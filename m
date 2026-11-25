Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795604209;
	b=sV8fYo1RuOBJNB0joQkwnxh1Q9KliU20YySlFEePb6LCmUJ+LdKTYAer/RMIsz42/Jke
	 l9qPk6o6SIHvksQqzaUT9ZzyRj7r9pKnmaRDjp8hbvhcw0nBqiMV9+D0qxCY8u8ylTGw4
	 q/tan3UcsuGDu6JJZXRz3JPo+57ciedtKsKaMFO67ZR1MWuhx8ZYrZD4T/ZXJQTQdKIWc
	 6qH1E0M8J7nobz7dnksQfbyYykYPW5pjYuriALSgjqdQtobt3qbRpj0TwnpDAsSX3kmgs
	 Gc/R/Y8xGuQaV4UMo3/dwVT/AJZiFc5nXRLOwlsFTLO6DKsL44Hj++QaxMGKDMqx4eA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795604209;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:Content-Language:To:Cc:References:From:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=IGlGVBtciy7MJkiN2Eftd5p6Uc7TCwHrsbps6+JM8Mc=;
	b=5tvdAKg+vHvk3A1noxV7vUN8L1HhcNwLKxkTbeTpXc2COhCQcl0U4k8nklelmi8b3Pa9
	 84hyLhI9AAojurW3066uIVmxaPZW6vIFG5ar+fqwyoa9vjy+XsQq8d4Al5VoZ2iFpZ+K7
	 GtZVcMby/8jB3SmkPqnCn4WOFqJ0/D04RbfrmXDEDE0HtrXlRTCk+ZznDH79ReqdC69uS
	 xM2Jzr3jxxVRr91dKsBbxCpf0XWyjQ9BtClv1Flgxj7F/SYs3rSo7e42g23CVcbsM2Mm4
	 ZuSLwY6ZlVXy9UsQ8MQgjEUcneisHKqzspyxx+mXP/cNp7r4qLqPp4zgMh1IgygCz2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZHQTxafb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAE9D606A323;
	Wed, 25 Nov 2026 10:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZHQTxafb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C1FD1F000CF;
	Wed, 25 Nov 2026 10:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795604209;
	bh=IGlGVBtciy7MJkiN2Eftd5p6Uc7TCwHrsbps6+JM8Mc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ZHQTxafb32l4zpYnzuD73O9FxavuPCR0PBw+Ou5e66x4MJBIHp2O79pUnVjSqToW9
	 0Rovl8124Fs2IuOJUmZwYMPxpXecQ6a82VgvCTc4yoDjGGyed6SUNYtZfHshIZfe1U
	 Ionj3pSJBQTcNDIYK3qzW70hYMyF8p4HCPybB2jriVJJXwpG9u3PyD2zU6WS3klm2u
	 FwukrUmR6szOo5anps6F3mLhei37Mmw+fcFT0Vkpbvj1JdzZUBkA8tj2lBWzniTfgV
	 cpii/fC0TQw173XCRUSKe9c9OjlOuz5HtGnouqNX9hQ+iVSJQnMZH8JBfhs4NIw65J
	 g0K917ElCA+eA==
Message-ID: <cbd03e3c-94ce-4eeb-92d4-45dbee4a098d@kernel.org>
Date: Wed, 25 Nov 2026 11:56:45 +0100
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
Subject: Re: [akpm-mm:mm-unstable 33/408] mm/mmap_lock.c:572:14-33: WARNING:
 atomic_dec_and_test variation before object free at line 574.
Content-Language: en-US
To: kernel test robot <lkp@intel.com>, "Lorenzo Stoakes (ARM)"
 <ljs@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>
References: <20261125102827.xQ94ZCi1-lkp@intel.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20261125102827.xQ94ZCi1-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/25/26 10:34, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
> head:   c8117bff684306f5c1f959d055cc2b24dd67b1eb
> commit: 549e0b6c9835de4cc4e8e4a56459ef09febfc2f7 [33/408] mm/vma: drop mm asynchronously in vma_start_read()
> config: sh-randconfig-r2100-20261125 (https://download.01.org/0day-ci/archive/20261125/20261125102827.xQ94ZCi1-lkp@intel.com/config)
> compiler: sh4-linux-gcc (GCC) 12.5.0
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/20261125102827.xQ94ZCi1-lkp@intel.com/
> 
> cocci warnings: (new ones prefixed by >>)
>>> mm/mmap_lock.c:572:14-33: WARNING: atomic_dec_and_test variation before object free at line 574.

So AFAIU this is a suggestion to use refcount_t instead of atomic_t in new
code, but this is a move of an existing code and intended to be a minimal
fix. So we can ignore.

(this is intended for saving Lorenzo a reply, let's see if he can resist :)

> vim +572 mm/mmap_lock.c
> 
>    569	
>    570	void mmdrop_async(struct mm_struct *mm)
>    571	{
>  > 572		if (unlikely(atomic_dec_and_test(&mm->mm_count))) {
>    573			INIT_WORK(&mm->async_put_work, mmdrop_async_fn);
>  > 574			schedule_work(&mm->async_put_work);
>    575		}
>    576	}
>    577	
> 

