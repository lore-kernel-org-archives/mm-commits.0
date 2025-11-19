Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97AE022E3F0
	for <mm-commits@vger.kernel.org>; Wed, 19 Nov 2025 23:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763594808; cv=none; b=kTI3WiwXJ8sjAA3W8z1/nNQROmMjb+ln4fke6S9ZMbvAeIvAOUDgKeXEVZb0ILExirLhovsx9SufnDrfZzbv7FrF7bozPDeqd/13kGJvBLNUHpqmOPPu6IfsGyb2AQxnGb2eusD3Ca1OstCjBM4hYZXP2Uix9Oj0ghBtfq6yvjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763594808; c=relaxed/simple;
	bh=XAR+YhxgRzBdtJmQQuhfaOQ8yqjIABDcRPnYI+fL7dg=;
	h=Date:To:From:Subject:Message-Id; b=tvVkT4mKL9eTmznhaWfQhWOVBkWoV5BpYd/y4MU7FXR+wkVBO5krKoKztmXL0y7nayXjvaTvNoFFRaLE2oL1UXIJ0/qiRA/qY4hTmfIPitBVR5ckdow02wy5JMYYurFUCRoO+j7HpjmaE0ahew9HNQQLmqzPWE4uwHgQrmx62/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dd2ZzG6I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dd2ZzG6I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A838C4CEF5;
	Wed, 19 Nov 2025 23:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763594806;
	bh=XAR+YhxgRzBdtJmQQuhfaOQ8yqjIABDcRPnYI+fL7dg=;
	h=Date:To:From:Subject:From;
	b=dd2ZzG6IEWoywRVCOtQY1pNrdhKtcVnqIZog+qlyLhoJAUUCnuNFiVAph8/i851sY
	 cR+sLC4Lu5HQaoKYl12lhUMPqudT5xtfvy3DYxlX50IH6L/aShKwarQtKVwCamDRGi
	 3D/UgLPACnYOlSxerD0sHz+5uuoH0suGQqcVf8q0=
Date: Wed, 19 Nov 2025 15:26:45 -0800
To: mm-commits@vger.kernel.org,richardycc@google.com,minchan@kernel.org,dan.carpenter@oracle.com,bgeffon@google.com,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-introduce-writeback-bio-batching-support-fix.patch added to mm-unstable branch
Message-Id: <20251119232646.1A838C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: fixup "introduce writeback bio batching support"
has been added to the -mm mm-unstable branch.  Its filename is
     zram-introduce-writeback-bio-batching-support-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-introduce-writeback-bio-batching-support-fix.patch

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
Subject: zram: fixup "introduce writeback bio batching support"
Date: Wed, 19 Nov 2025 18:46:53 +0900

add missing NULL check, per Dan

Link: https://lkml.kernel.org/r/20251119094715.2447022-1-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Richard Chang <richardycc@google.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/block/zram/zram_drv.c~zram-introduce-writeback-bio-batching-support-fix
+++ a/drivers/block/zram/zram_drv.c
@@ -760,6 +760,9 @@ static void release_wb_req(struct zram_w
 
 static void release_wb_ctl(struct zram_wb_ctl *wb_ctl)
 {
+	if (!wb_ctl)
+		return;
+
 	/* We should never have inflight requests at this point */
 	WARN_ON(!list_empty(&wb_ctl->inflight_reqs));
 
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-introduce-writeback-bio-batching-support-fix.patch
zram-add-writeback-batch-size-device-attr.patch
zram-take-write-lock-in-wb-limit-store-handlers.patch
zram-drop-wb_limit_lock.patch
zram-rework-bdev-block-allocation.patch
zram-read-slot-block-idx-under-slot-lock.patch

