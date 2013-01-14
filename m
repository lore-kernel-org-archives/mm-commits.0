From: akpm@linux-foundation.org
Subject: [merged] linux-audith-move-ptraceh-include-to-kernel-header.patch removed from -mm tree
Date: Mon, 14 Jan 2013 12:39:15 -0800
Message-ID: <20130114203916.266A120004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:35871 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757312Ab3ANUjS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Jan 2013 15:39:18 -0500
Received: by mail-wi0-f202.google.com with SMTP id hn17so165236wib.3
        for <mm-commits@vger.kernel.org>; Mon, 14 Jan 2013 12:39:17 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, eparis@redhat.com, keescook@chromium.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: linux/audit.h: move ptrace.h include to kernel header
has been removed from the -mm tree.  Its filename was
     linux-audith-move-ptraceh-include-to-kernel-header.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Frysinger <vapier@gentoo.org>
Subject: linux/audit.h: move ptrace.h include to kernel header

While the kernel internals want pt_regs (and so it includes
linux/ptrace.h), the user version of audit.h does not need it.  So move
the include out of the uapi version.

This avoids issues where people want the audit defines and userland ptrace
api.  Including both the kernel ptrace and the userland ptrace headers can
easily lead to failure.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Eric Paris <eparis@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/audit.h      |    1 +
 include/uapi/linux/audit.h |    1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/audit.h~linux-audith-move-ptraceh-include-to-kernel-header include/linux/audit.h
--- a/include/linux/audit.h~linux-audith-move-ptraceh-include-to-kernel-header
+++ a/include/linux/audit.h
@@ -24,6 +24,7 @@
 #define _LINUX_AUDIT_H_
 
 #include <linux/sched.h>
+#include <linux/ptrace.h>
 #include <uapi/linux/audit.h>
 
 struct audit_sig_info {
diff -puN include/uapi/linux/audit.h~linux-audith-move-ptraceh-include-to-kernel-header include/uapi/linux/audit.h
--- a/include/uapi/linux/audit.h~linux-audith-move-ptraceh-include-to-kernel-header
+++ a/include/uapi/linux/audit.h
@@ -26,7 +26,6 @@
 
 #include <linux/types.h>
 #include <linux/elf-em.h>
-#include <linux/ptrace.h>
 
 /* The netlink messages for the audit system is divided into blocks:
  * 1000 - 1099 are for commanding the audit system
_

Patches currently in -mm which might be from vapier@gentoo.org are

origin.patch
linux-next.patch

