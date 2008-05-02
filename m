From: akpm@linux-foundation.org
Subject: + uml-fix-inconsistence-due-to-tty_operation-change.patch added to -mm tree
Date: Fri, 02 May 2008 05:15:45 -0700
Message-ID: <200805021215.m42CFjim025666@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45124 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934657AbYEBMQd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 08:16:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiyou.wangcong@gmail.com, jdike@addtoit.com, wangcong@zeuux.org


The patch titled
     uml: fix inconsistence due to tty_operation change
has been added to the -mm tree.  Its filename is
     uml-fix-inconsistence-due-to-tty_operation-change.patch

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
Subject: uml: fix inconsistence due to tty_operation change
From: WANG Cong <xiyou.wangcong@gmail.com>

'put_char' of 'struct tty_operations' has changed from 'void' into 'int'. 
This can also shut up comipler warnings.

Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: WANG Cong <wangcong@zeuux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/line.c |    4 ++--
 arch/um/include/line.h |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/um/drivers/line.c~uml-fix-inconsistence-due-to-tty_operation-change arch/um/drivers/line.c
--- a/arch/um/drivers/line.c~uml-fix-inconsistence-due-to-tty_operation-change
+++ a/arch/um/drivers/line.c
@@ -191,9 +191,9 @@ void line_flush_chars(struct tty_struct 
 	line_flush_buffer(tty);
 }
 
-void line_put_char(struct tty_struct *tty, unsigned char ch)
+int line_put_char(struct tty_struct *tty, unsigned char ch)
 {
-	line_write(tty, &ch, sizeof(ch));
+	return line_write(tty, &ch, sizeof(ch));
 }
 
 int line_write(struct tty_struct *tty, const unsigned char *buf, int len)
diff -puN arch/um/include/line.h~uml-fix-inconsistence-due-to-tty_operation-change arch/um/include/line.h
--- a/arch/um/include/line.h~uml-fix-inconsistence-due-to-tty_operation-change
+++ a/arch/um/include/line.h
@@ -71,7 +71,7 @@ extern int line_setup(struct line *lines
 		      char *init, char **error_out);
 extern int line_write(struct tty_struct *tty, const unsigned char *buf,
 		      int len);
-extern void line_put_char(struct tty_struct *tty, unsigned char ch);
+extern int line_put_char(struct tty_struct *tty, unsigned char ch);
 extern void line_set_termios(struct tty_struct *tty, struct ktermios * old);
 extern int line_chars_in_buffer(struct tty_struct *tty);
 extern void line_flush_buffer(struct tty_struct *tty);
_

Patches currently in -mm which might be from xiyou.wangcong@gmail.com are

origin.patch
uml-fix-inconsistence-due-to-tty_operation-change.patch

