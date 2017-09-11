From: akpm@linux-foundation.org
Subject: [merged]
 kmod-move-ifdef-config_modules-wrapper-to-makefile.patch removed from -mm
 tree
Date: Mon, 11 Sep 2017 12:43:46 -0700
Message-ID: <20170911194346.GPACD4LFH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50722 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751045AbdIKTns (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 11 Sep 2017 15:43:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: colin.king@canonical.com, dan.carpenter@oracle.com, danielmentz@google.com, dcb314@hotmail.com, dmitry.torokhov@gmail.com, ebiederm@xmission.com, gregkh@linuxfoundation.org, jeyu@redhat.com, jpoimboe@redhat.com, keescook@chromium.org, linux@roeck-us.net, matt.redfearn@imgtec.com, mbenes@suse.cz, mcgrof@kernel.org, mm-commits@vger.kernel.org, mmarek@suse.com, pmladek@suse.com, rusty@rustcorp.com.au


The patch titled
     Subject: kmod: move #ifdef CONFIG_MODULES wrapper to Makefile
has been removed from the -mm tree.  Its filename was
     kmod-move-ifdef-config_modules-wrapper-to-makefile.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: kmod: move #ifdef CONFIG_MODULES wrapper to Makefile

The entire file is now conditionally compiled only when CONFIG_MODULES is
enabled, and this this is a bool.  Just move this conditional to the
Makefile as its easier to read this way.

Link: http://lkml.kernel.org/r/20170810180618.22457-5-mcgrof@kernel.org
Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jessica Yu <jeyu@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Michal Marek <mmarek@suse.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Miroslav Benes <mbenes@suse.cz>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Matt Redfearn <matt.redfearn@imgtec.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Colin Ian King <colin.king@canonical.com>
Cc: Daniel Mentz <danielmentz@google.com>
Cc: David Binderman <dcb314@hotmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/Makefile |    3 ++-
 kernel/kmod.c   |    3 ---
 2 files changed, 2 insertions(+), 4 deletions(-)

diff -puN kernel/Makefile~kmod-move-ifdef-config_modules-wrapper-to-makefile kernel/Makefile
--- a/kernel/Makefile~kmod-move-ifdef-config_modules-wrapper-to-makefile
+++ a/kernel/Makefile
@@ -5,12 +5,13 @@
 obj-y     = fork.o exec_domain.o panic.o \
 	    cpu.o exit.o softirq.o resource.o \
 	    sysctl.o sysctl_binary.o capability.o ptrace.o user.o \
-	    signal.o sys.o umh.o kmod.o workqueue.o pid.o task_work.o \
+	    signal.o sys.o umh.o workqueue.o pid.o task_work.o \
 	    extable.o params.o \
 	    kthread.o sys_ni.o nsproxy.o \
 	    notifier.o ksysfs.o cred.o reboot.o \
 	    async.o range.o smpboot.o ucount.o
 
+obj-$(CONFIG_MODULES) += kmod.o
 obj-$(CONFIG_MULTIUSER) += groups.o
 
 ifdef CONFIG_FUNCTION_TRACER
diff -puN kernel/kmod.c~kmod-move-ifdef-config_modules-wrapper-to-makefile kernel/kmod.c
--- a/kernel/kmod.c~kmod-move-ifdef-config_modules-wrapper-to-makefile
+++ a/kernel/kmod.c
@@ -28,7 +28,6 @@
 
 #include <trace/events/module.h>
 
-#ifdef CONFIG_MODULES
 /*
  * Assuming:
  *
@@ -177,5 +176,3 @@ int __request_module(bool wait, const ch
 	return ret;
 }
 EXPORT_SYMBOL(__request_module);
