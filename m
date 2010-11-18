From: akpm@linux-foundation.org
Subject: + arch-um-drivers-linec-safely-iterate-over-list-of-winch-handlers.patch added to -mm tree
Date: Thu, 18 Nov 2010 12:46:49 -0800
Message-ID: <201011182046.oAIKkn45004244@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49041 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758877Ab0KRUrZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Nov 2010 15:47:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: will.newton@gmail.com, jdike@addtoit.com, richard.weinberger@gmail.com, xiyou.wangcong@gmail.com


The patch titled
     arch/um/drivers/line.c: safely iterate over list of winch handlers
has been added to the -mm tree.  Its filename is
     arch-um-drivers-linec-safely-iterate-over-list-of-winch-handlers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arch/um/drivers/line.c: safely iterate over list of winch handlers
From: Will Newton <will.newton@gmail.com>

unregister_winch() should use list_for_each_safe(), as it can delete from
the list.

Signed-off-by: Will Newton <will.newton@gmail.com>
Cc: richard -rw- weinberger <richard.weinberger@gmail.com>
Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/line.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/um/drivers/line.c~arch-um-drivers-linec-safely-iterate-over-list-of-winch-handlers arch/um/drivers/line.c
--- a/arch/um/drivers/line.c~arch-um-drivers-linec-safely-iterate-over-list-of-winch-handlers
+++ a/arch/um/drivers/line.c
@@ -821,12 +821,12 @@ void register_winch_irq(int fd, int tty_
 
 static void unregister_winch(struct tty_struct *tty)
 {
-	struct list_head *ele;
+	struct list_head *ele, *next;
 	struct winch *winch;
 
 	spin_lock(&winch_handler_lock);
 
-	list_for_each(ele, &winch_handlers) {
+	list_for_each_safe(ele, next, &winch_handlers) {
 		winch = list_entry(ele, struct winch, list);
 		if (winch->tty == tty) {
 			free_winch(winch, 1);
_

Patches currently in -mm which might be from will.newton@gmail.com are

uml-disable-winch-irq-before-freeing-handler-data.patch
arch-um-drivers-linec-safely-iterate-over-list-of-winch-handlers.patch

