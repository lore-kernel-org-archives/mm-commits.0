From: akpm@osdl.org
Subject: - drivers-isdn-handcrafted-min-max-macro-removal.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:10:41 -0800
Message-ID: <200612082010.kB8KAfo3002838@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:58926 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946542AbWLHUKu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:10:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: amol@verismonetworks.com, kkeil@suse.de, mm-commits@vger.kernel.org


The patch titled
     drivers/isdn: Handcrafted MIN/MAX Macro removal
has been removed from the -mm tree.  Its filename was
     drivers-isdn-handcrafted-min-max-macro-removal.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/isdn: Handcrafted MIN/MAX Macro removal
From: Amol Lad <amol@verismonetworks.com>

Cleanups done to use min/max macros from kernel.h.  Handcrafted MIN/MAX
macros are changed to use macros in kernel.h

[akpm@osdl.org: warning fix]
Signed-off-by: Amol Lad <amol@verismonetworks.com>
Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/isdn/hardware/eicon/debug.c    |    4 ++--
 drivers/isdn/hardware/eicon/di.c       |    8 ++++----
 drivers/isdn/hardware/eicon/io.c       |    2 +-
 drivers/isdn/hardware/eicon/istream.c  |    4 ++--
 drivers/isdn/hardware/eicon/platform.h |    8 --------
 5 files changed, 9 insertions(+), 17 deletions(-)

