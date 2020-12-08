Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52079C433FE
	for <mm-commits@archiver.kernel.org>; Tue,  8 Dec 2020 00:46:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0021B23A1C
	for <mm-commits@archiver.kernel.org>; Tue,  8 Dec 2020 00:46:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726055AbgLHAqA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Dec 2020 19:46:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726231AbgLHAp7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 7 Dec 2020 19:45:59 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A34FC061749
        for <mm-commits@vger.kernel.org>; Mon,  7 Dec 2020 16:45:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description;
        bh=z4nhkVHGdLgG6UYZT44p/Vv/98uc1oAVtyG19MrBtHI=; b=rSB/G5i9meD+pjqI0BSJN9sm/P
        A1y/vuxsjMB69CPlBoFKYooG4t7918SnhULpt/wQYY5i7ZFZHqtbkwjV2QVj9Q93MqbDP/q4xLehh
        4IpoK9OticNmftDiPn6fw2K4CUNigZ+UDXEuJM7SRdA/h2HytRJpQB/yVGouWtGx+X+s52XGQ53AP
        eclNimY47xF7HzoBgZPh+S4KQcmn7qHg83fShdAMEsLbdM6aQZCFQgfH7eiSx2cigtzxwkWK1wWfD
        iqcfRXZ+kysLmgqQI93e8wrDDAKhGIMHtMnf29ZuB2/Qlo+D7Gp4fidyXwqSh/3EyJcD6XkNMnkyB
        A8BfzBmQ==;
Received: from [2601:1c0:6280:3f0::1494]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kmR80-0008Ad-GI; Tue, 08 Dec 2020 00:45:16 +0000
Subject: Re: [patch 01/12] zlib: export S390 symbols for zlib modules
To:     Zaslonko Mikhail <zaslonko@linux.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        borntraeger@de.ibm.com, gor@linux.ibm.com, hca@linux.ibm.com,
        iii@linux.ibm.com, linux-mm@kvack.org, lkp@intel.com,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
References: <20201206061438.EIlu-Bvu8%akpm@linux-foundation.org>
 <13e195ba-413a-ebba-ea90-c3a15ad514ea@linux.ibm.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <45544373-754c-ad37-e020-f4864b963852@infradead.org>
Date:   Mon, 7 Dec 2020 16:45:09 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <13e195ba-413a-ebba-ea90-c3a15ad514ea@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 12/7/20 1:03 AM, Zaslonko Mikhail wrote:
> Hello,
> 
> should we probably put these to lib/zlib_dfltcc/dfltcc_syms.c along with the other EXPORT_SYMBOL statements?

Hi,
I didn't know about that file. :)

That change makes sense. At least that's how some modules used
to do it. Not so much nowadays, but this one might as well
consistent within itself.

Do you want to fix it or should I?

Thanks.

> Reviewed-by: Mikhail Zaslonko <zaslonko@linux.ibm.com>
> 
> On 06.12.2020 07:14, Andrew Morton wrote:
>> From: Randy Dunlap <rdunlap@infradead.org>
>> Subject: zlib: export S390 symbols for zlib modules
>>
>> Fix build errors when ZLIB_INFLATE=m and ZLIB_DEFLATE=m and ZLIB_DFLTCC=y
>> by exporting the 2 needed symbols in dfltcc_inflate.c.
>>
>> Fixes these build errors:
>>
>> ERROR: modpost: "dfltcc_inflate" [lib/zlib_inflate/zlib_inflate.ko] undefined!
>> ERROR: modpost: "dfltcc_can_inflate" [lib/zlib_inflate/zlib_inflate.ko] undefined!
>>
>> Link: https://lkml.kernel.org/r/20201123191712.4882-1-rdunlap@infradead.org
>> Fixes: 126196100063 ("lib/zlib: add s390 hardware support for kernel zlib_inflate")
>> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
>> Reported-by: kernel test robot <lkp@intel.com>
>> Acked-by: Ilya Leoshkevich <iii@linux.ibm.com>
>> Cc: Mikhail Zaslonko <zaslonko@linux.ibm.com>
>> Cc: Heiko Carstens <hca@linux.ibm.com>
>> Cc: Vasily Gorbik <gor@linux.ibm.com>
>> Cc: Christian Borntraeger <borntraeger@de.ibm.com>
>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>> ---
>>
>>  lib/zlib_dfltcc/dfltcc_inflate.c |    3 +++
>>  1 file changed, 3 insertions(+)
>>
>> --- a/lib/zlib_dfltcc/dfltcc_inflate.c~zlib-export-s390-symbols-for-zlib-modules
>> +++ a/lib/zlib_dfltcc/dfltcc_inflate.c
>> @@ -4,6 +4,7 @@
>>  #include "dfltcc_util.h"
>>  #include "dfltcc.h"
>>  #include <asm/setup.h>
>> +#include <linux/export.h>
>>  #include <linux/zutil.h>
>>  
>>  /*
>> @@ -29,6 +30,7 @@ int dfltcc_can_inflate(
>>      return is_bit_set(dfltcc_state->af.fns, DFLTCC_XPND) &&
>>                 is_bit_set(dfltcc_state->af.fmts, DFLTCC_FMT0);
>>  }
>> +EXPORT_SYMBOL(dfltcc_can_inflate);
>>  
>>  static int dfltcc_was_inflate_used(
>>      z_streamp strm
>> @@ -147,3 +149,4 @@ dfltcc_inflate_action dfltcc_inflate(
>>      return (cc == DFLTCC_CC_OP1_TOO_SHORT || cc == DFLTCC_CC_OP2_TOO_SHORT) ?
>>          DFLTCC_INFLATE_BREAK : DFLTCC_INFLATE_CONTINUE;
>>  }
>> +EXPORT_SYMBOL(dfltcc_inflate);
>> _
>>


-- 
~Randy
Reported-by: Randy Dunlap <rdunlap@infradead.org>
