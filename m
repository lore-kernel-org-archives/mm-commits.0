Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D632EFC0E
	for <mm-commits@vger.kernel.org>; Tue,  5 Mar 2024 01:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709600533; cv=none; b=CyWSFtM9MVqvaGslcf0+DIb2ZH5COOqdmLpl0tTmgEmmr2EarYIW0+spfeK5VScg/tJdBQWoUSFaLS46mfen55I4fEbPa+g5nkt8r/ZpnDGnhCwsrA8ivw8h0QgObwStf9tPbbGbeO2hmDb293dbbyPIn9mmyVtF3YtrlPkg2OM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709600533; c=relaxed/simple;
	bh=zawRuDVW4wmetirg3moh8zQPlkFbTALIkhYFHnIS9hU=;
	h=Date:To:From:Subject:Message-Id; b=rfeszQ3wHzY4U0+NR7HpprPYZ3ERZ2fOl1QTDBC16vbSKEGz9CLx6q5Pjy8KvK0o+uN5LtXO8gnKKfdGptCsvbYN45T1RgUOJMaCR7lDQiQk6KjxZzHVsGY1AlOqzmQrSFWk94z9iDCnsirgjgtUCjFGrv1kYXCkSshxzofROUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FR5Asyrx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FR5Asyrx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A73E8C433F1;
	Tue,  5 Mar 2024 01:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709600533;
	bh=zawRuDVW4wmetirg3moh8zQPlkFbTALIkhYFHnIS9hU=;
	h=Date:To:From:Subject:From;
	b=FR5AsyrxBSIGbrAYHxLEPjNIZBXGPVgP8Hygv6/1A8q95uKS4sVNO1zJAEqPs4omd
	 SkXKbuftcPCYd254WUVaRecc+XcS8UZtak87zoGJmt0zU2PScWf4VL+qfTdCVH/Lid
	 vL/2Jh/wR+56IR/Fx3//SSf8ywLMPeh7TiNlqZZ4=
Date: Mon, 04 Mar 2024 17:02:13 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,senozhatsky@chromium.org,nphamcs@gmail.com,minchan@kernel.org,hannes@cmpxchg.org,chenhuacai@kernel.org,chengming.zhou@linux.dev,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-zcomp-remove-zcomp_set_max_streams-declaration.patch removed from -mm tree
Message-Id: <20240305010213.A73E8C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: zcomp: remove zcomp_set_max_streams() declaration
has been removed from the -mm tree.  Its filename was
     zram-zcomp-remove-zcomp_set_max_streams-declaration.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: zram: zcomp: remove zcomp_set_max_streams() declaration
Date: Fri, 23 Feb 2024 11:55:44 +0800

The zcomp_set_max_streams() is removed from commit 43209ea2d17a
("zram: remove max_comp_streams internals"), remove the declaration.

Link: https://lkml.kernel.org/r/20240223035548.2591882-2-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zcomp.h |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/block/zram/zcomp.h~zram-zcomp-remove-zcomp_set_max_streams-declaration
+++ a/drivers/block/zram/zcomp.h
@@ -39,5 +39,4 @@ int zcomp_compress(struct zcomp_strm *zs
 int zcomp_decompress(struct zcomp_strm *zstrm,
 		const void *src, unsigned int src_len, void *dst);
 
-bool zcomp_set_max_streams(struct zcomp *comp, int num_strm);
 #endif /* _ZCOMP_H_ */
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-memory-fix-shift-out-of-bounds-in-fault_around_bytes_set.patch

