Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D715E190489
	for <mm-commits@vger.kernel.org>; Tue, 30 Jul 2024 23:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722383718; cv=none; b=VVp9UBFxeA3lxnlYnGKanAbYDJ8lRL49lO1MqkvHMTY0PTFGkDrKSyraoPPtWHLwxLYv2BsGdhxgIpeDJzHzNV8+lcYD293mcHgt21t12+bdLprbpwleDVcE9S/6zW0nFzQQKFbSsEJvyOELsUGnP8TIc40czl4vZJBdS27fvmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722383718; c=relaxed/simple;
	bh=y1o+p2VJR629oN7yyZ0sk+Q+ICluE3GGCDTnnUWM2/s=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:Cc:From:
	 In-Reply-To:Content-Type; b=sFX13A1I8wpcF7DOu343bIse0XeDPPjuxt4+BgS9xsqhkKuQgRJJ02XNN3MKvbzxtzWO8t0ltw08KKnGanFUCztb+GLicXR5fruuNhc5ZhcVF5qBpGjq4zx9us/Hvf4edYoYKFCH9eDfU9I4PbWBPoSQqCCNLuMk1MvevlTNZyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=L59kVJKB; arc=none smtp.client-ip=115.124.30.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="L59kVJKB"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1722383713; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=v44WgqrUaLMaK8YVcfT4Hz15B2DhXpTRftLGcsUY97U=;
	b=L59kVJKB7ZKuZIC3CMDhxFI5900Drn9bXwNQSDd9Ys9R7rT9XyJAKplUCqTxZ8O3ElUZE9doJDhNPAEJ6jC5DONOBBlwWYsca9Fn0fTSu4AS02hLAajDmR4iLccgSNArXj+MGL7kbPuouQMgcCXlh62eByebEOcJUL/1uT924dk=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R761e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045046011;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0WBh-NeX_1722383711;
Received: from 192.168.1.5(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0WBh-NeX_1722383711)
          by smtp.aliyun-inc.com;
          Wed, 31 Jul 2024 07:55:12 +0800
Message-ID: <d7ae190d-5aba-440b-9f10-7652ae3c443b@linux.alibaba.com>
Date: Wed, 31 Jul 2024 07:55:11 +0800
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: +
 mm-migrate-fix-deadlock-in-migrate_pages_batch-on-large-folios.patch added to
 mm-hotfixes-unstable branch
To: Andrew Morton <akpm@linux-foundation.org>
References: <20240728195100.23ED1C116B1@smtp.kernel.org>
Cc: mm-commits@vger.kernel.org, Huang Ying <ying.huang@intel.com>,
 Matthew Wilcox <willy@infradead.org>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20240728195100.23ED1C116B1@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Andrew,

On 2024/7/29 03:50, Andrew Morton wrote:
> The patch titled
>       Subject: mm/migrate: fix deadlock in migrate_pages_batch() on large folios
> has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
>       mm-migrate-fix-deadlock-in-migrate_pages_batch-on-large-folios.patch
> 
> This patch will shortly appear at
>       https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-fix-deadlock-in-migrate_pages_batch-on-large-folios.patch
> 
> This patch will later appear in the mm-hotfixes-unstable branch at
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

Could you replace this version to v2?
https://lore.kernel.org/linux-mm/20240729021306.398286-1-hsiangkao@linux.alibaba.com/

Huang, Ying has reviewed it.  And I've also tested this
version for days, it seems to really fix the issue.

I think it applys for v6.3+ anyway, but Huang, Ying didn't confirm that tho.

Thanks,
Gao Xiang
