Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 048C215921D
	for <mm-commits@vger.kernel.org>; Thu, 26 Sep 2024 03:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727322369; cv=none; b=lfcuvwM1QMuY4+fTv3eylCHpa4qBZLtT7g7OPZCQ5ygNC+59JI37sjhM/4Nl5HZJ0a9bgdJNjGFt8sgZGfwbfDOtcfF5K1NzK3aG3nyGD9fF3EKl82rCfrJ4VdBDAeGSF+PNGAWfBTUgsMT8eMkFNTAvCDOUjYMGkxj6gX0ocxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727322369; c=relaxed/simple;
	bh=5IfVD6xH0WWvTRiXvN/JQBquP4Hm2H/F4ZcasbYnSaw=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=UM+pMCYNkRJQUYmT/fFgj9WTxMUQzm7mhNl2sEs3lZbYVcdApO5w05iorek7bCMxeD1qZJTpeJj+dgU7aUYJnj+zPFy11TQzOXVA+ayw6BCQ6UMi5sklpYMdRtXxnD5HO/0Yz4ksZzjs/DNN9KkvaHfxOONwEtzOfki6lU3CwdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4XDfcZ1vLKzySKK;
	Thu, 26 Sep 2024 11:45:02 +0800 (CST)
Received: from kwepemm600003.china.huawei.com (unknown [7.193.23.202])
	by mail.maildlp.com (Postfix) with ESMTPS id 1A59B1402CD;
	Thu, 26 Sep 2024 11:46:04 +0800 (CST)
Received: from [10.174.179.79] (10.174.179.79) by
 kwepemm600003.china.huawei.com (7.193.23.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 26 Sep 2024 11:46:03 +0800
Subject: Re: + mm-move-mm-flags-to-mm_typesh.patch added to mm-unstable branch
To: Matthew Wilcox <willy@infradead.org>
CC: Andrew Morton <akpm@linux-foundation.org>, <mm-commits@vger.kernel.org>,
	<wangkefeng.wang@huawei.com>, <peterz@infradead.org>, <oleg@redhat.com>,
	<mhiramat@kernel.org>
References: <20240925100517.DFC29C4CEC3@smtp.kernel.org>
 <ZvP_g757PkAb6thl@casper.infradead.org>
 <42755d5d-f554-15d1-e0a7-2239f6d6bf1a@huawei.com>
 <ZvQUIXxkVmbdTkZG@casper.infradead.org>
From: Nanyong Sun <sunnanyong@huawei.com>
Message-ID: <ae7a3c74-5bea-45a9-56d0-beaa514c4d1f@huawei.com>
Date: Thu, 26 Sep 2024 11:46:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <ZvQUIXxkVmbdTkZG@casper.infradead.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600003.china.huawei.com (7.193.23.202)

On 2024/9/25 21:46, Matthew Wilcox wrote:

> On Wed, Sep 25, 2024 at 09:40:31PM +0800, Nanyong Sun wrote:
>> On 2024/9/25 20:18, Matthew Wilcox wrote:
>>
>>> On Wed, Sep 25, 2024 at 03:05:17AM -0700, Andrew Morton wrote:
>>>> +++ a/include/linux/mm_types.h
>>>> @@ -1499,4 +1499,85 @@ enum {
>>>>    	/* See also internal only FOLL flags in mm/internal.h */
>>>>    };
>>>> +/* mm flags */
>>>> +
>>>> +/* core dumpable occupy bit0 and bit1 */
>>> ... but why is that important?
>> /*
>>   * The first two bits represent core dump modes for set-user-ID,
>>   * the modes are SUID_DUMP_* defined in linux/sched/coredump.h
>>   */
>> Do you think if change it to this will be OK?
> That seems reasonable.
>
> .

OK, I will send v3 later.

Thanks a lot for your review and suggestion.

