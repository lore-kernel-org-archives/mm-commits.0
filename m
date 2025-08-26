Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CD0F2A1BF
	for <mm-commits@vger.kernel.org>; Tue, 26 Aug 2025 00:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756167997; cv=none; b=kpJPZUUKpEGw/rmoYGveh8eLfwqS/DJLRuYwQXDFQDDHNduZMnhUJZErTsqwOfwtamgqD6OWAHC3K3EmRBqUxx8iiHGqRjHTTLJPssXUWjXQRrBcyajpLhmPo5/39td+fdF82Qar14pdMtVkqulSbYUGZBYxQNq+2QI0B07ekv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756167997; c=relaxed/simple;
	bh=VyBbq9f9CqA0NHJHl29KHzzz7FsSGemcEdEjkUsug+4=;
	h=Date:To:From:Subject:Message-Id; b=dPRJmvl1mdpPAl6DVUDzQusWr+o0AJ7gwIV0C7lJl+BBxm3VYF2GftARJ6y/fuYx3x1VTPtMHaY3VSQVP0xsYDJHggcJzxO8oJ4Jxi43RM2lih1HC93Ohy6EA7seOhUmOLZQhlqACUtnnbwnXNbu+hoDIWZv3CNsak1ZBTL1XmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ftyh0a4e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ftyh0a4e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1009EC116B1;
	Tue, 26 Aug 2025 00:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756167997;
	bh=VyBbq9f9CqA0NHJHl29KHzzz7FsSGemcEdEjkUsug+4=;
	h=Date:To:From:Subject:From;
	b=Ftyh0a4e93kOL+Gz4JJPcovUjoErDax9cyEnAnqPxzd4ZKJXhIX65jM263cIyX9C/
	 OrwqSdNjX0oZdH1CUg3dG3mIS5k3BhLOA8jqt/nVS0jI36KVir7UVKIhX84NO4SWwO
	 3AzTdZrAxLXGQ8M6ZtWBt6xdfIaBiqtMT6X2LP30=
Date: Mon, 25 Aug 2025 17:26:36 -0700
To: mm-commits@vger.kernel.org,yury.norov@gmail.com,yangyicong@hisilicon.com,ville.syrjala@linux.intel.com,vgoyal@redhat.com,tzimmermann@suse.de,tony.luck@intel.com,tj@kernel.org,thorsten.blum@linux.dev,tglx@linutronix.de,sohil.mehta@intel.com,senozhatsky@chromium.org,rostedt@goodmis.org,qianqiang.liu@163.com,pmladek@suse.com,oushixiong@kylinos.cn,namcao@linutronix.de,mingo@kernel.org,max.kellermann@ionos.com,luogengkun@huaweicloud.com,lihuafei1@huawei.com,kees@kernel.org,Jonathan.Cameron@huawei.com,john.ogness@linutronix.de,joel.granados@kernel.org,jgg@ziepe.ca,gpiccoli@igalia.com,dyoung@redhat.com,djwong@kernel.org,dianders@chromium.org,deller@gmx.de,cuiyunhui@bytedance.com,bhe@redhat.com,anna.schumaker@oracle.com,wangjinchao600@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + panic-printk-replace-this_cpu_in_panic-with-panic_on_this_cpu.patch added to mm-nonmm-unstable branch
Message-Id: <20250826002637.1009EC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: panic/printk: replace this_cpu_in_panic() with panic_on_this_cpu()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     panic-printk-replace-this_cpu_in_panic-with-panic_on_this_cpu.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/panic-printk-replace-this_cpu_in_panic-with-panic_on_this_cpu.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Jinchao Wang <wangjinchao600@gmail.com>
Subject: panic/printk: replace this_cpu_in_panic() with panic_on_this_cpu()
Date: Mon, 25 Aug 2025 10:29:35 +0800

The helper this_cpu_in_panic() duplicated logic already provided by
panic_on_this_cpu().

Remove this_cpu_in_panic() and switch all users to panic_on_this_cpu().

This simplifies the code and avoids having two helpers for the same check.

Link: https://lkml.kernel.org/r/20250825022947.1596226-8-wangjinchao600@gmail.com
Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
Cc: Anna Schumaker <anna.schumaker@oracle.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Young <dyoung@redhat.com>
Cc: Doug Anderson <dianders@chromium.org>
Cc: "Guilherme G. Piccoli" <gpiccoli@igalia.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Joanthan Cameron <Jonathan.Cameron@huawei.com>
Cc: Joel Granados <joel.granados@kernel.org>
Cc: John Ogness <john.ogness@linutronix.de>
Cc: Kees Cook <kees@kernel.org>
Cc: Li Huafei <lihuafei1@huawei.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Luo Gengkun <luogengkun@huaweicloud.com>
Cc: Max Kellermann <max.kellermann@ionos.com>
Cc: Nam Cao <namcao@linutronix.de>
Cc: oushixiong <oushixiong@kylinos.cn>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Qianqiang Liu <qianqiang.liu@163.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Sohil Mehta <sohil.mehta@intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: Thomas Zimemrmann <tzimmermann@suse.de>
Cc: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Ville Syrjala <ville.syrjala@linux.intel.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Yicong Yang <yangyicong@hisilicon.com>
Cc: Yunhui Cui <cuiyunhui@bytedance.com>
Cc: Yury Norov (NVIDIA) <yury.norov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/printk.h            |    2 --
 kernel/panic.c                    |    2 +-
 kernel/printk/nbcon.c             |    2 +-
 kernel/printk/printk.c            |   15 ++-------------
 kernel/printk/printk_ringbuffer.c |    2 +-
 lib/dump_stack.c                  |    2 +-
 6 files changed, 6 insertions(+), 19 deletions(-)

