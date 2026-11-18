Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=124.126.103.232
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795007919;
	b=4IoW1iH4hKUxdl9odaqO6hilrDYzEPDs54nIGeZ7T/NjqicLeeIiNbepOO/1E1Ul3KDw
	 gu3IqCD1NnNOBHmsrIFnIxWLGhbRxsxJTeijkBcopOuwyW0vu4LO4vmI4KL+Javp0wLC5
	 Qj+I3Xmd7UM8RVQSC/bXGTnpdOACTNf0soBB7n6K1GX7Az2ZGQdlHgAFCTaly4n68Zrmj
	 FZMSmLP5GwvUS9NFjeXADbcGdkBvnM2aTeqnq9FGlfKLz+4o9Di5PqiRmy9Bv4aF6KsW4
	 F+M6GMQRFfsxeaY3EeA7Vvgslvf6AUnOoKALGUrFF20U/AZzfyV3qdOM9wfD+7VGwDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795007919;
	h=DMARC-Filter:X-UUID:X-CID-P-RULE:X-CID-O-INFO:X-CID-INFO:X-CID-META:
	 X-CID-BVR:X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:X-User:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=upd0IxCj2792Sd+Vd6lDIAbHvUW1f3kpvaia8Zd/3Ck=;
	b=NDDcvhOHT4l+kDPJxkcl/W57TB+0EibBqXAs7hR8TnBTWpzaQgSHTg/vFuMmfB6jB2nJ
	 EvspgaZLnoMfqCbCxkvD61XcHua4rsyzxKiqYV5WKZ1X1pOKb8xQOvChb4+XPdH+02XiS
	 PMyKo3dNZqzigGKFPAXuTy2ASCU8OKZ6Km1UAfizWaizYIdfYa35Ld3pQ0Eo5pSn7bYuz
	 g8f6snlf6WJh1UV8LquGti+8u81DK6wCEGCUU+9bE6YsdYtVgw08W0fDaQII6XKZZu2F8
	 RU41mrQ4wdk0sQstNI7jvAzI7I+iZug+mKbTnL0BQ22y3lS2Ciw2tjbnuv6QzQBtWPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=kylinos.cn;
	spf=pass smtp.mailfrom=kylinos.cn;
	arc=none smtp.remote-ip=124.126.103.232
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EDAE606A31C;
	Wed, 18 Nov 2026 13:18:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3EDAE606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 8c311e00e35211f19a56ed5b684f684d-20261118
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:8e9c81ca-96b8-4040-b02f-cb5bf20b073f,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.19,REQID:8e9c81ca-96b8-4040-b02f-cb5bf20b073f,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:7db8b62,CLOUDID:590b889ced8d4f83e2e07ffedd64af85,BulkI
	D:261118093247FQF070YS,BulkQuantity:2,SF:17|19|38|64|66|78|80|81|82|83|102
	|127|136|153|841|865|898,TC:nil,Content:0|15|16|50|99,EDM:-3|-100,IP:-2,UR
	L:99|1,File:nil,RT:nil,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1
	,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_ULS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 8c311e00e35211f19a56ed5b684f684d-20261118
X-User: lienze@kylinos.cn
Received: from [192.168.3.106] [(111.193.136.161)] by mailgw.kylinos.cn
	(envelope-from <lienze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_128_GCM_SHA256 128/128)
	with ESMTP id 603697062; Wed, 18 Nov 2026 21:18:30 +0800
Message-ID: <06e16d01-328b-4267-902b-1b4821139029@kylinos.cn>
Date: Wed, 18 Nov 2026 21:18:26 +0800
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/damon/paddr: avoid truncation warning in high-address
 KUnit test
To: Aveline Noir <jm5905938@gmail.com>, SJ Park <sj@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: damon@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Justin Stitt <justinstitt@google.com>, linux-kernel@vger.kernel.org,
 Linux Memory Management List <linux-mm@kvack.org>,
 kernel test robot <lkp@intel.com>, llvm@lists.linux.dev,
 mm-commits@vger.kernel.org, Bill Wendling <morbo@google.com>,
 Nathan Chancellor <nathan@kernel.org>,
 Nick Desaulniers <ndesaulniers@google.com>, oe-kbuild-all@lists.linux.dev,
 rdunlap@infradead.org, sashiko-bot@kernel.org,
 sashiko-reviews@lists.linux.dev
References: <20261118-fix-damon-paddr-sparse-20261118-v1-1-3a0e943406d5@gmail.com>
Content-Language: en-US
From: Enze Li <lienze@kylinos.cn>
In-Reply-To: <20261118-fix-damon-paddr-sparse-20261118-v1-1-3a0e943406d5@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2026/11/18 01:04, Aveline Noir wrote:
> Hi SJ, Andrew,
> 
> The kernel test robot caught this issue in my earlier addr_unit KUnit
> patch. Feel free to fold this fix into that patch.
> 
> Thanks,
> Aveline Noir
> 
> -- >8 --
> When phys_addr_t is 32-bit, Sparse warns about truncating the u64 address
> passed to damon_pa_core_addr() in damon_test_pa_addr_over_4g().  The
> runtime kunit_skip() does not prevent Sparse from checking that
> conversion.
> 
> Compile the high-address assertions only with CONFIG_PHYS_ADDR_T_64BIT,
> and keep the test skipped otherwise.
> 
> Fixes: 7a983cc1b573 ("mm/damon/paddr: add KUnit tests for addr_unit conversion")
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/20261117170155.fEdeuuhm-lkp@intel.com/
> Signed-off-by: Aveline Noir <jm5905938@gmail.com>

Reviewed-by: Enze Li <lienze@kylinos.cn>

Thanks,
Enze

> ---
> The reported warning is gone with the original i386 config, Clang 22.1.8
> and Sparse v0.6.5-rc1-21-g84ec0658. All executed DAMON KUnit tests passed
> on x86_64 and i386 with and without PAE; the high-address case skips
> without PAE.
> ---
>  mm/damon/tests/paddr-kunit.h | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/damon/tests/paddr-kunit.h b/mm/damon/tests/paddr-kunit.h
> index 9839cc233071..2b11f0e67a12 100644
> --- a/mm/damon/tests/paddr-kunit.h
> +++ b/mm/damon/tests/paddr-kunit.h
> @@ -26,15 +26,16 @@ static void damon_test_pa_core_addr(struct kunit *test)
>  
>  static void damon_test_pa_addr_over_4g(struct kunit *test)
>  {
> +#ifdef CONFIG_PHYS_ADDR_T_64BIT
>  	unsigned long addr = 0xffffffffUL;
>  	unsigned long addr_unit = 0x1000;
>  	u64 pa = 0xffffffff000ULL;
>  
> -	if (!IS_ENABLED(CONFIG_PHYS_ADDR_T_64BIT))
> -		kunit_skip(test, "phys_addr_t is 32-bit");
> -
>  	KUNIT_EXPECT_EQ(test, damon_pa_phys_addr(addr, addr_unit), pa);
>  	KUNIT_EXPECT_EQ(test, damon_pa_core_addr(pa, addr_unit), addr);
> +#else
> +	kunit_skip(test, "phys_addr_t is 32-bit");
> +#endif
>  }
>  
>  static struct kunit_case damon_paddr_test_cases[] = {
> 
> ---
> base-commit: 7a983cc1b57309a875a9e07a934c9944bf3d088d
> change-id: 20261118-fix-damon-paddr-sparse-20261118-fb08902768d7

