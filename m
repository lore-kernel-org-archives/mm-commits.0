Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92CE719CD0A
	for <mm-commits@vger.kernel.org>; Thu, 28 May 2026 17:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779988443; cv=none; b=Ge4Ir5urKSavaB7eVfKi5Ph1W7JufntRD7mZvEzoWEJoYlFS9IPS2OtAnqnoK7Im+MYPEh4rE9/50cV5Bpnqu0Nnc6GLbcLP3SY2Nu5miYOyop2yij8JmQJ6v9Hms7mPkynmeCfjF/vThWc7Q+ijYaOcgu9o/yvVkddxw7YBbeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779988443; c=relaxed/simple;
	bh=tfKKkM/oy2z3qN1CLyHW46RsIwX+Ru7+MX7N5+w68BM=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=T0FOB2SMBuMrJ8WugT9SxKa+A4ReTL//s5cOFwaKPh6AiM+1NSMJVsobHCiCP/aPxeBbpECX/CUwH3O88y1Oja4pRRfWDbBFnfKUhnPX+jGBw04+gMGtC2rwrzABnmUJky5tNoOpgmSyH1IHcDsmZHZmOtRCxadkswgJx5Hg068=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QG5hMljN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QG5hMljN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2FC51F000E9;
	Thu, 28 May 2026 17:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779988442;
	bh=bQhqZnGi02rWphxYFousBWJ3WtVsbvjFLCMT/m55VSQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=QG5hMljN6tlsQQMUURP9F14LyWnla1zE1BKeMx/JOQYM/7AOni1okjI3N85tBPEvx
	 tGvQBTDihKt5OKMVMXEMBcanMPz3HZnz9C5zHsL62HHyr4a6lsLzx4yexE/bI5vdjV
	 hMRphTrksTiA04nb/FyMlMsmRd5a1d7mN7QgMGFo=
Date: Thu, 28 May 2026 10:14:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Mark Brown <broonie@kernel.org>, mm-commits@vger.kernel.org,
 roman.gushchin@linux.dev, rientjes@google.com, harry@kernel.org
Subject: Re: +
 maintainers-add-slab-related-scripts-and-tools-to-slab-allocator.patch
 added to mm-hotfixes-unstable branch
Message-Id: <20260528101401.c4727d268ee70092e7234966@linux-foundation.org>
In-Reply-To: <5c340177-548e-4c9d-aaaa-d28b30b0903a@kernel.org>
References: <20260525174125.746121F000E9@smtp.kernel.org>
	<5c340177-548e-4c9d-aaaa-d28b30b0903a@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 28 May 2026 11:44:20 +0200 "Vlastimil Babka (SUSE)" <vbabka@kernel.org> wrote:

> > From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
> > Subject: MAINTAINERS: add slab-related scripts and tools to SLAB ALLOCATOR
> > Date: Mon, 25 May 2026 09:26:39 +0200
> > 
> > Make sure the maintainers and reviewers are CC'd on changes to the scripts
> > and tools that depend on slab internals.
> > 
> > Link: https://lore.kernel.org/20260525-maint-slab-tools-v1-1-d66b69f1412a@kernel.org
> > Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> > Acked-by: Harry Yoo (Oracle) <harry@kernel.org>
> > Cc: David Rientjes <rientjes@google.com>
> > Cc: Roman Gushchin <roman.gushchin@linux.dev>
> > Cc: Vlastimil Babka <vbabka@kernel.org>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> 
> Hm I've put that to slab/for-next too, and the slabinfo patches that
> triggered this update as well [1] and they are also in the mm tree.

It's confusing when a git tree owner sends a patch.  I don't know if it
means "please apply this" or "I intend to apply this, please review". 
Not a huge issue, but explicit clarification would be helpful.

I'll drop the mm.git copy of this.

