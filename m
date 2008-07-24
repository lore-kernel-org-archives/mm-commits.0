From: akpm@linux-foundation.org
Subject: - vt-do-not-update-when-the-console-is-blanked.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:28:42 -0700
Message-ID: <200807242328.m6ONSgJW011299@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43516 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756643AbYGXX3B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:29:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stefano.stabellini@eu.citrix.com, adaplas@pol.net, krzysztof.h1@poczta.fm, mm-commits@vger.kernel.org


The patch titled
     vt: do not update when the console is blanked
has been removed from the -mm tree.  Its filename was
     vt-do-not-update-when-the-console-is-blanked.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vt: do not update when the console is blanked
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

vt.c DO_UPDATE macro checks if the console is visible but doesn't check if
the console is blanked.

In fact updating fbcon while the console is blanked is not only
unnecessary but can even cause screen corruption.

Therefore I am adding a simple check on console_blanked in DO_UPDATE.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/vt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/vt.c~vt-do-not-update-when-the-console-is-blanked drivers/char/vt.c
--- a/drivers/char/vt.c~vt-do-not-update-when-the-console-is-blanked
+++ a/drivers/char/vt.c
@@ -261,7 +261,7 @@ static void notify_update(struct vc_data
 #ifdef VT_BUF_VRAM_ONLY
 #define DO_UPDATE(vc)	0
 #else
-#define DO_UPDATE(vc)	CON_IS_VISIBLE(vc)
+#define DO_UPDATE(vc)	(CON_IS_VISIBLE(vc) && !console_blanked)
 #endif
 
 static inline unsigned short *screenpos(struct vc_data *vc, int offset, int viewed)
_

Patches currently in -mm which might be from stefano.stabellini@eu.citrix.com are

origin.patch

