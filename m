Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3709E79C4
	for <mm-commits@vger.kernel.org>; Wed, 25 Sep 2024 00:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727225149; cv=none; b=ZRPoftjM/1cwfHHmyI4VjiJkuLSQalDbPFi5+a/IUFh2QJmlQuYXFQYb52Snv+v0Q1rqEi50p5cUepDej40k5pBjYw0M16ISrrcyB6xMl6AvMCWQ5rboqoxSHlL+5BclXiaUXe1GdsNeh5355kmZeYdwJuYTXzCOq8jk139llic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727225149; c=relaxed/simple;
	bh=kGBxWxrbJXM0PH6WzRH/OeT3fJMHLLEFsH1HJnZFkyA=;
	h=Date:To:From:Subject:Message-Id; b=lJpeg2bXBrB/XELOspBYHvPx+Vw7/s9hj0kWOfbzcDr50q+O5pA/3N04rQn3XkMMnqhXAHDJADytUUNGIAEbUg3yeak/HifZdGhAG9y/nwCVqWm5t/he+y8MhQJkAbWB89agxbQBoJzcul+hs+8PxrRa4We1Diukv/HGO0PXUhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OTkp8m1Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OTkp8m1Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93DDFC4CEC4;
	Wed, 25 Sep 2024 00:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727225148;
	bh=kGBxWxrbJXM0PH6WzRH/OeT3fJMHLLEFsH1HJnZFkyA=;
	h=Date:To:From:Subject:From;
	b=OTkp8m1YTMLaG3WILjBuh/IQMPVkPB/qstFB78jfBVIKucXcE7Aru2Tlgg1xu+Cns
	 ya1ZXHPPFhTHl8dWb2oxakxPwUFUpxhaUExRc2p16iNJg2citBfyANWigpqEGgEyTI
	 N9BJeTJXsM+9XarRy55wRHrMiYnL5V7Xf0UMkP4A=
Date: Tue, 24 Sep 2024 17:45:48 -0700
To: mm-commits@vger.kernel.org,venkat88@linux.vnet.ibm.com,senozhatsky@chromium.org,minchan@kernel.org,christophe.jaillet@wanadoo.fr,chrisl@kernel.org,axboe@kernel.dk,andrej.skvortzov@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-dont-free-statically-defined-names.patch added to mm-hotfixes-unstable branch
Message-Id: <20240925004548.93DDFC4CEC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: don't free statically defined names
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     zram-dont-free-statically-defined-names.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-dont-free-statically-defined-names.patch

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
From: Andrey Skvortsov <andrej.skvortzov@gmail.com>
Subject: zram: don't free statically defined names
Date: Mon, 23 Sep 2024 19:48:43 +0300

When CONFIG_ZRAM_MULTI_COMP isn't set ZRAM_SECONDARY_COMP can hold
default_compressor, because it's the same offset as ZRAM_PRIMARY_COMP, so
we need to make sure that we don't attempt to kfree() the statically
defined compressor name.

This is detected by KASAN.

==================================================================
  Call trace:
   kfree+0x60/0x3a0
   zram_destroy_comps+0x98/0x198 [zram]
   zram_reset_device+0x22c/0x4a8 [zram]
   reset_store+0x1bc/0x2d8 [zram]
   dev_attr_store+0x44/0x80
   sysfs_kf_write+0xfc/0x188
   kernfs_fop_write_iter+0x28c/0x428
   vfs_write+0x4dc/0x9b8
   ksys_write+0x100/0x1f8
   __arm64_sys_write+0x74/0xb8
   invoke_syscall+0xd8/0x260
   el0_svc_common.constprop.0+0xb4/0x240
   do_el0_svc+0x48/0x68
   el0_svc+0x40/0xc8
   el0t_64_sync_handler+0x120/0x130
   el0t_64_sync+0x190/0x198
==================================================================

Link: https://lkml.kernel.org/r/20240923164843.1117010-1-andrej.skvortzov@gmail.com
Fixes: 684826f8271a ("zram: free secondary algorithms names")
Signed-off-by: Andrey Skvortsov <andrej.skvortzov@gmail.com>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reported-by: Venkat Rao Bagalkote <venkat88@linux.vnet.ibm.com>
Closes: https://lore.kernel.org/lkml/57130e48-dbb6-4047-a8c7-ebf5aaea93f4@linux.vnet.ibm.com/
Tested-by: Venkat Rao Bagalkote <venkat88@linux.vnet.ibm.com>
Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Venkat Rao Bagalkote <venkat88@linux.vnet.ibm.com>
Cc: Chris Li <chrisl@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-dont-free-statically-defined-names
+++ a/drivers/block/zram/zram_drv.c
@@ -2115,8 +2115,10 @@ static void zram_destroy_comps(struct zr
 		zram->num_active_comps--;
 	}
 
-	for (prio = ZRAM_SECONDARY_COMP; prio < ZRAM_MAX_COMPS; prio++) {
-		kfree(zram->comp_algs[prio]);
+	for (prio = ZRAM_PRIMARY_COMP; prio < ZRAM_MAX_COMPS; prio++) {
+		/* Do not free statically defined compression algorithms */
+		if (zram->comp_algs[prio] != default_compressor)
+			kfree(zram->comp_algs[prio]);
 		zram->comp_algs[prio] = NULL;
 	}
 
_

Patches currently in -mm which might be from andrej.skvortzov@gmail.com are

zram-dont-free-statically-defined-names.patch

