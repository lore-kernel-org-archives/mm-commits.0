Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E21853ED5AC
	for <mm-commits@vger.kernel.org>; Mon, 27 Jul 2026 09:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785144350; cv=none; b=QG+3YB104SqqIzLprRhN2gagCmoyz2oWlsVao+lu+RcBTMV2nYhp/svK1mfExIZN65mKutMWXx3GOQN/hBaovfvE8g7VqZQVI6xfNTD934n7Yvh4u05+XOXRVs/CSBFDIuA0VhqHkvH+wtx+XtYr2xKuC1JPItusv1ttNe70a/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785144350; c=relaxed/simple;
	bh=fXcHZndGpDuRPAU/M0K/xrc8q4z5CwSiEM6/Dma01TY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bfG8LvB8Z9a7xnPdFVRAdOpd3eEShvYIr7LwS723gKLQJlDiEuLKGEhoOiZ7ldFKcGxKfMm1uTMCub09RxdUkC2xUP32t8bfb1YXZRyZCXMyVdaMGQXN7OTJn22UwEbd1i0Q+P2ioHHIxB1pkRb1U2ueOasbZhNstv0kAX528No=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a7xMnQRN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a7xMnQRN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D7DD1F00A3A;
	Mon, 27 Jul 2026 09:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785144345;
	bh=ZeOjwA9t/b3Je6sX4+S34MGC+EZsj/Dlu+d1YmsigK0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=a7xMnQRNYEjbJw6KtqPchvYngvNf1Pq+80yK44ek3q6dMBlnVTUMfEAk2UlbqQqcL
	 0LwDDPxGbxE4DXPia/2e0uQMj4tgZO8o9VtgjKYDpagu3gFKElCuP/RlvJjzDoViHb
	 5BxDkTfxMxaQfCgc1YplUlaMG8CXW6C2nahYaQvZMOvhqjB12Ndj7lE6kiC1pEHVJT
	 R8lW1dq94SxIUW2WRIVZSVw88qVuhleHLy2Ar1qdprqVataBG+r02CjRqq77YHy+Kj
	 2qlKUkdHz+eOJcaFMKCgQkbAmhdSBl9+7tYrqevWpuOwi/im3xTdLzxX8dIEnUwbrd
	 2f3DjM7x3iheQ==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.phl.internal (Postfix) with ESMTP id 541EFF40071;
	Mon, 27 Jul 2026 05:25:44 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Mon, 27 Jul 2026 05:25:44 -0400
X-ME-Sender: <xms:GCRnapGpc8G8xDRocQsk1V4NnQxQLcLPYcf2OiQ3D23_R2pKR0WB1Q>
    <xme:GCRnakv3raqEs8kjfcEwegfIIQti1zpVtkK7VNyJwbYX_YQX-Inm1hEeaqpz0WLaA
    2WZx-r-BB91NYRhxFded897CJ1Ex3t7Y9UV0aYHUMsshhMM7_-1Dl0>
X-ME-Received: <xmr:GCRnanbOU3goIgvfrUSMn91hz3Tgz7IjKbfG26Jg2KjrNibIlkJZDc_rHZsamQ>
X-ME-Proxy-Cause: dmFkZTFpz/2JwI3MEXG1r/8nVb0TskSPs5i5gwuz69w9zqKCiMODWqD60GWIWd5xHt/GZz
    bEbmj/+Nb4XsL7rjWvsbd9bBkjopeMZJ7iCxp/cJrc+IFwkUZga/gpEn29PO0vp6MEmCwl
    ySzOJSwLInVs3aLv0ytRjnlnSKgHSwjomHDpYveKe3nTS+vLW0t27dd2KRGUs60uBYfZ3l
    6aJ/GBJEiQqNr/IAa8VlUbTZuY15ia5GNA1tylLuM0utfROe0pUUFNs6zhwRgRloHEAPve
    BPEiJ2KMYZMiKNLOFf0xUrk0Jg62fbtDDFJMFsSnPJWyG/hK8ru3JrO9ek79XqD+q6SdX3
    oDfnzh/sD/fYbG+CEVxajND+2TNiYEJVnYivTVv/I25ZTAXb8KF+9Y8X5k3FUAjQcu8D3l
    hZjHLrxGiN1pAQc22AROxH5Kyi2Wf56D3P/cGZ0HeRN3lkG976U7RaKqk+RmCNCCM5NeLG
    BDV3BA8RhBkRKe2mSzwRJB5v43Fie+LvJdK3ckZMz2524HnG9woiyRx8IS3VB6hgGk+BAE
    zwqa9YEfIcckuiOQ6XsXPJnRah+AhH/FabWzaraqSMHyqphdLfc3FYckX+j2YwG+iVg9UM
    rW3RMh4rMl16gvYCWbXS6CEf5EOQ9vIb9LWQ/i/7calq9lPxIFihCXNjqixg
X-ME-Proxy: <xmx:GCRnas6LYpUbLUlyP6VW-DyPxZcUDih5fQYS6UtiEaK4Fh6TH4MU1Q>
    <xmx:GCRnan-lYkMIlObNIiPFUK2JXtMlTthajeu8LjGiQTGg0qOXLiwY6A>
    <xmx:GCRnagbdbhLPMvj-n7xHdPveFxNzSUFDjVoN3D4cta9xEvAR2ui9tg>
    <xmx:GCRnao5iPePR4OZ8C-R-ozBenHeVqFkmJk684yuGlZSS9H3HYu46Qw>
    <xmx:GCRnatl9XITxj_x5Ff4qP1m4b73vz80sg-nYZSI3FQgdFT6LZ9RALAuq>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 27 Jul 2026 05:25:43 -0400 (EDT)
