From: akpm@linux-foundation.org
Subject: - isdn-capi-use-array_size-when-appropriate.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:46:09 -0800
Message-ID: <200702122246.l1CMk9TQ013776@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45198 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030323AbXBLWqO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:46:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: darwish.07@gmail.com, kkeil@suse.de, mm-commits@vger.kernel.org


The patch titled
     isdn/capi: use ARRAY_SIZE when appropriate
has been removed from the -mm tree.  Its filename was
     isdn-capi-use-array_size-when-appropriate.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: isdn/capi: use ARRAY_SIZE when appropriate
From: "Ahmed S. Darwish" <darwish.07@gmail.com>

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
Acked-by: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/capi/capi.c    |    4 ++--
 drivers/isdn/capi/capidrv.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/isdn/capi/capi.c~isdn-capi-use-array_size-when-appropriate drivers/isdn/capi/capi.c
--- a/drivers/isdn/capi/capi.c~isdn-capi-use-array_size-when-appropriate
+++ a/drivers/isdn/capi/capi.c
@@ -1456,7 +1456,7 @@ static struct procfsentries {
 
 static void __init proc_init(void)
 {
-    int nelem = sizeof(procfsentries)/sizeof(procfsentries[0]);
+    int nelem = ARRAY_SIZE(procfsentries);
     int i;
 
     for (i=0; i < nelem; i++) {
@@ -1468,7 +1468,7 @@ static void __init proc_init(void)
 
 static void __exit proc_exit(void)
 {
-    int nelem = sizeof(procfsentries)/sizeof(procfsentries[0]);
+    int nelem = ARRAY_SIZE(procfsentries);
     int i;
 
     for (i=nelem-1; i >= 0; i--) {
diff -puN drivers/isdn/capi/capidrv.c~isdn-capi-use-array_size-when-appropriate drivers/isdn/capi/capidrv.c
--- a/drivers/isdn/capi/capidrv.c~isdn-capi-use-array_size-when-appropriate
+++ a/drivers/isdn/capi/capidrv.c
@@ -2218,7 +2218,7 @@ static struct procfsentries {
 
 static void __init proc_init(void)
 {
-    int nelem = sizeof(procfsentries)/sizeof(procfsentries[0]);
+    int nelem = ARRAY_SIZE(procfsentries);
     int i;
 
     for (i=0; i < nelem; i++) {
@@ -2230,7 +2230,7 @@ static void __init proc_init(void)
 
 static void __exit proc_exit(void)
 {
-    int nelem = sizeof(procfsentries)/sizeof(procfsentries[0]);
+    int nelem = ARRAY_SIZE(procfsentries);
     int i;
 
     for (i=nelem-1; i >= 0; i--) {
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
