Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795709428;
	b=VTh3VinI2+pZeZUmUYlmh12HA1dBMwQ63b/DZRO+4vh0A+Jn9F0h2cMHdJ9kToA3Zl0Y
	 fZeJutu0VBHSa8kaiT9Sa8yzOh3WvoVOhVYzYe5J5mPJM1nOl7LrVfPGW64tF0eV3/Hs6
	 nO99bQp0VIMGErVTBC3JBPZgf0BFt6SelF3uDs3X/BVU1AbNHXt0rQZUXpN9tsdNiLI60
	 IqWddN5v/zHhTCVDvbaDUD4Mx4pgSHOIBhvmTo+rhbwec9TrwbJp+KbryiCqeUtE5srHl
	 mfyRYy/6TU2dXUp4txdk2b0jvnh1YQD99YgLrHU90pUxb3RYS2kQJz5WtCtLmeYVGaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795709428;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:From:
	 Content-Language:To:Cc:Autocrypt:Subject:Content-Type:
	 Content-Transfer-Encoding;
	bh=zRmmBYK19XeCuqPxJoN4entFK5CtWDLKuAQQihnLmEw=;
	b=jwGBkzuK6mx0EXGDjaTte04uIAoZvdAxOvP0FRWQAxumLxUhNSGQAvraePd0lsnvCCtx
	 VjB5P0wKKLh3trhg1CO5dwGJgxiGZrCX2Rd/b9RDa/k7Tmoc3ucTpmb0xsN0t4vIQSAS+
	 yXmV339D4oQ3pJVVbb+VzOSyASm+e6dfeHCrPviZmeUHUk+Tl44PzXV28boTqrAe8IYlW
	 09lKoMU6UVDv0zSWrhOPBmDiyshBC6h37a+WF7Me1I153DhtXXOmAMKjYunxD2vQRj6f+
	 Y/DWIz7lAKBimHMMKLyA2BgzDVRFhh24MZwnLS9rYEPAACyvoBqMt9eqk/jRzhHBxDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=htEW6RYv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 486CA606A31C
	for <mm-commits@vger.kernel.org>; Thu, 26 Nov 2026 16:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=htEW6RYv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53F3C1F000C4;
	Thu, 26 Nov 2026 16:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795709427;
	bh=zRmmBYK19XeCuqPxJoN4entFK5CtWDLKuAQQihnLmEw=;
	h=Date:From:To:Cc:Subject;
	b=htEW6RYvCAIl3vJ66BkWEkYta1Egb6G5TIUsxl6WcE9dgxcsw8ZDEOzDrXGRFQA1M
	 Ld6l/qt2SDlVZkCDeFJxReiYMcah48punpJL04q/GUNSjpCuCX5O01EensdGDsB3hT
	 cwSLcnA7JkbQOcO89iC9zIi0Feywj9VF9QXdipFlarqrQ59a5L7aXO8H0H3brGq2M1
	 qyaAA8braXnprMbN5Vkk0rD/fShHMPvyXx2BIXfivLjeJr7Fo0Em1drZK0bwJxjn1w
	 FCpaLAVC3qXSYm6b6NsoiMZ3sGvWcoEIJTyAZL2wKB6EBW+WxUreaugFjtcIV217Th
	 ZtWCWvHHcUJ3Q==
Message-ID: <5a0e6675-97cf-432b-8b18-60460e171e29@kernel.org>
Date: Thu, 26 Nov 2026 17:10:23 +0100
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
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
To: "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
Subject: mm-next: manual merge of the akpm/mm-unstable branch
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

today's (and yesterday's ;) ) mm-next merge of the akpm/mm-unstable branch
tree got a conflict in:

  mm/khugepaged.c

between the commit:

  0d100a39e288 mm: khugepaged: ignore MADV_HUGEPAGE for shadow stacks

from the core/for-next branch and the commit:

  e94cbda0f126 mm/madvise: convert madvise_vma_behavior() to use vma_flags_t

from the akpm/mm-unstable branch.

I resolved the conflicts manually (trivial):

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index a77235c78a5e..34bb22b73152 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -383,16 +383,11 @@ int hugepage_madvise(struct vm_area_struct *vma,
 {
      switch (advice) {
      case MADV_HUGEPAGE:
-<<<<<<< HEAD
              /* PTE batching doesn't work reliably. */
              if (vma_test_single_mask(vma, VMA_SHADOW_STACK))
                      break;
-             *vm_flags &= ~VM_NOHUGEPAGE;
-             *vm_flags |= VM_HUGEPAGE;
-=======
              vma_flags_clear(vma_flags, VMA_NOHUGEPAGE_BIT);
              vma_flags_set(vma_flags, VMA_HUGEPAGE_BIT);
->>>>>>> akpm/mm-unstable
              break;
      case MADV_NOHUGEPAGE:
              vma_flags_clear(vma_flags, VMA_HUGEPAGE_BIT);

-- 
Cheers,

David

