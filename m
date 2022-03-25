Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDA33C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 02:04:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237272AbiCYCFh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 22:05:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357661AbiCYCFg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 22:05:36 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CE64A27FD
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 19:04:03 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id qx21so12613867ejb.13
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 19:04:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ngtVr9tesRrH3h9QuJdwsRWwUqV+lCc3sEv7bM/pFPs=;
        b=S6nDFjuC5irly55Lifc9R62XBYSxZJDRmTi0DdDbogM1HSiCQm+1qbdjfGbyF021eP
         fEF2cncLSM88eWWsLKedyC+Z2HLojh7NeGRv6ZfKizTnEqphPmPBkhbk1gP4Cqld8agq
         j+FqOohMFDtUCRF5jWZ2XNLWo6mMTAQVnDgWg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ngtVr9tesRrH3h9QuJdwsRWwUqV+lCc3sEv7bM/pFPs=;
        b=yduUrtgpfxkDN8qlsHQv2t8DwIP08o9zZH9S+2sfgVMa/peBxPBT2XbgKEisjSAq3g
         BiaGoZI1U3t6I8jtT19qQvIcaPQJiqAyehzuPAb8NuRuLD2OJ2VNH8lULhWLVR3f3QCE
         rU9dz7wLx6aOUccitNC3jC4gVJUna2EfeLjLMb5i2EUR9dCX4hc014qFlY90LMssZveG
         Gc/8P4PcsuxqWK2pa+6iaROXbeSrXbzlXlOpYoXy8NjTWTiOp4Q4hNZF5YNe9J9b1A2v
         wiCMPHHshz3HH8XYlZdNYfyPoXdM6C/EjTvCf8rb0gpvPEMnLxDxaff+fqfQGXuzL3sE
         oQPA==
X-Gm-Message-State: AOAM531tn9TIQx60GHz5TZ6GiWmblukZ/zzVqZXZOdVDc8u73fgTfkFj
        Biotleh06eclW8npQG2DxHv/wxaSWUoAKZI8AH0=
X-Google-Smtp-Source: ABdhPJx46GAjlaV8IhGh9Tby4iorIm8HeikcSFwXAE/29UtRcvu5jjuM9L6sJ12o0BWGs+kOJ6Nycw==
X-Received: by 2002:a17:907:3e82:b0:6da:6f15:ff38 with SMTP id hs2-20020a1709073e8200b006da6f15ff38mr8870488ejc.324.1648173841490;
        Thu, 24 Mar 2022 19:04:01 -0700 (PDT)
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com. [209.85.218.49])
        by smtp.gmail.com with ESMTPSA id c2-20020aa7d602000000b0041997b3ce40sm880973edr.86.2022.03.24.19.04.01
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Mar 2022 19:04:01 -0700 (PDT)
Received: by mail-ej1-f49.google.com with SMTP id bg10so12676269ejb.4
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 19:04:01 -0700 (PDT)
X-Received: by 2002:a2e:a5c4:0:b0:249:9ec3:f2b with SMTP id
 n4-20020a2ea5c4000000b002499ec30f2bmr6190271ljp.358.1648173425818; Thu, 24
 Mar 2022 18:57:05 -0700 (PDT)
MIME-Version: 1.0
References: <20220324180758.96b1ac7e17675d6bc474485e@linux-foundation.org> <20220325011415.C645DC340EC@smtp.kernel.org>
In-Reply-To: <20220325011415.C645DC340EC@smtp.kernel.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 24 Mar 2022 18:56:49 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiLFGsHbbAEJV3j=Gj1p2foAf4+76XbH-nYzFh7EbxTPg@mail.gmail.com>
Message-ID: <CAHk-=wiLFGsHbbAEJV3j=Gj1p2foAf4+76XbH-nYzFh7EbxTPg@mail.gmail.com>
Subject: Re: [patch 113/114] selftests: vm: remove dependecy from internal
 kernel macros
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Shuah Khan <shuah@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        mathew.j.martineau@linux.intel.com,
        Jakub Kicinski <kuba@kernel.org>,
        Darren Hart <dvhart@infradead.org>,
        Davidlohr Bueso <dave@stgolabs.net>,
        David Miller <davem@davemloft.net>, chi.minghao@zte.com.cn,
        Alistair Popple <apopple@nvidia.com>,
        andrealmeid@collabora.com, usama.anjum@collabora.com,
        patches@lists.linux.dev, Linux-MM <linux-mm@kvack.org>,
        mm-commits@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, Mar 24, 2022 at 6:14 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> From: Muhammad Usama Anjum <usama.anjum@collabora.com>
> Subject: selftests: vm: remove dependecy from internal kernel macros

What what what?

> --- a/tools/testing/selftests/vm/userfaultfd.c~selftests-vm-remove-dependecy-from-internal-kernel-macros
> +++ a/tools/testing/selftests/vm/userfaultfd.c
> @@ -122,6 +122,9 @@ struct uffd_stats {
>  #define swap(a, b) \
>         do { typeof(a) __tmp = (a); (a) = (b); (b) = __tmp; } while (0)
>
> +#define swap(a, b) \
> +       do { typeof(a) __tmp = (a); (a) = (b); (b) = __tmp; } while (0)
> +
>  const char *examples =
>      "# Run anonymous memory test on 100MiB region with 99999 bounces:\n"
>      "./userfaultfd anon 100 99999\n\n"

Read that patch one more time.

This was already merged in commit 681696862bc1 ("selftests: vm: remove
dependecy from internal kernel macros"), just how many of those
'swap()' macros do you think we need?

Your patch managment logic seems to have failed the "was this already
applied" thing.

This smells like another "it applied with some context noise that I
just ignored" thing. Please please PLEASE use "-F0" to apply patches,
and if you have context that causes it to not apply cleanly,
double-check what is up.

(And if you are not git tool based, the *default* for git is to not
ignore context. But if you have scripts that do "-C1" or something to
ignore context lines, please make them warn very very loudly)

               Linus
