Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA647A93D
	for <mm-commits@vger.kernel.org>; Sun,  4 May 2025 02:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746326309; cv=none; b=IFnfWZfn5mQK5397pK27S3/+IeLk5Bhb3y0jPGZt3W4Ccv7pApwQDlE8cDBZhMy+QvNS/NHPT6rIgjweuOWQQ8obeBVDE/bE0jcJskvrVfEw1M9wE/jXPNoHL2JVe4wDKiJWAKeU65AKao0J+oPttmb7e8iNx54GbmAPhGFvHjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746326309; c=relaxed/simple;
	bh=oANQ3JMab7qW7sp/0PsTbrszoJBYlvh2rnIG3ps4xFc=;
	h=Date:To:From:Subject:Message-Id; b=jUE8BnPorxy/bxy228laNeabsDc1HOq3XLOUuJFbcq9lfBZFdvmel+/Ki9ClhzavaFoRFcD5jRreysvOIGhTAJcBp+jSxCSuLZiYc2tlq+F4EukhIWF5MY0+m5X4RMQy3FrUksUhmwlw74vqe3cNuQ4B1UwRhHcQUBdK2AkK+ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vbs8a2Ta; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vbs8a2Ta"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A48ECC4CEEB;
	Sun,  4 May 2025 02:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746326308;
	bh=oANQ3JMab7qW7sp/0PsTbrszoJBYlvh2rnIG3ps4xFc=;
	h=Date:To:From:Subject:From;
	b=vbs8a2Ta7TJev92NcACcugf0tFK/qRlyDCpqPbt/Fwtv6F86BLMFZKJNrhFHUAjAy
	 Xk49mZTeAJPgKD/50OF79IFuOxsgPvyt31CGvfE7tY8vJi+3pLbJsUrRAGhvbUfFK1
	 JWJuIJcR0c9WcTml7FGL16SDPWXgaxkksdXllAt4=
Date: Sat, 03 May 2025 19:38:28 -0700
To: mm-commits@vger.kernel.org,venkat88@linux.ibm.com,tglx@linutronix.de,song@kernel.org,luogengkun@huaweicloud.com,joel.granados@kernel.org,dianders@chromium.org,nysal@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + watchdog-fix-watchdog-may-detect-false-positive-of-softlockup-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20250504023828.A48ECC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: watchdog: fix the SOFTLOCKUP_DETECTOR=n case
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     watchdog-fix-watchdog-may-detect-false-positive-of-softlockup-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/watchdog-fix-watchdog-may-detect-false-positive-of-softlockup-fix.patch

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
From: "Nysal Jan K.A." <nysal@linux.ibm.com>
Subject: watchdog: fix the SOFTLOCKUP_DETECTOR=n case
Date: Fri, 2 May 2025 16:41:20 +0530

Update watchdog_thresh when SOFTLOCKUP_DETECTOR=n.  Additionally fix a
build failure in this case as well.

Link: https://lkml.kernel.org/r/20250502111120.282690-1-nysal@linux.ibm.com
Reported-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Closes: https://lore.kernel.org/all/339e2b3e-c7ee-418f-a84c-9c6360dc570b@linux.ibm.com
Signed-off-by: Nysal Jan K.A. <nysal@linux.ibm.com>
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Cc: Doug Anderson <dianders@chromium.org>
Cc: Joel Granados <joel.granados@kernel.org>
Cc: Luo Gengkun <luogengkun@huaweicloud.com>
Cc: Song Liu <song@kernel.org>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/kernel/watchdog.c~watchdog-fix-watchdog-may-detect-false-positive-of-softlockup-fix
+++ a/kernel/watchdog.c
@@ -923,10 +923,12 @@ static __init void lockup_detector_setup
 }
 
 #else /* CONFIG_SOFTLOCKUP_DETECTOR */
-static void __lockup_detector_reconfigure(void)
+static void __lockup_detector_reconfigure(bool thresh_changed)
 {
 	cpus_read_lock();
 	watchdog_hardlockup_stop();
+	if (thresh_changed)
+		watchdog_thresh = READ_ONCE(watchdog_thresh_next);
 	lockup_detector_update_enable();
 	watchdog_hardlockup_start();
 	cpus_read_unlock();
_

Patches currently in -mm which might be from nysal@linux.ibm.com are

selftests-mm-fix-a-build-failure-on-powerpc.patch
watchdog-fix-watchdog-may-detect-false-positive-of-softlockup-fix.patch

