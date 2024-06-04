Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30B16146D62
	for <mm-commits@vger.kernel.org>; Tue,  4 Jun 2024 13:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717507914; cv=none; b=YMXvLt33vL7XNJ0gH5AfzpcYDwsi6AzJ4sjjY6elxMJfkbzfux9W2TJHhKWU9Q4XqWPnfjKdVX6gubUozf4d5A3XExUqVwMHXOWTzGrTMpN2tCQndI78duJo2UTELmpLtMkoS9YR5KiEurVuuTwF9+YlvDdWWI4cMpEVMdcxSY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717507914; c=relaxed/simple;
	bh=H6W9sdqlCHqNwvVAglP0H4HmeCEL5BsC0IH+wghKAQU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=soV/YMZ4ojwW01jUxHsp3AoGUjMYUyOc0+jXxL2RNlzZHmF2mLvI0gK1k7zEVUbbSL6iHgKdGz1E+ujAMgXbjb2vfdBCKc2FJunMNZCUDqQfG6BxTWp/33YM2HZB/BaTHflf04kVvoqHWZl3fhCM4D6xymGIvftotROy+P3tGh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kWpxDqgy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kWpxDqgy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60B6DC4AF0A;
	Tue,  4 Jun 2024 13:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717507913;
	bh=H6W9sdqlCHqNwvVAglP0H4HmeCEL5BsC0IH+wghKAQU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kWpxDqgyR6KvPPr7wR81eHXpz7sSuFz8h8JSS1/Mpcwd3/IlHzra/IwxPlBsj7SG+
	 eR9sRO6c3b18/7fCBmysee4KmoqXS79aHY9BWgK6UcpRnczFifHmhCxT8Pfwc5rTGE
	 ofvNLEwn13ea1sH/aNgO3GcbMQYjxB9TBtyt9r5bomK55xlmJByJ4QwUUax1Rff4+e
	 RUx4mxy0GxmTA3cSzCkUVZXIpwfNjQy9xtX2gMjDZGTMm/e63QJ0nB4jvven9Id9/b
	 ef1H/YCV6gRc+VLsh6vuW+yufF7/Pzz7PoB5HISb9ol48rv6ld81SSUKWDoaABMQ+D
	 sXdixY5mymDVQ==
Date: Tue, 4 Jun 2024 14:31:46 +0100
From: Will Deacon <will@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, zokeefe@google.com, xiehuan09@gmail.com,
	wangkefeng.wang@huawei.com, songmuchun@bytedance.com,
	shy828301@gmail.com, ryan.roberts@arm.com, peterx@redhat.com,
	minchan@kernel.org, mhocko@suse.com, ioworker0@gmail.com,
	fengwei.yin@intel.com, david@redhat.com, chrisl@kernel.org,
	catalin.marinas@arm.com, baolin.wang@linux.alibaba.com,
	21cnbao@gmail.com, v-songbaohua@oppo.com
Subject: Re: +
 mm-arm64-fix-the-out-of-bounds-issue-in-contpte_clear_young_dirty_ptes.patch
 added to mm-hotfixes-unstable branch
Message-ID: <20240604133146.GA20384@willie-the-truck>
References: <20240524191054.60D9CC2BBFC@smtp.kernel.org>
 <20240603131346.GC18991@willie-the-truck>
 <20240603141924.32e4118a478f0d75b18e9cb0@linux-foundation.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240603141924.32e4118a478f0d75b18e9cb0@linux-foundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Mon, Jun 03, 2024 at 02:19:24PM -0700, Andrew Morton wrote:
> On Mon, 3 Jun 2024 14:13:46 +0100 Will Deacon <will@kernel.org> wrote:
> 
> > 
> > I was hoping that this would land in -rc2 to keep the testing bots at
> > bay, but it looks like it's still not graduated out of -next.
> > 
> > Did it simply fall by the wayside this time around, or are you waiting
> > for us to do something on the arm64 side? I can pick it up for -rc3 if
> > it makes life easier for you. Please let me know.
> 
> I usually give hotfixes a week in -next before sending them upstream. 
> I'll include this in this week's batch Tues or Weds?

Rightio, cheers Andrew.

Will
