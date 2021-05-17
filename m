Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF053C43460
	for <mm-commits@archiver.kernel.org>; Mon, 17 May 2021 05:58:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1CA1611CC
	for <mm-commits@archiver.kernel.org>; Mon, 17 May 2021 05:58:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234592AbhEQF7n (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 17 May 2021 01:59:43 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:20092 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234617AbhEQF7i (ORCPT
        <rfc822;mm-commits@vger.kernel.org>);
        Mon, 17 May 2021 01:59:38 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14H5Y9WP012706;
        Mon, 17 May 2021 01:57:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=516WN+OrgBfPOap0l8Avctex4U8iunkCNLSQRaLDJ+0=;
 b=GCdYQaqIKDJ2hxpuOKJk3DSP8yLh26r4sZD27dhpW+CKT+8b0DbFsTAJoqjpTIw8Qd/Z
 xvfoRkJOoMWnQx+qSBFE3yj0I9PxSkdyV2fkVTJMZNZYgis6Doog+P9rqWQDiBKTGb8X
 JX34w+c53BQeik0UZ93Pf8fUuKdxtFVeSWKl9qPXM4yPR1I3Pij5dh05O13tebPoHjHc
 Gp2lcvIK57btB5dFGhPXZ4E0m1C3o5b0vf0BXqvBsN9O/ink0aGoQghgHD6x8CGWz+tD
 H8CAgYPs5b7uzj+SkGr7V7GGop+w9wZ5CHwDvuSpuZgcvNEyOO//TsdyBLvQx9XAZ6AN tA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38kjderexm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 May 2021 01:57:57 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14H5Y91N012697;
        Mon, 17 May 2021 01:57:57 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38kjderex7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 May 2021 01:57:57 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14H5vtKR018466;
        Mon, 17 May 2021 05:57:55 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 38j5x7rk1h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 May 2021 05:57:55 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14H5vqFN38797710
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 May 2021 05:57:53 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D8D0411C04C;
        Mon, 17 May 2021 05:57:52 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1485511C04A;
        Mon, 17 May 2021 05:57:51 +0000 (GMT)
Received: from [9.199.40.240] (unknown [9.199.40.240])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 17 May 2021 05:57:50 +0000 (GMT)
Subject: Re: +
 mm-mremap-use-range-flush-that-does-tlb-and-page-walk-cache-flush-fix.patch
 added to -mm tree
To:     akpm@linux-foundation.org, christophe.leroy@csgroup.eu,
        joel@joelfernandes.org, kaleshsingh@google.com,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        naresh.kamboju@linaro.org, npiggin@gmail.com, sfr@canb.auug.org.au
References: <20210514220959.IXjn-Z0ga%akpm@linux-foundation.org>
From:   "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Message-ID: <8eedb441-a612-1ec8-8bf7-b40184de9f6f@linux.ibm.com>
Date:   Mon, 17 May 2021 11:27:50 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
In-Reply-To: <20210514220959.IXjn-Z0ga%akpm@linux-foundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: WKuS8FEjYrSeoGM18ojW_kDRTG3kt8nH
X-Proofpoint-ORIG-GUID: yl5s6jn_YTTrIScryjzy8dDU94ZlSZXt
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-17_01:2021-05-12,2021-05-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 impostorscore=0
 suspectscore=0 phishscore=0 bulkscore=0 mlxlogscore=999 priorityscore=1501
 clxscore=1011 lowpriorityscore=0 malwarescore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105170039
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 5/15/21 3:39 AM, akpm@linux-foundation.org wrote:
> The patch titled
>       Subject: mm-mremap-use-range-flush-that-does-tlb-and-page-walk-cache-flush-fix
> has been added to the -mm tree.  Its filename is
>       mm-mremap-use-range-flush-that-does-tlb-and-page-walk-cache-flush-fix.patch
> 
> This patch should soon appear at
>      https://ozlabs.org/~akpm/mmots/broken-out/mm-mremap-use-range-flush-that-does-tlb-and-page-walk-cache-flush-fix.patch
> and later at
>      https://ozlabs.org/~akpm/mmotm/broken-out/mm-mremap-use-range-flush-that-does-tlb-and-page-walk-cache-flush-fix.patch
> 
> Before you just go and hit "reply", please:
>     a) Consider who else should be cc'ed
>     b) Prefer to cc a suitable mailing list as well
>     c) Ideally: find the original patch on the mailing list and do a
>        reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next and is updated
> there every 3-4 working days
> 
> ------------------------------------------------------
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: mm-mremap-use-range-flush-that-does-tlb-and-page-walk-cache-flush-fix
> 
> fix build
> 
> Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
> Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
> Cc: Joel Fernandes <joel@joelfernandes.org>
> Cc: Kalesh Singh <kaleshsingh@google.com>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Nicholas Piggin <npiggin@gmail.com>
> Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>   mm/mremap.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/mm/mremap.c~mm-mremap-use-range-flush-that-does-tlb-and-page-walk-cache-flush-fix
> +++ a/mm/mremap.c
> @@ -216,7 +216,7 @@ static inline void flush_pte_tlb_pwc_ran
>   					   unsigned long start,
>   					   unsigned long end)
>   {
> -	return flush_tlb_range(vma, start, end);
> +	flush_tlb_range(vma, start, end);
>   }
>   #endif
>   
> _


Thanks for catching this. This is required because on some 
architectures, flush_tlb_range have non void returns. For example on 
parisc we have

int __flush_tlb_range(unsigned long sid,
	unsigned long start, unsigned long end);

#define flush_tlb_range(vma, start, end) \
	__flush_tlb_range((vma)->vm_mm->context, start, end)



-aneesh
