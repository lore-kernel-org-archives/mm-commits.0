From: akpm@linux-foundation.org
Subject: + sigaltstack-support-ss_autodisarm-for-config_compat.patch added to -mm tree
Date: Mon, 06 Feb 2017 16:03:29 -0800
Message-ID: <58990ed1.AlXa3lHajHYqy8Vp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36026 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752270AbdBGADb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Feb 2017 19:03:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stsp@list.ru, Waiman.Long@hpe.com, arnd@arndb.de, dave.hansen@linux.intel.com, dsafonov@virtuozzo.com, luto@kernel.org, milosz@adfin.com, mingo@kernel.org, nicolas.pitre@linaro.org, oleg@redhat.com, stable@vger.kernel.org, stsp@users.sourceforge.net, tglx@linutronix.de, viro@zeniv.linux.org.uk, wangxq10@lzu.edu.cn, mm-commits@vger.kernel.org


The patch titled
     Subject: sigaltstack: support SS_AUTODISARM for CONFIG_COMPAT
has been added to the -mm tree.  Its filename is
     sigaltstack-support-ss_autodisarm-for-config_compat.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sigaltstack-support-ss_autodisarm-for-config_compat.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sigaltstack-support-ss_autodisarm-for-config_compat.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Stas Sergeev <stsp@list.ru>
Subject: sigaltstack: support SS_AUTODISARM for CONFIG_COMPAT

Currently SS_AUTODISARM is not supported in compatibility mode, but does
not return -EINVAL either.  This makes dosemu built with -m32 on x86_64 to
crash.  Also the kernel's sigaltstack selftest fails if compiled with
-m32.

This patch adds the needed support.

Link: http://lkml.kernel.org/r/20170205101213.8163-2-stsp@list.ru
Signed-off-by: Stas Sergeev <stsp@users.sourceforge.net>
Cc: Milosz Tanski <milosz@adfin.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Waiman Long <Waiman.Long@hpe.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dmitry Safonov <dsafonov@virtuozzo.com>
Cc: Wang Xiaoqiang <wangxq10@lzu.edu.cn>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compat.h |    4 +++-
 kernel/signal.c        |   11 +++++++++--
 2 files changed, 12 insertions(+), 3 deletions(-)

diff -puN include/linux/compat.h~sigaltstack-support-ss_autodisarm-for-config_compat include/linux/compat.h
--- a/include/linux/compat.h~sigaltstack-support-ss_autodisarm-for-config_compat
+++ a/include/linux/compat.h
@@ -711,8 +711,10 @@ int __compat_save_altstack(compat_stack_
 	compat_stack_t __user *__uss = uss; \
 	struct task_struct *t = current; \
 	put_user_ex(ptr_to_compat((void __user *)t->sas_ss_sp), &__uss->ss_sp); \
-	put_user_ex(sas_ss_flags(sp), &__uss->ss_flags); \
+	put_user_ex(t->sas_ss_flags, &__uss->ss_flags); \
 	put_user_ex(t->sas_ss_size, &__uss->ss_size); \
+	if (t->sas_ss_flags & SS_AUTODISARM) \
+		sas_ss_reset(t); \
 } while (0);
 
 asmlinkage long compat_sys_sched_rr_get_interval(compat_pid_t pid,
diff -puN kernel/signal.c~sigaltstack-support-ss_autodisarm-for-config_compat kernel/signal.c
--- a/kernel/signal.c~sigaltstack-support-ss_autodisarm-for-config_compat
+++ a/kernel/signal.c
@@ -3239,10 +3239,17 @@ int compat_restore_altstack(const compat
 
 int __compat_save_altstack(compat_stack_t __user *uss, unsigned long sp)
 {
+	int err;
 	struct task_struct *t = current;
-	return  __put_user(ptr_to_compat((void __user *)t->sas_ss_sp), &uss->ss_sp) |
-		__put_user(sas_ss_flags(sp), &uss->ss_flags) |
+	err = __put_user(ptr_to_compat((void __user *)t->sas_ss_sp),
+			 &uss->ss_sp) |
+		__put_user(t->sas_ss_flags, &uss->ss_flags) |
 		__put_user(t->sas_ss_size, &uss->ss_size);
+	if (err)
+		return err;
+	if (t->sas_ss_flags & SS_AUTODISARM)
+		sas_ss_reset(t);
+	return 0;
 }
 #endif
 
_

Patches currently in -mm which might be from stsp@list.ru are

sigaltstack-support-ss_autodisarm-for-config_compat.patch

