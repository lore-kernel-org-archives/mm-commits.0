Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B73C2EB10
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011340; cv=none; b=sXbpaeqfKqcJvcO19t+DX7Um1fhS/dBdGenw/Mg4ud0Ekh86XgRBHzuD+DExnRzjTxxr+HRSTrMR5nYp/nvWLGlWWtgnUroU/qL4e6+Wp7eBzZguw8CSyMdECG3ttvKPiadVISxsnkkIJaBKZUWfrl6aNDu9/mKURMdx+BLTLJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011340; c=relaxed/simple;
	bh=hCQC3s2YyE8Y7owf4+2iHqx2hmyVPMJhcxwUnd4M4Eg=;
	h=Date:To:From:Subject:Message-Id; b=Gam6ob6j07Y+GtkdB3vi7PqtI8hlhbqYUgJUc0XtGkLqEcEB+Gcw/BMm0Nd27dtzyEFrY5fcKL8khUvIyT1sMBXXqTzLbWqyy94djrZI4hWeWdTus37881zUoOafxGFbluOeokeRsgZJj+Ob/1/kwTNqlHEUjXFAMDGRivmey3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SIuMnuq7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SIuMnuq7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BD6FC4CEEF;
	Mon, 12 May 2025 00:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011339;
	bh=hCQC3s2YyE8Y7owf4+2iHqx2hmyVPMJhcxwUnd4M4Eg=;
	h=Date:To:From:Subject:From;
	b=SIuMnuq7g1+ZxdMS2TNe2JHjevSN+aowfeyIOtAN2e9FFlSs3v+O/+7UCoXEgUWtH
	 iASEJms8eaCWQJggbXk88OCPSQ6cbTKLhUdiXRHdB28C2kJmHES4ugkMvYi8CTHQGO
	 5MBfQIad1vr6+oQm5D1jPiUKMQyrEnXMwMqgi9LM=
Date: Sun, 11 May 2025 17:55:39 -0700
To: mm-commits@vger.kernel.org,tim.bird@sony.com,rostedt@goodmis.org,francesco@valla.it,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] init-mainc-log-initcall-level-when-initcall_debug-is-used.patch removed from -mm tree
Message-Id: <20250512005539.9BD6FC4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: init/main.c: log initcall level when initcall_debug is used
has been removed from the -mm tree.  Its filename was
     init-mainc-log-initcall-level-when-initcall_debug-is-used.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


