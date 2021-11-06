Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49578C433F5
	for <mm-commits@archiver.kernel.org>; Sat,  6 Nov 2021 21:20:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 344BA611AE
	for <mm-commits@archiver.kernel.org>; Sat,  6 Nov 2021 21:20:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235121AbhKFVWv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 6 Nov 2021 17:22:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:54240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233912AbhKFVWv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 6 Nov 2021 17:22:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3E99060240;
        Sat,  6 Nov 2021 21:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636233609;
        bh=nNadFUWRbcC3kNmm5hW/iEEJPZbJezLbRcMqTbl9l6A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TFFChLZx/tfVHwMvwfsfY5N3g7+hOE1nMSOtwzkiO8VFERdyCjxwvK+QcXUUHvz0/
         4sPJW0TRDW3Svbq8dY9EapGguaEvJ/WR1abYOgfPfF1Tgh+B+1SSX19nEiRhMP9sDW
         da2AOJ1pYcMEEHbBbYG/WTi/Q/PhT9g59vwhlh+g=
Date:   Sat, 6 Nov 2021 14:20:07 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
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
Subject: Re: [patch 149/262] mm/vmscan: throttle reclaim until some
 writeback completes if congested
Message-Id: <20211106142007.6996480f2ac52b96c273ecf5@linux-foundation.org>
In-Reply-To: <e08fa92e-31bc-c340-fd31-d4535d922aed@suse.cz>
References: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
        <20211105204225.iIh99P9cn%akpm@linux-foundation.org>
        <YYWb5jTLkNRUI6ea@casper.infradead.org>
        <CAHk-=wi=D7f9H=3cxcZm16-iCRJY5EBaJ4kTjp+UjpD4dsNKPw@mail.gmail.com>
        <CAHk-=wgDdPxNWvQ8n=LW5bQeuq2WvP=5pnCZe2aubodfNR1JBg@mail.gmail.com>
        <e08fa92e-31bc-c340-fd31-d4535d922aed@suse.cz>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Sat, 6 Nov 2021 22:13:34 +0100 Vlastimil Babka <vbabka@suse.cz> wrote:

> On 11/6/21 22:12, Linus Torvalds wrote:
> > On Sat, Nov 6, 2021 at 1:49 PM Linus Torvalds
> > <torvalds@linux-foundation.org> wrote:
> >>
> >> This workflow can result in more conflicts for me than what Andrew
> >> used to do ("send against current linus tip"), but it means that when
> >> conflicts happen, they get all the merge resolution help that git
> >> gives you, and hopefully what gets tested (over the months that it can
> >> be in -mm) is closer to what gets sent to me.
> > 
> > .. and resolving the conflicts (none of which looked bad), I think
> > that part of the resolution ends up doing very similar things to your
> > fixup patch.
> 
> If this needed resolution, didn't the resolution exist in -next already?

Yes, but I had it queued after linux-next.patch so it got lost in the
unholy mess that linux-next becomes during the merge window.

I'm still figuring this out.  In retrospect I should have moved this
patch "mm/vmscan: throttle reclaim until some writeback completes if
congested" to the post-linux-next section weeks ago, then waited for
the prerequisites to be merged into mainline.  That way the unaltered,
tested patch would have smoothly slotted in late in the merge window.
