From: akpm@linux-foundation.org
Subject: [merged] mm-madvisec-madvise_hwpoison-remove-local-ret.patch
 removed from -mm tree
Date: Thu, 12 Sep 2013 12:45:43 -0700
Message-ID: <523219e7.y9+3iJO2iEiPinpk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58622 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756295Ab3ILTpo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:45:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, liwanp@linux.vnet.ibm.com, andi@firstfloor.org, akpm@linux-foundation.org

Subject: [merged] mm-madvisec-madvise_hwpoison-remove-local-ret.patch removed from -mm tree
To: akpm@linux-foundation.org,andi@firstfloor.org,liwanp@linux.vnet.ibm.com,n-horiguchi@ah.jp.nec.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:45:43 -0700


The patch titled
     Subject: mm/madvise.c:madvise_hwpoison(): remove local `ret'
has been removed from the -mm tree.  Its filename was
     mm-madvisec-madvise_hwpoison-remove-local-ret.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/madvise.c:madvise_hwpoison(): remove local `ret'

madvise_hwpoison() has two locals called "ret".  Fix it all up.

Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN mm/madvise.c~mm-madvisec-madvise_hwpoison-remove-local-ret mm/madvise.c
--- a/mm/madvise.c~mm-madvisec-madvise_hwpoison-remove-local-ret
+++ a/mm/madvise.c
@@ -343,15 +343,16 @@ static long madvise_remove(struct vm_are
  */
 static int madvise_hwpoison(int bhv, unsigned long start, unsigned long end)
 {
-	int ret = 0;
-
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 	for (; start < end; start += PAGE_SIZE) {
 		struct page *p;
-		int ret = get_user_pages_fast(start, 1, 0, &p);
+		int ret;
+
+		ret = get_user_pages_fast(start, 1, 0, &p);
 		if (ret != 1)
 			return ret;
+
 		if (PageHWPoison(p)) {
 			put_page(p);
 			continue;
@@ -369,7 +370,7 @@ static int madvise_hwpoison(int bhv, uns
 		/* Ignore return value for now */
 		memory_failure(page_to_pfn(p), 0, MF_COUNT_INCREASED);
 	}
-	return ret;
+	return 0;
 }
 #endif
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
drivers-staging-lustre-lustre-ptlrpc-sec_bulkc-rename-ptrs_per_page.patch
makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default-fix.patch
mm.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
fat-additions-to-support-fat_fallocate-fix-fix.patch
memcg-trivial-cleanups.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

