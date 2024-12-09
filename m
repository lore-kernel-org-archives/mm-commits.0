Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FD27136357
	for <mm-commits@vger.kernel.org>; Mon,  9 Dec 2024 08:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733733744; cv=none; b=KVkSPJf7PI33frJGE8QrHDIQ3DYX6CKifjMWgiqWuyZM5/Fi6+JGKNtuUunmpoGCKMyR600JMWxGaYxjp/HmQzvEddID9Tno/vFl6aRce0OOOVB0ZplMgPL+vo2Aw0KmU6t5oKh9g+y24Nx2aWSQnRtFzBJKXKWbLQqeG6zDD2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733733744; c=relaxed/simple;
	bh=560cY8Or/aigAyweNmUw00H+TZZqlIiHURVWMsniVaE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P6O04OFa//Ejzy04gqnnCX862NhqcnSThWph4PTqkyqrLrcbM0BWcR/9YXQVRLeSPcQaQHcz2cPKmM2WtVMig0aJS5fcM5a3jAqG4TaOCHfDWeUm+SHJ0Eyw6daj4V4DXi5iCL7j7d8/WP33miAdmgitLwN/okfcW3YOTXkaelA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ASZs58VH; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ASZs58VH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=GSbjiuljBZMtWWu8HAh/uwBGS991STHgLkDuV7SoClc=; b=ASZs58VHy8STE64G+oLxqzRe5k
	cj2fVhEMpfVeHc7wt2+F6J9PbZFhId2kD6qkVjBiGj7KCOH564Q+f0EkYeY+yydn5pOG2lupawHhS
	/ag/rEwxoYGDArU6wEwCjWpq8wwPRlaoorgUp995W0MOqrsMrHOsp0O4ADILqrRLVWBRLz2lwbbD3
	jOxkVvbZ4AODjCd5MFTvbva6jDftxTATnw3VUi/CBzv8IEhhfTHvVex+vpGoS781OZk606DVDD7yZ
	dTzDmoZBrw8KLjrzJ8gtR/9nQxRi2SNXWgg/xsK+brDzUtN/i4WI85HipplVDkKBxRaloNF1Ls6Dp
	mROhyHnA==;
Received: from 77-249-17-89.cable.dynamic.v4.ziggo.nl ([77.249.17.89] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tKZLA-00000003VeW-06a1;
	Mon, 09 Dec 2024 08:42:04 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 940673003FF; Mon,  9 Dec 2024 09:42:03 +0100 (CET)
Date: Mon, 9 Dec 2024 09:42:03 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
	souravpanda@google.com, shakeel.butt@linux.dev,
	richard.weiyang@gmail.com, peterx@redhat.com, paulmck@kernel.org,
	pasha.tatashin@soleen.com, oleg@redhat.com, mjguzik@gmail.com,
	minchan@google.com, mhocko@suse.com, mgorman@techsingularity.net,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
	jannh@google.com, hughd@google.com, hdanton@sina.com,
	hannes@cmpxchg.org, dhowells@redhat.com, david@redhat.com,
	dave@stgolabs.net, corbet@lwn.net, brauner@kernel.org,
	surenb@google.com
Subject: Re: + mm-convert-mm_lock_seq-to-a-proper-seqcount.patch added to
 mm-unstable branch
Message-ID: <20241209084203.GE21636@noisy.programming.kicks-ass.net>
References: <20241207042919.E4C44C4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241207042919.E4C44C4CECD@smtp.kernel.org>

On Fri, Dec 06, 2024 at 08:29:19PM -0800, Andrew Morton wrote:
> 
> The patch titled
>      Subject: mm: convert mm_lock_seq to a proper seqcount
> has been added to the -mm mm-unstable branch.  Its filename is
>      mm-convert-mm_lock_seq-to-a-proper-seqcount.patch

I'm having a pile of these patches in tip/perf/core
