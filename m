Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03A5F3C00
	for <mm-commits@vger.kernel.org>; Wed, 14 May 2025 01:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747185959; cv=none; b=kEWXH3ZsHZ7FN/KNPMw7s4QX8w7U7Rv/aEns0jxj7CvohgYr2rj9rngrhekSFG0GFvRslQf5Bp+86peJLwWtigr4u/XQjgXaEzf3aKvddECsIuyuLA01z9DTJrfdSUMWJfRjJQ6K0etTuUNSJ8Ynw2OHpyEz55q1IXTlXM5P22E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747185959; c=relaxed/simple;
	bh=+uGN9smP4q9oIU6cK/td1UytYGydqjEsXUmoEth/tzc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a8W5oGwkMqZXo6dCiR34Mt5I9FZyAoNSZd3GaDMhrczVkggr7XfqhTwwhzjZ0P6nTDgVH6S/fPma5soIJui0LCqrssIx78r+Ckc8nQHA9YH0dzZnUr6jhYJdiVbeT96XmJUByoTd6Dy/vWeSatUU4Xi8MHlCbcAV1YrC5iqxM/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=q5ae92Qp; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="q5ae92Qp"
Date: Tue, 13 May 2025 18:25:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1747185954;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HHGhI8qxnuYyTlMiGyBRLko8LXSLVjjUh32kHmMPRMk=;
	b=q5ae92QpXhjuF9ab6eykm63GS1/3jwG+tGH8jQXUauFOMCbPShNQeclOdyf42kLgfuscvq
	BluPV6EcVaN3cst7Gn5rlNERzS28tTuKCuTl3U2KPaPBFKHAVIsSjyEEZwh3UsBgEg4zkZ
	iOGITSFlDrx3z6biJUAzymkUHhH6+qw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, yang.yang29@zte.com.cn, 
	wang.yaxin@zte.com.cn, songmuchun@bytedance.com, roman.gushchin@linux.dev, 
	muchun.song@linux.dev, mhocko@suse.com, mhocko@kernel.org, hannes@cmpxchg.org, 
	david@redhat.com, chen.haonan2@zte.com.cn, xu.xin16@zte.com.cn
Subject: Re: [merged mm-stable] memcontrol-rename-mem_cgroup_scan_tasks.patch
 removed from -mm tree
Message-ID: <n4khqkpiq7q5u6n3o5zw6h55nb46cpcmh4epvwto65wt5xjqm5@ed4eirfexrz6>
References: <20250513065531.D8D79C4CEE4@smtp.kernel.org>
 <36ptbmurx4fwsb5hpbnilojogsdx3fj4f7soywzw6ea4ve4cld@52yyggqaisot>
 <20250513162906.051a2430ccaa121cb840732e@linux-foundation.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250513162906.051a2430ccaa121cb840732e@linux-foundation.org>
X-Migadu-Flow: FLOW_OUT

On Tue, May 13, 2025 at 04:29:06PM -0700, Andrew Morton wrote:
> On Tue, 13 May 2025 08:58:21 -0700 Shakeel Butt <shakeel.butt@linux.dev> wrote:
> 
> > Hi Andrew, can you please keep this series on hold for now? The
> > discussion has not concluded yet. Mainly I want to see system level
> > metrics which can get included in memcg and exposed through memory.stat
> > interface instead of a new one.
> 
> OK, I dropped these from mm-stable so they aren't in mm.git at all. 
> Should I re-add these patches to mm-unstable?

I don't have a strong opinion on that but I don't see any benefit of
bots testing this series which mm-unstable gets.
