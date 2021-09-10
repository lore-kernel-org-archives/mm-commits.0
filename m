Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 054C7C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 10 Sep 2021 17:51:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD35860F56
	for <mm-commits@archiver.kernel.org>; Fri, 10 Sep 2021 17:51:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbhIJRxF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 10 Sep 2021 13:53:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbhIJRxE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 10 Sep 2021 13:53:04 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC7CFC061574
        for <mm-commits@vger.kernel.org>; Fri, 10 Sep 2021 10:51:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=YDFCfvZcQfwIh9vQcvU8EUN8BZWQl7uWlfh1TeH0Jko=; b=eZt9MW6G2PVOgd5vHGA9l7c3um
        BwziZ2XpsNPDQCYkjXUe84TW1B/UVCRkn7L4s7fkThunkASTj5Qv4z9rpQft9RzoJYsF1+jeZWScx
        eKUHSBFGWtIzHen45ociPfQohRaQZgLU33pq39O4SQNZZpVH137bWFQYFSRGP/NBIE2tEc8jWss93
        oYVHJomnKX/4aU1GeztynjHpsoK+qc6pBSCLFdbt40UdlB33dWGu6upTVarM9PyRqVfeHVPUWONMc
        WiAdy9aZjzAMd9AcR34QWcxGwcF4auS/zwxRiGyUC+mzIPs+VbVfRszbz2EMk3Xvx+alATymQFawX
        vJ/L1YSA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mOkgi-00DIKF-VJ; Fri, 10 Sep 2021 17:51:44 +0000
Date:   Fri, 10 Sep 2021 10:51:44 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Jessica Yu <jeyu@kernel.org>, Borislav Petkov <bp@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, bgoncalv@redhat.com,
        egorenar@linux.ibm.com, hkallweit1@gmail.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [patch 128/147] init: move usermodehelper_enable() to
 populate_rootfs()
Message-ID: <YTubMDg3jv7wt7Uq@bombadil.infradead.org>
References: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
 <20210908030003.WFvhfWzKJ%akpm@linux-foundation.org>
 <YTjadLYEhTRbwvRe@bombadil.infradead.org>
 <04d237ff-9a52-a6ce-d184-ea5874c104dc@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <04d237ff-9a52-a6ce-d184-ea5874c104dc@rasmusvillemoes.dk>
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, Sep 10, 2021 at 10:12:01AM +0200, Rasmus Villemoes wrote:
> On 08/09/2021 17.44, Luis Chamberlain wrote:
> > On Tue, Sep 07, 2021 at 08:00:03PM -0700, Andrew Morton wrote:
> >> From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> >> Any call of wait_for_initramfs() done before the unpacking has been
> >> scheduled (i.e. before rootfs_initcall time) must just return
> >> immediately [and let the caller find an empty file system] in order
> >> not to deadlock the machine. I mistakenly thought, and my limited
> >> testing confirmed, that there were no such calls, so I added a
> >> pr_warn_once() in wait_for_initramfs(). It turns out that one can
> >> indeed hit request_module() as well as kobject_uevent_env() during
> >> those early init calls, leading to a user-visible warning in the
> >> kernel log emitted consistently for certain configurations.
> > 
> > Further proof that the semantics for init is still loose. Formalizing
> > dependencies on init is something we should strive to. Eventualy with a
> > DAG.  The linker-tables work I had done years ago strived to get us
> > there which allows us to get a simple explicit DAG through the linker.
> > Unfortunately that patch set fell through because folks were
> > more interested in questioning the alternative side benefits of
> > linker-tables, but the use-case for helping with init is still valid.
> > 
> > If we *do* want to resurrect this folks should let me know.
> 
> Heh, a while back I actually had some completely unrelated thing where
> I'd want to make use of the linker tables infrastructure - I remembered
> reading about it on LWN, and was quite surprised when I learnt that that
> work had never made it in. I don't quite remember the use case (I think
> it was for some test module infrastructure). But if you do have time to
> resurrect those patches, I'd certainly be interested.

OK I might.

> > Since the kobject_uevent_env() interest here is for /sbin/hotplug and
> > that crap is deprecated, in practice the relevant calls we'd care about
> > are the request_module() calls.
> 
> Yes - the first report I got about that pr_warn_once was indeed fixed by
> the reporter simply disabling CONFIG_UEVENT_HELPER
> (https://lore.kernel.org/lkml/9849be80-cfe5-b33e-8224-590a4c451415@gmail.com/).

Ah I see.

> >> We could just remove the pr_warn_once(), but I think it's better to
> >> postpone enabling the usermodehelper framework until there is at least
> >> some chance of finding the executable. That is also a little more
> >> efficient in that a lot of work done in umh.c will be elided.
> > 
> > I *don't* think we were aware that such request_module() calls were
> > happening before the fs was even ready and failing silently with
> > -ENOENT. 
> 
> Probably not, no, otherwise somebody would have noticed.

OK your commit log was not clear on this, it seemed to suggest this
as a possibility or that such a case existed. That also means the
impact of your change is less.

> >> However,
> >> it does change the error seen by those early callers from -ENOENT to
> >> -EBUSY, so there is a risk of a regression if any caller care about
> >> the exact error value.
> > 
> > I'd see this as a welcomed evolution as it tells us more: we're saying
> > "it's coming, try again" or whatever.
> 
> Indeed, and I don't think it's the end of the world if somebody notices
> some change due to that, because we'd learn more about where those early
> request_module() calls come from.

But since it would seem none have been reported yet, it is an even
better situation.

> > A debug option to allow us to get a full warning trace in the -EBUSY
> > case on early init would be nice to have.
> 
> As noted above, that's difficult. We'd need a way to know which other
> task is waiting for us, then print the trace of that guy.
> 
> I don't think anybody is gonna hear this tree falling, so let's not try
> to solve a problem before we know there is one.

That's fair. But let's also recall neither of us expected the above
situation either. But I agree the possible collateral at this point
seems to be small, if any.

 Luis
