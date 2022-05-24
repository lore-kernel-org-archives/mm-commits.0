Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57809C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 24 May 2022 16:52:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238453AbiEXQwU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 24 May 2022 12:52:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234234AbiEXQwS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 24 May 2022 12:52:18 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A015D5EBCB
        for <mm-commits@vger.kernel.org>; Tue, 24 May 2022 09:52:17 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id n23so23920265edy.0
        for <mm-commits@vger.kernel.org>; Tue, 24 May 2022 09:52:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=r/MuG6L5wg6ekbZqKkFBCkCsgRhVQuriQemtR5tAuqg=;
        b=GD0YwoCZ3S1CikkMRh9gYfg7qoT48l1Xa6UQr2p67srysKfZzcCTz/BRE42M9MvHXy
         r6CVpL37X9JBP6LzKjXB2VbbX0S27JFNl1Vp3NSPTgsvhxgjlBF47XC7zTM/3O9sNGG/
         bgJgMIBZIMuWPYgKHYjJmlEiPET6u2cOAE44g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=r/MuG6L5wg6ekbZqKkFBCkCsgRhVQuriQemtR5tAuqg=;
        b=EkNZGFxxPHp/5ftvq9f4kOEHYppV8hKTRUqnYVeyREcppdcZ3K4fQqr+k1tMQnoFcK
         /s+DHCmXnIIUi480i9jS8ii+1q4VeLWKXbtq1guQnH+chrYe1cV0NBqUzvrHcwRvG5SY
         drTdV062p58cTx2M7vgXtSlWl0HJe0poMIdCl+eWgDBvL6bAcMm8417LDZvTRSqYhcbj
         yBDiVe/XMAG/K5varNkCMTnbhxbV/EG9vc+X4bXePCGPu24JgGBYmpR7bUn9vNwzxfbQ
         O23sOYz2eP6iPjVWaZnySOf/H951oMBumIE0l2rwlAc6lZp2TSmKxRGd1Ncw7bOi+S5e
         jq8w==
X-Gm-Message-State: AOAM533wyV6+GpV97SpKgKMXjb7W2IMfGuOlo39rb9XTwEL3Fr8Kj2r9
        EFyALOFYMpRxSfIBB27Zaeb+3eQnH8aizc/G
X-Google-Smtp-Source: ABdhPJw7IB0skzSpbCwTQwE98cB1+t1dAIWMa6rK7O9CSKh9VC+VtBo4Jorp9xkLwfbRdpRCzogwkw==
X-Received: by 2002:a50:f69c:0:b0:42a:b933:d1d with SMTP id d28-20020a50f69c000000b0042ab9330d1dmr29240602edn.365.1653411136019;
        Tue, 24 May 2022 09:52:16 -0700 (PDT)
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com. [209.85.128.42])
        by smtp.gmail.com with ESMTPSA id a23-20020a05640213d700b0042ab4e20543sm9658426edx.48.2022.05.24.09.52.12
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 May 2022 09:52:13 -0700 (PDT)
Received: by mail-wm1-f42.google.com with SMTP id r126-20020a1c4484000000b00397345f2c6fso1437839wma.4
        for <mm-commits@vger.kernel.org>; Tue, 24 May 2022 09:52:12 -0700 (PDT)
X-Received: by 2002:a7b:cb91:0:b0:397:3225:244 with SMTP id
 m17-20020a7bcb91000000b0039732250244mr4682864wmi.68.1653411132437; Tue, 24
 May 2022 09:52:12 -0700 (PDT)
MIME-Version: 1.0
References: <YnLMSWbz6BNfsBME@zn.tnic> <CAHk-=wh_62HBCz1g_6mKP71XOvJAs3JwBz0=jve2mg1DGWPq5g@mail.gmail.com>
 <YnLfl6lupN2nq7+t@zn.tnic> <CAHk-=wiGbrJMim6EWncZUQBzguqy-vtNd+grfNizm5L8Vcmu+w@mail.gmail.com>
 <YnLplKy0Y66SsvQw@zn.tnic> <CAHk-=wjUX5DGNSiBYvPC8fQJGRe5_RWR8NW=gYF4=UpPiwCE8A@mail.gmail.com>
 <Ynow8F3G8Kl6V3gu@zn.tnic> <CAHk-=whCmmipbBDips0OJ=UiBUjZfgBGYruoOsqcq2TVd5kBSA@mail.gmail.com>
 <YnqqhmYv75p+xl73@zn.tnic> <Ynq1nVpu1xCpjnXm@zn.tnic> <YozQZMyQ0NDdD8cH@zn.tnic>
In-Reply-To: <YozQZMyQ0NDdD8cH@zn.tnic>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 24 May 2022 09:51:56 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiJ9xqFrdDJtUD3oc1kCxYcVjLi5BjBY-3NVHgYxYb_HA@mail.gmail.com>
Message-ID: <CAHk-=wiJ9xqFrdDJtUD3oc1kCxYcVjLi5BjBY-3NVHgYxYb_HA@mail.gmail.com>
Subject: Re: [PATCH] x86/clear_user: Make it faster
To:     Borislav Petkov <bp@alien8.de>
Cc:     Mark Hemment <markhemm@googlemail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        patrice.chotard@foss.st.com, Mikulas Patocka <mpatocka@redhat.com>,
        Lukas Czerner <lczerner@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Hugh Dickins <hughd@google.com>, patches@lists.linux.dev,
        Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org,
        Mel Gorman <mgorman@suse.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Tue, May 24, 2022 at 5:32 AM Borislav Petkov <bp@alien8.de> wrote:
>
> finally a somewhat final version, lightly tested.

I can't find anything wrong with this, but who knows what
patch-blindness I have from looking at a few different versions of it.
Maybe my eyes just skim over it now.

I do note that the clearing of %rax here:

> +.Lerms_exit:
> +       xorl %eax,%eax
> +       RET

seems to be unnecessary, since %rax is never modified in the path
leading to this. But maybe just as well just for consistency with the
cases where it *is* used as a temporary.

And I still suspect that "copy_to_user()" is *much* more interesting
than "clear_user()", but I guess we can't inline it anyway due to all
the other overhead (ie access_ok() and stac/clac).

And for a plain "call memcpy/memset", we'd need compiler help to do
this (at a minimum, we'd have to have the compiler use the 'rep
movs/stos' register logic, and then we could patch things in place
afterwards, with objtool creating the alternatives section or
something).

                    Linus
