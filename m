Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794032493;
	b=A6iDd2h4qDhJRKxD/VPsTbETAFcCSmlB/bNhp2jXnlVSWEin/992kOF0MIpwk7RthHqo
	 5/330SIbWqvBQqFLKgCL/vgaYUsMIjWiqBjmQndXOBIaEWHIgfW3ifTc+ZnKX9DTs80Kk
	 nhuHkpP0HCzb3rtQXglIjxV+cvXpyuNjajet6zmnB/cFOhnEhTdC6q7qaL0zxc23CIgk0
	 9BZcVaGTnA/ige5eIPfsmnEiYVCaFn/3iS9EU7Z4yqhrFxTmG8Jo16c34G6vfbvrT6eKK
	 JZ9I30o8RNttPEqYDpfyg4mZaghyliehqQQHaCHBnrSGSrGJ5A23YJO2WO4ptmMD4mw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794032493;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-Id:
	 In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=Rue7DrFJizzJaq9mJMBOWdT76HmG+xTQGYkTLJeaIcw=;
	b=UEZIOwh+toHG/FvIfTPeIW3jo0coDbVFz4UBe4/jeqWi3y8dXnUKS+DH1rriLxt33ic6
	 vQcDK11Sgs/G0qb7mxrM+ZMUar42964neaZ8HFxmuCO0op6rsyg4WDQ//XevVw257L2QN
	 QbxAEbDKuPLINyJpEcNeKq7q2Cj4gq4pp8ix1DhcHQBtHdcKu/1e8jdbayQ0Ils3WxxBb
	 0tmK1bhkGcRlhSccRT+qflbxQN5PgfYdzyx3n4POoZBeAInPto8DSehmbdBAOfvgkjwKf
	 CRuGZce6fOptbb3loGeoMsTkSOWwGMmZp6e29/O7vSPEwBMehoUScmQOOhJn0gbBVQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=f3kI8JMu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C92D6606A326;
	Sat,  7 Nov 2026 06:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=f3kI8JMu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F02801F0089F;
	Sat,  7 Nov 2026 06:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794032492;
	bh=Rue7DrFJizzJaq9mJMBOWdT76HmG+xTQGYkTLJeaIcw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=f3kI8JMuI2gAX6UrdrGzy9z6n4NuTB0jebBgdw93BDOJewkqBm84gwaRIeWmJ18hn
	 50WNn42R0DMvWJVVi2AZq4qwJGfr2oX+ajjqf+xsmkg6kJz23gcQYXe/ySEC9qpW3R
	 0l6mS0KpLjx6LhNIaYE8b+zghg132qOtdni6G/D4=
Date: Fri, 6 Nov 2026 22:21:31 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <lkp@intel.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, David Hildenbrand
 <david@kernel.org>, Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org, Abhishek Bapat <abhishekbapat@google.com>
Subject: Re: [akpm-mm:mm-unstable 225/232] include/linux/alloc_tag.h:159:24:
 error: duplicate 'inline' declaration specifier
Message-Id: <20261106222131.6fdd74ac14178fbe4470e33d@linux-foundation.org>
In-Reply-To: <202611071330.7rHbLZ6C-lkp@intel.com>
References: <202611071330.7rHbLZ6C-lkp@intel.com>
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

On Sat, 07 Nov 2026 14:10:12 +0800 kernel test robot <lkp@intel.com> wrote:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
> head:   a3d27154a205f6b32000e7e2734b2a6a4d22c65b
> commit: cb335644ac2611749ab17d3eb6f29c8f77450fa6 [225/232] alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints-fix-fix
> config: hexagon-allmodconfig (https://download.01.org/0day-ci/archive/20261107/202611071330.7rHbLZ6C-lkp@intel.com/config)
> compiler: clang version 24.0.0git (https://github.com/llvm/llvm-project fc9576e3b179738d99c5babe5cd9d6c1f883e0db)
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261107/202611071330.7rHbLZ6C-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202611071330.7rHbLZ6C-lkp@intel.com/
> 
> All error/warnings (new ones prefixed by >>):
> 
>    In file included from arch/hexagon/kernel/asm-offsets.c:13:
>    In file included from include/linux/compat.h:14:
>    In file included from include/linux/sem.h:5:
>    In file included from include/uapi/linux/sem.h:5:
>    In file included from include/linux/ipc.h:7:
>    In file included from include/linux/rhashtable-types.h:12:
> >> include/linux/alloc_tag.h:159:24: warning: duplicate 'inline' declaration specifier [-Wduplicate-decl-specifier]
>      159 | static __always_inline inline bool alloc_tag_is_traced(const struct alloc_tag *tag)

bah, thanks, fixed and pushed.
