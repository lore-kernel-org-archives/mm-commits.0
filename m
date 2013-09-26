From: akpm@linux-foundation.org
Subject: +
 mm-hwpoison-fix-traverse-hugetlbfs-page-to-avoid-printk-flood.patch added
 to -mm tree
Date: Thu, 26 Sep 2013 11:54:42 -0700
Message-ID: <524482f2.JaczmkAl9sKhy4AJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60162 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754549Ab3IZSyn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 Sep 2013 14:54:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, ak@linux.intel.com, liwanp@linux.vnet.ibm.com

Subject: + mm-hwpoison-fix-traverse-hugetlbfs-page-to-avoid-printk-flood.patch added to -mm tree
To: liwanp@linux.vnet.ibm.com,ak@linux.intel.com,n-horiguchi@ah.jp.nec.com
From: akpm@linux-foundation.org
Date: Thu, 26 Sep 2013 11:54:42 -0700


The patch titled
     Subject: mm/hwpoison: fix traversal of hugetlbfs pages to avoid printk flood
has been added to the -mm tree.  Its filename is
     mm-hwpoison-fix-traverse-hugetlbfs-page-to-avoid-printk-flood.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hwpoison-fix-traverse-hugetlbfs-page-to-avoid-printk-flood.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hwpoison-fix-traverse-hugetlbfs-page-to-avoid-printk-flood.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: mm/hwpoison: fix traversal of hugetlbfs pages to avoid printk flood

madvise_hwpoison won't check if the page is small page or huge page and
traverses in small page granularity against the range unconditionally,
which result in a printk flood "MCE xxx: already hardware poisoned" if the
page is a huge page.  This patch fixes it by using
compound_order(compound_head(page)) for huge page iterator.

Testcase:

#define _GNU_SOURCE
#include <stdlib.h>
#include <stdio.h>
#include <sys/mman.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/types.h>
#include <errno.h>

#define PAGES_TO_TEST 3
#define PAGE_SIZE	4096 * 512

int main(void)
{
	char *mem;
	int i;

	mem = mmap(NULL, PAGES_TO_TEST * PAGE_SIZE,
			PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB, 0, 0);

	if (madvise(mem, PAGES_TO_TEST * PAGE_SIZE, MADV_HWPOISON) == -1)
		return -1;

	munmap(mem, PAGES_TO_TEST * PAGE_SIZE);

	return 0;
}

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/madvise.c~mm-hwpoison-fix-traverse-hugetlbfs-page-to-avoid-printk-flood mm/madvise.c
--- a/mm/madvise.c~mm-hwpoison-fix-traverse-hugetlbfs-page-to-avoid-printk-flood
+++ a/mm/madvise.c
@@ -343,10 +343,11 @@ static long madvise_remove(struct vm_are
  */
 static int madvise_hwpoison(int bhv, unsigned long start, unsigned long end)
 {
+	struct page *p;
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
-	for (; start < end; start += PAGE_SIZE) {
-		struct page *p;
+	for (; start < end; start += PAGE_SIZE <<
+				compound_order(compound_head(p))) {
 		int ret;
 
 		ret = get_user_pages_fast(start, 1, 0, &p);
_

Patches currently in -mm which might be from liwanp@linux.vnet.ibm.com are

revert-mm-memory-hotplug-fix-lowmem-count-overflow-when-offline-pages.patch
mm-compactionc-periodically-schedule-when-freeing-pages.patch
mm-hwpoison-fix-traverse-hugetlbfs-page-to-avoid-printk-flood.patch
mm-hwpoison-fix-miss-catch-transparent-huge-page.patch
mm-hwpoison-fix-false-report-2nd-try-page-recovery.patch
mm-hwpoison-fix-the-lack-of-one-reference-count-against-poisoned-page.patch
ksm-remove-redundant-__gfp_zero-from-kcalloc.patch
mm-huge_memoryc-fix-stale-comments-of-transparent_hugepage_flags.patch
mm-memory-failurec-move-set_migratetype_isolate-outside-get_any_page.patch
mm-vmalloc-dont-set-area-caller-twice.patch
mm-vmalloc-fix-show-vmap_area-information-race-with-vmap_area-tear-down.patch
mm-vmalloc-revert-mm-vmallocc-check-vm_uninitialized-flag-in-s_show-instead-of-show_numa_info.patch
revert-mm-vmallocc-emit-the-failure-message-before-return.patch
memblock-factor-out-of-top-down-allocation.patch
memblock-introduce-bottom-up-allocation-mode.patch
x86-mm-factor-out-of-top-down-direct-mapping-setup.patch
x86-mem-hotplug-support-initialize-page-tables-in-bottom-up.patch
x86-acpi-crash-kdump-do-reserve_crashkernel-after-srat-is-parsed.patch
mem-hotplug-introduce-movablenode-boot-option.patch
mm-thp-cleanup-mv-alloc_hugepage-to-better-place.patch
mm-thp-khugepaged-add-policy-for-finding-target-node.patch
mm-drop-actor-argument-of-do_generic_file_read.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch

