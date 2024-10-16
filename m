Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E4101D54E5
	for <mm-commits@vger.kernel.org>; Wed, 16 Oct 2024 23:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729120421; cv=none; b=slSM55G/ZjznrWVU/fQVeLtkRFxoqJEFHWybGtgCJG7L7iKJZw3G+rgigZwWo31IP/3xGKKrBB/QeuJ/QZzW5F6EMPMGD+izmx/8osrmPgnauskfBT+KVc5xtFHm7qosYQhjiMsmYgFXQ2T9uIsIQ67DAGKT9GAybIDGcVTmrhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729120421; c=relaxed/simple;
	bh=6z74bCGkZb8c2WWRdPcNSAAiERRauzTcT8PAM0sGatw=;
	h=Date:To:From:Subject:Message-Id; b=H8u9AtGtoNS0Xd33+QXoxz22vjdlgDkMi/xRZiEv5iqmHvQrrVUMyThs6GE/mZmXg07G/jTYdAOMFRBHlWMh7uLIatXu1KBfdHylADqGyLNH6UROoL/3oTC8uIFYSJZGLahPzjxW4nuMIsoYi6wJJOLLTwkGzJEeqjyh+Wszp08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WmkA8ruf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WmkA8ruf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7B42C4CEC5;
	Wed, 16 Oct 2024 23:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729120421;
	bh=6z74bCGkZb8c2WWRdPcNSAAiERRauzTcT8PAM0sGatw=;
	h=Date:To:From:Subject:From;
	b=WmkA8rufrbhcs2Im3HMEKWDpxyuVx4XuoIO/OQLvSiTfbctrGVB1WCU1bjaYtapFe
	 pvO02dnSbBzOznR6wEXcgWSord0IXD7hHP3ZuZZ0Pce+b1gCM6NlA5hsFIR9nyNOtl
	 qW4wfvuRENMMoqXtY94NpQZojQhIi1A85sgM13Tw=
Date: Wed, 16 Oct 2024 16:13:40 -0700
To: mm-commits@vger.kernel.org,mark.rutland@arm.com,kan.liang@linux.intel.com,jolsa@kernel.org,irogers@google.com,alexander.shishkin@linux.intel.com,adrian.hunter@intel.com,ubizjak@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + perf-hw_breakpoint-use-err_ptr_pcpu-is_err_pcpu-and-ptr_err_pcpu-macros.patch added to mm-nonmm-unstable branch
Message-Id: <20241016231340.E7B42C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: perf/hw_breakpoint: use ERR_PTR_PCPU(), IS_ERR_PCPU() and PTR_ERR_PCPU() macros
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     perf-hw_breakpoint-use-err_ptr_pcpu-is_err_pcpu-and-ptr_err_pcpu-macros.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/perf-hw_breakpoint-use-err_ptr_pcpu-is_err_pcpu-and-ptr_err_pcpu-macros.patch

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
From: Uros Bizjak <ubizjak@gmail.com>
Subject: perf/hw_breakpoint: use ERR_PTR_PCPU(), IS_ERR_PCPU() and PTR_ERR_PCPU() macros
Date: Tue, 24 Sep 2024 11:07:13 +0200

Use ERR_PTR_PCPU() when returning error pointer in the percpu address
space.  Use IS_ERR_PCPU() and PTR_ERR_PCPU() when returning the error
pointer from the percpu address space.  These macros add intermediate cast
to unsigned long when switching named address spaces.

The patch will avoid future build errors due to pointer address space
mismatch with enabled strict percpu address space checks.

Link: https://lkml.kernel.org/r/20240924090813.1353586-1-ubizjak@gmail.com
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: "Liang, Kan" <kan.liang@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/events/hw_breakpoint.c           |    4 ++--
 samples/hw_breakpoint/data_breakpoint.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/kernel/events/hw_breakpoint.c~perf-hw_breakpoint-use-err_ptr_pcpu-is_err_pcpu-and-ptr_err_pcpu-macros
+++ a/kernel/events/hw_breakpoint.c
@@ -849,7 +849,7 @@ register_wide_hw_breakpoint(struct perf_
 
 	cpu_events = alloc_percpu(typeof(*cpu_events));
 	if (!cpu_events)
-		return (void __percpu __force *)ERR_PTR(-ENOMEM);
+		return ERR_PTR_PCPU(-ENOMEM);
 
 	cpus_read_lock();
 	for_each_online_cpu(cpu) {
@@ -868,7 +868,7 @@ register_wide_hw_breakpoint(struct perf_
 		return cpu_events;
 
 	unregister_wide_hw_breakpoint(cpu_events);
-	return (void __percpu __force *)ERR_PTR(err);
+	return ERR_PTR_PCPU(err);
 }
 EXPORT_SYMBOL_GPL(register_wide_hw_breakpoint);
 
--- a/samples/hw_breakpoint/data_breakpoint.c~perf-hw_breakpoint-use-err_ptr_pcpu-is_err_pcpu-and-ptr_err_pcpu-macros
+++ a/samples/hw_breakpoint/data_breakpoint.c
@@ -52,8 +52,8 @@ static int __init hw_break_module_init(v
 	attr.bp_type = HW_BREAKPOINT_W;
 
 	sample_hbp = register_wide_hw_breakpoint(&attr, sample_hbp_handler, NULL);
-	if (IS_ERR((void __force *)sample_hbp)) {
-		ret = PTR_ERR((void __force *)sample_hbp);
+	if (IS_ERR_PCPU(sample_hbp)) {
+		ret = PTR_ERR_PCPU(sample_hbp);
 		goto fail;
 	}
 
_

Patches currently in -mm which might be from ubizjak@gmail.com are

perf-hw_breakpoint-use-err_ptr_pcpu-is_err_pcpu-and-ptr_err_pcpu-macros.patch

