From: akpm@linux-foundation.org
Subject: [merged]
 mm-selftests-test-return-value-of-munmap-for-map_hugetlb-memory.patch
 removed from -mm tree
Date: Thu, 16 Apr 2015 09:52:28 -0700
Message-ID: <552fe8cc.Y6ic4qXu9Wjk9lbc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42787 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223AbbDPQrA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 12:47:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, aarcange@redhat.com, corbet@lwn.net, davidel@xmailserver.org, emunson@akamai.com, hughd@google.com, joern@logfs.org, lcapitulino@redhat.com, mpe@ellerman.id.au, shuahkh@osg.samsung.com, wujianguo@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, selftests: test return value of munmap for MAP_HUGETLB memory
has been removed from the -mm tree.  Its filename was
     mm-selftests-test-return-value-of-munmap-for-map_hugetlb-memory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, selftests: test return value of munmap for MAP_HUGETLB memory

When MAP_HUGETLB memory is unmapped, the length must be hugepage aligned,
otherwise it fails with -EINVAL.

All tests currently behave correctly, but it's better to explcitly test
the return value for completeness and document the requirement, especially
if users copy map_hugetlb.c as a sample implementation.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Davide Libenzi <davidel@xmailserver.org>
Cc: Luiz Capitulino <lcapitulino@redhat.com>
Cc: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Joern Engel <joern@logfs.org>
Cc: Jianguo Wu <wujianguo@huawei.com>
Cc: Eric B Munson <emunson@akamai.com>
Acked-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/powerpc/mm/hugetlb_vs_thp_test.c |    8 ++++++--
 tools/testing/selftests/vm/hugetlbfstest.c               |    4 +++-
 tools/testing/selftests/vm/map_hugetlb.c                 |    6 +++++-
 3 files changed, 14 insertions(+), 4 deletions(-)

diff -puN tools/testing/selftests/powerpc/mm/hugetlb_vs_thp_test.c~mm-selftests-test-return-value-of-munmap-for-map_hugetlb-memory tools/testing/selftests/powerpc/mm/hugetlb_vs_thp_test.c
--- a/tools/testing/selftests/powerpc/mm/hugetlb_vs_thp_test.c~mm-selftests-test-return-value-of-munmap-for-map_hugetlb-memory
+++ a/tools/testing/selftests/powerpc/mm/hugetlb_vs_thp_test.c
@@ -21,9 +21,13 @@ static int test_body(void)
 		 * Typically the mmap will fail because no huge pages are
 		 * allocated on the system. But if there are huge pages
 		 * allocated the mmap will succeed. That's fine too, we just
-		 * munmap here before continuing.
+		 * munmap here before continuing.  munmap() length of
+		 * MAP_HUGETLB memory must be hugepage aligned.
 		 */
-		munmap(addr, SIZE);
+		if (munmap(addr, SIZE)) {
+			perror("munmap");
+			return 1;
+		}
 	}
 
 	p = mmap(addr, SIZE, PROT_READ | PROT_WRITE,
diff -puN tools/testing/selftests/vm/hugetlbfstest.c~mm-selftests-test-return-value-of-munmap-for-map_hugetlb-memory tools/testing/selftests/vm/hugetlbfstest.c
--- a/tools/testing/selftests/vm/hugetlbfstest.c~mm-selftests-test-return-value-of-munmap-for-map_hugetlb-memory
+++ a/tools/testing/selftests/vm/hugetlbfstest.c
@@ -34,6 +34,7 @@ static void do_mmap(int fd, int extra_fl
 	int *p;
 	int flags = MAP_PRIVATE | MAP_POPULATE | extra_flags;
 	u64 before, after;
+	int ret;
 
 	before = read_rss();
 	p = mmap(NULL, length, PROT_READ | PROT_WRITE, flags, fd, 0);
@@ -44,7 +45,8 @@ static void do_mmap(int fd, int extra_fl
 			!"rss didn't grow as expected");
 	if (!unmap)
 		return;
-	munmap(p, length);
+	ret = munmap(p, length);
+	assert(!ret || !"munmap returned an unexpected error");
 	after = read_rss();
 	assert(llabs(after - before) < 0x40000 ||
 			!"rss didn't shrink as expected");
diff -puN tools/testing/selftests/vm/map_hugetlb.c~mm-selftests-test-return-value-of-munmap-for-map_hugetlb-memory tools/testing/selftests/vm/map_hugetlb.c
--- a/tools/testing/selftests/vm/map_hugetlb.c~mm-selftests-test-return-value-of-munmap-for-map_hugetlb-memory
+++ a/tools/testing/selftests/vm/map_hugetlb.c
@@ -73,7 +73,11 @@ int main(void)
 	write_bytes(addr);
 	ret = read_bytes(addr);
 
-	munmap(addr, LENGTH);
+	/* munmap() length of MAP_HUGETLB memory must be hugepage aligned */
+	if (munmap(addr, LENGTH)) {
+		perror("munmap");
+		exit(1);
+	}
 
 	return ret;
 }
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
jbd2-revert-must-not-fail-allocation-loops-back-to-gfp_nofail.patch
slab-infrastructure-for-bulk-object-allocation-and-freeing-v3.patch
slub-bulk-alloc-extract-objects-from-the-per-cpu-slab.patch
slub-bulk-allocation-from-per-cpu-partial-pages.patch
slub-bulk-allocation-from-per-cpu-partial-pages-fix.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
mm-utilc-add-kstrimdup.patch
linux-next.patch
cxgb4-drop-__gfp_nofail-allocation.patch

