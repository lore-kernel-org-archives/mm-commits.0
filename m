From: akpm@linux-foundation.org
Subject: [patch 063/115] mm/kasan/kasan_init.c: use kasan_zero_pud
 for p4d table
Date: Mon, 10 Jul 2017 15:50:21 -0700
Message-ID: <20170710225021.0voHottsv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43044 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754910AbdGJWuW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jul 2017 18:50:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aryabinin@virtuozzo.com, dvyukov@google.com, glider@google.com, iamjoonsoo.kim@lge.com, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
