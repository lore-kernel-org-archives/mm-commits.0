Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9BC91EA84
	for <mm-commits@vger.kernel.org>; Sat, 14 Feb 2026 00:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771029474; cv=none; b=f9cHsGhH7Aoq68Rtp1OJFrosOfMBktODyWITcZZWP9jD686W3fUofCIxsQGbayjEmr8yZoCQOyzuWGM6GqBwbactagQWKPqTUE72GLKo1Kekpb4oNaPnQy0DZFTPacXRWSM+9iquFT/7dx10ELEj1GmmwkL6Wu0kLHjexfSo62k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771029474; c=relaxed/simple;
	bh=kfIkufZnrF2ix5KIoc3Y421S1P7MCqe5H/ZLG2gzWdU=;
	h=Date:To:From:Subject:Message-Id; b=Z/HPxUfcca4CB5UrN+8BIDbkFuTDmvzFVU1+wqOTJy4YzPF4HBSzSe0FVS2Zn0S0He6wtLX500VGCydm8JyDsoxCCSXzCextE6ItYeVuor4s9rEra7+o8qFGf2JJihlM14m6jfh+DCllEJrzVYC5NJfClvonwY4jQMb2ivfdhSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YbprRx6C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YbprRx6C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54E4BC116C6;
	Sat, 14 Feb 2026 00:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771029474;
	bh=kfIkufZnrF2ix5KIoc3Y421S1P7MCqe5H/ZLG2gzWdU=;
	h=Date:To:From:Subject:From;
	b=YbprRx6CnDPZQy/vdK8jwfXJF/oeqrzJ4m+/pDSx7VnoCgcYPpbKddZyRaXK+6swy
	 J3sAkrGhhuvK44KARR/6gAUyzbzXglMo6PbxCBNtmBuTEAhVJNKJ5X0t10SUTZC3jD
	 aBWay1huJF21bJDbbn19Jm4rqvRF/yTwLw1ky7PM=
Date: Fri, 13 Feb 2026 16:37:53 -0800
To: mm-commits@vger.kernel.org,sean@geanix.com,samuel.kayode@savoirfairelinux.com,Frank.Li@nxp.com,dmitry.torokhov@gmail.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + drivers-input-misc-pf1550-onkeyc-fix-build-with-config_pm_sleep=n.patch added to mm-nonmm-unstable branch
Message-Id: <20260214003754.54E4BC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: drivers/input/misc/pf1550-onkey.c: fix build with CONFIG_PM_SLEEP=n
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     drivers-input-misc-pf1550-onkeyc-fix-build-with-config_pm_sleep=n.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/drivers-input-misc-pf1550-onkeyc-fix-build-with-config_pm_sleep=n.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers/input/misc/pf1550-onkey.c: fix build with CONFIG_PM_SLEEP=n
Date: Fri Feb 13 02:39:04 PM PST 2026

riscv randconfig:

drivers/input/misc/pf1550-onkey.c:154:12: error: 'pf1550_onkey_resume' defined but not used [-Werror=unused-function]
  154 | static int pf1550_onkey_resume(struct device *dev)
      |            ^~~~~~~~~~~~~~~~~~~
drivers/input/misc/pf1550-onkey.c:133:12: error: 'pf1550_onkey_suspend' defined but not used [-Werror=unused-function]
  133 | static int pf1550_onkey_suspend(struct device *dev)
      |            ^~~~~~~~~~~~~~~~~~~~
cc1: all warnings being treated as errors

Cc: Samuel Kayode <samuel.kayode@savoirfairelinux.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Frank Li <Frank.Li@nxp.com>
Cc: Sean Nyekjaer <sean@geanix.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/misc/pf1550-onkey.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/input/misc/pf1550-onkey.c~drivers-input-misc-pf1550-onkeyc-fix-build-with-config_pm_sleep=n
+++ a/drivers/input/misc/pf1550-onkey.c
@@ -130,6 +130,7 @@ static int pf1550_onkey_probe(struct pla
 	return 0;
 }
 
+#ifdef CONFIG_PM_SLEEP
 static int pf1550_onkey_suspend(struct device *dev)
 {
 	struct platform_device *pdev = to_platform_device(dev);
@@ -175,6 +176,7 @@ static int pf1550_onkey_resume(struct de
 
 static SIMPLE_DEV_PM_OPS(pf1550_onkey_pm_ops, pf1550_onkey_suspend,
 			 pf1550_onkey_resume);
+#endif CONFIG_PM_SLEEP
 
 static const struct platform_device_id pf1550_onkey_id[] = {
 	{ "pf1550-onkey", },
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

maple_tree-start-using-maple-copy-node-for-destination-checkpatch-fixes.patch
maple_tree-add-cp_is_new_root-helper-fix-fix.patch
drivers-input-misc-pf1550-onkeyc-fix-build-with-config_pm_sleep=n.patch

