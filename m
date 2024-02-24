Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61A9D8F6E
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 01:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708737434; cv=none; b=NZFxvOghs82NqLzRoznnRT39WIjic1LfRXkRI9j6wNOcCoE2M64QhdAGu9K09vlA19PAFfVc8D/T223m7mOE+Dr1z1NCRhXl2I/4vVmLDlTb5OvFGBhlDqrNJ/o9WOCob+9KXhVKHlURx+x3ZJfowhFGdMqE0am9UPJCeyl8CNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708737434; c=relaxed/simple;
	bh=vuw/rK/LOSahyyiykaZwh6aqMCtyf7/UhX9MFVL2U9s=;
	h=Date:To:From:Subject:Message-Id; b=uwq46ZzOaZnEyHAJAjMmgb62z1hHZVfWvH8DzDJko2mgLt4XFTAf7leAbDLGzbgir83sQhw+jiyWLJUm9yiaijszd5t2Nx9iMVxDys0J3Qnc7LbNcNSEOwZemOhEUHf6+tDaEk9FxA1Vu26qEq4vYffqhderP82/0u95xoaWUks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tRnBkbtY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tRnBkbtY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E118CC433C7;
	Sat, 24 Feb 2024 01:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708737434;
	bh=vuw/rK/LOSahyyiykaZwh6aqMCtyf7/UhX9MFVL2U9s=;
	h=Date:To:From:Subject:From;
	b=tRnBkbtYpWsRz3TOikTy1AYxM3JjeYyMT/w8/rVIlRBP6l3cLIi9yEKMlv1ugbr50
	 k7VckDXhDTokxY34baMsovZAB6NB2o4W70utpkyIzUQ+NMFATziR1lDW6ZqlPunEZN
	 DL7JUQ3TKxGyvZ04n/wFg4pV04iNLRt59r1KaBY8=
Date: Fri, 23 Feb 2024 17:17:13 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,senozhatsky@chromium.org,nphamcs@gmail.com,minchan@kernel.org,hannes@cmpxchg.org,chenhuacai@kernel.org,chengming.zhou@linux.dev,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-zcomp-remove-zcomp_set_max_streams-declaration.patch added to mm-unstable branch
Message-Id: <20240224011713.E118CC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: zcomp: remove zcomp_set_max_streams() declaration
has been added to the -mm mm-unstable branch.  Its filename is
     zram-zcomp-remove-zcomp_set_max_streams-declaration.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-zcomp-remove-zcomp_set_max_streams-declaration.patch

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

mm-compaction-early-termination-in-compact_nodes.patch
zram-zcomp-remove-zcomp_set_max_streams-declaration.patch

