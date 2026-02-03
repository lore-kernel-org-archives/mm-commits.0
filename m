Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D23F02ECE8F
	for <mm-commits@vger.kernel.org>; Tue,  3 Feb 2026 17:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770140854; cv=none; b=mIX6TUs4SOZYPX1c1dljQblSZ/zI3LvHDgegrBE24hzyNpq1Tdn1HnSQ1K8SOJGxYa9noVCDubtCkviheQZgad8D/iWvtLBmn8eEw7gxfXJvSw2BOw5R8jEz/hJs25YP3HU10I7K2NB4o6NZf7q3/ErWFXXnYt9bE6K3CxYRJkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770140854; c=relaxed/simple;
	bh=+1Rg0Qo9JKMlh5VR6orLM0BdH2Job7+LNL+Ppjinj+w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=diyjC5f03M7QmbPb1aS4yun5MsWWsNRkEXmoW03dYhEgy2lwU6FXOfcemBt3IjCQl3lUHsIYZMCEg/6ofLTLyufsLK3ngbAY/RYvmUlWKjS83gkd/1GAudnMQkq91k2feHBsVgeCzOaY0Vh/Zw8YHSPs2USB2CpuYvdH//9Kjcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=m9ScTRYE; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="m9ScTRYE"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 613ARvot018639;
	Tue, 3 Feb 2026 17:45:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=+1Rg0Q
	o9JKMlh5VR6orLM0BdH2Job7+LNL+Ppjinj+w=; b=m9ScTRYEzUfKqNeVQCbZ+Q
	Qf5MG2Ibd0vbeJ2ISXaPI4vBtw3s2T8ZmUGbmzUMrdtUnxC++y8+Wu8w7W9wXiGP
	T0fyUnGTB6nvVoH9ZpItcfSQ4hjOLoKYonk2lVLcLE9Q1IW3UY13BBAwQSpQRYCi
	vCjWsmQ7jH5IbnkhUv8yixpAHxf3yjTSZWF53Nn8FBTt7KkrWD6XbM0NMvTIHpM2
	xtgihifT6safw+Cvxs4hVLJdcPeO9CqguBDhshi/SiFb0EY6RDnEX26DElYI50px
	9ThKqe3NtnbjaNLLlfJ4mFdzePFcG9zv2Zdn0uvl4I5jGSt9wSQBFYKmbFBBwmBQ
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c175mvdwk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 03 Feb 2026 17:45:24 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 613HjOju016945;
	Tue, 3 Feb 2026 17:45:24 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c175mvdwd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 03 Feb 2026 17:45:24 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 613F9Hk0029064;
	Tue, 3 Feb 2026 17:45:23 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4c1v2sa6qt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 03 Feb 2026 17:45:23 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 613HjLuQ47841660
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 3 Feb 2026 17:45:21 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 49DD720043;
	Tue,  3 Feb 2026 17:45:21 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0716C20040;
	Tue,  3 Feb 2026 17:45:14 +0000 (GMT)
Received: from [9.124.212.68] (unknown [9.124.212.68])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  3 Feb 2026 17:45:13 +0000 (GMT)
Message-ID: <3d7ae169-1689-4eb3-a18d-96c88a624d5f@linux.ibm.com>
Date: Tue, 3 Feb 2026 23:15:12 +0530
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [merged mm-nonmm-stable]
 riscv-kexec-add-support-for-crashkernel-cma-reservation.patch removed from
 -mm tree
To: Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>
Cc: mm-commits@vger.kernel.org, vishal.moola@gmail.com,
        songshuaishuai@tinylab.org, samuel.holland@sifive.com,
        rdunlap@infradead.org, pawan.kumar.gupta@linux.intel.com,
        palmer@dabbelt.com, mingo@kernel.org, lirongqing@baidu.com,
        leitao@debian.org, kevin.brodsky@arm.com, kees@kernel.org,
        fvdl@google.com, elver@google.com, cuiyunhui@bytedance.com,
        corbet@lwn.net, bp@alien8.de, bjorn@rivosinc.com, bhelgaas@google.com,
        arnd@arndb.de, aou@eecs.berkeley.edu, alex@ghiti.fr,
        ruanjinjie@huawei.com
