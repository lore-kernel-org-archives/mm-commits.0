From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-soft-offline-exit-with-failure-for-non-anonymous-thp-fix.patch removed
 from -mm tree
Date: Fri, 15 Jan 2016 16:34:32 -0800
Message-ID: <56999018.thgKqQTVBBjvxN+f%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38092 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161319AbcAPAed (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jan 2016 19:34:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andi@firstfloor.org, kirill@shutemov.name, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-soft-offline-exit-with-failure-for-non-anonymous-thp-fix
has been removed from the -mm tree.  Its filename was
     mm-soft-offline-exit-with-failure-for-non-anonymous-thp-fix.patch

This patch was dropped because it was folded into mm-soft-offline-exit-with-failure-for-non-anonymous-thp.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-soft-offline-exit-with-failure-for-non-anonymous-thp-fix

fix build

Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/memory-failure.c~mm-soft-offline-exit-with-failure-for-non-anonymous-thp-fix mm/memory-failure.c
--- a/mm/memory-failure.c~mm-soft-offline-exit-with-failure-for-non-anonymous-thp-fix
+++ a/mm/memory-failure.c
@@ -1694,9 +1694,9 @@ static int soft_offline_in_use_page(stru
 		if (!PageAnon(hpage) || unlikely(split_huge_page(hpage))) {
 			unlock_page(hpage);
 			if (!PageAnon(hpage))
-				pr_info("soft offline: %#lx: non anonymous thp\n", pfn);
+				pr_info("soft offline: %#lx: non anonymous thp\n", page_to_pfn(page));
 			else
-				pr_info("soft offline: %#lx: thp split failed\n", pfn);
+				pr_info("soft offline: %#lx: thp split failed\n", page_to_pfn(page));
 			put_hwpoison_page(hpage);
 			return -EBUSY;
 		}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-define-madv_free-for-some-arches.patch
arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures.patch
mm-soft-offline-exit-with-failure-for-non-anonymous-thp.patch
kernel-stop_machinec-remove-config_smp-dependencies.patch
kernel-stop_machinec-remove-config_smp-dependencies-fix.patch
lib-vsprintfc-expand-field_width-to-24-bits-fix.patch
lib-test_printfc-test-dentry-printing-fix.patch
printk-help-pr_debug-and-pr_devel-to-optimize-out-arguments-fix.patch

