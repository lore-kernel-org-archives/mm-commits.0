Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30984C47088
	for <mm-commits@archiver.kernel.org>; Wed, 26 May 2021 18:03:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F0E71613C5
	for <mm-commits@archiver.kernel.org>; Wed, 26 May 2021 18:03:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232310AbhEZSFX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 26 May 2021 14:05:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232141AbhEZSFX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 26 May 2021 14:05:23 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB8EDC061574
        for <mm-commits@vger.kernel.org>; Wed, 26 May 2021 11:03:51 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id n3-20020a9d74030000b029035e65d0a0b8so1827621otk.9
        for <mm-commits@vger.kernel.org>; Wed, 26 May 2021 11:03:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ntXVLVi7kjOje8hv/D9Zs6Z9TOzHd6XUh5dQaKjWt3c=;
        b=iBz4Rlg9ie9y/mznb7ZOq3UlVdP2Mu0dTxPfZLl9dUhA9Xj/KomEQze3CcuR6d7kcs
         XZ8INBqBQMsj78UpUtOSN13Tyd+uyF8T5a05Ye42Ze0Rh6KkKa4HyZzc9M7o2syJW/NR
         LRVLMpmiY8BkmWzZrXpybpp+i8MVljKDCZfghQDKjhFSC5tFShddtEUh9pz6khdxZF0b
         Ay6TO774k08deKYs+s6QwZIzZYV58RxYlVBaMpotWeYyMUABJTW3OLHipTWQB0owwe42
         NyV3r752vmW4oLgLXsy8SoI7YO2fI7gNzIcJMgDMn309gisvqFsD5mMFmaywEJ5UaxXT
         mc/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ntXVLVi7kjOje8hv/D9Zs6Z9TOzHd6XUh5dQaKjWt3c=;
        b=BLH/n5IP7y178aL+RLCRW0E3ybJvTtxJ/8Iy+Ynbm27Cn66oxRMM/NJsMtD3C/pU3j
         ksMNPWXsB08Tu9jWM3w2JS8USQdzVpP989xdGzfW21dWOf1G6J08eFcGoogEZdp7/15w
         q+o1AmQCs4P5eKV78wbeTbb9GFUb87vB3r/bhJtBUVBtPDsdi9R4mzwoi4LyGp3ToVuE
         nrIOSlvzR0OjqgRCv6xhy0BMkfE4YDK21+Tk0H3kIVePZPQxOAlyksw6gpYhH1jOHHxJ
         sKY46QgPYVKlc1099gAMN2a+nQ4zo4yHHhD5kwXojnjkzdQzK3fxsanDUApZ0a+yWNBC
         t8Og==
X-Gm-Message-State: AOAM531uWpwyK+2qVR38HE3lkU2/0m9XQzuQzKqBhaiipXRbZg6d1VhN
        BF1N4m2vaq+uBD1AcFW7XP8PuO/0QRgtJwqfYx9PLg==
X-Google-Smtp-Source: ABdhPJzFdY2cV+2LjZq5cO8W6B2ef7MpuHTQR2MlPgwkjFzr3geUuTg+rg6LsW9tO2qREUESCiRvJuE+6wbAJ8ytduU=
X-Received: by 2002:a9d:7a54:: with SMTP id z20mr3392473otm.17.1622052231093;
 Wed, 26 May 2021 11:03:51 -0700 (PDT)
MIME-Version: 1.0
References: <20210525235909.STdFPyxJW%akpm@linux-foundation.org>
In-Reply-To: <20210525235909.STdFPyxJW%akpm@linux-foundation.org>
From:   Marco Elver <elver@google.com>
Date:   Wed, 26 May 2021 20:03:39 +0200
Message-ID: <CANpmjNNJcWQEV7Eu5a84FOM19OJoobwYd7zx1C+3ybQhEMBqCg@mail.gmail.com>
Subject: Re: [to-be-updated] kcov-add-__no_sanitize_coverage-to-fix-noinstr-for-all-architectures.patch
 removed from -mm tree
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Ard Biesheuvel <ardb@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Dmitry Vyukov <dvyukov@google.com>,
        Kees Cook <keescook@chromium.org>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        mm-commits@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Miguel Ojeda <ojeda@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, 26 May 2021 at 01:59, <akpm@linux-foundation.org> wrote:
> The patch titled
>      Subject: kcov: add __no_sanitize_coverage to fix noinstr for all architectures
> has been removed from the -mm tree.  Its filename was
>      kcov-add-__no_sanitize_coverage-to-fix-noinstr-for-all-architectures.patch
>
> This patch was dropped because an updated version will be merged

Thanks, Andrew. I'm hoping I can teach Clang one more trick and then send v2.

Thanks,
-- Marco
