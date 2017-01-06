From: akpm@linux-foundation.org
Subject: + fonts-keep-non-sparc-fonts-listed-together.patch added to -mm
 tree
Date: Fri, 06 Jan 2017 14:39:25 -0800
Message-ID: <58701c9d.2PNrh59WIaN6y8S4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58414 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755438AbdAFWiF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 6 Jan 2017 17:38:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rdunlap@infradead.org, geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/fonts/Kconfig: keep non-Sparc fonts listed together
has been added to the -mm tree.  Its filename is
     fonts-keep-non-sparc-fonts-listed-together.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fonts-keep-non-sparc-fonts-listed-together.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fonts-keep-non-sparc-fonts-listed-together.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: lib/fonts/Kconfig: keep non-Sparc fonts listed together

Keep fonts together and indented (in menu) as much as possible.
This moves the Sparc font choices to the end of the menu since they
have different dependencies.

Link: http://lkml.kernel.org/r/de6d8977-c6d6-a82d-c953-f2a2fefdb8a5@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/fonts/Kconfig |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN lib/fonts/Kconfig~fonts-keep-non-sparc-fonts-listed-together lib/fonts/Kconfig
--- a/lib/fonts/Kconfig~fonts-keep-non-sparc-fonts-listed-together
+++ a/lib/fonts/Kconfig
@@ -87,6 +87,14 @@ config FONT_6x10
 	  embedded devices with a 320x240 screen, to get a reasonable number
 	  of characters (53x24) that are still at a readable size.
 
+config FONT_10x18
+	bool "console 10x18 font (not supported by all drivers)" if FONTS
+	depends on FRAMEBUFFER_CONSOLE
+	help
+	  This is a high resolution console font for machines with very
+	  big letters. It fits between the sun 12x22 and the normal 8x16 font.
+	  If other fonts are too big or too small for you, say Y, otherwise say N.
+
 config FONT_SUN8x16
 	bool "Sparc console 8x16 font"
 	depends on FRAMEBUFFER_CONSOLE && (!SPARC && FONTS || SPARC)
@@ -101,14 +109,6 @@ config FONT_SUN12x22
 	  big letters (like the letters used in the SPARC PROM). If the
 	  standard font is unreadable for you, say Y, otherwise say N.
 
-config FONT_10x18
-	bool "console 10x18 font (not supported by all drivers)" if FONTS
-	depends on FRAMEBUFFER_CONSOLE
-	help
-	  This is a high resolution console font for machines with very
-	  big letters. It fits between the sun 12x22 and the normal 8x16 font.
-	  If other fonts are too big or too small for you, say Y, otherwise say N.
