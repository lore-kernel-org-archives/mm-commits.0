Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26087D515
	for <mm-commits@vger.kernel.org>; Tue,  9 Sep 2025 04:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757390652; cv=none; b=ARpdlWco7EE7j1BUs8+3Kg+fzgDFdCoWZ3eud0Y/2hUSxK1+kmNmsZ4k5bITW7+y0MWDS76F0rGMVjg8cNrsYs7Pe4aoOxGYLaS3JTylytsfugc63xb1nK222wzx4nsvbhhw3eVDn+XxT9s3/erYeO8I3U1ekGCqqztvA9Y5yDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757390652; c=relaxed/simple;
	bh=iwpYSJMG8FU5oruboIodUQwWaktyiwuDvq8WQ6y0W78=;
	h=Date:To:From:Subject:Message-Id; b=h2r7FUPEUucHr8v+pKaBV8DkPec0UFyOTB8920t+jUfSmFt4PFmzJjjLTGHj3NRHP4ycVe9Q0R/JUf8qsdAl+9sk8J8pznvxU1JR+sKve5tW48Nunv1YSDE1xWyCm81Gmhlo3uz2WU2jgplxfR5Uf4C66BQs8R2bmHw1ME25B7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vBNwXYcs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vBNwXYcs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA4CFC4CEF4;
	Tue,  9 Sep 2025 04:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757390652;
	bh=iwpYSJMG8FU5oruboIodUQwWaktyiwuDvq8WQ6y0W78=;
	h=Date:To:From:Subject:From;
	b=vBNwXYcsi9e6i7CYBeiP4NqfRCfN/05lQCQPm0CQszmCCtXV3/0NwZvmSRmyt4I10
	 giafurgdwU2rNBdq8I0pkJeQZg6QZGlhEp656FYxzRprK+0b7yZZ4IPjuu+oHP644Q
	 Nfzcx4I8zOeuRsrthX4CjDENQ0DD+Tw+fEqa8f7g=
Date: Mon, 08 Sep 2025 21:04:11 -0700
To: mm-commits@vger.kernel.org,rafael@kernel.org,pavel@ucw.cz,mchehab@kernel.org,mchehab+huawei@kernel.org,len.brown@intel.com,jani.nikula@linux.intel.com,james.bottomley@HansenPartnership.com,gregkh@linuxfoundation.org,corbet@lwn.net,rdunlap@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kernelh-add-comments-for-enum-system_states.patch added to mm-nonmm-unstable branch
Message-Id: <20250909040411.EA4CFC4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kernel.h: add comments for enum system_states
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kernelh-add-comments-for-enum-system_states.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kernelh-add-comments-for-enum-system_states.patch

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
From: Randy Dunlap <rdunlap@infradead.org>
Subject: kernel.h: add comments for enum system_states
Date: Sat, 6 Sep 2025 21:38:57 -0700

Provide some basic comments about the system_states and what they imply. 
Also convert the comments to kernel-doc format.

Split the enum declaration from the definition of the system_state
variable so that kernel-doc notation works cleanly with it.  This is
picked up by Documentation/driver-api/basics.rst so it does not need
further inclusion in the kernel docbooks.

Link: https://lkml.kernel.org/r/20250907043857.2941203-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Rafael J. Wysocki <rafael@kernel.org> # v1
Reviewed-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>	[v5]
Cc: "Brown, Len" <len.brown@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: James Bottomley <james.bottomley@HansenPartnership.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |   21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

--- a/include/linux/kernel.h~kernelh-add-comments-for-enum-system_states
+++ a/include/linux/kernel.h
@@ -164,11 +164,23 @@ extern int root_mountflags;
 
 extern bool early_boot_irqs_disabled;
 
-/*
- * Values used for system_state. Ordering of the states must not be changed
+/**
+ * enum system_states - Values used for system_state.
+ *
+ * @SYSTEM_BOOTING:	%0, no init needed
+ * @SYSTEM_SCHEDULING: system is ready for scheduling; OK to use RCU
+ * @SYSTEM_FREEING_INITMEM: system is freeing all of initmem; almost running
+ * @SYSTEM_RUNNING:	system is up and running
+ * @SYSTEM_HALT:	system entered clean system halt state
+ * @SYSTEM_POWER_OFF:	system entered shutdown/clean power off state
+ * @SYSTEM_RESTART:	system entered emergency power off or normal restart
+ * @SYSTEM_SUSPEND:	system entered suspend or hibernate state
+ *
+ * Note:
+ * Ordering of the states must not be changed
  * as code checks for <, <=, >, >= STATE.
  */
-extern enum system_states {
+enum system_states {
 	SYSTEM_BOOTING,
 	SYSTEM_SCHEDULING,
 	SYSTEM_FREEING_INITMEM,
@@ -177,7 +189,8 @@ extern enum system_states {
 	SYSTEM_POWER_OFF,
 	SYSTEM_RESTART,
 	SYSTEM_SUSPEND,
-} system_state;
+};
+extern enum system_states system_state;
 
 /*
  * General tracing related utility functions - trace_printk(),
_

Patches currently in -mm which might be from rdunlap@infradead.org are

listh-add-missing-kernel-doc-for-basic-macros.patch
kernelh-add-comments-for-enum-system_states.patch