Date: Mon, 27 Jul 2026 10:25:42 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kernel test robot <lkp@intel.com>, oe-kbuild-all@lists.linux.dev, 
	David Hildenbrand <david@kernel.org>, Linux Memory Management List <linux-mm@kvack.org>, 
	mm-commits@vger.kernel.org
Subject: Re: [akpm-mm:mm-unstable 340/601]
 include/linux/compiler_types.h:702:38: error: call to
 '__compiletime_assert_501' declared with attribute error: BUILD_BUG failed
Message-ID: <amcitKvUvFYr8W38@thinkstation>
References: <202607250853.VaJWGLeA-lkp@intel.com>
 <20260725195108.3f31c2641b0689d344e55400@linux-foundation.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260725195108.3f31c2641b0689d344e55400@linux-foundation.org>

On Sat, Jul 25, 2026 at 07:51:08PM -0700, Andrew Morton wrote:
> On Sat, 25 Jul 2026 08:56:41 +0800 kernel test robot <lkp@intel.com> wrote:
> 
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
> > head:   c04df384b55dd9dcf72c36b661becb5aaba371a9
> > commit: d2aed7c02fafacb9d055a2f683ac12e977ef16e0 [340/601] mm: preserve RWP marker across PTE rewrites
> > config: sparc64-randconfig-r134-20260725 (https://download.01.org/0day-ci/archive/20260725/202607250853.VaJWGLeA-lkp@intel.com/config)
> > compiler: sparc64-linux-gcc (GCC) 8.5.0
> > sparse: v0.6.5-rc1
> > reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260725/202607250853.VaJWGLeA-lkp@intel.com/reproduce)
> > 
> > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Closes: https://lore.kernel.org/oe-kbuild-all/202607250853.VaJWGLeA-lkp@intel.com/
> > 
> > All errors (new ones prefixed by >>):
> > 
> >    In file included from <command-line>:
> >    mm/huge_memory.c: In function 'move_pages_huge_pmd':
> > >> include/linux/compiler_types.h:702:38: error: call to '__compiletime_assert_501' declared with attribute error: BUILD_BUG failed
> >      _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
> >                                          ^
> >    include/linux/compiler_types.h:683:4: note: in definition of macro '__compiletime_assert'
> >        prefix ## suffix();    \
> 
> Well dang.
> 
> I can't reproduce with sparc64 gcc-15.2.0. 
> Documentation/process/changes.rst says we support 8,1, released in
> 2018.  Your 8.5 was released in 2021 so perhaps three other people are
> still using it :(
> 
> https://www.kernel.org/pub/tools/crosstool/ doesn't appear to have
> sparc64 gcc-8.5 so I gave up.
> 
> So I dunno.  I'm inclined to ignore and assume that if someone else hits
> this one day, they'll either fix it or provide us with enough details
> to figure it out.

I cannot reproduce it either. Maybe we can help compiler to derive that the
code is dead?

-- >8 --
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Date: Mon, 27 Jul 2026 10:16:11 +0100
Subject: [PATCH] mm: fold userfaultfd_rwp() to false without
 CONFIG_ARCH_HAS_PTE_PROTNONE

RWP tracks accesses by installing PAGE_NONE (protnone) PTEs, so its code
paths are gated on userfaultfd_rwp(). Without CONFIG_ARCH_HAS_PTE_PROTNONE
there is no PAGE_NONE -- <linux/pgtable.h> defines it to a BUILD_BUG()
stub, relying on callers folding such paths to dead code via
IS_ENABLED(CONFIG_ARCH_HAS_PTE_PROTNONE).

userfaultfd_rwp() was not a compile-time constant, so the compiler could
not fold those paths. With an older compiler (gcc 8.5.0, sparc64) the
PAGE_NONE reference in move_pages_huge_pmd() survived to codegen:

  mm/huge_memory.c:2874: _dst_pmd = pmd_modify(_dst_pmd, PAGE_NONE);
  compiler_types.h:702: error: call to '__compiletime_assert_501'
    declared with attribute error: BUILD_BUG failed

RWP cannot exist without protnone, so return a compile-time false when
CONFIG_ARCH_HAS_PTE_PROTNONE is unset; every RWP path then folds away.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 include/linux/userfaultfd_k.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
index bfbd6a59909f..0ce438ec294f 100644
--- a/include/linux/userfaultfd_k.h
+++ b/include/linux/userfaultfd_k.h
@@ -221,6 +221,12 @@ static inline bool userfaultfd_minor(struct vm_area_struct *vma)
 
 static inline bool userfaultfd_rwp(struct vm_area_struct *vma)
 {
+	/*
+	 * Callers gate PAGE_NONE usage on this; PAGE_NONE is a BUILD_BUG()
+	 * without CONFIG_ARCH_HAS_PTE_PROTNONE, so fold to false.
+	 */
+	if (!IS_ENABLED(CONFIG_ARCH_HAS_PTE_PROTNONE))
+		return false;
 	return vma_test_single_mask(vma, VMA_UFFD_RWP);
 }
 

base-commit: 505f6bc5c6c6db7d6390ea33c4e2ab44379e6f49
-- 
  Kiryl Shutsemau / Kirill A. Shutemov
