From: akpm@linux-foundation.org
Subject: + input-remove-unused-defines.patch added to -mm tree
Date: Tue, 06 May 2008 14:44:32 -0700
Message-ID: <200805062144.m46LiWfg028915@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48028 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763676AbYEFVp0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 May 2008 17:45:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, dtor@mail.ru


The patch titled
     input: remove unused defines
has been added to the -mm tree.  Its filename is
     input-remove-unused-defines.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