--- a/include/linux/printk.h~panic-printk-replace-this_cpu_in_panic-with-panic_on_this_cpu
+++ a/include/linux/printk.h
@@ -330,8 +330,6 @@ static inline bool pr_flush(int timeout_
 
 #endif
 
-bool this_cpu_in_panic(void);
-
 #ifdef CONFIG_SMP
 extern int __printk_cpu_sync_try_get(void);
 extern void __printk_cpu_sync_wait(void);
--- a/kernel/panic.c~panic-printk-replace-this_cpu_in_panic-with-panic_on_this_cpu
+++ a/kernel/panic.c
@@ -348,7 +348,7 @@ EXPORT_SYMBOL(panic_on_this_cpu);
  */
 bool panic_on_other_cpu(void)
 {
-	return (panic_in_progress() && !this_cpu_in_panic());
+	return (panic_in_progress() && !panic_on_this_cpu());
 }
 EXPORT_SYMBOL(panic_on_other_cpu);
 
--- a/kernel/printk/nbcon.c~panic-printk-replace-this_cpu_in_panic-with-panic_on_this_cpu
+++ a/kernel/printk/nbcon.c
@@ -1394,7 +1394,7 @@ enum nbcon_prio nbcon_get_default_prio(v
 {
 	unsigned int *cpu_emergency_nesting;
 
-	if (this_cpu_in_panic())
+	if (panic_on_this_cpu())
 		return NBCON_PRIO_PANIC;
 
 	cpu_emergency_nesting = nbcon_get_cpu_emergency_nesting();
--- a/kernel/printk/printk.c~panic-printk-replace-this_cpu_in_panic-with-panic_on_this_cpu
+++ a/kernel/printk/printk.c
@@ -17,6 +17,7 @@
  *	01Mar01 Andrew Morton
  */
 
+#include "linux/panic.h"
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/kernel.h>
@@ -345,18 +346,6 @@ static void __up_console_sem(unsigned lo
 }
 #define up_console_sem() __up_console_sem(_RET_IP_)
 
-/* Return true if a panic is in progress on the current CPU. */
-bool this_cpu_in_panic(void)
-{
-	/*
-	 * We can use raw_smp_processor_id() here because it is impossible for
-	 * the task to be migrated to the panic_cpu, or away from it. If
-	 * panic_cpu has already been set, and we're not currently executing on
-	 * that CPU, then we never will be.
-	 */
-	return unlikely(atomic_read(&panic_cpu) == raw_smp_processor_id());
-}
-
 /*
  * Return true if a panic is in progress on a remote CPU.
  *
@@ -365,7 +354,7 @@ bool this_cpu_in_panic(void)
  */
 bool other_cpu_in_panic(void)
 {
-	return (panic_in_progress() && !this_cpu_in_panic());
+	return (panic_in_progress() && !panic_on_this_cpu());
 }
 
 /*
--- a/kernel/printk/printk_ringbuffer.c~panic-printk-replace-this_cpu_in_panic-with-panic_on_this_cpu
+++ a/kernel/printk/printk_ringbuffer.c
@@ -2143,7 +2143,7 @@ static bool _prb_read_valid(struct print
 			 * But it would have the sequence number returned
 			 * by "prb_next_reserve_seq() - 1".
 			 */
-			if (this_cpu_in_panic() &&
+			if (panic_on_this_cpu() &&
 			    (!debug_non_panic_cpus || legacy_allow_panic_sync) &&
 			    ((*seq + 1) < prb_next_reserve_seq(rb))) {
 				(*seq)++;
--- a/lib/dump_stack.c~panic-printk-replace-this_cpu_in_panic-with-panic_on_this_cpu
+++ a/lib/dump_stack.c
@@ -102,7 +102,7 @@ static void __dump_stack(const char *log
  */
 asmlinkage __visible void dump_stack_lvl(const char *log_lvl)
 {
-	bool in_panic = this_cpu_in_panic();
+	bool in_panic = panic_on_this_cpu();
 	unsigned long flags;
 
 	/*
_

Patches currently in -mm which might be from wangjinchao600@gmail.com are

panic-introduce-helper-functions-for-panic-state.patch
fbdev-use-panic_in_progress-helper.patch
crash_core-use-panic_try_start-in-crash_kexec.patch
panic-use-panic_try_start-in-nmi_panic.patch
panic-use-panic_try_start-in-vpanic.patch
printk-nbcon-use-panic_on_this_cpu-helper.patch
panic-printk-replace-this_cpu_in_panic-with-panic_on_this_cpu.patch
panic-printk-replace-other_cpu_in_panic-with-panic_on_other_cpu.patch
watchdog-skip-checks-when-panic-is-in-progress.patch

