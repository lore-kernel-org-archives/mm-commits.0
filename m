Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BF331487FE
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 05:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736745461; cv=none; b=JLGZxLf0zAqGev/G+QGVK26k9qAO013mNw/ybQkLCavkhhmcxFNlrvWQoowFOe+fjOvLFmgag5CMzJyixB9Inbn5d2Wo1TsEoIw5S9VXuT1Kzof7IHkc8qR23B3gORJ5p4XKQEYi7iSbOIdsEuHxbCOTVR7HO4W+eJDMDIEfqQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736745461; c=relaxed/simple;
	bh=C1LkLbNwa3W1ouCQyiF/mTADo5BU4v7KEZnrZrhH5n8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=pbPWsE9Q5f0v6OM5hn7f6IZcM4sOPNgKFN6ttudbToczr9Vudjh8cUq/wPJkd578cFr6z77RQJCmUfy0O3c+Ph0+V3NOhaySJ3hRJHCt2BEz/IAjnNR1wpvRGagCCHFO6pl8ksMKmMs2L37VOz/GPdaTUoEH3b3nESniKp/ZzU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=hIKFo8NP; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="hIKFo8NP"
Message-ID: <623df213-8540-44a8-85eb-ab78b2b1446e@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1736745452;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6KWWSu+P3tPKfUpbWkbemCGrxIPuACmps+S+xr8xOU4=;
	b=hIKFo8NP4Nh+UOnluHIzvNA3BWfj7e1aCegwTmxga+WAo9zXdLQAVShSsN9Ber80kznYpk
	apN3AjuzIfXbYw6fEMuGlTiZ3sTxUjJjdMHRwva7MfLvCzmKPQvmJxO65MyKljnw5ajNQM
	3OQmvdy8mePiBNlsHTjMQvEbHbaX+tg=
Date: Mon, 13 Jan 2025 13:16:43 +0800
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: + selftests-mm-cow-modify-the-incorrect-checking-parameters.patch
 added to mm-unstable branch
To: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
 sj@kernel.org, shuah@kernel.org, gehao@kylinos.cn
References: <20250113042952.062F2C4CED6@smtp.kernel.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <20250113042952.062F2C4CED6@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

Hi Andrew


Anshuman reminded me that the issue was not limited to the 
run_with_memfd_hugetlb function,

so I have released a new version addressing the problem in other places 
as well.

So, please help update this patch to version 2.

https://lore.kernel.org/all/20250113050908.93638-1-hao.ge@linux.dev/

I apologize for any inconvenience this has caused.


Thanks

Best Regards

Hao


On 2025/1/13 12:29, Andrew Morton wrote:
> The patch titled
>       Subject: selftests/mm/cow: modify the incorrect checking parameters
> has been added to the -mm mm-unstable branch.  Its filename is
>       selftests-mm-cow-modify-the-incorrect-checking-parameters.patch
>
> This patch will shortly appear at
>       https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-cow-modify-the-incorrect-checking-parameters.patch
>
> This patch will later appear in the mm-unstable branch at
>      git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>
> Before you just go and hit "reply", please:
>     a) Consider who else should be cc'ed
>     b) Prefer to cc a suitable mailing list as well
>     c) Ideally: find the original patch on the mailing list and do a
>        reply-to-all to that, adding suitable additional cc's
>
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
>
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days
>
> ------------------------------------------------------
> From: Hao Ge <gehao@kylinos.cn>
> Subject: selftests/mm/cow: modify the incorrect checking parameters
> Date: Mon, 13 Jan 2025 11:28:58 +0800
>
> In run_with_memfd_hugetlb(), some error handle have passed incorrect
> parameters.  It should be "smem", but it was mistakenly written as "mem".
>
> Let's fix it.
>
> Link: https://lkml.kernel.org/r/20250113032858.63670-1-hao.ge@linux.dev
> Fixes: baa489fabd01 ("selftests/vm: rename selftests/vm to selftests/mm")
> Signed-off-by: Hao Ge <gehao@kylinos.cn>
> Cc: SeongJae Park <sj@kernel.org>
> Cc: Shuah Khan (Samsung OSG) <shuah@kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>   tools/testing/selftests/mm/cow.c |    4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> --- a/tools/testing/selftests/mm/cow.c~selftests-mm-cow-modify-the-incorrect-checking-parameters
> +++ a/tools/testing/selftests/mm/cow.c
> @@ -1692,7 +1692,7 @@ static void run_with_memfd_hugetlb(non_a
>   		goto close;
>   	}
>   	smem = mmap(NULL, hugetlbsize, PROT_READ, MAP_SHARED, fd, 0);
> -	if (mem == MAP_FAILED) {
> +	if (smem == MAP_FAILED) {
>   		ksft_test_result_fail("mmap() failed\n");
>   		goto munmap;
>   	}
> @@ -1704,7 +1704,7 @@ static void run_with_memfd_hugetlb(non_a
>   	fn(mem, smem, hugetlbsize);
>   munmap:
>   	munmap(mem, hugetlbsize);
> -	if (mem != MAP_FAILED)
> +	if (smem != MAP_FAILED)
>   		munmap(smem, hugetlbsize);
>   close:
>   	close(fd);
> _
>
> Patches currently in -mm which might be from gehao@kylinos.cn are
>
> selftests-mm-cow-modify-the-incorrect-checking-parameters.patch
>
