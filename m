From: akpm@linux-foundation.org
Subject: + w1-use-array_size-macro-when-appropriate.patch added to -mm tree
Date: Tue, 06 Feb 2007 15:53:40 -0800
Message-ID: <200702062353.l16NreSY000860@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55875 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965601AbXBFXxy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Feb 2007 18:53:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: darwish.07@gmail.com, johnpol@2ka.mipt.ru


The patch titled
     w1: Use ARRAY_SIZE macro when appropriate
has been added to the -mm tree.  Its filename is
     w1-use-array_size-macro-when-appropriate.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: w1: Use ARRAY_SIZE macro when appropriate
From: "Ahmed S. Darwish" <darwish.07@gmail.com>

A patch to use ARRAY_SIZE macro already defined in kernel.h

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
Acked-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/slaves/w1_therm.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

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

arch-arm-use-array_size-macro-when-appropriate.patch
arch-avr32-use-array_size-macro-when-appropriate.patch
arch-powerpc-user-array_size-macro-when-appropriate.patch
arch-ppc-user-array_size-macro-when-appropriate.patch
git-dvb.patch
git-netdev-all.patch
s390-kmalloc-kzalloc-casting-cleanups.patch
dac960-kmalloc-kzalloc-casting-cleanups.patch
arch-arm26-use-array_size-macro-when-appropriate.patch
arch-m68knommu-user-array_size-macro-when-appropriate.patch
arch-m68k-user-array_size-macro-when-appropriate.patch
arch-cris-user-array_size-macro-when-appropriate.patch
arch-v850-user-array_size-macro-when-appropriate.patch
w1-use-array_size-macro-when-appropriate.patch
isdn-capi-use-array_size-when-appropriate.patch
