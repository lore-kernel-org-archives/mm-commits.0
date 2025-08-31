Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 094F21BD035
	for <mm-commits@vger.kernel.org>; Sun, 31 Aug 2025 20:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756671128; cv=none; b=Nl34Tjw2wr2BawYtCBHVsFLU39uXzfMARqUDFyDZs8XBFpjWxFe9gjsUp3XXgLuF1YiSzjvh+N4rJxHkISbviI8XHC20ZRvtTTPFws34xE9NorZOYfc4jo2D/KoBH9N7eZpVOM0obVL8EFYI2T/ECKhFkau0AMDtRc9C4dt43SE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756671128; c=relaxed/simple;
	bh=5N+D9Ln1kRe1qOtghYWEHnNrFR3kAGceXexdTpZeh2M=;
	h=Date:To:From:Subject:Message-Id; b=nAdJxiDja1mCjPk11LovE8sIeP2/taDea3gozmXCZDvp4mDgpX1sPIjesfbWqC1DNvllCE3jUREjtvaLr3wB2peypLTrPj0UCKERPzlWswuLVS8Ij+NFW0EDaPyYTH2QUIK5WLKpQ1qwT0XdySuHL8ZDR1OX2ChFdXiOg76WLBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HpSPHXJ1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HpSPHXJ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79F63C4CEF5;
	Sun, 31 Aug 2025 20:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756671127;
	bh=5N+D9Ln1kRe1qOtghYWEHnNrFR3kAGceXexdTpZeh2M=;
	h=Date:To:From:Subject:From;
	b=HpSPHXJ1S8k4liYMMMOH/b4ekPpa9IOaqcuRBqpBnTT0lEvRkFsGISoE9K5i2804+
	 spjBeAfBiKSZyh3qUvbwfZmAaaUCrxDlpby6QiZ1WuQyPQ+8qaa+QtynndbaUq6Rjz
	 xOWQy/QaEw5yZYoaNMadZxBdK3MvQrat/K5bfhBU=
Date: Sun, 31 Aug 2025 13:12:06 -0700
To: mm-commits@vger.kernel.org,senozhatsky@chromium.org,rostedt@goodmis.org,qianqiang.liu@163.com,pmladek@suse.com,john.ogness@linutronix.de,wangjinchao600@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + panic-use-angle-bracket-include-for-panich.patch added to mm-nonmm-unstable branch
Message-Id: <20250831201207.79F63C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: panic: use angle-bracket include for panic.h
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     panic-use-angle-bracket-include-for-panich.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/panic-use-angle-bracket-include-for-panich.patch

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
Subject: panic: use angle-bracket include for panic.h
Date: Fri, 29 Aug 2025 13:13:02 +0800

Replace quoted includes of panic.h with `#include <linux/panic.h>` for
consistency across the kernel.

Link: https://lkml.kernel.org/r/20250829051312.33773-1-wangjinchao600@gmail.com
Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
Reviewed-by: John Ogness <john.ogness@linutronix.de>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Cc: Qianqiang Liu <qianqiang.liu@163.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/crash_core.c    |    2 +-
 kernel/printk/nbcon.c  |    2 +-
 kernel/printk/printk.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

--- a/kernel/crash_core.c~panic-use-angle-bracket-include-for-panich
+++ a/kernel/crash_core.c
@@ -4,7 +4,6 @@
  * Copyright (C) 2002-2004 Eric Biederman  <ebiederm@xmission.com>
  */
 
-#include "linux/panic.h"
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/buildid.h>
@@ -23,6 +22,7 @@
 #include <linux/btf.h>
 #include <linux/objtool.h>
 #include <linux/delay.h>
+#include <linux/panic.h>
 
 #include <asm/page.h>
 #include <asm/sections.h>
--- a/kernel/printk/nbcon.c~panic-use-angle-bracket-include-for-panich
+++ a/kernel/printk/nbcon.c
@@ -2,7 +2,6 @@
 // Copyright (C) 2022 Linutronix GmbH, John Ogness
 // Copyright (C) 2022 Intel, Thomas Gleixner
 
-#include "linux/panic.h"
 #include <linux/atomic.h>
 #include <linux/bug.h>
 #include <linux/console.h>
@@ -13,6 +12,7 @@
 #include <linux/irqflags.h>
 #include <linux/kthread.h>
 #include <linux/minmax.h>
+#include <linux/panic.h>
 #include <linux/percpu.h>
 #include <linux/preempt.h>
 #include <linux/slab.h>
--- a/kernel/printk/printk.c~panic-use-angle-bracket-include-for-panich
+++ a/kernel/printk/printk.c
@@ -17,7 +17,6 @@
  *	01Mar01 Andrew Morton
  */
 
-#include "linux/panic.h"
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/kernel.h>
@@ -49,6 +48,7 @@
 #include <linux/sched/clock.h>
 #include <linux/sched/debug.h>
 #include <linux/sched/task_stack.h>
+#include <linux/panic.h>
 
 #include <linux/uaccess.h>
 #include <asm/sections.h>
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
panic-use-angle-bracket-include-for-panich.patch

