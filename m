Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793329348;
	b=1kwl+0+d/o89ytStu9OzXxYZcZexdr7/3LbK8NGiFrqWDv7Cl2OuOg/oCBNSLw+HFbD3
	 GFMaJa1uex3MMnQOj8fRGjRbYkAr3/PQo9f/1zEWg2KhEnSiyfo2tqOhycksGSRK6zvp+
	 TjXsceLP+iRWpiE+fxO0QGN4xi54McqJgxOGrusO3MXaE0UnN9cntNRNXAac7UhWaTjJ4
	 sjrBJcU+Z+TdxyBBx5jDq9YFh7ckI/2VBuNPFQcxM1gk87JI4k8G81kBjotpdZkzuPlyZ
	 1NUBooMUnOKkgyhqTH4YCK+8XiQ45PY57ncJl2ahOBjwQKGPlYm5psg7lw/7RD1Rvaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793329348;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=7bZQwG3uBfbsLZDO2RCS6Z3UbVAUC+8vQpjij+D57xs=;
	b=n3MtIcDgAGexLUGpwzPT+kb0w3sf98uYUSA7m9J4h+Pb+BXxvFU/gbcePuPwB2LIhbvj
	 r+q9QmsxGt9raVFKbn/Q8zwKC/UOAe9ZDowLpm3ektEr9iCFJYrmvJwATPtJKhagNXtEd
	 Uwe4HE2xRQckTOJ/NJBcnuytH5L5EPDG9daztZJl3S0ZQeOKgErH/BHJvKywoi3WPl9ip
	 z3fz517d3xbYNM5lXJVrrvneFgeyjCOBITiTDahDcttPUuAusXOVTkoIpW9n9na2u9cHj
	 PczpKY5u9GhdZOPfagkbP0HS/k42i9HNGLspXeaGruUmj+MMlcBIMthE5ViuXLLdmUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=V8Yaf0ZY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55553606A325
	for <mm-commits@vger.kernel.org>; Fri, 30 Oct 2026 03:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=V8Yaf0ZY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8B971F00A02;
	Fri, 30 Oct 2026 03:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793329347;
	bh=7bZQwG3uBfbsLZDO2RCS6Z3UbVAUC+8vQpjij+D57xs=;
	h=Date:To:From:Subject;
	b=V8Yaf0ZYenxqz0j5H/166RSoh6TazvD1kq5nNECwAlfMujm10FoI9BlzLoLg/wKP5
	 aerzGmIlQaQKZq7hIGK6YTXbUH7mBhFUgQAtZEjhACqL6dW487uM3YdxdPEYnXMTvw
	 lrQW5o4pb6KHa44oXxM/VMofmbDqKxerIqGTlLuk=
Date: Thu, 29 Oct 2026 20:02:27 -0700
To: mm-commits@vger.kernel.org,zhangbo56@xiaomi.com,zhangbo0325@gmail.com,
	richardycc@google.com,minchan@kernel.org,hdanton@sina.com,bgeffon@google.com,
	baohua@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-remove-stale-warn_on-from-zram_read_page.patch added to mm-nonmm-unstable branch
Message-Id: <20261030030227.C8B971F00A02@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: zram: remove stale WARN_ON() from zram_read_page()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     zram-remove-stale-warn_on-from-zram_read_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-remove-stale-warn_on-from-zram_read_page.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: remove stale WARN_ON() from zram_read_page()
Date: Sun, 25 Oct 2026 11:18:21 +0900

The zram_read_page() WARN_ON() is not accurate anymore, because, in
theory, async read from bdev can return -EIO or -ENOMEM.  We report
errors to upper layers via bi_status, so upper layers printk errors.

Link: https://lore.kernel.org/20261025021839.1542805-6-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Bo Zhang <zhangbo0325@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Richard Chang <richardycc@google.com>
Cc: Bo Zhang <zhangbo56@xiaomi.com>
Cc: Hillf Danton <hdanton@sina.com>
---

 drivers/block/zram/zram_drv.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-remove-stale-warn_on-from-zram_read_page
+++ a/drivers/block/zram/zram_drv.c
@@ -2204,10 +2204,6 @@ static int zram_read_page(struct zram *z
 		ret = read_from_bdev(zram, page, index, blk_idx, parent);
 	}
 
-	/* Should NEVER happen. Return bio error if it does. */
-	if (WARN_ON(ret < 0))
-		pr_err("Decompression failed! err=%d, page=%lu\n", ret, index);
-
 	return ret;
 }
 
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-prefix-backends-printk-s.patch
zram-remove-debugfs-entry-on-init-failure.patch
zram-reset-writeback-state-in-zram_reset_device.patch
zram-move-mark_slot_accessed-under-existing-slot-lock-sections.patch
zram-remove-stale-warn_on-from-zram_read_page.patch
zram-zstd-do-not-allocate-empty-c-d-dictionaries.patch
zram-lz4hc-pre-initialize-dictionary-stream-in-setup_params.patch
zram-lz4-use-lz4_decompress_safe_usingdict.patch
zram-lz4hc-use-lz4_decompress_safe_usingdict.patch
zram-zstd-do-not-use-kvzalloc-for-zstd-allocations.patch
zram-split-zcomp-into-separate-r-w-streams.patch
zram-introduce-shared-decompression-streams.patch
zram-allocate-bounce-buffer-for-spanning-objects.patch
zram-borrow-idle-decompression-streams-in-exclusive-mode.patch
zram-use-a-singleton-compression-context-for-recompression.patch