References: <20260201001710.A3CE5C4CEF1@smtp.kernel.org>
 <aX9jPbkG7QYNWH73@kernel.org>
 <20260202125404.343361f6696777efc3acaab1@linux-foundation.org>
 <aYGnODFtgjyiRLB9@kernel.org>
 <20260203082703.bae7a2b786da8d74f5ebf851@linux-foundation.org>
Content-Language: en-US
From: Sourabh Jain <sourabhjain@linux.ibm.com>
In-Reply-To: <20260203082703.bae7a2b786da8d74f5ebf851@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: IQVqS1rPo5CAdfMx2qRjIyxjkpOeMQMD
X-Authority-Analysis: v=2.4 cv=VcX6/Vp9 c=1 sm=1 tr=0 ts=69823434 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=i0EeH86SAAAA:8 a=YHaCEJf6j7sQuHjAKnwA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: na2ZgQQEuUVjOllwlBrDgS4aWz_bCuD5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjAzMDEzOSBTYWx0ZWRfXyEZCRl/3/MhR
 noYee1irFrj9ZQJKKzYA/tYNwCFKPU6MA7cE7+imbaC/2arYcOXAT2Lsrck3xl9rj/TRDc5FOmi
 2i8NshbSQwesZZMPaVGVJnZfHSd32Hrq3x7Mir6UQbH3tT61PFZHE74TVrBB241jc3me0BF+8PY
 Of0QzrHEg755MHJ1QLh1w/D9ksap3E3xe/fr0KAlB0Ij8VQCC1do33tWrSCjALgPJoEI4ASx7z1
 q1N+v8ZFyO+gvINnNa9dLu18xs1HY1vqzVX5ptKdcMxQA53XAuoRkdOqOecrlsEcgED7jKkOPmG
 Ul+r+E8tjVm5iysJ/7m4HQyB1odaiyDfPG3VvIDjkdKyBFq6hyJd1SaOEVhI4KapxwkxLZ+Z/eI
 hGWovsudaPBR9TEXPf+K5i66DTVo7IG8LHIyiHHja1iD0J7XzlSF/nWdoDuBDe9sJ1/BdZlgEsB
 F2t+O9rERO2HuD2lUTQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-03_05,2026-02-02_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 suspectscore=0 spamscore=0 adultscore=0
 bulkscore=0 phishscore=0 lowpriorityscore=0 impostorscore=0 clxscore=1011
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2601150000 definitions=main-2602030139



On 03/02/26 21:57, Andrew Morton wrote:
> On Tue, 3 Feb 2026 09:43:52 +0200 Mike Rapoport <rppt@kernel.org> wrote:
>
>> On Mon, Feb 02, 2026 at 12:54:04PM -0800, Andrew Morton wrote:
>>> On Sun, 1 Feb 2026 15:29:17 +0100 Mike Rapoport <rppt@kernel.org> wrote:
>>>
>>>>> From: Jinjie Ruan <ruanjinjie@huawei.com>
>>>>> Subject: riscv: kexec: add support for crashkernel CMA reservation
>>>>> Date: Mon, 26 Jan 2026 16:07:38 +0800
>>>> I commented on almost identical patch for arm64
>>>>
>>>> https://lore.kernel.org/all/20260126081334.699147-1-ruanjinjie@huawei.com/
>>>>
>>>> about moving the exclusion of CMA regions into the core crash code.
>>>> The same comment applies to this one as well. Sorry I didn't mention that
>>>> more explicitly.
>>> Thanks.
>>>
>>> So IIUC this patch is OK, but we should reduce the code duplication in
>>> this area?
>> The patch is Ok in the sense it does not break anything :)
> No probs, I've dropped "riscv: kexec: add support for crashkernel CMA
> reservation" from mm.git.
>
>> I'd like to see series with PATCH 1/3 moving the duplicated code from x86
>> and powerpc to the crash_core.c and patches 2 and 3 adding arm64 and riscv
>> support for CMA.
> I'm not sure which kind soul will be doing this work!
>
> I've cc'ed Jinjie Ruan regarding "arm64: kexec: Add support for
> crashkernel CMA reservation" and Sourabh Jain regarding "powerpc/kdump:
> Add support for crashkernel CMA reservation".

I agree that we should avoid code duplication by handling CMA crashkernel
exclusion in a more generic way.

Would it make sense to handle the exclusion of all crash memory ranges
(including crashk_res, crashk_cma, and crashk_low) at the generic level?

Andrew, I can send the patch series you referred above.

- Sourabh
