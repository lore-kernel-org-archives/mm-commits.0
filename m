From: akpm@linux-foundation.org
Subject: [patch 103/111] w1: add helper macro module_w1_family
Date: Tue, 02 Aug 2016 14:07:09 -0700
Message-ID: <57a10b7d.139+YeO+srA5VDfa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60726 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754351AbcHBVXu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Aug 2016 17:23:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, afd@ti.com, greg@kroah.com, zbr@ioremap.net

From: "Andrew F. Davis" <afd@ti.com>
Subject: w1: add helper macro module_w1_family

The helper macro module_w1_family can be used in module drivers that only
register a w1 driver in their module init functions.  Add this macro and
use it in all applicable drivers.

Link: http://lkml.kernel.org/r/20160531204313.20979-2-afd@ti.com
Signed-off-by: Andrew F. Davis <afd@ti.com>
Acked-by: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/slaves/w1_ds2406.c  |   14 +-------------
 drivers/w1/slaves/w1_ds2408.c  |   14 +-------------
 drivers/w1/slaves/w1_ds2413.c  |   14 +-------------
 drivers/w1/slaves/w1_ds2423.c  |   14 +-------------
 drivers/w1/slaves/w1_ds2431.c  |   14 +-------------
 drivers/w1/slaves/w1_ds2433.c  |   14 +-------------
 drivers/w1/slaves/w1_ds2760.c  |   15 +--------------
 drivers/w1/slaves/w1_ds2780.c  |   14 +-------------
 drivers/w1/slaves/w1_ds2781.c  |   14 +-------------
 drivers/w1/slaves/w1_ds28e04.c |   14 +-------------
 drivers/w1/w1_family.h         |   12 ++++++++++++
 11 files changed, 22 insertions(+), 131 deletions(-)

diff -puN drivers/w1/slaves/w1_ds2406.c~w1-add-helper-macro-module_w1_family drivers/w1/slaves/w1_ds2406.c
--- a/drivers/w1/slaves/w1_ds2406.c~w1-add-helper-macro-module_w1_family
+++ a/drivers/w1/slaves/w1_ds2406.c
@@ -153,16 +153,4 @@ static struct w1_family w1_family_12 = {
 	.fid = W1_FAMILY_DS2406,
 	.fops = &w1_f12_fops,
 };
-
-static int __init w1_f12_init(void)
-{
-	return w1_register_family(&w1_family_12);
-}
-
-static void __exit w1_f12_exit(void)
-{
-	w1_unregister_family(&w1_family_12);
-}
-
-module_init(w1_f12_init);
-module_exit(w1_f12_exit);
+module_w1_family(w1_family_12);
diff -puN drivers/w1/slaves/w1_ds2408.c~w1-add-helper-macro-module_w1_family drivers/w1/slaves/w1_ds2408.c
--- a/drivers/w1/slaves/w1_ds2408.c~w1-add-helper-macro-module_w1_family
+++ a/drivers/w1/slaves/w1_ds2408.c
@@ -351,16 +351,4 @@ static struct w1_family w1_family_29 = {
 	.fid = W1_FAMILY_DS2408,
 	.fops = &w1_f29_fops,
 };
-
-static int __init w1_f29_init(void)
-{
-	return w1_register_family(&w1_family_29);
-}
-
-static void __exit w1_f29_exit(void)
-{
-	w1_unregister_family(&w1_family_29);
-}
-
-module_init(w1_f29_init);
-module_exit(w1_f29_exit);
+module_w1_family(w1_family_29);
diff -puN drivers/w1/slaves/w1_ds2413.c~w1-add-helper-macro-module_w1_family drivers/w1/slaves/w1_ds2413.c
--- a/drivers/w1/slaves/w1_ds2413.c~w1-add-helper-macro-module_w1_family
+++ a/drivers/w1/slaves/w1_ds2413.c
@@ -135,16 +135,4 @@ static struct w1_family w1_family_3a = {
 	.fid = W1_FAMILY_DS2413,
 	.fops = &w1_f3a_fops,
 };
-
-static int __init w1_f3a_init(void)
-{
-	return w1_register_family(&w1_family_3a);
-}
-
-static void __exit w1_f3a_exit(void)
-{
-	w1_unregister_family(&w1_family_3a);
-}
-
-module_init(w1_f3a_init);
-module_exit(w1_f3a_exit);
+module_w1_family(w1_family_3a);
diff -puN drivers/w1/slaves/w1_ds2423.c~w1-add-helper-macro-module_w1_family drivers/w1/slaves/w1_ds2423.c
--- a/drivers/w1/slaves/w1_ds2423.c~w1-add-helper-macro-module_w1_family
+++ a/drivers/w1/slaves/w1_ds2423.c
@@ -138,19 +138,7 @@ static struct w1_family w1_family_1d = {
 	.fid = W1_COUNTER_DS2423,
 	.fops = &w1_f1d_fops,
 };
-
-static int __init w1_f1d_init(void)
-{
-	return w1_register_family(&w1_family_1d);
-}
-
-static void __exit w1_f1d_exit(void)
-{
-	w1_unregister_family(&w1_family_1d);
-}
-
-module_init(w1_f1d_init);
-module_exit(w1_f1d_exit);
+module_w1_family(w1_family_1d);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mika Laitio <lamikr@pilppa.org>");
diff -puN drivers/w1/slaves/w1_ds2431.c~w1-add-helper-macro-module_w1_family drivers/w1/slaves/w1_ds2431.c
--- a/drivers/w1/slaves/w1_ds2431.c~w1-add-helper-macro-module_w1_family
+++ a/drivers/w1/slaves/w1_ds2431.c
@@ -288,19 +288,7 @@ static struct w1_family w1_family_2d = {
 	.fid = W1_EEPROM_DS2431,
 	.fops = &w1_f2d_fops,
 };
