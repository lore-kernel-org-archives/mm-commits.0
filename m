Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35D6E3101C0
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334285; cv=none; b=rAajitcgUeq00KTgpUFmEshyNvObOjKJ6zKClGkRJ8xtAD7iYRQBLsoesxZOCMOLSn1/oSphKjA3Se/D9Nu9kz9md157zTtA05yCUTKpF60WCuPDkNSv1feao5fcAZxcpUd8nfILP9mya0F0kmLfhBWgkonfV2EXf6yAdP5I9lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334285; c=relaxed/simple;
	bh=h69yzkVhPUUaaLTNNjjuHu5jBTU3AGEnApwOkywD5eE=;
	h=Date:To:From:Subject:Message-Id; b=IwSjMarEM2nP964A0NGUwfcmV7RoyU1gzoZt2j0jgt5BJbVuaLkfHi53IP7TXUhjmaYTklSSVsj9iIIFa4NP7uyd804Tn7/1lCZ8rAWrtojrMs+yiAOjou1USvOK27PE3XDWWMrJs+V34VmFvkJpmu5T9M0uEcaeO8jztP2KZ14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QS8rUwrZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QS8rUwrZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CBEA1F0089C;
	Wed,  7 Oct 2026 00:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334284;
	bh=LbI3CGLTfK0l89bwra3b9xXtE2jNChk6H/psk+JrhDE=;
	h=Date:To:From:Subject;
	b=QS8rUwrZF4Ck5jfdXxZ2ylpNg9qb7quA/onM57puqDRtNYLYrzhwHPAcG299odZTW
	 uak4LkHTjOZXGEbcKqQX1IGnM1Nj9OOxPzpSlOz9cJ7SSpX1W+BSWDD8YNLoqDjKmf
	 mAML4BcrHv6OtkVB22ZeAoPBfmyI+/vza8OHghi8=
Date: Tue, 06 Oct 2026 17:51:23 -0700
To: mm-commits@vger.kernel.org,zhaozhengzhuo@uniontech.com,sj@kernel.org,shuah@kernel.org,liyouhong@kylinos.cn,lienze@kylinos.cn,jaeyeon.lee.dev@gmail.com,harimishal1@gmail.com,gregkh@linuxfoundation.org,zenghui.yu@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-remove-declaration-of-__damon_commit_ctx.patch removed from -mm tree
Message-Id: <20261007005124.0CBEA1F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: remove declaration of __damon_commit_ctx()
has been removed from the -mm tree.  Its filename was
     mm-damon-core-remove-declaration-of-__damon_commit_ctx.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
Subject: mm/damon/core: remove declaration of __damon_commit_ctx()
Date: Mon, 31 Aug 2026 07:26:03 -0700

Patch series "mm/damon: misc cleanups".

Cleanup the code, tests and samples for clarifications and readability.

The patches are individually sent by the authors.  I'm reposting those as
one series for convenience of handling.  For this reason, changelog is on
each patch's commentary section.


This patch (of 7):

__damon_commit_ctx() was added by commit b1471afe4d10 ("mm/damon/core: do
parameter testing commit on damon_start()") but is actually not needed. 
Remove it.

Link: https://lore.kernel.org/20260831142611.77572-1-sj@kernel.org
Link: https://lore.kernel.org/20260831142611.77572-2-sj@kernel.org
Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Enze Li <lienze@kylinos.cn>
Cc: Hari Mishal <harimishal1@gmail.com>
Cc: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>
Cc: Li Youhong <liyouhong@kylinos.cn>
Cc: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
---

 mm/damon/core.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-remove-declaration-of-__damon_commit_ctx
+++ a/mm/damon/core.c
@@ -1935,8 +1935,6 @@ static int __damon_start(struct damon_ct
 	return err;
 }
 
-static int __damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src);
-
 /**
  * damon_start() - Starts the monitorings for a given group of contexts.
  * @ctxs:	an array of the pointers for contexts to start monitoring
_

Patches currently in -mm which might be from zenghui.yu@linux.dev are

selftests-mm-remove-unreachable-returns-after-ksft-exit-helpers.patch
docs-mm-damon-design-fix-broken-ref-usage-and-a-typo.patch
selftests-mm-fix-size-truncation-in-pagemap_ioctl-test.patch
selftests-mm-mark-file-local-symbols-of-pagemap_ioctlc-static.patch
selftests-mm-init-page-sizes-early-in-pagemap_ioctl-test.patch
selftests-damon-stop-kdamond-on-error-exits-of-no-op-commit-test.patch
selftests-damon-ignore-test-generated-damon_dump_output.patch
mm-damon-api-remove-unused-nr_damos_-enumerators.patch

