From: akpm@linux-foundation.org
Subject: + lib-kconfigdebug-clarify-config_debug_infos-bloaty-nature.patch added to -mm tree
Date: Mon, 03 Feb 2014 13:22:58 -0800
Message-ID: <52f008b2.y0et87702oWogsu4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46744 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195AbaBCVW6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Feb 2014 16:22:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, bp@suse.de

Subject: + lib-kconfigdebug-clarify-config_debug_infos-bloaty-nature.patch added to -mm tree
To: bp@suse.de
From: akpm@linux-foundation.org
Date: Mon, 03 Feb 2014 13:22:58 -0800


The patch titled
     Subject: lib/Kconfig.debug: clarify CONFIG_DEBUG_INFO's bloaty nature
has been added to the -mm tree.  Its filename is
     lib-kconfigdebug-clarify-config_debug_infos-bloaty-nature.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-kconfigdebug-clarify-config_debug_infos-bloaty-nature.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-kconfigdebug-clarify-config_debug_infos-bloaty-nature.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Borislav Petkov <bp@suse.de>
Subject: lib/Kconfig.debug: clarify CONFIG_DEBUG_INFO's bloaty nature

Hold down when it makes sense to enable CONFIG_DEBUG_INFO and when
CONFIG_KALLSYMS suffices.

Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN lib/Kconfig.debug~lib-kconfigdebug-clarify-config_debug_infos-bloaty-nature lib/Kconfig.debug
--- a/lib/Kconfig.debug~lib-kconfigdebug-clarify-config_debug_infos-bloaty-nature
+++ a/lib/Kconfig.debug
@@ -126,7 +126,11 @@ config DEBUG_INFO
 	  This adds debug symbols to the kernel and modules (gcc -g), and
 	  is needed if you intend to use kernel crashdump or binary object
 	  tools like crash, kgdb, LKCD, gdb, etc on the kernel.
-	  Say Y here only if you plan to debug the kernel.
+
+	  If you only want to have resolved symbols in kernel traces and
+	  are not going to need support for those tools above, you don't need
+	  to enable this as it is a huge bloat and build slowdown;
+	  enable CONFIG_KALLSYMS instead.
 
 	  If unsure, say N.
 
_

Patches currently in -mm which might be from bp@suse.de are

lib-kconfigdebug-clarify-config_debug_infos-bloaty-nature.patch
linux-next.patch

