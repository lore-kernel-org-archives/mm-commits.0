Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8328C2570
	for <mm-commits@vger.kernel.org>; Fri, 22 Mar 2024 00:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711068467; cv=none; b=InT4cjqk9jMv6l1MpjHMySUFoXCq4bSrBUgSlsNwGleVSBKeST3vCNnPy6du4IYxwmewGHXInk5No4glKaveilANIumY7IM6akYWrccy7Ebw8HWQjAeoOZCf3WUAFKiRA7j+DsklBq5OsFae+2WEm8gMIHa6Lj6+UlRbeAFVvTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711068467; c=relaxed/simple;
	bh=eulSk5/RxsWNVyZM0iC+QeARBkmkEwRLGCsTWciD7cg=;
	h=Date:To:From:Subject:Message-Id; b=bq9o10G/OvLCNmDc4MtKZwkNTQN2uR0nTFA88rexf5IACTixcf/6K4I4ftzGE5BlsxdQI4X5vzlfqXYzlKoyeaIIa5joaYEO0HF3MZbAn0qGc6rhJ98z4FB7lEb/H9m5A3n+szbt501S9HDZ2oiFB71fpq5KsJGWGZ4klz73PYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=g9J3WPsM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="g9J3WPsM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC84DC433C7;
	Fri, 22 Mar 2024 00:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711068467;
	bh=eulSk5/RxsWNVyZM0iC+QeARBkmkEwRLGCsTWciD7cg=;
	h=Date:To:From:Subject:From;
	b=g9J3WPsMH4vJUFhLXF4oR2R1f9cdOmyfigM++P3miiO+/h4ZcbysInBtRMKQSID/n
	 DvIVkzitMcJoA/i9IrJS65fK8m8DdNwrV3UbLfzYWTwJT7/yZ/puqtUYSJvijpQMUY
	 IMT3RJSfLk+yF3vwh1uzNU2tuE41hiVR3H4UHorg=
Date: Thu, 21 Mar 2024 17:47:46 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,rppt@kernel.org,peterx@redhat.com,ngeoffray@google.com,kaleshsingh@google.com,jannh@google.com,hdanton@sina.com,david@redhat.com,bgeffon@google.com,axelrasmussen@google.com,aarcange@redhat.com,lokeshgidra@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + userfaultfd-fix-deadlock-warning-when-locking-src-and-dst-vmas.patch added to mm-nonmm-unstable branch
Message-Id: <20240322004746.EC84DC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: userfaultfd: fix deadlock warning when locking src and dst VMAs
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     userfaultfd-fix-deadlock-warning-when-locking-src-and-dst-vmas.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/userfaultfd-fix-deadlock-warning-when-locking-src-and-dst-vmas.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Lokesh Gidra <lokeshgidra@google.com>
Subject: userfaultfd: fix deadlock warning when locking src and dst VMAs
Date: Thu, 21 Mar 2024 16:58:18 -0700

Use down_read_nested() to avoid the warning.

Link: https://lkml.kernel.org/r/20240321235818.125118-1-lokeshgidra@google.com
Fixes: 867a43a34ff8a ("userfaultfd: use per-vma locks in userfaultfd operations")
Reported-by: syzbot+49056626fe41e01f2ba7@syzkaller.appspotmail.com
Signed-off-by: Lokesh Gidra <lokeshgidra@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Brian Geffon <bgeffon@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Jann Horn <jannh@google.com> [Bug #2]
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Nicolas Geoffray <ngeoffray@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/userfaultfd.c~userfaultfd-fix-deadlock-warning-when-locking-src-and-dst-vmas
+++ a/mm/userfaultfd.c
@@ -1479,7 +1479,8 @@ static int uffd_move_lock(struct mm_stru
 		 */
 		down_read(&(*dst_vmap)->vm_lock->lock);
 		if (*dst_vmap != *src_vmap)
-			down_read(&(*src_vmap)->vm_lock->lock);
+			down_read_nested(&(*src_vmap)->vm_lock->lock,
+					 SINGLE_DEPTH_NESTING);
 	}
 	mmap_read_unlock(mm);
 	return err;
_

Patches currently in -mm which might be from lokeshgidra@google.com are

userfaultfd-fix-deadlock-warning-when-locking-src-and-dst-vmas.patch

