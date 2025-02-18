Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A86717597
	for <mm-commits@vger.kernel.org>; Tue, 18 Feb 2025 02:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739847237; cv=none; b=UszZY+gyswjE7C8VXY5lvPNc8SYgVgeYjivGV1SnlJb4N6wYe7ELZxwXoXc4TBKJR9AivbPQ6PjdWRFlA+X1FO6BVjtm10vb05xfhGDCDyccomftAaYmv2w4qISmZsNKczQdBwI7Jqx4FGxQ/cFQ0aZsaYE6nZl0cwLhnPcJvuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739847237; c=relaxed/simple;
	bh=BKnYHZ5MH+qH/5BKW5KIxSMd1Y5mpSE1hHlfjRt2z8s=;
	h=Date:To:From:Subject:Message-Id; b=oVAW1ZuOULlyWMHHi4GZhphLh5QQvKFfxJTiJ1wbJUV1BXMIt4J5FtKh2kLrUPuUVf7BMLNo3swp/LxNNePU/78yOiP3vFmwE6QHjBuMKY8S2dPg8xMa+R7X6AWxzd5jmc3KDoI7qI5QzAXi8BD3WMF4wtOsxb9sDVvA3y52law=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qjHEDFzL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qjHEDFzL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3C88C4CED1;
	Tue, 18 Feb 2025 02:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739847236;
	bh=BKnYHZ5MH+qH/5BKW5KIxSMd1Y5mpSE1hHlfjRt2z8s=;
	h=Date:To:From:Subject:From;
	b=qjHEDFzL7hH8hkkBxByhowVLwLtmENkJBwYcPH1vOMJ7lAX03MQfTchxXLyhiRdZa
	 Hxec6eMENUl0uX5RX9CoFFQGwKQNlUQFOT1WTFuf/oKRBRQzd4PYELX2OqfkQiV8Ls
	 ARULWnDDr+HFakyEb8ZAAmPDt74bztFfeaGIchN8=
Date: Mon, 17 Feb 2025 18:53:56 -0800
To: mm-commits@vger.kernel.org,tzungbi@kernel.org,teknoraver@meta.com,serge@hallyn.com,rui.zhang@intel.com,robh@kernel.org,rafael@kernel.org,mazziesaccount@gmail.com,lukasz.luba@arm.com,lgirdwood@gmail.com,kernel@pengutronix.de,groeck@chromium.org,festevam@denx.de,daniel.lezcano@linaro.org,corbet@lwn.net,broonie@kernel.org,bleung@chromium.org,a.fatoum@pengutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + reboot-describe-do_kernel_restarts-cmd-argument-in-kernel-doc.patch added to mm-nonmm-unstable branch
Message-Id: <20250218025356.D3C88C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: reboot: describe do_kernel_restart's cmd argument in kernel-doc
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     reboot-describe-do_kernel_restarts-cmd-argument-in-kernel-doc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/reboot-describe-do_kernel_restarts-cmd-argument-in-kernel-doc.patch

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
From: Ahmad Fatoum <a.fatoum@pengutronix.de>
Subject: reboot: describe do_kernel_restart's cmd argument in kernel-doc
Date: Mon, 17 Feb 2025 21:39:44 +0100

A W=1 build rightfully complains about the function's kernel-doc being
incomplete.

Describe its single parameter to fix this.

Link: https://lkml.kernel.org/r/20250217-hw_protection-reboot-v3-4-e1c09b090c0c@pengutronix.de
Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Reviewed-by: Tzung-Bi Shih <tzungbi@kernel.org>
Cc: Benson Leung <bleung@chromium.org>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Fabio Estevam <festevam@denx.de>
Cc: Guenter Roeck <groeck@chromium.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: Lukasz Luba <lukasz.luba@arm.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Matteo Croce <teknoraver@meta.com>
Cc: Matti Vaittinen <mazziesaccount@gmail.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Rob Herring (Arm) <robh@kernel.org>
Cc: Rui Zhang <rui.zhang@intel.com>
Cc: Sascha Hauer <kernel@pengutronix.de>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/reboot.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/reboot.c~reboot-describe-do_kernel_restarts-cmd-argument-in-kernel-doc
+++ a/kernel/reboot.c
@@ -229,6 +229,9 @@ EXPORT_SYMBOL(unregister_restart_handler
 /**
  *	do_kernel_restart - Execute kernel restart handler call chain
  *
+ *	@cmd: pointer to buffer containing command to execute for restart
+ *		or %NULL
+ *
  *	Calls functions registered with register_restart_handler.
  *
  *	Expected to be called from machine_restart as last step of the restart
_

Patches currently in -mm which might be from a.fatoum@pengutronix.de are

reboot-replace-__hw_protection_shutdown-bool-action-parameter-with-an-enum.patch
reboot-reboot-not-shutdown-on-hw_protection_reboot-timeout.patch
docs-thermal-sync-hardware-protection-doc-with-code.patch
reboot-describe-do_kernel_restarts-cmd-argument-in-kernel-doc.patch
reboot-rename-now-misleading-__hw_protection_shutdown-symbols.patch
reboot-indicate-whether-it-is-a-hardware-protection-reboot-or-shutdown.patch
reboot-add-support-for-configuring-emergency-hardware-protection-action.patch
regulator-allow-user-configuration-of-hardware-protection-action.patch
platform-chrome-cros_ec_lpc-prepare-for-hw_protection_shutdown-removal.patch
dt-bindings-thermal-give-os-some-leeway-in-absence-of-critical-action.patch
thermal-core-allow-user-configuration-of-hardware-protection-action.patch
reboot-retire-hw_protection_reboot-and-hw_protection_shutdown-helpers.patch

