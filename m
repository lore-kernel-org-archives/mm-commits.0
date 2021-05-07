Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 621AAC433B4
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 07:33:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 25781601FF
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 07:33:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232868AbhEGHe1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 May 2021 03:34:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbhEGHeW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 May 2021 03:34:22 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0310BC061574
        for <mm-commits@vger.kernel.org>; Fri,  7 May 2021 00:33:23 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id w4so10341132ljw.9
        for <mm-commits@vger.kernel.org>; Fri, 07 May 2021 00:33:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bApySWlmTsfizudeVmUm2CRbJWPswhG/6Y0dhbrJr7E=;
        b=VcQuqnwfp4qDEkS+zK9V3j86OHrLkqmVnGXei5/r3lgE7od3meqaBsckUS2Kt0xMCS
         yJCYFvuF9t+7+cFmoMNa3dg4wVYrZowROrwPc4GMov1TXU2E85p7VnrBvKeVBwmnrkVB
         z9VO2fEhXGKD0vp1Z1vt36cXiK6c+1jrhI69Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bApySWlmTsfizudeVmUm2CRbJWPswhG/6Y0dhbrJr7E=;
        b=nG2v7A7+pGHC//JlbLZJUyZy3pC6iQwnVxn8pe70O3vnqbBoqfK9F2MzCOSEqwhpWP
         /u7jxUa6GC9Q9wsH39QOU2k5VlDFrpeakUCgJ791zuNVuF2isWeUyhjjxT9LnA1sH3gA
         tGI+t930ub9FDNtgZyxF0b/lf2ohIeecE8X3hL/82EaUuOIzmK3x/kyco1kA4SvBhbTP
         OLexTZXosD2TKTjBmEEj3Za8T/2esInFN4ELhQtO8V/IZB5f36iJDOJtflNo92YZdSs0
         raA9Oyt1VY5hzIZEV6Y9QOIpgZu2d5inrmdXUwjmd9K4iUxR5TRR5wIipFXw0sKPopf9
         LoZw==
X-Gm-Message-State: AOAM531dy9qUkD6ydSrM2yBflw2VLBd2dugBvbEyQN5QXadCLn+RlZzk
        MYHMn/mP2+MfHdWq9aP5lgPCoY/gqgiIQm59TJc=
X-Google-Smtp-Source: ABdhPJy8xj4MmaXWj4Ln8dc9AVAwHvZsmKkeHwFbJbm+lkKT7UWTsXEJmvE4caaG5ZK+KY+y6v6yaA==
X-Received: by 2002:a2e:8596:: with SMTP id b22mr6546471lji.482.1620372801320;
        Fri, 07 May 2021 00:33:21 -0700 (PDT)
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com. [209.85.167.43])
        by smtp.gmail.com with ESMTPSA id y20sm1283327lfe.162.2021.05.07.00.33.21
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 May 2021 00:33:21 -0700 (PDT)
Received: by mail-lf1-f43.google.com with SMTP id x19so11469881lfa.2
        for <mm-commits@vger.kernel.org>; Fri, 07 May 2021 00:33:21 -0700 (PDT)
X-Received: by 2002:ac2:5f92:: with SMTP id r18mr5567590lfe.253.1620372345069;
 Fri, 07 May 2021 00:25:45 -0700 (PDT)
MIME-Version: 1.0
References: <20210506180126.03e1baee7ca52bedb6cc6003@linux-foundation.org> <20210507010432.IN24PudKT%akpm@linux-foundation.org>
In-Reply-To: <20210507010432.IN24PudKT%akpm@linux-foundation.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 7 May 2021 00:25:29 -0700
X-Gmail-Original-Message-ID: <CAHk-=wigjok_oSyrwiJMxQgTGYg9QtbG5xomMm9qQeO68MwsRw@mail.gmail.com>
Message-ID: <CAHk-=wigjok_oSyrwiJMxQgTGYg9QtbG5xomMm9qQeO68MwsRw@mail.gmail.com>
Subject: Re: [patch 48/91] kernel/crash_core: add crashkernel=auto for vmcore creation
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Andrey Konovalov <andreyknvl@google.com>,
        Baoquan He <bhe@redhat.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Colin King <colin.king@canonical.com>,
        Jonathan Corbet <corbet@lwn.net>, dyoung@redhat.com,
        Frederic Weisbecker <frederic@kernel.org>,
        gpiccoli@canonical.com, john.p.donnelly@oracle.com,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Linux-MM <linux-mm@kvack.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Ingo Molnar <mingo@kernel.org>, mm-commits@vger.kernel.org,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mike Rapoport <rppt@kernel.org>,
        saeed.mirzamohammadi@oracle.com,
        Sami Tolvanen <samitolvanen@google.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vivek Goyal <vgoyal@redhat.com>, yifeifz2@illinois.edu
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, May 6, 2021 at 6:04 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> From: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
> Subject: kernel/crash_core: add crashkernel=auto for vmcore creation
>
> This adds crashkernel=auto feature to configure reserved memory for vmcore
> creation.  CONFIG_CRASH_AUTO_STR is defined to be set for different kernel
> distributions and different archs based on their needs.

Ugh. I didn't realize how nasty this was until after I'd applied this patch.

I'm going to drop this patch, because the Kconfig thing for it is an
unmitigated mess. I was confused by the question, and then the help
message was actively misleading.

This is wrong for so many reasons:

 - this is a classic case of "you shouldn't ask a user this".

   The question makes no sense to any normal person, it certainly
didn't to me. Don't ask questions that don't have sane answers.

 - the config help text is actively misleading, and claims that the
option is about how much memory is reserved for a crash kernel

   Not so. It's the default string for when somebody uses "crashkernel=auto"

 - this shouldn't be a config option at all, it's clearly a distro
setting, and should be on the kernel command line with the other
distro settings.

So I'm dropping this, and I don't see it ever being applied in this
form for the above reasons.

People, I've said this before, and apparently I need to say it again:
the kernel config is likely the nastiest part of building a local
kernel, and the biggest impediment to people actually building their
own kernels.

And people building their own kernel is the first step to becoming a
kernel developer.

So the kernel configuration is already one of the less pleasant parts
of the kernel, but that does NOT mean that we should strive to make it
even worse.

Obscure, odd, strange config questions like this are a no-no. We're
not making an already bad experience wose for something like this.

           Linus
