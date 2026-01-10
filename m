Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B803C43ABC
	for <mm-commits@vger.kernel.org>; Sat, 10 Jan 2026 00:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768005155; cv=none; b=ga6jAAsDqb+PNhoxqHgbfW3t31RDYu9RtV0CFiHntZuXSJIEpaukOsIuV60CC7/pegHyb3/z1uPQ42BpYibd+hb2fkSd0UUh/lIsnRYAJI8UI5XG5vaZLNY7ZZIt2UBqb9D6TFHl1kouOxiuEzScktOTjzcXmfJueqAJNTiL+vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768005155; c=relaxed/simple;
	bh=gBB1sVNLogLKO+uQ2J7HaXts1De8Gn3Mpe4KrFZtUXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lGproCF/jeC4DTvfhWPugA/SY4lkFiZ14JPHJh0OWY9+ft0MyMRHcodrqi1XbznS6RvE+a5sltDvEYUATc8fDm90kPDr47eVfn0RfBMogP2b2smVB2XWMfvrgmSoE2HhdBx98UNW9FwdCavsFOUkmSKli8cwody+mQtmnR9RHBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TCfkvb0X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TCfkvb0X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E465DC4CEF1;
	Sat, 10 Jan 2026 00:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768005155;
	bh=gBB1sVNLogLKO+uQ2J7HaXts1De8Gn3Mpe4KrFZtUXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TCfkvb0XEH4Gu2auilwIDqr1e4vYlSbvKOPlN7pJIYM2zoaeXQk0z1afgAQKn10f4
	 bTffnk5TuDPTXvo7A6lW4zlxcwcRIUTrfg0MtzgqA/ekwji/yZ8iHilfrIN/OuNgmF
	 Ity1tDplRXnGgxB7rnzc3B8ybcdRNtPxzl7Va2uz9DPp4Pgt2kSdw77hI80VeI6JR/
	 /ZbNV4soicHkiRtsMW2PTFziRcGXaNddJeQpyigFhi18ZXLBx7mpSrASc7fpcH/0uI
	 FrlHZUbkMtAza8ElmBfdPNsUVrspooQ35WONqrNKjJVwzowLRJS1F40QcuQNegRbM+
	 SZm28NKQ+kGIQ==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	mm-commits@vger.kernel.org,
	zhengqi.arch@bytedance.com,
	yuanchu@google.com,
	weixugc@google.com,
	tballasi@linux.microsoft.com,
	shakeel.butt@linux.dev,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	mhocko@kernel.org,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	hannes@cmpxchg.org,
	david@fromorbit.com,
	axelrasmussen@google.com,
	rostedt@goodmis.org
Subject: Re: + tracing-add-__event_in_irq-helpers.patch added to mm-new branch
Date: Fri,  9 Jan 2026 16:32:32 -0800
Message-ID: <20260110003232.79586-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260109110028.8567b1a4a5cef096c25e173b@linux-foundation.org>
References: 
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 9 Jan 2026 11:00:28 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 9 Jan 2026 14:17:19 +0000 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:
> 
> > On Fri, Jan 09, 2026 at 02:59:38PM +0100, David Hildenbrand (Red Hat) wrote:
> > >
> > > Nothing to add to the above :)
> > >
> > > > >
> > > > > Hm.
> > > > >
> > > > > [1] we have 0day now running and reporting problems mostly private to me, I
> > > > > just didn't have the time yet to closely look into the results I've been
> > > > > getting because there seem to be some false positive test failures in some
> > > > > unrelated tests.
> > > >
> > > > I've not seen bot reports from mm-new at all, so this is news to me.
> > >
> > > So far the reports only go to me while we are experimenting with how helpful
> > > it is and how stable the results are.
> > >
> > > I skimmed over some results today, and apparently it found that the new
> > > memory-failure selftests are a bit shaky (fail in some environments).
> > 
> > I guess this is why Andrew isn't bothered about me no longer checking the
> > branch then, you're taking over that role somewhat :)
> 
> These are serious matters and they merit serious consideration.  This
> takes time and I shall not be making half-baked statements.  Please be
> patient.
> 
> I've seen some buildbot/fuzzbot reports for mm-new but they seem to
> have stopped.  It would be good to get this all going again but I never
> know who to poke.

Seems at least some build tests for mm-new are still actively ongoing.  We got
wo reports today (2026-01-09 UTC):
https://lore.kernel.org/oe-kbuild-all/?q=mm-new

> 
> > To be constructive, FWIW, here's what I propose:
> > 
> > 	I think we should rename mm-new to mm-early-testing, base stuff on
> > 	mm-unstable, and have a clear indication as to how things flow
> > 	through.
> 
> Yes, let's not base changes on mm-new.  If an mm-unstable patch needs
> work to integrate into mm-new (unlikely) then I'll take care of that.
> 
> I'm working on documentation for this and much more.  Hopefully I'll be
> progressing that significantly this weekend.

I was actually thinking it would be nice to have a document that describing the
current process, becasue the nwe can make an alignment on the current status,
and further discuss possible improvements.  I was actually about to share the
idea today, and start writing an RFC patch that adds the documentation based on
my best understanding, as MM's maintainer profile [1].  It's good to hear you
are doing the documentation.  I'm not sure your documentation will be somewhat
I was planning to make, but I sure that will be helpful.  So I will wait for
your documentation.

[1] https://docs.kernel.org/maintainer/maintainer-entry-profile.html


Thanks,
SJ

[...]
