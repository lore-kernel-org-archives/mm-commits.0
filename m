Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11C19C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  8 Jul 2022 00:27:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236976AbiGHA1o (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 7 Jul 2022 20:27:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236799AbiGHA1n (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Jul 2022 20:27:43 -0400
Received: from mail-vs1-xe36.google.com (mail-vs1-xe36.google.com [IPv6:2607:f8b0:4864:20::e36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE8A370E48
        for <mm-commits@vger.kernel.org>; Thu,  7 Jul 2022 17:27:42 -0700 (PDT)
Received: by mail-vs1-xe36.google.com with SMTP id a184so10856278vsa.1
        for <mm-commits@vger.kernel.org>; Thu, 07 Jul 2022 17:27:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :mime-version;
        bh=yKpz2JsAWBGEzk+Pm46cBe2l7KrmGKzfGL5fm64WZD4=;
        b=Uc2nk5PwU3lf6783wF3OI8X6qBIe0qvbibj/jmsnQti1XCEbjUMK1Dzjs33z2TUXxl
         F0jDu7jpp8XWuBwrYpQYtMIJvxNaWILRTp86SkQaiL2PaUQS+z60IKlqmeUZFsK9z052
         sqUaVpIjl/VJxyh+UfpvVUsQD1NCVdo1AvLW8FFW8/iZDDrkfcpgXfevYBZbyW9bWT55
         Hka0dJGzdte39kPYHOZW+mkoEH0sgxjBAsKK1MaH9yNpaO0DqdOAlRqJTg4gGRbxuUWo
         xyRnFeZJo0hw/BFfMOGpJbAH4UL1TFQUxFJ4OOnRMGb+5k7T8FT6WUH7VVFN6Rby+w1H
         xjxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:mime-version;
        bh=yKpz2JsAWBGEzk+Pm46cBe2l7KrmGKzfGL5fm64WZD4=;
        b=nsoTanLh8HXQWpJs+UejP35ceCwqUQmZ4wzIeyjwnF6xb8UfJSnZSoDs5W6ZCWlDj3
         9henK+r0bu3emROAxtIPr3hqFmSXOvCVDAAgigSS2MLJ3iuN2OiEWwh4DpX1U3InW9ja
         FegyEC5o7WA33JBQyCWbp6ugRpx/+hOunK9gnQglDR2gCiHE38OOL8bGIzIMxK/b7tB7
         1igCBo41gCf5xONdko4PMcyJ9sB6Nbz9K29UBNF6Fcwxn4ANBtxuWk4Kb/V5gdQF4nge
         KqI5nEq6GbdvmoroVLnHT8vSiidKUcogzBaGiNGafLhfQ1vxjmNqtvTE0O57iJA4lL+u
         w/1A==
X-Gm-Message-State: AJIora+ijMuMjH7ic9lgYe7leYML7VHrE5JtDfLohNDjZ06d8AzC83xf
        vDGTFKhmLahI3qmgAvEbMGgFqem/tQlviQ==
X-Google-Smtp-Source: AGRyM1v+E0mjG+TZRkCWPv/ahA2JZZfjj0hrjS+iMY6FCMIEYTZZsQsbnoofJzIGNsbzdDKU+lrUAQ==
X-Received: by 2002:a05:6214:2126:b0:472:f1bd:db0a with SMTP id r6-20020a056214212600b00472f1bddb0amr438700qvc.25.1657239744287;
        Thu, 07 Jul 2022 17:22:24 -0700 (PDT)
Received: from ripple.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id u5-20020a37ab05000000b006b4748535a1sm9557521qke.16.2022.07.07.17.22.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 17:22:23 -0700 (PDT)
Date:   Thu, 7 Jul 2022 17:22:06 -0700 (PDT)
From:   Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@ripple.anvils
To:     Andrew Morton <akpm@linux-foundation.org>
cc:     Vlastimil Babka <vbabka@suse.cz>, Yu Zhao <yuzhao@google.com>,
        mm-commits@vger.kernel.org,
        Nicolas Saenz Julienne <nsaenzju@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Minchan Kim <minchan@kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        kernel test robot <lkp@intel.com>,
        Hugh Dickins <hughd@google.com>, dan.carpenter@oracle.com
Subject: Re: + mm-page_alloc-protect-pcp-lists-with-a-spinlock-fix.patch
 added to mm-unstable branch
In-Reply-To: <44ae6dd9-c290-ae4a-15e8-593a9cb587ad@suse.cz>
Message-ID: <2030965f-5f68-c5ea-80a0-34be503de47f@google.com>
References: <20220707200919.90C41C3411E@smtp.kernel.org> <fc7101bb-b9b9-4444-1d8b-4a28ce13f333@suse.cz> <CAOUHufZEwtvOhKQZqBp7Lg41eC9tK7hyL_UOUb2RdLKva8U02g@mail.gmail.com> <44ae6dd9-c290-ae4a-15e8-593a9cb587ad@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, 8 Jul 2022, Vlastimil Babka wrote:
> On 7/8/22 00:09, Yu Zhao wrote:
> > On Thu, Jul 7, 2022 at 3:58 PM Vlastimil Babka <vbabka@suse.cz> wrote:
> >>
> >> On 7/7/22 22:09, Andrew Morton wrote:
> >> > The patch titled
> >> >      Subject: mm-page_alloc-protect-pcp-lists-with-a-spinlock-fix
> >> > has been added to the -mm mm-unstable branch.  Its filename is
> >> >      mm-page_alloc-protect-pcp-lists-with-a-spinlock-fix.patch
> >> >
> >> > This patch will shortly appear at
> >> >      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-protect-pcp-lists-with-a-spinlock-fix.patch
> >> >
> >> > This patch will later appear in the mm-unstable branch at
> >> >     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> >> >
> >> > Before you just go and hit "reply", please:
> >> >    a) Consider who else should be cc'ed
> >> >    b) Prefer to cc a suitable mailing list as well
> >> >    c) Ideally: find the original patch on the mailing list and do a
> >> >       reply-to-all to that, adding suitable additional cc's
> >> >
> >> > *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> >> >
> >> > The -mm tree is included into linux-next via the mm-everything
> >> > branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> >> > and is updated there every 2-3 working days
> >> >
> >> > ------------------------------------------------------
> >> > From: Andrew Morton <akpm@linux-foundation.org>
> >> > Subject: mm-page_alloc-protect-pcp-lists-with-a-spinlock-fix
> >> > Date: Thu Jul  7 01:06:35 PM PDT 2022
> >> >
> >> > add missing local_unlock_irqrestore() on contention path
> >>
> >> Doh, that's true and something to fix, although patch 7 did remove the bug
> >> later in the same series so that wouldn't explain the lkp report for patch
> >> 7. The reason lkp test robot complained was AFAICS that it was testing v4,
> >> as I just replied there.
> > 
> > Sorry I didn't bother to reply until now: it did test v5, at this
> > commit, not the whole series.
> 
> I meant this report that appears to be for v4 (full series including patch 7):
> https://lore.kernel.org/all/YsFk%2FqU+QtWun04h@xsang-OptiPlex-9020/
> That reported a bug due to missing unpin that was previously reported for v4
> and fixed in v5.
> 
> I'm not aware of a lkp report for v5 (found only Dan's) but yeah, hitting
> the (similar but not identical) bug fixed by this -fix would indeed be
> possible in v5 if patch 7 was not applied.

This is all very confusing.

For whatever reason, Mel's 7/7 (and its -fix per Yu Zhao) was not
included in next-20220706 or next-20220707 (I never tried 0705, and
0704 had none of Mel's series, so no problem in this regard; and
in weeks before that, no time for testing here).

So when I tried testing on 0706, got plenty of rcu_preempt stalls or
sleeping function called from invalid context (irqs_disabled(): 1) or
other alternative warnings. And found that applying the missing 7/7
plus -fix (I've never tried 7/7 without -fix) got rid of all those,
allowing to move forward and look into other bugs.

But now we have a different fix going in, though I thought Andrew
said he wanted to move 7/7 to mm-stable tomorrow (despite its not
even reaching mm-unstable?).  Maybe the Oliver Sang lkp testing (on
out-of-date version) cast doubt on v5 7/7 and delayed it going in.

This relentless drive towards mm-stable: I for one cannot keep up.
I'd like to ask for slowing down a bit - my intention had been to
reach testing maple tree again (it's not yet what I'd call stable),
but this and a couple of other issues got in the way.  More mails
to write.

Hugh
