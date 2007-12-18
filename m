From: akpm@linux-foundation.org
Subject: + pcmcia-axnet_cs-make-use-of-max-instead-of-handcrafted-one.patch added to -mm tree
Date: Tue, 18 Dec 2007 15:52:48 -0800
Message-ID: <200712182352.lBINqmVx028299@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55411 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754170AbXLRXx3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Dec 2007 18:53:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ricknu-0@student.ltu.se, alan@redhat.com


The patch titled
     pcmcia/axnet_cs: make use of 'max()' instead of handcrafted one
has been added to the -mm tree.  Its filename is
     pcmcia-axnet_cs-make-use-of-max-instead-of-handcrafted-one.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
kernel-compliment-va_copy-with-va_end.patch
git-dvb.patch
pcmcia-3c574_cs-fix-dubious-bitfield-warning.patch
pcmcia-3c574_cs-fix-shadow-variable-warning.patch
pcmcia-axnet_cs-make-functions-static.patch
pcmcia-axnet_cs-make-use-of-max-instead-of-handcrafted-one.patch
pcmcia-fmvj18x_cs-fix-shadow-variable-warning.patch
pcmcia-pcnet_cs-fix-shadow-variable-warning.patch
mm-mmap-remove-sparse-warning-null-as-0.patch
dio-array_size-cleanup-update.patch
dio-array_size-cleanup-update-checkpatch-fixes.patch
reiserfs-complement-va_start-with-va_end.patch
kernel-paramsc-remove-sparse-warning-different-signedness.patch
