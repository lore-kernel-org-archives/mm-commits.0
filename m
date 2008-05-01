From: akpm@linux-foundation.org
Subject: - char-fix-sparse-shadowed-variable-warnings-in-espc.patch removed from -mm tree
Date: Thu, 01 May 2008 02:29:36 -0700
Message-ID: <200805010929.m419Taoj030694@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40661 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757348AbYEAJ3i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:29:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, mm-commits@vger.kernel.org


The patch titled
     char: fix sparse shadowed variable warnings in esp.c
has been removed from the -mm tree.  Its filename was
     char-fix-sparse-shadowed-variable-warnings-in-espc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
frv-unbreak-misalignment-handling-changes.patch
git-acpi.patch
cifs-remove-global_extern-macro.patch
input-replace-remaining-__function__-occurrences.patch
input-make-one-bit-signed-bitfields-unsigned.patch
git-kvm.patch
git-mips.patch
mmc-make-one-bit-signed-bitfields-unsigned.patch
nfs-replace-remaining-__function__-occurrences.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
git-sched.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
git-watchdog.patch
mac80211-michaelc-use-kernel-provided-infrastructure.patch
mac80211-introduce-struct-michael_mic_ctx-and-static-helpers.patch
mac80211-tkipc-use-kernel-provided-infrastructure.patch
mac80211-add-const-remove-unused-function-make-one-function-static.patch
mac80211-add-a-struct-to-hold-tkip-context.patch
mac80211-tkipc-use-struct-tkip_ctx-in-phase-1-key-mixing.patch
mac80211-tkipc-use-struct-tkip_ctx-in-phase-2-key-mixing.patch
git-xfs.patch
xtensa-replace-remaining-__function__-occurences.patch
pcmcia-replace-remaining-__function__-occurrences.patch
autofs4-fix-sparse-warning-in-waitqc-autofs4_expire_indirect.patch
ide-eliminate-fit-macro.patch
ata-remove-fit-macro.patch
b43-replace-limit_value-macro-with-clamp_val.patch
b43legacy-replace-limit_value-macro-with-clamp_val.patch
fuse-use-clamp-rather-than-nested-min-max.patch
ide-tape-use-clamp_t-rather-than-nested-min_t-max_t.patch
input-ff-memlessc-use-clamp_val-macro.patch
dccp-ccid2c-ccid3c-use-clamp-clamp_t.patch
block-remove-remaining-__function__-occurances.patch

