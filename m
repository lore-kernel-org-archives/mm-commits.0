Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B785627290C;
	Thu, 27 Feb 2025 23:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740697963; cv=none; b=FBZCl5WeHFAJqgKoF7eMCScJG39NxWnSB5nMr8LoI6VGv+L9ctV3Vaf9n8quKsVCNPFJtzpDuM9tc8fMqUX8wcHnRKL8R89IooxfF3sD1A3/MgxxEY1uKKltxZ6nMFwd+O7swQOSnoM0elv0jCYhuvuAWsh8AKILdwhVSdDJl2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740697963; c=relaxed/simple;
	bh=KQbmUdVsqrK/03QDZ/3krl9iUybFdWvx7ljg3WtUVJU=;
	h=Date:To:From:Subject:Message-Id; b=UfMOA3sfDPrlGBoFeH1dS1I4MuEGLhnkkFs52hVKQde7yHn9ASvZwPl7ug7yGw6irxJi3+Lu5Q4Uyjj9WEkvSN7yrvTCWFGwkxvX4qhdYvYmdmWRnFk/vPg5JPFG6lycHngWqp9gJEXlc9OsR2SiYNPeIOIouTnQ1XMhLy+sPYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VBKJ4HTQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VBKJ4HTQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 339A2C4CEE5;
	Thu, 27 Feb 2025 23:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740697963;
	bh=KQbmUdVsqrK/03QDZ/3krl9iUybFdWvx7ljg3WtUVJU=;
	h=Date:To:From:Subject:From;
	b=VBKJ4HTQMFgrLTBxBdOrgLYEXM3kfK/2+E0uvHiLJMJLzZW0Uh1Auxq8UOQpl4fX0
	 MfaG9/GVECeHZQJwvXlsSXKof/Ghw4S8Z6RBuVpSB3u2BGV+Chin+QA8JkcIz7BCew
	 1W9wUugRMIjeiRndh53uZ8CByYT51XV7IkzNgnsA=
Date: Thu, 27 Feb 2025 15:12:42 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,mporter@kernel.crashing.org,dan.carpenter@linaro.org,alex.bou9@gmail.com,haoxiang_li2024@163.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + rapidio-fix-an-api-misues-when-rio_add_net-fails.patch added to mm-hotfixes-unstable branch
Message-Id: <20250227231243.339A2C4CEE5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: rapidio: fix an API misues when rio_add_net() fails
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     rapidio-fix-an-api-misues-when-rio_add_net-fails.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/rapidio-fix-an-api-misues-when-rio_add_net-fails.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

m68k-sun3-add-check-for-__pgd_alloc.patch
rapidio-fix-an-api-misues-when-rio_add_net-fails.patch

