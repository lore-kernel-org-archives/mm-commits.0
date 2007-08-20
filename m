From: akpm@linux-foundation.org
Subject: + fs-select-remove-unused-macros.patch added to -mm tree
Date: Mon, 20 Aug 2007 13:42:22 -0700
Message-ID: <200708202042.l7KKgMx7022224@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37482 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764564AbXHTUnL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Aug 2007 16:43:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     fs/select, remove unused macros
has been added to the -mm tree.  Its filename is
     fs-select-remove-unused-macros.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fs/select, remove unused macros
From: Jiri Slaby <jirislaby@gmail.com>

fs/select, remove unused macros

this is due to preparation for global BIT macro

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/select.c |    5 -----
 1 files changed, 5 deletions(-)

diff -puN fs/select.c~fs-select-remove-unused-macros fs/select.c
--- a/fs/select.c~fs-select-remove-unused-macros
+++ a/fs/select.c
@@ -179,11 +179,6 @@ get_max:
 	return max;
 }
 
-#define BIT(i)		(1UL << ((i)&(__NFDBITS-1)))
-#define MEM(i,m)	((m)+(unsigned)(i)/__NFDBITS)
-#define ISSET(i,m)	(((i)&*(m)) != 0)
-#define SET(i,m)	(*(m) |= (i))
-
 #define POLLIN_SET (POLLRDNORM | POLLRDBAND | POLLIN | POLLHUP | POLLERR)
 #define POLLOUT_SET (POLLWRBAND | POLLWRNORM | POLLOUT | POLLERR)
 #define POLLEX_SET (POLLPRI)
_

Patches currently in -mm which might be from jirislaby@gmail.com are

net-add-ath5k-wireless-driver.patch
net-add-ath5k-wireless-driver-fix.patch
epcac-reformat-comments-and-coding-style-improvements.patch
char-mxser_new-upgrade-to-110.patch
char-mxser_new-move-to-pci_vdevice.patch
char-mxser_new-remove-useless-comments-in-mxser_cards.patch
char-moxa-fix-and-optimise-empty-timer.patch
char-cyclades-remove-bottom-half-processing.patch
char-cyclades-make-the-isr-code-readable.patch
char-cyclades-move-spin_lock-to-one-place.patch
char-cyclades-fix-some-w-warnings.patch
fs-select-remove-unused-macros.patch
cyber2000fb-rename-bit-macro.patch
i2c-pxa-rename-bit-macro-to-pxa_bit.patch
s2io-rename-bit-macro.patch
amba-pl011-rename-bit-macro.patch
define-first-set-of-bit-macros.patch
get-rid-of-input-bit-duplicate-defines.patch
define-global-bit-macro.patch
flashpoint-use-bit-instead-of-bitw.patch
shrink_slab-handle-bad-shrinkers.patch
