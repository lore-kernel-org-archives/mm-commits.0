From: akpm@linux-foundation.org
Subject: + char-fix-sparse-shadowed-variable-warnings-in-espc.patch added to -mm tree
Date: Wed, 27 Feb 2008 15:24:14 -0800
Message-ID: <200802272324.m1RNOEE9003932@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:38023 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754215AbYB0XYR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Feb 2008 18:24:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com


The patch titled
     char: fix sparse shadowed variable warnings in esp.c
has been added to the -mm tree.  Its filename is
     char-fix-sparse-shadowed-variable-warnings-in-espc.patch

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
Subject: char: fix sparse shadowed variable warnings in esp.c
From: Harvey Harrison <harvey.harrison@gmail.com>

flags only use was in spin_lock_irqsave/spin_lock_irgrestore pairs, no
need to redeclare for each one.

drivers/char/esp.c:1599:17: warning: symbol 'flags' shadows an earlier one
drivers/char/esp.c:1517:16: originally declared here
drivers/char/esp.c:1615:17: warning: symbol 'flags' shadows an earlier one
drivers/char/esp.c:1517:16: originally declared here
drivers/char/esp.c:1631:17: warning: symbol 'flags' shadows an earlier one
drivers/char/esp.c:1517:16: originally declared here

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/esp.c |    6 ------
 1 file changed, 6 deletions(-)

diff -puN drivers/char/esp.c~char-fix-sparse-shadowed-variable-warnings-in-espc drivers/char/esp.c
--- a/drivers/char/esp.c~char-fix-sparse-shadowed-variable-warnings-in-espc
+++ a/drivers/char/esp.c
@@ -1600,8 +1600,6 @@ static int set_esp_config(struct esp_str
 
 	if ((new_config.flow_off != info->config.flow_off) ||
 	    (new_config.flow_on != info->config.flow_on)) {
-		unsigned long flags;
-
 		info->config.flow_off = new_config.flow_off;
 		info->config.flow_on = new_config.flow_on;
 
@@ -1616,8 +1614,6 @@ static int set_esp_config(struct esp_str
 
 	if ((new_config.rx_trigger != info->config.rx_trigger) ||
 	    (new_config.tx_trigger != info->config.tx_trigger)) {
-		unsigned long flags;
-
 		info->config.rx_trigger = new_config.rx_trigger;
 		info->config.tx_trigger = new_config.tx_trigger;
 		spin_lock_irqsave(&info->lock, flags);
@@ -1632,8 +1628,6 @@ static int set_esp_config(struct esp_str
 	}
 
 	if (new_config.rx_timeout != info->config.rx_timeout) {
-		unsigned long flags;
-
 		info->config.rx_timeout = new_config.rx_timeout;
 		spin_lock_irqsave(&info->lock, flags);
 
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
git-x86.patch
git-dvb.patch
git-dlm.patch
git-kvm.patch
pata_amd-fix-sparse-warning.patch
jffs2-include-function-prototype-for-jffs2_ioctl.patch
jffs2-fix-sparse-warning-in-nodemgmtc.patch
jffs2-fix-sparse-warning-in-writec.patch
jffs2-fix-sparse-warnings-in-gcc.patch
git-ubi.patch
git-net.patch
git-nfsd.patch
remove-sparse-warning-for-mmzoneh.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
adfs-work-around-bogus-sparse-warning.patch
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
fbcon-replace-mono_col-macro-with-static-inline.patch
jbd-sparse-warnings-in-revokec-journalc.patch
udf-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-fix_nodec.patch
reiserfs-fix-sparse-warnings-in-do_balanc.patch
reiserfs-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-lbalancec.patch
reiserfs-fix-sparse-warning-in-journalc.patch
reiserfs-fix-more-sparse-warnings-in-do_balanc.patch
cgroup-fix-sparse-warning-of-shadow-symbol-in-cgroupc.patch
char-fix-sparse-shadowed-variable-warnings-in-espc.patch
