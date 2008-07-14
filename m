From: akpm@linux-foundation.org
Subject: - drivers-char-pcmcia-ipwireless-hardwarec-fix-resource-leak.patch removed from -mm tree
Date: Mon, 14 Jul 2008 12:34:43 -0700
Message-ID: <200807141934.m6EJYhI1023833@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36705 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753535AbYGNTe4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Jul 2008 15:34:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: darrenrjenkins@gmail.com, jkosina@suse.cz, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     drivers/char/pcmcia/ipwireless/hardware.c fix resource leak
has been removed from the -mm tree.  Its filename was
     drivers-char-pcmcia-ipwireless-hardwarec-fix-resource-leak.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/char/pcmcia/ipwireless/hardware.c fix resource leak
From: Darren Jenkins <darrenrjenkins@gmail.com>

Coverity CID: 2172 RESOURCE_LEAK

When pool_allocate() tries to enlarge a packet, if it can not allocate enough
memory, it returns NULL without first freeing the old packet.

This patch just frees the packet first.

Signed-off-by: Darren Jenkins <darrenrjenkins@gmail.com>
Acked-by: Jiri Kosina <jkosina@suse.cz>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/pcmcia/ipwireless/hardware.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/char/pcmcia/ipwireless/hardware.c~drivers-char-pcmcia-ipwireless-hardwarec-fix-resource-leak drivers/char/pcmcia/ipwireless/hardware.c
--- a/drivers/char/pcmcia/ipwireless/hardware.c~drivers-char-pcmcia-ipwireless-hardwarec-fix-resource-leak
+++ a/drivers/char/pcmcia/ipwireless/hardware.c
@@ -590,8 +590,10 @@ static struct ipw_rx_packet *pool_alloca
 		packet = kmalloc(sizeof(struct ipw_rx_packet) +
 				old_packet->length + minimum_free_space,
 				GFP_ATOMIC);
-		if (!packet)
+		if (!packet) {
+			kfree(old_packet);
 			return NULL;
+		}
 		memcpy(packet, old_packet,
 				sizeof(struct ipw_rx_packet)
 					+ old_packet->length);
_

Patches currently in -mm which might be from darrenrjenkins@gmail.com are

linux-next.patch

