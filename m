From: akpm@linux-foundation.org
Subject: - char-vt-use-array_size.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:06:30 -0700
Message-ID: <200707172306.l6HN6UmS012021@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40496 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762794AbXGQXPi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Char: vt, use ARRAY_SIZE
has been removed from the -mm tree.  Its filename was
     char-vt-use-array_size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: vt, use ARRAY_SIZE
From: Jiri Slaby <jirislaby@gmail.com>

vt, use ARRAY_SIZE

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/vt.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/char/vt.c~char-vt-use-array_size drivers/char/vt.c
--- a/drivers/char/vt.c~char-vt-use-array_size
+++ a/drivers/char/vt.c
@@ -1990,8 +1990,7 @@ static int is_double_width(uint32_t ucs)
 		{ 0xFE10, 0xFE19 }, { 0xFE30, 0xFE6F }, { 0xFF00, 0xFF60 },
 		{ 0xFFE0, 0xFFE6 }, { 0x20000, 0x2FFFD }, { 0x30000, 0x3FFFD }
 	};
-	return bisearch(ucs, double_width,
-		sizeof(double_width) / sizeof(*double_width) - 1);
+	return bisearch(ucs, double_width, ARRAY_SIZE(double_width) - 1);
 }
 
 /* acquires console_sem */
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
some-kmalloc-memset-kzalloc-tree-wide.patch
shrink_slab-handle-bad-shrinkers.patch
