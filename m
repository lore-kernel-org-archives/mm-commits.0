Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E27C6C4167B
	for <mm-commits@archiver.kernel.org>; Wed,  6 Dec 2023 20:50:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379581AbjLFUuw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 6 Dec 2023 15:50:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379478AbjLFUuv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Dec 2023 15:50:51 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04977193
        for <mm-commits@vger.kernel.org>; Wed,  6 Dec 2023 12:50:58 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id d9443c01a7336-1d048d38881so1458375ad.2
        for <mm-commits@vger.kernel.org>; Wed, 06 Dec 2023 12:50:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1701895857; x=1702500657; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=e0PGdm9Ictq3O5Yxv8fQKKJtmMXP3/9LG+B0JyKdbWc=;
        b=Plh6qrvtATQ/Xju3ycl1hgPNB7t0/xTh45OFt3B0MHrmECQIlHkNjuuVVkNFsa+fFM
         fFvTpupaoxWkt4cJ5yDJxzeJKnTR8g8pa++NCTC754UYLvhWvOY/G1rI5uGe7gTjAJ+z
         KQhzPHVB18Y+lO50/CCqCdWer6Bw7y8xn73i4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701895857; x=1702500657;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e0PGdm9Ictq3O5Yxv8fQKKJtmMXP3/9LG+B0JyKdbWc=;
        b=JL8ellwhqWdCTeqtOfxSciNbVokwgyWlSeWyfKPXgFQ0TRMQHOoYEk+38KN8DLdB0b
         afMxgrlAZvgETqCx0USQYjR65DRqPsVxAcfXtTZY1Pyj0j7R0kXJ2Axh75aII54PWjII
         ozO8rP69d7e6nlhGVpJ/hLe5VwYvw3Yxx0HauEQVYK4dssmUuCDFGwr4qZZ52Bs8PEfC
         Wv6Sj8eV9U7az1TdEjhDjPbeIIk7vrGvhIy52+Jqi9jjESBtlwDncpsGpjP/4BR2ymzA
         oBXvhg3r67ZqeVMPNVHmlWu/m2AHRWuJfEuAkfT/hCj4uIKTJpjLALtzB8eOrwvyOFJC
         aorw==
X-Gm-Message-State: AOJu0Yz2wEh+HDhTM0zxweO+OiO8CVfWDJW0sCASOYRjZpUeOUY3TFTQ
        INQ67p0rFYhkBpqlLCbmxWd9LQ==
X-Google-Smtp-Source: AGHT+IED+XjRzzjoVmJkrXEo8PRkDvH0uDI5LCRADjVStjZUc+krrCVThhVxHvndJuuAuy/1qC1Gzg==
X-Received: by 2002:a17:902:d389:b0:1d0:4cde:6e2b with SMTP id e9-20020a170902d38900b001d04cde6e2bmr1287126pld.57.1701895857484;
        Wed, 06 Dec 2023 12:50:57 -0800 (PST)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id e9-20020a170902744900b001cff026df52sm230376plt.221.2023.12.06.12.50.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Dec 2023 12:50:56 -0800 (PST)
Date:   Wed, 6 Dec 2023 12:50:56 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, ebiederm@xmission.com,
        adobriyan@gmail.com
Subject: Re: + elf-maintainers-specifically-mention-elf.patch added to
 mm-hotfixes-unstable branch
Message-ID: <202312061250.525031ED@keescook>
References: <20231206175845.EF303C433C7@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231206175845.EF303C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, Dec 06, 2023 at 09:58:45AM -0800, Andrew Morton wrote:
> 
> The patch titled
>      Subject: ELF, MAINTAINERS: specifically mention ELF
> has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
>      elf-maintainers-specifically-mention-elf.patch

FWIW, I've snagged this via the execve tree.

-Kees

> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/elf-maintainers-specifically-mention-elf.patch
> 
> This patch will later appear in the mm-hotfixes-unstable branch at
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
> From: Alexey Dobriyan <adobriyan@gmail.com>
> Subject: ELF, MAINTAINERS: specifically mention ELF
> Date: Wed, 6 Dec 2023 12:21:42 +0300
> 
> People complain when I miss people in Cc.
> 
> Link: https://lkml.kernel.org/r/2cb0891e-d7c0-4939-bb5f-282812de6078@p183
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> Cc: Eric Biederman <ebiederm@xmission.com>
> Cc: Kees Cook <keescook@chromium.org>
> 
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  MAINTAINERS |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/MAINTAINERS~elf-maintainers-specifically-mention-elf
> +++ a/MAINTAINERS
> @@ -7880,7 +7880,7 @@ F:	include/uapi/linux/mdio.h
>  F:	include/uapi/linux/mii.h
>  F:	net/core/of_net.c
>  
> -EXEC & BINFMT API
> +EXEC & BINFMT API, ELF
>  R:	Eric Biederman <ebiederm@xmission.com>
>  R:	Kees Cook <keescook@chromium.org>
>  L:	linux-mm@kvack.org
> _
> 
> Patches currently in -mm which might be from adobriyan@gmail.com are
> 
> elf-maintainers-specifically-mention-elf.patch
> 

-- 
Kees Cook
