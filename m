Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D52D0C433E0
	for <mm-commits@archiver.kernel.org>; Thu,  7 Jan 2021 23:07:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A9715235FC
	for <mm-commits@archiver.kernel.org>; Thu,  7 Jan 2021 23:07:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727624AbhAGXHT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 7 Jan 2021 18:07:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:48764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727451AbhAGXHT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 7 Jan 2021 18:07:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6172A235FF;
        Thu,  7 Jan 2021 23:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610060798;
        bh=x8+3Kohj1OOwC6V8US7ttEra744siAlX47PLUHePtsA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FJU5GSca5wlAphqzMjG90dByEGN6bBxihHFqdoQ7CWImJC4xuMia+8jO7F68wcU1C
         Doica6+yeBXsOcc+0+JnyWhfv6eMdiKi0bis7S4WoG2c1hKcC2SdcTquLL2y3iG44z
         XUjg9x10Vc2GqhdCmNzao9dcg7kJr38KfNQcfAw0=
Date:   Thu, 7 Jan 2021 15:06:37 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     arnd@arndb.de, elver@google.com, georgepope@android.com,
        mm-commits@vger.kernel.org, natechancellor@gmail.com,
        ndesaulniers@google.com, sfr@canb.auug.org.au
Subject: Re: [folded-merged]
 ubsan-disable-unsigned-integer-overflow-sanitizer-with-clang-fix.patch
 removed from -mm tree
Message-Id: <20210107150637.e95a8c6173a7febeb02564cd@linux-foundation.org>
In-Reply-To: <202101071308.8854B1428B@keescook>
References: <20210107003426.Bqzd_O7Lf%akpm@linux-foundation.org>
        <202101071308.8854B1428B@keescook>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, 7 Jan 2021 13:09:29 -0800 Kees Cook <keescook@chromium.org> wrote:

> > --- a/lib/Kconfig.ubsan~ubsan-disable-unsigned-integer-overflow-sanitizer-with-clang-fix
> > +++ a/lib/Kconfig.ubsan
> > @@ -122,7 +122,7 @@ config UBSAN_SIGNED_OVERFLOW
> >  
> >  config UBSAN_UNSIGNED_OVERFLOW
> >  	bool "Perform checking for unsigned arithmetic overflow"
> > -	# clang hugely expands stack usage with -fsanitize=object-size
> > +	# clang hugely expands stack usage with -fsanitize=unsigned-integer-overflow
> >  	depends on !CC_IS_CLANG
> 
> The above "!CC_IS_CLANG" needs to be dropped. I makes it impossible to use at
> all (unsigned UBSAN overflow is only implemented for Clang).

It isn't clear to me that this patch remains valid anyway - I'll drop
it.

