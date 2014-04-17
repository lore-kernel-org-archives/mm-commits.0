From: akpm@linux-foundation.org
Subject: + ipc-kernel-use-linux-headers.patch added to -mm tree
Date: Thu, 17 Apr 2014 14:53:01 -0700
Message-ID: <53504d3d.ejXNY77NF1rbXXuU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:32966 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbaDQVxD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Apr 2014 17:53:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, paulmcquad@gmail.com

Subject: + ipc-kernel-use-linux-headers.patch added to -mm tree
To: paulmcquad@gmail.com
From: akpm@linux-foundation.org
Date: Thu, 17 Apr 2014 14:53:01 -0700


The patch titled
     Subject: ipc, kernel: use Linux headers
has been added to the -mm tree.  Its filename is
     ipc-kernel-use-linux-headers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-kernel-use-linux-headers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-kernel-use-linux-headers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Paul McQuade <paulmcquad@gmail.com>
Subject: ipc, kernel: use Linux headers

Use #include <linux/uaccess.h> instead of <asm/uaccess.h>
Use #include <linux/types.h> instead of <asm/types.h>

Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/compat.c    |    2 +-
 ipc/compat_mq.c |    2 +-
 ipc/msg.c       |    2 +-
 ipc/sem.c       |    2 +-
 ipc/shm.c       |    2 +-
 kernel/acct.c   |    2 +-
 kernel/audit.c  |    2 +-
 7 files changed, 7 insertions(+), 7 deletions(-)

diff -puN ipc/compat.c~ipc-kernel-use-linux-headers ipc/compat.c
--- a/ipc/compat.c~ipc-kernel-use-linux-headers
+++ a/ipc/compat.c
@@ -30,7 +30,7 @@
 #include <linux/ptrace.h>
 
 #include <linux/mutex.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 #include "util.h"
 
diff -puN ipc/compat_mq.c~ipc-kernel-use-linux-headers ipc/compat_mq.c
--- a/ipc/compat_mq.c~ipc-kernel-use-linux-headers
+++ a/ipc/compat_mq.c
@@ -12,7 +12,7 @@
 #include <linux/mqueue.h>
 #include <linux/syscalls.h>
 
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 struct compat_mq_attr {
 	compat_long_t mq_flags;      /* message queue flags		     */
diff -puN ipc/msg.c~ipc-kernel-use-linux-headers ipc/msg.c
--- a/ipc/msg.c~ipc-kernel-use-linux-headers
+++ a/ipc/msg.c
@@ -39,7 +39,7 @@
 #include <linux/ipc_namespace.h>
 
 #include <asm/current.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include "util.h"
 
 /*
diff -puN ipc/sem.c~ipc-kernel-use-linux-headers ipc/sem.c
--- a/ipc/sem.c~ipc-kernel-use-linux-headers
+++ a/ipc/sem.c
@@ -87,7 +87,7 @@
 #include <linux/nsproxy.h>
 #include <linux/ipc_namespace.h>
 
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include "util.h"
 
 /* One semaphore structure for each semaphore in the system. */
diff -puN ipc/shm.c~ipc-kernel-use-linux-headers ipc/shm.c
--- a/ipc/shm.c~ipc-kernel-use-linux-headers
+++ a/ipc/shm.c
@@ -43,7 +43,7 @@
 #include <linux/mount.h>
 #include <linux/ipc_namespace.h>
 
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 #include "util.h"
 
diff -puN kernel/acct.c~ipc-kernel-use-linux-headers kernel/acct.c
--- a/kernel/acct.c~ipc-kernel-use-linux-headers
+++ a/kernel/acct.c
@@ -55,7 +55,7 @@
 #include <linux/times.h>
 #include <linux/syscalls.h>
 #include <linux/mount.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <asm/div64.h>
 #include <linux/blkdev.h> /* sector_div */
 #include <linux/pid_namespace.h>
diff -puN kernel/audit.c~ipc-kernel-use-linux-headers kernel/audit.c
--- a/kernel/audit.c~ipc-kernel-use-linux-headers
+++ a/kernel/audit.c
@@ -44,7 +44,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/init.h>
-#include <asm/types.h>
+#include <linux/types.h>
 #include <linux/atomic.h>
 #include <linux/mm.h>
 #include <linux/export.h>
_

Patches currently in -mm which might be from paulmcquad@gmail.com are

ipc-kernel-use-linux-headers.patch
ipc-kernel-clear-whitespace.patch
linux-next.patch

