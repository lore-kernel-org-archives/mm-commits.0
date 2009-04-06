From: akpm@linux-foundation.org
Subject: [merged] xtensa-make-startup-code-discardable.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:39:30 -0700
Message-ID: <200904061939.n36JdUXw013919@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53910 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757533AbZDFTmS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:42:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dg@emlix.com, chris@zankel.net, mm-commits@vger.kernel.org


The patch titled
     xtensa: make startup code discardable
has been removed from the -mm tree.  Its filename was
     xtensa-make-startup-code-discardable.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: xtensa: make startup code discardable
=46rom: Daniel Gl=F6ckner <dg@emlix.com>

Move it from .text to .init.text to get rid of it after boot and
prevent illegal section references.

Signed-off-by: Daniel Gl=F6ckner <dg@emlix.com>
Cc: Chris Zankel <chris@zankel.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/kernel/head.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/xtensa/kernel/head.S~xtensa-make-startup-code-discardabl=
e arch/xtensa/kernel/head.S
--- a/arch/xtensa/kernel/head.S~xtensa-make-startup-code-discardable
+++ a/arch/xtensa/kernel/head.S
@@ -53,7 +53,7 @@ _start:	_j	2f
 2:	l32r	a0, 1b
 	jx	a0
=20
-	.text
+	.section .init.text, "ax"
 	.align 4
 _startup:
=20
_

Patches currently in -mm which might be from dg@emlix.com are

origin.patch
linux-next.patch
xtensa-variant-specific-code.patch
xtensa-cache-inquiry-and-unaligned-cache-handling-functions.patch
xtensa-s6000-dma-engine-support.patch
xtensa-allow-platform-and-variant-to-initialize-own-irq-chips.patch
xtensa-support-s6000-gpio-irqs-and-alternate-function-selection.patch
s6gmac-xtensa-s6000-on-chip-ethernet-driver.patch
xtensa-s6105-specific-configuration-for-s6gmac.patch
xtensa-enable-s6gmac-in-s6105_defconfig.patch
xtensa-add-m41t62-rtc-to-s6105-platform.patch
xtensa-enable-m41t80-driver-in-s6105_defconfig.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
