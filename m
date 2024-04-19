Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A4FB10E3
	for <mm-commits@vger.kernel.org>; Fri, 19 Apr 2024 01:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713489673; cv=none; b=FE4ajnAnfoYll0wxEYY5Qx8O3/tAltlLMDa7WKMmzl4Jajv3Z9BMUfkXwH53hu1+FKkWtSR4t35isiqbm+w8Bj8FguFHh7z8JV1ageXdxBUepMSwN0loqs++FQHwyaCjKXvme1HFV+Jr5+QLxrfakFTb1wEhFXHYDN2HTsh8qGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713489673; c=relaxed/simple;
	bh=LKpXD7G+1jvwg0B94HYdtRhLeElTuYodFeVjNQXnpRc=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=rRtpVXgVb9IeMmMHcXpN22mCN7XDwWRIMERqKpY9BCz9DjBWCd9VtLtokp54bBs2o1Xycyn9TIhSqg7SYfTAa96UjoiHNnaQA0HeVTkgOrU5xp4Yu9zw+3GTDHTK/JFGL/y38cpjEmKMq8VFdo2Q9qZ1ikUBpV7y0zPw3i/V5M0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4VLGxZ2n25z1xv56;
	Fri, 19 Apr 2024 09:18:42 +0800 (CST)
Received: from dggpemm100001.china.huawei.com (unknown [7.185.36.93])
	by mail.maildlp.com (Postfix) with ESMTPS id 764E61A016C;
	Fri, 19 Apr 2024 09:21:07 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemm100001.china.huawei.com (7.185.36.93) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 19 Apr 2024 09:21:07 +0800
Message-ID: <b5219c1f-02f8-4225-a578-d991d349f978@huawei.com>
Date: Fri, 19 Apr 2024 09:21:06 +0800
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: +
 mm-swapfile-check-usable-swap-device-in-__folio_throttle_swaprate.patch added
 to mm-unstable branch
Content-Language: en-US
To: Andrew Morton <akpm@linux-foundation.org>, <mm-commits@vger.kernel.org>,
	<tj@kernel.org>
References: <20240418194434.CF790C113CC@smtp.kernel.org>
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <20240418194434.CF790C113CC@smtp.kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm100001.china.huawei.com (7.185.36.93)


Hi Andrew,

On 2024/4/19 3:44, Andrew Morton wrote:
> 

> 
> ------------------------------------------------------
> From: Kefeng Wang <wangkefeng.wang@huawei.com>
> Subject: mm: swapfile: check usable swap device in __folio_throttle_swaprate()
> Date: Thu, 18 Apr 2024 21:56:44 +0800
> 
> Skip blk_cgroup_congested() if there is no usable swap device since no
> swapin/out will occur, Thereby avoid taking swap_lock.  The difference is
> shown below from perf date of CoW pagefault,

Thanks your for help to improving changelog, so kind to me.

> 
>   perf report -g -i perf.data.swapoff  | egrep "blk_cgroup_congested|__folio_throttle_swaprate"

I make a mistake, this should swapon

>       1.01%     0.16%  page_fault2_pro  [kernel.kallsyms]      [k] __folio_throttle_swaprate
>       0.83%     0.80%  page_fault2_pro  [kernel.kallsyms]      [k] blk_cgroup_congested
> 
>   perf report -g -i perf.data.swapon   | egrep "blk_cgroup_congested|__folio_throttle_swaprate"
and  this is swapoff

We don't use swap in our scene, so avoid blk_cgroup_congested(), could
you help to correct it too, thanks


>       0.15%     0.15%  page_fault2_pro  [kernel.kallsyms]      [k] __folio_throttle_swaprate
> 
