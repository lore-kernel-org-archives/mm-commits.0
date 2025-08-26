Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDEA52A1BF
	for <mm-commits@vger.kernel.org>; Tue, 26 Aug 2025 00:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756167988; cv=none; b=gUkpS5XXVVoOgqpQOZV0MBnc0NuWOl5GYqOcIzyfJTV2hoVsgcMLb/Phyfbiyw1Xy3dmdpK+rtDa/qdv+4hUnOYAcPT7x68GVHuzbbYCQ8H5y3C/+/lEfWEyN7mFMRSXHshvp5KPhlUIPTOpB4rPm2BSReVZ6prhy8JuJYy47Fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756167988; c=relaxed/simple;
	bh=s7DyqPod3Al1sYtc+2SLW35Xd+FdacwS6oRbyX3xPf8=;
	h=Date:To:From:Subject:Message-Id; b=jeY70CN5+c0usuE2WTWJa9NqZrdV8uEspdMVdoSC2v9F5yRSdAJ2i3WJt/7z/IbV0LNym63s7XqnSm0VFeFuqIUuqKXmmE0Wuh4z8ywTEs6l2OtRhm/vOj8rVPwosy7xpNnCLX6yUuLP/Eh5G5XzZMGTECsRMOJkBiYn8bawGeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kz9aGYfB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kz9aGYfB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A322BC4CEF4;
	Tue, 26 Aug 2025 00:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756167987;
	bh=s7DyqPod3Al1sYtc+2SLW35Xd+FdacwS6oRbyX3xPf8=;
	h=Date:To:From:Subject:From;
	b=kz9aGYfBjl+sRt8sDBSYXKKTcFDLb7qu2uhKLzKRxHMVw2rKsA3FZs7RO1EICuLA1
	 KeYr1y20WDUeLuH1k5Cd/V3WrMDJNMZWUbLGImILulEnzxYmRLY/dRbCW+Xd3JTcio
	 tlec+4gYHRyDDfvK3wpRy+v+t4bb2/4B7lilJJAU=
Date: Mon, 25 Aug 2025 17:26:27 -0700
To: mm-commits@vger.kernel.org,yury.norov@gmail.com,yangyicong@hisilicon.com,ville.syrjala@linux.intel.com,vgoyal@redhat.com,tzimmermann@suse.de,tony.luck@intel.com,tj@kernel.org,thorsten.blum@linux.dev,tglx@linutronix.de,sohil.mehta@intel.com,senozhatsky@chromium.org,rostedt@goodmis.org,qianqiang.liu@163.com,pmladek@suse.com,oushixiong@kylinos.cn,namcao@linutronix.de,mingo@kernel.org,max.kellermann@ionos.com,luogengkun@huaweicloud.com,lihuafei1@huawei.com,kees@kernel.org,Jonathan.Cameron@huawei.com,john.ogness@linutronix.de,joel.granados@kernel.org,jgg@ziepe.ca,gpiccoli@igalia.com,dyoung@redhat.com,djwong@kernel.org,dianders@chromium.org,deller@gmx.de,cuiyunhui@bytedance.com,bhe@redhat.com,anna.schumaker@oracle.com,wangjinchao600@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + crash_core-use-panic_try_start-in-crash_kexec.patch added to mm-nonmm-unstable branch
Message-Id: <20250826002627.A322BC4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: crash_core: use panic_try_start() in crash_kexec()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     crash_core-use-panic_try_start-in-crash_kexec.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/crash_core-use-panic_try_start-in-crash_kexec.patch

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
Subject: crash_core: use panic_try_start() in crash_kexec()
Date: Mon, 25 Aug 2025 10:29:31 +0800

crash_kexec() had its own code to exclude parallel execution by setting
panic_cpu.  This is already handled by panic_try_start().  Switch to
panic_try_start() to remove the duplication and keep the logic consistent.

Link: https://lkml.kernel.org/r/20250825022947.1596226-4-wangjinchao600@gmail.com
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

 kernel/crash_core.c |   15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

--- a/kernel/crash_core.c~crash_core-use-panic_try_start-in-crash_kexec
+++ a/kernel/crash_core.c
@@ -4,6 +4,7 @@
  * Copyright (C) 2002-2004 Eric Biederman  <ebiederm@xmission.com>
  */
 
+#include "linux/panic.h"
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/buildid.h>
@@ -143,17 +144,7 @@ STACK_FRAME_NON_STANDARD(__crash_kexec);
 
 __bpf_kfunc void crash_kexec(struct pt_regs *regs)
 {
-	int old_cpu, this_cpu;
-
-	/*
-	 * Only one CPU is allowed to execute the crash_kexec() code as with
-	 * panic().  Otherwise parallel calls of panic() and crash_kexec()
-	 * may stop each other.  To exclude them, we use panic_cpu here too.
-	 */
-	old_cpu = PANIC_CPU_INVALID;
-	this_cpu = raw_smp_processor_id();
-
-	if (atomic_try_cmpxchg(&panic_cpu, &old_cpu, this_cpu)) {
+	if (panic_try_start()) {
 		/* This is the 1st CPU which comes here, so go ahead. */
 		__crash_kexec(regs);
 
@@ -161,7 +152,7 @@ __bpf_kfunc void crash_kexec(struct pt_r
 		 * Reset panic_cpu to allow another panic()/crash_kexec()
 		 * call.
 		 */
-		atomic_set(&panic_cpu, PANIC_CPU_INVALID);
+		panic_reset();
 	}
 }
 
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

