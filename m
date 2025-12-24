Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A0C92989B5
	for <mm-commits@vger.kernel.org>; Wed, 24 Dec 2025 02:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766541746; cv=none; b=E3WrIuKBj02xWVoBC5W+DgRhyTrcf4jzxZ+eyoMxshVqEo0qcP/YAhS7yy/90zfC0G+hyRbPjPCFdjT1w61ReziYrCb6TzPE0DIfYTnEfRf9PXVic+FcYPfBZN/vpHDLCryC+ZYQ0+07+8xSgBHVj5pM7y1rFLXclBL1uhSWxro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766541746; c=relaxed/simple;
	bh=QjjzUcAJzuNML2huh+bcBZVNql9p8jN9mYoBFJXC0WA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S8ORiAGWMJWIjAKuLnpOTjVG54jSVMcUrY6EkZZRlWH+uclmMQuJ+aRg1KZQswvLlkbnMZG+J6K04BbbNcfYHd8KyJiP3qobY1tIHYYcQgj955J2SmqwPFNWd1GG4JDJKqpp6TMkp9OiVWAsDEPNpED7H9li2TnDo2J6xWhfbD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=POTdDgfN; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="POTdDgfN"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b79af62d36bso972955866b.3
        for <mm-commits@vger.kernel.org>; Tue, 23 Dec 2025 18:02:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766541742; x=1767146542; darn=vger.kernel.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yRw/5yBADLncifGz2dCY5jNqQx+Umqvd5/Bn4mWyFUo=;
        b=POTdDgfN4pWC5YvS6FuNalzVgbMOF20r+YWfKHPXZST2aY9L3AqU6Bm7ZqFnBhV7UZ
         OnUirCDvU4JxlFdBQzXYgpEIgPnec551MIiLRCR7lLx85D9MYVoLeXaiiV3mVMZU58/g
         Qx2eEqvLisjNF3RTxr5EDPMgBkUKQ3TThbAT9Ok3Tvxc0kk2MIm5os+NxFRWb8THolIo
         kTn1akxkAlywP++ZUmCSVWBQ2WBI/f/SG1w//jH667vH/xu+ANhbaKTv/swz4Xi57+oS
         nKpZIlp/vSLsqTkYLo6TxzNoBYSq+USNDNXq9uXf/FcvgISXCEmORhR4MdZ3d05AqgX9
         P+SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766541742; x=1767146542;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yRw/5yBADLncifGz2dCY5jNqQx+Umqvd5/Bn4mWyFUo=;
        b=XHegx9oBsJ+UPcP8J887IGdT/rlmbo/pl5cyJGMd7dC31D1Et4MG3NhMidYdZ9zP2d
         gHtd2JQJiLtjvCs29NN7jIXIz7yXSJK1pNSKZXMwT+ZBOTOYegW78V/8H9w4nJMAuAJH
         eKkQSdkEj441yR1I+e/4Aub+hh5BbFS5/CxBdyJ1P4kT5CzGnvX8CXg5fKGZTijN0f1X
         PkQUuvIQJAPftY5P73u7sXMC3croEK0JEVWJyTXxZFs6xhxGeaCEUbolK8oKw3nPXLE2
         a1EjtQyZrJ6EKwVJ95me439OKVDpTehYIxJWf7ceLm87Zva38a9//U9MgSemIzqXoPY4
         BgGQ==
X-Gm-Message-State: AOJu0YzyI87XGJQxsl/ZX7ONs97punwUKlgc5LpqmgTjqUGcFFfMquGp
	Ef7+R6a7/nxed4EwbncoFZNfU+ZxbRAvwPpSUL+G4byi8UXBcE5nNBP6
