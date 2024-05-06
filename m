Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F10453B79F
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 01:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714958114; cv=none; b=UnThvtkZOhQfsoJNn+kD38UAyJKp1Hf6d8AwStsLtVNL06FQN7o78Hl4ZOBabJV4ZvOShY5cO4OOv0fagXEISX0y71aiYo1M5FpSYYJzFulpCEy0kBz+VhmRuoT6/0CCfKl6GClwH7cFtmLgZkgK5WrtcWjHOTSKIyzwI/IcBco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714958114; c=relaxed/simple;
	bh=ce6HhbS35wfmUV+4eu2gLnXRe1ZzkVbzTjaDHFVWqZs=;
	h=Date:To:From:Subject:Message-Id; b=XaTZ0sP2eoTzyRI3Qa3KhK095yZa3vtOk7/kN3ALQDfAugAfbEvf8X6JphlauQxgof0H6h9I3qKByIcamnfEgHcMdfR5++AeCxLKNnDdKubz55yYoRha74XfIlKSjDJE9s6UrbMQYMF7nRAevig4MAqaXxOSU6ADBW8pfR0PPLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2L/6IJQu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2L/6IJQu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C53DFC113CC;
	Mon,  6 May 2024 01:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714958113;
	bh=ce6HhbS35wfmUV+4eu2gLnXRe1ZzkVbzTjaDHFVWqZs=;
	h=Date:To:From:Subject:From;
	b=2L/6IJQuEILAUQLW8cZCnkNe/3H5QGtK3A/a48WCe4xY7+wICBusVaall+PEl4+AL
	 iFYjdBQDDTdWrvxZ1+tkzb+Usicw6khcHrXDANbSRRBqdFU9er0gPKbTQ48Q6CV9P3
	 vkxV+VkkubzVjiNX8o0wTUTFcmDTUNIDdeepaHRU=
Date: Sun, 05 May 2024 18:15:13 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,peterz@infradead.org,song@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] watchdog-allow-nmi-watchdog-to-use-raw-perf-event.patch removed from -mm tree
Message-Id: <20240506011513.C53DFC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: watchdog: allow nmi watchdog to use raw perf event
has been removed from the -mm tree.  Its filename was
     watchdog-allow-nmi-watchdog-to-use-raw-perf-event.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

[akpm@linux-foundation.org: fix kerneldoc]
Link: https://lkml.kernel.org/r/20240430060236.1878002-2-song@kernel.org
Signed-off-by: Song Liu <song@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kernel-parameters.txt |    5 -
 include/linux/nmi.h                             |    2 
 kernel/watchdog.c                               |    2 
 kernel/watchdog_perf.c                          |   46 ++++++++++++++
 4 files changed, 53 insertions(+), 2 deletions(-)

--- a/Documentation/admin-guide/kernel-parameters.txt~watchdog-allow-nmi-watchdog-to-use-raw-perf-event
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -3773,10 +3773,12 @@
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
@@ -7464,4 +7466,3 @@
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
@@ -259,3 +274,34 @@ int __init watchdog_hardlockup_probe(voi
 	}
 	return ret;
 }
+
+/**
+ * hardlockup_config_perf_event - Overwrite config of wd_hw_attr.
+ *
+ * @str: number which identifies the raw perf event to use
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


