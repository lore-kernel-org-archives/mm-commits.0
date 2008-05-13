From: akpm@linux-foundation.org
Subject: - spi-change-modalias-from-a-pointer-to-a-character-array.patch removed from -mm tree
Date: Mon, 12 May 2008 19:14:31 -0700
Message-ID: <200805130225.m4D2PVQ0020565@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33439 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756949AbYEMCZg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 May 2008 22:25:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: grant.likely@secretlab.ca, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     spi: change modalias from a pointer to a character array
has been removed from the -mm tree.  Its filename was
     spi-change-modalias-from-a-pointer-to-a-character-array.patch

This patch was dropped because it ran afoul of gregkh-driver-core-driver-core-remove-kobj_name_len-define.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spi: change modalias from a pointer to a character array
From: Grant Likely <grant.likely@secretlab.ca>

Currently, 'modalias' in the spi_device structure is a 'const char *'. 
The spi_new_device() function fills in the modalias value from a passed in
spi_board_info data block.  Since it is a pointer copy, the new spi_device
remains dependent on the spi_board_info structure after the new spi_device
is registered (no other fields in spi_device directly depend on the
spi_board_info structure; all of the other data is copied).

This causes a problem when dynamically populating the list of attached SPI
devices.  For example, in arch/powerpc, the list of SPI devices can be
populated from data in the device tree.  With the current code, the device
tree adapter must kmalloc() a new spi_board_info structure for each new
SPI device it finds in the device tree, and there is no simple mechanism
in place for keeping track of these allocations.

This patch changes modalias from a 'const char *' to a fixed char array. 
By copying the modalias string instead of referencing it, the dependency
on the spi_board_info structure is eliminated and an outside caller does
not need to maintain a separate spi_board_info allocation for each device.

I searched through the code to the best of my ability for any references
to modalias which may be affected by this change and haven't found
anything.  It has been tested with the lite5200b platform in arch/powerpc.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi.c       |    2 +-
 include/linux/spi/spi.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/spi/spi.c~spi-change-modalias-from-a-pointer-to-a-character-array drivers/spi/spi.c
--- a/drivers/spi/spi.c~spi-change-modalias-from-a-pointer-to-a-character-array
+++ a/drivers/spi/spi.c
@@ -229,7 +229,7 @@ struct spi_device *spi_new_device(struct
 	proxy->max_speed_hz = chip->max_speed_hz;
 	proxy->mode = chip->mode;
 	proxy->irq = chip->irq;
-	proxy->modalias = chip->modalias;
+	strncpy(proxy->modalias, chip->modalias, KOBJ_NAME_LEN);
 
 	snprintf(proxy->dev.bus_id, sizeof proxy->dev.bus_id,
 			"%s.%u", dev_name(&master->dev),
diff -puN include/linux/spi/spi.h~spi-change-modalias-from-a-pointer-to-a-character-array include/linux/spi/spi.h
--- a/include/linux/spi/spi.h~spi-change-modalias-from-a-pointer-to-a-character-array
+++ a/include/linux/spi/spi.h
@@ -82,7 +82,7 @@ struct spi_device {
 	int			irq;
 	void			*controller_state;
 	void			*controller_data;
-	const char		*modalias;
+	char			modalias[KOBJ_NAME_LEN];
 
 	/*
 	 * likely need more hooks for more protocol options affecting how
_

Patches currently in -mm which might be from grant.likely@secretlab.ca are

mpc5200_psc_spi-typo-fix-in-header-block.patch
spi-change-modalias-from-a-pointer-to-a-character-array.patch

