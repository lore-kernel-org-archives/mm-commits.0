From: akpm@linux-foundation.org
Subject: [patch 15/78] sigaltstack: support SS_AUTODISARM for
 CONFIG_COMPAT
Date: Mon, 27 Feb 2017 14:27:25 -0800
Message-ID: <58b4a7cd.7RrSFA/9C+/6sOEk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45460 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751891AbdB0WgA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2017 17:36:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, stsp@list.ru, Waiman.Long@hpe.com, arnd@arndb.de, dave.hansen@linux.intel.com, dsafonov@virtuozzo.com, luto@kernel.org, milosz@adfin.com, mingo@kernel.org, nicolas.pitre@linaro.org, oleg@redhat.com, stable@vger.kernel.org, stsp@users.sourceforge.net, tglx@linutronix.de, viro@zeniv.linux.org.uk, wangxq10@lzu.edu.cn

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
