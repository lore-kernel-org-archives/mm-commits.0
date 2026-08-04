Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2573633937F
	for <mm-commits@vger.kernel.org>; Tue,  4 Aug 2026 19:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785873579; cv=none; b=XsfrzMw+2ub/y96JzGbqeY4ydaub1/6RGzJcee/XxNfTWo+fGd4iUx9LikvY/rMBPosnf/F3eJN0kiWbiTmRjeC2JsyBfVShfCEgkrc1tVqcPTg1hGMw18GJ0zZ+XO7jiqnGLFIiFbc0y5xobs2TvAA+bz6tzLU4XbpJomlezYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785873579; c=relaxed/simple;
	bh=I6xXXZXle2fGkeZTg2migPFFoHkmQjf3READ10txwA4=;
	h=Date:To:From:Subject:Message-Id; b=keEjPalrA+tpJXW/3ViFUlWOxYOoF+5hgSeyCwfGUVBJ9qbWIoRJDqsatcXywaAzrIK/H1qzhlAX/38J/nKFovtKpLkHduDUkC5yT+WFJaciSnaq9R/EJhDTATHmlGsjBwYRV0jxMj5ff+unB2Cgscb8jwsqEkCB/dzRGnqmbjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TWSYgYRe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TWSYgYRe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90D0D1F000E9;
	Tue,  4 Aug 2026 19:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785873577;
	bh=+7XD2hdh3UgBoiqJ/ZbSExxD32kaQNOkM9MkP8+JXQ8=;
	h=Date:To:From:Subject;
	b=TWSYgYReLt3mJtlH4kFMv66fZ/7P38z4SDzB8yBBNT3fRa6N/DjcfW4EBDCVwVkjw
	 gU9Yq+hAQo0rKi38Ph3qaOAaAgyVw7Gl8ZmHaEnyrKSADM4lb8HjMMmhjgmXbx4h1X
	 Rh6Xy529wLECmuNu2bFlTX9cGvhxN17YiWWybH8k=
Date: Tue, 04 Aug 2026 12:59:37 -0700
To: mm-commits@vger.kernel.org,zigiwang@tencent.com,terrelln@fb.com,senozhatsky@chromium.org,minchan@kernel.org,dsterba@suse.com,axboe@kernel.dk,haoqinhuang@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-reject-zero-size-dictionary.patch added to mm-new branch
Message-Id: <20260804195937.90D0D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: reject zero-size dictionary
has been added to the -mm mm-new branch.  Its filename is
     zram-reject-zero-size-dictionary.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-reject-zero-size-dictionary.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Haoqin Huang <haoqinhuang@tencent.com>
Subject: zram: reject zero-size dictionary
Date: Tue, 4 Aug 2026 17:38:38 +0800

kernel_read_file_from_path() already rejects empty files (i_size <= 0) and
returns -EINVAL, but the current implementation only checks for sz < 0
without logging any information.  Use sz == 0 to reject the zero-size case
and print distinct error messages for each failure type.

Link: https://lore.kernel.org/20260804093841.67920-3-haoqinhuang7@gmail.com
Signed-off-by: Haoqin Huang <haoqinhuang@tencent.com>
Signed-off-by: Rongwei Wang <zigiwang@tencent.com>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Tested-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: David Sterba <dsterba@suse.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nick Terrell <terrelln@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/block/zram/zram_drv.c~zram-reject-zero-size-dictionary
+++ a/drivers/block/zram/zram_drv.c
@@ -1700,8 +1700,16 @@ static int comp_params_store(struct zram
 						INT_MAX,
 						NULL,
 						READING_POLICY);
-		if (sz < 0)
+		if (sz < 0) {
+			pr_err("failed to load dictionary %s (err=%zd)\n",
+			       dict_path, sz);
+			return sz;
+		}
+		if (sz == 0) {
+			pr_err("failed to load dictionary %s (empty file)\n",
+			       dict_path);
 			return -EINVAL;
+		}
 	}
 
 	zram->params[prio].dict_sz = sz;
_

Patches currently in -mm which might be from haoqinhuang@tencent.com are

zram-do-not-release-zstd-global-params-from-error-paths.patch
zram-reject-zero-size-dictionary.patch
zram-add-pr_fmt-to-backend-files.patch
zram-validate-parameters-in-each-backends-setup_params.patch
zram-reset-per-priority-params-when-changing-algorithm-before-init.patch

