Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD89F153837
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725248804; cv=none; b=r2vB4N1eDTqfY3lbds0J9grsMvDV3F85BM5sJakfsEXAfMU4VOitKGhR4yUVcfS9yzZII4i9DRMngfG+i88WBMmJGOO5Sg3N1cnjPfKf4CLFeimgET3+YVJOl0RWrXhvlreMWegDy2X2AVse725sgbC+03DzhY8wcgX6SfLYlps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725248804; c=relaxed/simple;
	bh=dmqCeNWoJ2ERGuI7vb5LbnqhZ5O9GK1x2XT6JF8R8q0=;
	h=Date:To:From:Subject:Message-Id; b=IuOy4F05j6ymlQ1ZLmX9XGEmzpCVr29t/gjEDdxU8eeDO6VLrs+mEjvFFuBfXQrD/3xirnaOvwJtRWqdhXDOMfpEhQyRruBK8wu9lv4HODw7EHJ7uM2h+duUNNzwOxqMLoyskvkyLI9ZvjXmvS7NyYESSJghDmLvuf8CN8XMNn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OXWRUqdD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OXWRUqdD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77051C4CEC8;
	Mon,  2 Sep 2024 03:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725248804;
	bh=dmqCeNWoJ2ERGuI7vb5LbnqhZ5O9GK1x2XT6JF8R8q0=;
	h=Date:To:From:Subject:From;
	b=OXWRUqdDcq7deDlGMwo8VgugiQrfzq7FTE0jY4adls7VRbOO/IyRWO4RvXSsrwpli
	 83nWpW2fDugs8UNCiVvfmklvEuFIZq24XqdJmD2Zuu2p0yOl6bBLGqVqy7FyqkdCVE
	 Ai9Qy0QqbxMLGRiehkD15e22ScN0CRglPsR2FznQ=
Date: Sun, 01 Sep 2024 20:46:43 -0700
To: mm-commits@vger.kernel.org,pmladek@suse.com,lizhe.67@bytedance.com,linux@weissschuh.net,j.granados@samsung.com,dianders@chromium.org,longman@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] watchdog-handle-the-enodev-failure-case-of-lockup_detector_delay_init-separately.patch removed from -mm tree
Message-Id: <20240902034644.77051C4CEC8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: watchdog: handle the ENODEV failure case of lockup_detector_delay_init() separately
has been removed from the -mm tree.  Its filename was
     watchdog-handle-the-enodev-failure-case-of-lockup_detector_delay_init-separately.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Waiman Long <longman@redhat.com>
Subject: watchdog: handle the ENODEV failure case of lockup_detector_delay_init() separately
Date: Fri, 2 Aug 2024 11:16:21 -0400

When watchdog_hardlockup_probe() is being called by
lockup_detector_delay_init(), an error return of -ENODEV will happen
for the arm64 arch when arch_perf_nmi_is_available() returns false. This
means that NMI is not usable by the hard lockup detector and so has to
be disabled. This can be considered a deficiency in that particular
arm64 chip, but there is nothing we can do about it.  That also means
the following error will always be reported when the kernel boot up.

  watchdog: Delayed init of the lockup detector failed: -19

The word "failed" itself has a connotation that there is something
wrong with the kernel which is not really the case here. Handle this
special ENODEV case separately and explain the reason behind disabling
hard lockup detector without causing anxiety for those users who read
the above message and wonder about it.

Link: https://lkml.kernel.org/r/20240802151621.617244-1-longman@redhat.com
Signed-off-by: Waiman Long <longman@redhat.com>
Cc: Douglas Anderson <dianders@chromium.org>
Cc: Joel Granados <j.granados@samsung.com>
Cc: Li Zhe <lizhe.67@bytedance.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Thomas Weißschuh <linux@weissschuh.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/kernel/watchdog.c~watchdog-handle-the-enodev-failure-case-of-lockup_detector_delay_init-separately
+++ a/kernel/watchdog.c
@@ -1203,7 +1203,10 @@ static void __init lockup_detector_delay
 
 	ret = watchdog_hardlockup_probe();
 	if (ret) {
-		pr_info("Delayed init of the lockup detector failed: %d\n", ret);
+		if (ret == -ENODEV)
+			pr_info("NMI not fully supported\n");
+		else
+			pr_info("Delayed init of the lockup detector failed: %d\n", ret);
 		pr_info("Hard watchdog permanently disabled\n");
 		return;
 	}
_

Patches currently in -mm which might be from longman@redhat.com are


