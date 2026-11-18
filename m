Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794965557;
	b=mEFxuw4Bb9kX9VnBGd97YfbhGWgk9Bqd4eGpOquPhEM2H2N/V7GNNwfCqWk9XUPx0cbc
	 GFgXP6Sdpr8CiHxthAKzzKsFt4GypUUQo4/fk+u9xIqhtvkV5J8INpTVh8Ex83ew+Ux25
	 8uO/6s2P9Qi/LK59tQSi+DAceD97BCn37HdFmCIhqUIayt3NqkSBfGkZ7mCU0S4gfOsZ/
	 J+WmL6tESc0UtOZi7JDk/t1ruBW4XvQIRj7kNfLcC/5+BWf3It+EZHPPCcldpytItW7Tp
	 T5dGReBRviD43mXrpdS9oMUqzy9i7O0YkPCUbO1uC+U7QlKqRQwrzotb/b53jEcvH/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794965557;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=60eiZsC1vQ0qBVJ9i90dmpYE8S+lEjH9IMSqx80A0ng=;
	b=e27Hv+LNX1AEFKaO4DrQ7o3g2bEbCYmJwt/0P0G0YbNJG5VdsqmtKaXLfBd9QJXnV0kn
	 fOy71yr7o513wGbAI+wgE1kZi62cego80wNmYnAGE+uj7iOlPCZzdbqtYO1xIRWudpJ0W
	 NqbQAgH2ML8dyPtqbcKxtY0+YWBwp1sgdOgvLaOONoumyDeZ1hnqTnBQX9JM1y37eGRkU
	 KWj7mIinOJnqhEA/1grKiPqS2yDDs0MmitzhLlSvJf/5X3qIg6Jr4pyc6GI81Fm/1ArEx
	 eBZciSJi/4c9D/tESG3SB7KiMCr/3SP6eQumHDvM5SiGI2+9ntLj2RCEUnoh2aMhCag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=J+o8YWMj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD7E4606A31C;
	Wed, 18 Nov 2026 01:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=J+o8YWMj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB1581F000C4;
	Wed, 18 Nov 2026 01:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794965557;
	bh=60eiZsC1vQ0qBVJ9i90dmpYE8S+lEjH9IMSqx80A0ng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J+o8YWMjgX9T+5jaNOFnKzda/YbY1BNrE/oTberX3jpMzeB7wh97ZK10rgf3CwYSY
	 zq8mfbmcExTlNGaPUAdcqtmjnW+KVJR/dZpuwoTUH/GAizTqsbJ5pmwDSrNCULxRcJ
	 3ejeOy1vgVYdhIvtqX9U1pC4IRSEVtZrjI2QnNJD5vP+9t/V0MgcmVgC2z4cRDrCjS
	 f5XF/8p4dyvTiyWMKx9wr8jsREZ7FvT4FdC0ipJFFrF/iUn5TZCsahLeC9HttFpdF2
	 nQ4SAofcjof1wqiK4mRA0JHf6ohnn+LhWahQwWRci43iLDHiUygj6j9tIsPsOPevBX
	 J4VNdsXdz4+WA==
From: SJ Park <sj@kernel.org>
To: Aveline Noir <jm5905938@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	David Hildenbrand <david@kernel.org>,
	Justin Stitt <justinstitt@google.com>,
	lienze@kylinos.cn,
	linux-kernel@vger.kernel.org,
	Linux Memory Management List <linux-mm@kvack.org>,
	kernel test robot <lkp@intel.com>,
	llvm@lists.linux.dev,
	mm-commits@vger.kernel.org,
	Bill Wendling <morbo@google.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	oe-kbuild-all@lists.linux.dev,
	rdunlap@infradead.org,
	sashiko-bot@kernel.org,
	sashiko-reviews@lists.linux.dev
Subject: Re: [PATCH] mm/damon/paddr: avoid truncation warning in high-address KUnit test
Date: Tue, 17 Nov 2026 17:32:28 -0800
Message-ID: <20261118013229.94629-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261118-fix-damon-paddr-sparse-20261118-v1-1-3a0e943406d5@gmail.com>
References: 
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Aveline,

On Wed, 18 Nov 2026 04:04:33 +1100 Aveline Noir <jm5905938@gmail.com> wrote:

> Hi SJ, Andrew,
> 
> The kernel test robot caught this issue in my earlier addr_unit KUnit
> patch. Feel free to fold this fix into that patch.

I will ping Andrew again on Thursday, if Andrew doesn't add this fixup to
mm.git by the time.


Thanks,
SJ

[...]
