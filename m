Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793934360;
	b=0cwr5B4Ntvrm1NOnNwQHLNdlDVnccwkRhVAdes6BGBbfi+9GF3fSahfMQgUlHPRKzap7
	 YtQhjsJWX+2yE1uwkEBAzVHSy5niS57RdNL3iCwuZsB7jOJPE8Yqf9kVf08ok0bqymUHu
	 pQL4n+5Z9FQ6UJIEBDvaDIhEhYiq02fTUe3+P2CXuPb3vFTtD0I8gqxDsloX5DDk07TFd
	 aD5q/oBjKpvy00E2ZWn31nl/SeFtFAf0ZkY2IlFZrhtGo1tsmpS3vlsVt5L01IlXUUngH
	 7sR8lWT3oEMcm6FjGZqCpBd8JhH2vWpW6Jb+Ac3K1K0xRUCeA6AxNGvp/w3rL9hTMOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793934360;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-Id:
	 In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=YZkGjQt427pHZpQ9JbotH8VEMJC0LS31LlX+t4WlA5c=;
	b=RIY6aRn4c5HtC1gia43RT1DdhX4HGjiz3r0xhL5ZqlBcIdumu/AnftQUXbAsVkpw9aVU
	 vBDbfcXCutAwJU3Mth/mEqDHQVIR1N/HUZcEwgqGpE5H/1dqfQWHXM4mfCsD6zFm06anq
	 AipSCYSVjoFYIm7RnGpEM021mex/v7ehahpuRQ7e/7ppwQdpaus3Z32wQSnncF8eLfNO3
	 AzuUMUeBLfOFxUkbLyybe8VlEQusW1rwAIxbcCD+l1Q4C2WpXpZmM46PErL02GfN6gFm5
	 KKg7Uqkg6Xi36NohaJ+fZHvqU6ofXBANqB0f9u6cpkm6tMswtwgrZDbqMmQQfTSZMaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=XutjVlaN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AAE4606A32C
	for <mm-commits@vger.kernel.org>; Fri,  6 Nov 2026 03:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=XutjVlaN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B90C11F008A6;
	Fri,  6 Nov 2026 03:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793934359;
	bh=YZkGjQt427pHZpQ9JbotH8VEMJC0LS31LlX+t4WlA5c=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=XutjVlaNn6zbWPzBchJpHcdLyBIU7b+pScmD/VStJs/l4IyHUOVhjba3sEjIBlBBa
	 X2AJiEabXK9IiqnTWe2eY3fb5VODELRZJUkiXoib+ImUeveYD/aTJV6ewlxlnPA2Fx
	 lYV0U6JcejL3hsRq5X0M7wGbFlzKp5AKFcIU1XWI=
Date: Thu, 5 Nov 2026 19:05:59 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <lkp@intel.com>
Cc: David Hildenbrand <david@kernel.org>, Linux Memory Management List
 <linux-mm@kvack.org>, mm-commits@vger.kernel.org
Subject: Re: [akpm-mm:mm-new] BUILD REGRESSION
 dba8aba0a9a00ff781c03d82ae534fc6f8c2e263
Message-Id: <20261105190559.5656444f0cb52cbf888427a6@linux-foundation.org>
In-Reply-To: <20261106095340.lgMcCHGK-lkp@intel.com>
References: <20261106095340.lgMcCHGK-lkp@intel.com>
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

On Fri, 06 Nov 2026 09:53:40 +0800 kernel test robot <lkp@intel.com> wrote:

> tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> branch HEAD: dba8aba0a9a00ff781c03d82ae534fc6f8c2e263  riscv: mm: fix concurrency in mark_new_valid_map()
> 
> Error/Warning ids grouped by kconfigs:
> 
> recent_errors
> `-- csky-allmodconfig
>     `-- drivers-net-wireless-ath-ath11k-dbring.c:internal-compiler-error:in-final_scan_insn_1-at-final.cc
> 

Thanks.

Am I being dumb here.  I can't find any error report other than this.

And I'm not going to lose much sleep about a CSKY gcc ICE in ath11k ;)
