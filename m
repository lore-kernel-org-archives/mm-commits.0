Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE3023EFFCC
	for <mm-commits@vger.kernel.org>; Thu,  6 Aug 2026 21:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786050012; cv=none; b=lt/RQ3okXUK/Ns1kFIUE678zZvB9HzYo3mezE5oCvSZWVnAEJ9ii9hA6rlXzA9g+giAWfnC25aEN8B2gREm5Mbk52MyrxHsVtPCYFtjXfduEBf+ER80B8c767jRp/iT5Rtu5wnBqccbtueJ8MRGjeIVVtR5hUHMWMYUd31P5miM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786050012; c=relaxed/simple;
	bh=PMGZODo/GY3u+ujRdGBN5Pebjf8guq/oF8UekuIcwRU=;
	h=Date:To:From:Subject:Message-Id; b=RljtdLxzKVdg2yGOBmaXXMjjCjIUb59pDyUt9CTL5vA0wP6V5uI/AwMCKGF+2QBb74tz9HQzvaqLgddUXq4jbHxl7SLFSONsajyS89HSNCuvecGfPW0u30bpUK0325FO3urD0ZO1ys1a7eCWmTjrtl3uDtcXNni4qlZqUr//ZgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Fjy+CJzJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Fjy+CJzJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 110961F00A3D;
	Thu,  6 Aug 2026 21:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786050010;
	bh=y20CevV4vTJCWFiI6HoM7nAGZmdWLvF7R/Bsk3H3e1w=;
	h=Date:To:From:Subject;
	b=Fjy+CJzJEyqKM1nYYjIRcY5it6m6T27a3Z+9big56xcbwOQNq1fB7F1hiDdrwdZ+M
	 q3LeRcdrpAuGh8DQAJFq4RWENusolZbUw5M0gbOqF04yzGuM0HB3rXTT72WwfoGL9r
	 uWmpytwnGZ/yPCqqmU+MW13k4JdwkuVxfxno8zlo=
Date: Thu, 06 Aug 2026 14:00:09 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,usama.arif@linux.dev,surenb@google.com,shuah@kernel.org,sarthak.sharma@arm.com,ryan.roberts@arm.com,rppt@kernel.org,npache@redhat.com,nao.horiguchi@gmail.com,mhocko@suse.com,ljs@kernel.org,linmiaohe@huawei.com,liam@infradead.org,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,usama.anjum@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-skip-hard-dirty-page-cache-test-on-nfs.patch added to mm-new branch
Message-Id: <20260806210010.110961F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: skip hard dirty page-cache test on NFS
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-skip-hard-dirty-page-cache-test-on-nfs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-skip-hard-dirty-page-cache-test-on-nfs.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Subject: selftests/mm: skip hard dirty page-cache test on NFS
Date: Mon, 27 Jul 2026 10:52:20 +0100

The hard dirty_pagecache variant uses MADV_HWPOISON to exercise recovery
of a dirty file-backed page.  The recovery path records -EIO in the
address_space mapping, which NFS later reports when the test closes the
file.  This makes the test fail after the hwpoison checks have completed.

Skip this variant when the test file is on NFS.  Keep the hard clean-page
and both soft-offline variants enabled because they use folio removal,
invalidation, or migration rather than recording a delayed writeback
error.

The unsupported-filesystem path in clean_pagecache() also returns without
closing the opened test file.  Close the descriptor before skipping there
and in dirty_pagecache().

Link: https://lore.kernel.org/20260727095225.372655-5-usama.anjum@arm.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/memory-failure.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/memory-failure.c~selftests-mm-skip-hard-dirty-page-cache-test-on-nfs
+++ a/tools/testing/selftests/mm/memory-failure.c
@@ -287,8 +287,10 @@ TEST_F(memory_failure, clean_pagecache)
 	if (fd < 0)
 		SKIP(return, "failed to open test file.\n");
 	fs_type = get_fs_type(fd);
-	if (!fs_type || fs_type == TMPFS_MAGIC)
+	if (!fs_type || fs_type == TMPFS_MAGIC) {
+		close(fd);
 		SKIP(return, "unsupported filesystem :%x\n", fs_type);
+	}
 
 	addr = mmap(0, self->page_size, PROT_READ | PROT_WRITE,
 		    MAP_SHARED, fd, 0);
@@ -327,8 +329,16 @@ TEST_F(memory_failure, dirty_pagecache)
 	if (fd < 0)
 		SKIP(return, "failed to open test file.\n");
 	fs_type = get_fs_type(fd);
-	if (!fs_type || fs_type == TMPFS_MAGIC)
+	/*
+	 * MADV_HARD poisoning of dirty page-cache data records an expected
+	 * -EIO in the file mapping. NFS reports this error on close(), so
+	 * skip this variant.
+	 */
+	if (!fs_type || fs_type == TMPFS_MAGIC ||
+	    (fs_type == NFS_SUPER_MAGIC && variant->type == MADV_HARD)) {
+		close(fd);
 		SKIP(return, "unsupported filesystem :%x\n", fs_type);
+	}
 
 	addr = mmap(0, self->page_size, PROT_READ | PROT_WRITE,
 		    MAP_SHARED, fd, 0);
_

Patches currently in -mm which might be from usama.anjum@arm.com are

selftests-mm-unpoison-pages-in-memory-failure-teardown.patch
selftests-mm-skip-cow-tmpfile-cases-when-fallocate-is-unsupported.patch
selftests-mm-skip-guard-hole-punch-test-if-madv_remove-is-unsupported.patch
selftests-mm-skip-khugepaged-swap-tests-without-swap.patch
selftests-mm-skip-hard-dirty-page-cache-test-on-nfs.patch
selftests-mm-retry-migration-failures-for-the-full-runtime.patch

