From: akpm@linux-foundation.org
Subject: - uvesafb-change-mode-parameter-to-mode_option.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:32:05 -0700
Message-ID: <200807242332.m6ONW5jg011795@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45502 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756693AbYGXXcH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:32:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, mm-commits@vger.kernel.org


The patch titled
     uvesafb: change mode parameter to mode_option
has been removed from the -mm tree.  Its filename was
     uvesafb-change-mode-parameter-to-mode_option.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uvesafb: change mode parameter to mode_option
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Make more drivers use the "mode_option" parameter.  This one is quite new
so drop the old "mode" parameter before someone starts using it seriously.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/uvesafb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/uvesafb.c~uvesafb-change-mode-parameter-to-mode_option drivers/video/uvesafb.c
--- a/drivers/video/uvesafb.c~uvesafb-change-mode-parameter-to-mode_option
+++ a/drivers/video/uvesafb.c
@@ -2054,8 +2054,8 @@ MODULE_PARM_DESC(maxhf,
 module_param(maxvf, ushort, 0);
 MODULE_PARM_DESC(maxvf,
 	"Maximum vertical frequency [Hz], overrides EDID data");
-module_param_named(mode, mode_option, charp, 0);
-MODULE_PARM_DESC(mode,
+module_param(mode_option, charp, 0);
+MODULE_PARM_DESC(mode_option,
 	"Specify initial video mode as \"<xres>x<yres>[-<bpp>][@<refresh>]\"");
 module_param(vbemode, ushort, 0);
 MODULE_PARM_DESC(vbemode,
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch

