Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33F4A18F2F5
	for <mm-commits@vger.kernel.org>; Wed, 26 Jun 2024 17:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719421899; cv=none; b=F80StCaKStQ+Ns5P0OHs/8ClkJcr/74H4Iy7EXEdIbePXWDkQBKWOIqzvvXXfHBZ/9Bsfb52b5uBGR9bsz1RP6IUm9hqvcNdVxTUN6PmwHvpkIlupy87vC2Lm3dIpKYQGaS3C4MAMYzw3w//gD12Cvqy4jfRepcgmBxoTQP8114=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719421899; c=relaxed/simple;
	bh=PDYInYiXapW5mgeDZlEs9BWPGax4j0lEMgJOT0CUAPY=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=Q7QqXdSQUCfpyG0Z/r54BxSA3fVNtNXsF43+ZZDTniSot/+IFw9dCKoBgdEAk/enrU0sipXYk/pK6ySvZdMjkIPk2noxiQ81TLdzcdbeCAGK1jk/cTknGGCXhABvFRwXn2ibq8Zv0HKGNTs/M2jxVhayrHYX+wBluJUWZZVndfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NLQWBt22; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NLQWBt22"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C729C32782;
	Wed, 26 Jun 2024 17:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719421898;
	bh=PDYInYiXapW5mgeDZlEs9BWPGax4j0lEMgJOT0CUAPY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=NLQWBt22gMbr9R7Nb27SsKZ3m1FDrVvL41xboj1t8TexRO79DO6n2/CrDk1u9eU7W
	 L/INe6Q1ltq7t52xjR8bsWXeRJttC7rRYSH+5VzH3I9F4H0nockX8WpxDCbexitFxm
	 kXNfpsY4E1Tgoz8UMJThIeIqMQeu+4cKZAM9VbGU=
Date: Wed, 26 Jun 2024 10:11:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michal Hocko <mhocko@suse.com>
Cc: mm-commits@vger.kernel.org, yosryahmed@google.com, willy@infradead.org,
 wangkefeng.wang@huawei.com, tj@kernel.org, shakeel.butt@linux.dev,
 shakeelb@google.com, roman.gushchin@linux.dev, rientjes@google.com,
 nphamcs@gmail.com, muchun.song@linux.dev, lizefan.x@bytedance.com,
 hughd@google.com, hannes@cmpxchg.org, findns94@gmail.com, david@redhat.com,
 corbet@lwn.net, chrisl@kernel.org, schatzberg.dan@gmail.com
Subject: Re: [nacked] mm-add-swapiness=-arg-to-memoryreclaim.patch removed
 from -mm tree
Message-Id: <20240626101137.135997396b4e184643e045a4@linux-foundation.org>
In-Reply-To: <ZnuxTAcFbW0mI5uD@tiehlicka>
References: <20240625210334.0BCA0C32781@smtp.kernel.org>
	<ZnuxTAcFbW0mI5uD@tiehlicka>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 26 Jun 2024 08:12:28 +0200 Michal Hocko <mhocko@suse.com> wrote:

> On Tue 25-06-24 14:03:33, Andrew Morton wrote:
> > 
> > The quilt patch titled
> >      Subject: mm: add swappiness= arg to memory.reclaim
> > has been removed from the -mm tree.  Its filename was
> >      mm-add-swapiness=-arg-to-memoryreclaim.patch
> > 
> > This patch was dropped because it was nacked
> 
> I do not see this being nacked in the original email thread.

Sorry, I thought I sent an email about this.

Yu Zhou didn't like and the submitter (Dan) didn't participate in the
review discussion and the patchset wasn't going forward.

Dan, please prepare a new revision, attempt to address review thus far
and let's fire it up again.

