Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65FE7285CB6
	for <mm-commits@vger.kernel.org>; Wed, 24 Dec 2025 05:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766553678; cv=none; b=AatxxNiz82BpeTL4QfU5YKD4Fu0dD7+lvOJgbEak14aW265IorhmGFdInTkKGtE0uJ+Y6L3FMdgrmwIO7ZkeQX8Jp3Oy6AELPLNI8kiEST97QciTiDxwR1/r6HZ0sM8b/655G+hE0ws3qkzswO8Cg+Ncc3/Mf76XKOov1btQKTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766553678; c=relaxed/simple;
	bh=i6/chCM/9qkYx5fV4HNUpxEzPz6CaR35Xx6drhECrB8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uqvMozMc9f/S39R1yGHL7E4+roCq4yb1kgyM1mNgfLM4jmVQV89/SpLIwR5Z6CZD1tEV4Oy+yIRZUJ5YalGUD0Lk9p5NGKBdLWb56yrwHSHuRrx0yrNmxgyp1QGQ3+0SH/nzRd4m97ccrmzzXAVQfu25FCTp7lsGKJcp84Dqp1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fHUGHGSU; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fHUGHGSU"
Message-ID: <ac94c922-0caa-4d17-963e-f83f3df58508@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766553671;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=utZ+ORSiL0DK9/HaFaLYbinicIEN1NtwYIjZWYIRP6A=;
	b=fHUGHGSUOMQTV336jSEzMGZxJVJORxd1puhufpUEOK2S20YbQ6rwujGofD451gwUMymQFR
	pzkJpxqCWj/W3nhi2cD0pc18x9PdWVa1aYUQgbMhklmw6n+f5g6hj2bNw6kqiIHh9krx4q
	+or/Pghu9CaXqrWX/u3Z6Y3IYHsvV7A=
Date: Wed, 24 Dec 2025 13:21:01 +0800
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [failures]
 mm-huge_memory-consolidate-order-related-checks-into-folio_check_splittable.patch
 removed from -mm tree
To: Wei Yang <richard.weiyang@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, ziy@nvidia.com, ryan.roberts@arm.com,
 npache@redhat.com, lorenzo.stoakes@oracle.com, liam.howlett@oracle.com,
 dev.jain@arm.com, david@kernel.org, baolin.wang@linux.alibaba.com,
 baohua@kernel.org
References: <20251223182916.E9BF5C113D0@smtp.kernel.org>
 <20251224020219.lutpqt64qqunutgu@master>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20251224020219.lutpqt64qqunutgu@master>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT



On 2025/12/24 10:02, Wei Yang wrote:
> On Tue, Dec 23, 2025 at 10:29:16AM -0800, Andrew Morton wrote:
>>
>> The quilt patch titled
>>      Subject: mm/huge_memory: consolidate order-related checks into folio_check_splittable()
>> has been removed from the -mm tree.  Its filename was
>>      mm-huge_memory-consolidate-order-related-checks-into-folio_check_splittable.patch
>>
>> This patch was dropped because it had testing failures
>>
> 
> Hi, Andrew
> 
> Do you have specific error message for this?
> 
> I have built the kernel and split_huge_page_test looks good.

Emm, IIUC, we put the mapping_min_folio_order() check in the wrong place ...

See below please.

