Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66A3613B584
	for <mm-commits@vger.kernel.org>; Sun, 26 Jul 2026 18:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785091292; cv=none; b=GoG7L9PBFfeI5pWAq6vjToH3EaXPSf0mDxKtEQfVamo0wKO7JLV60j7CjvEqNmMy3N4rLaXbhQ4briaLTLK00HBfzw6qI0AQCTPNYGrHfYCPeb59X1ug8ZV6mwIzyCo3rqFqbuEQM+pLvgqXXqVFDOzz7SvdFaE8kFlfGT53rVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785091292; c=relaxed/simple;
	bh=n/0rf9Q/3JcIvKGkLjHFa6VgtoB7lG0B6iGS/mg4Dj4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VnJ+MknmzT32qKqP8MVpwzsbPNyO9IAhhIIYduzlnCjAC5v8hxCGpLQqohnpGAqFNB6xRBV0BzWDMRc1C3rSWgiPXM3rHLzAeeUPWwAwoOF8bihMLN8HT1mtyW9IwqzNHwKolrnzP0z8s8pMxxrWqLFDmuHT28T3kfzTA9IE9og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NIdH8gpF; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NIdH8gpF"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-38101f85591so2686236a91.1
        for <mm-commits@vger.kernel.org>; Sun, 26 Jul 2026 11:41:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785091291; x=1785696091; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=rnsX5Nycy+Nw1GF/hyAVIF+SSLqhhOcEVPTSmKPICUw=;
        b=NIdH8gpF7DQBqnL04ZSa1fSjpXUMqxsdKHNMnIUe6k8DnnRdKqiQUg5u+d0w8GcmM9
         u5RBn6nyU+6w2OFBUXdAO+ubPAhho1Qli/7Mtt0vL1CTQLBdTuziTugXdzTgIDcRB0Wy
         fZEW2Q0GFk/OagbTIAhtohdVdQyq4C6OMYDa9iCHKG215OgTlv/1JbGnegwWh0KsR82r
         c7brnfQGHx2T6VLrw1uudBWkiW5lCGphBAVj7NmNj1yvjDVHqfhvOUQ6aOHzNqyw0tMJ
         0UtAmI2SNaqHazRn5Q40+qYcALGN4je5q6A3jm2ANAfxjCcO0sgkXGR9fsy2SqhH/y57
         /jUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785091291; x=1785696091;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rnsX5Nycy+Nw1GF/hyAVIF+SSLqhhOcEVPTSmKPICUw=;
        b=B86wxlMUqbZOa3rOLc8Cpq3zqPPLnc5X+vtmCQj6e8CSIJR7sz5lfDZG6w4LJCjFA9
         ZlVyjkyMp2IQfOQBMna9C7UM54jebKRdUwwgRaApEmnoZahn5+Mb/aZwmQ4GGQUobC4C
         0Tj15+CB6xT6/++mx/+g+315oyDM+i+Pg7MUGcqwvLYt/McWUc5T3V+ogrHovTC9LtuJ
         mnhgRJIs07iMLNA72BevHFiIlwWAfN6pTK65UgoF0oRUQ3P6OKVX+CN+X0PniX0QEYD4
         41nJA3XZTLiCM1hYwKkqzBS4creYhIgTnPBXlmWfje/VnCSs4duFAHNwtFE+B/V2jgM/
         vQ8Q==
X-Forwarded-Encrypted: i=1; AHgh+RrDANR9VTloyVYC6BhpoaQT4cGySGwXAmEa5PnMy1zk0oS+oLH5L6WBvLo+jekmnTWg4Rssu9lc4ii8@vger.kernel.org
X-Gm-Message-State: AOJu0YyQjQ8vsgSfCwvIPraaSb/A0mnfDWNzMf3y1HpggINlR8bfSa4A
	RmPZGxW6eQfE68u3axZT9XMLAJXwB82aSmeeBNP+vpE8u55vZ2C3cIMa
X-Gm-Gg: AR+sD12WZ61UtbDu+2FVL/AqfGDdG6dZsd2GBUwQgWmZ1hAjH8aRGPIAfzcpX021+zt
	61a4TUmMlVQDODmvhKb0iGvlMhryPaTqOS+IB4wOOoDANfxAUvUHdGbub0izm5bR6/igB67HftJ
	QxCIa+pibE3B+Rlah0O2tSVatwpMsa7vT1pnBQD1T6vkkn9/gUogMpXr3PDfTC3NKnIpSt+aVss
	TthN8+EcgoxOZc+2qDobcsymrBcinsFQA5RqljvmtthZsBiVo18oshT9NE9zea/xg7ZEFN8ETg/
	WZNnbhVc/pE12f/QQb82r5JJkCAgGg+fzKefwRPFWZWS+LSyKnT9amKb57I7lqC3dr9MptpFwBR
	sa1baFpM4b1xGGvPiCvk1DNeeGGnhhjOlQ30XTQ+ED84P5hi5O4fPRpx8Z7biJEVZstGGdiTKvI
	l//NEhPNM6fKu1FTETHK5OZW7RHdjeeK64Ye1uIFkpKGxp
