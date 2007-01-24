From: akpm@osdl.org
Subject: + isdn-capi-use-array_size-when-appropriate.patch added to -mm tree
Date: Tue, 23 Jan 2007 19:54:12 -0800
Message-ID: <200701240354.l0O3sClh007746@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50018 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965642AbXAXDyR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Jan 2007 22:54:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: darwish.07@gmail.com, kkeil@suse.de


The patch titled
     isdn/capi: use ARRAY_SIZE when appropriate
has been added to the -mm tree.  Its filename is
     isdn-capi-use-array_size-when-appropriate.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: isdn/capi: use ARRAY_SIZE when appropriate
From: "Ahmed S. Darwish" <darwish.07@gmail.com>

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
Acked-by: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
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

git-cifs.patch
git-cpufreq.patch
git-dvb.patch
ucc-ether-driver-kmalloc-casting-cleanups.patch
s390-kmalloc-kzalloc-casting-cleanups.patch
dac960-kmalloc-kzalloc-casting-cleanups.patch
isdn-capi-use-array_size-when-appropriate.patch
