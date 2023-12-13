Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FE1928387
	for <mm-commits@vger.kernel.org>; Wed, 13 Dec 2023 18:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="G5/0gELS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF6DAC433CA;
	Wed, 13 Dec 2023 18:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702493514;
	bh=SbS6KVOMc+qJ241qYkBI4jWVb/+WNibqH/wbfHR2KgM=;
	h=Date:To:From:Subject:From;
	b=G5/0gELSTHG6/G5EeQWvxy3V1J/MXXB/G4E59n8z8QzOy6CqWEPRhm+Z9k8TASQLg
	 bF6b4f8c7HqnwRU8xXQ9yrb/yc1m9oxOsiOtbuseK/pQ7nunl8Rojgg8aSXLYG3KU5
	 7JFMC64G0gw/NgGsPsaLsD/FwE1REX1FnwRBPDUQ=
Date: Wed, 13 Dec 2023 10:51:54 -0800
To: mm-commits@vger.kernel.org,riel@surriel.com,hannes@cmpxchg.org,david@redhat.com,shr@devkernel.io,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-ksm-add-sysfs-knobs-for-advisor.patch added to mm-unstable branch
Message-Id: <20231213185154.AF6DAC433CA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/ksm: add sysfs knobs for advisor
has been added to the -mm mm-unstable branch.  Its filename is
     mm-ksm-add-sysfs-knobs-for-advisor.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-ksm-add-sysfs-knobs-for-advisor.patch

This patch will later appear in the mm-unstable branch at
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
From: Stefan Roesch <shr@devkernel.io>
Subject: mm/ksm: add sysfs knobs for advisor
Date: Wed, 13 Dec 2023 10:27:27 -0800

This adds four new knobs for the KSM advisor to influence its behaviour.

The knobs are:
- advisor_mode:
    none:      no advisor (default)
    scan-time: scan time advisor
- advisor_max_cpu: 70 (default, cpu usage percent)
- advisor_min_pages_to_scan: 500 (default)
- advisor_max_pages_to_scan: 30000 (default)
- advisor_target_scan_time: 200 (default in seconds)

The new values will take effect on the next scan round.

Link: https://lkml.kernel.org/r/20231213182729.587081-3-shr@devkernel.io
Signed-off-by: Stefan Roesch <shr@devkernel.io>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |  142 +++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 139 insertions(+), 3 deletions(-)

--- a/mm/ksm.c~mm-ksm-add-sysfs-knobs-for-advisor
+++ a/mm/ksm.c
@@ -302,10 +302,10 @@ unsigned long ksm_zero_pages;
 static unsigned long ksm_pages_skipped;
 
 /* Don't scan more than max pages per batch. */
-static unsigned long ksm_advisor_max_pages = 30000;
+static unsigned long ksm_advisor_max_pages_to_scan = 30000;
 
 /* At least scan this many pages per batch. */
-static unsigned long ksm_advisor_min_pages = 500;
+static unsigned long ksm_advisor_min_pages_to_scan = 500;
 
 /* Min CPU for scanning pages per scan */
 static unsigned int ksm_advisor_min_cpu =  10;
@@ -341,6 +341,16 @@ enum ksm_advisor_type {
 };
 static enum ksm_advisor_type ksm_advisor;
 
