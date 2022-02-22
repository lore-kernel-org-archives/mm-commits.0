Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12896C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 22 Feb 2022 13:44:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231216AbiBVNpD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Feb 2022 08:45:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231932AbiBVNpC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Feb 2022 08:45:02 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 173541275DE
        for <mm-commits@vger.kernel.org>; Tue, 22 Feb 2022 05:44:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645537476;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YEqegYhy4nHhK7XtneODbrgpfsfgm96jUO/bWdFkres=;
        b=VzOKpeQWqfKoeeaIqstln80GjnZ+kMG7p/xC3GTyNRzTPdUM86UhY5zzWQDYZmzHqKFdS1
        F0+QQC8qR3u9aLfnSqHAhayfmeoyuA9tniaX8Q15KWkb0wcl2iAcYl3+6n5nVjf+o0Jpf8
        f3lwXr9Nt/1Y4f/C1CPtIkK3i/xilnE=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-492-63Cp6cLiMIytDn_xT2l20w-1; Tue, 22 Feb 2022 08:44:35 -0500
X-MC-Unique: 63Cp6cLiMIytDn_xT2l20w-1
Received: by mail-qv1-f72.google.com with SMTP id kd18-20020a056214401200b0042de5c14702so21042166qvb.12
        for <mm-commits@vger.kernel.org>; Tue, 22 Feb 2022 05:44:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=YEqegYhy4nHhK7XtneODbrgpfsfgm96jUO/bWdFkres=;
        b=sx/VTpioZg/qDpjV8Uack9DWaBwLhPO8L70bx1RxG2eE9EbYtnksD8aQoXi+mIYGMa
         wbj5Vuno9yKORud2PQyjxa3inSHorxw2oWvz4qst2tTYiZpv63x0q8aOs7MQXWWUxjGy
         6mw2lmNGN2kRmXF1GOOAPl0FO4YrPuhgOKmCJ4Vf1aSE5WFligRMmpeHlb+apMoPiBHi
         kckIQ3cMYepKKh/ogrKjeT6WX1SUiCcPIs3yDTA//O3w0VTsUgdduQltIYQbhht7VoCU
         oYL58QUsD0zlWBwaLKI0/oMTsYiqbZkbX/9fdEqSdWGwfpUxK98jqoVbD2gtKUcN8yxQ
         ZLLw==
X-Gm-Message-State: AOAM533NPZGMTGtkSpR1uqcQRIpxK04EKOc7EPWl4RoeV/bEk82A6x92
        oRzipkmjbGzl1gU9NDjxmm9OtgOu8jvuFXzo/pOVghmlSAQyR5WoxVHvnrTfQ/fZ2TjKuBpcs9D
        HvDa0U+V3yJcim2jbrokSsg==
X-Received: by 2002:ae9:ed4d:0:b0:506:d0c4:b61b with SMTP id c74-20020ae9ed4d000000b00506d0c4b61bmr15399068qkg.562.1645537474363;
        Tue, 22 Feb 2022 05:44:34 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw1NxcpzDnNp0p+hgEcIBS9f7yFRH6LeYY1p0laepxMojkI/fP+eiEphOyOKFbVRA/SWe53eg==
X-Received: by 2002:ae9:ed4d:0:b0:506:d0c4:b61b with SMTP id c74-20020ae9ed4d000000b00506d0c4b61bmr15399057qkg.562.1645537474018;
        Tue, 22 Feb 2022 05:44:34 -0800 (PST)
Received: from [192.168.1.3] (c-24-60-53-55.hsd1.nh.comcast.net. [24.60.53.55])
        by smtp.gmail.com with ESMTPSA id c2sm24041196qkp.0.2022.02.22.05.44.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Feb 2022 05:44:33 -0800 (PST)
Message-ID: <c6b85c21-d48c-4865-f0b3-3f1853299523@redhat.com>
Date:   Tue, 22 Feb 2022 08:44:32 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: +
 mm-usercopy-return-1-from-hardened_usercopy-__setup-handler.patch added to
 -mm tree
