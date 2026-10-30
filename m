Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793329344;
	b=GZDUWf8v9gcu+MFqwAR3oXhpqR6vOVkYhRKUehdSEfzSv9lIlS59rsnVCziS/7vExs8n
	 7Zmw9AI/BasOC07KoyZazllOSPDXS6w83kmuBhO51FPxcBfYa5WiGrVz/t1iqAKP0BUA5
	 sTjeJ7IH6xO3fT58pKIW9m7svycM610XFqTWeVZCXHiAzONX/jAaNS4u05QbeMtXEd0Xw
	 kcm1JUWK7uQBttwIXAwFeTCmHrEG2mR77lxHFAB67RKCujZylUDECpNtGRyDhaB+DiXnY
	 Bjx6hq4AsAi+z0p1bGZiHKHoSPXMlKbypHXYcvedD6nZZdAlhAJrk4qClYO+fMlHNnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793329344;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=e19b4jiCCGHm0zmJUXIUt4W8BkKciyuQnNDdKqPjRss=;
	b=de5J9Cg4SWA9ut02IrS7ILr4bu2K0zjT+yV9I/jZeBlH6yxGvanytqYNG55shKEmCzYX
	 S/1J15FXpRRL2b5B9b9ufK6m1f8rkq28BAZ4P0tCVcS0XbDJd2BCCfi4qMIbVlHeAXnOK
	 dMvltNnOCNr+UvR32d7rSu/WaLSiKsoHTIW/0eohCVfLvaioDqvg8I7pdn6caNQgmddvE
	 UnEdpc1+HKLgNmRQuXi93WFQAMLGS71Dj/7gl0ku5JPeXTfVP2yhA6n7zdmElmyLv0I7g
	 tEv74GZTmrdWcsS0pYeKL2l4yz3efgDnYybBWTYn8ben6CEq9QY5B5DMQlO4vO3/1LQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=PyuljWtJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7696E606A322
	for <mm-commits@vger.kernel.org>; Fri, 30 Oct 2026 03:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=PyuljWtJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 066451F000C1;
	Fri, 30 Oct 2026 03:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793329344;
	bh=e19b4jiCCGHm0zmJUXIUt4W8BkKciyuQnNDdKqPjRss=;
	h=Date:To:From:Subject;
	b=PyuljWtJJxLNW2rs3v4PahWdRN/BI1Si0e3tGK8fvGQUWBecQ+7AqQ1OT75PFsv6E
	 pGWYDuMALBrLS224qPKjVCZBXRvc7nMyvRrL+BolSsuJkyFTHj3xm8IukTRAA2Q2Gx
	 862ESxkOuCXz7fb2XDLPo9EwYGk8KPD8Y4BN1F00=
Date: Thu, 29 Oct 2026 20:02:23 -0700
To: mm-commits@vger.kernel.org,zhangbo56@xiaomi.com,zhangbo0325@gmail.com,
	richardycc@google.com,minchan@kernel.org,hdanton@sina.com,bgeffon@google.com,
	baohua@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-reset-writeback-state-in-zram_reset_device.patch added to mm-nonmm-unstable branch
Message-Id: <20261030030224.066451F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: zram: reset writeback state in zram_reset_device()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     zram-reset-writeback-state-in-zram_reset_device.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-reset-writeback-state-in-zram_reset_device.patch

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
Subject: zram: reset writeback state in zram_reset_device()
Date: Sun, 25 Oct 2026 11:18:19 +0900

Reset all writeback state to its initial defaults on device reset.
We used to keep writeback related data in zram->stats, which
zram_reset_device() clears, but commit 1d69a3f8ae77 ("zram: idle
writeback fixes and cleanup") moved it (along with the newly added
wb_limit_enable) to struct zram, after which neither of them was
reset anymore.  wb_batch_size and compressed_wb, which were added
later, are not reset either.

The patch is more about just being pedantic.

Link: https://lore.kernel.org/20261025021839.1542805-4-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Brian Geffon <bgeffon@google.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Cc: Bo Zhang <zhangbo0325@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Richard Chang <richardycc@google.com>
Cc: Bo Zhang <zhangbo56@xiaomi.com>
Cc: Hillf Danton <hdanton@sina.com>
---

 drivers/block/zram/zram_drv.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/block/zram/zram_drv.c~zram-reset-writeback-state-in-zram_reset_device
+++ a/drivers/block/zram/zram_drv.c
@@ -694,6 +694,7 @@ static void reset_bdev(struct zram *zram
 	zram->disk->fops = &zram_devops;
 	kvfree(zram->bitmap);
 	zram->bitmap = NULL;
+	zram->nr_pages = 0;
 }
 
 static ssize_t backing_dev_show(struct device *dev,
@@ -2881,6 +2882,12 @@ static void zram_reset_device(struct zra
 	zram_destroy_comps(zram);
 	memset(&zram->stats, 0, sizeof(zram->stats));
 	reset_bdev(zram);
+#ifdef CONFIG_ZRAM_WRITEBACK
+	zram->wb_limit_enable = false;
+	zram->bd_wb_limit = 0;
+	zram->wb_batch_size = 32;
+	zram->compressed_wb = false;
+#endif
 }
 
 static ssize_t disksize_store(struct device *dev, struct device_attribute *attr,
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

