From: akpm@linux-foundation.org
Subject: [patch 005/126] fbmon: remove unused function argument
Date: Tue, 26 Jul 2016 15:21:11 -0700
Message-ID: <5797e257.1qOPf+dGf8moglfc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56423 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757059AbcGZWVN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jul 2016 18:21:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, arnd@arndb.de, adobriyan@gmail.com, plagnioj@jcrosoft.com, tomi.valkeinen@ti.com

From: Arnd Bergmann <arnd@arndb.de>
Subject: fbmon: remove unused function argument

When building with "make W=1", we get a warning about an empty stub
function that does nothing but reassign its one of its arguments:

drivers/video/fbdev/core/fbmon.c: In function 'fb_edid_to_monspecs':
drivers/video/fbdev/core/fbmon.c:1497:67: error: parameter 'specs' set but not used [-Werror=unused-but-set-parameter]

We can simply make that function completely empty to avoid the warning.

This prevents a warning which everyone will see after "CFLAGS: add
-Wunused-but-set-parameter" is merged.

Link: http://lkml.kernel.org/r/20160715203229.1771162-1-arnd@arndb.de
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fbdev/core/fbmon.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/video/fbdev/core/fbmon.c~fbmon-remove-unused-function-argument drivers/video/fbdev/core/fbmon.c
--- a/drivers/video/fbdev/core/fbmon.c~fbmon-remove-unused-function-argument
+++ a/drivers/video/fbdev/core/fbmon.c
@@ -1496,7 +1496,6 @@ int fb_parse_edid(unsigned char *edid, s
 }
 void fb_edid_to_monspecs(unsigned char *edid, struct fb_monspecs *specs)
 {
-	specs = NULL;
 }
 void fb_edid_add_monspecs(unsigned char *edid, struct fb_monspecs *specs)
 {
_
