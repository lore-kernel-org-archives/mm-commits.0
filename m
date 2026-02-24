Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE74B2FFF8F;
	Tue, 24 Feb 2026 19:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771960441; cv=none; b=GtzT3kVg4zmaToYPN5U+eWtz8wpWWvOlNyyoc5obyH/9o78cTKq3AgKr8bk6aqQvz4+NrPf5q72RXItFCf3W9znkGaHa19Fmo0qLW/hlfGsuZPAepl8iYTNpB1EZ+TN4I1OCem6Y5QDBzCr5fg6bQmtbeTBpAwOc+0BLtmmsOas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771960441; c=relaxed/simple;
	bh=VcylxH4Oefw8mmDP34gBy10Q/G3pskMGsfULM9edbaE=;
	h=Date:To:From:Subject:Message-Id; b=BmiJlI96fInb45jCoaddNFZ1u+YVFwy4NHs/Jl1ccaoJOoSOEbVgBGbyt7zhRYqBIkAt4NXNB6YStpmDVpGjU1yyCzYmzn0TACYGRMfqbqpVbEiGBD3qBVBSdhN2wmERGzji6l2tuyhA2JdyHUKv5Kr+Cy87puXwGvycGEOo/fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=01sHfdHl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="01sHfdHl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A198DC116D0;
	Tue, 24 Feb 2026 19:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771960440;
	bh=VcylxH4Oefw8mmDP34gBy10Q/G3pskMGsfULM9edbaE=;
	h=Date:To:From:Subject:From;
	b=01sHfdHlcydBnVQRdu2C3MITw/ik2EzUrmDL2T1uGrz8gJ8MT74h5BVDYqQmC3qD1
	 ZEu/e7O0n3IE85kRIEZHsLi5S/RXBMG52Lb5FefyYzyU2NPgXTCYnJE3CpM451hcVd
	 pPF6I3SPvpT2Jt3iG0zgjb2x9QT4c/p8KHhDZtjg=
Date: Tue, 24 Feb 2026 11:14:00 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,stable@vger.kernel.org,shy828301@gmail.com,ryan.roberts@arm.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,lance.yang@linux.dev,Kartikey406@gmail.com,i@maskray.me,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,ackerleytng@google.com,kartikey406@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-thp-deny-thp-for-files-on-anonymous-inodes.patch removed from -mm tree
Message-Id: <20260224191400.A198DC116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: thp: deny THP for files on anonymous inodes
has been removed from the -mm tree.  Its filename was
     mm-thp-deny-thp-for-files-on-anonymous-inodes.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Deepanshu Kartikey <kartikey406@gmail.com>
Subject: mm: thp: deny THP for files on anonymous inodes
Date: Sat, 14 Feb 2026 05:45:35 +0530

file_thp_enabled() incorrectly allows THP for files on anonymous inodes
(e.g. guest_memfd and secretmem). These files are created via
alloc_file_pseudo(), which does not call get_write_access() and leaves
inode->i_writecount at 0. Combined with S_ISREG(inode->i_mode) being
true, they appear as read-only regular files when
CONFIG_READ_ONLY_THP_FOR_FS is enabled, making them eligible for THP
collapse.

Anonymous inodes can never pass the inode_is_open_for_write() check
since their i_writecount is never incremented through the normal VFS
open path. The right thing to do is to exclude them from THP eligibility
altogether, since CONFIG_READ_ONLY_THP_FOR_FS was designed for real
filesystem files (e.g. shared libraries), not for pseudo-filesystem
inodes.

For guest_memfd, this allows khugepaged and MADV_COLLAPSE to create
large folios in the page cache via the collapse path, but the
guest_memfd fault handler does not support large folios. This triggers
WARN_ON_ONCE(folio_test_large(folio)) in kvm_gmem_fault_user_mapping().

For secretmem, collapse_file() tries to copy page contents through the
direct map, but secretmem pages are removed from the direct map. This
can result in a kernel crash:

    BUG: unable to handle page fault for address: ffff88810284d000
    RIP: 0010:memcpy_orig+0x16/0x130
    Call Trace:
     collapse_file
     hpage_collapse_scan_file
     madvise_collapse

Secretmem is not affected by the crash on upstream as the memory failure
recovery handles the failed copy gracefully, but it still triggers
confusing false memory failure reports:

    Memory failure: 0x106d96f: recovery action for clean unevictable
    LRU page: Recovered

Check IS_ANON_FILE(inode) in file_thp_enabled() to deny THP for all
anonymous inode files.

Link: https://syzkaller.appspot.com/bug?extid=33a04338019ac7e43a44
Link: https://lore.kernel.org/linux-mm/CAEvNRgHegcz3ro35ixkDw39ES8=U6rs6S7iP0gkR9enr7HoGtA@mail.gmail.com
Link: https://lkml.kernel.org/r/20260214001535.435626-1-kartikey406@gmail.com
Fixes: 7fbb5e188248 ("mm: remove VM_EXEC requirement for THP eligibility")
Signed-off-by: Deepanshu Kartikey <Kartikey406@gmail.com>
Reported-by: syzbot+33a04338019ac7e43a44@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=33a04338019ac7e43a44
Tested-by: syzbot+33a04338019ac7e43a44@syzkaller.appspotmail.com
Tested-by: Lance Yang <lance.yang@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Ackerley Tng <ackerleytng@google.com>
Tested-by: Ackerley Tng <ackerleytng@google.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Fangrui Song <i@maskray.me>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/huge_memory.c~mm-thp-deny-thp-for-files-on-anonymous-inodes
+++ a/mm/huge_memory.c
@@ -94,6 +94,9 @@ static inline bool file_thp_enabled(stru
 
 	inode = file_inode(vma->vm_file);
 
+	if (IS_ANON_FILE(inode))
+		return false;
+
 	return !inode_is_open_for_write(inode) && S_ISREG(inode->i_mode);
 }
 
_

Patches currently in -mm which might be from kartikey406@gmail.com are


