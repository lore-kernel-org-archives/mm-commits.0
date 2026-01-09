Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2FF3194098
	for <mm-commits@vger.kernel.org>; Fri,  9 Jan 2026 19:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767985229; cv=none; b=SQfctFaeDWLHj6WpefA8Ia1lAPrnIHpZOl3OBBdvaY2CvgZO6ge+jJ2q3Z1myXPzxdsZQeYD2lgusWm2OTbrdBwDx8fZKNWuIUWMrPhqW3srzyx5AFSzIslCKssVJCTURC91tFtHcTkuVVnWAYFg8R/0BwXtOwuZyXjLcKjDsII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767985229; c=relaxed/simple;
	bh=Cg0tzjfK3+8D9InpNcJ2HgT7UDpbdW3BhKj+oAxTVog=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=Wst6SnVzoLAnBIRyrzLlzPzNwsPV4EBI1PvC3NGsQ14G1K9qTVStKzWFOOObzrOva7Xl2x/Rd8hdtrY3w86Cc8bcnW4PFHtKfjgKyIv1J1jJ0U76XHzZBnFFsSyAF8pCM2X9x6LnoPdtx5RDuDFFjN3omfTvQ1BDwrc0iKqhIaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=t08TDToD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="t08TDToD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A38B8C4CEF1;
	Fri,  9 Jan 2026 19:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767985229;
	bh=Cg0tzjfK3+8D9InpNcJ2HgT7UDpbdW3BhKj+oAxTVog=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=t08TDToDCDeBlEsmnisquy/DnMA9gjL3h7jQ6vHipQCCx+E0LN6eSPzAhdunmLKG5
	 +/RfXxkGP7SS9/rfC3lRiZQvb5FAxxP5zQhATTo5jwTBk11bYcYzbryQcl4Z+Wa/eD
	 y8EiwInTiXow0VatxdVfE1+dMudI/YpXZdX+QX7w=
Date: Fri, 9 Jan 2026 11:00:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>,
 mm-commits@vger.kernel.org, zhengqi.arch@bytedance.com, yuanchu@google.com,
 weixugc@google.com, tballasi@linux.microsoft.com, shakeel.butt@linux.dev,
 roman.gushchin@linux.dev, muchun.song@linux.dev, mhocko@kernel.org,
 mhiramat@kernel.org, mathieu.desnoyers@efficios.com, hannes@cmpxchg.org,
 david@fromorbit.com, axelrasmussen@google.com, rostedt@goodmis.org
Subject: Re: + tracing-add-__event_in_irq-helpers.patch added to mm-new
 branch
Message-Id: <20260109110028.8567b1a4a5cef096c25e173b@linux-foundation.org>
In-Reply-To: <573a3645-e98f-46de-bb94-ba20daadfaed@lucifer.local>
References: <20260106033842.559EBC116D0@smtp.kernel.org>
	<3a96b65e-49b1-45f5-a36a-77b38cea62e2@lucifer.local>
	<20260106124930.827da463ea281bb392a9843d@linux-foundation.org>
	<4cccaf21-c78e-4017-bb95-29a401d7c3a5@lucifer.local>
	<f916c970-33fe-4147-9daf-159ba61a0302@kernel.org>
	<8b54e314-be57-4fa0-bb53-e9a0adb7d969@lucifer.local>
	<c8b4e2db-def0-49bf-bf04-5dee7e73711d@kernel.org>
	<573a3645-e98f-46de-bb94-ba20daadfaed@lucifer.local>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 9 Jan 2026 14:17:19 +0000 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:

> On Fri, Jan 09, 2026 at 02:59:38PM +0100, David Hildenbrand (Red Hat) wrote:
> >
> > Nothing to add to the above :)
> >
> > > >
> > > > Hm.
> > > >
> > > > [1] we have 0day now running and reporting problems mostly private to me, I
> > > > just didn't have the time yet to closely look into the results I've been
> > > > getting because there seem to be some false positive test failures in some
> > > > unrelated tests.
> > >
> > > I've not seen bot reports from mm-new at all, so this is news to me.
> >
> > So far the reports only go to me while we are experimenting with how helpful
> > it is and how stable the results are.
> >
> > I skimmed over some results today, and apparently it found that the new
> > memory-failure selftests are a bit shaky (fail in some environments).
> 
> I guess this is why Andrew isn't bothered about me no longer checking the
> branch then, you're taking over that role somewhat :)

These are serious matters and they merit serious consideration.  This
takes time and I shall not be making half-baked statements.  Please be
patient.

I've seen some buildbot/fuzzbot reports for mm-new but they seem to
have stopped.  It would be good to get this all going again but I never
know who to poke.

> To be constructive, FWIW, here's what I propose:
> 
> 	I think we should rename mm-new to mm-early-testing, base stuff on
> 	mm-unstable, and have a clear indication as to how things flow
> 	through.

Yes, let's not base changes on mm-new.  If an mm-unstable patch needs
work to integrate into mm-new (unlikely) then I'll take care of that.

I'm working on documentation for this and much more.  Hopefully I'll be
progressing that significantly this weekend.

> 	We should then use the testing to determine stability, drop
> 	anything that's broken, and move stuff to mm-unstable after a
> 	certain _set_ time period where we'd expect bots to pick up any
> 	issue.

I like to move things up after 2-3 days - it's all about protecting
linux-next from too much damage.  I've perhaps been a bit slow with
that lately, holidays and all.

> 	Then stuff in mm-unstable goes to Linus if it has a sub-maintainer
> 	tag on it, if not it doesn't.

Sounds easy if you say it quickly ;) There are complications.

Much more to say when I'm ready.
