Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C8D53BAD89
	for <mm-commits@vger.kernel.org>; Tue, 14 Apr 2026 10:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776161144; cv=none; b=l672bU+pFz9gVW58O9WYctX21Vd2A4aTmO/R/vMzeZUEvO7Fn0vjI+7EzLHJ1NLK3oI05KO1lTySLGL/b+Ok64cV0CBMIdQWnGdKE9farfASXcM9Ya0jTnyJQ9plzqu9SE9HPg5OYkjR8oOJyYfdqIKI8o71sueLIwZxewtwbLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776161144; c=relaxed/simple;
	bh=jiNq7KNlOCEUASqOp+9SN9b80TIKZFOq3caPruuVGXk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=cAKk8LQ8uKv5HSrWOH3DvmoQ4ARBy4HF5mJkO0UAYNl/KuYxZMIIv98BTe4ZyAr3bxgNAFI+dsuHj21kExcANe02zLJFtyoRjf5PeZDnJ3C6GxmqU5+mg2u318dENgXGo4qTdzNMhV1fiJxpYrmK/c7wgJLLaYWV4jFD01ygbQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oHUhIE0O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oHUhIE0O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EEA9C19425;
	Tue, 14 Apr 2026 10:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776161143;
	bh=jiNq7KNlOCEUASqOp+9SN9b80TIKZFOq3caPruuVGXk=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=oHUhIE0O+EQDP7i8OzXtDM3m5/PHEij2gJWOVfGGspwV7xI03MPD9l5hLs3D0pMOw
	 3qNIzOLMox+zBK22Pq7v+kn8y0IbRiuaWpZsgZWFcqNCp/ScKXNXFAj28ivIa1aiQH
	 wLiKo93ISxn93wTV/tvcUi02V3IfCxf3uU2Cy3Lq/fQlrLeyvLQWYnfi/9axFJhADH
	 6GlaBwUGa4DR57AXckWF9InKn5WUdwmFh6Xph3Fg0Gba8bQeMMCT2ArZPmKnM/tuGL
	 atlc3N6cy/HKoPhgcSTczgCUeHoih3jNC5I1TqGwl1XEFJIXRgcuH++9FXnUsAw2ju
	 xwZvkSu35KEZA==
Message-ID: <460b74aa-8840-4390-80de-4ce39251b83d@kernel.org>
Date: Tue, 14 Apr 2026 12:05:37 +0200
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [merged]
 mm-migrate_device-remove-dead-migration-entry-check-in-migrate_vma_collect_huge_pmd.patch
 removed from -mm tree
To: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
 ziy@nvidia.com, ying.huang@linux.alibaba.com,
 thomas.hellstrom@linux.intel.com, rakie.kim@sk.com, matthew.brost@intel.com,
 joshua.hahnjy@gmail.com, jhubbard@nvidia.com, jgg@ziepe.ca,
 gourry@gourry.net, byungchul@sk.com, balbirs@nvidia.com, apopple@nvidia.com,
 dave@stgolabs.net
References: <20260310201608.E6F5AC19423@smtp.kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260310201608.E6F5AC19423@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 3/10/26 21:16, Andrew Morton wrote:
> The quilt patch titled
>      Subject: mm/migrate_device: remove dead migration entry check in migrate_vma_collect_huge_pmd()
> has been removed from the -mm tree.  Its filename was
>      mm-migrate_device-remove-dead-migration-entry-check-in-migrate_vma_collect_huge_pmd.patch
> 
> This patch was dropped because it was merged into mainline or a subsystem tree
> 
> ------------------------------------------------------
> From: Davidlohr Bueso <dave@stgolabs.net>
> Subject: mm/migrate_device: remove dead migration entry check in migrate_vma_collect_huge_pmd()
> Date: Wed, 11 Feb 2026 17:46:11 -0800
> 
> The softleaf_is_migration() check is unreachable as entries that are not
> device_private are filtered out.  Similarly, the PTE-level equivalent in
> migrate_vma_collect_pmd() skips migration entries.
> 
> This dead branch also contained a double spin_unlock(ptl) bug.
> 
> Link: https://lkml.kernel.org/r/20260212014611.416695-1-dave@stgolabs.net
> Fixes: a30b48bf1b244 ("mm/migrate_device: implement THP migration of zone device pages")
> Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>
> Suggested-by: Matthew Brost <matthew.brost@intel.com>
> Reviewed-by: Alistair Popple <apopple@nvidia.com>
> Acked-by: Balbir Singh <balbirs@nvidia.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Cc: Byungchul Park <byungchul@sk.com>
> Cc: Gregory Price <gourry@gourry.net>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: John Hubbard <jhubbard@nvidia.com>
> Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
> Cc: Mathew Brost <matthew.brost@intel.com>
> Cc: Rakie Kim <rakie.kim@sk.com>
> Cc: Ying Huang <ying.huang@linux.alibaba.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  mm/migrate_device.c |    6 ------
>  1 file changed, 6 deletions(-)
> 
> --- a/mm/migrate_device.c~mm-migrate_device-remove-dead-migration-entry-check-in-migrate_vma_collect_huge_pmd
> +++ a/mm/migrate_device.c
> @@ -175,12 +175,6 @@ static int migrate_vma_collect_huge_pmd(
>  			return migrate_vma_collect_skip(start, end, walk);
>  		}
>  
> -		if (softleaf_is_migration(entry)) {
> -			migration_entry_wait_on_locked(entry, ptl);
> -			spin_unlock(ptl);
> -			return -EAGAIN;
> -		}
> -
>  		if (softleaf_is_device_private_write(entry))
>  			write = MIGRATE_PFN_WRITE;
>  	} else {
> _
> 
> Patches currently in -mm which might be from dave@stgolabs.net are

Andrew, was this patch dropped by mistake?

-- 
Cheers,

David
