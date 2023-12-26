Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A405B1FA4
	for <mm-commits@vger.kernel.org>; Tue, 26 Dec 2023 19:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZVN4HrHF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC93DC433C7;
	Tue, 26 Dec 2023 19:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703620270;
	bh=OcQkStVUKTjEQGckljc3AiaWg5F0ihPysxGS6JaCdSA=;
	h=Date:To:From:Subject:From;
	b=ZVN4HrHFzvTnvWWrQC3CE6NFjDwLJeIqfibauRG5Fit/7C0C5LRp2zj9vTUqH4UIB
	 wX1SHqsX4v9zdxrDwiCNuE0+vId7l1gI7RsJ1LpEfYJB1EZvSHUFHyzZcRekzWV4Ew
	 PtOeVnefyTYjVE/4Y9Wbwwr5v9adkJbn50SIj21Y=
Date: Tue, 26 Dec 2023 11:51:09 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,vitaly.wool@konsulko.com,sjenning@redhat.com,nphamcs@gmail.com,hannes@cmpxchg.org,ddstreet@ieee.org,chrisl@kernel.org,zhouchengming@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-change-dstmem-size-to-one-page.patch added to mm-unstable branch
Message-Id: <20231226195109.DC93DC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zswap: change dstmem size to one page
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-change-dstmem-size-to-one-page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-change-dstmem-size-to-one-page.patch

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
From: Chengming Zhou <zhouchengming@bytedance.com>
Subject: mm/zswap: change dstmem size to one page
Date: Tue, 26 Dec 2023 15:54:08 +0000

Patch series "mm/zswap: dstmem reuse optimizations and cleanups", v4.

The problem this series tries to optimize is that zswap_load() and
zswap_writeback_entry() have to malloc a temporary memory to support
!zpool_can_sleep_mapped().  We can avoid it by reusing the percpu
crypto_acomp_ctx->dstmem, which is also used by zswap_store() and
protected by the same percpu crypto_acomp_ctx->mutex.


This patch (of 6):

Change the dstmem size from 2 * PAGE_SIZE to only one page since we only
need at most one page when compress, and the "dlen" is also PAGE_SIZE in
acomp_request_set_params().  If the output size > PAGE_SIZE we don't wanna
store the output in zswap anyway.

So change it to one page, and delete the stale comment.

There is no any history about the reason why we needed 2 pages, it has
been 2 * PAGE_SIZE since the time zswap was first merged.

According to Yosry and Nhat, one potential reason is that we used to store
a zswap header containing the swap entry in the compressed page for
writeback purposes, but we don't do that anymore.

This patch works good in kernel build testing even when the input data
doesn't compress at all (i.e.  dlen == PAGE_SIZE), which we can see from
the bpftrace tool:

bpftrace -e 'k:zpool_malloc {@[(uint32)arg1==4096]=count()}'
@[1]: 2
@[0]: 12011430

Link: https://lkml.kernel.org/r/20231213-zswap-dstmem-v4-0-f228b059dd89@bytedance.com
Link: https://lkml.kernel.org/r/20231213-zswap-dstmem-v4-1-f228b059dd89@bytedance.com
Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Reviewed-by: Yosry Ahmed <yosryahmed@google.com>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Chris Li <chrisl@kernel.org> (Google)
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/zswap.c~mm-zswap-change-dstmem-size-to-one-page
+++ a/mm/zswap.c
@@ -707,7 +707,7 @@ static int zswap_dstmem_prepare(unsigned
 	struct mutex *mutex;
 	u8 *dst;
 
-	dst = kmalloc_node(PAGE_SIZE * 2, GFP_KERNEL, cpu_to_node(cpu));
+	dst = kmalloc_node(PAGE_SIZE, GFP_KERNEL, cpu_to_node(cpu));
 	if (!dst)
 		return -ENOMEM;
 
@@ -1657,8 +1657,7 @@ bool zswap_store(struct folio *folio)
 	sg_init_table(&input, 1);
 	sg_set_page(&input, page, PAGE_SIZE, 0);
 
-	/* zswap_dstmem is of size (PAGE_SIZE * 2). Reflect same in sg_list */
-	sg_init_one(&output, dst, PAGE_SIZE * 2);
+	sg_init_one(&output, dst, PAGE_SIZE);
 	acomp_request_set_params(acomp_ctx->req, &input, &output, PAGE_SIZE, dlen);
 	/*
 	 * it maybe looks a little bit silly that we send an asynchronous request,
_

Patches currently in -mm which might be from zhouchengming@bytedance.com are

mm-zswap-change-dstmem-size-to-one-page.patch
mm-zswap-reuse-dstmem-when-decompress.patch
mm-zswap-refactor-out-__zswap_load.patch
mm-zswap-cleanup-zswap_load.patch
mm-zswap-cleanup-zswap_writeback_entry.patch
mm-zswap-change-per-cpu-mutex-and-buffer-to-per-acomp_ctx.patch

