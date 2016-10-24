From: akpm@linux-foundation.org
Subject: + ipc-msg-make-msgrcv-work-with-long_min.patch added to -mm tree
Date: Mon, 24 Oct 2016 13:23:40 -0700
Message-ID: <580e6dcc.uoDdEDUigFc3Zy8F%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57235 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965254AbcJXUXl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Oct 2016 16:23:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jslaby@suse.cz, dave@stgolabs.net, manfred@colorfullife.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc: msg, make msgrcv work with LONG_MIN
has been added to the -mm tree.  Its filename is
     ipc-msg-make-msgrcv-work-with-long_min.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-msg-make-msgrcv-work-with-long_min.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-msg-make-msgrcv-work-with-long_min.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jiri Slaby <jslaby@suse.cz>
Subject: ipc: msg, make msgrcv work with LONG_MIN

When LONG_MIN is passed to msgrcv, one would expect to recieve any
message.  But convert_mode does *msgtyp = -*msgtyp and -LONG_MIN is
undefined.  In particular, with my gcc -LONG_MIN produces -LONG_MIN again.

So handle this case properly by assigning LONG_MAX to *msgtyp if LONG_MIN
was specified as msgtyp to msgrcv.

This code:
  long msg[] = { 100, 200 };
  int m = msgget(IPC_PRIVATE, IPC_CREAT | 0644);
  msgsnd(m, &msg, sizeof(msg), 0);
  msgrcv(m, &msg, sizeof(msg), LONG_MIN, 0);
produces currently nothing:
  msgget(IPC_PRIVATE, IPC_CREAT|0644)     = 65538
  msgsnd(65538, {100, "\310\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"}, 16, 0) = 0
  msgrcv(65538, ...

Except a UBSAN warning:
UBSAN: Undefined behaviour in ipc/msg.c:745:13
negation of -9223372036854775808 cannot be represented in type 'long int':

With the patch, I see what I expect:
  msgget(IPC_PRIVATE, IPC_CREAT|0644)     = 0
  msgsnd(0, {100, "\310\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"}, 16, 0) = 0
  msgrcv(0, {100, "\310\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"}, 16, -9223372036854775808, 0) = 16

Link: http://lkml.kernel.org/r/20161024082633.10148-1-jslaby@suse.cz
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN ipc/msg.c~ipc-msg-make-msgrcv-work-with-long_min ipc/msg.c
--- a/ipc/msg.c~ipc-msg-make-msgrcv-work-with-long_min
+++ a/ipc/msg.c
@@ -763,7 +763,10 @@ static inline int convert_mode(long *msg
 	if (*msgtyp == 0)
 		return SEARCH_ANY;
 	if (*msgtyp < 0) {
-		*msgtyp = -*msgtyp;
+		if (*msgtyp == LONG_MIN) /* -LONG_MIN is undefined */
+			*msgtyp = LONG_MAX;
+		else
+			*msgtyp = -*msgtyp;
 		return SEARCH_LESSEQUAL;
 	}
 	if (msgflg & MSG_EXCEPT)
_

Patches currently in -mm which might be from jslaby@suse.cz are

ipc-msg-make-msgrcv-work-with-long_min.patch

