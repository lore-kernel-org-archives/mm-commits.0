From: akpm@linux-foundation.org
Subject: + mm-kasan-use-kasan_zero_pud-for-p4d-table.patch added to -mm
 tree
Date: Mon, 15 May 2017 14:57:37 -0700
Message-ID: <591a2451.26AARFsd569lVK8m%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49372 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751437AbdEOV5n (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 15 May 2017 17:57:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, aryabinin@virtuozzo.com, dvyukov@google.com, glider@google.com, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/kasan/kasan_init.c: use kasan_zero_pud for p4d table
has been added to the -mm tree.  Its filename is
     mm-kasan-use-kasan_zero_pud-for-p4d-table.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-kasan-use-kasan_zero_pud-for-p4d-table.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-kasan-use-kasan_zero_pud-for-p4d-table.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/kasan/kasan_init.c: use kasan_zero_pud for p4d table

There is missing optimization in zero_p4d_populate() that can save some
memory when mapping zero shadow.  Implement it like as others.

Link: http://lkml.kernel.org/r/1494829255-23946-1-git-send-email-iamjoonsoo.kim@lge.com
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan_init.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff -puN mm/kasan/kasan_init.c~mm-kasan-use-kasan_zero_pud-for-p4d-table mm/kasan/kasan_init.c
--- a/mm/kasan/kasan_init.c~mm-kasan-use-kasan_zero_pud-for-p4d-table
+++ a/mm/kasan/kasan_init.c
@@ -118,6 +118,18 @@ static void __init zero_p4d_populate(pgd
 
 	do {
 		next = p4d_addr_end(addr, end);
+		if (IS_ALIGNED(addr, P4D_SIZE) && end - addr >= P4D_SIZE) {
+			pud_t *pud;
+			pmd_t *pmd;
+
+			p4d_populate(&init_mm, p4d, lm_alias(kasan_zero_pud));
+			pud = pud_offset(p4d, addr);
+			pud_populate(&init_mm, pud, lm_alias(kasan_zero_pmd));
+			pmd = pmd_offset(pud, addr);
+			pmd_populate_kernel(&init_mm, pmd,
+						lm_alias(kasan_zero_pte));
+			continue;
+		}
 
 		if (p4d_none(*p4d)) {
 			p4d_populate(&init_mm, p4d,
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

zram-introduce-zram_entry-to-prepare-dedup-functionality.patch
zram-implement-deduplication-in-zram.patch
zram-make-deduplication-feature-optional.patch
zram-compare-all-the-entries-with-same-checksum-for-deduplication.patch
mm-kasan-use-kasan_zero_pud-for-p4d-table.patch

