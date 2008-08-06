From: akpm@linux-foundation.org
Subject: - fbcon-fix-scrolling-after-logo-is-cleared.patch removed from -mm tree
Date: Wed, 06 Aug 2008 13:56:53 -0700
Message-ID: <200808062056.m76KurCX014715@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56186 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756151AbYHFU5Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Aug 2008 16:57:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, mm-commits@vger.kernel.org


The patch titled
     fbcon: fix scrolling after logo is cleared
has been removed from the -mm tree.  Its filename was
     fbcon-fix-scrolling-after-logo-is-cleared.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fbcon: fix scrolling after logo is cleared
From: Krzysztof Helt <krzysztof.h1@wp.pl>

If the 'clear' command is used on the frame buffer with a logo the upper
area is filled by few lines but not scrolled anymore.

Fix this by removing the protected area for the logo if any part of the
logo is cleared.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/console/fbcon.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/video/console/fbcon.c~fbcon-fix-scrolling-after-logo-is-cleared drivers/video/console/fbcon.c
--- a/drivers/video/console/fbcon.c~fbcon-fix-scrolling-after-logo-is-cleared
+++ a/drivers/video/console/fbcon.c
@@ -1311,6 +1311,9 @@ static void fbcon_clear(struct vc_data *
 	if (!height || !width)
 		return;
 
+	if (sy < vc->vc_top && vc->vc_top == logo_lines)
+		vc->vc_top = 0;
+
 	/* Split blits that cross physical y_wrap boundary */
 
 	y_break = p->vrows - p->yscroll;
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

linux-next.patch
rtc-m48t59-reduce-structure-m48t59_private.patch
x86-fdiv-bug-detection-fix.patch
fb-convert-lock-unlock_kernel-into-local-fb-mutex.patch

