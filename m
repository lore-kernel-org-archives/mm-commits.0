Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 836A5C4361B
	for <mm-commits@archiver.kernel.org>; Mon,  7 Dec 2020 09:06:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4AB5B23343
	for <mm-commits@archiver.kernel.org>; Mon,  7 Dec 2020 09:06:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726083AbgLGJGH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Dec 2020 04:06:07 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:53972 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726512AbgLGJGH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 7 Dec 2020 04:06:07 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B792M32159582;
        Mon, 7 Dec 2020 04:03:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=FtOAwr0iOoIcWtqIc9AQQlgiAQLd3n5RPQ3nwlm690s=;
 b=mkdt748xokBag5cq1bSc7DL3CRWhpfsZvqsQJlCJQVX/R/3A+F7TnuJCcQlNASgHHsB3
 NtpuazegJ8+whSC1F9d0jAT8ub2ePSeyl9h3IF3TfUc7iGNhhKQGDcyscmGisNVXJ+OM
 1u4W+rqp754pUHPDZBTUxJEzrhAMT7r+yntHYUwzTHnKoz5fp/VoZNCD49VUREZkkF+O
 BPW/o6+s/iMaLQ5nDJjmR4rp3ilI1TFnHbfRFZsr12SJkh4O4gT+sPNPtyFn2DzgZ9tH
 gwCARQyt9NGZaXtkJs5LKHmAvjMCT4Ersd0nHG+IoFjv/Hbz3MWTxZFvJDtBC5Fz4s8+ VQ== 
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 358r4urv9f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Dec 2020 04:03:38 -0500
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B792tS3022024;
        Mon, 7 Dec 2020 09:03:33 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma04dal.us.ibm.com with ESMTP id 3581u91t9m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Dec 2020 09:03:33 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B793VPD19988844
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Dec 2020 09:03:31 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8622D6E04C;
        Mon,  7 Dec 2020 09:03:31 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C4D8E6E053;
        Mon,  7 Dec 2020 09:03:28 +0000 (GMT)
Received: from [9.171.65.107] (unknown [9.171.65.107])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTPS;
        Mon,  7 Dec 2020 09:03:28 +0000 (GMT)
Subject: Re: [patch 01/12] zlib: export S390 symbols for zlib modules
To:     Andrew Morton <akpm@linux-foundation.org>, borntraeger@de.ibm.com,
        gor@linux.ibm.com, hca@linux.ibm.com, iii@linux.ibm.com,
        linux-mm@kvack.org, lkp@intel.com, mm-commits@vger.kernel.org,
        rdunlap@infradead.org, torvalds@linux-foundation.org
References: <20201206061438.EIlu-Bvu8%akpm@linux-foundation.org>
From:   Zaslonko Mikhail <zaslonko@linux.ibm.com>
Message-ID: <13e195ba-413a-ebba-ea90-c3a15ad514ea@linux.ibm.com>
Date:   Mon, 7 Dec 2020 10:03:30 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201206061438.EIlu-Bvu8%akpm@linux-foundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-07_05:2020-12-04,2020-12-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 impostorscore=0 malwarescore=0 adultscore=0 mlxlogscore=999 clxscore=1011
 spamscore=0 priorityscore=1501 lowpriorityscore=0 bulkscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012070054
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Hello,

should we probably put these to lib/zlib_dfltcc/dfltcc_syms.c along with the other EXPORT_SYMBOL statements?

Reviewed-by: Mikhail Zaslonko <zaslonko@linux.ibm.com>

On 06.12.2020 07:14, Andrew Morton wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
> Subject: zlib: export S390 symbols for zlib modules
> 
> Fix build errors when ZLIB_INFLATE=m and ZLIB_DEFLATE=m and ZLIB_DFLTCC=y
> by exporting the 2 needed symbols in dfltcc_inflate.c.
> 
> Fixes these build errors:
> 
> ERROR: modpost: "dfltcc_inflate" [lib/zlib_inflate/zlib_inflate.ko] undefined!
> ERROR: modpost: "dfltcc_can_inflate" [lib/zlib_inflate/zlib_inflate.ko] undefined!
> 
> Link: https://lkml.kernel.org/r/20201123191712.4882-1-rdunlap@infradead.org
> Fixes: 126196100063 ("lib/zlib: add s390 hardware support for kernel zlib_inflate")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Reported-by: kernel test robot <lkp@intel.com>
> Acked-by: Ilya Leoshkevich <iii@linux.ibm.com>
> Cc: Mikhail Zaslonko <zaslonko@linux.ibm.com>
> Cc: Heiko Carstens <hca@linux.ibm.com>
> Cc: Vasily Gorbik <gor@linux.ibm.com>
> Cc: Christian Borntraeger <borntraeger@de.ibm.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  lib/zlib_dfltcc/dfltcc_inflate.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> --- a/lib/zlib_dfltcc/dfltcc_inflate.c~zlib-export-s390-symbols-for-zlib-modules
> +++ a/lib/zlib_dfltcc/dfltcc_inflate.c
> @@ -4,6 +4,7 @@
>  #include "dfltcc_util.h"
>  #include "dfltcc.h"
>  #include <asm/setup.h>
> +#include <linux/export.h>
>  #include <linux/zutil.h>
>  
>  /*
> @@ -29,6 +30,7 @@ int dfltcc_can_inflate(
>      return is_bit_set(dfltcc_state->af.fns, DFLTCC_XPND) &&
>                 is_bit_set(dfltcc_state->af.fmts, DFLTCC_FMT0);
>  }
> +EXPORT_SYMBOL(dfltcc_can_inflate);
>  
>  static int dfltcc_was_inflate_used(
>      z_streamp strm
> @@ -147,3 +149,4 @@ dfltcc_inflate_action dfltcc_inflate(
>      return (cc == DFLTCC_CC_OP1_TOO_SHORT || cc == DFLTCC_CC_OP2_TOO_SHORT) ?
>          DFLTCC_INFLATE_BREAK : DFLTCC_INFLATE_CONTINUE;
>  }
> +EXPORT_SYMBOL(dfltcc_inflate);
> _
> 
