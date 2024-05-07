Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F0B1E570
	for <mm-commits@vger.kernel.org>; Tue,  7 May 2024 17:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715103205; cv=none; b=qKlQDXnIUbYkeGG08hUQkjnq890lMbox3pr6CgLVY8p1s0FYEiflAxEWQ1C0n/+Zu70mpUWSokw2QoV/c4KoX9El9PRBYdolqBRTqvT3D/fXPIcPU4bcCz36/LZJNo3Cqyez2lo9miSoPOpkyOLzp+7swEzbtVf8OWmaSIqPoWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715103205; c=relaxed/simple;
	bh=dN+dR+1lQE5AyJHGy3sdZNOmEX5mdGWsxjXCv/tOYPc=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=ArNfB733hFg82id61I/Hf9E95md09gCnyTzrUTzR5o+lEJMDuhg5uShrNbkAfqjOa/lfzVSBHrVNkrLI+6dVOunVJIRQh+LPlPLc31yU3NXBgrGzd+lZ1ngjqPil390+GTkTSZgQqAAhnVYhPMhCGCTqENEmw0iPotnzRqymmtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Heu0IASm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Heu0IASm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AEEFC2BBFC;
	Tue,  7 May 2024 17:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1715103204;
	bh=dN+dR+1lQE5AyJHGy3sdZNOmEX5mdGWsxjXCv/tOYPc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Heu0IASmZyt1UDReCrX0oA/7OFhdhzPw7Cq/GWUCe4rFhX5a30o8PGQtFiVhRbQU8
	 z3EbCn44Dhosgw4NRelpaWmFdB5f2hk8fa+7pCQc7qmx4METUQF+IuFaPXK9C8EP9V
	 F+/73u/PddJcVnuAtqdHma8TG9Zk4aThuYi3bRu0=
Date: Tue, 7 May 2024 10:33:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Hildenbrand <david@redhat.com>
Cc: mm-commits@vger.kernel.org, zokeefe@google.com, xiehuan09@gmail.com,
 wangkefeng.wang@huawei.com, songmuchun@bytedance.com, shy828301@gmail.com,
 ryan.roberts@arm.com, peterx@redhat.com, minchan@kernel.org,
 mhocko@suse.com, fengwei.yin@intel.com, 21cnbao@gmail.com,
 ioworker0@gmail.com
Subject: Re: [merged mm-stable]
 mm-madvise-optimize-lazyfreeing-with-mthp-in-madvise_free.patch removed
 from -mm tree
Message-Id: <20240507103323.9bfe1c3e2a83f66533db8179@linux-foundation.org>
In-Reply-To: <a0397765-ffac-4422-b82d-2f3460d6f9f8@redhat.com>
References: <20240506005757.7819CC113CC@smtp.kernel.org>
	<4e4a03e7-9c2e-4e23-8e76-3b2feae4ccb4@redhat.com>
	<20240507085526.5f4ea12e85e637dbc8e2e9df@linux-foundation.org>
	<a0397765-ffac-4422-b82d-2f3460d6f9f8@redhat.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 7 May 2024 18:54:09 +0200 David Hildenbrand <david@redhat.com> wrote:

> > 
> >> Review is still going on, can we still remove that from mm-stable?
> > 
> > I can rebase if needed.  Is there a reason to do so?  Nothing that
> > can't be fixed up with followup patches?
> 
> This here is good to go and saw sufficient review. [1] was too fast for 
> my taste, but it's up to you to decide if we want to fix that up piece 
> by piece as more review happens.
> 

OK.

Both series are cleanly droppable.  Maybe drop the later series
"Reclaim lazyfree THP without splitting" - let's see what the required
fixups look like?
