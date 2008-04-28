From: akpm@linux-foundation.org
Subject: - eicon-fix-sparse-integer-as-null-pointer-warnings.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:56:45 -0700
Message-ID: <200804282156.m3SLujMC018259@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53340 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936243AbYD1V46 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:56:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, jeff@garzik.org, kkeil@suse.de, mm-commits@vger.kernel.org


The patch titled
     eicon: fix sparse integer as NULL pointer warnings
has been removed from the -mm tree.  Its filename was
     eicon-fix-sparse-integer-as-null-pointer-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: eicon: fix sparse integer as NULL pointer warnings
From: Harvey Harrison <harvey.harrison@gmail.com>

drivers/isdn/hardware/eicon/message.c:745:47: warning: Using plain integer as NULL pointer
drivers/isdn/hardware/eicon/message.c:761:45: warning: Using plain integer as NULL pointer
drivers/isdn/hardware/eicon/message.c:9122:16: warning: Using plain integer as NULL pointer
drivers/isdn/hardware/eicon/message.c:9147:16: warning: Using plain integer as NULL pointer
drivers/isdn/hardware/eicon/message.c:9173:14: warning: Using plain integer as NULL pointer
drivers/isdn/hardware/eicon/divasmain.c:396:23: warning: Using plain integer as NULL pointer

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Karsten Keil <kkeil@suse.de>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/hardware/eicon/divasmain.c |    2 +-
 drivers/isdn/hardware/eicon/message.c   |   12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff -puN drivers/isdn/hardware/eicon/divasmain.c~eicon-fix-sparse-integer-as-null-pointer-warnings drivers/isdn/hardware/eicon/divasmain.c
