From: akpm@linux-foundation.org
Subject: [patch 81/96] ARM: HP Jornada 7XX: move inline before
 return type
Date: Wed, 12 Jul 2017 14:37:08 -0700
Message-ID: <20170712213708.lUb6ObiQs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55212 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754047AbdGLVhJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Jul 2017 17:37:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, joe@perches.com, linux@armlinux.org.uk, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Joe Perches <joe@perches.com>
Subject: ARM: HP Jornada 7XX: move inline before return type

Convert 'u8 inline' to 'inline u8' to be the same style used
by the rest of the kernel.

Miscellanea:

jornada_ssp_reverse is an odd function.
It is declared inline but is also EXPORT_SYMBOL.
It is also apparently only used by jornada720_ssp.c
Likely the EXPORT_SYMBOL could be removed and the function
converted to static.

The addition of static and removal of EXPORT_SYMBOL was not done.

Link: http://lkml.kernel.org/r/5bd3b2bf39c6c9caf773949f18158f8f5ec08582.1499284835.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Cc: Russell King <linux@armlinux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-sa1100/jornada720_ssp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/arm/mach-sa1100/jornada720_ssp.c~arm-hp-jornada-7xx-move-inline-before-return-type arch/arm/mach-sa1100/jornada720_ssp.c
--- a/arch/arm/mach-sa1100/jornada720_ssp.c~arm-hp-jornada-7xx-move-inline-before-return-type
+++ a/arch/arm/mach-sa1100/jornada720_ssp.c
@@ -33,7 +33,7 @@ static unsigned long jornada_ssp_flags;
  * we need to reverse all data we receive from the mcu due to its physical location
  * returns : 01110111 -> 11101110
  */
-u8 inline jornada_ssp_reverse(u8 byte)
+inline u8 jornada_ssp_reverse(u8 byte)
 {
 	return
 		((0x80 & byte) >> 7) |
_
