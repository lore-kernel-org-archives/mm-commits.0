Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14650C433DB
	for <mm-commits@archiver.kernel.org>; Wed, 24 Mar 2021 22:14:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D299961A1D
	for <mm-commits@archiver.kernel.org>; Wed, 24 Mar 2021 22:14:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232252AbhCXWOA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Mar 2021 18:14:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232148AbhCXWNu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 24 Mar 2021 18:13:50 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C7D5C06174A
        for <mm-commits@vger.kernel.org>; Wed, 24 Mar 2021 15:13:50 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id u10so508368ilb.0
        for <mm-commits@vger.kernel.org>; Wed, 24 Mar 2021 15:13:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=X00sTfrjFQqx0bGVsVp58hCxeXuTxU0Mfpny36/rMxk=;
        b=Ud4BsHtE/dubB7Q0doKqAC7jY7XUsldtX2Ey9UtaWpSwdtz9mbZhJg+UcJ2ze8WOx8
         mb7AFnuDokxDQBdHRPprNpGiO8rNMi+i8JZIPA/uUGd/6pBPrzZ1G2hi4IGNByapOr4B
         ikrVdjWIBBG5m9tc16zVvS89fvV4ZpVGo1WKr5LcHKGRVhSTnbrPzjdp5gWN44xhPjJP
         lheneD26ZPSziYU5UrkSjbC/eKj+yV/xZ58UOK1m8VsvGJiCC8Suenbxo46AMeN12b5L
         K3DKTqKGstB+28SLvCy+CucsFwqfsEVQmFps+SJ6zPjFyIoESH7NIeMHqtYCi5rHLVN1
         o2jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=X00sTfrjFQqx0bGVsVp58hCxeXuTxU0Mfpny36/rMxk=;
        b=Sq52WLlwuJUdAmzP/yayaJ3iGH0eeg8rZbaMrvc3F+y3AbEjHGn3+F3Er7uAoOhEr8
         TMT4HzVGLx59KWp7A+L1FmVY50iRR++yJneeVqmijDnvJQp2EvVnLx31XsdWPCgPWYYl
         IsPzNvl8LG/ALCwscjmlB2cLiBmn4wCHH7KRYGcin2Gd8hmd6z3JYXstMvd2Cs2fNuOh
         P+6bagKnDJ2wUWHNnUNqsf0RG3TjMTVwO5NHeQsYMulylORIHyp3rqbJti9o6IT1CEk3
         oeGQTGRs6D3BCobfOLVvfWv64HcsA02QrhcJXdz1N6uAaKQL7/eD0P6K+qxjOxREQsIO
         4Shg==
X-Gm-Message-State: AOAM532GBJEohq048jLi/MFX/r5xUszbfzsbOxi4hzz/aRvLHUTQGxb1
        ys+9ilLcQ+K/6PY056xqi8OmyDgiNuPDiQ==
X-Google-Smtp-Source: ABdhPJwyCTo5KZe6+oiyfAly5VxTYkajiNn1Jv6tTV+JYJgmOUPBYAFhNaVokv+bxnSAzvrm2C2kRQ==
X-Received: by 2002:a05:6e02:216d:: with SMTP id s13mr4555039ilv.208.1616624029600;
        Wed, 24 Mar 2021 15:13:49 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id a14sm1715704ilm.68.2021.03.24.15.13.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Mar 2021 15:13:49 -0700 (PDT)
Subject: Re: + mm-provide-filemap_range_needs_writeback-helper.patch added to
 -mm tree
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Jan Kara <jack@suse.cz>, mm-commits@vger.kernel.org,
        Matthew Wilcox <willy@infradead.org>
References: <20210302234347.N9evDxn__%akpm@linux-foundation.org>
 <9c04eafc-475d-31fc-e2cc-ea99aafd8972@kernel.dk>
 <20210324150218.bd9f1ebc4af58703ce001f77@linux-foundation.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <a0d094d9-cf6b-8e27-d7f2-a6f86977bfa1@kernel.dk>
Date:   Wed, 24 Mar 2021 16:13:48 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210324150218.bd9f1ebc4af58703ce001f77@linux-foundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 3/24/21 4:02 PM, Andrew Morton wrote:
> On Wed, 24 Mar 2021 13:48:08 -0600 Jens Axboe <axboe@kernel.dk> wrote:
> 
>> On Tue, Mar 2, 2021 at 4:43 PM <akpm@linux-foundation.org> wrote:
>>>
>>>
>>> The patch titled
>>>      Subject: mm: provide filemap_range_needs_writeback() helper
>>> has been added to the -mm tree.  Its filename is
>>>      mm-provide-filemap_range_needs_writeback-helper.patch
>>
>> Are you still planning on flushing this out for 5.12??
> 
> Oh.  No, I wasn't planning on that.  I saw nothing which made me think
> it was that urgent.

Ehm ok, I think that was the plan though when we originally talked about
this series. At least that was what was in my original emails on this
topic :-)

> What is the justification?  How much performance benefit are we talking
> here?

Well it's pretty huge, since if we return "nope can't do this
non-blocking" it'll mean that io_uring has to bump the operation to an
async threads. So CPU cost goes way up, and latencies does too.

Problem is, we're now at -rc4, and it was my understanding that we'd get
this in for 5.12, but obviously way sooner than this. But I kind of lost
track when it went into your tree, until I started thinking about it
earlier today. While it's not the end of the world to wait for 5.13,
though the current situation does suck a lot for certain workloads.

-- 
Jens Axboe

