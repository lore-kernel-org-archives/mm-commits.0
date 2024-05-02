Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E59F16FF38
	for <mm-commits@vger.kernel.org>; Thu,  2 May 2024 16:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714668696; cv=none; b=u7yAUuXCGTvXPuP0g3zYHQnxh+qsxyvqwUjqYULBKcmES1BXaQ7HAuthtGrYIEitBnwkN8UJkKjCsyUvOekZawu9qacPZ+jtzVAqyRysJLn8rTwWrafLVdfX5eRH9UBfXGpR2z9F1UDo1+8Y2qREkw0PKbcP0XNJRg8cj/VMHTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714668696; c=relaxed/simple;
	bh=ibs1vWNeKtIhGuZydDFC5AgDUXMGDBqZ2OknN8prWEk=;
	h=Date:To:From:Subject:Message-Id; b=jp9MvSlD/eanE8p8Hi+FSkTVrq4TZS8TukXQF6ScodaHyTcb2FnEhGcpt2sCt2Eu8YgdGyQdK97tPc2SqRjZ9c/aREnpYPyoKI96s9e7V9yMbGDNG6IME4HnW0vKuTepsAV73+SQydeqTWFPbn0JensusyLdPY/K8RtIjuj+rxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Eyofd233; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Eyofd233"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 729BDC113CC;
	Thu,  2 May 2024 16:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714668695;
	bh=ibs1vWNeKtIhGuZydDFC5AgDUXMGDBqZ2OknN8prWEk=;
	h=Date:To:From:Subject:From;
	b=Eyofd233gZ2kazH8rbPlduE8hBRko2hZK6Z7XI3Whd3W8mN0y8UAwRcDThQ16hplZ
	 WD3EceMtAdKHktuIqbRIIeV10ekxPdV0nbnwNMZfDvCPOWGvGmeoukzxXoWFuvUNHZ
	 iF0unkUkZBgKABcVawqFa8XrsS5EEV2uOIc8r5ac=
Date: Thu, 02 May 2024 09:51:34 -0700
To: mm-commits@vger.kernel.org,peterz@infradead.org,song@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + watchdog-allow-nmi-watchdog-to-use-raw-perf-event.patch added to mm-nonmm-unstable branch
Message-Id: <20240502165135.729BDC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: watchdog: allow nmi watchdog to use raw perf event
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     watchdog-allow-nmi-watchdog-to-use-raw-perf-event.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/watchdog-allow-nmi-watchdog-to-use-raw-perf-event.patch

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
From: Song Liu <song@kernel.org>
Subject: watchdog: allow nmi watchdog to use raw perf event
Date: Mon, 29 Apr 2024 23:02:36 -0700

NMI watchdog permanently consumes one hardware counters per CPU on the
system.  For systems that use many hardware counters, this causes more
aggressive time multiplexing of perf events.

OTOH, some CPUs (mostly Intel) support "ref-cycles" event, which is rarely
used.  Add kernel cmdline arg nmi_watchdog=rNNN to configure the watchdog
to use raw event.  For example, on Intel CPUs, we can use "r300" to
configure the watchdog to use ref-cycles event.

If the raw event does not work, fall back to use "cycles".

Link: https://lkml.kernel.org/r/20240430060236.1878002-2-song@kernel.org
Signed-off-by: Song Liu <song@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kernel-parameters.txt |    5 -
 include/linux/nmi.h                             |    2 
 kernel/watchdog.c                               |    2 
 kernel/watchdog_perf.c                          |   44 ++++++++++++++
 4 files changed, 51 insertions(+), 2 deletions(-)

--- a/Documentation/admin-guide/kernel-parameters.txt~watchdog-allow-nmi-watchdog-to-use-raw-perf-event
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -3779,10 +3779,12 @@
 			Format: [state][,regs][,debounce][,die]
 
 	nmi_watchdog=	[KNL,BUGS=X86] Debugging features for SMP kernels
-			Format: [panic,][nopanic,][num]
+			Format: [panic,][nopanic,][rNNN,][num]
 			Valid num: 0 or 1
 			0 - turn hardlockup detector in nmi_watchdog off
 			1 - turn hardlockup detector in nmi_watchdog on
