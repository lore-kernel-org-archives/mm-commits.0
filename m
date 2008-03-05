From: akpm@linux-foundation.org
Subject: - ipwireless-fix-potential-tty-==-null-dereference.patch removed from -mm tree
Date: Tue, 04 Mar 2008 23:44:41 -0800
Message-ID: <200803050744.m257ifc7021532@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33977 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764636AbYCEHq3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 02:46:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dsterba@suse.cz, bunk@kernel.org, jkosina@suse.cz, linville@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     ipwireless: fix potential tty == NULL dereference
has been removed from the -mm tree.  Its filename was
     ipwireless-fix-potential-tty-==-null-dereference.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipwireless: fix potential tty == NULL dereference
From: David Sterba <dsterba@suse.cz>

The Coverity checker spotted the following inconsequent NULL checking in
drivers/char/pcmcia/ipwireless/network.c:ipwireless_network_packet_received()

if (tty && channel_idx == IPW_CHANNEL_RAS
		&& (network->ras_control_lines &
			IPW_CONTROL_LINE_DCD) != 0
		&& ipwireless_tty_is_modem(tty)) {
...
	else
		ipwireless_tty_received(tty, data, length);

Cc: Adrian Bunk <bunk@kernel.org>
Signed-off-by: David Sterba <dsterba@suse.cz>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/pcmcia/ipwireless/network.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/char/pcmcia/ipwireless/network.c~ipwireless-fix-potential-tty-==-null-dereference drivers/char/pcmcia/ipwireless/network.c
--- a/drivers/char/pcmcia/ipwireless/network.c~ipwireless-fix-potential-tty-==-null-dereference
+++ a/drivers/char/pcmcia/ipwireless/network.c
@@ -377,13 +377,16 @@ void ipwireless_network_packet_received(
 	for (i = 0; i < MAX_ASSOCIATED_TTYS; i++) {
 		struct ipw_tty *tty = network->associated_ttys[channel_idx][i];
 
+		if (!tty)
+			continue;
+
 		/*
 		 * If it's associated with a tty (other than the RAS channel
 		 * when we're online), then send the data to that tty.  The RAS
 		 * channel's data is handled above - it always goes through
 		 * ppp_generic.
 		 */
-		if (tty && channel_idx == IPW_CHANNEL_RAS
+		if (channel_idx == IPW_CHANNEL_RAS
 				&& (network->ras_control_lines &
 					IPW_CONTROL_LINE_DCD) != 0
 				&& ipwireless_tty_is_modem(tty)) {
_

Patches currently in -mm which might be from dsterba@suse.cz are


