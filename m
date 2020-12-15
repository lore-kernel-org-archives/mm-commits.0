Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4D90C4361B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 20:01:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9658422B47
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 20:01:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728949AbgLOUBm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 15:01:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728935AbgLOUBl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Dec 2020 15:01:41 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84FFEC061285
        for <mm-commits@vger.kernel.org>; Tue, 15 Dec 2020 12:00:38 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id j22so11493148eja.13
        for <mm-commits@vger.kernel.org>; Tue, 15 Dec 2020 12:00:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=14DpLRM3Qz+vRvapZDzuHDoj/LiCL2CCGIM1xiF/BtI=;
        b=DAZ9VGdX78qr1/MsSxEVNpxEDv8wd/DhMM2Y60fNWLShUEDh1TOfX1tSWSbs+UUN5K
         aUhYTTXMhTLXaxbM+LqhqdEssyG+ujXqnWCtNlOXeFkErx8Q58Zrsk1vYSUC+UsDjsmB
         0IituVgiNBXJvKJnG5L2jLCXw9be1TlJreat8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=14DpLRM3Qz+vRvapZDzuHDoj/LiCL2CCGIM1xiF/BtI=;
        b=b5p18xoK1+J1gQisGC1fHl1N9JFZtlKWvoR4bg8VqscDd/lakYiHTJSaldmaCfdt8K
         ZU4hHWnrXZvMcydZJGs6llY48/2W1Ux3RgqvATsbj+ox0roRqJ9xm5+WHJ/966u8tGGm
         C9q3g5OhJi0fkTeNVLrYPahu2uN74jZzh41eOqb3tIppmtXysTMQ5BKiFObKENFw4+Yi
         hf3kNwIsXZYVPiLH1kO4uzlgd3dYC6JiW27dZDDWxKJCoIJkn+k5acQN/xrIC9elQXg1
         s946Pj9sTWX4MM7MVF/dbMSuR8R+dP24E5STbby/wT9oF8NKi45wM00nWP2YFd62PSaZ
         iCtQ==
X-Gm-Message-State: AOAM532194asvbz0pUveTDJsB0dJ6hBaHU8Gm3/O9Cf6YHCb2lzaKdB0
        aOdFrMRujkOhwV1gJWQK3x5ZYd0vtQN/MQ==
X-Google-Smtp-Source: ABdhPJz8DsoWhP7aJBHBiuc/5a8Dmt5Pdvm+TjKZI+zGedqXBWKmTDLiCKdpBybfjG0/gdi/auA/VQ==
X-Received: by 2002:a17:906:2612:: with SMTP id h18mr28881500ejc.469.1608062436933;
        Tue, 15 Dec 2020 12:00:36 -0800 (PST)
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com. [209.85.218.49])
        by smtp.gmail.com with ESMTPSA id n9sm18598679edy.83.2020.12.15.12.00.36
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Dec 2020 12:00:36 -0800 (PST)
Received: by mail-ej1-f49.google.com with SMTP id n26so29476987eju.6
        for <mm-commits@vger.kernel.org>; Tue, 15 Dec 2020 12:00:36 -0800 (PST)
X-Received: by 2002:ac2:41d9:: with SMTP id d25mr11197984lfi.377.1608061956340;
 Tue, 15 Dec 2020 11:52:36 -0800 (PST)
MIME-Version: 1.0
References: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org> <20201215030730.NC3CU98e4%akpm@linux-foundation.org>
In-Reply-To: <20201215030730.NC3CU98e4%akpm@linux-foundation.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 15 Dec 2020 11:52:19 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgrnTkgP+RVV6SMr+Hv05KR0pUQxrb+-d_Wo3mKD0WeeA@mail.gmail.com>
Message-ID: <CAHk-=wgrnTkgP+RVV6SMr+Hv05KR0pUQxrb+-d_Wo3mKD0WeeA@mail.gmail.com>
Subject: Re: [patch 075/200] mm: speedup mremap on 1GB or larger regions
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     almasrymina@google.com,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Brian Geffon <bgeffon@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Frederic Weisbecker <frederic@kernel.org>, gshan@redhat.com,
        hnaveed@wavecomp.com, Peter Anvin <hpa@zytor.com>,
        John Hubbard <jhubbard@nvidia.com>, justin.he@arm.com,
        kaleshsingh@google.com, Kees Cook <keescook@chromium.org>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Linux-MM <linux-mm@kvack.org>, linuxram@us.ibm.com,
        kernel test robot <lkp@intel.com>,
        Lokesh Gidra <lokeshgidra@google.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>, minchan@google.com,
        Ingo Molnar <mingo@redhat.com>, mm-commits@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Ralph Campbell <rcampbell@nvidia.com>,
        Mike Rapoport <rppt@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        sandipan@linux.ibm.com, Shuah Khan <shuah@kernel.org>,
        SeongJae Park <sjpark@amazon.de>,
        Steven Price <steven.price@arm.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will@kernel.org>, ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Mon, Dec 14, 2020 at 7:07 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> From: Kalesh Singh <kaleshsingh@google.com>
> Subject: mm: speedup mremap on 1GB or larger regions
>
> Android needs to move large memory regions for garbage collection.  The GC
> requires moving physical pages of multi-gigabyte heap using mremap.
> During this move, the application threads have to be paused for
> correctness.  It is critical to keep this pause as short as possible to
> avoid jitters during user interaction.

It would have been good to add a pointer to the PMD case we did earlier..

Also, a few comments on the actual performance in practice would be
nice. Does this actually *trigger* on Android in practice?

I can well imagine the PMD case triggering easily, but are there
real-life Android loads that really do gigabyte heaps? That sounds a
bit odd to me.

So I don't have any complaints about the patch, but I just wonder how
_realistic_ this actually is, particularly the alleged 13x improvement
in timing...

             Linus
