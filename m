Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C60091EB31
	for <mm-commits@vger.kernel.org>; Wed, 13 Dec 2023 20:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kY376D4Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34405C433C8;
	Wed, 13 Dec 2023 20:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702499660;
	bh=Zyk7CRQdSddxC/HB6EH5C06qko8kPotSv4yVLFeRrPo=;
	h=Date:To:From:Subject:From;
	b=kY376D4ZOat79uGdRExW4lSflbBrNg3rlgYKPwbRzr9TMnpHrj6OSvAaTgvRbpWwt
	 YlpcQg1PFrfHTK4NFUiuKL+q5010C57+Wrgi3kL7HAtDNiP36d0gBSd5el/VW/TBuu
	 eaQCD31lxfO3GksgZ26LCAwf/x5IsrjQ6Pyzs1EE=
Date: Wed, 13 Dec 2023 12:34:19 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,vitaly.wool@konsulko.com,sjenning@redhat.com,nphamcs@gmail.com,hannes@cmpxchg.org,ddstreet@ieee.org,chriscli@google.com,zhouchengming@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-change-dstmem-size-to-one-page.patch added to mm-unstable branch
Message-Id: <20231213203420.34405C433C8@smtp.kernel.org>
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
Date: Wed, 13 Dec 2023 04:17:59 +0000

Change the dstmem size from 2 * PAGE_SIZE to only one page since we only
need at most one page when compress, and the "dlen" is also PAGE_SIZE in
acomp_request_set_params().  If the output size > PAGE_SIZE we don't wanna
store the output in zswap anyway.

So change it to one page, and delete the stale comment.

Link: https://lkml.kernel.org/r/20231213-zswap-dstmem-v1-2-896763369d04@bytedance.com
Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Cc: Chris Li <chriscli@google.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
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

mm-zswap-reuse-dstmem-when-decompress.patch
mm-zswap-change-dstmem-size-to-one-page.patch
mm-zswap-refactor-out-__zswap_load.patch
mm-zswap-cleanup-zswap_load.patch
mm-zswap-cleanup-zswap_reclaim_entry.patch