-
-static int __init w1_f2d_init(void)
-{
-	return w1_register_family(&w1_family_2d);
-}
-
-static void __exit w1_f2d_fini(void)
-{
-	w1_unregister_family(&w1_family_2d);
-}
-
-module_init(w1_f2d_init);
-module_exit(w1_f2d_fini);
+module_w1_family(w1_family_2d);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Bernhard Weirich <bernhard.weirich@riedel.net>");
diff -puN drivers/w1/slaves/w1_ds2433.c~w1-add-helper-macro-module_w1_family drivers/w1/slaves/w1_ds2433.c
--- a/drivers/w1/slaves/w1_ds2433.c~w1-add-helper-macro-module_w1_family
+++ a/drivers/w1/slaves/w1_ds2433.c
@@ -305,16 +305,4 @@ static struct w1_family w1_family_23 = {
 	.fid = W1_EEPROM_DS2433,
 	.fops = &w1_f23_fops,
 };
-
-static int __init w1_f23_init(void)
-{
-	return w1_register_family(&w1_family_23);
-}
-
-static void __exit w1_f23_fini(void)
-{
-	w1_unregister_family(&w1_family_23);
-}
-
-module_init(w1_f23_init);
-module_exit(w1_f23_fini);
+module_w1_family(w1_family_23);
diff -puN drivers/w1/slaves/w1_ds2760.c~w1-add-helper-macro-module_w1_family drivers/w1/slaves/w1_ds2760.c
--- a/drivers/w1/slaves/w1_ds2760.c~w1-add-helper-macro-module_w1_family
+++ a/drivers/w1/slaves/w1_ds2760.c
@@ -162,26 +162,13 @@ static struct w1_family w1_ds2760_family
 	.fid = W1_FAMILY_DS2760,
 	.fops = &w1_ds2760_fops,
 };
-
-static int __init w1_ds2760_init(void)
-{
-	pr_info("1-Wire driver for the DS2760 battery monitor chip - (c) 2004-2005, Szabolcs Gyurko\n");
-	return w1_register_family(&w1_ds2760_family);
-}
-
-static void __exit w1_ds2760_exit(void)
-{
-	w1_unregister_family(&w1_ds2760_family);
-}
+module_w1_family(w1_ds2760_family);
 
 EXPORT_SYMBOL(w1_ds2760_read);
 EXPORT_SYMBOL(w1_ds2760_write);
 EXPORT_SYMBOL(w1_ds2760_store_eeprom);
 EXPORT_SYMBOL(w1_ds2760_recall_eeprom);
 
-module_init(w1_ds2760_init);
-module_exit(w1_ds2760_exit);
-
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Szabolcs Gyurko <szabolcs.gyurko@tlt.hu>");
 MODULE_DESCRIPTION("1-wire Driver Dallas 2760 battery monitor chip");
diff -puN drivers/w1/slaves/w1_ds2780.c~w1-add-helper-macro-module_w1_family drivers/w1/slaves/w1_ds2780.c
--- a/drivers/w1/slaves/w1_ds2780.c~w1-add-helper-macro-module_w1_family
+++ a/drivers/w1/slaves/w1_ds2780.c
@@ -154,19 +154,7 @@ static struct w1_family w1_ds2780_family
 	.fid = W1_FAMILY_DS2780,
 	.fops = &w1_ds2780_fops,
 };
-
-static int __init w1_ds2780_init(void)
-{
-	return w1_register_family(&w1_ds2780_family);
-}
-
-static void __exit w1_ds2780_exit(void)
-{
-	w1_unregister_family(&w1_ds2780_family);
-}
-
-module_init(w1_ds2780_init);
-module_exit(w1_ds2780_exit);
+module_w1_family(w1_ds2780_family);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Clifton Barnes <cabarnes@indesign-llc.com>");
diff -puN drivers/w1/slaves/w1_ds2781.c~w1-add-helper-macro-module_w1_family drivers/w1/slaves/w1_ds2781.c
--- a/drivers/w1/slaves/w1_ds2781.c~w1-add-helper-macro-module_w1_family
+++ a/drivers/w1/slaves/w1_ds2781.c
@@ -151,19 +151,7 @@ static struct w1_family w1_ds2781_family
 	.fid = W1_FAMILY_DS2781,
 	.fops = &w1_ds2781_fops,
 };
-
-static int __init w1_ds2781_init(void)
-{
-	return w1_register_family(&w1_ds2781_family);
-}
-
-static void __exit w1_ds2781_exit(void)
-{
-	w1_unregister_family(&w1_ds2781_family);
-}
-
-module_init(w1_ds2781_init);
-module_exit(w1_ds2781_exit);
+module_w1_family(w1_ds2781_family);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Renata Sayakhova <renata@oktetlabs.ru>");
diff -puN drivers/w1/slaves/w1_ds28e04.c~w1-add-helper-macro-module_w1_family drivers/w1/slaves/w1_ds28e04.c
--- a/drivers/w1/slaves/w1_ds28e04.c~w1-add-helper-macro-module_w1_family
+++ a/drivers/w1/slaves/w1_ds28e04.c
@@ -427,16 +427,4 @@ static struct w1_family w1_family_1C = {
 	.fid = W1_FAMILY_DS28E04,
 	.fops = &w1_f1C_fops,
 };
-
-static int __init w1_f1C_init(void)
-{
-	return w1_register_family(&w1_family_1C);
-}
-
-static void __exit w1_f1C_fini(void)
-{
-	w1_unregister_family(&w1_family_1C);
-}
