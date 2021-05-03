Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1CC4C433B4
	for <mm-commits@archiver.kernel.org>; Mon,  3 May 2021 18:44:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B338D61176
	for <mm-commits@archiver.kernel.org>; Mon,  3 May 2021 18:44:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbhECSpe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 May 2021 14:45:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:60578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229520AbhECSpc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 3 May 2021 14:45:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 57A2061177;
        Mon,  3 May 2021 18:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620067477;
        bh=KzwzYPqMQGWsl4irZBQchhPgVJXTuvNbjzYx2VBBHL4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HtsHTqLzOhCv6l9qLjsp4kHAY9/Ma7e7UrhDIf39l5valXtC85eJZlV5yWp/u1IVi
         piMmyRGh1wcYDFjz7EuvcOzWEff80cU4oWkAgwcWY8DoGziwshCe8DLPWwnJKmwb/G
         gTGY6jACRXvsQ+t/LasLfTQ3px9+TuklvJ0tR0iA=
Date:   Mon, 3 May 2021 11:44:36 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrey Konovalov <andreyknvl@google.com>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Marco Elver <elver@google.com>,
        Alexander Potapenko <glider@google.com>,
        Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org
Subject: Re: [patch 148/178] kasan: detect false-positives in tests
Message-Id: <20210503114436.d1bd44ca2b625fd19a7a1fbd@linux-foundation.org>
In-Reply-To: <CAHk-=wjLz7HtquTYwDkGegnOmeM=wXp-XC4sRM8d47K2YScJXw@mail.gmail.com>
References: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
        <20210430060049.FrKVS3ZER%akpm@linux-foundation.org>
        <CAHk-=whhOEXyFGV7CfwB44etgYsb1vAkLhRrWb-mxjeUcqWu=g@mail.gmail.com>
        <20210502110456.238c3e175d35e4a6ce8a6088@linux-foundation.org>
        <CAHk-=wjLz7HtquTYwDkGegnOmeM=wXp-XC4sRM8d47K2YScJXw@mail.gmail.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Sun, 2 May 2021 12:08:17 -0700 Linus Torvalds <torvalds@linux-foundation=
.org> wrote:

> > > Use the previous release as a base (ie in this case 5.12)
> >
> > Not a problem for the first batch of patches, but what base do I use for
> > the second and succeeding batches?
>=20
> Well, the first batch is usually the biggest and most core one, and in
> many ways the most important that it would have been a branch of its
> own, and be something that has actually been tested as-is in
> linux-next.
>=20
> Ad to succeeding batches.. Optimally if they don't have any
> dependencies on other trees or the first batch, they'd actually
> entirely independent of the first batch, and just a separate patch
> queue entirely, and tested as such in linux-next (and again on top of
> some previous base).

The mm/ patches tend to be significantly interdependent.  I try to
separate things into mm/whatever subparts, but things are often quite
smeary, both textually and conceptually.

I don't send the whole mm/ queue in a single hit because it tends to be
rather large.  I could do so.

> But that kind of workflow would require you literally have multiple
> separate patch-queues that you test independently. That does sound
> like a good idea, but it also sounds very much like a "git topic
> branch" model, and I think quilt basically is a "single series" tool,
> not able to handle multiple independent series?
>=20
> I don't know quilt, and a quick google of "multiple independent quilt
> patch series" ended up at a web page by Andreas Gr=FCnbacher that was so
> old that it was in Latin1 and doesn't even display properly on any
> modern browser.

I haven't found a need to do this.  I presently identify 353 subsystems
in the -mm patch queue.  Most have zero patches in them most of the
time.  But apart from mm/ being all tangled up internally, I basically
never see any overlap between these subsystems.  So I stack 'em all up
in the same series.

> I'd actually be perfectly ok with being told that subsequent patches
> be based on top of your previous patch series: I already create a
> branch called "akpm" for applying all your patches, and while right
> now it's a temporary branch that gets removed after I merge it, I
> could easily just keep it around - and then apply your next series on
> top of it.

OK, I'll do that this week and shall have a bit of a think.

> So the only issues would be the things that actually end up being
> dependent on other branches in linux-next:
>=20
> > Maybe 10% of the patches I carry are based on changes which are in
> > linux-next.
>=20
> These are the ones that you'd have to keep separate, in order to not
> rebase the patches that _aren't_ based on linux-next changes..
>=20
> Again, I don't know how to do that with quilt (and iirc, you aren't
> actually using quilt, you're using your own extended version?)

Yes, my patch-scripts is quilt's grandfather and I continue to use and
evolve it.

> The quilt man-page does have some signs that there can be multiple
> series of patches (wording like "current series" vs "another series",
> and "Different series files can be used.."), but the actual quilt
> commands don't really show much sign of switching between different
> patch series. So I get the feeling that it's more of a "theoretically
> possible" thing rather than something that is actually supported by
> the tooling natively.

Easy.  You'd have a bunch of different series files and then do

ln -s series-ocfs2 series
ln -s series-procfs series


etc to work on a particular series.  Then for assembling an entire tree,
have a master series-of-series file which contains the names of the
various sub-series files, to define the stacking order:

series-ocfs2
series-procfs
...

Then

	cat $(cat series-of-series) > series

and go for it.  But as said, I haven't seen the need because they're
almost always all orthogonal.

A fairly recent series file is at
https://ozlabs.org/~akpm/mmotm/series.  It defines the applying order,
the various subsystems, tags for which bits are to be included in
linux-next, lots of notes-to-self, etc.

