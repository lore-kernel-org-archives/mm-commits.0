Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D40E3C433ED
	for <mm-commits@archiver.kernel.org>; Fri, 21 May 2021 09:06:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B62F6613AC
	for <mm-commits@archiver.kernel.org>; Fri, 21 May 2021 09:06:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234628AbhEUJH5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 May 2021 05:07:57 -0400
Received: from first.geanix.com ([116.203.34.67]:36438 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235351AbhEUJH4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 21 May 2021 05:07:56 -0400
X-Greylist: delayed 345 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 May 2021 05:07:55 EDT
Received: from [192.168.100.10] (unknown [185.233.254.173])
        by first.geanix.com (Postfix) with ESMTPSA id DBCFF46531B;
        Fri, 21 May 2021 09:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1621587645; bh=3xolAQOkDdfYsAWj/GpN99/E68e71DE4mOHkZNqSG4g=;
        h=Subject:To:References:From:Date:In-Reply-To;
        b=N6asiGwveQ6nZpu7zo7PJa+Kj4al5Q+wCRvSWzyEF3ca2V85c/g6BsLRr2WWwqQzq
         DyxRbwmPfaBQARb5qUKmFUEjJo7jSXaFW+x9ofyxkiCLlIP0EeGMCaCGcC/st5kVyG
         xR6MrcwyI6bhzsCau/aizvKew1twxPn1QofVBFuBetemM+kIpyGtVLZvZLYoW0WX/e
         UMAxfZdnR0Gicm7gvUcLETysAlMTrTVmaEmn/qF8Uu8v8LNNJwlEczTIRifkqXtljO
         L2EuLBBLTmAsC9RoXOnqTVxI4BJFKKAYIz22I+hSbyDTVkFgME06QuVwgG5WxPw1Xe
         ZvctaDlltXxAA==
Subject: Re: mmotm 2021-05-19-23-58 uploaded
 (drivers/iio/accel/fxls8962af-core.o)
To:     Randy Dunlap <rdunlap@infradead.org>, akpm@linux-foundation.org,
        broonie@kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-next@vger.kernel.org, mhocko@suse.cz,
        mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        linux-iio <linux-iio@vger.kernel.org>,
        Jonathan Cameron <jic23@kernel.org>
References: <20210520065918.KsmugQp47%akpm@linux-foundation.org>
 <0aa5599d-cd74-ea39-8acd-202582e76e15@infradead.org>
From:   Sean Nyekjaer <sean@geanix.com>
Message-ID: <40a21519-0755-74f6-da11-da9d0af4aab6@geanix.com>
Date:   Fri, 21 May 2021 11:00:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <0aa5599d-cd74-ea39-8acd-202582e76e15@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 21/05/2021 00.53, Randy Dunlap wrote:
> On 5/19/21 11:59 PM, akpm@linux-foundation.org wrote:
>> The mm-of-the-moment snapshot 2021-05-19-23-58 has been uploaded to
>>
>>    https://www.ozlabs.org/~akpm/mmotm/
>>
>> mmotm-readme.txt says
>>
>> README for mm-of-the-moment:
>>
>> https://www.ozlabs.org/~akpm/mmotm/
>>
>> This is a snapshot of my -mm patch queue.  Uploaded at random hopefully
>> more than once a week.
>>
>> You will need quilt to apply these patches to the latest Linus release (5.x
>> or 5.x-rcY).  The series file is in broken-out.tar.gz and is duplicated in
>> https://ozlabs.org/~akpm/mmotm/series
>>
>> The file broken-out.tar.gz contains two datestamp files: .DATE and
>> .DATE-yyyy-mm-dd-hh-mm-ss.  Both contain the string yyyy-mm-dd-hh-mm-ss,
>> followed by the base kernel version against which this patch series is to
>> be applied.
>>
>> This tree is partially included in linux-next.  To see which patches are
>> included in linux-next, consult the `series' file.  Only the patches
>> within the #NEXT_PATCHES_START/#NEXT_PATCHES_END markers are included in
>> linux-next.
> 
> on x86_64:
> (from linux-next, not mmotm)
> 
> CONFIG_FXLS8962AF=y
> CONFIG_FXLS8962AF_SPI=y
> but no I2C.
> 
> ld: drivers/iio/accel/fxls8962af-core.o: in function `fxls8962af_fifo_flush':
> fxls8962af-core.c:(.text+0x9d4): undefined reference to `i2c_verify_client'
> 
> Full randconfig file is attached.
> 
Thanks :)

It's fixed in:
https://lore.kernel.org/linux-iio/a3329058-2b2d-415a-5d2a-0bdf2f97d23d@geanix.com/T/#t

/Sean
