Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4DE3A927
	for <mm-commits@vger.kernel.org>; Thu,  8 May 2025 10:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746699575; cv=none; b=oFIYcUM/4+7FzKF+Y5FyXglRV6zW8RGDI7xrA67bKuIUPOHfr3A5+AVqYm7I/yAgLkGvemyBON5SspDN3HW5zMOXA5R+AhZdzoFLxS4n8OavFuFTpl+xjmvuhc5tyuYniFkT2gArKU+g3N025mKcN3XCsAjJ3jXeNbIcDl38doo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746699575; c=relaxed/simple;
	bh=B0++XrK0YPvLvtsHUnreBBq39vA0+n7IWMTF81b4tRg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oUkF4BPGJAYxPPL1f8gYGU2pXbKYk1wLGEJbyH+xWsNjOXY4YuD3NDYjGgGJGSNwMt1jWnlS0o7aQpueOzWTCyjzYmuSXy24kwy0fuL3uD7dveZ2COMuTe0O35IhQDsHHnijv/wQsnUH+U0yyyiXH2kLN3ROq9wRCptC7VXGiKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A37FD106F;
	Thu,  8 May 2025 03:19:21 -0700 (PDT)
Received: from [10.162.43.19] (K4MQJ0H1H2.blr.arm.com [10.162.43.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D6AF43F5A1;
	Thu,  8 May 2025 03:19:25 -0700 (PDT)
Message-ID: <d0fd1faf-ea5a-4b99-9b48-7e3e8725865e@arm.com>
Date: Thu, 8 May 2025 15:49:22 +0530
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: + mm-optimize-mremap-by-pte-batching.patch added to mm-new branch
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
 ziy@nvidia.com, zhengqi.arch@bytedance.com, yang@os.amperecomputing.com,
 willy@infradead.org, vbabka@suse.cz, ryan.roberts@arm.com,
 peterx@redhat.com, mingo@kernel.org, maobibo@loongson.cn,
 libang.li@antgroup.com, liam.howlett@oracle.com, jannh@google.com,
 ioworker0@gmail.com, hughd@google.com, david@redhat.com,
 baolin.wang@linux.alibaba.com, baohua@kernel.org, anshuman.khandual@arm.com
References: <20250508014113.7E78FC4CEE2@smtp.kernel.org>
 <addcfcdf-3ded-4d9d-8a96-6006d3b71a51@arm.com>
 <66fada4e-c9e2-4d67-a939-9cc1a93239d7@lucifer.local>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <66fada4e-c9e2-4d67-a939-9cc1a93239d7@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 08/05/25 3:41 pm, Lorenzo Stoakes wrote:
> On Thu, May 08, 2025 at 03:38:46PM +0530, Dev Jain wrote:
>>
>>
>> On 08/05/25 7:11 am, Andrew Morton wrote:
> 
> [snip]
> 
>>>    	/*
>>>    	 * When need_rmap_locks is true, we take the i_mmap_rwsem and anon_vma
>>> @@ -236,12 +254,13 @@ static int move_ptes(struct pagetable_mo
>>>    	flush_tlb_batched_pending(vma->vm_mm);
>>>    	arch_enter_lazy_mmu_mode();
>>> -	for (; old_addr < old_end; old_ptep++, old_addr += PAGE_SIZE,
>>> -				   new_ptep++, new_addr += PAGE_SIZE) {
>>> -		if (pte_none(ptep_get(old_ptep)))
>>> +	for (int nr = 1; old_addr < old_end; old_ptep += nr, old_addr += nr * PAGE_SIZE,
>>> +				   new_ptep += nr, new_addr += nr * PAGE_SIZE) {
>>
>> Apologies, this is wrong, I moved nr to the for loop thus nr will be
>> initialized to 1 only once, what I intend to do is set this to 1 at the
>> beginning of each iteration.
>>
> 
> Don't worry, Andrew will pull the series out of the mm-new tree based on review
> push back automatically :)
> 
> The mm-new tree is also intentionally designated as the 'anything goes' one
> which has latest series in - easily applied, easily dropped, mm-unstable is
> the one that goes to linux-next now and mm-stable is the final set of
> patches that will be sent to Linus.
> 
> So there's no need to proactively chase here unless it's heading for
> mm-stable really!

Thanks for explaining what mm-new is, couldn't find anything about it on 
lore :)

> 
> Cheers, Lorenzo
> 
> [snip]

