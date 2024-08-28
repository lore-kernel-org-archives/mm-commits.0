Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9405915535B
	for <mm-commits@vger.kernel.org>; Wed, 28 Aug 2024 10:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724840252; cv=none; b=euKPLeR+Vuxn/6lR5XMFafk0nv9aPTLLxSeRwLrxa3Qf4l0kf1K2eVmiTW97HoRupiD2F2+DqA2wcXCSm49dkFxY7+qRWxxistD+yJJ4YzXhefKRnvd9MHf4Ja7IA31P9BsOViXbBhIkomQYtc4HpM0BrxZUPHht/1ZhcxHm/+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724840252; c=relaxed/simple;
	bh=oMTvlYVw59st1jPkqevLbQMToLfCHwiQGZ9XCUmN9jE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sJtO1ZGPnYZx+xZsbWda0B6yGriw+XwXiwFTuORoYbwEawNB5IxuBlEwvD5pbK8UIvyHtdaEX/TV3Ag7Kg4oEHr6OsxXg6UWfZOGej5VAYb4X6Fbw4Uhp7JvmGAdh8+LnIkCsmp88zWBLnJwEPYwwImANDJZErmj7+KnkrmcTmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=ff1JN8io; arc=none smtp.client-ip=115.124.30.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="ff1JN8io"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1724840241; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=5U/PCsDSCCljClGiWQHDXoHpjZPhkXTv4aWqSBOY/5U=;
	b=ff1JN8ioPwRpe7vjiHA6R8ZFSQt0WAM060ePx9cSusHJ79TfNgOeJ540WwFUqnakMX++0cd9e8FHMaIX8INY2Q5ym3pFQMWMFQSKIEerVBiXgicANRDaTEfdfeyTSnZGLKvCawSBHAv9j8YsKTrMc/4ocVn1QqhCtp72RYYM54s=
Received: from 30.97.56.60(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WDpWP8i_1724840239)
          by smtp.aliyun-inc.com;
          Wed, 28 Aug 2024 18:17:19 +0800
Message-ID: <8c03467c-63b2-43b4-9851-222d4188725c@linux.alibaba.com>
Date: Wed, 28 Aug 2024 18:17:18 +0800
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: +
 mm-shmem-support-large-folio-allocation-for-shmem_replace_folio-fix.patch
 added to mm-unstable branch
To: SeongJae Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
 willy@infradead.org, wangkefeng.wang@huawei.com, shy828301@gmail.com,
 ryan.roberts@arm.com, p.raghav@samsung.com, ioworker0@gmail.com,
 hughd@google.com, david@redhat.com, da.gomez@samsung.com, chrisl@kernel.org,
 baohua@kernel.org
