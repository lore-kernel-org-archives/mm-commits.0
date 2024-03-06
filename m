Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 946F114006
	for <mm-commits@vger.kernel.org>; Wed,  6 Mar 2024 20:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709758510; cv=none; b=mH5+mo0/MUTr758+Lb+i3Vp/FKD5Z+hAnhqE5oyStc+6Ea5lwkuzxTdAvb7yumJaL7YEw0QglcS4xQDqLipFO6diQjojb4BiifAhvE7PmFWDXXQqzPcIdjV3ME3Rp/ckNYDMxt6Tyel9VHOO302hnttTzCSHn4KEDJxQvgO4ogE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709758510; c=relaxed/simple;
	bh=hkaa/0eHNebmTQgq6LRnG9AF8otL2KsNCfKqn1u37G8=;
	h=Date:To:From:Subject:Message-Id; b=OJg2+4VSLjrDqUv2JoDzxu5sY8NgaRUw9LRrs0PS+WPTwxlH9pzp4aUESgF23UU92PK54eKolKLX0AcKzwTUHKyi+AQaD27OE/99VJ33UUOMhV7JCbaDq+OPqGPcOcRCh56V+nbqes+S22HShBeDxUi3jjqHkazTClOuXYW7WgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YqWhOaS/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YqWhOaS/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12949C433C7;
	Wed,  6 Mar 2024 20:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709758510;
	bh=hkaa/0eHNebmTQgq6LRnG9AF8otL2KsNCfKqn1u37G8=;
	h=Date:To:From:Subject:From;
	b=YqWhOaS/ZH8isIJOTDTN/SehWO8pnqzaitQRtk7eU3/z2+0BO3hEkqXeTjotCAZ/T
	 /c9HNZsHYrQc+cnvGJFL5RqajC+8/WOHXHRdfaAWtlK0RX+LDqSsqKDFws+jm8GKly
	 uqMI1Mib7I33Jq/2pFP0GGiJBDZKPDmK9NdBQKwc=
Date: Wed, 06 Mar 2024 12:55:09 -0800
To: mm-commits@vger.kernel.org,linux@weissschuh.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + watchdog-core-remove-sysctl-handlers-from-public-header.patch added to mm-nonmm-unstable branch
Message-Id: <20240306205510.12949C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: watchdog/core: remove sysctl handlers from public header
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     watchdog-core-remove-sysctl-handlers-from-public-header.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/watchdog-core-remove-sysctl-handlers-from-public-header.patch

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

watchdog-core-remove-sysctl-handlers-from-public-header.patch

