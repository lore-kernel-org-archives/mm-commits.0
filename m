From: akpm@linux-foundation.org
Subject: [merged] pid_namespacec-h-simplify-defines.patch removed from -mm tree
Date: Tue, 07 May 2013 10:50:06 -0700
Message-ID: <20130507175006.6F8BE5A445B@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:47404 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190Ab3EGRuH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:50:07 -0400
Received: by mail-gg0-f201.google.com with SMTP id k25so86048ggl.2
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:50:06 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: raphael.scarv@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: pid_namespace.c/.h: simplify defines
has been removed from the -mm tree.  Its filename was
     pid_namespacec-h-simplify-defines.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Raphael S.Carvalho" <raphael.scarv@gmail.com>
Subject: pid_namespace.c/.h: simplify defines

Move BITS_PER_PAGE from pid_namespace.c to pid_namespace.h, since we can
simplify the define PID_MAP_ENTRIES by using the BITS_PER_PAGE.

[akpm@linux-foundation.org: kernel/pid.c:54:1: warning: "BITS_PER_PAGE" redefined]
Signed-off-by: Raphael S.Carvalho <raphael.scarv@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pid_namespace.h |    4 +++-
 kernel/pid.c                  |    3 ---
 kernel/pid_namespace.c        |    2 --
 3 files changed, 3 insertions(+), 6 deletions(-)

diff -puN include/linux/pid_namespace.h~pid_namespacec-h-simplify-defines include/linux/pid_namespace.h
--- a/include/linux/pid_namespace.h~pid_namespacec-h-simplify-defines
+++ a/include/linux/pid_namespace.h
@@ -13,7 +13,9 @@ struct pidmap {
        void *page;
 };
 
-#define PIDMAP_ENTRIES         ((PID_MAX_LIMIT + 8*PAGE_SIZE - 1)/PAGE_SIZE/8)
+#define BITS_PER_PAGE		(PAGE_SIZE * 8)
+#define BITS_PER_PAGE_MASK	(BITS_PER_PAGE-1)
+#define PIDMAP_ENTRIES		((PID_MAX_LIMIT+BITS_PER_PAGE-1)/BITS_PER_PAGE)
 
 struct bsd_acct_struct;
 
diff -puN kernel/pid.c~pid_namespacec-h-simplify-defines kernel/pid.c
--- a/kernel/pid.c~pid_namespacec-h-simplify-defines
+++ a/kernel/pid.c
@@ -51,9 +51,6 @@ int pid_max = PID_MAX_DEFAULT;
 int pid_max_min = RESERVED_PIDS + 1;
 int pid_max_max = PID_MAX_LIMIT;
 
-#define BITS_PER_PAGE		(PAGE_SIZE*8)
-#define BITS_PER_PAGE_MASK	(BITS_PER_PAGE-1)
-
 static inline int mk_pid(struct pid_namespace *pid_ns,
 		struct pidmap *map, int off)
 {
diff -puN kernel/pid_namespace.c~pid_namespacec-h-simplify-defines kernel/pid_namespace.c
--- a/kernel/pid_namespace.c~pid_namespacec-h-simplify-defines
+++ a/kernel/pid_namespace.c
@@ -19,8 +19,6 @@
 #include <linux/reboot.h>
 #include <linux/export.h>
 
-#define BITS_PER_PAGE		(PAGE_SIZE*8)
