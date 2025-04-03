Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 719FA14386D
	for <mm-commits@vger.kernel.org>; Thu,  3 Apr 2025 02:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743648967; cv=none; b=cq8L/U4+RzWSmZTNUbJFEbtTdAtGYLh4QTZLYjFp3aZRWcSByhUOCcbDMLeMRxvPk3hq/oBdgVVYiegbdxhX9pcQlYGkvblEf33KzuNLN6YlAgPwydrfsAP2PBk+NA6/tUsXwAYVP1206NhzHK5V9iPP+FTsUOR9plv9PThvCbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743648967; c=relaxed/simple;
	bh=ErKFkpix+sKY4d3iomCCquunQxL+ID0KzoLN2uLkp5U=;
	h=Date:To:From:Subject:Message-Id; b=oYUrKMTJaDV2dFigPdYZtbU0FZ8hQVCngKe9ovPPv53MsrbIOiGbKZlpYA7s60Eam2mgtRQT3PX93XHcnaJrI91g+qMZ7e+pJzVonASF87E3ar4rJrwqs7CS9CspZH25ZUR4c2lGn32hZrzEy01It7rUi8Tp404Pci174vJJqcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IPo/Kcjb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IPo/Kcjb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC492C4CEE9;
	Thu,  3 Apr 2025 02:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743648965;
	bh=ErKFkpix+sKY4d3iomCCquunQxL+ID0KzoLN2uLkp5U=;
	h=Date:To:From:Subject:From;
	b=IPo/KcjbyOhYkvI94u57wBVL6es6wmRvu1Am5gmgp5Y9Sf+yPp340QVcgYoMHCHLG
	 ozU5huaFgXxVC0Ndqeta6+VETvb+brItLnL+7fmtfFqEZa7QX9Co3RJto6Z2L8xR11
	 niwqQ0ycevFB+hOGp+fqNkWMglHLdLm6MROisl2w=
Date: Wed, 02 Apr 2025 19:56:05 -0700
To: mm-commits@vger.kernel.org,tim.bird@sony.com,rostedt@goodmis.org,francesco@valla.it,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + init-mainc-log-initcall-level-when-initcall_debug-is-used.patch added to mm-nonmm-unstable branch
Message-Id: <20250403025605.DC492C4CEE9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: init/main.c: log initcall level when initcall_debug is used
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     init-mainc-log-initcall-level-when-initcall_debug-is-used.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/init-mainc-log-initcall-level-when-initcall_debug-is-used.patch

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
From: Francesco Valla <francesco@valla.it>
Subject: init/main.c: log initcall level when initcall_debug is used
Date: Sun, 16 Mar 2025 21:50:15 +0100

When initcall_debug is specified on the command line, the start and return
point for each initcall is printed.  However, no information on the
initcall level is reported.

Add to the initcall_debug infrastructure an additional print that informs
when a new initcall level is entered.  This is particularly useful when
debugging dependency chains and/or working on boot time reduction.

Link: https://lkml.kernel.org/r/20250316205014.2830071-2-francesco@valla.it
Signed-off-by: Francesco Valla <francesco@valla.it>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tim Bird <tim.bird@sony.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/init/main.c~init-mainc-log-initcall-level-when-initcall_debug-is-used
+++ a/init/main.c
@@ -1214,6 +1214,12 @@ trace_initcall_finish_cb(void *data, ini
 		 fn, ret, (unsigned long long)ktime_us_delta(rettime, *calltime));
 }
 
+static __init_or_module void
+trace_initcall_level_cb(void *data, const char *level)
+{
+	printk(KERN_DEBUG "entering initcall level: %s\n", level);
+}
+
 static ktime_t initcall_calltime;
 
 #ifdef TRACEPOINTS_ENABLED
@@ -1225,10 +1231,12 @@ static void __init initcall_debug_enable
 					    &initcall_calltime);
 	ret |= register_trace_initcall_finish(trace_initcall_finish_cb,
 					      &initcall_calltime);
+	ret |= register_trace_initcall_level(trace_initcall_level_cb, NULL);
 	WARN(ret, "Failed to register initcall tracepoints\n");
 }
 # define do_trace_initcall_start	trace_initcall_start
 # define do_trace_initcall_finish	trace_initcall_finish
+# define do_trace_initcall_level	trace_initcall_level
 #else
 static inline void do_trace_initcall_start(initcall_t fn)
 {
@@ -1242,6 +1250,12 @@ static inline void do_trace_initcall_fin
 		return;
 	trace_initcall_finish_cb(&initcall_calltime, fn, ret);
 }
+static inline void do_trace_initcall_level(const char *level)
+{
+	if (!initcall_debug)
+		return;
+	trace_initcall_level_cb(NULL, level);
+}
 #endif /* !TRACEPOINTS_ENABLED */
 
 int __init_or_module do_one_initcall(initcall_t fn)
@@ -1314,7 +1328,7 @@ static void __init do_initcall_level(int
 		   level, level,
 		   NULL, ignore_unknown_bootoption);
 
-	trace_initcall_level(initcall_level_names[level]);
+	do_trace_initcall_level(initcall_level_names[level]);
 	for (fn = initcall_levels[level]; fn < initcall_levels[level+1]; fn++)
 		do_one_initcall(initcall_from_entry(fn));
 }
@@ -1358,7 +1372,7 @@ static void __init do_pre_smp_initcalls(
 {
 	initcall_entry_t *fn;
 
-	trace_initcall_level("early");
+	do_trace_initcall_level("early");
 	for (fn = __initcall_start; fn < __initcall0_start; fn++)
 		do_one_initcall(initcall_from_entry(fn));
 }
_

Patches currently in -mm which might be from francesco@valla.it are

init-mainc-log-initcall-level-when-initcall_debug-is-used.patch

