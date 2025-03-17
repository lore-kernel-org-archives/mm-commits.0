Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25715218EA7
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742189519; cv=none; b=LwbQsSoJqc9YebtP/68JYDcf+NajyyMty0jegwYMsZoaXlXMzt3ohHt2SDTYn/juYQXbZJlPm9TBkpH9kR/fnsBz5yDq1F7bKG6IenM8z2au3krDOF05G74w3jG6syl4INsbl9YKaeqwWQPJPB+SXPPLhBfZEpDWKCjxnhJ0RAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742189519; c=relaxed/simple;
	bh=QZ5bl/hEWnE58T3kAeAIewMYgyLS8+X+sydaIR9H25I=;
	h=Date:To:From:Subject:Message-Id; b=B6FplVqKPxVyiFSpSiKkpgjILm2TyuyvVFJyo8iaSoG2zjXA9NIil5RxeugS6ltnHG1qH3xhujkB2VzZBVWBXnlJhqsiZ/lYzMNH+bZKBsraSI0Iw9jvfAYzefIqVtx2bkYS3K97rfnbK6KIfjW92Rf9S2cSnJjDuwoIkoG0wQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VZemIYGe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VZemIYGe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED29AC4CEEC;
	Mon, 17 Mar 2025 05:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742189519;
	bh=QZ5bl/hEWnE58T3kAeAIewMYgyLS8+X+sydaIR9H25I=;
	h=Date:To:From:Subject:From;
	b=VZemIYGe3oErSd9E8F9ASHrID1mRB/vAXmoYr+/70URJNAz41ME91VTju1VSg3UUi
	 m2Nv3typHKE/bbn72BNMmbY2jbhOEM8tlDiN+nLVs9SqRON5VR8iteiEK3yxIwYQ99
	 EVYRnP/irhLy3/Uh7drUXEvzmnTlkE5655OzqfII=
Date: Sun, 16 Mar 2025 22:31:58 -0700
To: mm-commits@vger.kernel.org,tzungbi@kernel.org,teknoraver@meta.com,serge@hallyn.com,rui.zhang@intel.com,robh@kernel.org,rafael@kernel.org,mazziesaccount@gmail.com,lukasz.luba@arm.com,lgirdwood@gmail.com,kernel@pengutronix.de,groeck@chromium.org,festevam@denx.de,daniel.lezcano@linaro.org,corbet@lwn.net,broonie@kernel.org,bleung@chromium.org,a.fatoum@pengutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] reboot-describe-do_kernel_restarts-cmd-argument-in-kernel-doc.patch removed from -mm tree
Message-Id: <20250317053158.ED29AC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: reboot: describe do_kernel_restart's cmd argument in kernel-doc
has been removed from the -mm tree.  Its filename was
     reboot-describe-do_kernel_restarts-cmd-argument-in-kernel-doc.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


