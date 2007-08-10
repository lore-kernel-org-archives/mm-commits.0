From: akpm@linux-foundation.org
Subject: - fbcon-kill-compile-warning-fix.patch removed from -mm tree
Date: Fri, 10 Aug 2007 12:44:51 -0700
Message-ID: <200708101944.l7AJip6K005246@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46348 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758545AbXHJTpT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Aug 2007 15:45:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fbcon-kill-compile-warning-fix
has been removed from the -mm tree.  Its filename was
     fbcon-kill-compile-warning-fix.patch

This patch was dropped because it was folded into fbcon-kill-compile-warning.patch

------------------------------------------------------
Subject: fbcon-kill-compile-warning-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: "Antonino A. Daplas" <adaplas@gmail.com>
Cc: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/console/fbcon.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/video/console/fbcon.c~fbcon-kill-compile-warning-fix drivers/video/console/fbcon.c
--- a/drivers/video/console/fbcon.c~fbcon-kill-compile-warning-fix
+++ a/drivers/video/console/fbcon.c
@@ -136,7 +136,9 @@ static inline void fbcon_map_override(vo
 	map_override = 1;
 }
 #else
-#define fbcon_map_override(...) do { } while (0)
+static inline void fbcon_map_override(void)
+{
+}
 #endif /* CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY */
 
 /* font data */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

fbcon-kill-compile-warning.patch
fbcon-kill-compile-warning-fix.patch
fix-serial-buffer-memory-leak-fix.patch
mtdchar-build-fix.patch
fix-compilation-with-gcc-42-fix.patch
