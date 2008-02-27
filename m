From: akpm@linux-foundation.org
Subject: + ipwireless-fix-potential-tty-==-null-dereference.patch added to -mm tree
Date: Wed, 27 Feb 2008 14:49:53 -0800
Message-ID: <200802272249.m1RMnrKZ002216@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:50461 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760693AbYB0WvM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Feb 2008 17:51:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dsterba@suse.cz, bunk@kernel.org, jkosina@suse.cz, linville@tuxdriver.com


The patch titled
     ipwireless: fix potential tty == NULL dereference
has been added to the -mm tree.  Its filename is
     ipwireless-fix-potential-tty-==-null-dereference.patch

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

ipwireless-fix-potential-tty-==-null-dereference.patch
