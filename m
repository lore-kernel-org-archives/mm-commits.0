Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 806DD19E98B;
	Thu,  6 Mar 2025 05:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741239478; cv=none; b=ZIz4zL7INkIr1OYWcDDiI1OZyCWFz+Z/M4iFl6drkjurIMlF7i0Tnj+rzdK1+HmK6ETUQuue7ubcFwhr9NjLBYm3gkc+z7ZAcMbxRxmgOPWegN6BlDKj9CCJ0d4Tbhwxawc3dtQbC7QHV6SoK8p+8o8Gyh01OsdJSv5YTUP0Bm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741239478; c=relaxed/simple;
	bh=3aP1s4odDqOMqiixyZJipNsAXL1MLjKbmg3XU6TT3ds=;
	h=Date:To:From:Subject:Message-Id; b=JhI9aTMHK2pH2aT+F2cu7BBYLPf6Bx6VI0bNtL7VDmimgiRk0crnyGyPQpcjxh8IhnI0iCaldSli5rWKGw1LbAxdgdQOzCLQPyS5Pv9fp3G02voD2SiUo9p/OIH+ycr1FDC+csmrG2FH0K4BVfLcC1o9hHdO+9ByEGe38bgwBvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HddSvvgc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HddSvvgc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56FB9C4CEE4;
	Thu,  6 Mar 2025 05:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741239478;
	bh=3aP1s4odDqOMqiixyZJipNsAXL1MLjKbmg3XU6TT3ds=;
	h=Date:To:From:Subject:From;
	b=HddSvvgcLNseLGDXDf794AEy9fjsKa8psVa0/U1WqUtgq9gzl1PL9mUXIi0NG2CIe
	 +xbFDQw4Lhvk4xUkkgpP32OlF+4rKeMOALyunV2jE8b74DwVwOkF3SRLlL5I2XsyFY
	 KExL66UwsSMWiJKzCa0Q6s2xVHur3EcpGTOTq2p8=
Date: Wed, 05 Mar 2025 21:37:57 -0800
To: mm-commits@vger.kernel.org,yangyingliang@huawei.com,stable@vger.kernel.org,mporter@kernel.crashing.org,dan.carpenter@linaro.org,alex.bou9@gmail.com,haoxiang_li2024@163.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] rapidio-fix-an-api-misues-when-rio_add_net-fails.patch removed from -mm tree
Message-Id: <20250306053758.56FB9C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: rapidio: fix an API misues when rio_add_net() fails
has been removed from the -mm tree.  Its filename was
     rapidio-fix-an-api-misues-when-rio_add_net-fails.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Haoxiang Li <haoxiang_li2024@163.com>
Subject: rapidio: fix an API misues when rio_add_net() fails
Date: Thu, 27 Feb 2025 15:34:09 +0800

rio_add_net() calls device_register() and fails when device_register()
fails.  Thus, put_device() should be used rather than kfree().  Add
"mport->net = NULL;" to avoid a use after free issue.

Link: https://lkml.kernel.org/r/20250227073409.3696854-1-haoxiang_li2024@163.com
Fixes: e8de370188d0 ("rapidio: add mport char device driver")
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Alexandre Bounine <alex.bou9@gmail.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Yang Yingliang <yangyingliang@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/devices/rio_mport_cdev.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/rapidio/devices/rio_mport_cdev.c~rapidio-fix-an-api-misues-when-rio_add_net-fails
+++ a/drivers/rapidio/devices/rio_mport_cdev.c
@@ -1742,7 +1742,8 @@ static int rio_mport_add_riodev(struct m
 		err = rio_add_net(net);
 		if (err) {
 			rmcd_debug(RDEV, "failed to register net, err=%d", err);
-			kfree(net);
+			put_device(&net->dev);
+			mport->net = NULL;
 			goto cleanup;
 		}
 	}
_

Patches currently in -mm which might be from haoxiang_li2024@163.com are


