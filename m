Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9AE02A1BF
	for <mm-commits@vger.kernel.org>; Tue, 26 Aug 2025 00:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756167982; cv=none; b=WvUijGFyHU+JeCtQXt+uNUI2nOI0by1OR/Kn9yh2pN4R54NxzIne23kQq3q1cUbyRpZiQzu/uAyfNekhPhR7iIG2lDTHAsIpT6GmunivmL6RHxG0V/22ta30ORVNaPbrHl2WX4fv8Ypaplde74hsLljsVsSRI7YdFlVjSHiVjDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756167982; c=relaxed/simple;
	bh=QlSw5KgD+Ta1EYgV9BQbhCyNh3v9DZSH/JnhN0WdU6k=;
	h=Date:To:From:Subject:Message-Id; b=qvarQC6q/pCTfBI24B4ebzEuCBdbaHZJMavzUkB6mBlpi+HdJSc47EY1AtB/2ow6GqCGvLE7ER6LxTI0uH+GesXO4VHMiFJZi4maTUXFsB68sulBaJyEZmxYbdKtg1FPRdAeOwv5rff3Q+rqg8lTvgnVJ8VDAW+F3xTWK+RH4bM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=volInZh8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="volInZh8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F215C4CEED;
	Tue, 26 Aug 2025 00:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756167982;
	bh=QlSw5KgD+Ta1EYgV9BQbhCyNh3v9DZSH/JnhN0WdU6k=;
	h=Date:To:From:Subject:From;
	b=volInZh8bVhhpyHSMQd11RlP/CTYjG/eJgx6r7PvZ4Oqfbo2PlexsQlo5Vmp/bl/G
	 3lzWROHpcpUIaN9aozas2lGOajeUGrjehWA6ZiPyG+2Bi5UutuOsGqU97+EeRzBq5n
	 P1W/QkLnYbJmimIfnyZSy5909GJgAY2Fm69oTj80=
Date: Mon, 25 Aug 2025 17:26:21 -0700
To: mm-commits@vger.kernel.org,yury.norov@gmail.com,yangyicong@hisilicon.com,ville.syrjala@linux.intel.com,vgoyal@redhat.com,tzimmermann@suse.de,tony.luck@intel.com,tj@kernel.org,thorsten.blum@linux.dev,tglx@linutronix.de,sohil.mehta@intel.com,senozhatsky@chromium.org,rostedt@goodmis.org,qianqiang.liu@163.com,pmladek@suse.com,oushixiong@kylinos.cn,namcao@linutronix.de,mingo@kernel.org,max.kellermann@ionos.com,luogengkun@huaweicloud.com,lihuafei1@huawei.com,kees@kernel.org,Jonathan.Cameron@huawei.com,john.ogness@linutronix.de,joel.granados@kernel.org,jgg@ziepe.ca,gpiccoli@igalia.com,dyoung@redhat.com,djwong@kernel.org,dianders@chromium.org,deller@gmx.de,cuiyunhui@bytedance.com,bhe@redhat.com,anna.schumaker@oracle.com,wangjinchao600@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + panic-introduce-helper-functions-for-panic-state.patch added to mm-nonmm-unstable branch
Message-Id: <20250826002622.1F215C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: panic: introduce helper functions for panic state
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     panic-introduce-helper-functions-for-panic-state.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/panic-introduce-helper-functions-for-panic-state.patch

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
Subject: panic: introduce helper functions for panic state
Date: Mon, 25 Aug 2025 10:29:29 +0800

Patch series "panic: introduce panic status function family", v2.

This series introduces a family of helper functions to manage panic state
and updates existing code to use them.

Before this series, panic state helpers were scattered and inconsistent. 
For example, panic_in_progress() was defined in printk/printk.c, not in
panic.c or panic.h.  As a result, developers had to look in unexpected
places to understand or re-use panic state logic.  Other checks were open-
coded, duplicating logic across panic, crash, and watchdog paths.

The new helpers centralize the functionality in panic.c/panic.h:
  - panic_try_start()
  - panic_reset()
  - panic_in_progress()
  - panic_on_this_cpu()
  - panic_on_other_cpu()

Patches 1–8 add the helpers and convert panic/crash and printk/nbcon
code to use them.

Patch 9 fixes a bug in the watchdog subsystem by skipping checks when a
panic is in progress, avoiding interference with the panic CPU.

Together, this makes panic state handling simpler, more discoverable, and
more robust.


This patch (of 9):

This patch introduces four new helper functions to abstract the management
of the panic_cpu variable.  These functions will be used in subsequent
patches to refactor existing code.

