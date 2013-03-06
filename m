From: akpm@linux-foundation.org
Subject: + pid_namespacec-h-simplify-defines.patch added to -mm tree
Date: Wed, 06 Mar 2013 12:31:54 -0800
Message-ID: <20130306203154.683C231C20C@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:50405 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372Ab3CFUb5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Mar 2013 15:31:57 -0500
Received: by mail-ye0-f202.google.com with SMTP id q5so911631yen.1
        for <mm-commits@vger.kernel.org>; Wed, 06 Mar 2013 12:31:56 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: raphael.scarv@gmail.com


The patch titled
     Subject: pid_namespace.c/.h: simplify defines
has been added to the -mm tree.  Its filename is
     pid_namespacec-h-simplify-defines.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Raphael S.Carvalho" <raphael.scarv@gmail.com>
Subject: pid_namespace.c/.h: simplify defines

Move BITS_PER_PAGE from pid_namespace.c to pid_namespace.h, since we can
simplify the define PID_MAP_ENTRIES by using the BITS_PER_PAGE.

Signed-off-by: Raphael S.Carvalho <raphael.scarv@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pid_namespace.h |    3 ++-
 kernel/pid_namespace.c        |    2 --
 2 files changed, 2 insertions(+), 3 deletions(-)

diff -puN include/linux/pid_namespace.h~pid_namespacec-h-simplify-defines include/linux/pid_namespace.h
--- a/include/linux/pid_namespace.h~pid_namespacec-h-simplify-defines
+++ a/include/linux/pid_namespace.h
@@ -13,7 +13,8 @@ struct pidmap {
        void *page;
 };
 
-#define PIDMAP_ENTRIES         ((PID_MAX_LIMIT + 8*PAGE_SIZE - 1)/PAGE_SIZE/8)
+#define BITS_PER_PAGE		(PAGE_SIZE * 8)
+#define PIDMAP_ENTRIES		((PID_MAX_LIMIT+BITS_PER_PAGE-1)/BITS_PER_PAGE)
 
 struct bsd_acct_struct;
 
diff -puN kernel/pid_namespace.c~pid_namespacec-h-simplify-defines kernel/pid_namespace.c
--- a/kernel/pid_namespace.c~pid_namespacec-h-simplify-defines
+++ a/kernel/pid_namespace.c
@@ -19,8 +19,6 @@
 #include <linux/reboot.h>
 #include <linux/export.h>
 
-#define BITS_PER_PAGE		(PAGE_SIZE*8)