X-Received: by 2002:a17:90b:4d90:b0:38e:4e61:c9e with SMTP id 98e67ed59e1d1-38f2aad0dbfmr4574273a91.21.1785091290598;
        Sun, 26 Jul 2026 11:41:30 -0700 (PDT)
Received: from skinsburskii (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38f0583bcd0sm3144769a91.1.2026.07.26.11.41.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jul 2026 11:41:29 -0700 (PDT)
Date: Sun, 26 Jul 2026 11:41:26 -0700
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kernel test robot <lkp@intel.com>, David Hildenbrand <david@kernel.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	mm-commits@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Subject: Re: [akpm-mm:mm-new] BUILD SUCCESS WITH UNVERIFIED WARNING
 34cacd0ac7c10dc9e34e1b9f28a2b78d335cb487
Message-ID: <amZU1hH_9IOeO4G8@skinsburskii>
References: <202607251512.KMStVfrY-lkp@intel.com>
 <20260725193155.0e03a382d76a99485ca05cdd@linux-foundation.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260725193155.0e03a382d76a99485ca05cdd@linux-foundation.org>

On Sat, Jul 25, 2026 at 07:31:55PM -0700, Andrew Morton wrote:
> 
> Thanks.  A few head-scratchers for hmm people, please:
> 
> On Sat, 25 Jul 2026 15:11:38 +0800 kernel test robot <lkp@intel.com> wrote:
> 
> > tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> > branch HEAD: 34cacd0ac7c10dc9e34e1b9f28a2b78d335cb487  mm/swap, PM: hibernate: atomically replace hibernation pin
> > 
> > Unverified Warning (likely false positive, kindly check if interested):
> > 
> >     https://lore.kernel.org/oe-kbuild/202607021433.DYT5fDqE-lkp@intel.com
> >     https://lore.kernel.org/oe-kbuild/202607120402.clBrrZQA-lkp@intel.com
> > 
> >     mm/hmm.c:673 hmm_do_fault() error: we previously assumed 'hmm_vma_walk->locked' could be null (see line 654)
> >     mm/vmpressure.c:123 vmpressure() warn: check likely/unlikely parentheses
> > 
> > Warning ids grouped by kconfigs:
> > 
> > recent_errors
> > |-- microblaze-randconfig-r072-20260725
> > |   `-- mm-hmm.c-hmm_do_fault()-error:we-previously-assumed-hmm_vma_walk-locked-could-be-null-(see-line-)
> 
> With this microblaze config on current mainline I hit
> 
> mm/hmm.c:804:25: error: implicit declaration of function 'mmu_interval_read_begin'; did you mean 'mmu_interval_check_retry'? [-Wimplicit-function-declaration]
>   804 |                         mmu_interval_read_begin(range->notifier);
> 
> And after adding the hmm changes from mm-unstable I also hit
> 
> mm/hmm.c:805:25: error: implicit declaration of function 'mmu_interval_read_begin'; did you mean 'mmu_interval_check_retry'? [-Wimplicit-function-declaration]
>   805 |                         mmu_interval_read_begin(range->notifier);
>       |                         ^~~~~~~~~~~~~~~~~~~~~~~
>       |                         mmu_interval_check_retry
> 
> Both of which can be fixed with
> 
> --- a/include/linux/mmu_notifier.h~a
> +++ a/include/linux/mmu_notifier.h
> @@ -576,6 +576,19 @@ static inline void _mmu_notifier_range_i
>  	_mmu_notifier_range_init(range, start, end)
>  
>  static inline bool
> +mmu_interval_check_retry(struct mmu_interval_notifier *interval_sub,
> +			 unsigned long seq)
> +{
> +	return true;
> +}
> +
> +static inline unsigned long
> +mmu_interval_read_begin(struct mmu_interval_notifier *interval_sub)
> +{
> +	return 0;
> +}
> +
> +static inline bool
>  mmu_notifier_range_blockable(const struct mmu_notifier_range *range)
>  {
>  	return true;
> 
> But I do wonder whether we should be compiling hmm at all if
> CONFIG_MMU_NOTIFIER=n?
> 

Documentation/mm/hmm.rst explicitly states:

"Address space mirroring's main objective is to allow duplication of a range of
CPU page table into a device page table; HMM helps keep both synchronized. A
device driver that wants to mirror a process address space must start with the
registration of a mmu_interval_notifier"

I think making CONFIG_HMM_MIRROR dependent on the CONFIG_MMU_NOTIFIER is the right thing to do.

> 
> And your hmm_do_fault() warning seems legit:
> 
> 	if (hmm_vma_walk->locked)
> 		fault_flags |= FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
> 
> ...
> 			*hmm_vma_walk->locked = false;
> 
> and the blame seems to lie with Stanislav's "mm/hmm: add
> hmm_range_fault_unlocked_timeout() for mmap lock-drop support".
> 

Well, this is the same behavior as in fixup_user_fault().

The fault handler is not supposed to return either VM_FAULT_COMPLETED or
VM_FAULT_RETRY unless FAULT_FLAG_ALLOW_RETRY is set, and that flag is
set only if hmm_vma_walk->locked is not NULL.

In other words, only buggy fault handlers can trigger this NULL pointer
dereference, and I thought we had agreed that we do not try to support
those.

Let me know if you think otherwise and I'll send an update.

Thanks, Stanislav

> 
