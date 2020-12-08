Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BF2EC433FE
	for <mm-commits@archiver.kernel.org>; Tue,  8 Dec 2020 08:20:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E4B323A5B
	for <mm-commits@archiver.kernel.org>; Tue,  8 Dec 2020 08:20:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727998AbgLHIUD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Dec 2020 03:20:03 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:16352 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726734AbgLHIUD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Dec 2020 03:20:03 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B88EjwX102362;
        Tue, 8 Dec 2020 03:19:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=I6pqXL0B9swGQcYt1Khwuq4HRuBDMUebtYmBLP1MNXs=;
 b=jcgGM4oFZ66W6Sq+Ng2qhtOUqWMw+YrtHoltYSGje8XHQnO53MirEOeCdmo/PslsSBfp
 po8nTv07gyn6DFZIbOa95aonHFJRYf0L/gskmTtCgAS8pOggjKBgMNK7Z9EK/Lb3knkc
 xEvup2e0mGW4K9Q2Hx2hS8bre2Hhm9jem2fc5iGzxmDcvkjthvuXMGpF03hUAWR3i4Dd
 Ya5c5OGZy2l8shHnKEhReK/ZTK8+SyW7LiJ2m0ASUZnntkrKUuZ4kaJ8ydvrtay89cxw
 Ij63S5kNLMsGw5Ys3Zyz/bPiYDF+FyxrpSB4DUGUrB8S70U61qT7gtvFVnEprjXRpdTD ew== 
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35a5tcr4bx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Dec 2020 03:19:15 -0500
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B88C1oT003290;
        Tue, 8 Dec 2020 08:19:14 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma02dal.us.ibm.com with ESMTP id 3581u9kra7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Dec 2020 08:19:14 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B88JCgq22479118
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Dec 2020 08:19:12 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 28663BE053;
        Tue,  8 Dec 2020 08:19:12 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 309B3BE056;
        Tue,  8 Dec 2020 08:19:09 +0000 (GMT)
Received: from [9.171.50.178] (unknown [9.171.50.178])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTPS;
        Tue,  8 Dec 2020 08:19:08 +0000 (GMT)
Subject: Re: [patch 01/12] zlib: export S390 symbols for zlib modules
To:     Randy Dunlap <rdunlap@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        borntraeger@de.ibm.com, gor@linux.ibm.com, hca@linux.ibm.com,
        iii@linux.ibm.com, linux-mm@kvack.org, lkp@intel.com,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
References: <20201206061438.EIlu-Bvu8%akpm@linux-foundation.org>
 <13e195ba-413a-ebba-ea90-c3a15ad514ea@linux.ibm.com>
 <45544373-754c-ad37-e020-f4864b963852@infradead.org>
From:   Zaslonko Mikhail <zaslonko@linux.ibm.com>
Message-ID: <1d4cccc2-5e71-d09b-9b1b-03f30427af56@linux.ibm.com>
Date:   Tue, 8 Dec 2020 09:19:08 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <45544373-754c-ad37-e020-f4864b963852@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-08_03:2020-12-04,2020-12-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 impostorscore=0 mlxlogscore=999 mlxscore=0 adultscore=0 clxscore=1015
 lowpriorityscore=0 spamscore=0 priorityscore=1501 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012080046
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org



On 08.12.2020 01:45, Randy Dunlap wrote:
> On 12/7/20 1:03 AM, Zaslonko Mikhail wrote:
>> Hello,
>>
>> should we probably put these to lib/zlib_dfltcc/dfltcc_syms.c along with the other EXPORT_SYMBOL statements?
> 
> Hi,
> I didn't know about that file. :)
> 
> That change makes sense. At least that's how some modules used
> to do it. Not so much nowadays, but this one might as well
> consistent within itself.
> 
> Do you want to fix it or should I?

Please, go ahead.

Thanks.

> 
> Thanks.
> 
>> Reviewed-by: Mikhail Zaslonko <zaslonko@linux.ibm.com>
>>
>> On 06.12.2020 07:14, Andrew Morton wrote:
>>> From: Randy Dunlap <rdunlap@infradead.org>
>>> Subject: zlib: export S390 symbols for zlib modules
>>>
>>> Fix build errors when ZLIB_INFLATE=m and ZLIB_DEFLATE=m and ZLIB_DFLTCC=y
>>> by exporting the 2 needed symbols in dfltcc_inflate.c.
>>>
>>> Fixes these build errors:
>>>
>>> ERROR: modpost: "dfltcc_inflate" [lib/zlib_inflate/zlib_inflate.ko] undefined!
>>> ERROR: modpost: "dfltcc_can_inflate" [lib/zlib_inflate/zlib_inflate.ko] undefined!
>>>
>>> Link: https://lkml.kernel.org/r/20201123191712.4882-1-rdunlap@infradead.org
>>> Fixes: 126196100063 ("lib/zlib: add s390 hardware support for kernel zlib_inflate")
>>> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
>>> Reported-by: kernel test robot <lkp@intel.com>
>>> Acked-by: Ilya Leoshkevich <iii@linux.ibm.com>
>>> Cc: Mikhail Zaslonko <zaslonko@linux.ibm.com>
>>> Cc: Heiko Carstens <hca@linux.ibm.com>
>>> Cc: Vasily Gorbik <gor@linux.ibm.com>
>>> Cc: Christian Borntraeger <borntraeger@de.ibm.com>
>>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>>> ---
>>>
>>>  lib/zlib_dfltcc/dfltcc_inflate.c |    3 +++
>>>  1 file changed, 3 insertions(+)
>>>
>>> --- a/lib/zlib_dfltcc/dfltcc_inflate.c~zlib-export-s390-symbols-for-zlib-modules
>>> +++ a/lib/zlib_dfltcc/dfltcc_inflate.c
>>> @@ -4,6 +4,7 @@
>>>  #include "dfltcc_util.h"
>>>  #include "dfltcc.h"
>>>  #include <asm/setup.h>
>>> +#include <linux/export.h>
>>>  #include <linux/zutil.h>
>>>  
>>>  /*
>>> @@ -29,6 +30,7 @@ int dfltcc_can_inflate(
>>>      return is_bit_set(dfltcc_state->af.fns, DFLTCC_XPND) &&
>>>                 is_bit_set(dfltcc_state->af.fmts, DFLTCC_FMT0);
>>>  }
>>> +EXPORT_SYMBOL(dfltcc_can_inflate);
>>>  
>>>  static int dfltcc_was_inflate_used(
>>>      z_streamp strm
>>> @@ -147,3 +149,4 @@ dfltcc_inflate_action dfltcc_inflate(
>>>      return (cc == DFLTCC_CC_OP1_TOO_SHORT || cc == DFLTCC_CC_OP2_TOO_SHORT) ?
>>>          DFLTCC_INFLATE_BREAK : DFLTCC_INFLATE_CONTINUE;
>>>  }
>>> +EXPORT_SYMBOL(dfltcc_inflate);
>>> _
>>>
> 
> 
