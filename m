Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01B1F18FC84
	for <mm-commits@vger.kernel.org>; Fri, 15 Nov 2024 11:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731670797; cv=none; b=ikBcJQ+6s2qzpIkzMJyJQ23EXGFxqpLu2uhDBOmVTDj+56E0D2qPkTv5V8p/Hz244Qekqk0j6rfDeFhnr0hUXvMbtQmGTIXQ/a75gg/tYgXTUFvAnNyHodP9v/cXN4LnImYU3kVPoBIkEe0RsuzDGd95XRj0+1b3wdQSqf1lHng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731670797; c=relaxed/simple;
	bh=z73EP7L2YEuXLGYjxcheTomIKNaXRNjlXEfKHqlPQcw=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=pVfIbDPn1Vt2ci9sx7UARBtUG9y7+TA3DFgGj3hArE0y2za8Apa4r1gqLGkre9WDdsIUw6/6MzvSmW9xktVVE9AHvBNHQUaTG3RuRO3wtzTym6/QxuZfQjBZnGoKiTEpRCGPwfC9lQVsMkXNkvnea4CntWRRtJvKu8jc1iWAs38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=AXjAP76m; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="AXjAP76m"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AFAYkqL021091;
	Fri, 15 Nov 2024 11:39:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=5keBdr
	2c96Cj4U5m43ZjYCZVtz+EZttXonQgygoUlp8=; b=AXjAP76mu1yxjZohj8VYnz
	AWOeQsTyJkvr9Hgp/qNIulybkKxjQMvE2EjIf2x3D3Hf7ishtFXwUIIqZUMGGhv3
	WV2DQnZ1QADofQ2XZsxFReFF2LrKyOqcqWuIKStqhN3AQODYYZiRSS0mwlpkrcCP
	geNp+BGgODhFJvi6t+SX0zOyQlfrJu98HOnsAEvSKgEFnVn37ulizgixmLhSgFeG
	zFpDttVHTwaqgUzOBDe45BfqdRWCwPN0FfLZgFmXRhKJHh/LE2mDe4yIC5zkwYYg
	PtH5QmhQ7/jnLGAXESsn47cSU+N/+Qf9OTOA/7upnYnlGDXE1bgWgh1JC8zJcERw
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42wrvkubrf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 15 Nov 2024 11:39:54 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 4AFBZkRB021483;
	Fri, 15 Nov 2024 11:39:53 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42wrvkubrc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 15 Nov 2024 11:39:53 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4AFBIGhN029724;
	Fri, 15 Nov 2024 11:39:52 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 42tkjmsadc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 15 Nov 2024 11:39:52 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4AFBdoCn17957290
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Nov 2024 11:39:50 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 46CAB20043;
	Fri, 15 Nov 2024 11:39:50 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2626420040;
	Fri, 15 Nov 2024 11:39:49 +0000 (GMT)
Received: from [9.39.29.135] (unknown [9.39.29.135])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 15 Nov 2024 11:39:48 +0000 (GMT)
Message-ID: <b308eff0-931d-446f-8ac6-7df347085ea6@linux.ibm.com>
Date: Fri, 15 Nov 2024 17:09:47 +0530
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [merged mm-stable]
 mm-kfence-add-a-new-kunit-test-test_use_after_free_read_nofault.patch removed
 from -mm tree
To: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
        ritesh.list@gmail.com, glider@google.com, elver@google.com,
        dvyukov@google.com
References: <20241115065003.1C2EFC4CECF@smtp.kernel.org>
Content-Language: en-US
From: Nirjhar Roy <nirjhar@linux.ibm.com>
In-Reply-To: <20241115065003.1C2EFC4CECF@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: _yIQMDrPBwRjn7cEXJ-mKGKNB9Q5IM1I
X-Proofpoint-GUID: 892gKORc0b36tMBPDYkq1PnK9qTmCRq4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 mlxscore=0
 phishscore=0 malwarescore=0 suspectscore=0 mlxlogscore=999
 lowpriorityscore=0 impostorscore=0 adultscore=0 spamscore=0 bulkscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2411150099

Thank you for the update.

On 11/15/24 12:19, Andrew Morton wrote:
> The quilt patch titled
>       Subject: mm/kfence: add a new kunit test test_use_after_free_read_nofault()
> has been removed from the -mm tree.  Its filename was
>       mm-kfence-add-a-new-kunit-test-test_use_after_free_read_nofault.patch
>
> This patch was dropped because it was merged into the mm-stable branch
> of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>
> ------------------------------------------------------
> From: Nirjhar Roy <nirjhar@linux.ibm.com>
> Subject: mm/kfence: add a new kunit test test_use_after_free_read_nofault()
> Date: Fri, 18 Oct 2024 23:16:01 +0530
>
> Faults from copy_from_kernel_nofault() need to be handled by fixup table
> and should not be handled by kfence.  Otherwise while reading /proc/kcore
> which uses copy_from_kernel_nofault(), kfence can generate false
> negatives.  This can happen when /proc/kcore ends up reading an unmapped
> address from kfence pool.
>
> Let's add a testcase to cover this case.
>
> Link: https://lkml.kernel.org/r/210e561f7845697a32de44b643393890f180069f.1729272697.git.ritesh.list@gmail.com
> Signed-off-by: Nirjhar Roy <nirjhar@linux.ibm.com>
> Co-developed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
> Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
> Tested-by: Marco Elver <elver@google.com>
> Reviewed-by: Marco Elver <elver@google.com>
> Cc: Alexander Potapenko <glider@google.com>
> Cc: Dmitry Vyukov <dvyukov@google.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>   mm/kfence/kfence_test.c |   17 +++++++++++++++++
>   1 file changed, 17 insertions(+)
>
> --- a/mm/kfence/kfence_test.c~mm-kfence-add-a-new-kunit-test-test_use_after_free_read_nofault
> +++ a/mm/kfence/kfence_test.c
> @@ -383,6 +383,22 @@ static void test_use_after_free_read(str
>   	KUNIT_EXPECT_TRUE(test, report_matches(&expect));
>   }
>   
> +static void test_use_after_free_read_nofault(struct kunit *test)
> +{
> +	const size_t size = 32;
> +	char *addr;
> +	char dst;
> +	int ret;
> +
> +	setup_test_cache(test, size, 0, NULL);
> +	addr = test_alloc(test, size, GFP_KERNEL, ALLOCATE_ANY);
> +	test_free(addr);
> +	/* Use after free with *_nofault() */
> +	ret = copy_from_kernel_nofault(&dst, addr, 1);
> +	KUNIT_EXPECT_EQ(test, ret, -EFAULT);
> +	KUNIT_EXPECT_FALSE(test, report_available());
> +}
> +
>   static void test_double_free(struct kunit *test)
>   {
>   	const size_t size = 32;
> @@ -780,6 +796,7 @@ static struct kunit_case kfence_test_cas
>   	KFENCE_KUNIT_CASE(test_out_of_bounds_read),
>   	KFENCE_KUNIT_CASE(test_out_of_bounds_write),
>   	KFENCE_KUNIT_CASE(test_use_after_free_read),
> +	KFENCE_KUNIT_CASE(test_use_after_free_read_nofault),
>   	KFENCE_KUNIT_CASE(test_double_free),
>   	KFENCE_KUNIT_CASE(test_invalid_addr_free),
>   	KFENCE_KUNIT_CASE(test_corruption),
> _
>
> Patches currently in -mm which might be from nirjhar@linux.ibm.com are
>
>
-- 
---
Nirjhar Roy
Linux Kernel Developer
IBM, Bangalore

