From: akpm@linux-foundation.org
Subject: [merged] kernelh-neaten-panic-prototype.patch removed from -mm tree
Date: Fri, 13 Jan 2012 12:31:29 -0800
Message-ID: <20120113203129.9125010004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:52529 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759051Ab2AMUba (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 15:31:30 -0500
Received: by ggnk3 with SMTP id k3so355515ggn.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 12:31:29 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel.h: neaten panic prototype
has been removed from the -mm tree.  Its filename was
     kernelh-neaten-panic-prototype.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: kernel.h: neaten panic prototype

Use __printf macro.
Convert NORET_AND to ATTRIB_NORET.
Use the normal kernel style for pointer arguments.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN include/linux/kernel.h~kernelh-neaten-panic-prototype include/linux/kernel.h
--- a/include/linux/kernel.h~kernelh-neaten-panic-prototype
+++ a/include/linux/kernel.h
@@ -185,8 +185,9 @@ static inline void might_fault(void)
 
 extern struct atomic_notifier_head panic_notifier_list;
 extern long (*panic_blink)(int state);
-NORET_TYPE void panic(const char * fmt, ...)
-	__attribute__ ((NORET_AND format (printf, 1, 2))) __cold;
+NORET_TYPE __printf(1, 2)
+void panic(const char *fmt, ...)
+	ATTRIB_NORET __cold;
 extern void oops_enter(void);
 extern void oops_exit(void);
 void print_oops_end_marker(void);
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
maintainers-staging-cx25821-add-l-linux-media.patch

