From: akpm@linux-foundation.org
Subject: + fbmon-remove-unused-function-argument.patch added to -mm tree
Date: Fri, 15 Jul 2016 13:43:17 -0700
Message-ID: <57894ae5.swNFrUU+zTQuVLRe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37336 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565AbcGOUnS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jul 2016 16:43:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, adobriyan@gmail.com, plagnioj@jcrosoft.com, tomi.valkeinen@ti.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fbmon: remove unused function argument
has been added to the -mm tree.  Its filename is
     fbmon-remove-unused-function-argument.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fbmon-remove-unused-function-argument.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fbmon-remove-unused-function-argument.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from arnd@arndb.de are

fbmon-remove-unused-function-argument.patch
procfs-avoid-32-bit-time_t-in-proc-stat.patch
crc32-use-ktime_get_ns-for-measurement.patch
compat-remove-compat_printk.patch
nilfs2-replace-nilfs_warning-with-nilfs_msg-fix.patch

