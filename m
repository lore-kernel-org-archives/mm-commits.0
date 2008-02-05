From: akpm@linux-foundation.org
Subject: - pcmcia-axnet_cs-make-use-of-max-instead-of-handcrafted-one.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:27:16 -0800
Message-ID: <200802052226.m15MQvFq011661@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46308 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932362AbYBEWnb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:43:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ricknu-0@student.ltu.se, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     pcmcia/axnet_cs: make use of 'max()' instead of handcrafted one
has been removed from the -mm tree.  Its filename was
     pcmcia-axnet_cs-make-use-of-max-instead-of-handcrafted-one.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pcmcia/axnet_cs: make use of 'max()' instead of handcrafted one
From: Richard Knutsson <ricknu-0@student.ltu.se>

Use 'max(x,y)' instead of 'x < y ? y : x'.

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/pcmcia/axnet_cs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/net/pcmcia/axnet_cs.c~pcmcia-axnet_cs-make-use-of-max-instead-of-handcrafted-one drivers/net/pcmcia/axnet_cs.c
--- a/drivers/net/pcmcia/axnet_cs.c~pcmcia-axnet_cs-make-use-of-max-instead-of-handcrafted-one
+++ a/drivers/net/pcmcia/axnet_cs.c
@@ -1087,8 +1087,8 @@ static int ei_start_xmit(struct sk_buff 
 	
 	ei_local->irqlock = 1;
 
-	send_length = ETH_ZLEN < length ? length : ETH_ZLEN;
-	
+	send_length = max(length, ETH_ZLEN);
+
 	/*
 	 * We have two Tx slots available for use. Find the first free
 	 * slot, and then perform some sanity checks. With two Tx bufs,
_

Patches currently in -mm which might be from ricknu-0@student.ltu.se are

origin.patch
reiserfs-complement-va_start-with-va_end.patch
kernel-paramsc-remove-sparse-warning-different-signedness.patch
