Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECC2F222578
	for <mm-commits@vger.kernel.org>; Tue, 25 Nov 2025 17:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764090750; cv=none; b=QF8uP0AsMsBUM2Zj1NGOkwe9WMt1DUcF6ABuYEox0MHUL2U8J3JHT9GGPX74Co0wVSuO6F6ESRkAgY1wtrJaHK5QOY+03wZn+0dFbPJnKt7QtnfAOZcLHyTsELaEENAsprNbT0GnJinztb7f4YB5SqMBXjfqScftjYlOkM5kFw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764090750; c=relaxed/simple;
	bh=HjGCZPJ7nxqMo5VVBnpPdv3fvJzZ9NTDHCHeUC4pDYE=;
	h=Date:To:From:Subject:Message-Id; b=WTdsFG+sg/gMRlOGt3KMaF4WfxzpjmJ8SLb9zrIMtisZ1ZNO3FOeuPDD0/s4lxzkz5Tp2uuhktZRcgvDR7yhZkOgt84WDIITVvQwz25IGPSe+vSabKa/1tG1eqOSFETSNrG3O8Qh18u4Zd5pa7or8Kcy4/FLAqhM7c1e6fL8aCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uj+5scww; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uj+5scww"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67489C4CEF1;
	Tue, 25 Nov 2025 17:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764090749;
	bh=HjGCZPJ7nxqMo5VVBnpPdv3fvJzZ9NTDHCHeUC4pDYE=;
	h=Date:To:From:Subject:From;
	b=uj+5scwwJNGFQNMYnPi6oGhXCujgx5Wka43ua3BpB7VdfB+JWa9UvEd0N85ifaPGb
	 VFjjBHp1RWPVmwET16iHwHcFJ0jzgAqzSBlyCySQvsPxOo55SvxmGuM4GxlWzWrEPv
	 Hc2mraVVLVtjFRgIH8hfIEYLruAbWODfVyMfBiUw=
Date: Tue, 25 Nov 2025 09:12:28 -0800
To: mm-commits@vger.kernel.org,senozhatsky@chromium.org,minchan@kernel.org,axboe@kernel.dk,chuguangqing@inspur.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-fix-a-spelling-mistake.patch added to mm-unstable branch
Message-Id: <20251125171229.67489C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: fix a spelling mistake
has been added to the -mm mm-unstable branch.  Its filename is
     zram-fix-a-spelling-mistake.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-fix-a-spelling-mistake.patch

This patch will later appear in the mm-unstable branch at
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
From: Chu Guangqing <chuguangqing@inspur.com>
Subject: zram: fix a spelling mistake
Date: Tue, 25 Nov 2025 10:05:22 +0800

The spelling of the word "relases" is incorrect; it should be "releases".

Link: https://lkml.kernel.org/r/20251125020522.1913-1-chuguangqing@inspur.com
Signed-off-by: Chu Guangqing <chuguangqing@inspur.com>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/block/zram/zram_drv.c~zram-fix-a-spelling-mistake
+++ a/drivers/block/zram/zram_drv.c
@@ -1043,7 +1043,7 @@ static int zram_writeback_slots(struct z
 		index = pps->index;
 		zram_slot_lock(zram, index);
 		/*
-		 * scan_slots() sets ZRAM_PP_SLOT and relases slot lock, so
+		 * scan_slots() sets ZRAM_PP_SLOT and releases slot lock, so
 		 * slots can change in the meantime. If slots are accessed or
 		 * freed they lose ZRAM_PP_SLOT flag and hence we don't
 		 * post-process them.
_

Patches currently in -mm which might be from chuguangqing@inspur.com are

zram-fix-a-spelling-mistake.patch