--- a/drivers/isdn/hardware/eicon/divasmain.c~eicon-fix-sparse-integer-as-null-pointer-warnings
+++ a/drivers/isdn/hardware/eicon/divasmain.c
@@ -393,7 +393,7 @@ void diva_free_dma_map(void *hdev, struc
 	dma_addr_t dma_handle;
 	void *addr_handle;
 
-	for (i = 0; (pmap != 0); i++) {
+	for (i = 0; (pmap != NULL); i++) {
 		diva_get_dma_map_entry(pmap, i, &cpu_addr, &phys_addr);
 		if (!cpu_addr) {
 			break;
diff -puN drivers/isdn/hardware/eicon/message.c~eicon-fix-sparse-integer-as-null-pointer-warnings drivers/isdn/hardware/eicon/message.c
--- a/drivers/isdn/hardware/eicon/message.c~eicon-fix-sparse-integer-as-null-pointer-warnings
+++ a/drivers/isdn/hardware/eicon/message.c
@@ -742,7 +742,7 @@ static void start_internal_command (dwor
   else
   {
     i = 1;
-    while (plci->internal_command_queue[i] != 0)
+    while (plci->internal_command_queue[i] != NULL)
       i++;
     plci->internal_command_queue[i] = command_function;
   }
@@ -758,7 +758,7 @@ static void next_internal_command (dword
 
   plci->internal_command = 0;
   plci->internal_command_queue[0] = NULL;
-  while (plci->internal_command_queue[1] != 0)
+  while (plci->internal_command_queue[1] != NULL)
   {
     for (i = 0; i < MAX_INTERNAL_COMMAND_LEVELS - 1; i++)
       plci->internal_command_queue[i] = plci->internal_command_queue[i+1];
@@ -9119,7 +9119,7 @@ word AdvCodecSupport(DIVA_CAPI_ADAPTER  
         dbug(1,dprintf("AdvSigPlci=0x%x",a->AdvSignalPLCI));
         return 0x2001; /* codec in use by another application */
       }
-      if(plci!=0)
+      if(plci!=NULL)
       {
         a->AdvSignalPLCI = plci;
         plci->tel=ADV_VOICE;
@@ -9144,7 +9144,7 @@ word AdvCodecSupport(DIVA_CAPI_ADAPTER  
         }
                                                /* indicate D-ch connect if  */
       }                                        /* codec is connected OK     */
-      if(plci!=0)
+      if(plci!=NULL)
       {
         a->AdvSignalPLCI = plci;
         plci->tel=ADV_VOICE;
@@ -9170,7 +9170,7 @@ word AdvCodecSupport(DIVA_CAPI_ADAPTER  
   {
     if(hook_listen) return 0x300B;               /* Facility not supported */
                                                  /* no hook with SCOM      */
-    if(plci!=0) plci->tel = CODEC;
+    if(plci!=NULL) plci->tel = CODEC;
     dbug(1,dprintf("S/SCOM codec"));
     /* first time we use the scom-s codec we must shut down the internal   */
     /* handset application of the card. This can be done by an assign with */
@@ -14604,7 +14604,7 @@ static void channel_xmit_extended_xon (P
   int max_ch = ARRAY_SIZE(a->ch_flow_control);
   int i, one_requested = 0;
 
-  if ((!plci) || (!plci->Id) || ((a = plci->adapter) == 0)) {
+  if ((!plci) || (!plci->Id) || ((a = plci->adapter) == NULL)) {
     return;
   }
 
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
cifs-remove-global_extern-macro.patch
input-replace-remaining-__function__-occurrences.patch
git-kvm.patch
git-mips.patch
git-nfsd.patch
nfs-replace-remaining-__function__-occurrences.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
pcmcia-replace-remaining-__function__-occurrences.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
git-watchdog.patch
git-xfs.patch
xtensa-replace-remaining-__function__-occurences.patch
power-replace-remaining-__function__-occurrences.patch
adfs-work-around-bogus-sparse-warning.patch
coda-add-static-to-functions-in-dirc.patch
befs-fix-sparse-warning-in-linuxvfsc.patch
autofs4-fix-sparse-warning-in-rootc.patch
firmware-replace-remaining-__function__-occurrences.patch
drivers-misc-replace-remaining-__function__-occurrences.patch
xen-make-blkif_getgeo-static.patch
ecryptfs-replace-remaining-__function__-occurrences.patch
cgroup-fix-sparse-warning-of-shadow-symbol-in-cgroupc.patch
ext4-replace-remaining-__function__-occurrences.patch
jdb2-replace-remaining-__function__-occurrences.patch
char-fix-sparse-shadowed-variable-warnings-in-espc.patch
char-espc-fix-possible-double-unlock.patch
char-rocketc-fix-sparse-variable-shadowing-and-int-as-null-pointer.patch
cycladesc-fix-sparse-shadowed-variable-warnings.patch
epcac-static-functions-and-integer-as-null-pointer-fixes.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
add-macros-similar-to-min-max-min_t-max_t.patch
add-macros-similar-to-min-max-min_t-max_t-doc.patch
ide-eliminate-fit-macro.patch
ata-remove-fit-macro.patch
b43-replace-limit_value-macro-with-clamp_val.patch
b43legacy-replace-limit_value-macro-with-clamp_val.patch
fuse-use-clamp-rather-than-nested-min-max.patch
ide-tape-use-clamp_t-rather-than-nested-min_t-max_t.patch
input-ff-memlessc-use-clamp_val-macro.patch
dccp-ccid2c-ccid3c-use-clamp-clamp_t.patch
drivers-replace-remaining-__function__-occurrences.patch
kernel-add-common-infrastructure-for-unaligned-access.patch
kernel-move-arches-to-use-common-unaligned-access.patch
drivers-block-use-get_unaligned_-helpers.patch
hid-core-use-get_unaligned_-helpers.patch
char-use-get_unaligned_-helpers.patch
input-use-get_unaligned_-helpers.patch
mmc-use-get-put_unaligned_-helpers.patch
net-use-get-put_unaligned_-helpers.patch
wireless-use-get-put_unaligned_-helpers.patch
pcmcia-use-get-put_unaligned_-helpers.patch
usb-use-get-put_unaligned_-helpers.patch
video-use-get-put_unaligned_-helpers.patch
fat-use-get-put_unaligned_-helpers.patch
hfsplus-use-get-put_unaligned_-helpers.patch
isofs-use-get-put_unaligned_-helpers.patch
ncpfs-use-get-put_unaligned_-helpers.patch
ncpfs-use-get-put_unaligned_-helpers-checkpatch-fixes.patch
mm-remove-remaining-__function__-occurances.patch
block-remove-remaining-__function__-occurances.patch
kernel-replace-remaining-__function__-occurances.patch
lib-replace-remaining-__function__-occurances.patch
afs-replace-remaining-__function__-occurrences.patch
fs-replace-remaining-__function__-occurrences.patch
drivers-char-replace-remaining-__function__-occurrences.patch
serial-replace-remaining-__function__-occurrences.patch

