Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0572F800
	for <mm-commits@vger.kernel.org>; Mon,  4 Nov 2024 05:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730699189; cv=none; b=CWNQaezJ3PENjWHGILbiUhrutXaJvlCRFalJ97zsTXBZapqeME2s0zYZZjeDF56sCE+EZApCes7WVg78Gwetpl3JAAubNj8aL1dHjekEQL02Ro89/OonIi6YwU/QGmnwHYra8JgmiNVJdA5FLIhBbFqWe1mGpB6T3cRAqqUo39w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730699189; c=relaxed/simple;
	bh=3cmm/PJ3Ezoxs0RrSz4ShCIUIDCigf02qUTsW0ZQpGM=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=WPRGxW7najJ6fnMLIPWtEVU2JPJmdyN/zrcDQjd+UWFHbh+uDoqNfEedHzS+Duvr6dBSobT9WVaSUwgK2FknzqdJKT6en8J2fXCiWExGg3cF0s+Z89D70U7H3i++i5+gKJzdh6hVnJHylKiymc1B6kt3LJ/pKqIXFFXRNtgzRzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=p2OKIX/e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="p2OKIX/e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 051D7C4CECE;
	Mon,  4 Nov 2024 05:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730699186;
	bh=3cmm/PJ3Ezoxs0RrSz4ShCIUIDCigf02qUTsW0ZQpGM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=p2OKIX/ex8UmnQcMR27gpL0wGXMYaBc60gzVE3SwwMOHMdS4MpBQa20+LFMuDLaXd
	 VaE8Ldz09bcprEaAluyGyvgx9NDAKiiFJ5RW+m638eWW3wakBQZiDaPDoQHKyKq+CE
	 FvPlwAC8ESSzS78DsOENUywRzuoiS/XKr4xwnO9k=
Date: Sun, 3 Nov 2024 21:46:25 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kairui Song <ryncsn@gmail.com>
Cc: mm-commits@vger.kernel.org, zhouchengming@bytedance.com,
 zhengqi.arch@bytedance.com, willy@infradead.org, usamaarif642@gmail.com,
 shakeel.butt@linux.dev, roman.gushchin@linux.dev, muchun.song@linux.dev,
 mhocko@suse.com, longman@redhat.com, hannes@cmpxchg.org
Subject: Re: + mm-list_lru-split-the-lock-to-per-cgroup-scope-fix.patch
 added to mm-unstable branch
Message-Id: <20241103214625.79ff7512809d91551f2153ca@linux-foundation.org>
In-Reply-To: <CAMgjq7AMm0vw3QWo50XgRa7QOZn-GA+v6EnM6TcmsHcCQWqxxg@mail.gmail.com>
References: <20241104040639.A548BC4CECE@smtp.kernel.org>
	<CAMgjq7AMm0vw3QWo50XgRa7QOZn-GA+v6EnM6TcmsHcCQWqxxg@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 4 Nov 2024 12:37:57 +0800 Kairui Song <ryncsn@gmail.com> wrote:

> > Patches currently in -mm which might be from ryncsn@gmail.com are
> >
> > mm-list_lru-split-the-lock-to-per-cgroup-scope-fix.patch
> >
> 
> Thanks for taking care of this. I was just thinking about posting a V3.
> 
> Can you also help pick up this fix?
> https://lore.kernel.org/linux-mm/62a65418-2393-40ec-b462-151605a5efcf@stanley.mountain/
> 
> It also applies to "mm/list_lru: split the lock to per-cgroup scope".
> These are so far the only two problems founded for that series.

I'll drop the series.  Please resend everything.
