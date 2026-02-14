Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 983F43EBF3A
	for <mm-commits@vger.kernel.org>; Sat, 14 Feb 2026 03:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771041210; cv=none; b=UeQG2Ls87VNRcwGnBOaoBvJ6Hh4FDoWTquDphbkKtTDXuuF5DCTuQP4H+tRZT8BANcid9LFxreOXHL3Pik71laoSNGmvv+NrKvOI+f9+y50cWD+Z8IoySuIDA/s57CfiUaKHa+K3rSGjojNnTJMnWXjoqcrr1vpCtcA5bgGUFQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771041210; c=relaxed/simple;
	bh=8k3I9i2AcFCaGl5xuE5NGk2MWzofST6HzzfkDZXlCh4=;
	h=Date:To:From:Subject:Message-Id; b=fEKcf+s4IkpZY2J3j/oC7qO5kcN1PAx1LtM31ZiRbbFPgRIu1yITiLluHHghk7FBE9x3t6z9scyNOEUHKIj7k42QtS6M9+Xs02c35JS/rrtI5o5XjyoJndTVU4cb397+V5e0oLsE6xeyKYcMU+/y072J7J2xmaCv29aylzqTauM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=boFz2Ke2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="boFz2Ke2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CAAFC19421;
	Sat, 14 Feb 2026 03:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771041210;
	bh=8k3I9i2AcFCaGl5xuE5NGk2MWzofST6HzzfkDZXlCh4=;
	h=Date:To:From:Subject:From;
	b=boFz2Ke2pwtwvcN0Xs8KeDwVenGDbenkyCm3wHFLLjueY2fG657gJcUBFY1UBqXYd
	 3af0X1iQuZa5WYVkyA8LG0uQ959HRzqn1TXZQUrAOgueZvDjuGDle7Qh9JfpT/iWrR
	 1rocVPtMePsOIWLWQr1WgnxBd/AJPOFAH5gog8rw=
Date: Fri, 13 Feb 2026 19:53:29 -0800
To: mm-commits@vger.kernel.org,sean@geanix.com,samuel.kayode@savoirfairelinux.com,Frank.Li@nxp.com,dmitry.torokhov@gmail.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [alternative-merged] drivers-input-misc-pf1550-onkeyc-fix-build-with-config_pm_sleep=n.patch removed from -mm tree
Message-Id: <20260214035330.2CAAFC19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: drivers/input/misc/pf1550-onkey.c: fix build with CONFIG_PM_SLEEP=n
has been removed from the -mm tree.  Its filename was
     drivers-input-misc-pf1550-onkeyc-fix-build-with-config_pm_sleep=n.patch

This patch was dropped because an alternative patch was or shall be merged

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