References: <20240828092801.154587-1-sj@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20240828092801.154587-1-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2024/8/28 17:28, SeongJae Park wrote:
> Hello,
> 
> On Tue, 27 Aug 2024 19:13:21 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> 
>>
>> The patch titled
>>       Subject: mm: shmem: fix the gfp flag for large folio allocation
>> has been added to the -mm mm-unstable branch.  Its filename is
>>       mm-shmem-support-large-folio-allocation-for-shmem_replace_folio-fix.patch
>>
>> This patch will shortly appear at
>>       https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-support-large-folio-allocation-for-shmem_replace_folio-fix.patch
>>
>> This patch will later appear in the mm-unstable branch at
>>      git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>>
>> Before you just go and hit "reply", please:
>>     a) Consider who else should be cc'ed
>>     b) Prefer to cc a suitable mailing list as well
>>     c) Ideally: find the original patch on the mailing list and do a
>>        reply-to-all to that, adding suitable additional cc's
>>
>> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
>>
>> The -mm tree is included into linux-next via the mm-everything
>> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>> and is updated there every 2-3 working days
>>
>> ------------------------------------------------------
>> From: Baolin Wang <baolin.wang@linux.alibaba.com>
>> Subject: mm: shmem: fix the gfp flag for large folio allocation
>> Date: Tue, 27 Aug 2024 11:06:34 +0800
>>
>> In shmem_replace_folio(), it may be necessary to allocate a large folio,
>> so we should update the gfp flags to ensure it is suitable for allocating
>> the large folio.
>>
>> Link: https://lkml.kernel.org/r/5b1e9c5a-7f61-4d97-a8d7-41767ca04c77@linux.alibaba.com
>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>> Cc: Barry Song <baohua@kernel.org>
>> Cc: Chris Li <chrisl@kernel.org>
>> Cc: Daniel Gomez <da.gomez@samsung.com>
>> Cc: David Hildenbrand <david@redhat.com>
>> Cc: "Huang, Ying" <ying.huang@intel.com>
>> Cc: Hugh Dickins <hughd@google.com>
>> Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
>> Cc: Lance Yang <ioworker0@gmail.com>
>> Cc: Matthew Wilcox <willy@infradead.org>
>> Cc: Pankaj Raghav <p.raghav@samsung.com>
>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>> Cc: Yang Shi <shy828301@gmail.com>
>> Cc: Zi Yan <ziy@nvidia.com>
>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>> ---
>>
>>   mm/shmem.c |   18 +++++++++++++-----
>>   1 file changed, 13 insertions(+), 5 deletions(-)
>>
>> --- a/mm/shmem.c~mm-shmem-support-large-folio-allocation-for-shmem_replace_folio-fix
>> +++ a/mm/shmem.c
>> @@ -155,7 +155,7 @@ static unsigned long shmem_default_max_i
>>   
>>   static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
>>   			struct folio **foliop, enum sgp_type sgp, gfp_t gfp,
>> -			struct mm_struct *fault_mm, vm_fault_t *fault_type);
>> +			struct vm_area_struct *vma, vm_fault_t *fault_type);
>>   
>>   static inline struct shmem_sb_info *SHMEM_SB(struct super_block *sb)
>>   {
>> @@ -1883,7 +1883,8 @@ static bool shmem_should_replace_folio(s
>>   }
>>   
>>   static int shmem_replace_folio(struct folio **foliop, gfp_t gfp,
>> -				struct shmem_inode_info *info, pgoff_t index)
>> +				struct shmem_inode_info *info, pgoff_t index,
>> +				struct vm_area_struct *vma)
>>   {
>>   	struct folio *new, *old = *foliop;
>>   	swp_entry_t entry = old->swap;
>> @@ -1898,6 +1899,12 @@ static int shmem_replace_folio(struct fo
>>   	 * limit chance of success by further cpuset and node constraints.
>>   	 */
>>   	gfp &= ~GFP_CONSTRAINT_MASK;
>> +	if (nr_pages > 1) {
>> +		gfp_t huge_gfp = vma_thp_gfp_mask(vma);
>> +
>> +		gfp = limit_gfp_mask(huge_gfp, gfp);
>> +	}
>> +
> 
> I just found the above change makes kernel build without
> CONFIG_TRANSPARENT_HUGEPAGE fails like below.
> 
>      ERROR:root:/usr/bin/ld: mm/shmem.o: in function `shmem_swapin_folio':
>      shmem.c:(.text+0x12d9): undefined reference to `vma_thp_gfp_mask'
>      collect2: error: ld returned 1 exit status
> 
> Specifically, I reproduce the problem with kunit[1].
> 
> Maybe the above if statement need to take care of the case, e.g., wrap with
> #ifdef CONFIG_TRANSPARENT_HUGEPAGE?
> 
> [1] https://github.com/damonitor/damon-tests/blob/master/corr/tests/kunit.sh

Thanks for reporting. Yes, the vma_thp_gfp_mask() should be wrapped with 
the CONFIG_TRANSPARENT_HUGEPAGE macro.

Andrew, please help to squash the following fix. Sorry for troubles.

diff --git a/mm/shmem.c b/mm/shmem.c
index 2b0209d6ac9c..553b99cb265e 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1910,11 +1910,13 @@ static int shmem_replace_folio(struct folio 
**foliop, gfp_t gfp,
          * limit chance of success by further cpuset and node constraints.
          */
         gfp &= ~GFP_CONSTRAINT_MASK;
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
         if (nr_pages > 1) {
                 gfp_t huge_gfp = vma_thp_gfp_mask(vma);

                 gfp = limit_gfp_mask(huge_gfp, gfp);
         }
+#endif

         new = shmem_alloc_folio(gfp, folio_order(old), info, index);
         if (!new)
