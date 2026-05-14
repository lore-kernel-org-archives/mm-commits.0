Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA8C7346E4A;
	Thu, 14 May 2026 21:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778795031; cv=none; b=IQaWMsp5q5+wn6EvScZyYOyNdiseghjRLKJmL3VWy3Yb7drOAq+LZW7GboO1K9XgnX38jyGr5ZBHIHb35TGk5xjaRzNr6rhk4/Xw7Gx4ZKRKrugG+FWcgFWVtmjVP6iwE9dZs75/uNqhPumvMH6XFVdRD9QuUh5gnWX32OYV0po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778795031; c=relaxed/simple;
	bh=205Dg9+b13DcjQTMV0rTW+w1f2xOl+JJOBtYTKjYa6A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RIb3IsVe4Uku6Nd//sdjQnOg2J+8+rMGAi2+A8VIZVOtCLDmoYFHR8y+MwsrTAGbRbxnJs/BmdROW2zDJGpsFtKdbL9W/QpLX7p1QmRunS46+7yguF6NeOcrnNlmkpuw1epepAkXj3WOiOKyBN2J5F1z1R4f8UggIG16Z6ifrx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JFC7SNiE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JFC7SNiE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DF56C2BCB3;
	Thu, 14 May 2026 21:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778795031;
	bh=205Dg9+b13DcjQTMV0rTW+w1f2xOl+JJOBtYTKjYa6A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JFC7SNiE8UhhRnsLS0Ce0FMQV24ymQdI8Gk1BQHRRbrozaDAVLrUNELRnFM2BWeix
	 gkD8A83rg3AXWBFpGAUJEKxYBwnKNUKHNfbDKI5VavH62uRdJPizbxGXO/FlNy5p8G
	 4vHda2u9el0P5PPAxyZCjSsP03mTK5mxQVHn3nwWzhpSRQArsKJnXHIRiDjPbCJy7J
	 Y8cSmyhy5lMfP6jhowY1TOr5Si/M+RhKyaGSngXjafGeAp8fUe9RHgcTW0D4dklO0R
	 F8zkmRJXjvvC46DkDAkfaKHIUP1DPqmB0ko6y8w4j6efDbyWJ/1gHLIdHbipc7aCXF
	 8qTUZW0sN98Tg==
Date: Thu, 14 May 2026 14:43:50 -0700
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kernel test robot <lkp@intel.com>, oe-kbuild-all@lists.linux.dev,
	David Hildenbrand <david@kernel.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	mm-commits@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>
Subject: Re: [akpm-mm:mm-new 301/315] mm/oom_kill.c:922:12: warning:
 'kill_all_shared_mm' defined but not used
Message-ID: <agZCFll-lFLqabbJ@google.com>
References: <202605131940.kEzvUaiR-lkp@intel.com>
 <20260513102711.323fed51b7dbb1dfe6217b44@linux-foundation.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513102711.323fed51b7dbb1dfe6217b44@linux-foundation.org>

On Wed, May 13, 2026 at 10:27:11AM -0700, Andrew Morton wrote:
> On Wed, 13 May 2026 19:48:25 +0800 kernel test robot <lkp@intel.com> wrote:
> 
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> > head:   2c3f468717231305523ddcd94d91c0d5e4a72419
> > commit: def36547cd98fa3f7ecac1bf860479f500bc6b1e [301/315] mm: process_mrelease: introduce PROCESS_MRELEASE_REAP_KILL flag
> > config: sh-allnoconfig (https://download.01.org/0day-ci/archive/20260513/202605131940.kEzvUaiR-lkp@intel.com/config)
> > compiler: sh4-linux-gcc (GCC) 15.2.0
> > reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260513/202605131940.kEzvUaiR-lkp@intel.com/reproduce)
> > 
> > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Closes: https://lore.kernel.org/oe-kbuild-all/202605131940.kEzvUaiR-lkp@intel.com/
> > 
> > All warnings (new ones prefixed by >>):
> > 
> > >> mm/oom_kill.c:922:12: warning: 'kill_all_shared_mm' defined but not used [-Wunused-function]
> >      922 | static int kill_all_shared_mm(struct task_struct *victim, struct mm_struct *mm)
> 
> Thanks. I  did this:

Thank you, Andrew.
