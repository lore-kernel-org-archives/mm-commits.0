Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F67145948
	for <mm-commits@vger.kernel.org>; Sun, 11 May 2025 04:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746938848; cv=none; b=nLnWYsbnlHCZUmqVbZ2Wqz7I9AS3nJF9YMOzpK1RzL86cGpw3DRF4CPil5a1L8EwsAhjSKtvodo/IvaHmkQXWX8dB7L5z1LtszQOplBMR75SpolVOteMj74FlwJwKbxzWc+MQePg4R1WDQHlTPkKkKRDUYnvLJgBs9Hp6pyTvas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746938848; c=relaxed/simple;
	bh=ExDtTiBDYfRrj3Z7d0e73838WNpWOLQnK2wRfIyXME8=;
	h=Date:To:From:Subject:Message-Id; b=LySeIPwICcG/rNxJWdbjJBbUOvng3qfmqVC3iP96B0PSKn911XLloYY4OWENdpw5MNeJf3PO2oNglo5t0w09O8NL1Wgx6syBiiV1UwgaNEf56mX8KbCkaz2NdGKJ/CdpZptwy68WxFuFTegSKv2QRh/kBhZRcX+fJvZYjkQj2X8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CkV0mkro; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CkV0mkro"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B68EC4CEE4;
	Sun, 11 May 2025 04:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746938847;
	bh=ExDtTiBDYfRrj3Z7d0e73838WNpWOLQnK2wRfIyXME8=;
	h=Date:To:From:Subject:From;
	b=CkV0mkron60k5/y9Ytk3lQAQNIM6WE4DpRyKXH6Dh/cVUq6NiwTv+4gCo8LBfjA//
	 IUUosQD7SFGz8HSCAZDsGxS2PGfxJ7Z3zSImMlI7IPkrOXLr/2HwxWtJ4I41phnFHo
	 /w2YRuvxbb7AcIRmcq6kHjvUi1iSDF2yo6B0Y2LI=
Date: Sat, 10 May 2025 21:47:27 -0700
To: mm-commits@vger.kernel.org,venkat88@linux.ibm.com,tglx@linutronix.de,song@kernel.org,luogengkun@huaweicloud.com,joel.granados@kernel.org,dianders@chromium.org,nysal@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] watchdog-fix-watchdog-may-detect-false-positive-of-softlockup-fix.patch removed from -mm tree
Message-Id: <20250511044727.9B68EC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: watchdog: fix the SOFTLOCKUP_DETECTOR=n case
has been removed from the -mm tree.  Its filename was
     watchdog-fix-watchdog-may-detect-false-positive-of-softlockup-fix.patch

This patch was dropped because it was folded into watchdog-fix-watchdog-may-detect-false-positive-of-softlockup.patch

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

watchdog-fix-watchdog-may-detect-false-positive-of-softlockup.patch

