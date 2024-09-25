Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D88571B2ED3
	for <mm-commits@vger.kernel.org>; Wed, 25 Sep 2024 13:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727271637; cv=none; b=Y0YclNUgwbcDHdvl/wFytmRdVT7ZQP1HhZe3a45x9fQeLOp6SlmWQou2vOhq6mWyXsRSScDJFkYVz2Ccgktc0tlcUnJrAmDZsCAEQt6UeNhcjpA6vHHc51F4HZmPEHvJ0VEJWN0QdXIEQOdZjAj4KG72WfdMEG3mUA6JzvpLT5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727271637; c=relaxed/simple;
	bh=haxCFuKWelhaaT9lI6Q2mn9f7B7ytecpNf130Z0u+S4=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=bb0+5VdJ/dmTY1OIAZ//JNg7RTl9gxlOEJOoo1LZe2I16hPnuJuo1mEWzgyqwa7gjCxtcHiid64/npulJjRfFJzd8ktHw7mKrASQCQ6ZkyD/0ttck6DLsn79G/f64l3SOFbDwZrkfmrvJ80cXCEmqe36DjprLZkjoLZLcprdvoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4XDHqp21mbzpW8r;
	Wed, 25 Sep 2024 21:38:30 +0800 (CST)
Received: from kwepemm600003.china.huawei.com (unknown [7.193.23.202])
	by mail.maildlp.com (Postfix) with ESMTPS id D55E9180087;
	Wed, 25 Sep 2024 21:40:32 +0800 (CST)
Received: from [10.174.179.79] (10.174.179.79) by
 kwepemm600003.china.huawei.com (7.193.23.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 25 Sep 2024 21:40:32 +0800
Subject: Re: + mm-move-mm-flags-to-mm_typesh.patch added to mm-unstable branch
To: Matthew Wilcox <willy@infradead.org>, Andrew Morton
	<akpm@linux-foundation.org>
CC: <mm-commits@vger.kernel.org>, <wangkefeng.wang@huawei.com>,
	<peterz@infradead.org>, <oleg@redhat.com>, <mhiramat@kernel.org>
References: <20240925100517.DFC29C4CEC3@smtp.kernel.org>
 <ZvP_g757PkAb6thl@casper.infradead.org>
From: Nanyong Sun <sunnanyong@huawei.com>
Message-ID: <42755d5d-f554-15d1-e0a7-2239f6d6bf1a@huawei.com>
Date: Wed, 25 Sep 2024 21:40:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <ZvP_g757PkAb6thl@casper.infradead.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600003.china.huawei.com (7.193.23.202)

On 2024/9/25 20:18, Matthew Wilcox wrote:

> On Wed, Sep 25, 2024 at 03:05:17AM -0700, Andrew Morton wrote:
>> +++ a/include/linux/mm_types.h
>> @@ -1499,4 +1499,85 @@ enum {
>>   	/* See also internal only FOLL flags in mm/internal.h */
>>   };
>>   
>> +/* mm flags */
>> +
>> +/* core dumpable occupy bit0 and bit1 */
> ... but why is that important?
/*
  * The first two bits represent core dump modes for set-user-ID,
  * the modes are SUID_DUMP_* defined in linux/sched/coredump.h
  */
Do you think if change it to this will be OK?
>
>> +#define MMF_DUMPABLE_BITS 2
>> +#define MMF_DUMPABLE_MASK ((1 << MMF_DUMPABLE_BITS) - 1)
>> +++ a/include/linux/sched/coredump.h
>> @@ -8,12 +8,6 @@
>>   #define SUID_DUMP_USER		1	/* Dump as user of process */
>>   #define SUID_DUMP_ROOT		2	/* Dump as root */
>>   
>> -/* mm flags */
>> -
>> -/* for SUID_DUMP_* above */
> the old comment told us why!
>
>> -#define MMF_DUMPABLE_BITS 2
>> -#define MMF_DUMPABLE_MASK ((1 << MMF_DUMPABLE_BITS) - 1)
> NAK this patch.
>
> .
