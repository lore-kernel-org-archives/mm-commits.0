From: akpm@linux-foundation.org
Subject: - pcmcia-pcnet_cs-fix-shadow-variable-warning.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:27:20 -0800
Message-ID: <200802052227.m15MR1mN011669@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43592 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932367AbYBEWnc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:43:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ricknu-0@student.ltu.se, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     pcmcia/pcnet_cs: fix 'shadow variable' warning
has been removed from the -mm tree.  Its filename was
     pcmcia-pcnet_cs-fix-shadow-variable-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pcmcia/pcnet_cs: fix 'shadow variable' warning
From: Richard Knutsson <ricknu-0@student.ltu.se>

Fixing:
  CHECK   drivers/net/pcmcia/pcnet_cs.c
drivers/net/pcmcia/pcnet_cs.c:523:15: warning: symbol 'hw_info' shadows an earlier one
drivers/net/pcmcia/pcnet_cs.c:148:18: originally declared here

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/pcmcia/pcnet_cs.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff -puN drivers/net/pcmcia/pcnet_cs.c~pcmcia-pcnet_cs-fix-shadow-variable-warning drivers/net/pcmcia/pcnet_cs.c
--- a/drivers/net/pcmcia/pcnet_cs.c~pcmcia-pcnet_cs-fix-shadow-variable-warning
+++ a/drivers/net/pcmcia/pcnet_cs.c
@@ -521,7 +521,7 @@ static int pcnet_config(struct pcmcia_de
     int i, last_ret, last_fn, start_pg, stop_pg, cm_offset;
     int has_shmem = 0;
     u_short buf[64];
-    hw_info_t *hw_info;
+    hw_info_t *local_hw_info;
     DECLARE_MAC_BUF(mac);
 
     DEBUG(0, "pcnet_config(0x%p)\n", link);
@@ -590,23 +590,23 @@ static int pcnet_config(struct pcmcia_de
 	dev->if_port = 0;
     }
 
-    hw_info = get_hwinfo(link);
-    if (hw_info == NULL)
-	hw_info = get_prom(link);
-    if (hw_info == NULL)
-	hw_info = get_dl10019(link);
-    if (hw_info == NULL)
-	hw_info = get_ax88190(link);
-    if (hw_info == NULL)
-	hw_info = get_hwired(link);
+    local_hw_info = get_hwinfo(link);
+    if (local_hw_info == NULL)
+	local_hw_info = get_prom(link);
+    if (local_hw_info == NULL)
+	local_hw_info = get_dl10019(link);
+    if (local_hw_info == NULL)
+	local_hw_info = get_ax88190(link);
+    if (local_hw_info == NULL)
+	local_hw_info = get_hwired(link);
 
-    if (hw_info == NULL) {
+    if (local_hw_info == NULL) {
 	printk(KERN_NOTICE "pcnet_cs: unable to read hardware net"
 	       " address for io base %#3lx\n", dev->base_addr);
 	goto failed;
     }
 
-    info->flags = hw_info->flags;
+    info->flags = local_hw_info->flags;
     /* Check for user overrides */
     info->flags |= (delay_output) ? DELAY_OUTPUT : 0;
     if ((link->manf_id == MANFID_SOCKET) &&
_

Patches currently in -mm which might be from ricknu-0@student.ltu.se are

origin.patch
reiserfs-complement-va_start-with-va_end.patch
kernel-paramsc-remove-sparse-warning-different-signedness.patch
