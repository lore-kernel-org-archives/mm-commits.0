From: akpm@linux-foundation.org
Subject: + dma-debug-switch-check-from-_text-to-_stext.patch added to -mm
 tree
Date: Mon, 04 Jan 2016 13:33:22 -0800
Message-ID: <568ae522.iITOE8AkpfsfgXnA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53109 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbcADVdX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Jan 2016 16:33:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: labbott@fedoraproject.org, arnd@arndb.de, keescook@chromium.org, linux@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: dma-debug: switch check from _text to _stext
has been added to the -mm tree.  Its filename is
     dma-debug-switch-check-from-_text-to-_stext.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dma-debug-switch-check-from-_text-to-_stext.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dma-debug-switch-check-from-_text-to-_stext.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

dma-debug-switch-check-from-_text-to-_stext.patch

