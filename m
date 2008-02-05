From: akpm@linux-foundation.org
Subject: - pcmcia-fmvj18x_cs-fix-shadow-variable-warning.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:27:18 -0800
Message-ID: <200802052226.m15MQxG1011665@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43827 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932363AbYBEWnb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:43:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ricknu-0@student.ltu.se, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     pcmcia/fmvj18x_cs: fix 'shadow variable' warning
has been removed from the -mm tree.  Its filename was
     pcmcia-fmvj18x_cs-fix-shadow-variable-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pcmcia/fmvj18x_cs: fix 'shadow variable' warning
From: Richard Knutsson <ricknu-0@student.ltu.se>

Fixing:
  CHECK   drivers/net/pcmcia/fmvj18x_cs.c
drivers/net/pcmcia/fmvj18x_cs.c:1205:6: warning: symbol 'i' shadows an earlier one
drivers/net/pcmcia/fmvj18x_cs.c:1179:9: originally declared here

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/pcmcia/fmvj18x_cs.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/net/pcmcia/fmvj18x_cs.c~pcmcia-fmvj18x_cs-fix-shadow-variable-warning drivers/net/pcmcia/fmvj18x_cs.c
--- a/drivers/net/pcmcia/fmvj18x_cs.c~pcmcia-fmvj18x_cs-fix-shadow-variable-warning
+++ a/drivers/net/pcmcia/fmvj18x_cs.c
@@ -1198,8 +1198,7 @@ static void set_rx_mode(struct net_devic
 	outb(1, ioaddr + RX_MODE);	/* Ignore almost all multicasts. */
     } else {
 	struct dev_mc_list *mclist;
-	int i;
-	
+
 	memset(mc_filter, 0, sizeof(mc_filter));
 	for (i = 0, mclist = dev->mc_list; mclist && i < dev->mc_count;
 	     i++, mclist = mclist->next) {
_

Patches currently in -mm which might be from ricknu-0@student.ltu.se are

origin.patch
reiserfs-complement-va_start-with-va_end.patch
kernel-paramsc-remove-sparse-warning-different-signedness.patch
