Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42291C76195
	for <mm-commits@archiver.kernel.org>; Mon, 27 Mar 2023 18:53:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232220AbjC0SxH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Mar 2023 14:53:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232140AbjC0SxG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Mar 2023 14:53:06 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E923119A8
        for <mm-commits@vger.kernel.org>; Mon, 27 Mar 2023 11:53:05 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id d13so8613893pjh.0
        for <mm-commits@vger.kernel.org>; Mon, 27 Mar 2023 11:53:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679943185;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PlVFW4wB3gl+H/vw5OCCL08zfQ+PaxK4GF0r9RjjLVU=;
        b=FmoL7o4hmEQp+2+8EYNL1vSN8/Lc0Bri8X+emd6gUwRRccu1cDZKwScqdIATVRwsJ/
         gALNdwg0wZ4EYLCU35mCQglRNaKANowe73pt2AvBA2Lk2a/gF+2e1fXC1/gQ85SrYAsM
         M0z4Tq6kIo1/8KYueukV7ByuRuIK2YKkNqRF7T9+y+/TfSGTfNntQJ3kZq/0bqehF+2Q
         wntVm9sdX6OIMRqIKHr6ThC0s+929XxdxGfJd8Ay/WIj6SIwfODuJSv5YdMQum5aGVRx
         4AQXFyRVkbHDAQ9eOR2pkWKVo3weG1kG/dGOWSGIPKJYG5lunky1oQ8dWZgpZmYktN8x
         2DWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679943185;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PlVFW4wB3gl+H/vw5OCCL08zfQ+PaxK4GF0r9RjjLVU=;
        b=W6l/7KMSkSstm5TDkKc7VyHC8Yy7ch2z+xazNnsJ9Fu2sjAuCuW0WARuAt8k2P5qz5
         H66EB/dPtToFCYDvETD7XgRpxpTo5iidv9udvdBhMfO9y36cNVslca6JqKJ761hh9yrJ
         AitRdwhXf1GX3XaUWtb0mo86g0JLapBb7P0kW2KvHmDAq8rTVwxvqG2katoAiVEEkJIc
         LqLpQxDvFJXv7/WOQbFQufqJErd7LsDL/3GRWeuPytWU1aBhpJtIAbNbepb+g2hI4GbT
         mnsrWLlDuthcHHqU7ov+AbUm5iHK4XmjFcy+0JkgCH7XWRWwqL7v7I+lCJVLqL+bVRjo
         qaDQ==
X-Gm-Message-State: AAQBX9eXTtg2dp3K31mp1zvvM0EuzfAGJ0VhI0jzfaWL6po+f5lOC1sx
        zG+VRrSzZHxwazaQ3w3wsKc=
X-Google-Smtp-Source: AKy350ZtbVhWN9ZqwlK/7QRncaf/04Id4VHDUtPfOHNNjmgEvfbx3fawQBxxLMpmXeCU2j3FBhRImA==
X-Received: by 2002:a17:90a:1ce:b0:233:ee50:d28b with SMTP id 14-20020a17090a01ce00b00233ee50d28bmr13381860pjd.16.1679943184878;
        Mon, 27 Mar 2023 11:53:04 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id dw18-20020a17090b095200b002407750c3c3sm2957890pjb.37.2023.03.27.11.52.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Mar 2023 11:53:04 -0700 (PDT)
Message-ID: <7fba4e12-99f7-3d35-5708-018fda55bfcb@gmail.com>
Date:   Mon, 27 Mar 2023 11:52:55 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: + scripts-gdb-bail-early-if-there-are-no-generic-pd.patch added
 to mm-nonmm-unstable branch
Content-Language: en-US
To:     Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, sboyd@kernel.org,
        leonard.crestez@nxp.com, kbingham@kernel.org,
        jan.kiszka@siemens.com
References: <20230324204556.D06C9C433D2@smtp.kernel.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230324204556.D06C9C433D2@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Hi Andrew,

On 3/24/23 13:45, Andrew Morton wrote:
> The patch titled
>       Subject: scripts/gdb: bail early if there are no generic PD
> has been added to the -mm mm-nonmm-unstable branch.  Its filename is
>       scripts-gdb-bail-early-if-there-are-no-generic-pd.patch
> 
> This patch will shortly appear at
>       https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-gdb-bail-early-if-there-are-no-generic-pd.patch
> 
> This patch will later appear in the mm-nonmm-unstable branch at
>      git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> Before you just go and hit "reply", please:
>     a) Consider who else should be cc'ed
>     b) Prefer to cc a suitable mailing list as well
>     c) Ideally: find the original patch on the mailing list and do a
>        reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days

I made a mistake in this patch, will send a v2 shortly, please drop this 
one. Thank you!
-- 
Florian