The direct use of panic_cpu can be error-prone and ambiguous, as it
requires manual checks to determine which CPU is handling the panic.  The
new helpers clarify intent:

panic_try_start():
Atomically sets the current CPU as the panicking CPU.

panic_reset():
Reset panic_cpu to PANIC_CPU_INVALID.

panic_in_progress():
Checks if a panic has been triggered.

panic_on_this_cpu():
Returns true if the current CPU is the panic originator.

panic_on_other_cpu():
Returns true if a panic is on another CPU.

This change lays the groundwork for improved code readability
and robustness in the panic handling subsystem.

Link: https://lkml.kernel.org/r/20250825022947.1596226-1-wangjinchao600@gmail.com
Link: https://lkml.kernel.org/r/20250825022947.1596226-2-wangjinchao600@gmail.com
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
Cc: Yury Norov (NVIDIA) <yury.norov@gmail.com>b
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/panic.h  |    6 ++++
 kernel/panic.c         |   53 +++++++++++++++++++++++++++++++++++++++
 kernel/printk/printk.c |    5 ---
 3 files changed, 59 insertions(+), 5 deletions(-)

--- a/include/linux/panic.h~panic-introduce-helper-functions-for-panic-state
+++ a/include/linux/panic.h
@@ -43,6 +43,12 @@ void abort(void);
 extern atomic_t panic_cpu;
 #define PANIC_CPU_INVALID	-1
 
+bool panic_try_start(void);
+void panic_reset(void);
+bool panic_in_progress(void);
+bool panic_on_this_cpu(void);
+bool panic_on_other_cpu(void);
+
 /*
  * Only to be used by arch init code. If the user over-wrote the default
  * CONFIG_PANIC_TIMEOUT, honor it.
--- a/kernel/panic.c~panic-introduce-helper-functions-for-panic-state
+++ a/kernel/panic.c
@@ -299,6 +299,59 @@ void __weak crash_smp_send_stop(void)
 
 atomic_t panic_cpu = ATOMIC_INIT(PANIC_CPU_INVALID);
 
+bool panic_try_start(void)
+{
+	int old_cpu, this_cpu;
+
+	/*
+	 * Only one CPU is allowed to execute the crash_kexec() code as with
+	 * panic().  Otherwise parallel calls of panic() and crash_kexec()
+	 * may stop each other.  To exclude them, we use panic_cpu here too.
+	 */
+	old_cpu = PANIC_CPU_INVALID;
+	this_cpu = raw_smp_processor_id();
+
+	return atomic_try_cmpxchg(&panic_cpu, &old_cpu, this_cpu);
+}
+EXPORT_SYMBOL(panic_try_start);
+
+void panic_reset(void)
+{
+	atomic_set(&panic_cpu, PANIC_CPU_INVALID);
+}
+EXPORT_SYMBOL(panic_reset);
+
+bool panic_in_progress(void)
+{
+	return unlikely(atomic_read(&panic_cpu) != PANIC_CPU_INVALID);
+}
+EXPORT_SYMBOL(panic_in_progress);
+
+/* Return true if a panic is in progress on the current CPU. */
+bool panic_on_this_cpu(void)
+{
+	/*
+	 * We can use raw_smp_processor_id() here because it is impossible for
+	 * the task to be migrated to the panic_cpu, or away from it. If
+	 * panic_cpu has already been set, and we're not currently executing on
+	 * that CPU, then we never will be.
+	 */
+	return unlikely(atomic_read(&panic_cpu) == raw_smp_processor_id());
+}
+EXPORT_SYMBOL(panic_on_this_cpu);
+
+/*
+ * Return true if a panic is in progress on a remote CPU.
+ *
+ * On true, the local CPU should immediately release any printing resources
+ * that may be needed by the panic CPU.
+ */
+bool panic_on_other_cpu(void)
+{
+	return (panic_in_progress() && !this_cpu_in_panic());
+}
+EXPORT_SYMBOL(panic_on_other_cpu);
+
 /*
  * A variant of panic() called from NMI context. We return if we've already
  * panicked on this CPU. If another CPU already panicked, loop in
--- a/kernel/printk/printk.c~panic-introduce-helper-functions-for-panic-state
+++ a/kernel/printk/printk.c
@@ -345,11 +345,6 @@ static void __up_console_sem(unsigned lo
 }
 #define up_console_sem() __up_console_sem(_RET_IP_)
 
-static bool panic_in_progress(void)
-{
-	return unlikely(atomic_read(&panic_cpu) != PANIC_CPU_INVALID);
-}
-
 /* Return true if a panic is in progress on the current CPU. */
 bool this_cpu_in_panic(void)
 {
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

