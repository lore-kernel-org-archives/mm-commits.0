From: akpm@linux-foundation.org
Subject: [folded-merged] pid_namespacec-h-simplify-defines-fix.patch removed from -mm tree
Date: Tue, 30 Apr 2013 15:19:08 -0700
Message-ID: <20130430221909.4B0D331C0F7@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:40458 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755642Ab3D3WTK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 18:19:10 -0400
Received: by mail-qc0-f201.google.com with SMTP id o22so114192qcr.2
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 15:19:09 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, raphael.scarv@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: pid_namespacec-h-simplify-defines-fix
has been removed from the -mm tree.  Its filename was
     pid_namespacec-h-simplify-defines-fix.patch

This patch was dropped because it was folded into pid_namespacec-h-simplify-defines.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: pid_namespacec-h-simplify-defines-fix

kernel/pid.c:54:1: warning: "BITS_PER_PAGE" redefined

Cc: Raphael S.Carvalho <raphael.scarv@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pid_namespace.h |    1 +
 kernel/pid.c                  |    3 ---
 2 files changed, 1 insertion(+), 3 deletions(-)

diff -puN include/linux/pid_namespace.h~pid_namespacec-h-simplify-defines-fix include/linux/pid_namespace.h
--- a/include/linux/pid_namespace.h~pid_namespacec-h-simplify-defines-fix
+++ a/include/linux/pid_namespace.h
@@ -14,6 +14,7 @@ struct pidmap {
 };
 
 #define BITS_PER_PAGE		(PAGE_SIZE * 8)
+#define BITS_PER_PAGE_MASK	(BITS_PER_PAGE-1)
 #define PIDMAP_ENTRIES		((PID_MAX_LIMIT+BITS_PER_PAGE-1)/BITS_PER_PAGE)
 
 struct bsd_acct_struct;
diff -puN kernel/pid.c~pid_namespacec-h-simplify-defines-fix kernel/pid.c
--- a/kernel/pid.c~pid_namespacec-h-simplify-defines-fix
+++ a/kernel/pid.c
@@ -51,9 +51,6 @@ int pid_max = PID_MAX_DEFAULT;
 int pid_max_min = RESERVED_PIDS + 1;
 int pid_max_max = PID_MAX_LIMIT;
 
-#define BITS_PER_PAGE		(PAGE_SIZE*8)
-#define BITS_PER_PAGE_MASK	(BITS_PER_PAGE-1)
