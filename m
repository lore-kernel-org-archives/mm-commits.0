Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C9E6184540
	for <mm-commits@vger.kernel.org>; Sun, 14 Sep 2025 00:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757810152; cv=none; b=M8thUG/TFoavNSfyDeEvI5bh1gfEGIBfzgqFz6iLsJ+LcEeMxLCTtEf+tbaGc674QRzOyRWRsGQLSpCvF/laaAscKTd8+AcZVLWJx16ZRWASh0xUsvOCJvmKV1FZgXM5Wdu8kOYMnfiIyo2lFncEOh296OMS9z6MWtLCShSzCNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757810152; c=relaxed/simple;
	bh=Ce6iwWGfhCwLb/dszKVYalxszNSAcdDkQpeAbqSAeGI=;
	h=Date:To:From:Subject:Message-Id; b=d0/v2sMbG4q2f4PofWcbFkHzfD9glFWRSIX7MzKa94aIyYMS6FrEFsLzMJEWrS8TtRb9FsBEWqUEV0PbHLnv2CV3X3E0+BBQ3z/rYI0jVHVfqsJHuXNz1VeU704q9zGf88v3Xw1llLb85TKgvOlOVR+W9jvnipL/K9KCjvy2Rog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lv42bB3L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lv42bB3L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62054C4CEEB;
	Sun, 14 Sep 2025 00:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757810152;
	bh=Ce6iwWGfhCwLb/dszKVYalxszNSAcdDkQpeAbqSAeGI=;
	h=Date:To:From:Subject:From;
	b=lv42bB3LjZddd5/gUpGdKa8beh8hKG434Of4/ZOY875FkF9XO2wJmYgg5Ut0bbERR
	 vkbE5kdlU+R/tRHTz63ccCFNAvZ0TK3hkknL8UcE0zhMP3aQxdM8QXoBhlQvhSCZKt
	 BWC5+cROSQHT8u+IIyg9vd0B2BfbtwT/+hMhIW5I=
Date: Sat, 13 Sep 2025 17:35:51 -0700
To: mm-commits@vger.kernel.org,senozhatsky@chromium.org,rostedt@goodmis.org,qianqiang.liu@163.com,pmladek@suse.com,john.ogness@linutronix.de,wangjinchao600@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] panic-use-angle-bracket-include-for-panich.patch removed from -mm tree
Message-Id: <20250914003552.62054C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: panic: use angle-bracket include for panic.h
has been removed from the -mm tree.  Its filename was
     panic-use-angle-bracket-include-for-panich.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


