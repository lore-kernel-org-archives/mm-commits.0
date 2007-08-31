From: akpm@linux-foundation.org
Subject: + v4l-stk11xx-use-array_size-in-another-2-cases.patch added to -mm tree
Date: Fri, 31 Aug 2007 11:41:42 -0700
Message-ID: <200708311841.l7VIfgo9021263@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59353 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965908AbXHaSly (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 31 Aug 2007 14:41:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, mchehab@infradead.org


The patch titled
     V4L: stk11xx, use ARRAY_SIZE in another 2 cases
has been added to the -mm tree.  Its filename is
     v4l-stk11xx-use-array_size-in-another-2-cases.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: V4L: stk11xx, use ARRAY_SIZE in another 2 cases
From: Jiri Slaby <jirislaby@gmail.com>

There were 2 places with constant in for loop.  Use ARRARY_SIZE instead to
allow easy update of the tables.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/stk1125.c |    2 +-
 drivers/media/video/stk1135.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/media/video/stk1125.c~v4l-stk11xx-use-array_size-in-another-2-cases drivers/media/video/stk1125.c
--- a/drivers/media/video/stk1125.c~v4l-stk11xx-use-array_size-in-another-2-cases
+++ a/drivers/media/video/stk1125.c
@@ -80,7 +80,7 @@ static int stk1125_load_microcode(struct
 		break;
 	}
 
-	for (i = 0; i < 59; i++) {
+	for (i = 0; i < ARRAY_SIZE(values_1_204); i++) {
 		stk11xx_read_dummy(dev, 0x02ff);
 		stk11xx_write_reg(dev, 0x02ff, 0x00);
 
diff -puN drivers/media/video/stk1135.c~v4l-stk11xx-use-array_size-in-another-2-cases drivers/media/video/stk1135.c
--- a/drivers/media/video/stk1135.c~v4l-stk11xx-use-array_size-in-another-2-cases
+++ a/drivers/media/video/stk1135.c
@@ -53,7 +53,7 @@ static int stk1135_load_microcode(struct
 		0xe4, 0x09, 0xc8, 0x08, 0x08, 0x10, 0x14
 	};
 
-	for (i = 0; i < 117; i++) {
+	for (i = 0; i < ARRAY_SIZE(values_204); i++) {
 		stk11xx_read_dummy(dev, 0x02ff);
 		stk11xx_write_reg(dev, 0x02ff, 0x00);
 
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
v4l-stk11xx-add-a-new-webcam-driver.patch
v4l-stk11xx-use-array_size-in-another-2-cases.patch
v4l-stk11xx-use-retval-from-stk11xx_check_device.patch
v4l-stk11xx-add-static-to-tables.patch
ata-pata_marvell-use-ioread-for-iomap-ped-memory.patch
git-net.patch
git-wireless.patch
net-add-ath5k-wireless-driver-fix.patch
epcac-reformat-comments-and-coding-style-improvements.patch
char-mxser_new-upgrade-to-110.patch
char-mxser_new-move-to-pci_vdevice.patch
char-mxser_new-remove-useless-comments-in-mxser_cards.patch
mxser-remove-commented-crap.patch
char-moxa-fix-and-optimise-empty-timer.patch
char-cyclades-remove-bottom-half-processing.patch
char-cyclades-make-the-isr-code-readable.patch
char-cyclades-move-spin_lock-to-one-place.patch
char-cyclades-fix-some-w-warnings.patch
char-moxa-cleanup-prints.patch
char-moxa-function-names-cleanup.patch
char-moxa-remove-sleep_on.patch
fs-select-remove-unused-macros.patch
cyber2000fb-rename-bit-macro.patch
i2c-pxa-rename-bit-macro-to-pxa_bit.patch
s2io-rename-bit-macro.patch
amba-pl011-rename-bit-macro.patch
define-first-set-of-bit-macros.patch
get-rid-of-input-bit-duplicate-defines.patch
define-global-bit-macro.patch
flashpoint-use-bit-instead-of-bitw.patch
remove-bits_to_type-macro.patch
shrink_slab-handle-bad-shrinkers.patch
