Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04805C47097
	for <mm-commits@archiver.kernel.org>; Thu,  3 Jun 2021 10:42:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC07D613FA
	for <mm-commits@archiver.kernel.org>; Thu,  3 Jun 2021 10:42:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbhFCKny (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Jun 2021 06:43:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbhFCKnx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 3 Jun 2021 06:43:53 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B1DAC06174A;
        Thu,  3 Jun 2021 03:42:09 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id jt22so8521920ejb.7;
        Thu, 03 Jun 2021 03:42:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-transfer-encoding;
        bh=wJVYMLShJcEHY1M41voNtHfPWItH6cQvkxCpZVR0vs8=;
        b=XOqADyF/nJ0rA072xUGq1GxKZjgwb4Wrm5ReoZ1rpmKFVXvmQDc+hVYMpJYJ6Yyp3o
         D4CZjvK1rA42CZssk1DAoYJpgRW2rX3kTEPTNYIY/AYpZHI7Ik04GrraIPN8vDZkoHHD
         iKoDmmOEmtOkpOKjsId64TWJ83dsirCXsfjUrjdG5S7RX2GF1JGl+8Dij5NtVp0o0tFO
         3dXIZea0WLq4o+cj9rWtYNNLvf1QjVGbzd/6lRWaBE9mM9tOhbuI6Sahki83bIm1ecdu
         nPX3cJ02shej292z8Gt+8yc08o5DNN0+74yHLyRoflk/mlEK+4iP1yFWgKGkJ3SylF/m
         BWbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:user-agent:mime-version:to
         :cc:subject:references:in-reply-to:content-transfer-encoding;
        bh=wJVYMLShJcEHY1M41voNtHfPWItH6cQvkxCpZVR0vs8=;
        b=hN/nUP5gPgCvVEPL65fU+dHCdA3lTiZ8RqOIxDeGlAM4OeDkDQ8E2+hD0sH2ChzMtm
         ET80gjlSvz99jT1JUf5FmH82E6krxTV3FWfl/1rWvH7fRyt9o1+YxnBtVbwEAKAwV9bI
         KBF+syI9PIfa52WDbucT8aKYZv6D1j5StNzp+fNiCmDEJ8VdybHz3LsmbHpLjmB+1U0M
         s/TNrz0L9MuZZi8SOjF6Ept6vsSGu46UEk/Bp8k8iNTbhyQc8BkBpSWOasE1AVCTlll9
         k5oxnZjKWLGn8nrDSkQQx2czBQ8ru5V1AQu0YyiOuhxRXIvoHtSGFX5SabuWp6fu3XLk
         Z48A==
X-Gm-Message-State: AOAM533sJfXoEFaEkAT34F1ldDuyvXq/EdPbvplMdIhPaOXUR6w3cgw2
        7ADLwjN7PcQKmXYKkrBkPXvTjMABI+Ok0g==
X-Google-Smtp-Source: ABdhPJyQ98INu/bg6n9Pa4Xb8TqWMXaIgBi62SiHv9wRIP1x8ujNteC/67jKfp4eG0pIEO8i1AZJqg==
X-Received: by 2002:a17:906:848:: with SMTP id f8mr13370399ejd.198.1622716927705;
        Thu, 03 Jun 2021 03:42:07 -0700 (PDT)
Received: from [109.186.180.4] (109-186-180-4.bb.netvision.net.il. [109.186.180.4])
        by smtp.gmail.com with ESMTPSA id u4sm1350420eje.81.2021.06.03.03.42.06
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Thu, 03 Jun 2021 03:42:07 -0700 (PDT)
Message-ID: <60B8B189.6060404@gmail.com>
Date:   Thu, 03 Jun 2021 13:40:09 +0300
From:   Eli Billauer <eli.billauer@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Randy Dunlap <rdunlap@infradead.org>, akpm@linux-foundation.org,
        broonie@kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-next@vger.kernel.org, mhocko@suse.cz,
        mm-commits@vger.kernel.org, sfr@canb.auug.org.au
Subject: Re: mmotm 2021-06-01-19-57 uploaded (xillybus)
References: <20210602025803.3TVVfGdaW%akpm@linux-foundation.org> <d880c052-e3e3-3af7-040d-7abdc97df1d1@infradead.org> <YLcQc0sHBaYViZIN@kroah.com>
In-Reply-To: <YLcQc0sHBaYViZIN@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 02/06/21 08:00, Greg Kroah-Hartman wrote:
>> (on i386)
>> >  
>> >  CONFIG_XILLYBUS_CLASS=y
>> >  CONFIG_XILLYBUS=m
>> >  CONFIG_XILLYUSB=y
>> >  
>> >  ERROR: modpost: "xillybus_cleanup_chrdev" [drivers/char/xillybus/xillybus_core.ko] undefined!
>> >  ERROR: modpost: "xillybus_init_chrdev" [drivers/char/xillybus/xillybus_core.ko] undefined!
>> >  ERROR: modpost: "xillybus_find_inode" [drivers/char/xillybus/xillybus_core.ko] undefined!
>> >  
>> >  
>> >  Full randconfig file is attached.
>>      
> Sorry about that, I have a fix in my inbox for this that I will push out
> later today...
>    
For the record, this is the said pending patch:

https://lkml.org/lkml/2021/5/28/245

I've tested this issue, and can confirm the compilation problem and that 
the patch fixes it.

Regards,
    Eli
