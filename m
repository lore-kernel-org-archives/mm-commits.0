Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E2F03B27FB;
	Mon, 27 Apr 2026 14:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777301711; cv=none; b=MzmFsQdUNcQk7uEJzqh5P3ucA+r2A4AkJVnWINA44vhg5cMRWoFMXrvUrStnbcbGBy7orIAmcCp90+LvYTzZTBdmcjUQFBMf2yiFQwwnkNqOav4xt1beZJsWqMjeB6OvS4hF3oauySmhrL2Np80JN5uzWXt4KP/xfqPczTsYqgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777301711; c=relaxed/simple;
	bh=4fuQfK0U3MCtLpCaqNDn3ZYnCmYAsN25PDsyXgxtvfM=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=OoHi9IhAWc6UgxGhhmgVcFZpSvNp8DWGxjGLML0wtmQ3hwdAGBJfTviuIkLXaJueXFTyhv3RFU2LmdOSWCqFvgNGCf1KiMtKyQwo4BLHIhizmRnsJveV1wIH9KL0+jIs/Ylagdg82dyNu+mXaz3gu9/CWmu6/wc446w3yWXb7pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=v19bN0oa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="v19bN0oa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E3C2C19425;
	Mon, 27 Apr 2026 14:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777301710;
	bh=4fuQfK0U3MCtLpCaqNDn3ZYnCmYAsN25PDsyXgxtvfM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=v19bN0oao0FGtM0DaQMaeWM4xHGqaVBcVrB4U4tQxwlnqKjCjaxELNE14NBxwYH9D
	 At4/U96J4/daE4Wwk7pKQ+2PXcI5iGgh0LcSPbv6RTIxaD07I6rr47xv3R5ftzzy9q
	 ga50uMqOlVHIesyKg6QL0lSHxe9wrQYBeBVk0yn0=
Date: Mon, 27 Apr 2026 07:55:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <lkp@intel.com>
Cc: <oe-kbuild-all@lists.linux.dev>, David Hildenbrand <david@kernel.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 <mm-commits@vger.kernel.org>, Davidlohr Bueso <dave@stgolabs.net>
Subject: Re: [akpm-mm:mm-new 117/130] ./include/asm-generic/fixmap.h:77:9:
 error: implicit declaration of function '__set_fixmap'; did you mean
 'set_fixmap'?
Message-Id: <20260427075510.bbac70576250c2af5e76bbcc@linux-foundation.org>
In-Reply-To: <ae92kz3LeyaFBvKw@rli9-mobl>
References: <ae92kz3LeyaFBvKw@rli9-mobl>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 27 Apr 2026 22:45:39 +0800 kernel test robot <lkp@intel.com> wrote:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> head:   4f7b2cc1ad8719d55a8de9675a0aca65cb17c364
> commit: 93580c23bb3da5dd2926d6ae991ef04c2cdacaf2 [117/130] include/asm-generic/fixmap.h: reimplement nasty macros in C
> config: powerpc64-allnoconfig-bpf (https://download.01.org/0day-ci/archive/20260427/202604271114.ebmzs1LE-lkp@intel.com/config)
> compiler: powerpc64-linux-gnu-gcc (Debian 14.2.0-19) 14.2.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260427/202604271114.ebmzs1LE-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/r/202604271114.ebmzs1LE-lkp@intel.com/
> 
> All error/warnings (new ones prefixed by >>):
> 
>    In file included from ./arch/powerpc/include/asm/fixmap.h:91,
>                     from mm/early_ioremap.c:18:
>    ./include/asm-generic/fixmap.h: In function '__set_fixmap_offset':
> >> ./include/asm-generic/fixmap.h:77:9: error: implicit declaration of function '__set_fixmap'; did you mean 'set_fixmap'? [-Wimplicit-function-declaration]
>       77 |         __set_fixmap(idx, phys, flags);
>          |         ^~~~~~~~~~~~
>          |         set_fixmap
>    ./arch/powerpc/include/asm/fixmap.h: At top level:
> >> ./arch/powerpc/include/asm/fixmap.h:93:20: warning: conflicting types for '__set_fixmap'; have 'void(enum fixed_addresses,  phys_addr_t,  pgprot_t)' {aka 'void(enum fixed_addresses,  long long unsigned int,  pgprot_t)'}
>       93 | static inline void __set_fixmap(enum fixed_addresses idx,
>          |                    ^~~~~~~~~~~~

Sigh, thanks, of course one architecture had to go and be weird.

hacky fix:

--- a/arch/powerpc/include/asm/fixmap.h~include-asm-generic-fixmaph-reimplement-nasty-macros-in-c-fix-fix
+++ a/arch/powerpc/include/asm/fixmap.h
@@ -88,6 +88,9 @@ enum fixed_addresses {
 #define FIXMAP_PAGE_NOCACHE PAGE_KERNEL_NCG
 #define FIXMAP_PAGE_IO	PAGE_KERNEL_NCG
 
+static inline void __set_fixmap(enum fixed_addresses idx,
+				phys_addr_t phys, pgprot_t flags);
+
 #include <asm-generic/fixmap.h>
 
 static inline void __set_fixmap(enum fixed_addresses idx,
_

