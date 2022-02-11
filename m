Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAEE1C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 11 Feb 2022 18:35:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352729AbiBKSfi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Feb 2022 13:35:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346051AbiBKSfi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Feb 2022 13:35:38 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBDB7184
        for <mm-commits@vger.kernel.org>; Fri, 11 Feb 2022 10:35:33 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id s18so12434938ioa.12
        for <mm-commits@vger.kernel.org>; Fri, 11 Feb 2022 10:35:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=YG2mtDCQAmHKIGQN1Eu7bQuJAuyZkXd1RbbixtMnArE=;
        b=KOwmSeAWLyMDR7YExr/Dy/eKVXJTND6Ojnfwm5cx9XKmCBbkZ0Nj1/71HLaREhxAyn
         wtIg72FetE4ch+dq3mG7O+H0c4VieC6iAejR3rP3um78qF/zuZeE7nkdZK9lVy05TNqU
         lkJ/T2n4vo58bZ8zGjF6Aw/3DtoB1Pe16Fty0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YG2mtDCQAmHKIGQN1Eu7bQuJAuyZkXd1RbbixtMnArE=;
        b=PaLHgUDqhzNfopkS7W9IxVHGnMlf8ZMbb+f8rA52eH0XYM9g0MY10V7lpfjpQXulAO
         FzKDJ8PCrkcIZn/dBfrOK7R0cg8/wFc9/pQmgA9zbmiTRO6CXcvLzAkWXSV7RQUn6AzZ
         4ByDW8T3OQKk6p3CteK/KCoBS7RxVvbDKgsu0pl/yOwuTGr4aOvVgioGAfWh7g0a5KRo
         CQLTHd64aPCAfphWQc7VzWyVLwPxbcULocSDYbfnLPT+nkvWkRh5d3dvkAplhiGSfeJF
         rF43xs776ITxdY28L4HxO0GbdM8Si4Jxm5+SXo6lcbiMzYqDvZ9umzVvup3i5mEavv/f
         JVeA==
X-Gm-Message-State: AOAM531a0nV11LhnKQwA0g8nXHgKyn1YvMD9pulpeqgEYRwMiF+3X2Vb
        zlbsOoTcCAFrxidxEV7B7fSYMUdGBxvAOw==
X-Google-Smtp-Source: ABdhPJxo8568LcN9ktIC1erRyIfVyA5h5BZiiPFtUEu5vEdqDW6uP7K/u9v2gkw0Pw07hNEs2PaDVg==
X-Received: by 2002:a05:6602:2a4b:: with SMTP id k11mr1527598iov.136.1644604533363;
        Fri, 11 Feb 2022 10:35:33 -0800 (PST)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id s18sm14450622iov.5.2022.02.11.10.35.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Feb 2022 10:35:33 -0800 (PST)
Subject: Re: + selftests-exec-add-non-regular-to-test_gen_progs.patch added to
 -mm tree
To:     Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, stable@vger.kernel.org,
        keescook@chromium.org, ebiederm@xmission.com, bot@kernelci.org,
        usama.anjum@collabora.com, Shuah Khan <skhan@linuxfoundation.org>
References: <20220211182612.B562CC340ED@smtp.kernel.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <9130ef69-02eb-1a46-970c-0ce6fa6a68ad@linuxfoundation.org>
Date:   Fri, 11 Feb 2022 11:35:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220211182612.B562CC340ED@smtp.kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 2/11/22 11:26 AM, Andrew Morton wrote:
> The patch titled
>       Subject: selftests/exec: add non-regular to TEST_GEN_PROGS
> has been added to the -mm tree.  Its filename is
>       selftests-exec-add-non-regular-to-test_gen_progs.patch
> 
> This patch should soon appear at
>      https://ozlabs.org/~akpm/mmots/broken-out/selftests-exec-add-non-regular-to-test_gen_progs.patch
> and later at
>      https://ozlabs.org/~akpm/mmotm/broken-out/selftests-exec-add-non-regular-to-test_gen_progs.patch
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
> From: Muhammad Usama Anjum <usama.anjum@collabora.com>
> Subject: selftests/exec: add non-regular to TEST_GEN_PROGS
> 
> non-regular file needs to be compiled and then copied to the output
> directory.  Remove it from TEST_PROGS and add it to TEST_GEN_PROGS.  This
> removes error thrown by rsync when non-regular object isn't found:
> 

Andrew,

I pushed this to linux-kselftest fixes for rc5. I can go drop it now,
and you can take this through yours.

thanks,
-- Shuah

