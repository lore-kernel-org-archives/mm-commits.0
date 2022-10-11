Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38748C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 11 Oct 2022 17:11:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbiJKRLd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Oct 2022 13:11:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiJKRLc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Oct 2022 13:11:32 -0400
Received: from mail-oo1-xc2a.google.com (mail-oo1-xc2a.google.com [IPv6:2607:f8b0:4864:20::c2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C30345A891
        for <mm-commits@vger.kernel.org>; Tue, 11 Oct 2022 10:11:31 -0700 (PDT)
Received: by mail-oo1-xc2a.google.com with SMTP id r11-20020a4aa2cb000000b004806f49e27eso4409754ool.7
        for <mm-commits@vger.kernel.org>; Tue, 11 Oct 2022 10:11:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=BvBn0lntalCDidDjbA7w+SCkEO+LKl4O05VhkDUH/vU=;
        b=bSmudPi0IHNcb0hgJsa7o3HQK6sOc4zIc1Wi+JzL70zSd7KHq+fSMonbswMWenz8N+
         DsVjCGftVd99UWuC3joXnTdOtUDqKC3VemMBEqWpIXL0wgXZU4YFZ09mdJOMwW5A/UZC
         ee7ZWWmjM1hBBgyteKApw8WZ1kZsheIqG+sxc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BvBn0lntalCDidDjbA7w+SCkEO+LKl4O05VhkDUH/vU=;
        b=YHMqbfJdfBnL6LfvGGyiRvDKRnmjZwRikub1j4qoU+qWxk/kCJ0MszpaRaEveABCcW
         s0GQJY8XaFFrjXduzNqdl7PWsFkvdm92GS3bSFeqYlek7+3SCtvtha7Aj81dfSo1cPxQ
         E1hMuDbiIXjq+uWJexpqfY71vjeS/sBZV5rZIebt6gK+GSgH6htNh1SIKCQOeaF7GEkl
         AhZGK85QcQlF6mdE6wmpaP7byZkYA1pgdU+cjXNhvCixP50JKiQw/J+VnpE+osSVF0FR
         Iu3vUWgQiBMuuLuhiioz7s2tBPL9eIZu7K4pcgOX1M3RyFG277pGiM1rbt5T1YdcQVp/
         RyLA==
X-Gm-Message-State: ACrzQf0XDpAyvfQcpht9YnDLNsLxzo+RaPzSP344IzVpWbPrcyAaniqi
        6q0DyijxHb25tl/GQNsI/xBJ1AFLTm9uOw==
X-Google-Smtp-Source: AMsMyM464n1jCwR/tNfgUWK+2uB0LsnJfMvtkxX7XCgenR9vwBZMFy++XtFzVDRVAE+a0D+K7HKisQ==
X-Received: by 2002:a05:6830:6999:b0:661:3006:7cfb with SMTP id cy25-20020a056830699900b0066130067cfbmr10164327otb.42.1665508290315;
        Tue, 11 Oct 2022 10:11:30 -0700 (PDT)
Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com. [209.85.167.174])
        by smtp.gmail.com with ESMTPSA id bu11-20020a0568300d0b00b00655ca9a109bsm6458557otb.36.2022.10.11.10.11.27
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Oct 2022 10:11:28 -0700 (PDT)
Received: by mail-oi1-f174.google.com with SMTP id j188so9572914oih.4
        for <mm-commits@vger.kernel.org>; Tue, 11 Oct 2022 10:11:27 -0700 (PDT)
X-Received: by 2002:aca:b957:0:b0:351:4ecf:477d with SMTP id
 j84-20020acab957000000b003514ecf477dmr73295oif.126.1665508287655; Tue, 11 Oct
 2022 10:11:27 -0700 (PDT)
MIME-Version: 1.0
References: <20221008132113.919b9b894426297de78ac00f@linux-foundation.org>
 <CAHk-=wigZoriP8ZB+V87Jf+EQV=ka6DQe_HCAQmh3Dmus2FFhw@mail.gmail.com> <CAG_fn=WuMUKjdNwpcc7Msh6wrXFEkigYJJv9rS9+iMJO2d5Y-w@mail.gmail.com>
In-Reply-To: <CAG_fn=WuMUKjdNwpcc7Msh6wrXFEkigYJJv9rS9+iMJO2d5Y-w@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 11 Oct 2022 10:11:11 -0700
X-Gmail-Original-Message-ID: <CAHk-=wj-_peVY71FK7nX7p36VYacf2mFD5i4fKQpqk77J8K9Aw@mail.gmail.com>
Message-ID: <CAHk-=wj-_peVY71FK7nX7p36VYacf2mFD5i4fKQpqk77J8K9Aw@mail.gmail.com>
Subject: Re: [GIT PULL] MM updates for 6.1-rc1
To:     Alexander Potapenko <glider@google.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Andrey Konovalov <andreyknvl@google.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        mm-commits@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Tue, Oct 11, 2022 at 2:03 AM Alexander Potapenko <glider@google.com> wrote:
>
> Small nit:
>
>      - Dmitry Vyukov introduces KMSAN: the Kernel Memory Sanitizer. It uses
>        clang-generated instrumentation to detect used-unintialized bugs down
>        to the single bit level.
>
> s/Dmitry Vyukov/Alexander Potapenko/ ;)

Uhhuh. I just took what Andrew told me for the commit message, so we
have that error in the history now.

Then when I reported my conflict resolution, at that point I actually
looked at the commit that introduced it, which is why I cc'd you.

So you got all the blame, and none of the glory. Sorry about that,

                   Linus
