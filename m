From: akpm@linux-foundation.org
Subject: [merged] ipc-fix-potential-oops-when-src-msg-4k-w-msg_copy.patch removed from -mm tree
Date: Mon, 11 Mar 2013 13:16:27 -0700
Message-ID: <20130311201627.ED13F5A41E9@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:63350 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753566Ab3CKUQ3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Mar 2013 16:16:29 -0400
Received: by mail-yh0-f74.google.com with SMTP id z6so423833yhz.1
        for <mm-commits@vger.kernel.org>; Mon, 11 Mar 2013 13:16:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: peter@hurleysoftware.com, skinsbursky@parallels.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc: fix potential oops when src msg > 4k w/ MSG_COPY
has been removed from the -mm tree.  Its filename was
     ipc-fix-potential-oops-when-src-msg-4k-w-msg_copy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
