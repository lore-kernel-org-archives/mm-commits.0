Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99A24320A09
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 01:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768960232; cv=none; b=NvenZD3ZXx9lidSohE9YJv/VlWv6idOt8jXii65MAyRx3dG3uI0oxbv5S9eYx6rRh5btt3wu2+XeAQ/UJ3/2929j1Yh+AEhFRUMSkvpgHV8EOPzl/PRtCKPXklyadEoV1qBJ/QDOSFYXzddKxVCJ5EzulVbX+2MAWHt23frcMq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768960232; c=relaxed/simple;
	bh=RgSSTBM4KklTk9tDVSjuWwrlYGxSMcimu3zyE9ZVmY0=;
	h=Date:To:From:Subject:Message-Id; b=ThSV5GF9GUI3+AZsZMoOcC/dPL30yeLfLofjuiKwNZTjjAOoDWlijxiUWTe6khlE9/SGCYMMuaFlClmogv2wdgpS0SwOp+XsKKx8ahg54jKCQpjZaGuI9TeGqNtE3L+K2r0U3jOrO/QMU1qBCFk6jzJQ1sd1SUmWMvtNU0N5j0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=V2NO6KlD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="V2NO6KlD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D757C19424;
	Wed, 21 Jan 2026 01:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768960232;
	bh=RgSSTBM4KklTk9tDVSjuWwrlYGxSMcimu3zyE9ZVmY0=;
	h=Date:To:From:Subject:From;
	b=V2NO6KlDgXWmCvMRAJvU9vnoUqJpTTA4+7jjUXgHw/CXIwwzbAHjzKU3W0AU9FCqV
	 HM4VigngshBS0nc5ygf6RLHdFQS3k/2f6vFW7OoGnSTSjvAqPtoc0knpKrpOWWF3DI
	 RIfvtK+0byhB8qimtFHJaHyctxmWMfIOr4wV6qF4=
Date: Tue, 20 Jan 2026 17:50:31 -0800
To: mm-commits@vger.kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] zram-fixup-read_block_state-fix-2.patch removed from -mm tree
Message-Id: <20260121015032.4D757C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram-fixup-read_block_state-fix-2
has been removed from the -mm tree.  Its filename was
     zram-fixup-read_block_state-fix-2.patch

This patch was dropped because it was folded into zram-fixup-read_block_state.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: zram-fixup-read_block_state-fix-2
Date: Thu Jan 15 10:30:48 PM PST 2026

fix build

drivers/block/zram/zram_drv.c: In function 'read_block_state':
drivers/block/zram/zram_drv.c:1582:41: error: format '%lu' expects argument of type 'long unsigned int', but argument 6 has type 'int' [-Werror=format=]
 1582 |                         "%12zd %12u.%06lu %c%c%c%c%c%c\n",
      |                                     ~~~~^
      |                                         |
      |                                         long unsigned int
      |                                     %06u
 1583 |                         index, zram->table[index].attr.ac_time, 0,
      |                                                                 ~
      |                                                                 |
      |                                                                 int

Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/block/zram/zram_drv.c~zram-fixup-read_block_state-fix-2
+++ a/drivers/block/zram/zram_drv.c
@@ -1589,7 +1589,7 @@ static ssize_t read_block_state(struct f
 			goto next;
 
 		copied = snprintf(kbuf + written, count,
-			"%12zd %12u.%06lu %c%c%c%c%c%c\n",
+			"%12zd %12u.%06d %c%c%c%c%c%c\n",
 			index, zram->table[index].attr.ac_time, 0,
 			test_slot_flag(zram, index, ZRAM_SAME) ? 's' : '.',
 			test_slot_flag(zram, index, ZRAM_WB) ? 'w' : '.',
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-vmscanc-shrink_folio_list-save-a-tabstop.patch
zram-fixup-read_block_state.patch
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

