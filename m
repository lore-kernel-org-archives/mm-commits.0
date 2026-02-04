Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86F312D249B
	for <mm-commits@vger.kernel.org>; Wed,  4 Feb 2026 02:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770172971; cv=none; b=u5UQttczQtKxKhG/2kPPXtoGDL5vOFfAMupQXea1flTaJ2EIiO+I/ulhpRHog9vL8YC6YxphhlNBvBOccEJ2bS2SlNxj0UXNBP76NmQzTMwJz51BT89ksJyNdc6vKJTIbrJJEi2xPjtO1HW8E2ooRdfyx/1IOb97sgyUCScP4pE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770172971; c=relaxed/simple;
	bh=cK6MjnNMQoRPEItX5jhZMnANwwqRadyMJI965Y1wziQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=G6Ztxg3KVr4XOchTD3KdMSBQLOGtkZXxncrb+IFb2iFLzYsUtT6OH21SvM+x70c0ueyR4w8P+w09/N1KL9P+3rnS/Qgf4nCU/ViSxDrqKdvpr62b1HRLvFPxIntT9ZGWfPyEXIVeNumnb7UrzAVqPDnEJzcxSGo2rTagCF+3N28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=vLO5CyDg; arc=none smtp.client-ip=113.46.200.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="vLO5CyDg"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=4QYnWxi2qbdZ+cpccpAN1rqGfCFURPR/8h/7kA5P36k=;
	b=vLO5CyDgipMGYhjVNrjSdogKCUBk25ayqUFpv5zMrCCXRq1DMfzeAkrrYeVFsLn7Dz0jXoKfQ
	U5fj2Ha2TrNCl0WZAMgwjzYdj3DW5gTzX23hcjr515KK18T2SG35YH46x3DuUh2BfhB67Lal9OB
	lCY0bWKt6RM4nDDAv7IPxpI=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4f5PfS6ZbfzmV6g;
	Wed,  4 Feb 2026 10:38:08 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id C8645402AB;
	Wed,  4 Feb 2026 10:42:43 +0800 (CST)
Received: from [10.67.109.254] (10.67.109.254) by
 dggpemf500011.china.huawei.com (7.185.36.131) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 4 Feb 2026 10:42:41 +0800
Message-ID: <2260cbc3-bbb3-3179-68c1-7c813583a6d6@huawei.com>
Date: Wed, 4 Feb 2026 10:42:40 +0800
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [merged mm-nonmm-stable]
 riscv-kexec-add-support-for-crashkernel-cma-reservation.patch removed from
 -mm tree
Content-Language: en-US
To: Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
CC: <mm-commits@vger.kernel.org>, <vishal.moola@gmail.com>,
	<songshuaishuai@tinylab.org>, <samuel.holland@sifive.com>,
	<rdunlap@infradead.org>, <pawan.kumar.gupta@linux.intel.com>,
	<palmer@dabbelt.com>, <mingo@kernel.org>, <lirongqing@baidu.com>,
	<leitao@debian.org>, <kevin.brodsky@arm.com>, <kees@kernel.org>,
	<fvdl@google.com>, <elver@google.com>, <cuiyunhui@bytedance.com>,
	<corbet@lwn.net>, <bp@alien8.de>, <bjorn@rivosinc.com>,
	<bhelgaas@google.com>, <arnd@arndb.de>, <aou@eecs.berkeley.edu>,
	<alex@ghiti.fr>
References: <20260201001710.A3CE5C4CEF1@smtp.kernel.org>
 <aX9jPbkG7QYNWH73@kernel.org>
 <20260202125404.343361f6696777efc3acaab1@linux-foundation.org>
 <aYGnODFtgjyiRLB9@kernel.org>
From: Jinjie Ruan <ruanjinjie@huawei.com>
In-Reply-To: <aYGnODFtgjyiRLB9@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf500011.china.huawei.com (7.185.36.131)



On 2026/2/3 15:43, Mike Rapoport wrote:
> On Mon, Feb 02, 2026 at 12:54:04PM -0800, Andrew Morton wrote:
>> On Sun, 1 Feb 2026 15:29:17 +0100 Mike Rapoport <rppt@kernel.org> wrote:
>>
>>>> From: Jinjie Ruan <ruanjinjie@huawei.com>
>>>> Subject: riscv: kexec: add support for crashkernel CMA reservation
>>>> Date: Mon, 26 Jan 2026 16:07:38 +0800
>>>
>>> I commented on almost identical patch for arm64 
>>>
>>> https://lore.kernel.org/all/20260126081334.699147-1-ruanjinjie@huawei.com/
>>>
>>> about moving the exclusion of CMA regions into the core crash code.
>>> The same comment applies to this one as well. Sorry I didn't mention that
>>> more explicitly.
>>
>> Thanks.
>>
>> So IIUC this patch is OK, but we should reduce the code duplication in
>> this area?
> 
> The patch is Ok in the sense it does not break anything :)
> 
> I'd like to see series with PATCH 1/3 moving the duplicated code from x86
> and powerpc to the crash_core.c and patches 2 and 3 adding arm64 and riscv
> support for CMA.

I agree that we should eliminate this duplication; I can also try to
post a standalone patch that reduces the redundant code as suggested.

> 
> Requiring refactoring upfront rather than fixing this afterwards makes
> maintainers life easier ;-)
> 
