Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B83C199FCE
	for <mm-commits@vger.kernel.org>; Tue,  1 Oct 2024 21:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727819868; cv=none; b=OjyheuYVrdc01UMoS8ogKYo0m0mzw9A5JwPUeqeMGrRdh/WDRmFlo24eHd/qOD3E9KxxROWOCxgruj9G3Mpz9Y6ukZiLNJ4LizhG+/QwvQ0CkmnngTUKuEYvefywiY0S6IShHjF0vVU4rerLqoAdEgCqH2ORlvLz3AUEHYylbqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727819868; c=relaxed/simple;
	bh=jRGoRdwQe8UIN6ObyW0YiRcbtc75WfA/PA/XjL7hWxQ=;
	h=Date:To:From:Subject:Message-Id; b=ptd/FAowP1zxgygstIVSdIxN5pcNNe48VlykY0jbXu+ENF0AQIjRj1QjKotV43pVirEbYV+RFfsW3tEYH06Qtbc/RZHp0CKGVImlLbYzLofp0CarPemI7YtxDmOsxYeSkI+eqni0U30mOY3sKmoKGd2fXP7jU1iIB5YzkTND4GI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SxLx809S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SxLx809S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADAEEC4CEC6;
	Tue,  1 Oct 2024 21:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727819867;
	bh=jRGoRdwQe8UIN6ObyW0YiRcbtc75WfA/PA/XjL7hWxQ=;
	h=Date:To:From:Subject:From;
	b=SxLx809Sgctz+sMXaoNeVuKovIkttZEk8d8v+QE8vsUqFXSF3dtDnilJ3J7uqk8u3
	 anm6AIdegYzAG+/HRmpQPvHBQ16eItKxSKquqY5xLLYjdmqmfIQbafelVLMom67q+9
	 ePPYuvMStQoQ3uU0hLKj5AF1U9hHh8fVR63Lqf7Q=
Date: Tue, 01 Oct 2024 14:57:47 -0700
To: mm-commits@vger.kernel.org,minchan@kernel.org,dan.carpenter@linaro.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-rework-recompress-target-selection-strategy-fix.patch added to mm-unstable branch
Message-Id: <20241001215747.ADAEEC4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: do not skip the first bucket
has been added to the -mm mm-unstable branch.  Its filename is
     zram-rework-recompress-target-selection-strategy-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-rework-recompress-target-selection-strategy-fix.patch

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
Subject: zram: do not skip the first bucket
Date: Tue, 1 Oct 2024 17:55:56 +0900

A small fixup.

Link: https://lkml.kernel.org/r/20241001085634.1948384-1-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/block/zram/zram_drv.c~zram-rework-recompress-target-selection-strategy-fix
+++ a/drivers/block/zram/zram_drv.c
@@ -264,7 +264,7 @@ static struct zram_pp_slot *select_pp_sl
 	s32 idx = NUM_PP_BUCKETS - 1;
 
 	/* The higher the bucket id the more optimal slot post-processing is */
-	while (idx > 0) {
+	while (idx >= 0) {
 		pps = list_first_entry_or_null(&ctl->pp_buckets[idx],
 					       struct zram_pp_slot,
 					       entry);
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-introduce-zram_pp_slot-flag.patch
zram-permit-only-one-post-processing-operation-at-a-time.patch
zram-rework-recompress-target-selection-strategy.patch
zram-rework-recompress-target-selection-strategy-fix.patch
zram-rework-writeback-target-selection-strategy.patch
zram-do-not-mark-idle-slots-that-cannot-be-idle.patch
zram-reshuffle-zram_free_page-flags-operations.patch
zram-remove-under_wb-and-simplify-writeback.patch

