From: akpm@linux-foundation.org
Subject: + eicon-fix-sparse-integer-as-null-pointer-warnings.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:34:40 -0800
Message-ID: <200802230735.m1N7ZTkH018363@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:47476 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754316AbYBWIAS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 03:00:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, jeff@garzik.org, kkeil@suse.de


The patch titled
     eicon: fix sparse integer as NULL pointer warnings
has been added to the -mm tree.  Its filename is
     eicon-fix-sparse-integer-as-null-pointer-warnings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
markers-fix-sparse-warnings-in-markersc.patch
acpi-sparse-fix-replace-macro-with-static-function.patch
bttv-struct-member-initialized-twice.patch
dlm-match-signedness-between-dlm_config_info-and-cluster_set.patch
ata-fix-sparse-warning-in-libatah.patch
pata_amd-fix-sparse-warning.patch
jffs2-include-function-prototype-for-jffs2_ioctl.patch
jffs2-fix-sparse-warning-in-nodemgmtc.patch
jffs2-fix-sparse-warning-in-writec.patch
jffs2-fix-sparse-warnings-in-gcc.patch
git-ubi.patch
lockd-fix-sparse-warning-in-svcsharec.patch
remove-sparse-warning-for-mmzoneh.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
adfs-work-around-bogus-sparse-warning.patch
debugfs-fix-sparse-warnings.patch
coda-add-static-to-functions-in-dirc.patch
befs-fix-sparse-warning-in-linuxvfsc.patch
autofs4-fix-sparse-warning-in-rootc.patch
ncpfs-add-prototypes-to-ncp_fsh.patch
ncpfs-fix-sparse-warnings-in-ioctlc.patch
ncpfs-fix-sparse-warning-in-ncpsign_kernelc.patch
serial-remove-double-initializer.patch
char-make-functions-static-in-synclinkmpc.patch
kprobes-introduce-kprobe_handle_fault.patch
kprobes-remove-preempt_enable-disable-from-kprobe_handle_fault.patch
capi-fix-sparse-warnings-using-integer-as-null-pointer.patch
avm-fix-sparse-warning-using-integer-as-null-pointer.patch
eicon-fix-sparse-integer-as-null-pointer-warnings.patch
jbd-sparse-warnings-in-revokec-journalc.patch
udf-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-fix_nodec.patch
reiserfs-fix-sparse-warnings-in-do_balanc.patch
reiserfs-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-lbalancec.patch
reiserfs-fix-sparse-warning-in-journalc.patch
reiserfs-fix-more-sparse-warnings-in-do_balanc.patch
jbd2-sparse-warnings-in-revokec-journalc.patch
