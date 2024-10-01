Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F2231CDA2F
	for <mm-commits@vger.kernel.org>; Tue,  1 Oct 2024 22:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727820796; cv=none; b=ZuGScSjO9Twax1NC73fXCdPsEBGkdAL0byknRrGes4lZ88j68R+wcQ7hf/ffjYZ5nh6hRouYQbdYh9W8AqhqltuQZ71hkBGqT8lA/iI4uyezr/xYj+KdfXMlnoIRlhKWaxFRNaJvfDGZhzDvK4sfpM59ZgMAUPSNlIXXLKKpBro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727820796; c=relaxed/simple;
	bh=TDnw5XkLoEI9mc7HPqP4ucfaWCOuklbMqrAlQ7cyR1E=;
	h=Date:To:From:Subject:Message-Id; b=pjZ9HIiEHAHcyWE+jl2YBXHNNAGx37NCjwJdqqk+Gguo0Xarp4EnR2UbVyjgcBd78GC65eZQVLmDvCfxOtZhQ6rDY4ICK5/mhmqnvdqI2ULC15R0ZFJ3T4gZF4vB6XeQ8IEL8Xm/aOVouOh72908FjybG9iBdVSX0A+nQdYquOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=z1QKG3ao; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="z1QKG3ao"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6310C4CEC6;
	Tue,  1 Oct 2024 22:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727820795;
	bh=TDnw5XkLoEI9mc7HPqP4ucfaWCOuklbMqrAlQ7cyR1E=;
	h=Date:To:From:Subject:From;
	b=z1QKG3aohnmD6fYMeyGR2ldClNJXHCwdYMcvSyuZpVdDRRUSTsgRoSX7xsadPDBgG
	 bQMYtahghct4lqvH+d4XSjmthsw2QBfk/DQNHIhRbcNZuWaZSGFbu4nBMJQOMKlUqA
	 xAxj1THoN9ongq0IyOriIPgTGxRR3LHPH3kZqJe0=
Date: Tue, 01 Oct 2024 15:13:15 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@intel.com,willy@infradead.org,wajdi.k.feghali@intel.com,usamaarif642@gmail.com,shakeel.butt@linux.dev,ryan.roberts@arm.com,nphamcs@gmail.com,nanhai.zou@intel.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,kanchana.p.sridhar@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-modify-zswap_compress-to-accept-a-page-instead-of-a-folio.patch added to mm-unstable branch
Message-Id: <20241001221315.C6310C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: zswap: modify zswap_compress() to accept a page instead of a folio.
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-modify-zswap_compress-to-accept-a-page-instead-of-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-modify-zswap_compress-to-accept-a-page-instead-of-a-folio.patch

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
From: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Subject: mm: zswap: modify zswap_compress() to accept a page instead of a folio.
Date: Mon, 30 Sep 2024 22:32:17 -0700

For zswap_store() to be able to store a large folio by compressing it one
page at a time, zswap_compress() needs to accept a page as input.  This
will allow us to iterate through each page in the folio in zswap_store(),
compress it and store it in the zpool.

Link: https://lkml.kernel.org/r/20241001053222.6944-3-kanchana.p.sridhar@intel.com
Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: Chengming Zhou <chengming.zhou@linux.dev>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Yosry Ahmed <yosryahmed@google.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Wajdi Feghali <wajdi.k.feghali@intel.com>
Cc: "Zou, Nanhai" <nanhai.zou@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/zswap.c~mm-zswap-modify-zswap_compress-to-accept-a-page-instead-of-a-folio
+++ a/mm/zswap.c
@@ -875,7 +875,7 @@ static int zswap_cpu_comp_dead(unsigned
 	return 0;
 }
 
-static bool zswap_compress(struct folio *folio, struct zswap_entry *entry)
+static bool zswap_compress(struct page *page, struct zswap_entry *entry)
 {
 	struct crypto_acomp_ctx *acomp_ctx;
 	struct scatterlist input, output;
@@ -893,7 +893,7 @@ static bool zswap_compress(struct folio
 
 	dst = acomp_ctx->buffer;
 	sg_init_table(&input, 1);
-	sg_set_folio(&input, folio, PAGE_SIZE, 0);
+	sg_set_page(&input, page, PAGE_SIZE, 0);
 
 	/*
 	 * We need PAGE_SIZE * 2 here since there maybe over-compression case,
@@ -1456,7 +1456,7 @@ bool zswap_store(struct folio *folio)
 		mem_cgroup_put(memcg);
 	}
 
-	if (!zswap_compress(folio, entry))
+	if (!zswap_compress(&folio->page, entry))
 		goto put_pool;
 
 	entry->swpentry = swp;
_

Patches currently in -mm which might be from kanchana.p.sridhar@intel.com are

mm-define-obj_cgroup_get-if-config_memcg-is-not-defined.patch
mm-zswap-modify-zswap_compress-to-accept-a-page-instead-of-a-folio.patch
mm-zswap-rename-zswap_pool_get-to-zswap_pool_tryget.patch
mm-change-count_objcg_event-to-count_objcg_events-for-batch-event-updates.patch
mm-zswap-modify-zswap_stored_pages-to-be-atomic_long_t.patch
mm-zswap-support-large-folios-in-zswap_store.patch
mm-swap-count-successful-large-folio-zswap-stores-in-hugepage-zswpout-stats.patch

