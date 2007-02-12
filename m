From: akpm@linux-foundation.org
Subject: - w1-use-array_size-macro-when-appropriate.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:43:41 -0800
Message-ID: <200702122243.l1CMhf3P013520@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44893 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030249AbXBLWnv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:43:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: darwish.07@gmail.com, johnpol@2ka.mipt.ru, mm-commits@vger.kernel.org


The patch titled
     w1: Use ARRAY_SIZE macro when appropriate
has been removed from the -mm tree.  Its filename was
     w1-use-array_size-macro-when-appropriate.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: w1: Use ARRAY_SIZE macro when appropriate
From: "Ahmed S. Darwish" <darwish.07@gmail.com>

A patch to use ARRAY_SIZE macro already defined in kernel.h

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
Acked-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/slaves/w1_therm.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/w1/slaves/w1_therm.c~w1-use-array_size-macro-when-appropriate drivers/w1/slaves/w1_therm.c
--- a/drivers/w1/slaves/w1_therm.c~w1-use-array_size-macro-when-appropriate
+++ a/drivers/w1/slaves/w1_therm.c
@@ -141,7 +141,7 @@ static inline int w1_convert_temp(u8 rom
 {
 	int i;
 
-	for (i=0; i<sizeof(w1_therm_families)/sizeof(w1_therm_families[0]); ++i)
+	for (i = 0; i < ARRAY_SIZE(w1_therm_families); ++i)
 		if (w1_therm_families[i].f->fid == fid)
 			return w1_therm_families[i].convert(rom);
 
@@ -238,7 +238,7 @@ static int __init w1_therm_init(void)
 {
 	int err, i;
 
-	for (i=0; i<sizeof(w1_therm_families)/sizeof(w1_therm_families[0]); ++i) {
+	for (i = 0; i < ARRAY_SIZE(w1_therm_families); ++i) {
 		err = w1_register_family(w1_therm_families[i].f);
 		if (err)
 			w1_therm_families[i].broken = 1;
@@ -251,7 +251,7 @@ static void __exit w1_therm_fini(void)
 {
 	int i;
 
-	for (i=0; i<sizeof(w1_therm_families)/sizeof(w1_therm_families[0]); ++i)
+	for (i = 0; i < ARRAY_SIZE(w1_therm_families); ++i)
 		if (!w1_therm_families[i].broken)
 			w1_unregister_family(w1_therm_families[i].f);
 }
_

Patches currently in -mm which might be from darwish.07@gmail.com are

origin.patch
git-acpi.patch
git-agpgart.patch
git-arm.patch
git-avr32.patch
git-drm.patch
git-dvb.patch
git-infiniband.patch
git-mips.patch
atm-use-array_size-macro-when-appropriate.patch
s390-kmalloc-kzalloc-casting-cleanups.patch
rcutorture-use-array_size-macro-when-appropriate.patch
drivers-mdc-use-array_size-macro-when-appropriate.patch
