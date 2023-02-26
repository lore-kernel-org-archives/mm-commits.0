Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A580BC6FA8E
	for <mm-commits@archiver.kernel.org>; Sun, 26 Feb 2023 11:00:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbjBZLAD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 26 Feb 2023 06:00:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjBZLAD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 26 Feb 2023 06:00:03 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CC3FBDC5
        for <mm-commits@vger.kernel.org>; Sun, 26 Feb 2023 03:00:02 -0800 (PST)
Received: from zn.tnic (p5de8e9fe.dip0.t-ipconnect.de [93.232.233.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 402B61EC05B0;
        Sun, 26 Feb 2023 12:00:00 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1677409200;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=dmNaIvF9mnzLAkrbpt1k1glDaeNPDuL4kRjIMa8FBw4=;
        b=cw62IPkjJqXrPSmejTlgoWPI6zOzpUHjpt5f1yLzcBdmod/0rZ2vHIhYuC+m+x8aen3lDF
        7bzarOj04DWP2jphGaDhymjhjGIYbrgMbggzhFDDC0ys7oBykIvZSPWIpU17g5mIZQKS1t
        x8rO0olD8Q5i3I1RjqrXOFMqvSz1hWU=
Date:   Sun, 26 Feb 2023 11:59:55 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        tglx@linutronix.de, ryabinin.a.a@gmail.com, peterz@infradead.org,
        nicolas@fjasle.eu, ndesaulniers@google.com, nathan@kernel.org,
        naresh.kamboju@linaro.org, mingo@redhat.com, lkft@linaro.org,
        keescook@chromium.org, jakub@redhat.com, glider@google.com,
        dvyukov@google.com, dave.hansen@linux.intel.com,
        andreyknvl@gmail.com, elver@google.com
Subject: Re: +
 kasan-emit-different-calls-for-instrumentable-memintrinsics.patch added to
 mm-hotfixes-unstable branch
Message-ID: <Y/s7q4EAXRticRvR@zn.tnic>
References: <20230226050340.CFC98C433D2@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230226050340.CFC98C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Sat, Feb 25, 2023 at 09:03:40PM -0800, Andrew Morton wrote:
> --- a/mm/kasan/shadow.c~kasan-emit-different-calls-for-instrumentable-memintrinsics
> +++ b/mm/kasan/shadow.c
> @@ -107,6 +107,17 @@ void *__asan_memcpy(void *dest, const void *src, size_t len)
>  }
>  EXPORT_SYMBOL(__asan_memcpy);
>  
> +#ifdef CONFIG_KASAN_SW_TAGS
> +void *__hwasan_memset(void *addr, int c, size_t len) __alias(__asan_memset);
> +EXPORT_SYMBOL(__hwasan_memset);
> +#ifdef __HAVE_ARCH_MEMMOVE
> +void *__hwasan_memmove(void *dest, const void *src, size_t len) __alias(__asan_memmove);
> +EXPORT_SYMBOL(__hwasan_memmove);
> +#endif
> +void *__hwasan_memcpy(void *dest, const void *src, size_t len) __alias(__asan_memcpy);
> +EXPORT_SYMBOL(__hwasan_memcpy);

Any particular reason those exports are not _GPL?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
