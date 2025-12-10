Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 044DB25524C
	for <mm-commits@vger.kernel.org>; Wed, 10 Dec 2025 23:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765408149; cv=none; b=bVUwm4M85fDAecDxbd4ir5m+n+8JGE4OvAheOfZ6lshk0mlQMWPkKt2/K2Mw6RUpMuYhx8dxbeKtStusJRU0nvw1e8/I+rH4sugOhB5IRosG0WlxNGFeM8AHNiOe+DIlKs0WDvrGtYsuxVtPW396v8F1BhUPZ2JFWOa81By52V8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765408149; c=relaxed/simple;
	bh=FP0QBcKZLXjVyr3oYiAZ6989QR1zqMbIdvUZ7ikl6eo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sieumm5gWuHPoIrAI87doPhwp3cuIEmua70qg9CnUHBYr8Cs0PoKBuvj1lv1YObOJ0CufYfPc32nyzBO5/9V5igZFwMruil8Wq/8i8Vainc7PYWJlsVqjn8biT+v/4QXk7crPwC/Way4VJ2DkaPHX7JC/zdCMWdr/pYgMrnTEJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mWKuOwvd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mWKuOwvd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 222FAC4CEF1;
	Wed, 10 Dec 2025 23:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765408148;
	bh=FP0QBcKZLXjVyr3oYiAZ6989QR1zqMbIdvUZ7ikl6eo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mWKuOwvdSD6LARD0vXgyxrf8gWM9NGZaL+17EaEuc7JjNCRY5kWMU/8k2juC+8mHw
	 Pt7vQZtusGbVyvfEDGysbht8Uhe76OfeqoxXJhBJVFaQkc8TfNohm1QgI+rAR5cfV0
	 pCnsNGVFONQC1BJdRwUGRGMKtaXneSJpqJ9dTEoP8v5Jcs6dKTXJK3+LojhsZpY+Ev
	 bRLAODYnx1lhMs5cAz8fFkYVYOqxZDhzMk0KxKyUXknjmxqZCI7FjZrVmrT7Y4QpcF
	 nvpUS2zrXlJZTJk3jw+GGlhB6hLfkm0sy0awTJlfC6Ha8CgbkRmIKNCQ5ceoiH32LX
	 SC7Q4GCSk4EVA==
Date: Thu, 11 Dec 2025 08:09:03 +0900
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, skhawaja@google.com, rientjes@google.com,
	pratyush@kernel.org, pmladek@suse.com, kees@kernel.org,
	dmatlack@google.com, davidgow@google.com, corbet@lwn.net,
	pasha.tatashin@soleen.com
Subject: Re: [merged mm-nonmm-stable]
 liveupdate-luo_flb-introduce-file-lifecycle-bound-global-state.patch removed
 from -mm tree
Message-ID: <aTn9jyHeIR_AidS-@kernel.org>
References: <20251209193312.7CF12C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251209193312.7CF12C4CEF5@smtp.kernel.org>

Hi Andrew,

On Tue, Dec 09, 2025 at 11:33:11AM -0800, Andrew Morton wrote:
> 
> The quilt patch titled
>      Subject: liveupdate: luo_flb: introduce File-Lifecycle-Bound global state
> has been removed from the -mm tree.  Its filename was
>      liveupdate-luo_flb-introduce-file-lifecycle-bound-global-state.patch
> 
> This patch was dropped because it was merged into the mm-nonmm-stable branch
> of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Didn't we agree to keep this in mm-nonmm-unstable until either LUO support
for VFIO or hugetlb are ready to merge?

I didn't have time to properly review it yet and I didn't see Pratyush's
comments on this either.
 
> ------------------------------------------------------
> From: Pasha Tatashin <pasha.tatashin@soleen.com>
> Subject: liveupdate: luo_flb: introduce File-Lifecycle-Bound global state
> Date: Tue, 25 Nov 2025 17:50:05 -0500
> 
> Patch series "Live Update: File-Lifecycle-Bound (FLB) State", v8.
> 
> This series adds support for FLB state to the Live Update Orchestrator.
> 
> This functionality was originally part of the main LUO series [1] but has
> been split out to serve as a stable dependency for upcoming device
> preservation series.
 
-- 
Sincerely yours,
Mike.
