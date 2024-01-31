Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EC017B3E3
	for <mm-commits@vger.kernel.org>; Wed, 31 Jan 2024 13:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706707576; cv=none; b=r+27c1+uFVmhAB+MypCig9KLt4UrnxqtoU/CVLjt5cMyVUQJzxxzYVMiZGZIzaAXetLe/vUrNpCdCEugc3a9MxQhsa9NBHlmlJDx4DCM9FOz1tOvILiNpMQiGVkukylacxoQM+jaiklzAAjijuHwstici8bjogAMY8DxGniU0b8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706707576; c=relaxed/simple;
	bh=xkBgU8WL5+orXtLpRGum57RnSZqRCt1Swt9UwDGlGHU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PLkYxqn7jKDXHDMx2iP9RsTZCJbZdaYSCmK3wNa6/9KV22Es4EYSUrHdWaPfI7mTqzjZDuXAcpfuhMUKaYwXn84fonw5qoTJG/cOculvdOdC02dBTxdk2kojxcspehOXD0Cu0QGV+Sm0P/Y8AbpqcKHiVRnN/zJms4WnEnpLH2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=PMqwQR4f; arc=none smtp.client-ip=115.124.30.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="PMqwQR4f"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1706707572; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=lGXG1hy01AWQdqiykZAGx5tuazULd6WaMSLRzHwMJbc=;
	b=PMqwQR4fVI2joksSAJDuHGKjXVq1f4X0Iwm0LKisrGpc/rciTTNkwMCkVnLBmM/QddE9PLRbpoxITN1S9UpUjnYprfwfkMi/87v/wSOOKzhp8R5zWoK2YxcWaMOycpRK4jXFzMhRI2wNB5wC4Gi75opMMGRt8SS/Cld2P/jRj3M=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045170;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0W.jtVZu_1706707570;
Received: from 30.13.183.251(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0W.jtVZu_1706707570)
          by smtp.aliyun-inc.com;
          Wed, 31 Jan 2024 21:26:11 +0800
Message-ID: <99eefe1a-b46c-494b-bb91-3c1172eac6f6@linux.alibaba.com>
Date: Wed, 31 Jan 2024 21:26:32 +0800
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: +
 mm-compaction-update-the-cc-nr_migratepages-when-allocating-or-freeing-the-freepages.patch
 added to mm-unstable branch
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, vbabka@suse.cz, mgorman@techsingularity.net
References: <20240130063057.A1891C433C7@smtp.kernel.org>
 <e4d47608-7f7f-4156-9fbb-52ffb3029f4d@linux.alibaba.com>
 <20240130225156.077d0314ee3eae824ac45c42@linux-foundation.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20240130225156.077d0314ee3eae824ac45c42@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 1/31/2024 2:51 PM, Andrew Morton wrote:
> On Tue, 30 Jan 2024 15:01:30 +0800 Baolin Wang <baolin.wang@linux.alibaba.com> wrote:
> 
>> Thanks for queuing this patch, but this patch should be updated as below
>> after the "Enable >0 order folio memory compaction" series:
> 
> Best to send a new patch please.

Sure, I've sent out the new version.

https://lore.kernel.org/all/994af744828efe3c060128445204a56ab41e3ebb.1706706820.git.baolin.wang@linux.alibaba.com/
