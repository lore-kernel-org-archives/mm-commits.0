Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795844941;
	b=cdQqSzwHb8i+iJXlJP8DGmT4TbeBCnWZuJghRWhzylnlT37H+wlinoKrb2XANvno21ji
	 Ih8ctDqhNuc1e9IX3zVxlz8TCd5DOa4mJRAe9hlFCIH+g1B3Vwe1NxtizAD5cMaNBIYS9
	 6qHmQurjdn5PT6H8ZXhzvldoJUVD1TvCug/GSPeKZGf7BAMCKBEVrE/o/YnfCQwIfUqBI
	 zpTazqdalMP4aMMwzMn8cm6pP1mzQLI87FO4Sw6/Xc5EOUc6zT2l0bAVuwXIqT6ekHi/a
	 JesKnQ1FEl1A3opHX/BYJ3jAu7In6PTMr3NLDHs62cWrOcZRn871KPLUxP4n54F2pvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795844941;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-Id:
	 In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=gYeJofYi9liYn6S4qO14pY4ChJw65r1Z1mgpE4pXETY=;
	b=frRs2K/Faynr+Al8JKbdBpg1n9XWDTvXL59FLvzG3qY5fpN2T+pDpkv+NwlzFKqoR8+2
	 5NREtgw1MwCXvXhIaHFqkuM10G4bN+brlVxV3zVuTVDbIwT3fFwnxSFlLv4u7bgiJ4MPo
	 kM2P7k/iPlzoZz82KVzR54P7tLdWzy4mWqHw3opERtBmyCHdyz2vLVCvObim/obpPGbWr
	 d4DmIECb7F+cvnhQ9ZGaUWGPCIFQ49iVOKrAi039cqTHiJFJU4+N/ZnirY1111RftOxBs
	 lwkj91NwE6QmtTVjo3mwWk6QyyH19CV3WQZVs8l4iYf/RH5TFzzweokiFwDo6dmLKbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=JktTvMfS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD8CC606A31C;
	Sat, 28 Nov 2026 05:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=JktTvMfS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 038A71F00893;
	Sat, 28 Nov 2026 05:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795844940;
	bh=gYeJofYi9liYn6S4qO14pY4ChJw65r1Z1mgpE4pXETY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=JktTvMfS19fCnaznrdzb45dOpH8joUVYkIfnfNGRYCdYxm0Bxwyb85eLPLLYeZmk+
	 zyKu1DHM1vTN7kgGZOdUOgUfSXxoOnvt9OrJtwrm2QZ2GCRaSGn5mHngdMHk7RzXwZ
	 sIhENi3nRl9jpBRbRql3a1BC6vMAqLskpNA4teUU=
Date: Fri, 27 Nov 2026 21:48:59 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <lkp@intel.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, llvm@lists.linux.dev,
 oe-kbuild-all@lists.linux.dev, Linux Memory Management List
 <linux-mm@kvack.org>, mm-commits@vger.kernel.org
Subject: Re: [akpm-mm:mm-unstable 303/428] mm/huge_memory.c:2546:67: error:
 too few arguments to function call, expected 4, have 3
Message-Id: <20261127214859.8f11ddcd5575f062253cd681@linux-foundation.org>
In-Reply-To: <20261128060622.OMTGOfau-lkp@intel.com>
References: <20261128060622.OMTGOfau-lkp@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 28 Nov 2026 06:11:18 +0100 kernel test robot <lkp@intel.com> wrote:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
> head:   ac6a52aad42728ef45e6972c403072fba5c524f4
> commit: 5a7c0c5e349b6b13c1689fedd1a82073b4679418 [303/428] mm/hugetlb: delay anon folio rmap removal until after the TLB flush
> config: x86_64-kexec (https://download.01.org/0day-ci/archive/20261128/20261128060622.OMTGOfau-lkp@intel.com/config)
> compiler: clang version 22.1.8 (https://github.com/llvm/llvm-project ca7933e47d3a3451d81e72ac174dcb5aa28b59d1)
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261128/20261128060622.OMTGOfau-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/20261128060622.OMTGOfau-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
> >> mm/huge_memory.c:2546:67: error: too few arguments to function call, expected 4, have 3
>     2546 |         else if (__tlb_remove_page_size(tlb, &folio->page, HPAGE_PMD_SIZE))
>          |                  ~~~~~~~~~~~~~~~~~~~~~~                                  ^
>    include/asm-generic/tlb.h:248:6: note: '__tlb_remove_page_size' declared here
>      248 | bool __tlb_remove_page_size(struct mmu_gather *tlb, struct page *page,
>          |      ^                      ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>      249 |                 int page_size, bool delay_rmap);
>          |                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Thanks.  I've fixed all that up so perhaps there's some timing skew
happening here.

