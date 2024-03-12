Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D2621428E8
	for <mm-commits@vger.kernel.org>; Tue, 12 Mar 2024 20:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710274187; cv=none; b=Tjh8FWwZbac8OohUbP8QxVoYMF4vkXMMVlZn1gEpKebjTy8D7hqP/AlLqru0F7xRGk2YHDX96DxCQ+F6XejxfcPwMgOR9veMUZk51Nx95lY90C75znkXni8URGeVUgeTxOL7c2FdFrvKDsrISkYJkdsOj6NiHw02ihiRoEEJseg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710274187; c=relaxed/simple;
	bh=dZvVU2d2fk4lGEIYNxnlhD+9Q5VBTZfZHAdcTi6M/QE=;
	h=Date:To:From:Subject:Message-Id; b=idHFJFgWUugOdHhGZgPW4H/SdQO3mYv1CVh+peEDKMttXLBqpJsGnldi27lH/NDFnTyJGPH6Xxz/tpIvorc5mg3qWfhkAyCZUYqh0O1kwj7fVf/qGXXIMxYAzZSpR1AI0lyolM3wrmGSUCRBsCcruA2TYzfG7LxwYLUL2VhkzWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2lR3cRq4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2lR3cRq4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21657C433C7;
	Tue, 12 Mar 2024 20:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1710274187;
	bh=dZvVU2d2fk4lGEIYNxnlhD+9Q5VBTZfZHAdcTi6M/QE=;
	h=Date:To:From:Subject:From;
	b=2lR3cRq4THWIYONT3S+HAHZKWCMHw0kLSvcya5+96Z5L5UYnS/qrqZm6HwtH6cBmO
	 KNtD15h87w36Ees1HzI7WwxCXDxpky/a21wMmbPMYU3Z33212jPnuB/R/rmtKDlmd3
	 0E9EBh3hecUm0CEuO84+tIyPxwol3hME1m8Xz6UU=
Date: Tue, 12 Mar 2024 13:09:46 -0700
To: mm-commits@vger.kernel.org,linux@weissschuh.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] watchdog-core-remove-sysctl-handlers-from-public-header.patch removed from -mm tree
Message-Id: <20240312200947.21657C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: watchdog/core: remove sysctl handlers from public header
has been removed from the -mm tree.  Its filename was
     watchdog-core-remove-sysctl-handlers-from-public-header.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Thomas Weißschuh <linux@weissschuh.net>
Subject: watchdog/core: remove sysctl handlers from public header
Date: Wed, 06 Mar 2024 07:49:16 +0100

The functions are only used in the file where they are defined.  Remove
them from the header and make them static.

Also guard proc_soft_watchdog with a #define-guard as it is not used
otherwise.

Link: https://lkml.kernel.org/r/20240306-const-sysctl-prep-watchdog-v1-1-bd45da3a41cf@weissschuh.net
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/nmi.h |    7 -------
 kernel/watchdog.c   |   22 ++++++++++++----------
 2 files changed, 12 insertions(+), 17 deletions(-)

--- a/include/linux/nmi.h~watchdog-core-remove-sysctl-handlers-from-public-header
+++ a/include/linux/nmi.h
@@ -216,13 +216,6 @@ void watchdog_update_hrtimer_threshold(u
 static inline void watchdog_update_hrtimer_threshold(u64 period) { }
 #endif
 
-struct ctl_table;
-int proc_watchdog(struct ctl_table *, int, void *, size_t *, loff_t *);
-int proc_nmi_watchdog(struct ctl_table *, int , void *, size_t *, loff_t *);
-int proc_soft_watchdog(struct ctl_table *, int , void *, size_t *, loff_t *);
-int proc_watchdog_thresh(struct ctl_table *, int , void *, size_t *, loff_t *);
-int proc_watchdog_cpumask(struct ctl_table *, int, void *, size_t *, loff_t *);
-
 #ifdef CONFIG_HAVE_ACPI_APEI_NMI
 #include <asm/nmi.h>
 #endif
--- a/kernel/watchdog.c~watchdog-core-remove-sysctl-handlers-from-public-header
+++ a/kernel/watchdog.c
@@ -796,8 +796,8 @@ static int proc_watchdog_common(int whic
 /*
  * /proc/sys/kernel/watchdog
  */
-int proc_watchdog(struct ctl_table *table, int write,
-		  void *buffer, size_t *lenp, loff_t *ppos)
+static int proc_watchdog(struct ctl_table *table, int write,
+			 void *buffer, size_t *lenp, loff_t *ppos)
 {
 	return proc_watchdog_common(WATCHDOG_HARDLOCKUP_ENABLED |
 				    WATCHDOG_SOFTOCKUP_ENABLED,
@@ -807,8 +807,8 @@ int proc_watchdog(struct ctl_table *tabl
 /*
  * /proc/sys/kernel/nmi_watchdog
  */
-int proc_nmi_watchdog(struct ctl_table *table, int write,
-		      void *buffer, size_t *lenp, loff_t *ppos)
+static int proc_nmi_watchdog(struct ctl_table *table, int write,
+			     void *buffer, size_t *lenp, loff_t *ppos)
 {
 	if (!watchdog_hardlockup_available && write)
 		return -ENOTSUPP;
@@ -816,21 +816,23 @@ int proc_nmi_watchdog(struct ctl_table *
 				    table, write, buffer, lenp, ppos);
 }
 
+#ifdef CONFIG_SOFTLOCKUP_DETECTOR
 /*
  * /proc/sys/kernel/soft_watchdog
  */
-int proc_soft_watchdog(struct ctl_table *table, int write,
-			void *buffer, size_t *lenp, loff_t *ppos)
+static int proc_soft_watchdog(struct ctl_table *table, int write,
+			      void *buffer, size_t *lenp, loff_t *ppos)
 {
 	return proc_watchdog_common(WATCHDOG_SOFTOCKUP_ENABLED,
 				    table, write, buffer, lenp, ppos);
 }
+#endif
 
 /*
  * /proc/sys/kernel/watchdog_thresh
  */
-int proc_watchdog_thresh(struct ctl_table *table, int write,
-			 void *buffer, size_t *lenp, loff_t *ppos)
+static int proc_watchdog_thresh(struct ctl_table *table, int write,
+				void *buffer, size_t *lenp, loff_t *ppos)
 {
 	int err, old;
 
@@ -852,8 +854,8 @@ int proc_watchdog_thresh(struct ctl_tabl
  * user to specify a mask that will include cpus that have not yet
  * been brought online, if desired.
  */
-int proc_watchdog_cpumask(struct ctl_table *table, int write,
-			  void *buffer, size_t *lenp, loff_t *ppos)
+static int proc_watchdog_cpumask(struct ctl_table *table, int write,
+				 void *buffer, size_t *lenp, loff_t *ppos)
 {
 	int err;
 
_

Patches currently in -mm which might be from linux@weissschuh.net are