+			rNNN - configure the watchdog with raw perf event 0xNNN
+
 			When panic is specified, panic when an NMI watchdog
 			timeout occurs (or 'nopanic' to not panic on an NMI
 			watchdog, if CONFIG_BOOTPARAM_HARDLOCKUP_PANIC is set)
@@ -7470,4 +7472,3 @@
 				memory, and other data can't be written using
 				xmon commands.
 			off	xmon is disabled.
-
--- a/include/linux/nmi.h~watchdog-allow-nmi-watchdog-to-use-raw-perf-event
+++ a/include/linux/nmi.h
@@ -105,10 +105,12 @@ void watchdog_hardlockup_check(unsigned
 extern void hardlockup_detector_perf_stop(void);
 extern void hardlockup_detector_perf_restart(void);
 extern void hardlockup_detector_perf_cleanup(void);
+extern void hardlockup_config_perf_event(const char *str);
 #else
 static inline void hardlockup_detector_perf_stop(void) { }
 static inline void hardlockup_detector_perf_restart(void) { }
 static inline void hardlockup_detector_perf_cleanup(void) { }
+static inline void hardlockup_config_perf_event(const char *str) { }
 #endif
 
 void watchdog_hardlockup_stop(void);
--- a/kernel/watchdog.c~watchdog-allow-nmi-watchdog-to-use-raw-perf-event
+++ a/kernel/watchdog.c
@@ -80,6 +80,8 @@ next:
 		watchdog_hardlockup_user_enabled = 0;
 	else if (!strncmp(str, "1", 1))
 		watchdog_hardlockup_user_enabled = 1;
+	else if (!strncmp(str, "r", 1))
+		hardlockup_config_perf_event(str + 1);
 	while (*(str++)) {
 		if (*str == ',') {
 			str++;
--- a/kernel/watchdog_perf.c~watchdog-allow-nmi-watchdog-to-use-raw-perf-event
+++ a/kernel/watchdog_perf.c
@@ -90,6 +90,14 @@ static struct perf_event_attr wd_hw_attr
 	.disabled	= 1,
 };
 
+static struct perf_event_attr fallback_wd_hw_attr = {
+	.type		= PERF_TYPE_HARDWARE,
+	.config		= PERF_COUNT_HW_CPU_CYCLES,
+	.size		= sizeof(struct perf_event_attr),
+	.pinned		= 1,
+	.disabled	= 1,
+};
+
 /* Callback function for perf event subsystem */
 static void watchdog_overflow_callback(struct perf_event *event,
 				       struct perf_sample_data *data,
@@ -123,6 +131,13 @@ static int hardlockup_detector_event_cre
 	evt = perf_event_create_kernel_counter(wd_attr, cpu, NULL,
 					       watchdog_overflow_callback, NULL);
 	if (IS_ERR(evt)) {
+		wd_attr = &fallback_wd_hw_attr;
+		wd_attr->sample_period = hw_nmi_get_sample_period(watchdog_thresh);
+		evt = perf_event_create_kernel_counter(wd_attr, cpu, NULL,
+						       watchdog_overflow_callback, NULL);
+	}
+
+	if (IS_ERR(evt)) {
 		pr_debug("Perf event create on CPU %d failed with %ld\n", cpu,
 			 PTR_ERR(evt));
 		return PTR_ERR(evt);
@@ -259,3 +274,32 @@ int __init watchdog_hardlockup_probe(voi
 	}
 	return ret;
 }
+
+/**
+ * hardlockup_config_perf_event - Overwrite config of wd_hw_attr.
+ */
+void __init hardlockup_config_perf_event(const char *str)
+{
+	u64 config;
+	char buf[24];
+	char *comma = strchr(str, ',');
+
+	if (!comma) {
+		if (kstrtoull(str, 16, &config))
+			return;
+	} else {
+		unsigned int len = comma - str;
+
+		if (len >= sizeof(buf))
+			return;
+
+		if (strscpy(buf, str, sizeof(buf)) < 0)
+			return;
+		buf[len] = 0;
+		if (kstrtoull(buf, 16, &config))
+			return;
+	}
+
+	wd_hw_attr.type = PERF_TYPE_RAW;
+	wd_hw_attr.config = config;
+}
_

Patches currently in -mm which might be from song@kernel.org are

watchdog-handle-comma-separated-nmi_watchdog-command-line.patch
watchdog-allow-nmi-watchdog-to-use-raw-perf-event.patch

