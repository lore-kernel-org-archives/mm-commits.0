Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 751D0143736
	for <mm-commits@vger.kernel.org>; Sun, 11 May 2025 03:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746934375; cv=none; b=OwwjnEvH3YESXR+3ZJiosUErJafsWKmwC5SX5ORxrw5ieQrw+oG6tTk8O2kSWneJhP7yIL6Qw7wtFu8UNAA4LMZfyTGOy7arjR3wDrfSmK/yMe82QzrWfP5R7qkefYRR+RFA3VRH4FWJ/Rj1dAlUODJkEozhLfgM1cIcJiRHznE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746934375; c=relaxed/simple;
	bh=ZsMkbetGX+14x96VPQkOmetIenLBE2CAdEUIt3e6MeA=;
	h=Date:To:From:Subject:Message-Id; b=siT6CjefaEVvyPGZTorP6BkhB8CFSNmvRoILn3EMQQfFC83QW/67VVns7Q/Szj8s/08teKdN0nzC530arnanvzTb9p8EeQ43hVp7aQH+b+gvaPti2O1v8zNEQ+vPvHZvMbiCb7jOskX1krJT4IiZt/vmfaq5/VjHZWRHebCODnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PQ/zvKcY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PQ/zvKcY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 474A4C4CEE9;
	Sun, 11 May 2025 03:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746934375;
	bh=ZsMkbetGX+14x96VPQkOmetIenLBE2CAdEUIt3e6MeA=;
	h=Date:To:From:Subject:From;
	b=PQ/zvKcYEjhFTsZDtCl1QSdYhZVJjCHDDJHuYAAxVHkmxRutjTU5ids7mjX04j+4/
	 MYfySUmhL0PY8vNN8LGYgpVvM/iWhKu/ChzR1PXEGd78Yg1CbTlxz/tBqC7ISsGeOq
	 uYQirSpdA5QfgfzsMRkNcPOuRno75yswpnOmJpRo=
Date: Sat, 10 May 2025 20:32:54 -0700
To: mm-commits@vger.kernel.org,richardycc@google.com,minchan@kernel.org,dan.carpenter@linaro.org,bgeffon@google.com,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] zram-modernize-writeback-interface-v4.patch removed from -mm tree
Message-Id: <20250511033255.474A4C4CEE9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: modernize writeback interface
has been removed from the -mm tree.  Its filename was
     zram-modernize-writeback-interface-v4.patch

This patch was dropped because it was folded into zram-modernize-writeback-interface.patch

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: modernize writeback interface
Date: Wed, 9 Apr 2025 20:23:48 +0900

fix uninitialized variable in zram_writeback_slots(), per Dan

Link: https://lkml.kernel.org/r/20250409112611.1154282-1-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reviewed-by: Brian Geffon <bgeffon@google.com>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Richard Chang <richardycc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/block/zram/zram_drv.c~zram-modernize-writeback-interface-v4
+++ a/drivers/block/zram/zram_drv.c
@@ -741,7 +741,7 @@ static int zram_writeback_slots(struct z
 	struct zram_pp_slot *pps;
 	struct bio_vec bio_vec;
 	struct bio bio;
-	int ret, err;
+	int ret = 0, err;
 	u32 index;
 
 	page = alloc_page(GFP_KERNEL);
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zsmalloc-dont-underflow-size-calculation-in-zs_obj_write.patch
zram-modernize-writeback-interface.patch
zsmalloc-cleanup-headers-includes.patch
documentation-zram-update-idle-pages-tracking-documentation.patch

