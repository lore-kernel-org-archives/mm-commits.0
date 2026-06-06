Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00B8F233723
	for <mm-commits@vger.kernel.org>; Sat,  6 Jun 2026 02:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780713326; cv=none; b=GDEuiX/TzfrPVwzjzNYrFSAa3VeaCnuBtO0pLjrmlzNqZSSRrKqHKVBn6aQtmi8I8/Y/Zq3FR2pa7E1FRv7yU/gzbVp3GJBkR+xearQbJJfpZJOVIR9MZd2OVAZLeGmxTV2s8kHwx252PFW19QjBCY8wi7/02Q7DUkzrk1aOxzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780713326; c=relaxed/simple;
	bh=ngkM6yaBvmdrsakEUC5rDhNrRIFKg2cNNEmcRRe0BAw=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=jT1pjCR0STYerIECh4OAtXoWm389jCATlqHEHymghPlbI9nqDc0wPKZZFjTOsA4m8OUu3LP1qke/BY8yKR9xik/ORGW2f1eLdyLRW4LVdMk0wF3k0dyRBl4esOhBm9z3hdEnKWK3oekKeq4aa6mgGdbQIqGFUWTyMdk7CTGwvO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EtcOzEfR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EtcOzEfR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B6C01F00893;
	Sat,  6 Jun 2026 02:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780713324;
	bh=s+hR9OKg375GRVRwWz0j3ymtFn1IU53PC4Nt+pTrMdE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=EtcOzEfRWXMMYuyhzQj1KrHIaDJ/16ki8l1j7/0QAmrKz1bS1aInR8YS7a6bHlvk1
	 FGVSGGTym0bzy3SaeeYeUoJlusHqJGoyY7erpkYeRMMU3ak/AE6tOLNh7VStVgQsYe
	 CyRO+g4Hb5ZyghsFWbqn/lE9IooE0NoLhXc2g0OU=
Date: Fri, 5 Jun 2026 19:35:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Maxwell Doose <m32285159@gmail.com>
Cc: mm-commits@vger.kernel.org, fabf@skynet.be, brauner@kernel.org
Subject: Re: + fs-efs-remove-unneeded-debug-prints.patch added to
 mm-nonmm-unstable branch
Message-Id: <20260605193524.f277071da69189161e84e327@linux-foundation.org>
In-Reply-To: <CAKqfh0Eenm536jtRZ=0dwobpanBxXHk+4sauON-tQcTi9dcQZg@mail.gmail.com>
References: <20260606013254.96CA41F00893@smtp.kernel.org>
	<CAKqfh0Eenm536jtRZ=0dwobpanBxXHk+4sauON-tQcTi9dcQZg@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Fri, 5 Jun 2026 21:28:03 -0500 Maxwell Doose <m32285159@gmail.com> wrote:

> On Fri, Jun 5, 2026 at 8:32 PM Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > The patch titled
> >      Subject: fs: efs: remove unneeded debug prints
> > has been added to the -mm mm-nonmm-unstable branch.  Its filename is
> >      fs-efs-remove-unneeded-debug-prints.patch
> >
> > This patch will shortly appear at
> >      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-efs-remove-unneeded-debug-prints.patch
> >
> > This patch will later appear in the mm-nonmm-unstable branch at
> >     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> >
> 
> Thanks for merging this. I know that EFS is orphaned, so I was
> wondering if I could step up to maintain it. Mathew Wilcox had
> mentioned how this filesystem is incredibly outdated and it should
> probably see conversion to a FUSE, however in the meantime it should
> probably see more fixes, modernizations, dead code removal, etc. I
> hope I'm not being too hasty, given I've only sent about 2 patches in
> fs!

Fine by me, and thanks.  But I believe Christian is the guy to speak
with regarding this.
