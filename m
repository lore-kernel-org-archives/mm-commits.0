From: akpm@linux-foundation.org
Subject: + uml-remove-a-useless-function.patch added to -mm tree
Date: Mon, 14 Apr 2008 23:40:33 -0700
Message-ID: <200804150640.m3F6eXCU015141@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37873 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752453AbYDOGlI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Apr 2008 02:41:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiyou.wangcong@gmail.com, jdike@addtoit.com, wangcong@zeuux.org


The patch titled
     uml: remove a useless function
has been added to the -mm tree.  Its filename is
     uml-remove-a-useless-function.patch

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
Subject: uml: remove a useless function
From: WANG Cong <xiyou.wangcong@gmail.com>

arch/um/drivers/chan_kern.c::chan_out_fd() is not used by anyone.  Remove it.

Acked-by: Jeff Dike <jdike@addtoit.com>
Signed-off-by: WANG Cong <wangcong@zeuux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/chan_kern.c |   13 -------------
 arch/um/include/chan_kern.h |    1 -
 2 files changed, 14 deletions(-)

diff -puN arch/um/drivers/chan_kern.c~uml-remove-a-useless-function arch/um/drivers/chan_kern.c
--- a/arch/um/drivers/chan_kern.c~uml-remove-a-useless-function
+++ a/arch/um/drivers/chan_kern.c
@@ -583,19 +583,6 @@ int parse_chan_pair(char *str, struct li
 	return 0;
 }
 
-int chan_out_fd(struct list_head *chans)
-{
-	struct list_head *ele;
-	struct chan *chan;
-
-	list_for_each(ele, chans) {
-		chan = list_entry(ele, struct chan, list);
-		if (chan->primary && chan->output)
-			return chan->fd;
-	}
-	return -1;
-}
-
 void chan_interrupt(struct list_head *chans, struct delayed_work *task,
 		    struct tty_struct *tty, int irq)
 {
diff -puN arch/um/include/chan_kern.h~uml-remove-a-useless-function arch/um/include/chan_kern.h
--- a/arch/um/include/chan_kern.h~uml-remove-a-useless-function
+++ a/arch/um/include/chan_kern.h
@@ -44,7 +44,6 @@ extern void close_chan(struct list_head 
 extern int chan_window_size(struct list_head *chans, 
 			     unsigned short *rows_out, 
 			     unsigned short *cols_out);
-extern int chan_out_fd(struct list_head *chans);
 extern int chan_config_string(struct list_head *chans, char *str, int size,
 			      char **error_out);
 
_

Patches currently in -mm which might be from xiyou.wangcong@gmail.com are

uml-compile-error-fix.patch
git-hrt.patch
arch-um-kernel-um_archc-some-small-improvements.patch
arch-um-os-linux-start_upc-various-improvements.patch
uml-make-a-function-static.patch
uml-remove-a-useless-function.patch
uml-make-three-functions-static.patch
uml-make-several-things-static.patch
uml-clean-up-arch-um-drivers-ubd_kernc.patch
remove-the-macro-get_personality.patch
elf-fix-shadowed-variables-in-fs-binfmt_elfc.patch

