From: akpm@linux-foundation.org
Subject: + mmc_spi-fail-gracefully-if-host-or-card-do-not-support-the-switch-command.patch added to -mm tree
Date: Thu, 10 Sep 2009 15:34:38 -0700
Message-ID: <200909102234.n8AMYcRP024081__47073.2835973196$1252622178$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35198 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751304AbZIJWft (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Sep 2009 18:35:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wolfgang.mues@auerswald.de, linux-mmc@vger.kernel.org, stable@kernel.org


The patch titled
     mmc_spi: fail gracefully if host or card do not support the switch command
has been added to the -mm tree.  Its filename is
     mmc_spi-fail-gracefully-if-host-or-card-do-not-support-the-switch-command.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mmc_spi: fail gracefully if host or card do not support the switch command
From: Wolfgang Muees <wolfgang.mues@auerswald.de>

Some time ago, I have send a patch to the mmc_spi subsystem changing the
error codes.  This was after a discussion with Pierre about using EINVAL
only for non-recoverable errors.  This patch was accepted as

http://git.kernel.org/linus/fdd858db7113ca64132de390188d7ca00701013d

Unfortunately, several weeks later, I realized that this patch has opened
a little can of worms because there are SD cards on the market which

a) claim that they support the switch command
AND
b) refuse to execute this command if operating in SPI mode.

So, such a card would get unusuable in an embedded linux system in SPI
mode, because the init sequence terminates with an error.

This patch adds the missing error codes to the caller of the switch
command and restores the old behaviour to fail gracefully if these
commands can not execute.

Signed-off-by: Wolfgang Muees <wolfgang.mues@auerswald.de>
Cc: <linux-mmc@vger.kernel.org>
Cc: <stable@kernel.org>		[2.6.31.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/core/mmc.c |   10 +++++-----
 drivers/mmc/core/sd.c  |   10 +++++-----
 2 files changed, 10 insertions(+), 10 deletions(-)

diff -puN drivers/mmc/core/mmc.c~mmc_spi-fail-gracefully-if-host-or-card-do-not-support-the-switch-command drivers/mmc/core/mmc.c
--- a/drivers/mmc/core/mmc.c~mmc_spi-fail-gracefully-if-host-or-card-do-not-support-the-switch-command
+++ a/drivers/mmc/core/mmc.c
@@ -179,11 +179,11 @@ static int mmc_read_ext_csd(struct mmc_c
 
 	err = mmc_send_ext_csd(card, ext_csd);
 	if (err) {
-		/*
-		 * We all hosts that cannot perform the command
-		 * to fail more gracefully
-		 */
-		if (err != -EINVAL)
+		/* If the host or the card can't do the switch,
+		 * fail more gracefully. */
+		if ((err != -EINVAL)
+		 && (err != -ENOSYS)
+		 && (err != -EFAULT))
 			goto out;
 
 		/*
diff -puN drivers/mmc/core/sd.c~mmc_spi-fail-gracefully-if-host-or-card-do-not-support-the-switch-command drivers/mmc/core/sd.c
--- a/drivers/mmc/core/sd.c~mmc_spi-fail-gracefully-if-host-or-card-do-not-support-the-switch-command
+++ a/drivers/mmc/core/sd.c
@@ -210,11 +210,11 @@ static int mmc_read_switch(struct mmc_ca
 
 	err = mmc_sd_switch(card, 0, 0, 1, status);
 	if (err) {
-		/*
-		 * We all hosts that cannot perform the command
-		 * to fail more gracefully
-		 */
-		if (err != -EINVAL)
+		/* If the host or the card can't do the switch,
+		 * fail more gracefully. */
+		if ((err != -EINVAL)
+		 && (err != -ENOSYS)
+		 && (err != -EFAULT))
 			goto out;
 
 		printk(KERN_WARNING "%s: problem reading switch "
_

Patches currently in -mm which might be from wolfgang.mues@auerswald.de are

mmc_spi-fail-gracefully-if-host-or-card-do-not-support-the-switch-command.patch

