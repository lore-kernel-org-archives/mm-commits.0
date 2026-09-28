Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14D402F8E93
	for <mm-commits@vger.kernel.org>; Mon, 28 Sep 2026 04:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790570568; cv=none; b=e3d23sQq2pjYiSALHO+cEHbUpV5Zriykmv6G20giXBRw8VizbhFwwpPfMA5CqrhK0YEuQxCMT+9sVmUm5UtFDF8VoG0yGCU+abkbLYW/s+QiP6F5FSCw/8v/c7YMgQs6IJ4LuHnQk7GrfWAt4rr5hAv4F5O1u9BlcX8qFkyS6rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790570568; c=relaxed/simple;
	bh=g9+BM8LQstyMyJtvF3kyKscq7+5czkGZL/4m6fk+efo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WxJtun7Y/iMsQdaHtqkgEZT+Kf+IvX+OJo1aOhyGDNytXt5dixNL2GkEjAPLupgfNfdnd/P5quk9AFVwLIlZxPVQq4toulMcyPulXqc1uhofiCV2peDgJ4IlNBi5hdu1Fh50SmDO4t+C9q+Q/limK0BhENY2LPOucghB/IWaEg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=bKrEwt2b; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="bKrEwt2b"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3B62D1595;
	Sun, 27 Sep 2026 21:42:36 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E5F973F85F;
	Sun, 27 Sep 2026 21:42:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790570559; bh=g9+BM8LQstyMyJtvF3kyKscq7+5czkGZL/4m6fk+efo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bKrEwt2bC/ZQWJUMqIbP/vuS1K0gagIxbK5QMww2e+iM4X8cIC/KbLm1H+8DoVNY9
	 URi8HP8oh6BmQp553mLeKba4VYQrdZDfLFLzocjOav/O1EFyxeVVivmwCJ0iPtKlXX
	 i5a9pmIFqdzNhYDXPlY63UsQvBcs0j0/tnvCuMnk=
Date: Mon, 28 Sep 2026 10:12:36 +0530
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kernel test robot <lkp@intel.com>, oe-kbuild-all@lists.linux.dev, 
	David Hildenbrand <david@kernel.org>, Linux Memory Management List <linux-mm@kvack.org>, 
	mm-commits@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [akpm-mm:mm-new 661/679] mmu.c:undefined reference to
 `__check_safe_pte_update'
Message-ID: <bao3loem52ww7aplteu4ialsb2umep6mynhofp3loamdewytxc@pexxabh7vdf4>
References: <202609270030.Y0QVBPmK-lkp@intel.com>
 <20260927133100.46a4f7067c79280dcf83731b@linux-foundation.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260927133100.46a4f7067c79280dcf83731b@linux-foundation.org>

On Sun, Sep 27, 2026 at 01:31:00PM -0700, Andrew Morton wrote:
> On Sun, 27 Sep 2026 00:32:54 +0800 kernel test robot <lkp@intel.com> wrote:
> 
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> > head:   b4fc90c82982d98959af08b4320420bcfc01303b
> > commit: 2862bcaf1aca55e0b43a5692a4595281ab780f05 [661/679] arm64/mm: move __check_safe_pte_update()
> > config: arm64-randconfig-1002-20260926 (https://download.01.org/0day-ci/archive/20260927/202609270030.Y0QVBPmK-lkp@intel.com/config)
> > compiler: aarch64-linux-gcc (GCC) 8.5.0
> 
> Thanks.  It works for me, but I'm using gcc-15.2.0.

Tried building this series with a cross compiler (gcc 14.3.1) and a native
compiler (15.2.0). The series builds successfully in both cases.

- Anshuman

> 
> > reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260927/202609270030.Y0QVBPmK-lkp@intel.com/reproduce)
> > 
> > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Closes: https://lore.kernel.org/oe-kbuild-all/202609270030.Y0QVBPmK-lkp@intel.com/
> > 
> > All errors (new ones prefixed by >>):
> > 
> > >> aarch64-linux-ld: Unexpected GOT/PLT entries detected!
> > >> aarch64-linux-ld: Unexpected run-time procedure linkages detected!
> >    aarch64-linux-ld: arch/arm64/mm/mmu.o: in function `__set_ptes_anysz.isra.40.constprop.47':
> > >> mmu.c:(.text+0x9a8): undefined reference to `__check_safe_pte_update'
> >    aarch64-linux-ld: arch/arm64/mm/hugetlbpage.o: in function `__set_ptes_anysz.isra.32':
> > >> hugetlbpage.c:(.text+0x1a8): undefined reference to `__check_safe_pte_update'
> >    aarch64-linux-ld: kernel/bpf/arena.o: in function `apply_range_set_cb':
> > >> arena.c:(.text+0x11fc): undefined reference to `__check_safe_pte_update'
> >    aarch64-linux-ld: mm/gup.o: in function `follow_page_pte':
> > >> gup.c:(.text+0x2b48): undefined reference to `__check_safe_pte_update'
> >    aarch64-linux-ld: mm/memory.o: in function `__set_ptes.isra.207':
> > >> memory.c:(.text+0x3418): undefined reference to `__check_safe_pte_update'
> >    aarch64-linux-ld: mm/mprotect.o:mprotect.c:(.text+0x1080): more undefined references to `__check_safe_pte_update' follow
> > 
> 
