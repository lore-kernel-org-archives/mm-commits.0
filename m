Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793329346;
	b=HFYNC0xZioBlFNgR1XSeY2sfrruozqztZfibu2YVEzFcOORNhsKinNqLnwiuxCg0Yf5P
	 AMyXpzCm7FLjNTmvgEpKhwWlDvsNEjX8q9JY/ixzy75zh0w/e7QZ1orPgKcTtYJu4hr4a
	 lkWg81lPaDWOrRf/GqNF5oz3KwmnYfAGaCLlQ16oB3EX4UWgah+7k1gTTWRhSknlWWMFk
	 b7aMlMdMyrCBJT8waqyk+pD4IqObdKJjuE3uCjRWwzow/Rxc3uJA3pLqJTF84QaeMMuIv
	 9Mq0dl5xtrmCfBRmlatmIgoT2gnL0aq/dKS6ltxSOlRuZqMTXl2HJWJta5+WCDeRzdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793329346;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=gNl8IoLvaaFN0xGd2/CfNTe4EYt1gPL1PIrapnWXRDA=;
	b=xxU1IEDWSmwA0yXA9uKFn2jVXmRcAGcIQBbWrnlG8SbcdiHXkhEVluWS53fPJcKIcKf5
	 W1C4tp93gLYBvI1213Y6F0EGS7S5e7xoFq43zmfMlNtHdZ+OntQit5ZMb5miwco9lgXZY
	 kYP5K737XEuYZY5Ifq2DkKL1n9vWM/5H3pfzEtH8OU/PESaFKT9MQ7qdtUUyJ+TuswJYm
	 p3jjd5w2/TWMbX4gZ9Kdgqoowrxr+uRkpsKNUbMaMF0MV/MWi14B6x8FxX+6fge1Uf4J/
	 oOu1NPDfpeiuOsI4CHtr6k4b/qVDkDPg8jYw/bQrtg4eNeXe1Ej9NaKPQG4xCGY7Taw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=LkHVEh9d;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79043606A31C
	for <mm-commits@vger.kernel.org>; Fri, 30 Oct 2026 03:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=LkHVEh9d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4C311F000C1;
	Fri, 30 Oct 2026 03:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793329346;
	bh=gNl8IoLvaaFN0xGd2/CfNTe4EYt1gPL1PIrapnWXRDA=;
	h=Date:To:From:Subject;
	b=LkHVEh9dkbyIKa3m3uWh75R/xSZyqKlpVIAjDDZvFFP/OGwt1Sj+Uk2k89J7ACWwu
	 OaNiTPhqfi/n43K3KGL9lqtYqO/Qti0PT5cYrnNVkjbDYVttjBOm85+HeAL7iMBcf9
	 7Y9NoWrP2x9pFS/FPJT8/S/KhP9WsZ+t5vVkOK2c=
Date: Thu, 29 Oct 2026 20:02:25 -0700
To: mm-commits@vger.kernel.org,zhangbo56@xiaomi.com,zhangbo0325@gmail.com,
	richardycc@google.com,minchan@kernel.org,hdanton@sina.com,bgeffon@google.com,
	baohua@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-move-mark_slot_accessed-under-existing-slot-lock-sections.patch added to mm-nonmm-unstable branch
Message-Id: <20261030030225.E4C311F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: zram: move mark_slot_accessed() under existing slot lock sections
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     zram-move-mark_slot_accessed-under-existing-slot-lock-sections.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-move-mark_slot_accessed-under-existing-slot-lock-sections.patch

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
Subject: zram: move mark_slot_accessed() under existing slot lock sections
Date: Sun, 25 Oct 2026 11:18:20 +0900

zram_bio_read() and zram_bio_write() take slot lock just to
mark_slot_accessed(), right after zram_read_page() and
zram_write_page() have already taken and released it.  Move
mark_slot_accessed() into those existing slot lock read/write
sections.

Link: https://lore.kernel.org/20261025021839.1542805-5-senozhatsky@chromium.org
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

 drivers/block/zram/zram_drv.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-move-mark_slot_accessed-under-existing-slot-lock-sections
+++ a/drivers/block/zram/zram_drv.c
@@ -2188,6 +2188,7 @@ static int zram_read_page(struct zram *z
 	int ret;
 
 	slot_lock(zram, index);
+	mark_slot_accessed(zram, index);
 	if (!test_slot_flag(zram, index, ZRAM_WB)) {
 		/* Slot should be locked through out the function call */
 		ret = read_from_zspool(zram, page, index);
@@ -2244,6 +2245,7 @@ static int write_same_filled_page(struct
 	slot_free(zram, index);
 	set_slot_flag(zram, index, ZRAM_SAME);
 	set_slot_handle(zram, index, fill);
+	mark_slot_accessed(zram, index);
 	slot_unlock(zram, index);
 
 	atomic64_inc(&zram->stats.same_pages);
@@ -2283,6 +2285,7 @@ static int write_incompressible_page(str
 	set_slot_flag(zram, index, ZRAM_HUGE);
 	set_slot_handle(zram, index, handle);
 	set_slot_size(zram, index, PAGE_SIZE);
+	mark_slot_accessed(zram, index);
 	slot_unlock(zram, index);
 
 	atomic64_add(PAGE_SIZE, &zram->stats.compr_data_size);
@@ -2348,6 +2351,7 @@ static int zram_write_page(struct zram *
 	slot_free(zram, index);
 	set_slot_handle(zram, index, handle);
 	set_slot_size(zram, index, comp_len);
+	mark_slot_accessed(zram, index);
 	slot_unlock(zram, index);
 
 	/* Update stats */
@@ -2756,10 +2760,6 @@ static void zram_bio_read(struct zram *z
 		}
 		flush_dcache_page(bv.bv_page);
 
-		slot_lock(zram, index);
-		mark_slot_accessed(zram, index);
-		slot_unlock(zram, index);
-
 		bio_advance_iter_single(bio, &iter, bv.bv_len);
 	} while (iter.bi_size);
 
@@ -2786,10 +2786,6 @@ static void zram_bio_write(struct zram *
 			break;
 		}
 
-		slot_lock(zram, index);
-		mark_slot_accessed(zram, index);
-		slot_unlock(zram, index);
-
 		bio_advance_iter_single(bio, &iter, bv.bv_len);
 	} while (iter.bi_size);
 
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

