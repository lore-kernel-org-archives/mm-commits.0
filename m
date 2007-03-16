From: akpm@linux-foundation.org
Subject: - software-suspend-fix-suspend-when-console-is-in-tidy.patch removed from -mm tree
Date: Fri, 16 Mar 2007 13:35:11 -0800
Message-ID: <200703162135.l2GLZBVs022216@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36921 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753294AbXCPVf2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Mar 2007 17:35:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, adaplas@pol.net, ajohnson@intrinsyc.com, pavel@ucw.cz, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     software-suspend-fix-suspend-when-console-is-in-tidy
has been removed from the -mm tree.  Its filename was
     software-suspend-fix-suspend-when-console-is-in-tidy.patch

This patch was dropped because it was folded into software-suspend-fix-suspend-when-console-is-in.patch

------------------------------------------------------
Subject: software-suspend-fix-suspend-when-console-is-in-tidy
From: Andrew Morton <akpm@linux-foundation.org>

tsk.

Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Johnson <ajohnson@intrinsyc.com>
Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/vt.c       |    2 --
 include/linux/vt_kern.h |    1 +
 2 files changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/char/vt.c~software-suspend-fix-suspend-when-console-is-in-tidy drivers/char/vt.c
--- a/drivers/char/vt.c~software-suspend-fix-suspend-when-console-is-in-tidy
+++ a/drivers/char/vt.c
@@ -2185,8 +2185,6 @@ static void console_callback(struct work
 	release_console_sem();
 }
 
-extern char vt_dont_switch;
-
 int set_console(int nr)
 {
 	struct vc_data *vc = vc_cons[fg_console].d;
diff -puN include/linux/vt_kern.h~software-suspend-fix-suspend-when-console-is-in-tidy include/linux/vt_kern.h
--- a/include/linux/vt_kern.h~software-suspend-fix-suspend-when-console-is-in-tidy
+++ a/include/linux/vt_kern.h
@@ -83,6 +83,7 @@ void reset_vc(struct vc_data *vc);
 #define CON_BUF_SIZE (CONFIG_BASE_SMALL ? 256 : PAGE_SIZE)
 extern char con_buf[CON_BUF_SIZE];
 extern struct semaphore con_buf_sem;
+extern char vt_dont_switch;
 
 struct vt_spawn_console {
 	spinlock_t lock;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

ktime_set-fix-arg-type.patch
software-suspend-fix-suspend-when-console-is-in.patch
software-suspend-fix-suspend-when-console-is-in-tidy.patch
