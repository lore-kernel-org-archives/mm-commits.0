From: akpm@linux-foundation.org
Subject: - uml-make-a-function-static.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:54:54 -0700
Message-ID: <200804282154.m3SLssJZ018049@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48417 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935873AbYD1Vy5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:54:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiyou.wangcong@gmail.com, jdike@addtoit.com, wangcong@zeuux.org, mm-commits@vger.kernel.org


The patch titled
     uml: make a function static
has been removed from the -mm tree.  Its filename was
     uml-make-a-function-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: make a function static
From: WANG Cong <xiyou.wangcong@gmail.com>

arch/um/drivers/chan_kern.c::open_chan() can become static.

Acked-by: Jeff Dike <jdike@addtoit.com>
Signed-off-by: WANG Cong <wangcong@zeuux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/chan_kern.c |    2 +-
 arch/um/include/chan_kern.h |    1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff -puN arch/um/drivers/chan_kern.c~uml-make-a-function-static arch/um/drivers/chan_kern.c
--- a/arch/um/drivers/chan_kern.c~uml-make-a-function-static
+++ a/arch/um/drivers/chan_kern.c
@@ -125,7 +125,7 @@ static int open_one_chan(struct chan *ch
 	return 0;
 }
 
-int open_chan(struct list_head *chans)
+static int open_chan(struct list_head *chans)
 {
 	struct list_head *ele;
 	struct chan *chan;
diff -puN arch/um/include/chan_kern.h~uml-make-a-function-static arch/um/include/chan_kern.h
--- a/arch/um/include/chan_kern.h~uml-make-a-function-static
+++ a/arch/um/include/chan_kern.h
@@ -31,7 +31,6 @@ extern void chan_interrupt(struct list_h
 			   struct tty_struct *tty, int irq);
 extern int parse_chan_pair(char *str, struct line *line, int device,
 			   const struct chan_opts *opts, char **error_out);
-extern int open_chan(struct list_head *chans);
 extern int write_chan(struct list_head *chans, const char *buf, int len,
 			     int write_irq);
 extern int console_write_chan(struct list_head *chans, const char *buf, 
_

Patches currently in -mm which might be from xiyou.wangcong@gmail.com are

origin.patch
remove-the-macro-get_personality.patch
elf-fix-shadowed-variables-in-fs-binfmt_elfc.patch

