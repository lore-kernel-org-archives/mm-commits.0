Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 564BD2C11F1
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 12:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780058147; cv=none; b=Eizeo88IdeUvIdVnnYvUmI0manVdlgAAwn0NtIQvYjND7p1sKNeIphbnUlqBmBteNhjjF+J2AqgTEIOZMNGni5/CyoCjC87mvFGf2Lkc+fUnDNnHxq2OahkNKeRd502brxFM7AeIocQu4xQcri8ejrKIkizbB0eYjZ3rgrWeifo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780058147; c=relaxed/simple;
	bh=Uu0pOOe3qel1vCkqwx+k52targ03de26WlHCo/vfDlg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s3yxDtCfbBYw52fOEzLcnnE4+5LYaP8bjL5m/rKRykB6AI/woqYG7A5ds4DdbxsBFdXS6YYBy9Iw2Ns482PXn+JIPT+LNg2wZni+YI0dmSKEuEA4LDwGi9353jcnfuDtY0pRRivt07s0pUyZekB+MRtr000OOFGVZiipLuGGmp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org; spf=pass smtp.mailfrom=cmpxchg.org; dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b=L75lg7wG; arc=none smtp.client-ip=209.85.222.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b="L75lg7wG"
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-90fbf21d9d3so2049901885a.1
        for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 05:35:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1780058144; x=1780662944; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=C8tyG14nP5ARAFOFatQyu1rvTUj9VVrrHucz+LTuvp4=;
        b=L75lg7wGwuKFoqAieyo01sb0Ur2SgKfttVtdJX6SYbLPpZP5LZrSbNnGK8F1c8cxUk
         2Mwo1OFXRUJY3PvOwj1r8SuR/Pe604w8XJhC8VvpbulykZgDC6zgDHoks8ziciGuqAa9
         NbwlW7jWUnLDIQ2SYYpn3QyH0X3hwwV47NknnbAWjesr4oV5vZyBpHFAflqO5HT3Aygy
         6NRJj7sSRtsbohIr63t0TSUoJXelLZ5Snl8WLOUhANojmNkbTGM5ADO6x77+tBUf8Cqn
         kgwDKHCRX/tADjpVaaY5csg50Xs1OMMd+ek6q0JeFKXdWd3PVmPX1r/4wS3QtKcFVpbw
         V8jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780058144; x=1780662944;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C8tyG14nP5ARAFOFatQyu1rvTUj9VVrrHucz+LTuvp4=;
        b=nPd0oAP8lpex2IpsTwg6xR5nBRto3Io2vkb2BueQv/JyaALmw02W2VieYMztbyGzTm
         hHJT4oomDCWCcJvWsUBxnhiXrdK6EqrIsviUExISGxbfu9QnBG8ElrDns36LvCF+kwvB
         ZbLT+ecZZvgasXFU4JbrP9T8CvRYOCLBRm6U72zYWuVixAVoVvNBT9c28Vg7LDUl6600
         4ariIHPVmHuwzGmRW4+i2MlBlFkWBhDo8+LtVHeKq6tF32g6gF5Ny+ozhWwz2sBuhTJ7
         gKHEiO4vZh/9mzdok8sxuW62z88hHpy5udFPX8a/O/IpGEGtRc7htDe7GjVvfVGWibM2
         586w==
X-Forwarded-Encrypted: i=1; AFNElJ9USyNOvElsG9MsrbGgRTFlHyBluje6vYW4IQwRwkBKEo5srFpXu39/sX5o3RDaMctffg5MImYcURoa@vger.kernel.org
X-Gm-Message-State: AOJu0YwzZBMOTVFt8u/Lk4EgEijHVnrlakDDFvDph3sYeuuWR6PeemzB
	bYQBj5fuxe0efQxc3dlMPK0OfyOAlCQybx3hROV9WwyayvDSro36ei++V3+lnMsJOOY=
