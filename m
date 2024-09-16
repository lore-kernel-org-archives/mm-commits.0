Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AED6155316;
	Mon, 16 Sep 2024 14:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726497798; cv=none; b=lISwp9f7LpNE1ozcAz2KkFvpMU/Wi8wyXuUUKezFjPZUCV/2SSh8qM7c/Nr16nEMukezX7JmnxWqh9HJo788WRU1o28Wr+kLa4C86hovxDGqDfc+38Q30A6JE8tCrf+Tkr8obvP11KeJT4XCKo6zEK0FTdxle6bosuzZMUDuyyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726497798; c=relaxed/simple;
	bh=yZP0ywzUOpqlm3tR2QySgnnY9Yp8bn8W+dSMtAexxM4=;
	h=Date:To:From:Subject:Message-Id; b=gestbOCIhhh9W9PZYMeIoyU52PZZ8yTSISCO2BDi5NZ6gmLKglMuri09E13ISEQantVPH13y4kJbcTTnZtUIPrEjZHODS1AZ3nDqObSwFMHIn0LC/jH4Z2PJfBPwTQ1gjEU4pD/fmXJIajPpJ9cSgHAF4VnWJ/AxVBZD08gE+uM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ttxT6bgR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ttxT6bgR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5096CC4CEC4;
	Mon, 16 Sep 2024 14:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1726497797;
	bh=yZP0ywzUOpqlm3tR2QySgnnY9Yp8bn8W+dSMtAexxM4=;
	h=Date:To:From:Subject:From;
	b=ttxT6bgRkozdVQp3YOIyDqOUbdxCzO9A5737jzQIp3Ik64C8z78oBRtWW+Mxi1/Tr
	 1yaOz/2pvtRniK5+t0QghyBEMEUjrpFYxcUpEMykasPzrPzjagOv8AgckaczTXe44S
	 ahb4baCkjL9AP7qSAAUDjPXwk5vsfdEHAwfp86us=
Date: Mon, 16 Sep 2024 07:43:14 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-free-secondary-algorithms-names.patch added to mm-unstable branch
Message-Id: <20240916144317.5096CC4CEC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: free secondary algorithms names
has been added to the -mm mm-unstable branch.  Its filename is
     zram-free-secondary-algorithms-names.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-free-secondary-algorithms-names.patch

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
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: free secondary algorithms names
Date: Wed, 11 Sep 2024 11:54:56 +0900

We need to kfree() secondary algorithms names when reset zram device that
had multi-streams, otherwise we leak memory.

Link: https://lkml.kernel.org/r/20240911025600.3681789-1-senozhatsky@chromium.org
Fixes: 001d92735701 ("zram: add recompression algorithm sysfs knob")
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/block/zram/zram_drv.c~zram-free-secondary-algorithms-names
+++ a/drivers/block/zram/zram_drv.c
@@ -2112,6 +2112,13 @@ static void zram_destroy_comps(struct zr
 		zram->num_active_comps--;
 	}
 
+	for (prio = ZRAM_SECONDARY_COMP; prio < ZRAM_MAX_COMPS; prio++) {
+		if (!zram->comp_algs[prio])
+			continue;
+		kfree(zram->comp_algs[prio]);
+		zram->comp_algs[prio] = NULL;
+	}
+
 	zram_comp_params_reset(zram);
 }
 
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zsmalloc-use-unique-zsmalloc-caches-names.patch
zram-free-secondary-algorithms-names.patch