+static void set_advisor_defaults(void)
+{
+	if (ksm_advisor == KSM_ADVISOR_NONE) {
+		ksm_thread_pages_to_scan = DEFAULT_PAGES_TO_SCAN;
+	} else if (ksm_advisor == KSM_ADVISOR_SCAN_TIME) {
+		advisor_ctx = (const struct advisor_ctx){ 0 };
+		ksm_thread_pages_to_scan = ksm_advisor_min_pages_to_scan;
+	}
+}
+
 static inline void advisor_start_scan(void)
 {
 	if (ksm_advisor == KSM_ADVISOR_SCAN_TIME)
@@ -434,7 +444,7 @@ static void scan_time_advisor(void)
 
 	pages = min(pages, per_page_cost * ksm_advisor_max_cpu);
 	pages = max(pages, per_page_cost * ksm_advisor_min_cpu);
-	pages = min(pages, ksm_advisor_max_pages);
+	pages = min(pages, ksm_advisor_max_pages_to_scan);
 
 	/* Update advisor context */
 	advisor_ctx.change = change;
@@ -3724,6 +3734,127 @@ static ssize_t smart_scan_store(struct k
 }
 KSM_ATTR(smart_scan);
 
+static ssize_t advisor_mode_show(struct kobject *kobj,
+				 struct kobj_attribute *attr, char *buf)
+{
+	const char *output;
+
+	if (ksm_advisor == KSM_ADVISOR_NONE)
+		output = "[none] scan-time";
+	else if (ksm_advisor == KSM_ADVISOR_SCAN_TIME)
+		output = "none [scan-time]";
+
+	return sysfs_emit(buf, "%s\n", output);
+}
+
+static ssize_t advisor_mode_store(struct kobject *kobj,
+				  struct kobj_attribute *attr, const char *buf,
+				  size_t count)
+{
+	if (sysfs_streq("scan-time", buf))
+		ksm_advisor = KSM_ADVISOR_SCAN_TIME;
+	else if (sysfs_streq("none", buf))
+		ksm_advisor = KSM_ADVISOR_NONE;
+	else
+		return -EINVAL;
+
+	/* Set advisor default values */
+	set_advisor_defaults();
+
+	return count;
+}
+KSM_ATTR(advisor_mode);
+
+static ssize_t advisor_max_cpu_show(struct kobject *kobj,
+				    struct kobj_attribute *attr, char *buf)
+{
+	return sysfs_emit(buf, "%u\n", ksm_advisor_max_cpu);
+}
+
+static ssize_t advisor_max_cpu_store(struct kobject *kobj,
+				     struct kobj_attribute *attr,
+				     const char *buf, size_t count)
+{
+	int err;
+	unsigned long value;
+
+	err = kstrtoul(buf, 10, &value);
+	if (err)
+		return -EINVAL;
+
+	ksm_advisor_max_cpu = value;
+	return count;
+}
+KSM_ATTR(advisor_max_cpu);
+
+static ssize_t advisor_min_pages_to_scan_show(struct kobject *kobj,
+					struct kobj_attribute *attr, char *buf)
+{
+	return sysfs_emit(buf, "%lu\n", ksm_advisor_min_pages_to_scan);
+}
+
+static ssize_t advisor_min_pages_to_scan_store(struct kobject *kobj,
+					struct kobj_attribute *attr,
+					const char *buf, size_t count)
+{
+	int err;
+	unsigned long value;
+
+	err = kstrtoul(buf, 10, &value);
+	if (err)
+		return -EINVAL;
+
+	ksm_advisor_min_pages_to_scan = value;
+	return count;
+}
+KSM_ATTR(advisor_min_pages_to_scan);
+
+static ssize_t advisor_max_pages_to_scan_show(struct kobject *kobj,
+					struct kobj_attribute *attr, char *buf)
+{
+	return sysfs_emit(buf, "%lu\n", ksm_advisor_max_pages_to_scan);
+}
+
+static ssize_t advisor_max_pages_to_scan_store(struct kobject *kobj,
+					struct kobj_attribute *attr,
+					const char *buf, size_t count)
+{
+	int err;
+	unsigned long value;
+
+	err = kstrtoul(buf, 10, &value);
+	if (err)
+		return -EINVAL;
+
+	ksm_advisor_max_pages_to_scan = value;
+	return count;
+}
+KSM_ATTR(advisor_max_pages_to_scan);
+
+static ssize_t advisor_target_scan_time_show(struct kobject *kobj,
+					     struct kobj_attribute *attr, char *buf)
+{
+	return sysfs_emit(buf, "%lu\n", ksm_advisor_target_scan_time);
+}
+
+static ssize_t advisor_target_scan_time_store(struct kobject *kobj,
+					      struct kobj_attribute *attr,
+					      const char *buf, size_t count)
+{
+	int err;
+	unsigned long value;
+
+	err = kstrtoul(buf, 10, &value);
+	if (err)
+		return -EINVAL;
+	if (value < 1)
+		return -EINVAL;
+
+	ksm_advisor_target_scan_time = value;
+	return count;
+}
+KSM_ATTR(advisor_target_scan_time);
+
 static struct attribute *ksm_attrs[] = {
 	&sleep_millisecs_attr.attr,
 	&pages_to_scan_attr.attr,
@@ -3746,6 +3877,11 @@ static struct attribute *ksm_attrs[] = {
 	&use_zero_pages_attr.attr,
 	&general_profit_attr.attr,
 	&smart_scan_attr.attr,
+	&advisor_mode_attr.attr,
+	&advisor_max_cpu_attr.attr,
+	&advisor_min_pages_to_scan_attr.attr,
+	&advisor_max_pages_to_scan_attr.attr,
+	&advisor_target_scan_time_attr.attr,
 	NULL,
 };
 
_

Patches currently in -mm which might be from shr@devkernel.io are

mm-ksm-add-ksm-advisor.patch
mm-ksm-add-sysfs-knobs-for-advisor.patch
mm-ksm-add-tracepoint-for-ksm-advisor.patch
mm-ksm-document-ksm-advisor-and-its-sysfs-knobs.patch