X-Gm-Gg: AY/fxX6D+O6TMWEm49TpDcuk6dwz8TNizg3I9i9D71cSmu1orpNLJNMSVgrjHMpCPSM
	5Rx9JJti+gEsHSQSupbkAM30hkqgwWdcBFUobtDUslGCyVR6duRNPZMk3xf2J3k43TW8SqrgsSl
	k5K9L7ZCm8i0rBdAZWtdQPkbhvMUSnK3HRi4GJ/Cmy0qXpFxC7oPC5hcjuvJtlPIm8SIqniy0LL
	4u5Y+D8DsvedGnZDbu44Df1p3YogHGWpXfA9KO4nnHliB1a97IScf/A8M7g6VMpXeAd//DEtplX
	I29X1ZAmIaqg/f1RQ4mE5Sg6GOx0RuhDSNHcmxKBg96pJ9lXfBGctjWSIxpBl/rhMH/vcuV9ubH
	PlblJeljiqW5nyHxKAVi6YUZ46Y86yaFdhUnRbBo8HY5R+eOKb7GgSjU7FhO1Z3GnDAVuRxRJ5V
	Qymzc7xTIC5w==
X-Google-Smtp-Source: AGHT+IEA4dzXZFlPVn86MrZqNFfu6OffboRNVhghSfjfIZ2XRKQHHjpP2bp2wVG9/x0AQujsI6h9jw==
X-Received: by 2002:a17:907:9691:b0:b7f:c6c6:d27b with SMTP id a640c23a62f3a-b803719efa5mr1846734266b.54.1766541742156;
        Tue, 23 Dec 2025 18:02:22 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-64de4798077sm706911a12.7.2025.12.23.18.02.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 23 Dec 2025 18:02:20 -0800 (PST)
Date: Wed, 24 Dec 2025 02:02:19 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, ziy@nvidia.com, ryan.roberts@arm.com,
	npache@redhat.com, lorenzo.stoakes@oracle.com,
	liam.howlett@oracle.com, lance.yang@linux.dev, dev.jain@arm.com,
	david@kernel.org, baolin.wang@linux.alibaba.com, baohua@kernel.org,
	richard.weiyang@gmail.com
Subject: Re: [failures]
 mm-huge_memory-consolidate-order-related-checks-into-folio_check_splittable.patch
 removed from -mm tree
Message-ID: <20251224020219.lutpqt64qqunutgu@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251223182916.E9BF5C113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251223182916.E9BF5C113D0@smtp.kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)

On Tue, Dec 23, 2025 at 10:29:16AM -0800, Andrew Morton wrote:
>
>The quilt patch titled
>     Subject: mm/huge_memory: consolidate order-related checks into folio_check_splittable()
>has been removed from the -mm tree.  Its filename was
>     mm-huge_memory-consolidate-order-related-checks-into-folio_check_splittable.patch
>
>This patch was dropped because it had testing failures
>

Hi, Andrew

Do you have specific error message for this?

I have built the kernel and split_huge_page_test looks good.

