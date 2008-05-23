From: akpm@linux-foundation.org
Subject: + spi-make-spi_board_infomodalias-a-char-array.patch added to -mm tree
Date: Fri, 23 May 2008 11:29:53 -0700
Message-ID: <200805231829.m4NITrgk002974@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36020 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752903AbYEWSac (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 23 May 2008 14:30:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: grant.likely@secretlab.ca, dbrownell@users.sourceforge.net


The patch titled
     spi: make spi_board_info.modalias a char array
has been added to the -mm tree.  Its filename is
     spi-make-spi_board_infomodalias-a-char-array.patch

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
Subject: spi: make spi_board_info.modalias a char array
From: Grant Likely <grant.likely@secretlab.ca>

Currently, 'modalias' in the spi_device structure is a 'const char *'. 
The spi_new_device() function fills in the modalias value from a passed in
spi_board_info data block.  Since it is a pointer copy, the new spi_device
remains dependent on the spi_board_info structure after the new spi_device
is registered (no other fields in spi_device directly depend on the
spi_board_info structure; all of the other data is copied).

This causes a problem when dynamically propulating the list of attached
SPI devices.  For example, in arch/powerpc, the list of SPI devices can be
populated from data in the device tree.  With the current code, the device
tree adapter must kmalloc() a new spi_board_info structure for each new
SPI device it finds in the device tree, and there is no simple mechanism
in place for keeping track of these allocations.

This patch changes modalias from a 'const char *' to a fixed char array. 
By copying the modalias string instead of referencing it, the dependency
on the spi_board_info structure is eliminated and an outside caller does
not need to maintain a separate spi_board_info allocation for each device.

If searched through the code to the best of my ability for any references
to modalias which may be affected by this change and haven't found
anything.  It has been tested with the lite5200b platform in arch/powerpc.

[dbrownell@users.sourceforge.net: cope with linux-next changes: KOBJ_NAME_LEN obliterated, etc]
Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi.c       |    4 +++-
 include/linux/spi/spi.h |    2 +-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/spi/spi.c~spi-make-spi_board_infomodalias-a-char-array drivers/spi/spi.c
--- a/drivers/spi/spi.c~spi-make-spi_board_infomodalias-a-char-array
+++ a/drivers/spi/spi.c
@@ -218,6 +218,8 @@ struct spi_device *spi_new_device(struct
 	if (!spi_master_get(master))
 		return NULL;
 
+	WARN_ON(strlen(chip->modalias) >= sizeof(proxy->modalias));
+
 	proxy = kzalloc(sizeof *proxy, GFP_KERNEL);
 	if (!proxy) {
 		dev_err(dev, "can't alloc dev for cs%d\n",
@@ -229,7 +231,7 @@ struct spi_device *spi_new_device(struct
 	proxy->max_speed_hz = chip->max_speed_hz;
 	proxy->mode = chip->mode;
 	proxy->irq = chip->irq;
-	proxy->modalias = chip->modalias;
+	strlcpy(proxy->modalias, chip->modalias, sizeof(proxy->modalias));
 
 	snprintf(proxy->dev.bus_id, sizeof proxy->dev.bus_id,
 			"%s.%u", master->dev.bus_id,
diff -puN include/linux/spi/spi.h~spi-make-spi_board_infomodalias-a-char-array include/linux/spi/spi.h
--- a/include/linux/spi/spi.h~spi-make-spi_board_infomodalias-a-char-array
+++ a/include/linux/spi/spi.h
@@ -82,7 +82,7 @@ struct spi_device {
 	int			irq;
 	void			*controller_state;
 	void			*controller_data;
-	const char		*modalias;
+	char			modalias[32];
 
 	/*
 	 * likely need more hooks for more protocol options affecting how
_

Patches currently in -mm which might be from grant.likely@secretlab.ca are

spi-make-spi_board_infomodalias-a-char-array.patch
linux-next.patch
fec_mpc52xx-mpc52xx_messages_default-2nd-netif_msg_ifdown-=-ifup.patch

