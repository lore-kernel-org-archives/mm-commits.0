From: akpm@linux-foundation.org
Subject: - input-remove-unused-defines.patch removed from -mm tree
Date: Thu, 08 May 2008 12:31:53 -0700
Message-ID: <200805081931.m48JVr8X001905@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33148 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756163AbYEHTc4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 May 2008 15:32:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, dtor@mail.ru, mm-commits@vger.kernel.org


The patch titled
     input: remove unused defines
has been removed from the -mm tree.  Its filename was
     input-remove-unused-defines.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: input: remove unused defines
From: Joe Perches <joe@perches.com>

Remove unused to_dev, to_handler, to_handle from include/linux/input.h
Move to_handle_h from include/linux/input.h to drivers/char/keyboard.c

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/keyboard.c |    2 ++
 include/linux/input.h   |    5 -----
 2 files changed, 2 insertions(+), 5 deletions(-)

diff -puN drivers/char/keyboard.c~input-remove-unused-defines drivers/char/keyboard.c
--- a/drivers/char/keyboard.c~input-remove-unused-defines
+++ a/drivers/char/keyboard.c
@@ -46,6 +46,8 @@
 
 extern void ctrl_alt_del(void);
 
+#define to_handle_h(n) container_of(n, struct input_handle, h_node)
+
 /*
  * Exported functions/variables
  */
diff -puN include/linux/input.h~input-remove-unused-defines include/linux/input.h
--- a/include/linux/input.h~input-remove-unused-defines
+++ a/include/linux/input.h
@@ -1213,11 +1213,6 @@ struct input_handle {
 	struct list_head	h_node;
 };
 
-#define to_dev(n) container_of(n, struct input_dev, node)
-#define to_handler(n) container_of(n, struct input_handler, node)
-#define to_handle(n) container_of(n, struct input_handle, d_node)
-#define to_handle_h(n) container_of(n, struct input_handle, h_node)
