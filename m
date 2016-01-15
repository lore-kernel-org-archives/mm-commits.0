From: akpm@linux-foundation.org
Subject: [merged] dma-debug-switch-check-from-_text-to-_stext.patch
 removed from -mm tree
Date: Fri, 15 Jan 2016 14:31:12 -0800
Message-ID: <56997330.6zZo6FSlLNrIamxe%akpm__13264.7338127301$1452897092$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58946 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586AbcAOWbN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jan 2016 17:31:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: labbott@fedoraproject.org, arnd@arndb.de, keescook@chromium.org, linux@arm.linux.org.uk, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: dma-debug: switch check from _text to _stext
has been removed from the -mm tree.  Its filename was
     dma-debug-switch-check-from-_text-to-_stext.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Laura Abbott <labbott@fedoraproject.org>
Subject: dma-debug: switch check from _text to _stext

In include/asm-generic/sections.h:

/*
 * Usage guidelines:
 * _text, _data: architecture specific, don't use them in
 * arch-independent code
 * [_stext, _etext]: contains .text.* sections, may also contain
 * .rodata.*
 *                   and/or .init.* sections

_text is not guaranteed across architectures.  Architectures such as ARM
may reuse parts which are not actually text and erroneously trigger a bug.
Switch to using _stext which is guaranteed to contain text sections.

Came out of https://lkml.kernel.org/g/<567B1176.4000106@redhat.com>

Signed-off-by: Laura Abbott <labbott@fedoraproject.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/dma-debug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/dma-debug.c~dma-debug-switch-check-from-_text-to-_stext lib/dma-debug.c
--- a/lib/dma-debug.c~dma-debug-switch-check-from-_text-to-_stext
+++ a/lib/dma-debug.c
@@ -1181,7 +1181,7 @@ static inline bool overlap(void *addr, u
 
 static void check_for_illegal_area(struct device *dev, void *addr, unsigned long len)
 {
-	if (overlap(addr, len, _text, _etext) ||
+	if (overlap(addr, len, _stext, _etext) ||
 	    overlap(addr, len, __start_rodata, __end_rodata))
 		err_printk(dev, NULL, "DMA-API: device driver maps memory from kernel text or rodata [addr=%p] [len=%lu]\n", addr, len);
 }
_

Patches currently in -mm which might be from labbott@fedoraproject.org are


