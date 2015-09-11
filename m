From: akpm@linux-foundation.org
Subject: + mm-kasan-prevent-deadlock-in-kasan-reporting.patch added to -mm tree
Date: Fri, 11 Sep 2015 14:27:13 -0700
Message-ID: <55f34731.aDtpggh+at4rurBH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45411 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753599AbbIKV1O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Sep 2015 17:27:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, ryabinin.a.a@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/kasan: prevent deadlock in kasan reporting
has been added to the -mm tree.  Its filename is
     mm-kasan-prevent-deadlock-in-kasan-reporting.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-kasan-prevent-deadlock-in-kasan-reporting.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-kasan-prevent-deadlock-in-kasan-reporting.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: mm/kasan: prevent deadlock in kasan reporting

When we end up calling kasan_report in real mode, our shadow mapping for
the spinlock variable will show poisoned.  This will result in us calling
kasan_report_error with lock_report spin lock held.  To prevent this
disable kasan reporting when we are priting error w.r.t kasan.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Reviewed-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/report.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff -puN mm/kasan/report.c~mm-kasan-prevent-deadlock-in-kasan-reporting mm/kasan/report.c
--- a/mm/kasan/report.c~mm-kasan-prevent-deadlock-in-kasan-reporting
+++ a/mm/kasan/report.c
@@ -173,12 +173,10 @@ static void print_shadow_for_address(con
 		 * function, because generic functions may try to
 		 * access kasan mapping for the passed address.
 		 */
-		kasan_disable_current();
 		memcpy(shadow_buf, shadow_row, SHADOW_BYTES_PER_ROW);
 		print_hex_dump(KERN_ERR, buffer,
 			DUMP_PREFIX_NONE, SHADOW_BYTES_PER_ROW, 1,
 			shadow_buf, SHADOW_BYTES_PER_ROW, 0);
-		kasan_enable_current();
 
 		if (row_is_guilty(shadow_row, shadow))
 			pr_err("%*c\n",
@@ -195,6 +193,10 @@ void kasan_report_error(struct kasan_acc
 {
 	unsigned long flags;
 
+	/*
+	 * Make sure we don't end up in loop.
+	 */
+	kasan_disable_current();
 	spin_lock_irqsave(&report_lock, flags);
 	pr_err("================================="
 		"=================================\n");
@@ -204,12 +206,17 @@ void kasan_report_error(struct kasan_acc
 	pr_err("================================="
 		"=================================\n");
 	spin_unlock_irqrestore(&report_lock, flags);
+	kasan_enable_current();
 }
 
 void kasan_report_user_access(struct kasan_access_info *info)
 {
 	unsigned long flags;
 
+	/*
+	 * Make sure we don't end up in loop.
+	 */
+	kasan_disable_current();
 	spin_lock_irqsave(&report_lock, flags);
 	pr_err("================================="
 		"=================================\n");
@@ -222,6 +229,7 @@ void kasan_report_user_access(struct kas
 	pr_err("================================="
 		"=================================\n");
 	spin_unlock_irqrestore(&report_lock, flags);
+	kasan_enable_current();
 }
 
 void kasan_report(unsigned long addr, size_t size,
_

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

mm-kasan-rename-kasan_enabled-to-kasan_report_enabled.patch
mm-kasan-module_vaddr-is-not-available-on-all-archs.patch
mm-kasan-dont-use-kasan-shadow-pointer-in-generic-functions.patch
mm-kasan-prevent-deadlock-in-kasan-reporting.patch

