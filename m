Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4612C4430
	for <mm-commits@vger.kernel.org>; Fri, 24 May 2024 01:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716513155; cv=none; b=Mzh2MvFdQBH3FoFoFech7/7VPNSTEmWESBP+1yFiAaByMHkkJBsn829+ytfgy0mQzkVGHx1LJHPwXblCKHVCflnAJHowTwyVf5lCTdXn28vu29MHhwCAViOokb3TdJHhWJSHZ41WxIx5LO0N2FwdNo+BkrAkN5vYJ3odeCWaO4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716513155; c=relaxed/simple;
	bh=HEiAjZXs30txuZEmMpKJPrMt8RyfQ9FTL/siQaTHUf0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Cfhp7vZaagExYXlJSZKcOX9XWu4A7rLZ0QFToMovrEzROAGQw8mLfl3vTi+vGSj2L3CJimvlUg6gW1CI1iUrky+O/cCtTaMBlgvwasJRCiqDxJWO18bA7K3a+kvyYGNHld9VqKfDCyVj/37uMVX0MWK6lmcHIzmHHAp0EMBcDeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=sU2/FLAq; arc=none smtp.client-ip=115.124.30.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="sU2/FLAq"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1716513148; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=x4m59I74BL2aMprBx9xU+duv7FOSt4M4dNAu+wUASTY=;
	b=sU2/FLAq6ERlULJ7J0pZBZFYw0XORB5INekXrjVV2keW4EmzeI/oSjkSrOdLs4sLyd8fmR0OJolOof/qetA2wx+yv4y3IkBisbOSTJMInWWZIbHRZLbVSzI1Cw1yIHNc+HybioF/Ark9+QrSkCQwy4f75cU/DwA6CwnT4cS8Nek=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033022160150;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0W74Bf0h_1716513146;
Received: from 30.97.56.65(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0W74Bf0h_1716513146)
          by smtp.aliyun-inc.com;
          Fri, 24 May 2024 09:12:28 +0800
Message-ID: <e984fd19-f355-4716-af85-5e5275550e87@linux.alibaba.com>
Date: Fri, 24 May 2024 09:12:26 +0800
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: + mm-drop-the-anon_-prefix-for-swap-out-mthp-counters.patch added
 to mm-unstable branch
To: Andrew Morton <akpm@linux-foundation.org>, Barry Song <baohua@kernel.org>
Cc: mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
 willy@infradead.org, ryan.roberts@arm.com, ioworker0@gmail.com,
 david@redhat.com
References: <20240523194021.CF145C2BD10@smtp.kernel.org>
 <CAGsJ_4z_FiDM8v8h8gbfmr5ooU8Dw6TyQrG3MXRUdOzQfmrjhg@mail.gmail.com>
 <20240523165005.3b1569628569060cfba211f4@linux-foundation.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20240523165005.3b1569628569060cfba211f4@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 2024/5/24 07:50, Andrew Morton wrote:
> On Fri, 24 May 2024 10:55:17 +1200 Barry Song <baohua@kernel.org> wrote:
> 
>> On Fri, May 24, 2024 at 7:40 AM Andrew Morton <akpm@linux-foundation.org> wrote:
>>>
>>>
>>> The patch titled
>>>       Subject: mm: drop the 'anon_' prefix for swap-out mTHP counters
>>> has been added to the -mm mm-unstable branch.  Its filename is
>>>       mm-drop-the-anon_-prefix-for-swap-out-mthp-counters.patch
>>
>> Hi Andrew,
>>
>> Baolin is aiming to implement this rename for version 6.10.

Thanks for reminding.

> 
> No probs, I kinda missed that in the changelog.
> 
> Things like this should have a Fixes: so that anyone who backports the
> original feature patch knows to grab this as well.  Please?

Sure, the fixes tag should be:
Fixes: d0f048ac39f6 ("mm: add per-order mTHP anon_swpout and 
anon_swpout_fallback counters")
Fixes: 42248b9d34ea ("mm: add docs for per-order mTHP counters and 
transhuge_page ABI")
