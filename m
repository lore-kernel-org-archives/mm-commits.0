Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74B7DC433F5
	for <mm-commits@archiver.kernel.org>; Sat,  6 Nov 2021 21:12:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5340B6120A
	for <mm-commits@archiver.kernel.org>; Sat,  6 Nov 2021 21:12:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233921AbhKFVPF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 6 Nov 2021 17:15:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231159AbhKFVPE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 6 Nov 2021 17:15:04 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D95F0C061570
        for <mm-commits@vger.kernel.org>; Sat,  6 Nov 2021 14:12:22 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id x27so26445593lfu.5
        for <mm-commits@vger.kernel.org>; Sat, 06 Nov 2021 14:12:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Objj6YxuQIiT268265+4lRwjorCzYJtOd/jCKS7TfhA=;
        b=U4gr9OdTo9UkiIg503Lm+bijEJa2gVLtZuYFPshcvOyaL6cBIDkZo+fnL/Sel77+SB
         ZDxHuKn5DvTIT01kXgxv3GaS4NAGcBfh7O7OPojC+EOGxcvaC7DIpinFmGvjhrVROPob
         +s73W79O97OioWKIymJ3J7kWS2j5x2a5LKNkg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Objj6YxuQIiT268265+4lRwjorCzYJtOd/jCKS7TfhA=;
        b=ah9euFoHgqnZEnUd+cZ6Hqjg9Fa7mA3Ag3n+xjxVQm4fQQ/kme9SMUgjPMTlCaLH/X
         wpholfOSfTXZy1XLXlznlt5xksjPah94RuFPtkaRpOhPTGYi2iJXvU3PQhrhGykus+gJ
         +UEHthBfc3jQbugxKYKSJ4sjD5vBysTGnzlHrARMbpPrWqXLF+hRQ47IyRDnDDLeFamA
         41JES5va4ZS8X4iXk4ud7fSbCdG50y0npdmGyiWR4XVYL2QLQKq6E5HyAkt7BowHin/f
         mNHc8ceK4Zt7fjiGMGVYQ3z9Jnk+QpJvd/SPWO07YQSv7OufzUpvI/50Yps5kDxmFhd2
         qCpQ==
X-Gm-Message-State: AOAM530dGjj9VGZDl1ISab8tT7HjliFDgRLApQ7w5r8ZegbyZPSpgqHR
        e0RFX8FaBmhnTAmGqJgNcXVboD26vXDeVsj3zn0=
X-Google-Smtp-Source: ABdhPJz2bgMtEfGpLGl+Yh7UuEqvq7AfcAi6coSqvwf1vDcD5xP3cN8qXiWgBXEVbIqpQ5/TDzy32w==
X-Received: by 2002:ac2:5e33:: with SMTP id o19mr5962934lfg.85.1636233140753;
        Sat, 06 Nov 2021 14:12:20 -0700 (PDT)
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com. [209.85.167.54])
        by smtp.gmail.com with ESMTPSA id l2sm564466lfg.290.2021.11.06.14.12.18
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 06 Nov 2021 14:12:18 -0700 (PDT)
Received: by mail-lf1-f54.google.com with SMTP id u11so26484154lfs.1
        for <mm-commits@vger.kernel.org>; Sat, 06 Nov 2021 14:12:18 -0700 (PDT)
X-Received: by 2002:a05:6512:13a5:: with SMTP id p37mr60408920lfa.474.1636233138293;
 Sat, 06 Nov 2021 14:12:18 -0700 (PDT)
MIME-Version: 1.0
References: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
 <20211105204225.iIh99P9cn%akpm@linux-foundation.org> <YYWb5jTLkNRUI6ea@casper.infradead.org>
 <CAHk-=wi=D7f9H=3cxcZm16-iCRJY5EBaJ4kTjp+UjpD4dsNKPw@mail.gmail.com>
In-Reply-To: <CAHk-=wi=D7f9H=3cxcZm16-iCRJY5EBaJ4kTjp+UjpD4dsNKPw@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 6 Nov 2021 14:12:02 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgDdPxNWvQ8n=LW5bQeuq2WvP=5pnCZe2aubodfNR1JBg@mail.gmail.com>
Message-ID: <CAHk-=wgDdPxNWvQ8n=LW5bQeuq2WvP=5pnCZe2aubodfNR1JBg@mail.gmail.com>
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

On Sat, Nov 6, 2021 at 1:49 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> This workflow can result in more conflicts for me than what Andrew
> used to do ("send against current linus tip"), but it means that when
> conflicts happen, they get all the merge resolution help that git
> gives you, and hopefully what gets tested (over the months that it can
> be in -mm) is closer to what gets sent to me.

.. and resolving the conflicts (none of which looked bad), I think
that part of the resolution ends up doing very similar things to your
fixup patch.

So it looks all good.

Famous last words.

                Linus
