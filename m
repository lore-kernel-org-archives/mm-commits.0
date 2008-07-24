From: akpm@linux-foundation.org
Subject: - vfb-only-enable-if-explicitly-requested-when-compiled-in.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:32:18 -0700
Message-ID: <200807242332.m6ONWIfS011824@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34507 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756815AbYGXXcX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:32:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: elendil@planet.nl, adaplas@gmail.com, krzysztof.h1@wp.pl, mm-commits@vger.kernel.org


The patch titled
     vfb: only enable if explicitly requested when compiled in
has been removed from the -mm tree.  Its filename was
     vfb-only-enable-if-explicitly-requested-when-compiled-in.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfb: only enable if explicitly requested when compiled in
From: Frans Pop <elendil@planet.nl>

The Kconfig help for the vfb driver says:
   Do NOT enable it for normal systems! To protect the innocent, it
   has to be enabled explicitly at boot time using the kernel option
   `video=vfb:'.

This change lets the code match the description.

Support for vfb:disable is kept for backwards compatibility; vfb:off works
because it is tested at a higher level.

Note: any undefined option (e.g. vfb:enable) will also enable this driver.

The relevant code has been unchanged since before the migration to
git (2.6.12).

This patch fixes bugzilla #9310 and was the root cause behind
http://lkml.org/lkml/2008/5/31/220.

Signed-off-by: Frans Pop <elendil@planet.nl>
Cc: Antonino A. Daplas <adaplas@gmail.com>
Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/vfb.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff -puN drivers/video/vfb.c~vfb-only-enable-if-explicitly-requested-when-compiled-in drivers/video/vfb.c
--- a/drivers/video/vfb.c~vfb-only-enable-if-explicitly-requested-when-compiled-in
+++ a/drivers/video/vfb.c
@@ -443,19 +443,29 @@ static int vfb_mmap(struct fb_info *info
 }
 
 #ifndef MODULE
+/*
+ * The virtual framebuffer driver is only enabled if explicitly
+ * requested by passing 'video=vfb:' (or any actual options).
+ */
 static int __init vfb_setup(char *options)
 {
 	char *this_opt;
 
+	vfb_enable = 0;
+
+	if (!options)
+		return 1;
+
 	vfb_enable = 1;
 
-	if (!options || !*options)
+	if (!*options)
 		return 1;
 
 	while ((this_opt = strsep(&options, ",")) != NULL) {
 		if (!*this_opt)
 			continue;
-		if (!strncmp(this_opt, "disable", 7))
+		/* Test disable for backwards compatibility */
+		if (!strcmp(this_opt, "disable"))
 			vfb_enable = 0;
 	}
 	return 1;
_

Patches currently in -mm which might be from elendil@planet.nl are

origin.patch

