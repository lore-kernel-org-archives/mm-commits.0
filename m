From: akpm@linux-foundation.org
Subject: + linux-audith-move-ptraceh-include-to-kernel-header.patch added to -mm tree
Date: Tue, 08 Jan 2013 14:47:30 -0800
Message-ID: <20130108224731.0EF6120004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f74.google.com ([209.85.215.74]:41432 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026Ab3AHWrf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Jan 2013 17:47:35 -0500
Received: by mail-la0-f74.google.com with SMTP id ej20so72139lab.5
        for <mm-commits@vger.kernel.org>; Tue, 08 Jan 2013 14:47:33 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, eparis@redhat.com, viro@zeniv.linux.org.uk


The patch titled
     Subject: linux/audit.h: move ptrace.h include to kernel header
has been added to the -mm tree.  Its filename is
     linux-audith-move-ptraceh-include-to-kernel-header.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
linux-audith-move-ptraceh-include-to-kernel-header.patch

