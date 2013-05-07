From: akpm@linux-foundation.org
Subject: + init-remove-permanent-string-buffer-from-do_one_initcall.patch added to -mm tree
Date: Tue, 07 May 2013 14:07:15 -0700
Message-ID: <20130507210715.70C4F31C071@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:46566 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753119Ab3EGVHQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 17:07:16 -0400
Received: by mail-gh0-f202.google.com with SMTP id g24so99733ghb.3
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 14:07:16 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rostedt@goodmis.org, geert@linux-m68k.org


The patch titled
     Subject: init: remove permanent string buffer from do_one_initcall()
has been added to the -mm tree.  Its filename is
     init-remove-permanent-string-buffer-from-do_one_initcall.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Steven Rostedt <rostedt@goodmis.org>
Subject: init: remove permanent string buffer from do_one_initcall()

do_one_initcall() uses a 64 byte string buffer to save a message. This
buffer is declared static and is only used at boot up and when a module
is loaded. As 64 bytes is very small, and this function has very limited
scope, there's no reason to waste permanent memory with this string and
not just simply put it on the stack.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN init/main.c~init-remove-permanent-string-buffer-from-do_one_initcall init/main.c
--- a/init/main.c~init-remove-permanent-string-buffer-from-do_one_initcall
+++ a/init/main.c
@@ -655,8 +655,6 @@ static void __init do_ctors(void)
 bool initcall_debug;
 core_param(initcall_debug, initcall_debug, bool, 0644);
 
-static char msgbuf[64];
