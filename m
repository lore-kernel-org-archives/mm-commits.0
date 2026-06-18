Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C2E1279907;
	Thu, 18 Jun 2026 20:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781816335; cv=none; b=LBHYz2sTZSg+/1KEurO50GKyabCEpUsb19HGAkJtA6Y63aETUXnagx0ksQ/S/J8uYeGf9eZ/GYyozGxeTT1m3NFEB/Ouj9MRmpCcwcjAgUSYEel6dM8Er5nDraKUfiW7sBvn+GAW01t63yGhBEgkuy+OxGjHV8ltLHMSF8X8+8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781816335; c=relaxed/simple;
	bh=bkHH2IU7IJHOwyveyIkd27A5uPPFE9CTDC19CQGFo9U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hz3ds2lmxi0y0lYOEkPc3ePKbZsrSe99q0TmwpqkcLugJC2lSoMJ8i4GsFQHqO/0BEDv4upUWC/kq9lvHGUA4vhSFAd1U8wAd2vqUYXhUwDZQraA9rYK52Tu4Dvr9zinpuhYMHgdPnkthAZW1aRqWR264NgwwsVb3mY9ED9owb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=14nCRR0b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="14nCRR0b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ABCF1F000E9;
	Thu, 18 Jun 2026 20:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781816333;
	bh=zljnJf5HQ/OchNgTmG7P8Dn2J1XlofQvwnuh99sRKhw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=14nCRR0b5Pj1LekQo1SNTGbmG92AW/Q7K7Qx8i1tT4iBid+jV1StR1z7LwYvuQ/yL
	 jJzgKYa/fxPEdC/TYjiN1t9ZN10RTqs5WV0RMuvKXYAJdvs3Ip2thSRhx3ELwqoqUe
	 u2S3Pw7myyvQNlACXAr3DajINMW8m+u7cX7fom+Y=
Date: Thu, 18 Jun 2026 16:58:52 -0400
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: pr-tracker-bot@kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>
Subject: Re: [GIT PULL] MM updates for 7.2-rc1
Message-ID: <20260618-first-aspiring-wapiti-71c024@meerkat>
References: <20260617153144.acead3f2795da15f1e56005c@linux-foundation.org>
 <178179616355.2947725.4377157124023044624.pr-tracker-bot@kernel.org>
 <CAHk-=whn39dQtoMeJrz++nAnZpgnrooU0dgzOZXdn1LyxQ+f2w@mail.gmail.com>
 <20260618-generous-sceptical-jackdaw-3d32db@meerkat>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260618-generous-sceptical-jackdaw-3d32db@meerkat>

On Thu, Jun 18, 2026 at 04:37:52PM -0400, Konstantin Ryabitsev wrote:
> On Thu, Jun 18, 2026 at 09:02:06AM -0700, Linus Torvalds wrote:
> > This is very wrong. That merge (2f9f5887b427) is merging Jens'
> > io_uring epoll cleanup. Not Andrew's MM tree, which I haven't gotten
> > to yet.
> > 
> > I wonder why pr-tracker-bot got this wrong.
> > 
> > [ Goes off and looks ]
> > 
> > Oh. Andrew's pull request is confused. It says
> > 
> >    The following changes since commit e771677...
> >      ...
> >    for you to fetch changes up to e771677....
> > 
> > and note how the "since" commit and "up to" commits are the same (and
> > is my iommufd merge). So then pr-tracker bot thinks it's merged when
> > the "since" commit was merged.
> 
> Let me at least handle this situation -- it's clearly an oversight.

The bot should now properly recognize when the start and end of the range are
the same sha and ignore the message (it seemed a safer logic than trying to do
anything else).

> > That doesn't explain why pr-tracker-bot thinks it got merged in what
> > was me merging Jens' tree, but whatever.

It's "bad assumptions snowballing." The merge commit in the notification isn't
taken from the pull request at all -- it's computed. Once the bot believes a
commit is merged, it runs:

    git rev-list <commit>.. --ancestry-path

and then takes the oldest commit in that range. With <commit> being e771677,
that is simply the next merge you made after the iommufd pull:

    $ git rev-list e771677c937d.. --ancestry-path | tail -1
    2f9f5887b42711595e768b9dc0582dccfdf60c3b

...which is your merge of Jens' io_uring epoll tree. So the bot wasn't
associating Andrew's MM tree with Jens' work; it just tried to do its best
with bad data, with predictably bad outcomes. :)

-K
