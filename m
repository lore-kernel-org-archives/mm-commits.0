Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 620EC1CFB2
	for <mm-commits@vger.kernel.org>; Tue, 23 Apr 2024 04:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713848177; cv=none; b=EnfIfr2N0bYulUWUgWEVIaE9iv3iLdNUGX2boFNBba5/YvLlZucAGPm92mkdwC9SH2AOkoeuNGN1axVzBy198nmDLe1Vl8cDUUh2KTSHEGeuMP0i+YD8o7hnKZrno4+kVPRGDpFzQ3ZlwMdAEVsO6K/W5o32Gcv8inx4/EvQjxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713848177; c=relaxed/simple;
	bh=N9FS1Xm1sks9Fy73gFMSsHSpXkpW35qJCMUnvosTR/s=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=hSsIfXg7+iRec20T5+g88EyxUmaeKD+th/xLK/g/YvVJUVx2mppBxsVJnPmwji4lRE4+17p19VpZ2RpBVysxR0nD+VpUyKA4m7pZX8m2ih9mrNvlcBWipW5JFshkG4iYyv+5XrQ4s1OHsxceUdDhTS/Qr0UW2IArgyqRcLzLRo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4VNqVj5S8HzXmYF;
	Tue, 23 Apr 2024 12:52:45 +0800 (CST)
Received: from dggpemm100001.china.huawei.com (unknown [7.185.36.93])
	by mail.maildlp.com (Postfix) with ESMTPS id 5AAC4140444;
	Tue, 23 Apr 2024 12:56:13 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemm100001.china.huawei.com (7.185.36.93) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 23 Apr 2024 12:56:13 +0800
Message-ID: <9a84493e-84d3-4fe7-be40-41fa86329273@huawei.com>
Date: Tue, 23 Apr 2024 12:56:12 +0800
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
To: Andrew Morton <akpm@linux-foundation.org>
CC: <mm-commits@vger.kernel.org>, <tj@kernel.org>
References: <20240418194434.CF790C113CC@smtp.kernel.org>
 <b5219c1f-02f8-4225-a578-d991d349f978@huawei.com>
 <20240422145619.3c040adc7706a8fb501d1883@linux-foundation.org>
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <20240422145619.3c040adc7706a8fb501d1883@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm100001.china.huawei.com (7.185.36.93)



On 2024/4/23 5:56, Andrew Morton wrote:
> On Fri, 19 Apr 2024 09:21:06 +0800 Kefeng Wang <wangkefeng.wang@huawei.com> wrote:
> 
>>
>> Hi Andrew,
>>
>> On 2024/4/19 3:44, Andrew Morton wrote:
>>>
>>
>>>
>>> ------------------------------------------------------
>>> From: Kefeng Wang <wangkefeng.wang@huawei.com>
>>> Subject: mm: swapfile: check usable swap device in __folio_throttle_swaprate()
>>> Date: Thu, 18 Apr 2024 21:56:44 +0800
>>>
>>> Skip blk_cgroup_congested() if there is no usable swap device since no
>>> swapin/out will occur, Thereby avoid taking swap_lock.  The difference is
>>> shown below from perf date of CoW pagefault,
>>
>> Thanks your for help to improving changelog, so kind to me.
>>
>>>
>>>    perf report -g -i perf.data.swapoff  | egrep "blk_cgroup_congested|__folio_throttle_swaprate"
>>
>> I make a mistake, this should swapon
>>
>>>        1.01%     0.16%  page_fault2_pro  [kernel.kallsyms]      [k] __folio_throttle_swaprate
>>>        0.83%     0.80%  page_fault2_pro  [kernel.kallsyms]      [k] blk_cgroup_congested
>>>
>>>    perf report -g -i perf.data.swapon   | egrep "blk_cgroup_congested|__folio_throttle_swaprate"
>> and  this is swapoff
>>
>> We don't use swap in our scene, so avoid blk_cgroup_congested(), could
>> you help to correct it too, thanks
>>
>>
>>>        0.15%     0.15%  page_fault2_pro  [kernel.kallsyms]      [k] __folio_throttle_swaprate
>>>
> 
> Please send me the new changelog text and I'll paste it in, thanks.

Here, thank you, Andrew

Skip blk_cgroup_congested() if there is no usable swap device since no
swapin/out will occur, Thereby avoid taking swap_lock.  The difference is
shown below from perf date of CoW pagefault,

  perf report -g -i perf.data.swapon  | egrep 
"blk_cgroup_congested|__folio_throttle_swaprate"
      1.01%     0.16%  page_fault2_pro  [kernel.kallsyms]      [k] 
__folio_throttle_swaprate
      0.83%     0.80%  page_fault2_pro  [kernel.kallsyms]      [k] 
blk_cgroup_congested

  perf report -g -i perf.data.swapoff   | egrep 
"blk_cgroup_congested|__folio_throttle_swaprate"
      0.15%     0.15%  page_fault2_pro  [kernel.kallsyms]      [k] 
__folio_throttle_swaprate

