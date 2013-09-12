From: akpm@linux-foundation.org
Subject: [merged]
 mm-hwpoisonc-fix-held-reference-count-after-unpoisoning-empty-zero-page.patch removed from -mm tree
Date: Thu, 12 Sep 2013 12:45:35 -0700
Message-ID: <523219df.MVwQNhd+cMv/1Hlu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58606 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756260Ab3ILTpg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:45:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, andi@firstfloor.org, liwanp@linux.vnet.ibm.com

Subject: [merged] mm-hwpoisonc-fix-held-reference-count-after-unpoisoning-empty-zero-page.patch removed from -mm tree
To: liwanp@linux.vnet.ibm.com,andi@firstfloor.org,n-horiguchi@ah.jp.nec.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:45:35 -0700


The patch titled
     Subject: mm/hwpoison.c: fix held reference count after unpoisoning empty zero page
has been removed from the -mm tree.  Its filename was
     mm-hwpoisonc-fix-held-reference-count-after-unpoisoning-empty-zero-page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: mm/hwpoison.c: fix held reference count after unpoisoning empty zero page

madvise hwpoison inject will poison the read-only empty zero page if there
is no write access before poison.  Empty zero page reference count will be
increased for hwpoison, subsequent poison zero page will return directly
since page has already been set PG_hwpoison, however, page reference count
is still increased by get_user_pages_fast.  The unpoison process will
unpoison the empty zero page and decrease the reference count successfully
for the fist time, however, subsequent unpoison empty zero page will
return directly since page has already been unpoisoned and without
decrease the page reference count of empty zero page.

This patch fixes it by make madvise_hwpoison() put a page and return
immediately (without calling memory_failure() or soft_offline_page()) when
the page is already hwpoisoned.

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
#define PAGE_SIZE	4096

int main(void)
{
	char *mem;
	int i;

	mem = mmap(NULL, PAGES_TO_TEST * PAGE_SIZE,
			PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, 0, 0);

	if (madvise(mem, PAGES_TO_TEST * PAGE_SIZE, MADV_HWPOISON) == -1)
		return -1;

	munmap(mem, PAGES_TO_TEST * PAGE_SIZE);

	return 0;
}

Add printk to dump page reference count:

[   93.075959] Injecting memory failure for page 0x19d0 at 0xb77d8000
[   93.076207] MCE 0x19d0: non LRU page recovery: Ignored
[   93.076209] pfn 0x19d0, page count = 1 after memory failure
[   93.076220] Injecting memory failure for page 0x19d0 at 0xb77d9000
[   93.076221] MCE 0x19d0: already hardware poisoned
[   93.076222] pfn 0x19d0, page count = 2 after memory failure
[   93.076224] Injecting memory failure for page 0x19d0 at 0xb77da000
[   93.076224] MCE 0x19d0: already hardware poisoned
[   93.076225] pfn 0x19d0, page count = 3 after memory failure

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Suggested-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN mm/madvise.c~mm-hwpoisonc-fix-held-reference-count-after-unpoisoning-empty-zero-page mm/madvise.c
--- a/mm/madvise.c~mm-hwpoisonc-fix-held-reference-count-after-unpoisoning-empty-zero-page
+++ a/mm/madvise.c
@@ -352,6 +352,10 @@ static int madvise_hwpoison(int bhv, uns
 		int ret = get_user_pages_fast(start, 1, 0, &p);
 		if (ret != 1)
 			return ret;
+		if (PageHWPoison(p)) {
+			put_page(p);
+			continue;
+		}
 		if (bhv == MADV_SOFT_OFFLINE) {
 			pr_info("Soft offlining page %#lx at %#lx\n",
 				page_to_pfn(p), start);
_

Patches currently in -mm which might be from liwanp@linux.vnet.ibm.com are

origin.patch
mm-drop-actor-argument-of-do_generic_file_read.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch

