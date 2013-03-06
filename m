From: akpm@linux-foundation.org
Subject: + ipc-msgutilc-use-linux-uaccessh.patch added to -mm tree
Date: Wed, 06 Mar 2013 13:32:54 -0800
Message-ID: <20130306213254.669EA5A41F7@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:60884 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754114Ab3CFVcz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Mar 2013 16:32:55 -0500
Received: by mail-vb0-f74.google.com with SMTP id r6so342806vbi.1
        for <mm-commits@vger.kernel.org>; Wed, 06 Mar 2013 13:32:54 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rain6557@gmail.com


The patch titled
     Subject: ipc/msgutil.c: use linux/uaccess.h
has been added to the -mm tree.  Its filename is
     ipc-msgutilc-use-linux-uaccessh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: HoSung Jung <rain6557@gmail.com>
Subject: ipc/msgutil.c: use linux/uaccess.h

Signed-off-by: HoSung Jung <rain6557@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msgutil.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN ipc/msgutil.c~ipc-msgutilc-use-linux-uaccessh ipc/msgutil.c
--- a/ipc/msgutil.c~ipc-msgutilc-use-linux-uaccessh
+++ a/ipc/msgutil.c
@@ -17,7 +17,7 @@
 #include <linux/ipc_namespace.h>
 #include <linux/utsname.h>
 #include <linux/proc_fs.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 #include "util.h"
 
@@ -37,7 +37,7 @@ struct ipc_namespace init_ipc_ns = {
 atomic_t nr_ipc_ns = ATOMIC_INIT(1);
 
 struct msg_msgseg {
-	struct msg_msgseg* next;
+	struct msg_msgseg *next;
 	/* the next part of the message follows immediately */
 };
 
_

Patches currently in -mm which might be from rain6557@gmail.com are

ipc-msgutilc-use-linux-uaccessh.patch