Content-Language: en-US
To:     Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, keescook@chromium.org,
        i.zhbanov@omprussia.ru, rdunlap@infradead.org
References: <20220222035450.ABDBFC340E8@smtp.kernel.org>
From:   Christoph von Recklinghausen <crecklin@redhat.com>
In-Reply-To: <20220222035450.ABDBFC340E8@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

You can add

Acked-by: Chris von Recklinghausen <crecklin@redhat.com>

to this patch.

Thanks,

Chris

On 2/21/22 22:54, Andrew Morton wrote:
> The patch titled
>       Subject: mm/usercopy: return 1 from hardened_usercopy __setup() handler
> has been added to the -mm tree.  Its filename is
>       mm-usercopy-return-1-from-hardened_usercopy-__setup-handler.patch
>
> This patch should soon appear at
>      https://ozlabs.org/~akpm/mmots/broken-out/mm-usercopy-return-1-from-hardened_usercopy-__setup-handler.patch
> and later at
>      https://ozlabs.org/~akpm/mmotm/broken-out/mm-usercopy-return-1-from-hardened_usercopy-__setup-handler.patch
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
> From: Randy Dunlap <rdunlap@infradead.org>
> Subject: mm/usercopy: return 1 from hardened_usercopy __setup() handler
>
> __setup() handlers should return 1 if the command line option is handled
> and 0 if not (or maybe never return 0; it just pollutes init's
> environment). This prevents:
>
>    Unknown kernel command line parameters \
>    "BOOT_IMAGE=/boot/bzImage-517rc5 hardened_usercopy=off", will be \
>    passed to user space.
>
>    Run /sbin/init as init process
>     with arguments:
>       /sbin/init
>     with environment:
>       HOME=/
>       TERM=linux
>       BOOT_IMAGE=/boot/bzImage-517rc5
>       hardened_usercopy=off
> or
>       hardened_usercopy=on
> but when "hardened_usercopy=foo" is used, there is no Unknown kernel
> command line parameter.
>
> Return 1 to indicate that the boot option has been handled.
> Print a warning if strtobool() returns an error on the option string,
> but do not mark this as in unknown command line option and do not cause
> init's environment to be polluted with this string.
>
> Link: https://lkml.kernel.org/r/20220222034249.14795-1-rdunlap@infradead.org
> Link: lore.kernel.org/r/64644a2f-4a20-bab3-1e15-3b2cdd0defe3@omprussia.ru
> Fixes: b5cb15d9372ab ("usercopy: Allow boot cmdline disabling of hardening")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Reported-by: Igor Zhbanov <i.zhbanov@omprussia.ru>
> Cc: Chris von Recklinghausen <crecklin@redhat.com>
> Cc: Kees Cook <keescook@chromium.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>   mm/usercopy.c |    5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
>
> --- a/mm/usercopy.c~mm-usercopy-return-1-from-hardened_usercopy-__setup-handler
> +++ a/mm/usercopy.c
> @@ -284,7 +284,10 @@ static bool enable_checks __initdata = t
>   
>   static int __init parse_hardened_usercopy(char *str)
>   {
> -	return strtobool(str, &enable_checks);
> +	if (strtobool(str, &enable_checks))
> +		pr_warn("Invalid option string for hardened_usercopy: '%s'\n",
> +			str);
> +	return 1;
>   }
>   
>   __setup("hardened_usercopy=", parse_hardened_usercopy);
> _
>
> Patches currently in -mm which might be from rdunlap@infradead.org are
>
> mm-memcontrol-return-1-from-cgroupmemory-__setup-handler.patch
> mm-mmap-return-1-from-stack_guard_gap-__setup-handler.patch
> mm-usercopy-return-1-from-hardened_usercopy-__setup-handler.patch
> inith-improve-__setup-and-early_param-documentation.patch
> init-mainc-return-1-from-handled-__setup-functions.patch
> docs-sysctl-kernel-add-missing-bit-to-panic_print-fix.patch
>