>> ------------------------------------------------------
>> From: Wei Yang <richard.weiyang@gmail.com>
>> Subject: mm/huge_memory: consolidate order-related checks into folio_check_splittable()
>> Date: Tue, 23 Dec 2025 12:25:39 +0000
>>
>> The primary goal of the folio_check_splittable() function is to validate
>> whether a folio is suitable for splitting and to bail out early if it is
>> not.
>>
>> Currently, some order-related checks are scattered throughout the calling
>> code rather than being centralized in folio_check_splittable().
>>
>> This commit moves all remaining order-related validation logic into
>> folio_check_splittable().  This consolidation ensures that the function
>> serves its intended purpose as a single point of failure and improves the
>> clarity and maintainability of the surrounding code.
>>
>> Link: https://lkml.kernel.org/r/20251223122539.10726-1-richard.weiyang@gmail.com
>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>> Cc: Zi Yan <ziy@nvidia.com>
>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>> Cc: Barry Song <baohua@kernel.org>
>> Cc: David Hildenbrand (Red Hat) <david@kernel.org>
>> Cc: Dev Jain <dev.jain@arm.com>
>> Cc: Lance Yang <lance.yang@linux.dev>
>> Cc: Liam Howlett <liam.howlett@oracle.com>
>> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>> Cc: Nico Pache <npache@redhat.com>
>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>> ---
>>
>> mm/huge_memory.c |   63 +++++++++++++++++++++------------------------
>> 1 file changed, 30 insertions(+), 33 deletions(-)
>>
>> --- a/mm/huge_memory.c~mm-huge_memory-consolidate-order-related-checks-into-folio_check_splittable
>> +++ a/mm/huge_memory.c
>> @@ -3700,6 +3700,10 @@ int folio_check_splittable(struct folio
>> 			   enum split_type split_type)
>> {
>> 	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
>> +
>> +	if (new_order >= folio_order(folio))
>> +		return -EINVAL;
>> +
>> 	/*
>> 	 * Folios that just got truncated cannot get split. Signal to the
>> 	 * caller that there was a race.
>> @@ -3714,28 +3718,33 @@ int folio_check_splittable(struct folio
>> 		/* order-1 is not supported for anonymous THP. */
>> 		if (new_order == 1)
>> 			return -EINVAL;
>> -	} else if (split_type == SPLIT_TYPE_NON_UNIFORM || new_order) {
>> -		if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
>> -		    !mapping_large_folio_support(folio->mapping)) {
>> -			/*
>> -			 * We can always split a folio down to a single page
>> -			 * (new_order == 0) uniformly.
>> -			 *
>> -			 * For any other scenario
>> -			 *   a) uniform split targeting a large folio
>> -			 *      (new_order > 0)
>> -			 *   b) any non-uniform split
>> -			 * we must confirm that the file system supports large
>> -			 * folios.
>> -			 *
>> -			 * Note that we might still have THPs in such
>> -			 * mappings, which is created from khugepaged when
>> -			 * CONFIG_READ_ONLY_THP_FOR_FS is enabled. But in that
>> -			 * case, the mapping does not actually support large
>> -			 * folios properly.
>> -			 */
>> -			return -EINVAL;
>> +	} else {
>> +		if (split_type == SPLIT_TYPE_NON_UNIFORM || new_order) {
>> +			if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
>> +			    !mapping_large_folio_support(folio->mapping)) {
>> +				/*
>> +				 * We can always split a folio down to a
>> +				 * single page (new_order == 0) uniformly.
>> +				 *
>> +				 * For any other scenario
>> +				 *   a) uniform split targeting a large folio
>> +				 *      (new_order > 0)
>> +				 *   b) any non-uniform split
>> +				 * we must confirm that the file system
>> +				 * supports large folios.
>> +				 *
>> +				 * Note that we might still have THPs in such
>> +				 * mappings, which is created from khugepaged
>> +				 * when CONFIG_READ_ONLY_THP_FOR_FS is
>> +				 * enabled. But in that case, the mapping does
>> +				 * not actually support large folios properly.
>> +				 */
>> +				return -EINVAL;
>> +			}
>> 		}
>> +
>> +		if (new_order < mapping_min_folio_order(folio->mapping))
>> +			return -EINVAL;

The comment clearly says "we can always split a folio down to a single page
(new_order == 0) uniformly", but the wrong placement made this
mapping_min_folio_order() check apply to all cases, including splits that
should be allowed ...

Specifically, this check should only happen in two cases:
1) Non-uniform splits (SPLIT_TYPE_NON_UNIFORM)
2) OR when new_order > 0

But we put it outside the conditional, so even uniform splits to order-0 got
blocked by this check，right?

The report[1] shows up when madvise(MADV_PAGEOUT) calls split_folio(), which
uses new_order=0 and split_type=UNIFORM. If a filesystem has min order > 0,
it incorrectly returns -EINVAL and triggers the warning in __folio_split().

So, let's just move this check inside the conditional, right next to the
mapping_large_folio_support() check :)

---8<---
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 01e5139a5e56..068a17317e26 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3741,10 +3741,10 @@ int folio_check_splittable(struct folio *folio, 
unsigned int new_order,
  				 */
  				return -EINVAL;
  			}
-		}

-		if (new_order < mapping_min_folio_order(folio->mapping))
-			return -EINVAL;
+			if (new_order < mapping_min_folio_order(folio->mapping))
+				return -EINVAL;
+		}
  	}

  	/*
---

[1] 
https://lore.kernel.org/all/694ac438.050a0220.35954c.0000.GAE@google.com/

[...]

Thanks,
Lance
