Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECAF1C433F5
	for <mm-commits@archiver.kernel.org>; Sat,  6 Nov 2021 21:21:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CBB4F60240
	for <mm-commits@archiver.kernel.org>; Sat,  6 Nov 2021 21:21:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235149AbhKFVXn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 6 Nov 2021 17:23:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235155AbhKFVXn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 6 Nov 2021 17:23:43 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F561C061570
        for <mm-commits@vger.kernel.org>; Sat,  6 Nov 2021 14:21:01 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id d12so22929820lfv.6
        for <mm-commits@vger.kernel.org>; Sat, 06 Nov 2021 14:21:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lCc3YeCdHo2e3Ru8bueGswsYqbOaxs0YN7dp3QCxbNg=;
        b=TVIImmQBvd2hjuDjBkJSLHFA0zJWF/WlwN/r8YPkn+HObyHYSGm9GJw5H6ectn8Js3
         HdXOA/1bG5tyF2SUg0BLPYg4pPuz00xTveeHNezlP80YJw7JvMFrX/KJpwPfsw5nbZuI
         4QxXMWouiGMQOzz2mAjQsGJUN9FP3yPNVagMw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lCc3YeCdHo2e3Ru8bueGswsYqbOaxs0YN7dp3QCxbNg=;
        b=W97ydXC5/G8tYem6zQuLNIY62EEtXhbbeurgB5A9ezLtmGQkRAqFtjlBCwyQo91hgT
         kj29oaiDiYow+vLoxgxpyeHp24ZQCABSmjaXOG3F8zmpaXJOi8SvUg42UZptElB9Xt9X
         p84wgSRAtHOqnwY8HlEc9K1V45uHzBa0B49b7w8CzC7fqGH0hbG7H3pTaj5Q4StcFGRb
         j22hHiKzzcWn/VLBxpXzPEfROXO5U+1LD+5UlNjzXbTKNzrMqU3tYdshI41WWuQa6R34
         3V6nPdAkwBAeKp9IxFZBR9QM35QBNGgj9eWBcRguuR2P5ZjAxZXUincmPNSiRyo7+D3w
         0x6Q==
X-Gm-Message-State: AOAM5338b7JNXjdwfIxx14nasLoeQEfv8Vs8sonouoRKdPxCCIgzHZS/
        hNwL1KAn9h+heubdjJsZqofpDnUfztVxeqRLkuk=
X-Google-Smtp-Source: ABdhPJxGHPFZ24OvMG3mqk3+fzS54gHueeMTJ1k/9CK5NnZmYtjH7seGFzG2u7DW/ewN9VIDYqvO7g==
X-Received: by 2002:ac2:51ac:: with SMTP id f12mr4494990lfk.6.1636233659472;
        Sat, 06 Nov 2021 14:20:59 -0700 (PDT)
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com. [209.85.167.51])
        by smtp.gmail.com with ESMTPSA id c15sm1260087lft.244.2021.11.06.14.20.58
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 06 Nov 2021 14:20:58 -0700 (PDT)
Received: by mail-lf1-f51.google.com with SMTP id d21so26425673lfg.7
        for <mm-commits@vger.kernel.org>; Sat, 06 Nov 2021 14:20:58 -0700 (PDT)
X-Received: by 2002:a19:ad0c:: with SMTP id t12mr62018562lfc.173.1636233658168;
 Sat, 06 Nov 2021 14:20:58 -0700 (PDT)
MIME-Version: 1.0
References: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
 <20211105204225.iIh99P9cn%akpm@linux-foundation.org> <YYWb5jTLkNRUI6ea@casper.infradead.org>
 <CAHk-=wi=D7f9H=3cxcZm16-iCRJY5EBaJ4kTjp+UjpD4dsNKPw@mail.gmail.com>
 <CAHk-=wgDdPxNWvQ8n=LW5bQeuq2WvP=5pnCZe2aubodfNR1JBg@mail.gmail.com> <e08fa92e-31bc-c340-fd31-d4535d922aed@suse.cz>
In-Reply-To: <e08fa92e-31bc-c340-fd31-d4535d922aed@suse.cz>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 6 Nov 2021 14:20:42 -0700
X-Gmail-Original-Message-ID: <CAHk-=whE7VNHVf=OqiZoxd7zufE_5MmJA1od=fQMS57eFjtSGg@mail.gmail.com>
Message-ID: <CAHk-=whE7VNHVf=OqiZoxd7zufE_5MmJA1od=fQMS57eFjtSGg@mail.gmail.com>
Subject: Re: [patch 149/262] mm/vmscan: throttle reclaim until some writeback
 completes if congested
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jonathan Corbet <corbet@lwn.net>,
        Dave Chinner <david@fromorbit.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Linux-MM <linux-mm@kvack.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Michal Hocko <mhocko@suse.com>, mm-commits@vger.kernel.org,
        Neil Brown <neilb@suse.de>, Rik van Riel <riel@surriel.com>,
        "Theodore Ts'o" <tytso@mit.edu>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Sat, Nov 6, 2021 at 2:13 PM Vlastimil Babka <vbabka@suse.cz> wrote:
>
> If this needed resolution, didn't the resolution exist in -next already?

Oh, I'm sure it was there in -next.

But I just always do my own merge resolution anyway because I want to
see what's going on.

I don't look at other peoples resolutions, and I much prefer to
actually look at the history itself in order to actually understand
what the history and cause for the conflicts is (and what the proper
resolution was).

Of course, in many cases it's so trivial that there's not a lot to
"understand", and most merge conflicts by far are not the kind that
need a lot of thought.

But just to clarify: I do actually like seeing people send their
resolutions to me (possibly as an addendum to the pull request email,
or possibly as a separate "resolved" branch).

I don't use those to guide my resolution, but if there is any subtle
issues at all, I will then compare the end results to verify that they
agreed. Often any differences tend to be just whitespace or similar,
but it can be interesting to see when there are meaningful semantic
differences.

          Linus
