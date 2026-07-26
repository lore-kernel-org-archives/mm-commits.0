Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E5BB1A6809
	for <mm-commits@vger.kernel.org>; Sun, 26 Jul 2026 02:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785033118; cv=none; b=cz/A2b05WYckmxb4aV8kBgJvHiX6ruB/vsK7VZDxXE6Hm/yXWKCdC9q/u7G71FD+VjukGPZqdKJT6YtfUz4eKyZu+27v/yLTKfzQx0xKnBFKFzsi4r2QVX75b9Hd8qMy7AtYP1yfjtTWJezecFYBb9DJ+fkxifS5vEsa1Ncz+g8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785033118; c=relaxed/simple;
	bh=KaAwOF2xjrPUKU2aq7oks8yx8EosFjyFDXXlG51LHXU=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=Geu99/0NixJX81nv4q3AQg+udF2C13knatQvUVvgi1i5j42Vbj32FK2VWUfJbby7VRFw+v+yAUmRHKsBmRgFFcQT8rULB3MEkwUaC0gc4v5ShEqmPWy4jtl32daFd3lJrcIYtiuftZzL+D42pnVyIWFbkoIh4fml7DZqECSG4uU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0S7xinMg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0S7xinMg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A72E1F000E9;
	Sun, 26 Jul 2026 02:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785033116;
	bh=f6+XXUR5lBU9DHLuveWr4u6xO1b7eTisGaSLWHvXZb0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=0S7xinMgsoPuxz/eqN+Uerpodx94PS6f9Ur0SDwyuEqY3yqoiypP6tFjfFw/UlNrY
	 XtM6H+Q+RmeH3ufA6fzqpdSwYc2y30rS4+gbyhwFC/hxMxVP+lkDyJdT09B05cnW+h
	 VxWrEwxlSv2B8cQJwxkkBVdoL0lwbF3G0fZCxY8k=
Date: Sat, 25 Jul 2026 19:31:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <lkp@intel.com>
Cc: David Hildenbrand <david@kernel.org>, Linux Memory Management List
 <linux-mm@kvack.org>, mm-commits@vger.kernel.org, Stanislav Kinsburskii
 <skinsburskii@gmail.com>, Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky
 <leon@kernel.org>
Subject: Re: [akpm-mm:mm-new] BUILD SUCCESS WITH UNVERIFIED WARNING
 34cacd0ac7c10dc9e34e1b9f28a2b78d335cb487
Message-Id: <20260725193155.0e03a382d76a99485ca05cdd@linux-foundation.org>
In-Reply-To: <202607251512.KMStVfrY-lkp@intel.com>
References: <202607251512.KMStVfrY-lkp@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit


Thanks.  A few head-scratchers for hmm people, please:

On Sat, 25 Jul 2026 15:11:38 +0800 kernel test robot <lkp@intel.com> wrote:

> tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> branch HEAD: 34cacd0ac7c10dc9e34e1b9f28a2b78d335cb487  mm/swap, PM: hibernate: atomically replace hibernation pin
> 
> Unverified Warning (likely false positive, kindly check if interested):
> 
>     https://lore.kernel.org/oe-kbuild/202607021433.DYT5fDqE-lkp@intel.com
>     https://lore.kernel.org/oe-kbuild/202607120402.clBrrZQA-lkp@intel.com
> 
>     mm/hmm.c:673 hmm_do_fault() error: we previously assumed 'hmm_vma_walk->locked' could be null (see line 654)
>     mm/vmpressure.c:123 vmpressure() warn: check likely/unlikely parentheses
> 
> Warning ids grouped by kconfigs:
> 
> recent_errors
> |-- microblaze-randconfig-r072-20260725
> |   `-- mm-hmm.c-hmm_do_fault()-error:we-previously-assumed-hmm_vma_walk-locked-could-be-null-(see-line-)

With this microblaze config on current mainline I hit

mm/hmm.c:804:25: error: implicit declaration of function 'mmu_interval_read_begin'; did you mean 'mmu_interval_check_retry'? [-Wimplicit-function-declaration]
  804 |                         mmu_interval_read_begin(range->notifier);

And after adding the hmm changes from mm-unstable I also hit

mm/hmm.c:805:25: error: implicit declaration of function 'mmu_interval_read_begin'; did you mean 'mmu_interval_check_retry'? [-Wimplicit-function-declaration]
  805 |                         mmu_interval_read_begin(range->notifier);
      |                         ^~~~~~~~~~~~~~~~~~~~~~~
      |                         mmu_interval_check_retry

Both of which can be fixed with

--- a/include/linux/mmu_notifier.h~a
+++ a/include/linux/mmu_notifier.h
@@ -576,6 +576,19 @@ static inline void _mmu_notifier_range_i
 	_mmu_notifier_range_init(range, start, end)
 
 static inline bool
+mmu_interval_check_retry(struct mmu_interval_notifier *interval_sub,
+			 unsigned long seq)
+{
+	return true;
+}
+
+static inline unsigned long
+mmu_interval_read_begin(struct mmu_interval_notifier *interval_sub)
+{
+	return 0;
+}
+
+static inline bool
 mmu_notifier_range_blockable(const struct mmu_notifier_range *range)
 {
 	return true;

But I do wonder whether we should be compiling hmm at all if
CONFIG_MMU_NOTIFIER=n?


And your hmm_do_fault() warning seems legit:

	if (hmm_vma_walk->locked)
		fault_flags |= FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;

...
			*hmm_vma_walk->locked = false;

and the blame seems to lie with Stanislav's "mm/hmm: add
hmm_range_fault_unlocked_timeout() for mmap lock-drop support".


