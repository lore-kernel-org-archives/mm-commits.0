From: akpm@linux-foundation.org
Subject: + mmap-allow-map_hugetlb-for-hugetlbfs-files-v2.patch added to
 -mm tree
Date: Fri, 28 Jun 2013 15:03:30 -0700
Message-ID: <51ce0832.RCx5MHRDSakWdqAn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51997 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571Ab3F1WDb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 28 Jun 2013 18:03:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, wujianguo@huawei.com, joern@logfs.org

Subject: + mmap-allow-map_hugetlb-for-hugetlbfs-files-v2.patch added to -mm tree
To: joern@logfs.org,wujianguo@huawei.com
From: akpm@linux-foundation.org
Date: Fri, 28 Jun 2013 15:03:30 -0700


The patch titled
     Subject: mmap: allow MAP_HUGETLB for hugetlbfs files v2
has been added to the -mm tree.  Its filename is
     mmap-allow-map_hugetlb-for-hugetlbfs-files-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: mmap: allow MAP_HUGETLB for hugetlbfs files v2

It is counterintuitive at best that mmap'ing a hugetlbfs file with
MAP_HUGETLB fails, while mmap'ing it without will a) succeed and b)
return huge pages.
v2: use is_file_hugepages(), as suggested by Jianguo

Signed-off-by: Joern Engel <joern@logfs.org>
Cc: Jianguo Wu <wujianguo@huawei.com>
---
 1 file changed, 4 insertions(+), 2 deletions(-)

index 2a594246..cdc8e7a 100644
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN mm/mmap.c~mmap-allow-map_hugetlb-for-hugetlbfs-files-v2 mm/mmap.c
--- a/mm/mmap.c~mmap-allow-map_hugetlb-for-hugetlbfs-files-v2
+++ a/mm/mmap.c
@@ -1358,13 +1358,14 @@ SYSCALL_DEFINE6(mmap_pgoff, unsigned lon
 
 	if (!(flags & MAP_ANONYMOUS)) {
 		audit_mmap_fd(fd, flags);
-		if (unlikely(flags & MAP_HUGETLB))
-			return -EINVAL;
 		file = fget(fd);
 		if (!file)
 			goto out;
 		if (is_file_hugepages(file))
 			len = ALIGN(len, huge_page_size(hstate_file(file)));
+		retval = -EINVAL;
+		if (unlikely(flags & MAP_HUGETLB && !is_file_hugepages(file)))
+			goto out_fput;
 	} else if (flags & MAP_HUGETLB) {
 		struct user_struct *user = NULL;
 		struct hstate *hs = hstate_sizelog((flags >> MAP_HUGE_SHIFT) &
@@ -1391,6 +1392,7 @@ SYSCALL_DEFINE6(mmap_pgoff, unsigned lon
 	flags &= ~(MAP_EXECUTABLE | MAP_DENYWRITE);
 
 	retval = vm_mmap_pgoff(file, addr, len, prot, flags, pgoff);
+out_fput:
 	if (file)
 		fput(file);
 out:
_

Patches currently in -mm which might be from joern@logfs.org are

linux-next.patch
hugetlb-properly-account-rss.patch
mmap-allow-map_hugetlb-for-hugetlbfs-files-v2.patch
nilfs2-implement-calculation-of-free-inodes-count.patch
nilfs2-use-atomic64_t-type-for-inodes_count-and-blocks_count-fields-in-nilfs_root-struct.patch
selftests-exit-1-on-failure.patch
self-test-fix-make-clean.patch
selftests-add-hugetlbfstest.patch

