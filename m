Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03ECCC761A6
	for <mm-commits@archiver.kernel.org>; Wed, 29 Mar 2023 09:21:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230335AbjC2JVQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 29 Mar 2023 05:21:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230113AbjC2JVM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 29 Mar 2023 05:21:12 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3345530C2
        for <mm-commits@vger.kernel.org>; Wed, 29 Mar 2023 02:21:10 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id e11so15343509lji.8
        for <mm-commits@vger.kernel.org>; Wed, 29 Mar 2023 02:21:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680081668;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SgyUXppr1sIZ/lsDEPLmvqr7wwZZDtS4lgk8xid0HCs=;
        b=XtIagS9nY+TTi8Q90S6qaP2pcWGnqn0h1tz8KPEssv8OjeY3Jv51wl+m/kCH1HpNVQ
         nURCDWWmnbs6pnqKV+oJen3Dyaj+KkeBy4yL4bwl5xBlPYo5PvP7JDXbTbhelW86gaGn
         27S2Og++5Y3kLGnHz8FpJPBtW1h45T8hDSXm15y3cZ0s7t0FW51Ec8KAgy8HJmH4W/Ik
         q5xq+9iHVXl1Ubz1B+RTGEmPUQrP1W4//z0iV/GxXqqGwP5xqbEHbv1jAf0fryIKEcJ8
         36hP+8l0G+5BMHRPnIfqN4xnwxk3DTvKGyQYQqmfmXrTpSDMHrIDEsX/H9tCIgnkMdSD
         0poQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680081668;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SgyUXppr1sIZ/lsDEPLmvqr7wwZZDtS4lgk8xid0HCs=;
        b=joJ4KHZDQGfRg73npe5m4aZorajrEjpr3gH/oWtJFiR1iRSdkh0XYwPeI8/eO+D6jk
         moChJoZsAcpC3tbkH03eYk1X54D0WwvQQMypUmtnYo/x1vlJA/Ij/AbBZ8WSSxzlqdoG
         e5P3WPtsM2oejDmjbRGRyw7tNjZqfeyEyXIIEWNen76Op4Ibzx83M8YolcKVCKuqn2eh
         WFiDffO60CR4G4s3NGw6xhGMaMVQqKONKKKbv/n+Bni4nKzxzZ63afuzIeS5+fyX7oZV
         quW/WUAbFrtbCgkLdItOtTnJdX5Lt4sWgUn6oHFcxYqDnKN/a47PBIuRf/NqKOsOfmmv
         wM8Q==
X-Gm-Message-State: AAQBX9e14u5A0RlIJKPQW3Rbi9OHkjlu7BxCqpbdfpNSg1GlE3hE290f
        1k8xeVyVbNiDtBYnlr2BZOicqA==
X-Google-Smtp-Source: AKy350Zf2pgI1Y8yFSo5/2YWwkRY2OOueaJWPm5JjdDgE9HvBLWvYUeS6Fr5/lDmERX37TR/5Wcwbw==
X-Received: by 2002:a2e:8016:0:b0:29b:3a19:bd71 with SMTP id j22-20020a2e8016000000b0029b3a19bd71mr6677075ljg.35.1680081668492;
        Wed, 29 Mar 2023 02:21:08 -0700 (PDT)
Received: from [192.168.0.21] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id g5-20020a2e9385000000b002959d2cc975sm5366219ljh.37.2023.03.29.02.21.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Mar 2023 02:21:08 -0700 (PDT)
Message-ID: <287eaf10-d833-e59f-8b82-7084a1d40e21@linaro.org>
Date:   Wed, 29 Mar 2023 11:21:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: + checkpatch-add-missing-bindings-license-check.patch added to
 mm-nonmm-unstable branch
Content-Language: en-US
To:     Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, robh@kernel.org,
        lukas.bulwahn@gmail.com, joe@perches.com, dwaipayanray1@gmail.com,
        apw@canonical.com, ddrokosov@sberdevices.ru
References: <20230321212913.79232C4339B@smtp.kernel.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230321212913.79232C4339B@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 21/03/2023 22:29, Andrew Morton wrote:
> The patch titled
>      Subject: checkpatch: add missing bindings license check
> has been added to the -mm mm-nonmm-unstable branch.  Its filename is
>      checkpatch-add-missing-bindings-license-check.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/checkpatch-add-missing-bindings-license-check.patch
> 
> This patch will later appear in the mm-nonmm-unstable branch at
>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days
> 
> ------------------------------------------------------
> From: Dmitry Rokosov <ddrokosov@sberdevices.ru>
> Subject: checkpatch: add missing bindings license check
> Date: Mon, 20 Mar 2023 23:33:50 +0300
> 
> All headers from 'include/dt-bindings/' must be verified by checkpatch
> together with Documentation bindings, because all of them are part of the
> whole DT bindings system.
> 
> The requirement is dual licensed and matching pattern:
>     /GPL-2\.0(?:-only|-or-later|\+)? (?:OR|or) BSD-2-Clause/
> 
> The issue was found during patch review:
> https://lore.kernel.org/all/20230313201259.19998-4-ddrokosov@sberdevices.ru/
> 
> Link: https://lkml.kernel.org/r/20230320203350.13696-1-ddrokosov@sberdevices.ru
> Signed-off-by: Dmitry Rokosov <ddrokosov@sberdevices.ru>
> Acked-by: Joe Perches <joe@perches.com>
> Cc: Andy Whitcroft <apw@canonical.com>
> Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
> Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> Cc: Rob Herring <robh@kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Hi Andrew,

Can you drop this patch? Rob raised few concerns and it should be reworked.

Rob's arguments/comments:
https://lore.kernel.org/all/20230321215337.GA1656483-robh@kernel.org/
https://lore.kernel.org/all/CAL_Jsq+-YJsBO+LuPJ=ZQ=eb-monrwzuCppvReH+af7hYZzNaQ@mail.gmail.com/
https://lore.kernel.org/all/CAL_JsqJa-McFEorLr6ZWNqaEtjG8Oi2rNJ3hGwb2Xk3jvqMZgQ@mail.gmail.com/

Best regards,
Krzysztof

