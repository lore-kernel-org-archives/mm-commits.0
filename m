Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE532352009
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622866; cv=none; b=FyDmlZqMddQSnYfdgN9SPF4hghonHAQDsyClIN3BqF83TlqJra8CH0JOzYR+tWBxKmsUa3xvPbn184JNK5T/MPoFgXg8TxpeFSaB35kUWURi677M4etYRunut05V4YpMtYlb57ucKl2pYSAu7BECNlqMefNWYjzyNfipN6kt9LI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622866; c=relaxed/simple;
	bh=kX/73V54SYZ8WSPX6vvlRc1iRXel5bNkWrbKhXmei0Q=;
	h=Date:To:From:Subject:Message-Id; b=Fke5WZNka4DXHXBCWHNFXILSOCJqR9UP7/i1ZeBwmNSRB6HH7ivSAU7E/klOa+XK13ga/+OXFPmiWCFzBjVlbHNfXUGHd73pPOG7HzcInT0gIxPcslROSNuAAC3Uo4QlF/rMbMOrFwLiVheO3sEifr+Y6eTafNqV2aClt7BQP4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=f/gj+inU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="f/gj+inU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 865A71F00A3D;
	Tue, 25 Aug 2026 01:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622864;
	bh=nE+D4XJqkK9OmEtPbBJ6lQ7sfx+vlg38d3SN17sPa8A=;
	h=Date:To:From:Subject;
	b=f/gj+inUCFAjAa7J69Vv6q9IbF0d0nJ/SvCiPqDUi4ySLJoy8e6O4eKu7vv/80RPT
	 QIcxwrrN2LNI17V9m8YbFnf3fsK7nGGqS6bvKPxHpLwxYe/UF09t1gmSnS+hA9zF0O
	 d2tMWhG7tpHSnfpJb7ARcO4yoVZLI/CpljEss0XI=
Date: Mon, 24 Aug 2026 18:54:24 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,usama.arif@linux.dev,surenb@google.com,shuah@kernel.org,sarthak.sharma@arm.com,ryan.roberts@arm.com,rppt@kernel.org,npache@redhat.com,nao.horiguchi@gmail.com,mhocko@suse.com,ljs@kernel.org,linmiaohe@huawei.com,liam@infradead.org,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,usama.anjum@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-skip-hard-dirty-page-cache-test-on-nfs.patch removed from -mm tree
Message-Id: <20260825015424.865A71F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: skip hard dirty page-cache test on NFS
has been removed from the -mm tree.  Its filename was
     selftests-mm-skip-hard-dirty-page-cache-test-on-nfs.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


