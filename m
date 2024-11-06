Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDAA516FF45
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730855629; cv=none; b=FLXNwUBp2fFoJG7JKuWsxX9bvtgvsWJgdazjnEQC8tL6zCxUmO5qcip5IsASJVh2qfa+4aA/Tk++RUISudyaMCH355aiTwOiYVZI2VBr8DzH7DvhCsYRakl2xGfUXchuhk313UywBSMszL6YV9JN1kBlD8gxPMJwt7OujwDE5As=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730855629; c=relaxed/simple;
	bh=0vAHtiDcS331IQnu+cGlNlbuUUUPRMxSIh4LsXCliKo=;
	h=Date:To:From:Subject:Message-Id; b=ee0h9BQ03pyi+CJPd227k41GXeAmM+UOtTqLcJbsqj9wRRWNUoEwkJgnBxJUDQ0Ksl0sca9xdn4KQ/92+6q/p2GcScwQeyf/N2R47gns1wrwNRVFfTLZXQsFzGtSF4TXo1nMJnJMF4em+aArO49ff03xoOB13OaChPoXsSUUfiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0ac/xYEn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0ac/xYEn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1333C4CECF;
	Wed,  6 Nov 2024 01:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730855629;
	bh=0vAHtiDcS331IQnu+cGlNlbuUUUPRMxSIh4LsXCliKo=;
	h=Date:To:From:Subject:From;
	b=0ac/xYEnP2lDwrhAAn4dQJxoMF8dU4zKwXRtxdPD4zRPehsogKygYgjbgtqOLFhpZ
	 H7X1XOZgqIS5fwtgMLMdhQyTghq4WA8Bop4UPi+CD8jLtCID1LIP3i7zYEEMYjiZ+W
	 r/JphkU1KfvCannqwY5zjzGHg81mCUvgWgxnTVNo=
Date: Tue, 05 Nov 2024 17:13:49 -0800
To: mm-commits@vger.kernel.org,mark.rutland@arm.com,kan.liang@linux.intel.com,jolsa@kernel.org,irogers@google.com,alexander.shishkin@linux.intel.com,adrian.hunter@intel.com,ubizjak@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] perf-hw_breakpoint-use-err_ptr_pcpu-is_err_pcpu-and-ptr_err_pcpu-macros.patch removed from -mm tree
Message-Id: <20241106011349.A1333C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: perf/hw_breakpoint: use ERR_PTR_PCPU(), IS_ERR_PCPU() and PTR_ERR_PCPU() macros
has been removed from the -mm tree.  Its filename was
     perf-hw_breakpoint-use-err_ptr_pcpu-is_err_pcpu-and-ptr_err_pcpu-macros.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


