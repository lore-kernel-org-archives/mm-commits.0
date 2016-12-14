From: akpm@linux-foundation.org
Subject: [patch 043/114] ipc: msg, make msgrcv work with LONG_MIN
Date: Wed, 14 Dec 2016 15:06:07 -0800
Message-ID: <5851d05f.0UqRXDIZvLaG4scD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34800 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754673AbcLNXGY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 18:06:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, jslaby@suse.cz, dave@stgolabs.net, manfred@colorfullife.com

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
