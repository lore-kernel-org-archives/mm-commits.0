From: akpm@linux-foundation.org
Subject: + remove-bits_to_type-macro.patch added to -mm tree
Date: Mon, 27 Aug 2007 15:27:25 -0700
Message-ID: <200708272227.l7RMRP12031791@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60781 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762926AbXH0W12 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Aug 2007 18:27:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     remove BITS_TO_TYPE macro
has been added to the -mm tree.  Its filename is
     remove-bits_to_type-macro.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: remove BITS_TO_TYPE macro
From: Jiri Slaby <jirislaby@gmail.com>

remove BITS_TO_TYPE macro

I realized, that it is actually the same as DIV_ROUND_UP, use it instead.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitops.h |    3 +--
 1 files changed, 1 insertion(+), 2 deletions(-)

diff -puN include/linux/bitops.h~remove-bits_to_type-macro include/linux/bitops.h
--- a/include/linux/bitops.h~remove-bits_to_type-macro
+++ a/include/linux/bitops.h
@@ -6,8 +6,7 @@
 #define BIT(nr)			(1UL << (nr))
 #define BIT_MASK(nr)		(1UL << ((nr) % BITS_PER_LONG))
 #define BIT_WORD(nr)		((nr) / BITS_PER_LONG)
-#define BITS_TO_TYPE(nr, t)	(((nr)+(t)-1)/(t))
-#define BITS_TO_LONGS(nr)	BITS_TO_TYPE(nr, BITS_PER_LONG)
+#define BITS_TO_LONGS(nr)	DIV_ROUND_UP(nr, BITS_PER_LONG)
 #define BITS_PER_BYTE		8
 #endif
 
_

Patches currently in -mm which might be from jirislaby@gmail.com are

maintainers-order-neterion-alphabetically.patch
ata-pata_marvell-use-ioread-for-iomap-ped-memory.patch
git-wireless.patch
net-ath5k-comment-some-eeprom-registers.patch
net-ath5k-initial-write-cleanup.patch
net-ath5k-use-short-preamble-for-some-rates.patch
net-ath5k-remove-some-ieee80211-re-defines.patch
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
