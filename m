Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C99D2C433FE
	for <mm-commits@archiver.kernel.org>; Sat,  6 Nov 2021 20:50:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A86396120A
	for <mm-commits@archiver.kernel.org>; Sat,  6 Nov 2021 20:50:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230268AbhKFUww (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 6 Nov 2021 16:52:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbhKFUww (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 6 Nov 2021 16:52:52 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F499C061570
        for <mm-commits@vger.kernel.org>; Sat,  6 Nov 2021 13:50:10 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id h11so21296089ljk.1
        for <mm-commits@vger.kernel.org>; Sat, 06 Nov 2021 13:50:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gIwI2+vdyaBUs1d2e1o7WY8c7yHceBuSOfT7syHIWJ0=;
        b=deviKqN+qTBXfylbEOBcZ/bwz9QhTdQAFm7LRuDtZ7+N0bKkIQ1lEivLalVjjegn3W
         ZKHLTh2zi7BcMRlRTPdBVUF4VmSVJWyQel8dZS3VWjqs474wX53RPEF+vGjfZKIkf1xS
         05VvFBhbxtvYdL+tgRpmzL3MhyxTAHJW0DFz0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gIwI2+vdyaBUs1d2e1o7WY8c7yHceBuSOfT7syHIWJ0=;
        b=l37J8k9spPZqY4vZwCl+CVVhAszT2it5dxUw6R82TxR2YEbUufeZtHX55rzrnnTDQf
         FGr2ZotmHYkdyUHMJEAVIaRSmtP+jQ2tuhR05rW0DeOKnP7BoYPUSEcKl6TtZSV2Ku/Q
         Ro0RkTI2thESi/AJ1lNtqpw306WIfxKVs7LuJMDPC5OTv2CzoLxxUGhSuGT4obnz5K1K
         9Ys89RdBn++S3Yqy+7Itm643vsZXkdyZ495wQEEMzKgHSGyVlmzdv8NDYzwkxXh9x9sb
         NqY/tZfEyK4vQaFo28jjoToXVHIGAQ6Kez6lYpNmF1WZdiXuNR5UbVwJ67q4nRUHrJwc
         eyHQ==
X-Gm-Message-State: AOAM531927uwgtvK5XGPrOWR94SwxgEI3DHsTXWN9KySStVnQlR9FpmR
        fKkHg60xkuThXd9hq1q8Gu4XjbSGLmR2ErSx
X-Google-Smtp-Source: ABdhPJy4+tGEmAgtctaGaoAVS/RXVbU0a/pX3z8ft4kCM3yrRQ+BHivJX+ItPBqQbixwzRjjlq9A2g==
X-Received: by 2002:a2e:8584:: with SMTP id b4mr70421376lji.14.1636231807526;
        Sat, 06 Nov 2021 13:50:07 -0700 (PDT)
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com. [209.85.208.176])
        by smtp.gmail.com with ESMTPSA id h4sm1252949lft.184.2021.11.06.13.50.05
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 06 Nov 2021 13:50:05 -0700 (PDT)
Received: by mail-lj1-f176.google.com with SMTP id i26so21214400ljg.7
        for <mm-commits@vger.kernel.org>; Sat, 06 Nov 2021 13:50:05 -0700 (PDT)
X-Received: by 2002:a05:651c:17a6:: with SMTP id bn38mr69526616ljb.56.1636231804824;
 Sat, 06 Nov 2021 13:50:04 -0700 (PDT)
MIME-Version: 1.0
References: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
 <20211105204225.iIh99P9cn%akpm@linux-foundation.org> <YYWb5jTLkNRUI6ea@casper.infradead.org>
In-Reply-To: <YYWb5jTLkNRUI6ea@casper.infradead.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 6 Nov 2021 13:49:49 -0700
X-Gmail-Original-Message-ID: <CAHk-=wi=D7f9H=3cxcZm16-iCRJY5EBaJ4kTjp+UjpD4dsNKPw@mail.gmail.com>
Message-ID: <CAHk-=wi=D7f9H=3cxcZm16-iCRJY5EBaJ4kTjp+UjpD4dsNKPw@mail.gmail.com>
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

On Fri, Nov 5, 2021 at 2:05 PM Matthew Wilcox <willy@infradead.org> wrote:
>
> hmm?  I think you based on some older version of Linus' tree that didn't
> have folios.

Andrew these days actually maintains a base commit model exactly so
that he doesn't end up rebasing during development.

So the whole series is based on plain 5.15, and I'll take care of the
conflict resolution.

This workflow can result in more conflicts for me than what Andrew
used to do ("send against current linus tip"), but it means that when
conflicts happen, they get all the merge resolution help that git
gives you, and hopefully what gets tested (over the months that it can
be in -mm) is closer to what gets sent to me.

              Linus
