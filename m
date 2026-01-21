Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95E3231D399
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 01:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768960232; cv=none; b=USxwA0PctPya7lx7Id0ruquzg30Yu6CqJbPEq7AVzaUfx4WIORRTIxGtg0QBQdv6iuXwRXt9lwNYTs98nSPgkYz7BgC7bEBXPflTMNnhXJ7KxlSWkxWVeC7D4vU9lr4N9UkcltmdCmkBHTXCPPw7dNDLigNcKzD+F7/SQPKkf+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768960232; c=relaxed/simple;
	bh=a/lm/ep/hFI4seqVBiec6lgXLexI0XA8Ft8BMquiCy8=;
	h=Date:To:From:Subject:Message-Id; b=QOc2zGxedZ5Ae83f4muGGrvhZE6Bjt5MlfJnF4PUEwp3SDL3UrLOFzAHzjrWOyCsh+s2tR0TltwriW7628/34Pg2+igHyd4Hb+uAMyebukWCwkPCJzNi6vd+tHKzSTJvlsEZ+qsJ2NoxNFLthfmXj/vFSkD0Ioy3ca/86D0E6wI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WjLRQwBl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WjLRQwBl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FF64C16AAE;
	Wed, 21 Jan 2026 01:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768960231;
	bh=a/lm/ep/hFI4seqVBiec6lgXLexI0XA8Ft8BMquiCy8=;
	h=Date:To:From:Subject:From;
	b=WjLRQwBlYomuk3WZmUWF0DKaosCpoLa/BEqSt+j4M/1cnacu3LX7z3rlGCLoY4xS3
	 ZT2l28j6K32OZu7i06T7GVMD7IcSGjcQ4hyHKA4i90xjrkhUuJFUuF0hqgSheQmICS
	 SAupLXdZldVzo8aC++ueeGkqc4S6iOgCf/5PqGp8=
Date: Tue, 20 Jan 2026 17:50:30 -0800
To: mm-commits@vger.kernel.org,stevensd@google.com,senozhatsky@chromium.org,richardycc@google.com,minchan@google.com,clm@meta.com,bgeffon@google.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] zram-fixup-read_block_state-fix.patch removed from -mm tree
Message-Id: <20260121015031.0FF64C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram-fixup-read_block_state-fix
has been removed from the -mm tree.  Its filename was
     zram-fixup-read_block_state-fix.patch

This patch was dropped because it was folded into zram-fixup-read_block_state.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: zram-fixup-read_block_state-fix
Date: Thu Jan 15 03:07:56 PM PST 2026

remove now-unused local `ts'

Cc: Brian Geffon <bgeffon@google.com>
Cc: Chris Mason <clm@meta.com>
Cc: David Stevens <stevensd@google.com>
Cc: Minchan Kim <minchan@google.com>
Cc: Richard Chang <richardycc@google.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/block/zram/zram_drv.c~zram-fixup-read_block_state-fix
+++ a/drivers/block/zram/zram_drv.c
@@ -1570,7 +1570,6 @@ static ssize_t read_block_state(struct f
 	ssize_t index, written = 0;
 	struct zram *zram = file->private_data;
 	unsigned long nr_pages = zram->disksize >> PAGE_SHIFT;
-	struct timespec64 ts;
 
 	kbuf = kvmalloc(count, GFP_KERNEL);
 	if (!kbuf)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-vmscanc-shrink_folio_list-save-a-tabstop.patch
zram-fixup-read_block_state.patch
zram-fixup-read_block_state-fix-2.patch
mm-block-fs-remove-laptop_mode-fix.patch
mm-fix-minor-spelling-mistakes-in-comments-fix.patch
memcg-rename-mem_cgroup_ino-to-mem_cgroup_id-fix-fix.patch
mm-add-wq_percpu-to-alloc_workqueue-users-fix.patch
mm-hugetlb-optimize-replace_free_hugepage_folios-v2-fix.patch
mm-memcontrol-eliminate-the-problem-of-dying-memory-cgroup-for-lru-folios-fix.patch
mm-update-shmem__file_-functions-to-use-vma_flags_t-fix.patch
mm-pagewalk-use-min-to-simplify-the-code-fix.patch
kallsyms-bpf-rename-__bpf_address_lookup-to-bpf_address_lookup-fix.patch
list-add-primitives-for-private-list-manipulations-fix.patch
init-mainc-check-if-rdinit-was-explicitly-set-before-printing-warning-fix.patch

