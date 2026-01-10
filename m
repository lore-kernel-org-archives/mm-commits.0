Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF9B81DF248
	for <mm-commits@vger.kernel.org>; Sat, 10 Jan 2026 01:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768007723; cv=none; b=LeGEiDrj6PBR8jGKABALDUvFRC4ayCwEcrwAA9XYZthYw+dWWRtwCwXmwCx6sHxp90tV2VJ8BjjCvNdZaHhDcL9glDttituHIR5NI8xrSXoi8fqROa6/qFFLWFg0ckmBYZjtbRTaCuURMtBRS5mGNXdsZZ0YTHvskRZC+/Op15g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768007723; c=relaxed/simple;
	bh=SklmeYXuenArnfaii1QDjjTofb4ih62PJb4aG4U3B+A=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=Lg5Gjbxc53TQUcKwxNb1Rw52z+kjsh16pE4Atin5NNyLJXQy3qthw9lVVzdZOlMiqwGQqVuoayRZPtAbZDYgmJftPFzbZYc2Yy0Tk55PFiVhJYU9EOzvYEr0MMgEJpVMqVkfd3hxmcFv5qga7lHexQr/kv306O+iY3iCbE6koB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gGURov+y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gGURov+y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 077FBC19421;
	Sat, 10 Jan 2026 01:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768007722;
	bh=SklmeYXuenArnfaii1QDjjTofb4ih62PJb4aG4U3B+A=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=gGURov+yokd12AZGrNVUKV3NqcWClhaXaNSUl/KUikbwSXMi2XorwOIMkEXIbMT2y
	 p4bHgFkhfVCdliXtLUlHOjkFXX8nQ/ChgqrXh3hV+9voyZ+b07OE+fZkCwCvvGyVZW
	 LAN06mWcyUOKmd3clYg+y80ApBdLsVSLU2WaZO68=
Date: Fri, 9 Jan 2026 17:15:21 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: SeongJae Park <sj@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "David Hildenbrand (Red Hat)" <david@kernel.org>,
 mm-commits@vger.kernel.org, zhengqi.arch@bytedance.com, yuanchu@google.com,
 weixugc@google.com, tballasi@linux.microsoft.com, shakeel.butt@linux.dev,
 roman.gushchin@linux.dev, muchun.song@linux.dev, mhocko@kernel.org,
 mhiramat@kernel.org, mathieu.desnoyers@efficios.com, hannes@cmpxchg.org,
 david@fromorbit.com, axelrasmussen@google.com, rostedt@goodmis.org
Subject: Re: + tracing-add-__event_in_irq-helpers.patch added to mm-new
 branch
Message-Id: <20260109171521.d088eac0f8e3beb703051089@linux-foundation.org>
In-Reply-To: <20260110003232.79586-1-sj@kernel.org>
References: <20260109110028.8567b1a4a5cef096c25e173b@linux-foundation.org>
	<20260110003232.79586-1-sj@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri,  9 Jan 2026 16:32:32 -0800 SeongJae Park <sj@kernel.org> wrote:

> > I'm working on documentation for this and much more.  Hopefully I'll be
> > progressing that significantly this weekend.
> 
> I was actually thinking it would be nice to have a document that describing the
> current process, becasue the nwe can make an alignment on the current status,
> and further discuss possible improvements.  I was actually about to share the
> idea today, and start writing an RFC patch that adds the documentation based on
> my best understanding, as MM's maintainer profile [1].  It's good to hear you
> are doing the documentation.  I'm not sure your documentation will be somewhat
> I was planning to make, but I sure that will be helpful.  So I will wait for
> your documentation.

Thanks.  What I plan to do is, roughly,

- A whole bunch of changes to the mm.git series file
  (https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/pc/devel-series),
  which is the repository of all status

- Add some words to all those added-to-mm emails directing people to
  this file so they can look at the current status of all the patches

- Add a glossary of terms to the series file.  Decoding akpm notes-to-self.

- Explain what all the branches do, how material moves between them

- High level description of how mm-unstable works.  It's a
  development tree, not a patch repository!

- Explain my decision-making process, if such is possible

- Anything else I think of.

The series file is a strange place to do some of this - we can of
course move content somewhere else sometime.
