Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AF2B276D02;
	Thu, 27 Feb 2025 23:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740698629; cv=none; b=lTjO/z0fVDcLXz0i+HwNi/KRvSBYWpbSLy3FENFVC44CleEWWYtZDRfCwYEWya46lOwQ/lqv8jFdfajX7mEwC5Zi5m+SkEOWySQfQP/T32oINGRZc0wxQ13HyeowOq8lBtfu2wIt32pObrgxz/oSaUPVDA4rUNPC4y2VoymK34k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740698629; c=relaxed/simple;
	bh=E3A8TVyuK+9FALwmobWB9gf0jwNxDzPMCCpodwXyseI=;
	h=Date:To:From:Subject:Message-Id; b=SyzUp5TEsvw9hGdK7qezJTunHH8CI3JM7jcp3ilucb1AzPUvdvUQ3VbNvNs813wiUO6gAJNamLaHsQi8qC6pLL1O/w/7Q2pitHUEPWgE4gTAkZtEiZfUTRmve3nfp8gNoTYHYMarTWsivZAdaMKW9+rc1X+bdD67ALnVXPlZlOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RydUfsXn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RydUfsXn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8788C4CEDD;
	Thu, 27 Feb 2025 23:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740698628;
	bh=E3A8TVyuK+9FALwmobWB9gf0jwNxDzPMCCpodwXyseI=;
	h=Date:To:From:Subject:From;
	b=RydUfsXnw6WKnsLHU3sn0qgGUZeekIYT4UUrOLu/KMDUYtGAy91RRrLW4aFVOyO9e
	 p+LW9YPlfYjL3PfVHSBZA8O200JoE75w0WylxEot+6JUlU1oPfjKvuwEcV5khd/WaO
	 mcA18elCgjQ6ipvC9ukbTv2hpoQt/e5INfQJzflc=
Date: Thu, 27 Feb 2025 15:23:48 -0800
To: mm-commits@vger.kernel.org,yangyingliang@huawei.com,stable@vger.kernel.org,mporter@kernel.crashing.org,dan.carpenter@linaro.org,alex.bou9@gmail.com,haoxiang_li2024@163.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + rapidio-add-check-for-rio_add_net-in-rio_scan_alloc_net.patch added to mm-hotfixes-unstable branch
Message-Id: <20250227232348.A8788C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: rapidio: add check for rio_add_net() in rio_scan_alloc_net()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     rapidio-add-check-for-rio_add_net-in-rio_scan_alloc_net.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/rapidio-add-check-for-rio_add_net-in-rio_scan_alloc_net.patch

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
Subject: rapidio: add check for rio_add_net() in rio_scan_alloc_net()
Date: Thu, 27 Feb 2025 12:11:31 +0800

The return value of rio_add_net() should be checked.  If it fails,
put_device() should be called to free the memory and give up the reference
initialized in rio_add_net().

Link: https://lkml.kernel.org/r/20250227041131.3680761-1-haoxiang_li2024@163.com
Fixes: e6b585ca6e81 ("rapidio: move net allocation into core code")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Cc: Alexandre Bounine <alex.bou9@gmail.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio-scan.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/rapidio/rio-scan.c~rapidio-add-check-for-rio_add_net-in-rio_scan_alloc_net
+++ a/drivers/rapidio/rio-scan.c
@@ -871,7 +871,10 @@ static struct rio_net *rio_scan_alloc_ne
 		dev_set_name(&net->dev, "rnet_%d", net->id);
 		net->dev.parent = &mport->dev;
 		net->dev.release = rio_scan_release_dev;
-		rio_add_net(net);
+		if (rio_add_net(net)) {
+			put_device(&net->dev);
+			net = NULL;
+		}
 	}
 
 	return net;
_

Patches currently in -mm which might be from haoxiang_li2024@163.com are

m68k-sun3-add-check-for-__pgd_alloc.patch
rapidio-fix-an-api-misues-when-rio_add_net-fails.patch
rapidio-add-check-for-rio_add_net-in-rio_scan_alloc_net.patch

