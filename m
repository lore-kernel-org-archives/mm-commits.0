Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4687DC4361B
	for <mm-commits@archiver.kernel.org>; Fri, 18 Dec 2020 22:19:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0619323B7E
	for <mm-commits@archiver.kernel.org>; Fri, 18 Dec 2020 22:19:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725843AbgLRWSz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 18 Dec 2020 17:18:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725813AbgLRWSz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 18 Dec 2020 17:18:55 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 124B2C0617A7
        for <mm-commits@vger.kernel.org>; Fri, 18 Dec 2020 14:18:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description;
        bh=pc6txyVvOlrwNWi3sTdmcTTPq0af6atkBqUO7tGbAbI=; b=IMNQDtx8i5A3tfvsJG6/d/CoOW
        92oHH4C5HtPBDJNFJRagR7k02yyXTVI8ZZ+/Uu3w9HrXyP7rsvCypdlGuwTbf9l/P5NyxG3DuJb37
        9phde+5iwa3vjesFuMfIEfkudaX5sTZ1hqLxGRE+wv9h2XUHE6ad3DwbkraUCfRSPBf4jEPYsLCu3
        RIZ3RAIuvgOPcQYZdpypukp+bAm3Iq7I5z9t0/pnYKLMbrpj2eiXIQbMvqje6IBTz6b7f2qnB91vA
        I5hJYI9eqv08ccLVhC3BOXcT12KPZme+iyXi4QITTLSCLHwY+luIahhp9gOxGJul1I1L6ZHZKhKEc
        kYMlvq5w==;
Received: from [2601:1c0:6280:3f0::64ea]
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kqO4g-00071O-IR; Fri, 18 Dec 2020 22:18:11 +0000
Subject: Re: [patch 01/12] zlib: export S390 symbols for zlib modules
To:     Zaslonko Mikhail <zaslonko@linux.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        borntraeger@de.ibm.com, gor@linux.ibm.com, hca@linux.ibm.com,
        iii@linux.ibm.com, linux-mm@kvack.org, lkp@intel.com,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
References: <20201206061438.EIlu-Bvu8%akpm@linux-foundation.org>
 <13e195ba-413a-ebba-ea90-c3a15ad514ea@linux.ibm.com>
 <45544373-754c-ad37-e020-f4864b963852@infradead.org>
 <1d4cccc2-5e71-d09b-9b1b-03f30427af56@linux.ibm.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <dcbebf98-1313-f95d-b2dc-6c2a134439d2@infradead.org>
Date:   Fri, 18 Dec 2020 14:18:05 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <1d4cccc2-5e71-d09b-9b1b-03f30427af56@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 12/8/20 12:19 AM, Zaslonko Mikhail wrote:
> 
> 
> On 08.12.2020 01:45, Randy Dunlap wrote:
>> On 12/7/20 1:03 AM, Zaslonko Mikhail wrote:
>>> Hello,
>>>
>>> should we probably put these to lib/zlib_dfltcc/dfltcc_syms.c along with the other EXPORT_SYMBOL statements?
>>
>> Hi,
>> I didn't know about that file. :)
>>
>> That change makes sense. At least that's how some modules used
>> to do it. Not so much nowadays, but this one might as well
>> consistent within itself.
>>
>> Do you want to fix it or should I?
> 
> Please, go ahead.
> 
> Thanks.

Hi,

How do you feel about eliminating the dfltcc_syms.c file and
putting the EXPORT_SYMBOL()s in the source file(s) where they
occur?  as expressed in coding-style.rst:

In source files, separate functions with one blank line.  If the function is
exported, the **EXPORT** macro for it should follow immediately after the
closing function brace line.

(also move the MODULE_LICENSE() to a different source file.)

>>
>> Thanks.
>>
>>> Reviewed-by: Mikhail Zaslonko <zaslonko@linux.ibm.com>
>>>
>>> On 06.12.2020 07:14, Andrew Morton wrote:
>>>> From: Randy Dunlap <rdunlap@infradead.org>
>>>> Subject: zlib: export S390 symbols for zlib modules
>>>>
>>>> Fix build errors when ZLIB_INFLATE=m and ZLIB_DEFLATE=m and ZLIB_DFLTCC=y
>>>> by exporting the 2 needed symbols in dfltcc_inflate.c.


thanks.
-- 
~Randy

