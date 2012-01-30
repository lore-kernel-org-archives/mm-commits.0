From: akpm@linux-foundation.org
Subject: + lkdtm-avoid-calling-lkdtm_do_action-with-spin-lock-held.patch added to -mm tree
Date: Mon, 30 Jan 2012 12:54:36 -0800
Message-ID: <20120130205436.9954BA0342@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:46560 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290Ab2A3Uyi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 30 Jan 2012 15:54:38 -0500
Received: by eaaf1 with SMTP id f1so216265eaa.1
        for <mm-commits@vger.kernel.org>; Mon, 30 Jan 2012 12:54:37 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiyou.wangcong@gmail.com, arnd@arndb.de, dyoung@redhat.com, greg@kroah.com, prarit@redhat.com


The patch titled
     Subject: lkdtm: avoid calling lkdtm_do_action() with spinlock held
has been added to the -mm tree.  Its filename is
     lkdtm-avoid-calling-lkdtm_do_action-with-spin-lock-held.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Cong Wang <xiyou.wangcong@gmail.com>
Subject: lkdtm: avoid calling lkdtm_do_action() with spinlock held

lkdtm_do_action() may call sleeping functions like kmalloc(), so do not
call it with spin lock held.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <greg@kroah.com>
Reviewed-by: Dave Young <dyoung@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/lkdtm.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN drivers/misc/lkdtm.c~lkdtm-avoid-calling-lkdtm_do_action-with-spin-lock-held drivers/misc/lkdtm.c
--- a/drivers/misc/lkdtm.c~lkdtm-avoid-calling-lkdtm_do_action-with-spin-lock-held
+++ a/drivers/misc/lkdtm.c
@@ -354,6 +354,7 @@ static void lkdtm_do_action(enum ctype w
 static void lkdtm_handler(void)
 {
 	unsigned long flags;
+	bool do_it = false;
 
 	spin_lock_irqsave(&count_lock, flags);
 	count--;
@@ -361,10 +362,13 @@ static void lkdtm_handler(void)
 			cp_name_to_str(cpoint), cp_type_to_str(cptype), count);
 
 	if (count == 0) {
-		lkdtm_do_action(cptype);
+		do_it = true;
 		count = cpoint_count;
 	}
 	spin_unlock_irqrestore(&count_lock, flags);
+
+	if (do_it)
+		lkdtm_do_action(cptype);
 }
 
 static int lkdtm_register_cpoint(enum cname which)
_
Subject: Subject: lkdtm: avoid calling lkdtm_do_action() with spinlock held

Patches currently in -mm which might be from xiyou.wangcong@gmail.com are

origin.patch
linux-next.patch
lkdtm-avoid-calling-lkdtm_do_action-with-spin-lock-held.patch
x86-mm-fix-the-size-calculation-of-mapping-tables.patch

