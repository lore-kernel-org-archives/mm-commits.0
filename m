Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3477D4C74;
	Thu, 25 Jul 2024 01:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721869846; cv=none; b=Gz94XBfwDbikT8gTB4NGnYamEDXvpYa0x79eN+2Kbxovd4OOJHJWw3scZWpht3bUvyY5VQOIXEJNyTOQrrQRL5ZTebToCdnPssBtAPy70meDHTh90m369jiDjC9hhrznvZQwmHUfYpp8tjGF/FMg+1szUEe5sbl82eLGuhQ5M78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721869846; c=relaxed/simple;
	bh=bGpfHtZjqEuI1uKvHRGk6zezjPs5wbemehRQh8Y1lDE=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=cIdTnZ0sDklkPF10YmK7Ig/jH0BZJIbgquReqiicnqr9cpEP6wLdlBg72B+nZBaxgp7J8+EoWb/ojI0Wk9kcq1Ypoys+vqtpA3EEr8grkjoBTr14B6r6VjPxqYV/GTBwmsqd2MMETtrlp5zmAnFKfMc1ujYIFogHXB+CkdusFtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4WTt4b1mfzzQn4y;
	Thu, 25 Jul 2024 09:06:23 +0800 (CST)
Received: from kwepemi100008.china.huawei.com (unknown [7.221.188.57])
	by mail.maildlp.com (Postfix) with ESMTPS id 1D765140121;
	Thu, 25 Jul 2024 09:10:35 +0800 (CST)
Received: from [10.67.109.254] (10.67.109.254) by
 kwepemi100008.china.huawei.com (7.221.188.57) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 25 Jul 2024 09:10:34 +0800
Message-ID: <f177a4ec-821d-982d-3680-434861a4babb@huawei.com>
Date: Thu, 25 Jul 2024 09:10:33 +0800
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: + crash-fix-x86_32-crash-memory-reserve-dead-loop-bug.patch added
 to mm-nonmm-unstable branch
Content-Language: en-US
To: Andrew Morton <akpm@linux-foundation.org>
CC: <mm-commits@vger.kernel.org>, <will@kernel.org>, <vgoyal@redhat.com>,
	<thunder.leizhen@huawei.com>, <tglx@linutronix.de>, <stable@vger.kernel.org>,
	<robh@kernel.org>, <paul.walmsley@sifive.com>, <palmer@dabbelt.com>,
	<mingo@redhat.com>, <linux@armlinux.org.uk>, <linus.walleij@linaro.org>,
	<javierm@redhat.com>, <hpa@zytor.com>, <hbathini@linux.ibm.com>,
	<gregkh@linuxfoundation.org>, <eric.devolder@oracle.com>,
	<dyoung@redhat.com>, <deller@gmx.de>, <dave.hansen@linux.intel.com>,
	<chenjiahao16@huawei.com>, <catalin.marinas@arm.com>, <bp@alien8.de>,
	<bhe@redhat.com>, <arnd@arndb.de>, <aou@eecs.berkeley.edu>, <afd@ti.com>
References: <20240724053727.28397C32782@smtp.kernel.org>
 <7898c0c5-45b6-9795-74a0-f70904dd077c@huawei.com>
 <20240724103752.f3ed5021d203d5e333b47873@linux-foundation.org>
From: Jinjie Ruan <ruanjinjie@huawei.com>
In-Reply-To: <20240724103752.f3ed5021d203d5e333b47873@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemi100008.china.huawei.com (7.221.188.57)



On 2024/7/25 1:37, Andrew Morton wrote:
> On Wed, 24 Jul 2024 14:44:12 +0800 Jinjie Ruan <ruanjinjie@huawei.com> wrote:
> 
>>> ------------------------------------------------------
>>> From: Jinjie Ruan <ruanjinjie@huawei.com>
>>> Subject: crash: fix x86_32 crash memory reserve dead loop bug
>>> Date: Thu, 18 Jul 2024 11:54:42 +0800
>>>
>>> Patch series "crash: Fix x86_32 memory reserve dead loop bug", v3.
>>
>> It seems that the newest is v4, and the loongarch is missing.
> 
> I cannot find a v4 series anywhere.

Hi, Andrew

v4 is below, thank you!

Link:
https://lore.kernel.org/all/20240719095735.1912878-1-ruanjinjie@huawei.com/
