Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83EDE324B1F
	for <mm-commits@vger.kernel.org>; Wed,  8 Apr 2026 01:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775610537; cv=none; b=RxzSi0dEtsjtbiXb71M9QxnWtG2suplrWxpzEAbpTuQVvy5SZOxIYWHrK+IcFTz7g8eGQZUg5IVURJhZLon4NJPfyPG/cflXMkHZfM63Gltv1sEkJJFZt3OtrZ12H/MZ6VpWf5X/GXuBcGh3tMfLooNwM5PRyXJ2pEhyfEvmJPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775610537; c=relaxed/simple;
	bh=0VPkHhk1BTytrbEWc2X/LA30iFchBrzvIoMRhyOsrAw=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:Cc:
	 In-Reply-To:Content-Type; b=tOuiPBL0ciuXOoonu/iFc80+H30NLU8n1RwQqjYi3giLg2d3JaFmYOIhlSV7pqdKhX09jiOVd7p11QMleK8Xg5dLUR3WF++1Np8X14n+9CJlKTWBvSP68hWVzVzKuV6tRtfRj1ig3wEYGqLHFBJX2O819S0QAIjoEieftEB1BNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wwDuADB8; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wwDuADB8"
Message-ID: <ebde5bba-8147-40fe-a008-7cffad421637@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775610532;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zkxvwdUektqPpNj22jLMEaZwCLMTOoMdK3I9936Qt3s=;
	b=wwDuADB8MHCbj6idhseF4z40Q1bS9ceHuORZ2NH/Rc5T8f9HZUzr/AcfmQss43SJPhRm09
	H3AherjCKRIrDrIiwRuJGlYt6Sp0+8Lhux0d6xLQgsCNHoOqOzL4X3waBPsCxhfRFEFoEo
	eYcKAq5JzuuzuJZX2QV2s9CXfpcbTH8=
Date: Wed, 8 Apr 2026 09:08:41 +0800
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: +
 lib-test_hmm-evict-device-pages-on-file-close-to-avoid-use-after-free.patch
 added to mm-new branch
To: Andrew Morton <akpm@linux-foundation.org>
References: <20260401003334.2A85EC19423@smtp.kernel.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zenghui Yu <zenghui.yu@linux.dev>
Cc: mm-commits@vger.kernel.org, surenb@google.com, rppt@kernel.org,
 mhocko@suse.com, ljs@kernel.org, liam.howlett@oracle.com, leon@kernel.org,
 jgg@ziepe.ca, david@kernel.org, balbirs@nvidia.com, apopple@nvidia.com
In-Reply-To: <20260401003334.2A85EC19423@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

On 4/1/26 8:33 AM, Andrew Morton wrote:
> The patch titled
>      Subject: lib: test_hmm: evict device pages on file close to avoid use-after-free
> has been added to the -mm mm-new branch.  Its filename is
>      lib-test_hmm-evict-device-pages-on-file-close-to-avoid-use-after-free.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-test_hmm-evict-device-pages-on-file-close-to-avoid-use-after-free.patch
> 
> This patch will later appear in the mm-new branch at
>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> Note, mm-new is a provisional staging ground for work-in-progress
> patches, and acceptance into mm-new is a notification for others take
> notice and to finish up reviews.  Please do not hesitate to respond to
> review feedback and post updated versions to replace or incrementally
> fixup patches in mm-new.
> 
> The mm-new branch of mm.git is not included in linux-next
> 
> If a few days of testing in mm-new is successful, the patch will me moved
> into mm.git's mm-unstable branch, which is included in linux-next
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next via various
> branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there most days
> 
> ------------------------------------------------------
> From: Alistair Popple <apopple@nvidia.com>
> Subject: lib: test_hmm: evict device pages on file close to avoid use-after-free
> Date: Tue, 31 Mar 2026 17:34:43 +1100
> 
> Patch series "Minor hmm_test fixes and cleanups".
> 
> Two bugfixes a cleanup for the HMM kernel selftests.  These were mostly
> reported by Zenghui Yu with special thanks to Lorenzo for analysing and
> pointing out the problems.
> 
> 
> This patch (of 3):
> 
> When dmirror_fops_release() is called it frees the dmirror struct but
> doesn't migrate device private pages back to system memory first.  This
> leaves those pages with a dangling zone_device_data pointer to the freed
> dmirror.
> 
> If a subsequent fault occurs on those pages (eg.  during coredump) the
> dmirror_devmem_fault() callback dereferences the stale pointer causing a
> kernel panic.  This was reported [1] when running mm/ksft_hmm.sh on arm64,
> where a test failure triggered SIGABRT and the resulting coredump walked
> the VMAs faulting in the stale device private pages.
> 
> Fix this by calling dmirror_device_evict_chunk() for each devmem chunk in
> dmirror_fops_release() to migrate all device private pages back to system
> memory before freeing the dmirror struct.  The function is moved earlier
> in the file to avoid a forward declaration.
> 
> Link: https://lkml.kernel.org/r/20260331063445.3551404-1-apopple@nvidia.com
> Link: https://lkml.kernel.org/r/20260331063445.3551404-2-apopple@nvidia.com
> Fixes: b2ef9f5a5cb3 ("mm/hmm/test: add selftest driver for HMM")
> Signed-off-by: Alistair Popple <apopple@nvidia.com>
> Reported-by: Zenghui Yu <zenghui.yu@linux.dev>
> Closes: https://lore.kernel.org/linux-mm/8bd0396a-8997-4d2e-a13f-5aac033083d7@linux.dev/
> Reviewed-by: Balbir Singh <balbirs@nvidia.com>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Leon Romanovsky <leon@kernel.org>
> Cc: Liam Howlett <liam.howlett@oracle.com>
> Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Zenghui Yu <zenghui.yu@linux.dev>
> Cc: <stable@vger,kernel.org>

Cc: <stable@vger.kernel.org>

?

Thanks,
Zenghui
