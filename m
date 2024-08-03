Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BA2D42A82
	for <mm-commits@vger.kernel.org>; Sat,  3 Aug 2024 05:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722663350; cv=none; b=ETt5mjW4wYYrZ4Dy5RmHq6TtYm+cgIQN++la8UVoBxCzdZI70T2VR04JsBj/FKSmBA0OTQMFzu3Fd6hGRWtjuXm2iKvj1UB6LeZzIoSGsFetb2MlYrLs3O7s1FK1cNfsaonZi8KV0N7QDt5WAqs+Enj3mJm1Poi31ZtcFhsgyIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722663350; c=relaxed/simple;
	bh=LN6aPtLE1BqON+4+ZQxOzyrGs8iXjEoYFiXRlEIvIZ8=;
	h=Date:To:From:Subject:Message-Id; b=d9hsdoZ1MJIRDFLRHQVGJRYq/UiI4Ze9D4wL6AF47BHxR+PNLYoebZJMIXnqiy/BhZWmE4WgCwAeIRoh+M9gEmGyBIvHnFXRYBykpXGas2FoU0qFXLWOvxIiT/bOkMXHZhZ3ydLkH7Xtdy8cAEFN/bbTE/Gj/EEgyVDhep/ePcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kinrdF31; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kinrdF31"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 105C5C116B1;
	Sat,  3 Aug 2024 05:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722663350;
	bh=LN6aPtLE1BqON+4+ZQxOzyrGs8iXjEoYFiXRlEIvIZ8=;
	h=Date:To:From:Subject:From;
	b=kinrdF31PD7LVEPI6PplcHRv+u+GDYUXDqMTRmur+5uoVXhhr2htw+/s1SjGYQ4fs
	 ZsJmdPI/75jq7quvC1QGDToanavP8e1tL3O4l2F5VtRwtp0RRJ46xJNq5v6NzbbeRk
	 bycnYvKNuoYR96N57BjK0oOjBMJLNSEBh7t2VN/M=
Date: Fri, 02 Aug 2024 22:35:49 -0700
To: mm-commits@vger.kernel.org,pmladek@suse.com,lizhe.67@bytedance.com,linux@weissschuh.net,j.granados@samsung.com,dianders@chromium.org,longman@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + watchdog-handle-the-enodev-failure-case-of-lockup_detector_delay_init-separately.patch added to mm-nonmm-unstable branch
Message-Id: <20240803053550.105C5C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: watchdog: Handle the ENODEV failure case of lockup_detector_delay_init() separately
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     watchdog-handle-the-enodev-failure-case-of-lockup_detector_delay_init-separately.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/watchdog-handle-the-enodev-failure-case-of-lockup_detector_delay_init-separately.patch

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
From: Waiman Long <longman@redhat.com>
Subject: watchdog: Handle the ENODEV failure case of lockup_detector_delay_init() separately
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

watchdog-handle-the-enodev-failure-case-of-lockup_detector_delay_init-separately.patch

