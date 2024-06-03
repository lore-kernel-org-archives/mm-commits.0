Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6F5012C816
	for <mm-commits@vger.kernel.org>; Mon,  3 Jun 2024 13:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717420433; cv=none; b=ii4JJu1A9r1CHkNKxIEtY71kIX97t7MHCkIRpIrQXeqqwqmRVexgTl0XrUX2DH7A62D7bYOH2x6Xyuwy1/evsNDtgrWfQjzQFue8O7Ox4AayEGl8s4F/kObXg78r9sPjWdCJShMlkIwMuS+j0MTJU5m2Di5kXi2cqtg+8H8a0iY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717420433; c=relaxed/simple;
	bh=Ak7QswN+LOkA/aRcDFg7VninzqLBDkjs+k3jZk18vAU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kwd1aCO9cPP1mnFO3w5f3WROGlidYDvllxWSbeRbDtZ5w2VdD4ISMyEdsxDTVW3k0fKAOPamB+IIcWXsKV1pFM3QijuDcDzrkmXoelduWMAguKIW182RGJxboFFIE+I+Wa+qt8qBGEs7zV2UoRENXiH8IEUnOVqIIWtG91hbk2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LvKE1LsV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LvKE1LsV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1D31C2BD10;
	Mon,  3 Jun 2024 13:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717420433;
	bh=Ak7QswN+LOkA/aRcDFg7VninzqLBDkjs+k3jZk18vAU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LvKE1LsVQLzH9VYot3Cf9M20HR8x6b+LJuCaA0mL7rwygGTykpzm+JfHIf+TDpUGf
	 nzve0iO/eoAmAhXONzXSB0OFes1nqSPCwfC8JtSPNX30IvjJye+/dk7YPTtxNaX06n
	 oTOP9ZI4hb9A7qMYKeDhNZLmdxRW8QKUF539E4zRAJ4Jpbi81TA6WNkGa25VI8GJBK
	 oX00aYnKvIHy+YYW5nRwe1Gw+33dlVvS+BZNxpSQRuIzgw5P65AYufTPuIBRy11+Dy
	 5aSqvVI+Co+rmASonNX7pZTVR/h2fOe3wnE63RC0KYXQDELM6481/Zfrr4lELrbj7c
	 Zbv6axXvvHZAw==
Date: Mon, 3 Jun 2024 14:13:46 +0100
From: Will Deacon <will@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, zokeefe@google.com, xiehuan09@gmail.com,
	wangkefeng.wang@huawei.com, songmuchun@bytedance.com,
	shy828301@gmail.com, ryan.roberts@arm.com, peterx@redhat.com,
	minchan@kernel.org, mhocko@suse.com, ioworker0@gmail.com,
	fengwei.yin@intel.com, david@redhat.com, chrisl@kernel.org,
	catalin.marinas@arm.com, baolin.wang@linux.alibaba.com,
	21cnbao@gmail.com, v-songbaohua@oppo.com
Subject: Re: +
 mm-arm64-fix-the-out-of-bounds-issue-in-contpte_clear_young_dirty_ptes.patch
 added to mm-hotfixes-unstable branch
Message-ID: <20240603131346.GC18991@willie-the-truck>
References: <20240524191054.60D9CC2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240524191054.60D9CC2BBFC@smtp.kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

Hi Andrew,

On Fri, May 24, 2024 at 12:10:53PM -0700, Andrew Morton wrote:
> The patch titled
>      Subject: mm: arm64: Fix the out-of-bounds issue in contpte_clear_young_dirty_ptes
> has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
>      mm-arm64-fix-the-out-of-bounds-issue-in-contpte_clear_young_dirty_ptes.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-arm64-fix-the-out-of-bounds-issue-in-contpte_clear_young_dirty_ptes.patch
> 
> This patch will later appear in the mm-hotfixes-unstable branch at
>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days
> 
> ------------------------------------------------------
> From: Barry Song <v-songbaohua@oppo.com>
> Subject: mm: arm64: Fix the out-of-bounds issue in contpte_clear_young_dirty_ptes
> Date: Fri, 24 May 2024 12:54:44 +1200
> 
> We are passing a huge nr to __clear_young_dirty_ptes() right now.  While
> we should pass the number of pages, we are actually passing CONT_PTE_SIZE.
> This is causing lots of crashes of MADV_FREE, panic oops could vary
> everytime.
> 
> Link: https://lkml.kernel.org/r/20240524005444.135417-1-21cnbao@gmail.com
> Fixes: 89e86854fb0a ("mm/arm64: override clear_young_dirty_ptes() batch helper")
> Signed-off-by: Barry Song <v-songbaohua@oppo.com>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Acked-by: Lance Yang <ioworker0@gmail.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Acked-by: Chris Li <chrisl@kernel.org>
> Cc: Barry Song <21cnbao@gmail.com>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Jeff Xie <xiehuan09@gmail.com>
> Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: Muchun Song <songmuchun@bytedance.com>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: Yang Shi <shy828301@gmail.com>
> Cc: Yin Fengwei <fengwei.yin@intel.com>
> Cc: Zach O'Keefe <zokeefe@google.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  arch/arm64/mm/contpte.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

I was hoping that this would land in -rc2 to keep the testing bots at
bay, but it looks like it's still not graduated out of -next.

Did it simply fall by the wayside this time around, or are you waiting
for us to do something on the arm64 side? I can pick it up for -rc3 if
it makes life easier for you. Please let me know.

Cheers,

Will
