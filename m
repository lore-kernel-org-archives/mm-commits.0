From: akpm@linux-foundation.org
Subject: [merged] arch-um-drivers-linec-safely-iterate-over-list-of-winch-handlers.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:03:42 -0800
Message-ID: <201101132006.p0DK6Neh029742@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44990 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933405Ab1AMUHF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:07:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: will.newton@gmail.com, jdike@addtoit.com, richard.weinberger@gmail.com, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     arch/um/drivers/line.c: safely iterate over list of winch handlers
has been removed from the -mm tree.  Its filename was
     arch-um-drivers-linec-safely-iterate-over-list-of-winch-handlers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

