Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70972C433F5
	for <mm-commits@archiver.kernel.org>; Sat,  6 Nov 2021 23:27:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4275460232
	for <mm-commits@archiver.kernel.org>; Sat,  6 Nov 2021 23:27:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229869AbhKFX36 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 6 Nov 2021 19:29:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229843AbhKFX35 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 6 Nov 2021 19:29:57 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4369C061570
        for <mm-commits@vger.kernel.org>; Sat,  6 Nov 2021 16:27:15 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id u11so26944351lfs.1
        for <mm-commits@vger.kernel.org>; Sat, 06 Nov 2021 16:27:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0O9H11CHR/LBeotHonKsdnZt5YOq8AQ+XiJJoaG/1Rc=;
        b=Z/y/pSlK8vTMaTWwtZV/KrzxvxBM3LZzJ6sESUQ5NNgN+MhuJd01YB7fwNjqngWKer
         GauWyAp9meEuwj6eelbF0Is4obI8tqrh1ZlWYl+SXFet1/iw8LjdzeZVxYzi+FKOq3p1
         PJdfk1RHiPgtWX7GYTgoQ0KwkihpgH7cSzMmA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0O9H11CHR/LBeotHonKsdnZt5YOq8AQ+XiJJoaG/1Rc=;
        b=5ECd5d8y8ANRX6LfdZ6cN6JGNr2MA2mu5zXx5FTvtJn69fW3bQb5ChgY1FgWAE5ShY
         MUwca2U3mZruTlQJsiKxLAqDQJacC+wQJl7Ci8Ax0ki4tMAmgmeBX1B4IRzVcBOVRJlB
         +wBA1sEhbH+3wQF7+9LUhlFUf01o1APuoBzSBV20sF6nB8SlcPgAspwX69bnFEOeDsXa
         481oh4O8XYkNkHdV/p6jDi6Ektf/1xmQu0aq8szCOzb2Vbhj//FUUjR0caYpss3u19Nf
         ZYMAHo5Hk6YED8/F++Ch1Y0HojMeETNDhNESb+M5QgGoQoDz7eWhq8daWb+3Tp4VtYA9
         6VdA==
X-Gm-Message-State: AOAM5327n/7rnZzfeXNoB7AVlNNeMUs9LonW7o6EAdzJYuSk1+tDar8Y
        Ys7m63HUsw9Y3WGeoK5h6CXABcZbgSpBpC7HR0o=
X-Google-Smtp-Source: ABdhPJxr5TbQ1nyw5jrJg5fvyeqkRtU/iFszZRVELs1Oy2+gylhiZh4VMmKxhFdlM6qzTGT3SXoGtg==
X-Received: by 2002:a19:5611:: with SMTP id k17mr48847770lfb.106.1636241233241;
        Sat, 06 Nov 2021 16:27:13 -0700 (PDT)
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com. [209.85.167.41])
        by smtp.gmail.com with ESMTPSA id bi3sm1287531lfb.49.2021.11.06.16.27.11
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 06 Nov 2021 16:27:11 -0700 (PDT)
Received: by mail-lf1-f41.google.com with SMTP id y26so26835234lfa.11
        for <mm-commits@vger.kernel.org>; Sat, 06 Nov 2021 16:27:11 -0700 (PDT)
X-Received: by 2002:a05:6512:3993:: with SMTP id j19mr59499729lfu.402.1636241231188;
 Sat, 06 Nov 2021 16:27:11 -0700 (PDT)
MIME-Version: 1.0
References: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
 <20211105204225.iIh99P9cn%akpm@linux-foundation.org> <YYWb5jTLkNRUI6ea@casper.infradead.org>
 <CAHk-=wi=D7f9H=3cxcZm16-iCRJY5EBaJ4kTjp+UjpD4dsNKPw@mail.gmail.com>
 <CAHk-=wgDdPxNWvQ8n=LW5bQeuq2WvP=5pnCZe2aubodfNR1JBg@mail.gmail.com> <YYcFjgDQRc0H/X/z@casper.infradead.org>
In-Reply-To: <YYcFjgDQRc0H/X/z@casper.infradead.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 6 Nov 2021 16:26:55 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgWJaRq0dVkCOcMRNnekbmtBwOmDZNR6gLcBAih6Tb-Xg@mail.gmail.com>
Message-ID: <CAHk-=wgWJaRq0dVkCOcMRNnekbmtBwOmDZNR6gLcBAih6Tb-Xg@mail.gmail.com>
Subject: Re: [patch 149/262] mm/vmscan: throttle reclaim until some writeback
 completes if congested
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jonathan Corbet <corbet@lwn.net>,
        Dave Chinner <david@fromorbit.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Linux-MM <linux-mm@kvack.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Michal Hocko <mhocko@suse.com>, mm-commits@vger.kernel.org,
        Neil Brown <neilb@suse.de>, Rik van Riel <riel@surriel.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Vlastimil Babka <vbabka@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Sat, Nov 6, 2021 at 3:46 PM Matthew Wilcox <willy@infradead.org> wrote:
>
> Reviewed what you did in the merge commit, looks good to me.  And I've
> learned I need to run git log --cc instead of -p in order to see all
> changes to a file.

Heh.

If this is your first time using "--cc" (although it's the default for
"git show", so you may have used it without being aware of it), it's
very useful and powerful, but it's worth keeping in mind that it's
also a lot more limited than the merge-time "git diff" output.

At merge time, git has computed the shared state parenthood, and "git
diff" knows about not only the current state, but also the state of
both parents and the base state of the file (in a three-way merge kind
of sense, although with recursive merges the "base state" may be much
more complex than just a shared parent state).

But "git log --cc" (and related "show commit" kind of things, like
"git show" and friends) only sees the final result and the parent
information. The full common parent and base state isn't there
after-the-fact.

That means that "git log --cc" doesn't have quite as much information
to go by, and the "--cc" output can sometimes be a bit misleading.

In particular, if there was a conflict, and the resolution ended up
basically being "take one side where the conflict was", then "git log
--cc" will not show the conflict resolution as a conflict at all - it
will just think "ok, development was done on that branch, the other
side was irrelevant".

So "--cc" is very useful, and often shows that interesting sub-part of
the merge where there were conflicts. But it's definitely somewhat
limited, and can end up looking like there was no conflict at all even
when there was something.

           Linus