X-Gm-Gg: Acq92OFr1/sVBHfcHbcyf/4zjnWqmtYp1DIf6cPnvn+GoWjzuuM1FDdbZuO/s1FJwLn
	2KgkbqZvBLoTcadL8qWcuFJ8Chl7sQi9CVXIZ4nJgomWNldnchJ3Ro8oRXe7XI2hwqkyuRNgyvZ
	jUQrazHoNVPMsXo1JNMgB+DQTnFwhmsXGeoIuHv91LULzl2v0UwJ5K5rs+Jv2BdXVuTplQqUEva
	k/fWK8+tWQIuAGz8qbSFfiSnlnHnC+IQMy8wSFXxyHn9SxHd+OafJSVudfN0RNr9M2Tw/NjodWs
	2/3j+qwlmMON0nnr4e8MSc31HAehqEOmqO1iHvB+/QjLOAwVs52oR35eXqQ3PZN8x5k9swLnc+E
	GcvTZ2N0qRTWtnhw+Ug1VaxVhl7TAsnO/81cUdAk3yP8MfAmgbg3vE4farvPP6xXyZkUF5wblEx
	MfwyTkNO34857Q19FdHUIz0MAslX9kz1zR
X-Received: by 2002:a05:620a:2982:b0:914:bd3f:b6d0 with SMTP id af79cd13be357-9152fdf204fmr323840685a.31.1780058143430;
        Fri, 29 May 2026 05:35:43 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9153262d1b4sm172594285a.39.2026.05.29.05.35.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2026 05:35:42 -0700 (PDT)
Date: Fri, 29 May 2026 08:35:41 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kernel test robot <lkp@intel.com>, llvm@lists.linux.dev,
	oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	mm-commits@vger.kernel.org,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Subject: Re: [akpm-mm:mm-new 429/433] mm/swap_state.c:468:19: error: call to
 undeclared function 'folio_memcg_alloc_deferred'; ISO C99 and later do not
 support implicit function declarations
Message-ID: <ahmIHZUg2IRrSgnm@cmpxchg.org>
References: <202605281620.lc3rtkBm-lkp@intel.com>
 <20260528151618.7aa255415825c8d1de6ca437@linux-foundation.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260528151618.7aa255415825c8d1de6ca437@linux-foundation.org>

On Thu, May 28, 2026 at 03:16:18PM -0700, Andrew Morton wrote:
> On Thu, 28 May 2026 16:15:31 +0800 kernel test robot <lkp@intel.com> wrote:
> 
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> > head:   d7d405cc33d6e3eeba2d6ec8f0b595da2a5c600a
> > commit: a5e62d9e00dac6f96174c397a82da30e7ae53064 [429/433] mm: switch deferred split shrinker to list_lru
> > config: hexagon-defconfig (https://download.01.org/0day-ci/archive/20260528/202605281620.lc3rtkBm-lkp@intel.com/config)
> > compiler: clang version 23.0.0git (https://github.com/llvm/llvm-project 9409c07de6378507397ecdb6f05f628f58110112)
> > reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260528/202605281620.lc3rtkBm-lkp@intel.com/reproduce)
> > 
> > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Closes: https://lore.kernel.org/oe-kbuild-all/202605281620.lc3rtkBm-lkp@intel.com/
> > 
> > All errors (new ones prefixed by >>):
> > 
> > >> mm/swap_state.c:468:19: error: call to undeclared function 'folio_memcg_alloc_deferred'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
> >      468 |         if (order > 1 && folio_memcg_alloc_deferred(folio)) {
> >          |                          ^
> >    1 error generated.
> 
> Thanks.  How does this look?
> 
> 
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: mm-switch-deferred-split-shrinker-to-list_lru-fix
> Date: Thu May 28 03:12:45 PM PDT 2026
> 
> fix build with CONFIG_TRANSPARENT_HUGEPAGE=n

Thanks! SJ also sent a fix to this end. Either of them will work :)
