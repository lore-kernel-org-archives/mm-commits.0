Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D4C2C43334
	for <mm-commits@archiver.kernel.org>; Fri,  8 Jul 2022 00:40:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231200AbiGHAkn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 7 Jul 2022 20:40:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiGHAkm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Jul 2022 20:40:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A59B92B600
        for <mm-commits@vger.kernel.org>; Thu,  7 Jul 2022 17:40:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D78862606
        for <mm-commits@vger.kernel.org>; Fri,  8 Jul 2022 00:40:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2443BC3411E;
        Fri,  8 Jul 2022 00:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1657240840;
        bh=cEqBKEudZM9nnPARcJJ/CA3z0bbisQGTNExUHyCjiyg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YaO7BNfnI8PdDjIT0hK7Tcc2fNvlT1GPoLxanDrd8Zcm9NZSiutVXV7HE483eMMey
         on0+50TPtoA4SyDOrZz+LCGk2Sjct0/YEnmsmNRJ0BxdcxJmThkMinviroXfTm/x+7
         XEBn1ritJRMJdiQ4OFx6uv2kkiY+7Q0OmRW8xd5k=
Date:   Thu, 7 Jul 2022 17:40:39 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Hugh Dickins <hughd@google.com>
Cc:     Vlastimil Babka <vbabka@suse.cz>, Yu Zhao <yuzhao@google.com>,
        mm-commits@vger.kernel.org,
        Nicolas Saenz Julienne <nsaenzju@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Minchan Kim <minchan@kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        kernel test robot <lkp@intel.com>, dan.carpenter@oracle.com
Subject: Re: + mm-page_alloc-protect-pcp-lists-with-a-spinlock-fix.patch
 added to mm-unstable branch
Message-Id: <20220707174039.092a09f76ce0cea84feeb3f2@linux-foundation.org>
In-Reply-To: <2030965f-5f68-c5ea-80a0-34be503de47f@google.com>
References: <20220707200919.90C41C3411E@smtp.kernel.org>
        <fc7101bb-b9b9-4444-1d8b-4a28ce13f333@suse.cz>
        <CAOUHufZEwtvOhKQZqBp7Lg41eC9tK7hyL_UOUb2RdLKva8U02g@mail.gmail.com>
        <44ae6dd9-c290-ae4a-15e8-593a9cb587ad@suse.cz>
        <2030965f-5f68-c5ea-80a0-34be503de47f@google.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, 7 Jul 2022 17:22:06 -0700 (PDT) Hugh Dickins <hughd@google.com> wrote:

> > I'm not aware of a lkp report for v5 (found only Dan's) but yeah, hitting
> > the (similar but not identical) bug fixed by this -fix would indeed be
> > possible in v5 if patch 7 was not applied.
> 
> This is all very confusing.
> 
> For whatever reason, Mel's 7/7 (and its -fix per Yu Zhao) was not
> included in next-20220706 or next-20220707 (I never tried 0705, and
> 0704 had none of Mel's series, so no problem in this regard; and
> in weeks before that, no time for testing here).
> 
> So when I tried testing on 0706, got plenty of rcu_preempt stalls or
> sleeping function called from invalid context (irqs_disabled(): 1) or
> other alternative warnings. And found that applying the missing 7/7
> plus -fix (I've never tried 7/7 without -fix) got rid of all those,
> allowing to move forward and look into other bugs.
> 
> But now we have a different fix going in, though I thought Andrew
> said he wanted to move 7/7 to mm-stable tomorrow (despite its not
> even reaching mm-unstable?).  Maybe the Oliver Sang lkp testing (on
> out-of-date version) cast doubt on v5 7/7 and delayed it going in.

Yes, 7/7 ("mm/page_alloc: replace local_lock with normal spinlock") has
had a number of issues (most recently
"BUG:sleeping_function_called_from_invalid_context_at_mm/gup.c") so 7/7
has been shelved for now.  Unfortunately 7/7 accidentally fixed a bug
which was added by 2/7.

> This relentless drive towards mm-stable: I for one cannot keep up.
> I'd like to ask for slowing down a bit - my intention had been to
> reach testing maple tree again (it's not yet what I'd call stable),
> but this and a couple of other issues got in the way.  More mails
> to write.

I'm not happy with it.

We're in -rc4 and still only a small amount of the queue look stable
enough to be moved into mm-stable.  Major patch series still have
question marks and red flags on them.  Things are being left to dangle
for days or weeks.

I addressed this at lsf/mm - asked that we drive things to completion
more promptly before moving onto other things.

I can (and do) hold things over if they don't seem sufficiently
stabilized.  This results in fairly major patch reordering/redoing but
at least that happens during mid-rc rather than at -rc7.

If I have to route around mapletree this time then that's going to be
fairly nasty - quite a lot of succeeding material depends on it.  We do
think mapletree is just about there, so please do concentrate your
testing and reviewing on that if poss.

Slow down?  Maybe we'll have to.  That would involve blocking
significant new work somewhat earlier, around -rc5 perhaps.  But at
-rc4 we're still in firehose mode.