diff -puN drivers/isdn/hardware/eicon/debug.c~drivers-isdn-handcrafted-min-max-macro-removal drivers/isdn/hardware/eicon/debug.c
--- a/drivers/isdn/hardware/eicon/debug.c~drivers-isdn-handcrafted-min-max-macro-removal
+++ a/drivers/isdn/hardware/eicon/debug.c
@@ -756,14 +756,14 @@ int diva_get_driver_info (dword id, byte
 
     data_length -= 9;
 
-    if ((to_copy = MIN(strlen(clients[id].drvName), data_length-1))) {
+    if ((to_copy = min(strlen(clients[id].drvName), (size_t)(data_length-1)))) {
       memcpy (p, clients[id].drvName, to_copy);
       p += to_copy;
       data_length -= to_copy;
       if ((data_length >= 4) && clients[id].hDbg->drvTag[0]) {
         *p++ = '(';
         data_length -= 1;
-        if ((to_copy = MIN(strlen(clients[id].hDbg->drvTag), data_length-2))) {
+        if ((to_copy = min(strlen(clients[id].hDbg->drvTag), (size_t)(data_length-2)))) {
           memcpy (p, clients[id].hDbg->drvTag, to_copy);
           p += to_copy;
           data_length -= to_copy;
diff -puN drivers/isdn/hardware/eicon/di.c~drivers-isdn-handcrafted-min-max-macro-removal drivers/isdn/hardware/eicon/di.c
--- a/drivers/isdn/hardware/eicon/di.c~drivers-isdn-handcrafted-min-max-macro-removal
+++ a/drivers/isdn/hardware/eicon/di.c
@@ -133,7 +133,7 @@ void pr_out(ADAPTER * a)
     i = this->XCurrent;
     X = PTR_X(a,this);
     while(i<this->XNum && length<270) {
-      clength = MIN((word)(270-length),X[i].PLength-this->XOffset);
+      clength = min((word)(270-length),(word)(X[i].PLength-this->XOffset));
       a->ram_out_buffer(a,
                         &ReqOut->XBuffer.P[length],
                         PTR_P(a,this,&X[i].P[this->XOffset]),
@@ -622,7 +622,7 @@ byte isdn_ind(ADAPTER * a,
                                                      sizeof(a->stream_buffer),
                                                      &final, NULL, NULL);
         }
-        IoAdapter->RBuffer.length = MIN(MLength, 270);
+        IoAdapter->RBuffer.length = min(MLength, (word)270);
         if (IoAdapter->RBuffer.length != MLength) {
           this->complete = 0;
         } else {
@@ -676,9 +676,9 @@ byte isdn_ind(ADAPTER * a,
         this->RCurrent++;
       }
       if (cma) {
-        clength = MIN(MLength, R[this->RCurrent].PLength-this->ROffset);
+        clength = min(MLength, (word)(R[this->RCurrent].PLength-this->ROffset));
       } else {
-        clength = MIN(a->ram_inw(a, &RBuffer->length)-offset,
+        clength = min(a->ram_inw(a, &RBuffer->length)-offset,
                       R[this->RCurrent].PLength-this->ROffset);
       }
       if(R[this->RCurrent].P) {
diff -puN drivers/isdn/hardware/eicon/io.c~drivers-isdn-handcrafted-min-max-macro-removal drivers/isdn/hardware/eicon/io.c
--- a/drivers/isdn/hardware/eicon/io.c~drivers-isdn-handcrafted-min-max-macro-removal
+++ a/drivers/isdn/hardware/eicon/io.c
@@ -262,7 +262,7 @@ void request(PISDN_ADAPTER IoAdapter, EN
     case IDI_SYNC_REQ_XDI_GET_CAPI_PARAMS: {
        diva_xdi_get_capi_parameters_t prms, *pI = &syncReq->xdi_capi_prms.info;
        memset (&prms, 0x00, sizeof(prms));
-       prms.structure_length = MIN(sizeof(prms), pI->structure_length);
+       prms.structure_length = min_t(size_t, sizeof(prms), pI->structure_length);
        memset (pI, 0x00, pI->structure_length);
        prms.flag_dynamic_l1_down    = (IoAdapter->capi_cfg.cfg_1 & \
          DIVA_XDI_CAPI_CFG_1_DYNAMIC_L1_ON) ? 1 : 0;
diff -puN drivers/isdn/hardware/eicon/istream.c~drivers-isdn-handcrafted-min-max-macro-removal drivers/isdn/hardware/eicon/istream.c
--- a/drivers/isdn/hardware/eicon/istream.c~drivers-isdn-handcrafted-min-max-macro-removal
+++ a/drivers/isdn/hardware/eicon/istream.c
@@ -92,7 +92,7 @@ int diva_istream_write (void* context,
     return (-1); /* was not able to write       */
    break;     /* only part of message was written */
   }
-  to_write = MIN(length, DIVA_DFIFO_DATA_SZ);
+  to_write = min(length, DIVA_DFIFO_DATA_SZ);
   if (to_write) {
    a->ram_out_buffer (a,
 #ifdef PLATFORM_GT_32BIT
@@ -176,7 +176,7 @@ int diva_istream_read (void* context,
     return (-1); /* was not able to read */
    break;
   }
-  to_read = MIN(max_length, tmp[1]);
+  to_read = min(max_length, (int)tmp[1]);
   if (to_read) {
    a->ram_in_buffer(a,
 #ifdef PLATFORM_GT_32BIT
diff -puN drivers/isdn/hardware/eicon/platform.h~drivers-isdn-handcrafted-min-max-macro-removal drivers/isdn/hardware/eicon/platform.h
--- a/drivers/isdn/hardware/eicon/platform.h~drivers-isdn-handcrafted-min-max-macro-removal
+++ a/drivers/isdn/hardware/eicon/platform.h
@@ -83,14 +83,6 @@
 #define	NULL	((void *) 0)
 #endif
 
-#ifndef	MIN
-#define MIN(a,b)	((a)>(b) ? (b) : (a))
-#endif
-
-#ifndef	MAX
-#define MAX(a,b)	((a)>(b) ? (a) : (b))
-#endif
-
 #ifndef	far
 #define far
 #endif
_

Patches currently in -mm which might be from amol@verismonetworks.com are

origin.patch
drivers-isdn-handcrafted-min-max-macro-removal.patch
ioremap-balanced-with-iounmap-for-drivers-video-virgefb.patch
ioremap-balanced-with-iounmap-for-drivers-video-vesafb.patch
ioremap-balanced-with-iounmap-for-drivers-video-tridentfb.patch
ioremap-balanced-with-iounmap-for-drivers-video-tgafb.patch
ioremap-balanced-with-iounmap-for-drivers-video-stifb.patch
ioremap-balanced-with-iounmap-for-drivers-video-retz3fb.patch
ioremap-balanced-with-iounmap-for-drivers-video-pvr2fb.patch
ioremap-balanced-with-iounmap-for-drivers-video-platinumfb.patch
ioremap-balanced-with-iounmap-for-drivers-video-offb.patch
ioremap-balanced-with-iounmap-for-drivers-video-macfb.patch
ioremap-balanced-with-iounmap-for-drivers-video-hpfb.patch
ioremap-balanced-with-iounmap-for-drivers-video-fm2fb.patch
ioremap-balanced-with-iounmap-for-drivers-video-ffb.patch
ioremap-balanced-with-iounmap-for-drivers-video-cyberfb.patch
ioremap-balanced-with-iounmap-for-drivers-video-cirrusfb.patch
ioremap-balanced-with-iounmap-for-drivers-video-atyfb_base.patch
ioremap-balanced-with-iounmap-for-drivers-video-atafb.patch
ioremap-balanced-with-iounmap-for-drivers-video-amifb.patch
ioremap-balanced-with-iounmap-for-drivers-video-S3triofb.patch
git-cpufreq.patch
drivers-scsi-ncr5380c-replacing-yield-with-a.patch
drivers-scsi-megaraidc-replacing-yield-with-a.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch

