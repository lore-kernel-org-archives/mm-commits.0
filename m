Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB4B119E98B;
	Thu,  6 Mar 2025 05:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741239481; cv=none; b=Ve1vutyokMI3GjevwekfFBTWYLFKJbv+1yu1QnMpBbGCPAxV+c4UcJWLH45HOj7LOZgh7z5Nsw8FyBaB25UNRpDa25n0v1fBHCXhJxf0fkqnpwGvlk5Sh6hXFA0lZ6Ar/1qIIz1I/1UC4UMfEhWTvAa5MoVX202svBa43I61bP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741239481; c=relaxed/simple;
	bh=Kp7+qb6KrGc12rhnJWMg7vZottYFmxP5uMTPFGPp/kY=;
	h=Date:To:From:Subject:Message-Id; b=FQCyYHKWMwtRJlppTkzDzCKW1SU3Z/sfT2QdG7ahZWVBX9aI3ze2eGHaT1dz0duwbSG7bAKdJI/HGl+NiAHxGD5SP/R1e5wRTsukxy/vl1P1Xb8CSzSOYJgGbq6/RU+7yR9E7NaaunybMqy7GV8hdtF5TxzEliCZN5mF/sDthEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZwIEp8n4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZwIEp8n4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1108C4CEE4;
	Thu,  6 Mar 2025 05:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741239480;
	bh=Kp7+qb6KrGc12rhnJWMg7vZottYFmxP5uMTPFGPp/kY=;
	h=Date:To:From:Subject:From;
	b=ZwIEp8n42rGCuJ3xLGhtg3GmRiX3o+fpey2K/R4LR5l2l7jiVjAQi5FnErTcUXw/D
	 4N/7BHbvQ0URlXL/aHTSr9E/IFkG1DHsKlAr6AWln4TJk7kJXhJ52iNNkdbg6IHR0O
	 jBeCyEy9wjWBhELYtmD+0JKWn0rU+O0u9+joK9aY=
Date: Wed, 05 Mar 2025 21:38:00 -0800
To: mm-commits@vger.kernel.org,yangyingliang@huawei.com,stable@vger.kernel.org,mporter@kernel.crashing.org,dan.carpenter@linaro.org,alex.bou9@gmail.com,haoxiang_li2024@163.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] rapidio-add-check-for-rio_add_net-in-rio_scan_alloc_net.patch removed from -mm tree
Message-Id: <20250306053800.C1108C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: rapidio: add check for rio_add_net() in rio_scan_alloc_net()
has been removed from the -mm tree.  Its filename was
     rapidio-add-check-for-rio_add_net-in-rio_scan_alloc_net.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


