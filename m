Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793329343;
	b=We4WHFHQctBzwFPo/44cTqeb8hUX38lt9sBeLJ1BvGiwobXmkOFMHYHBcwbMNkYv8yTf
	 5ynYFL1deFvdxwr+sD4A8DceYFh+cpLSJh0NXupd/w+H7CdtIesyVl7pwS8Q+n0ZON/s+
	 dJQs80ie2PLnkYoxgpGhK0WuOBNXODqY+qN6edhpsoyQR8TGw2RdXnCZkBNm2sv9hMIGC
	 qAJSCJbe/0ja+houl7HaX9UUsSDd6b716/JY/VnHcyXdTWrgybtOFAvjEHsz9rSRamk5z
	 F2YFUhs+djz8MFbAzxzyPUnRwzC4Yacdf8AIv0rkc8ZORx1XEjJ5OODwCrLLJ250cqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793329343;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=a1BMpS1pJUWv/fL2IMAiUq2YWrD2P/rvA28DqlMrHnQ=;
	b=1XUihmaL5EY91gOic/b6TLFYdY9CN+lq+h7HN+oE9VOcjEaNxZxTne4/9GhgVIdS/3f+
	 aMj14ZxyAhWEhHN/beGL4SbPD+oBTBFoDnlphKcWuh9tgbwphwKDVPGyRwqiswywSPgri
	 jHJd/4SyhimZql7A0TL8o0yEy4FXAHSiMQ2umIjp5UQEpScN6kBjrKkKP03NzUS+fD0rB
	 FPME1sGT2hlmj1Ty5v2Wtu+zmLev4uIA70gRaH5DqV1+W2d0w9Qnhm1c23F/M2qQlkZgv
	 28zGfxo8sVMeFEeUB6UCW3oVK1NbvL8MsmoeMPnMjpt0+XSFIEOVvISm4ob1IFtZnJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=bBXR743+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06B8F606A31A
	for <mm-commits@vger.kernel.org>; Fri, 30 Oct 2026 03:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=bBXR743+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21B531F000C1;
	Fri, 30 Oct 2026 03:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793329342;
	bh=a1BMpS1pJUWv/fL2IMAiUq2YWrD2P/rvA28DqlMrHnQ=;
	h=Date:To:From:Subject;
	b=bBXR743+5ZHshLP4PxWRIxU3TaOC6dip22Mtn5lIwtq2ukuknl5zW7YiBkku34Qex
	 TsZlvE1N0FwlTbPWhkEgGrYsmc5ZAW7LyFIuSHOUzU1oqUBrXcX2hYO3bHdi11k2vx
	 5+L5EQsMa5JuA255H/PExNkebVfzl+pgTIaCxbyo=
Date: Thu, 29 Oct 2026 20:02:21 -0700
To: mm-commits@vger.kernel.org,zhangbo56@xiaomi.com,zhangbo0325@gmail.com,
	richardycc@google.com,minchan@kernel.org,hdanton@sina.com,bgeffon@google.com,
	baohua@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-remove-debugfs-entry-on-init-failure.patch added to mm-nonmm-unstable branch
Message-Id: <20261030030222.21B531F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: zram: remove debugfs entry on init failure
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     zram-remove-debugfs-entry-on-init-failure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-remove-debugfs-entry-on-init-failure.patch

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
Subject: zram: remove debugfs entry on init failure
Date: Sun, 25 Oct 2026 11:18:18 +0900

Do not leak the debugfs entry when zram_init() fails to register
the block device.

Link: https://lore.kernel.org/20261025021839.1542805-3-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Barry Song <baohua@kernel.org>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Bo Zhang <zhangbo0325@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Richard Chang <richardycc@google.com>
Cc: Bo Zhang <zhangbo56@xiaomi.com>
Cc: Hillf Danton <hdanton@sina.com>
---

 drivers/block/zram/zram_drv.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/block/zram/zram_drv.c~zram-remove-debugfs-entry-on-init-failure
+++ a/drivers/block/zram/zram_drv.c
@@ -3297,6 +3297,7 @@ static int __init zram_init(void)
 	if (zram_major <= 0) {
 		pr_err("Unable to get major number\n");
 		class_unregister(&zram_control_class);
+		zram_debugfs_destroy();
 		cpuhp_remove_multi_state(CPUHP_ZCOMP_PREPARE);
 		return -EBUSY;
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

