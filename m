From: akpm@linux-foundation.org
Subject: + drivers-char-pcmcia-ipwireless-hardwarec-fix-resource-leak.patch added to -mm tree
Date: Thu, 10 Jul 2008 18:49:55 -0700
Message-ID: <200807110155.m6B1tWAt026073@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35850 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752932AbYGKBzi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Jul 2008 21:55:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: darrenrjenkins@gmail.com, jkosina@suse.cz


The patch titled
     drivers/char/pcmcia/ipwireless/hardware.c fix resource leak
has been added to the -mm tree.  Its filename is
     drivers-char-pcmcia-ipwireless-hardwarec-fix-resource-leak.patch

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
Subject: drivers/char/pcmcia/ipwireless/hardware.c fix resource leak
From: Darren Jenkins <darrenrjenkins@gmail.com>

Coverity CID: 2172 RESOURCE_LEAK

When pool_allocate() tries to enlarge a packet, if it can not allocate enough
memory, it returns NULL without first freeing the old packet.

This patch just frees the packet first.

Signed-off-by: Darren Jenkins <darrenrjenkins@gmail.com>
Acked-by: Jiri Kosina <jkosina@suse.cz>
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
drivers-char-pcmcia-ipwireless-hardwarec-fix-resource-leak.patch

