From: akpm@linux-foundation.org
Subject: + usermodehelper-use-umh_wait_proc-consistently.patch added to -mm tree
Date: Wed, 08 Feb 2012 16:14:35 -0800
Message-ID: <20120209001435.C216FA04C2@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fx0-f74.google.com ([209.85.161.74]:46561 "EHLO
	mail-fx0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757679Ab2BIAOi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Feb 2012 19:14:38 -0500
Received: by faaa19 with SMTP id a19so35449faa.1
        for <mm-commits@vger.kernel.org>; Wed, 08 Feb 2012 16:14:37 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, FlorianSchandinat@gmx.de, drbd-dev@lists.linbit.com, gregkh@linuxfoundation.org, jmorris@namei.org, penguin-kernel@I-love.SAKURA.ne.jp, penguin-kernel@i-love.sakura.ne.jp, spock@gentoo.org, takedakn@nttdata.co.jp


The patch titled
     Subject: usermodehelper: use UMH_WAIT_PROC consistently
has been added to the -mm tree.  Its filename is
     usermodehelper-use-umh_wait_proc-consistently.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: usermodehelper: use UMH_WAIT_PROC consistently

A few call_usermodehelper() callers use the hardcoded constant instead of
the proper UMH_WAIT_PROC, fix them.

Reported-by: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Lars Ellenberg <drbd-dev@lists.linbit.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Michal Januszewski <spock@gentoo.org>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Kentaro Takeda <takedakn@nttdata.co.jp>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/drbd/drbd_nl.c               |    2 +-
 drivers/staging/rtl8187se/r8180_core.c     |    2 +-
 drivers/staging/rtl8192e/rtl8192e/rtl_dm.c |    4 ++--
 drivers/video/uvesafb.c                    |    2 +-
 security/tomoyo/load_policy.c              |    2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/block/drbd/drbd_nl.c~usermodehelper-use-umh_wait_proc-consistently drivers/block/drbd/drbd_nl.c
--- a/drivers/block/drbd/drbd_nl.c~usermodehelper-use-umh_wait_proc-consistently
+++ a/drivers/block/drbd/drbd_nl.c
@@ -179,7 +179,7 @@ int drbd_khelper(struct drbd_conf *mdev,
 	dev_info(DEV, "helper command: %s %s %s\n", usermode_helper, cmd, mb);
 
 	drbd_bcast_ev_helper(mdev, cmd);
-	ret = call_usermodehelper(usermode_helper, argv, envp, 1);
+	ret = call_usermodehelper(usermode_helper, argv, envp, UMH_WAIT_PROC);
 	if (ret)
 		dev_warn(DEV, "helper command: %s %s %s exit code %u (0x%x)\n",
 				usermode_helper, cmd, mb,
diff -puN drivers/staging/rtl8187se/r8180_core.c~usermodehelper-use-umh_wait_proc-consistently drivers/staging/rtl8187se/r8180_core.c
--- a/drivers/staging/rtl8187se/r8180_core.c~usermodehelper-use-umh_wait_proc-consistently
+++ a/drivers/staging/rtl8187se/r8180_core.c
@@ -4144,7 +4144,7 @@ void GPIOChangeRFWorkItemCallBack(struct
 		argv[0] = RadioPowerPath;
 		argv[2] = NULL;
 
-		call_usermodehelper(RadioPowerPath, argv, envp, 1);
+		call_usermodehelper(RadioPowerPath, argv, envp, UMH_WAIT_PROC);
 	}
 }
 
diff -puN drivers/staging/rtl8192e/rtl8192e/rtl_dm.c~usermodehelper-use-umh_wait_proc-consistently drivers/staging/rtl8192e/rtl8192e/rtl_dm.c
--- a/drivers/staging/rtl8192e/rtl8192e/rtl_dm.c~usermodehelper-use-umh_wait_proc-consistently
+++ a/drivers/staging/rtl8192e/rtl8192e/rtl_dm.c
@@ -208,7 +208,7 @@ static void dm_check_ac_dc_power(struct 
 
 	if (priv->rtllib->state != RTLLIB_LINKED)
 		return;
-	call_usermodehelper(ac_dc_check_script_path, argv, envp, 1);
+	call_usermodehelper(ac_dc_check_script_path, argv, envp, UMH_WAIT_PROC);
 
 	return;
 };
@@ -2296,7 +2296,7 @@ void dm_CheckRfCtrlGPIO(void *data)
 
 		argv[0] = RadioPowerPath;
 		argv[2] = NULL;
-		call_usermodehelper(RadioPowerPath, argv, envp, 1);
+		call_usermodehelper(RadioPowerPath, argv, envp, UMH_WAIT_PROC);
 	}
 }
 
diff -puN drivers/video/uvesafb.c~usermodehelper-use-umh_wait_proc-consistently drivers/video/uvesafb.c
--- a/drivers/video/uvesafb.c~usermodehelper-use-umh_wait_proc-consistently
+++ a/drivers/video/uvesafb.c
@@ -121,7 +121,7 @@ static int uvesafb_helper_start(void)
 		NULL,
 	};
 
-	return call_usermodehelper(v86d_path, argv, envp, 1);
+	return call_usermodehelper(v86d_path, argv, envp, UMH_WAIT_PROC);
 }
 
 /*
diff -puN security/tomoyo/load_policy.c~usermodehelper-use-umh_wait_proc-consistently security/tomoyo/load_policy.c
--- a/security/tomoyo/load_policy.c~usermodehelper-use-umh_wait_proc-consistently
+++ a/security/tomoyo/load_policy.c
@@ -102,7 +102,7 @@ void tomoyo_load_policy(const char *file
 	envp[0] = "HOME=/";
 	envp[1] = "PATH=/sbin:/bin:/usr/sbin:/usr/bin";
 	envp[2] = NULL;
-	call_usermodehelper(argv[0], argv, envp, 1);
+	call_usermodehelper(argv[0], argv, envp, UMH_WAIT_PROC);
 	tomoyo_check_profile();
 }
 
_
Subject: Subject: usermodehelper: use UMH_WAIT_PROC consistently

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix-fix.patch
kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any.patch
kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any-fix.patch
usermodehelper-use-umh_wait_proc-consistently.patch
pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall.patch
pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall-fix.patch
sysctl-make-kernelns_last_pid-control-being-checkpoint_restore-dependent.patch

