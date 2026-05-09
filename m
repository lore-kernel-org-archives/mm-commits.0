Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB0E11E9B37;
	Sat,  9 May 2026 16:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778343744; cv=none; b=EM3EM2a6+QmraK8AVudTcvhQRWf2Ax3IThueCni7dJOYOnuFpem15A4ugu07d8QPItukvVhwXe4USXxpttrk9MGWSjtI2DKTs8OjFYmBZ4aQX1CSAD6+LcUoOPq6x1Hlal+MUI6xmJLe/qrn2B2SKG3MHfghCl/HShzfJghMKAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778343744; c=relaxed/simple;
	bh=q+bBnUic3jJEdxGsCmvC4w3BR+OKv2m8On+Qe3HOB2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RwY6TFeWhuHqWNAxQTvnfU0K56IFXY4+yIyF/pGLIlmM8viBtP9Bfu9WPx9jFInljJL38J11NOzDvQu4xJxaPvNQ83nL+VyLj31WfIixkVKsGJxQ/G8Z5CsJN57IJNDLNdIj3SytMbfaDyfA2rCbFlwvf2W4yrlbmk4kpTyLfdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EoqRzVoP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EoqRzVoP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50F7FC2BCB2;
	Sat,  9 May 2026 16:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778343744;
	bh=q+bBnUic3jJEdxGsCmvC4w3BR+OKv2m8On+Qe3HOB2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EoqRzVoPlrwY3Nev52tdMLwdD+AXArV8TgWwFCzDQcEecTZZe3pkuipRM6vRVG+tq
	 DZVXwLgpxLSH1ZYQOXNDtpBhXx3bQsxyAjeIZ8BYjqyt965SwIjphmEpkj+/cpuTU1
	 ujUIKHDTQC+M087iAcdOgDqmlnCOmNI1DnePcCxmGUOa2P2VQnQyW1d1R+7nA9HwOT
	 cCe/wx4N9CJW0NzVDG8ual/d+FHPGcOr9rgWdbAZbRGSoi4uNX6oVQT83T1WkNyNh+
	 E0cquw3bDTSnS62hyuCHmpUQ50cDHFy5dvHDvPZbExw5LzVCRK3Q5eBY+xG8jAlUdR
	 mZ+IW64+Vrkdw==
From: SeongJae Park <sj@kernel.org>
To: kernel test robot <lkp@intel.com>
Cc: SeongJae Park <sj@kernel.org>,
	Jiayuan Chen <jiayuan.chen@shopee.com>,
	oe-kbuild-all@lists.linux.dev,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	mm-commits@vger.kernel.org,
	damon@lists.linux.dev
Subject: Re: [akpm-mm:mm-new 222/223] include/linux/damon.h:869 damon_rand() warn: always true condition '(span <= (~0)) => (0-u32max <= u32max)'
Date: Sat,  9 May 2026 09:22:01 -0700
Message-ID: <20260509162202.114645-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <202605092036.9mdDJbEZ-lkp@intel.com>
References: 
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sat, 09 May 2026 20:44:33 +0800 kernel test robot <lkp@intel.com> wrote:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> head:   7505bb13a9bb1f214310915ccc06643119fdafc9
> commit: 8b7c38eb9621c71d288eca45c8dd4dc92357dc07 [222/223] mm/damon: replace damon_rand() with a per-ctx lockless PRNG
> config: riscv-randconfig-r071-20260509 (https://download.01.org/0day-ci/archive/20260509/202605092036.9mdDJbEZ-lkp@intel.com/config)
> compiler: riscv32-linux-gcc (GCC) 8.5.0
> smatch: v0.5.0-9065-ge9cc34fd
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202605092036.9mdDJbEZ-lkp@intel.com/
> 
> smatch warnings:
> include/linux/damon.h:869 damon_rand() warn: always true condition '(span <= (~0)) => (0-u32max <= u32max)'
> 
> vim +869 include/linux/damon.h
> 
>    861	
>    862	/* Get a random number in [@l, @r) using @ctx's lockless PRNG. */
>    863	static inline unsigned long damon_rand(struct damon_ctx *ctx,
>    864					       unsigned long l, unsigned long r)
>    865	{
>    866		unsigned long span = r - l;
>    867		u64 rnd;
>    868	
>  > 869		if (span <= U32_MAX) {
>    870			rnd = prandom_u32_state(&ctx->rnd_state);
>    871			return l + (unsigned long)((rnd * span) >> 32);
>    872		}
>    873		rnd = ((u64)prandom_u32_state(&ctx->rnd_state) << 32) |
>    874		      prandom_u32_state(&ctx->rnd_state);
>    875		return l + mul_u64_u64_shr(rnd, span, 64);
>    876	}
>    877	

The check is for 64bit systems.  I think this warning is ok to be ignored.
Please let me know if I'm missing something.


Thanks,
SJ

[...]
