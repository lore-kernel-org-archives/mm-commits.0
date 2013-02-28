From: akpm@linux-foundation.org
Subject: + ipc-fix-potential-oops-when-src-msg-4k-w-msg_copy.patch added to -mm tree
Date: Thu, 28 Feb 2013 15:47:13 -0800
Message-ID: <20130228234714.2DFBC31C0A0@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:53438 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132Ab3B1XrP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 18:47:15 -0500
Received: by mail-gg0-f202.google.com with SMTP id l4so272442ggi.1
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 15:47:14 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: peter@hurleysoftware.com, skinsbursky@parallels.com, stable@vger.kernel.org


The patch titled
     Subject: ipc: fix potential oops when src msg > 4k w/ MSG_COPY
has been added to the -mm tree.  Its filename is
     ipc-fix-potential-oops-when-src-msg-4k-w-msg_copy.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Peter Hurley <peter@hurleysoftware.com>
Subject: ipc: fix potential oops when src msg > 4k w/ MSG_COPY

If the src msg is > 4k, then dest->next points to the
next allocated segment; resetting it just prior to dereferencing
is bad.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
Acked-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msgutil.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN ipc/msgutil.c~ipc-fix-potential-oops-when-src-msg-4k-w-msg_copy ipc/msgutil.c
--- a/ipc/msgutil.c~ipc-fix-potential-oops-when-src-msg-4k-w-msg_copy
+++ a/ipc/msgutil.c
@@ -117,9 +117,6 @@ struct msg_msg *copy_msg(struct msg_msg 
 	if (alen > DATALEN_MSG)
 		alen = DATALEN_MSG;
 
-	dst->next = NULL;
-	dst->security = NULL;