>------------------------------------------------------
>From: Wei Yang <richard.weiyang@gmail.com>
>Subject: mm/huge_memory: consolidate order-related checks into folio_check_splittable()
>Date: Tue, 23 Dec 2025 12:25:39 +0000
>
>The primary goal of the folio_check_splittable() function is to validate
>whether a folio is suitable for splitting and to bail out early if it is
>not.
>
>Currently, some order-related checks are scattered throughout the calling
>code rather than being centralized in folio_check_splittable().
>
>This commit moves all remaining order-related validation logic into
>folio_check_splittable().  This consolidation ensures that the function
>serves its intended purpose as a single point of failure and improves the
>clarity and maintainability of the surrounding code.
>
>Link: https://lkml.kernel.org/r/20251223122539.10726-1-richard.weiyang@gmail.com
>Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>Cc: Zi Yan <ziy@nvidia.com>
>Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>Cc: Barry Song <baohua@kernel.org>
>Cc: David Hildenbrand (Red Hat) <david@kernel.org>
>Cc: Dev Jain <dev.jain@arm.com>
>Cc: Lance Yang <lance.yang@linux.dev>
>Cc: Liam Howlett <liam.howlett@oracle.com>
>Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>Cc: Nico Pache <npache@redhat.com>
>Cc: Ryan Roberts <ryan.roberts@arm.com>
>Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>---
>
> mm/huge_memory.c |   63 +++++++++++++++++++++------------------------
> 1 file changed, 30 insertions(+), 33 deletions(-)
>
>--- a/mm/huge_memory.c~mm-huge_memory-consolidate-order-related-checks-into-folio_check_splittable
>+++ a/mm/huge_memory.c
>@@ -3700,6 +3700,10 @@ int folio_check_splittable(struct folio
> 			   enum split_type split_type)
> {
> 	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
>+
>+	if (new_order >= folio_order(folio))
>+		return -EINVAL;
>+
> 	/*
> 	 * Folios that just got truncated cannot get split. Signal to the
> 	 * caller that there was a race.
>@@ -3714,28 +3718,33 @@ int folio_check_splittable(struct folio
> 		/* order-1 is not supported for anonymous THP. */
> 		if (new_order == 1)
> 			return -EINVAL;
>-	} else if (split_type == SPLIT_TYPE_NON_UNIFORM || new_order) {
>-		if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
>-		    !mapping_large_folio_support(folio->mapping)) {
>-			/*
>-			 * We can always split a folio down to a single page
>-			 * (new_order == 0) uniformly.
>-			 *
>-			 * For any other scenario
>-			 *   a) uniform split targeting a large folio
>-			 *      (new_order > 0)
>-			 *   b) any non-uniform split
>-			 * we must confirm that the file system supports large
>-			 * folios.
>-			 *
>-			 * Note that we might still have THPs in such
>-			 * mappings, which is created from khugepaged when
>-			 * CONFIG_READ_ONLY_THP_FOR_FS is enabled. But in that
>-			 * case, the mapping does not actually support large
>-			 * folios properly.
>-			 */
>-			return -EINVAL;
>+	} else {
>+		if (split_type == SPLIT_TYPE_NON_UNIFORM || new_order) {
>+			if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
>+			    !mapping_large_folio_support(folio->mapping)) {
>+				/*
>+				 * We can always split a folio down to a
>+				 * single page (new_order == 0) uniformly.
>+				 *
>+				 * For any other scenario
>+				 *   a) uniform split targeting a large folio
>+				 *      (new_order > 0)
>+				 *   b) any non-uniform split
>+				 * we must confirm that the file system
>+				 * supports large folios.
>+				 *
>+				 * Note that we might still have THPs in such
>+				 * mappings, which is created from khugepaged
>+				 * when CONFIG_READ_ONLY_THP_FOR_FS is
>+				 * enabled. But in that case, the mapping does
>+				 * not actually support large folios properly.
>+				 */
>+				return -EINVAL;
>+			}
> 		}
>+
>+		if (new_order < mapping_min_folio_order(folio->mapping))
>+			return -EINVAL;
> 	}
> 
> 	/*
>@@ -3956,11 +3965,6 @@ static int __folio_split(struct folio *f
> 		goto out;
> 	}
> 
>-	if (new_order >= old_order) {
>-		ret = -EINVAL;
>-		goto out;
>-	}
>-
> 	ret = folio_check_splittable(folio, new_order, split_type);
> 	if (ret) {
> 		VM_WARN_ONCE(ret == -EINVAL, "Tried to split an unsplittable folio");
>@@ -3984,16 +3988,9 @@ static int __folio_split(struct folio *f
> 		anon_vma_lock_write(anon_vma);
> 		mapping = NULL;
> 	} else {
>-		unsigned int min_order;
> 		gfp_t gfp;
> 
> 		mapping = folio->mapping;
>-		min_order = mapping_min_folio_order(folio->mapping);
>-		if (new_order < min_order) {
>-			ret = -EINVAL;
>-			goto out;
>-		}
>-
> 		gfp = current_gfp_context(mapping_gfp_mask(mapping) &
> 							GFP_RECLAIM_MASK);
> 
>_
>
>Patches currently in -mm which might be from richard.weiyang@gmail.com are
>

-- 
Wei Yang
Help you, Help me
