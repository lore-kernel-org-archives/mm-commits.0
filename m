From: akpm@linux-foundation.org
Subject: - synclink_gt-leave-transmitter-in-reset-state-after-configuration.patch removed from -mm tree
Date: Mon, 21 Jul 2008 14:34:22 -0700
Message-ID: <200807212134.m6LLYMDH025663@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44535 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753151AbYGUVfH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Jul 2008 17:35:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: paulkf@microgate.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     synclink_gt: leave transmitter in reset state after configuration
has been removed from the -mm tree.  Its filename was
     synclink_gt-leave-transmitter-in-reset-state-after-configuration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: synclink_gt: leave transmitter in reset state after configuration
From: Paul Fulghum <paulkf@microgate.com>

Leave the transmitter in reset state after configuration so that transmit
signal is held at mark until transmitter is explicitly enabled by
application, otherwise transmitter sends idle pattern.

Signed-off-by: Paul Fulghum <paulkf@microgate.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/synclink_gt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/synclink_gt.c~synclink_gt-leave-transmitter-in-reset-state-after-configuration drivers/char/synclink_gt.c
--- a/drivers/char/synclink_gt.c~synclink_gt-leave-transmitter-in-reset-state-after-configuration
+++ a/drivers/char/synclink_gt.c
@@ -4149,7 +4149,7 @@ static void sync_mode(struct slgt_info *
 	 * 01      enable
 	 * 00      auto-CTS enable
 	 */
-	val = 0;
+	val = BIT2;
 
 	switch(info->params.mode) {
 	case MGSL_MODE_MONOSYNC: val |= BIT14 + BIT13; break;
_

Patches currently in -mm which might be from paulkf@microgate.com are

linux-next.patch

