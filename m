From: akpm@linux-foundation.org
Subject: + fix-struct-device-member-name-in-pcmcia-au1000_generic.patch added to -mm tree
Date: Mon, 26 Mar 2007 00:26:46 -0800
Message-ID: <200703260826.l2Q8QkjM014680@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:49517 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752630AbXCZIaQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Mar 2007 04:30:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yoichi_yuasa@tripeaks.co.jp, greg@kroah.com, linux@dominikbrodowski.net, perex@suse.cz, ralf@linux-mips.org, tiwai@suse.de


The patch titled
     Fix struct device member name in PCMCIA au1000_generic
has been added to the -mm tree.  Its filename is
     fix-struct-device-member-name-in-pcmcia-au1000_generic.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix struct device member name in PCMCIA au1000_generic
From: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>

drivers/pcmcia/au1000_generic.c: In function 'au1x00_pcmcia_socket_probe':
drivers/pcmcia/au1000_generic.c:375: error: 'struct device' has no member named 'dev'

Signed-off-by: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Jaroslav Kysela <perex@suse.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Greg KH <greg@kroah.com>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pcmcia/au1000_generic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/pcmcia/au1000_generic.c~fix-struct-device-member-name-in-pcmcia-au1000_generic drivers/pcmcia/au1000_generic.c
--- a/drivers/pcmcia/au1000_generic.c~fix-struct-device-member-name-in-pcmcia-au1000_generic
+++ a/drivers/pcmcia/au1000_generic.c
@@ -372,7 +372,7 @@ int au1x00_pcmcia_socket_probe(struct de
 		skt->socket.resource_ops = &pccard_static_ops;
 		skt->socket.ops = &au1x00_pcmcia_operations;
 		skt->socket.owner = ops->owner;
-		skt->socket.dev.dev = dev;
+		skt->socket.dev.parent = dev;
 
 		init_timer(&skt->poll_timer);
 		skt->poll_timer.function = au1x00_pcmcia_poll_event;
_

Patches currently in -mm which might be from yoichi_yuasa@tripeaks.co.jp are

fix-struct-device-member-name-in-pcmcia-au1000_generic.patch
git-input.patch
git-mips.patch
