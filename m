From: akpm@linux-foundation.org
Subject: [merged] mmap-allow-map_hugetlb-for-hugetlbfs-files-v2.patch
 removed from -mm tree
Date: Tue, 09 Jul 2013 16:20:31 -0700
Message-ID: <51dc9abf.VEQd+DVfOBOEise+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38926 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753613Ab3GIXUb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 19:20:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, wujianguo@huawei.com, joern@logfs.org

Subject: [merged] mmap-allow-map_hugetlb-for-hugetlbfs-files-v2.patch removed from -mm tree
To: joern@logfs.org,wujianguo@huawei.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 16:20:31 -0700


The patch titled
     Subject: mmap: allow MAP_HUGETLB for hugetlbfs files v2
has been removed from the -mm tree.  Its filename was
     mmap-allow-map_hugetlb-for-hugetlbfs-files-v2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

