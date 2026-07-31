Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CE553563E1
	for <mm-commits@vger.kernel.org>; Fri, 31 Jul 2026 18:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785523242; cv=none; b=jNCBeZMceFQj2MGtrxaneFJS9ESJqeO6rxYeXGz7DOPgjDMlF5fbyoU7C1dGGPlt1JDpd+x7uUxxKQFOLEETo8ved781HeMoVUYJYheW5Swu4xC5VF+5QyOqVNzMkkd2yz3Y8sVTQ52kUnFEZr9RZyY09nQMMOZLOtaKPYBHVbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785523242; c=relaxed/simple;
	bh=MMut3YAsQuF5ygSjn3F+JyhtYTwCBpLjgzAIcjKgNTE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FVI147D7I6RHNMogS42VtpnB4xLv31XDoVh18TOBqfzrkYX6MiALy3RKpvfWiSf7zrr+0JjvP/VlJ/4spASUKwOEj6BWfW7ZYuousyWdHy834IxXNjqeUpsN3eNuKHoXXVDe7LAqH7V3y9CQewPQdEwPFSCyzE3nc4ujKPEmYUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WN4YXZfj; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WN4YXZfj"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2cfbbdfa60bso12403845ad.3
        for <mm-commits@vger.kernel.org>; Fri, 31 Jul 2026 11:40:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785523241; x=1786128041; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=XZ3Rb60doRZjVM3Yr3BNrWYoEOvjpyjvXsCIWVvxrw4=;
        b=WN4YXZfjckiwTFBLs6+ToicpfoUBJtmNNduR16xF4ufFTLWu19jOTEeKPt4gZhhtFh
         /ZGbB/wuNmWE1AIROp/AAayXbN+3x0k3NSIAYmyaO10JS/wsu7TKtc2hHSTpb/B8HJFR
         vz8gewjKf8UiEind55zqGqFjgCPi+MuRX35ftIyv2OR+ox5ME8+Kg2sjrwMUGP4KhIzk
         HbwG2myoWi/2bkrhrG5wpYX8WmvVFtCF1ssW+13wi1YqB2Z+zneBrbjIn73QNUqIhYXk
         OladxDIJzKhbd65h1B96g9q6fAoeajeVogtmyI5NtkfLLLHfRecKjISdH8rg5xyLB5/I
         VNow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785523241; x=1786128041;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XZ3Rb60doRZjVM3Yr3BNrWYoEOvjpyjvXsCIWVvxrw4=;
        b=ElzTOCNV9j5VxRjgww9DK+IBHs3UUEXKIg4S160kS3kFnctScW5T0nu0FZckorXjIB
         /1gDGaYicAEhdleVpBDh3UpSyRAtclMHYvfkHItKkD2fZ0hzAdmlsy454yz3PlVkIRUs
         hX1zA/iwXDQPsKEwkU5fb+Eeui3mUZJekMiu73Jm1Ov9zeNOdnYaCTpM9lArz8lLdNrJ
         UTG5Gb1PvKFk0d+YcmkDxMjTvCGG8uUp5Ru4QQg3xTND9Jj+fJgabRICH5YsEacMf0ox
         vskN7X7cnTry8RBzt79RnErgG6nSAbwz7Ni3Lw6MqTXLRNowEJRjlsE9qlZiEkUEA5yG
         U1rw==
X-Forwarded-Encrypted: i=1; AHgh+RrZ3hA6pqwInsYMF3gzArgXZ0czM+/h0Kzh8XRTmSP1laq41NTRGqYEt3GfizET2vT97RoCa9vNcqQS@vger.kernel.org
X-Gm-Message-State: AOJu0Yw09w+/pp4hQszDSR36lax/hoEWbbk4NTDS8e8OFjHwxJQRbyPw
	OYwBRpZg9lRRj61/m9uqH1KyYfHK/yXQW9FjQZyg+IUw8iXnNBtOp+uf
X-Gm-Gg: AR+sD12x763eqrRXyofi9oYIstoZ+lODPiXOSAju9vboJG64mw6NaEFIcPvoA0mA24E
	J0jxoXfjNASlYOfoyy8UoKTi01ZxwMjdkrRKVgbd62eKjpQihDMjL8qJG/+8GOP2MmrCSAid7fG
	H8oLN+8wkw3+5V6OubLIDZQREqjvjwKTCieuOJLgQFQYqErlOyu8eOKIhDc4q5YmQfVQ9vJrF58
	0QYfmxEgrWsedsecAsG81izvWmmJ4Iq0onMuH2seHU4yd7BJJzo1m4Lw4/cSlA0Z9c17Lxxi4/V
	LspS9MnM0aXNhkOBK3LpD966Qf+Fya3XrNrrbSiRBNp/uLyBL4Q9KbWmBc+71GDjQKVBzLuI1rH
	xOFHti7OOVxmu8sUJydJSuSbNNGVB8nC7z3c3xbjAL87zEXLaPolyPI5jtIzPDjjGao4lf1bjXp
	2LNL5KXCEqQBWgkS7X3RODIzrFlbKT5tl3tfobKV7rZe2o/ElLy8fdRnFvx0demV3Id+9FJmuBM
	hUNWHSpWQkjx+eTq1jYqNzhvo+CsKY=
X-Received: by 2002:a17:903:11c3:b0:2ca:b48f:3395 with SMTP id d9443c01a7336-2d0523bf980mr8796925ad.34.1785523240828;
        Fri, 31 Jul 2026 11:40:40 -0700 (PDT)
Received: from skinsburskii (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d04aea2514sm9211335ad.37.2026.07.31.11.40.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 11:40:40 -0700 (PDT)
Date: Fri, 31 Jul 2026 11:40:38 -0700
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kernel test robot <lkp@intel.com>, David Hildenbrand <david@kernel.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	mm-commits@vger.kernel.org
Subject: Re: [akpm-mm:mm-new] BUILD SUCCESS WITH UNVERIFIED WARNING
 0c39e2f552f5e16be695cec3a1c77d6a6bf086bb
Message-ID: <amzsJg00NzGIxOxw@skinsburskii>
References: <202607312212.u1pPx1f6-lkp@intel.com>
 <20260731100547.57414d6c37e65f08eb52ef04@linux-foundation.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260731100547.57414d6c37e65f08eb52ef04@linux-foundation.org>

On Fri, Jul 31, 2026 at 10:05:47AM -0700, Andrew Morton wrote:
> On Fri, 31 Jul 2026 22:31:38 +0800 kernel test robot <lkp@intel.com> wrote:
> 
> > tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> > branch HEAD: 0c39e2f552f5e16be695cec3a1c77d6a6bf086bb  mm/swap, PM: hibernate: atomically replace hibernation pin
> > 
> > Unverified Warning (likely false positive, kindly check if interested):
> > 
> >     https://lore.kernel.org/oe-kbuild/202607120402.clBrrZQA-lkp@intel.com
> > 
> >     mm/hmm.c:673 hmm_do_fault() error: we previously assumed 'hmm_vma_walk->locked' could be null (see line 654)
> 
> Thanks, due to "mm/hmm: add hmm_range_fault_unlocked_timeout() for mmap
> lock-drop support".  I think we've looked at this previously.
> 
> +	if (hmm_vma_walk->locked)
> +		fault_flags |= FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
> 
> ...
> 
> +			*hmm_vma_walk->locked = false;
> 
> Stanislav, can you please take a look?

It's the same concern as before: this path can be triggered only by a buggy fault
handler.

The logic in hmm_range_fault_unlocked_timeout() mimics the same login in
GUP's fixup_user_fault().

A quote from one of my previous emails:

"Fault handlers are not supposed to return VM_FAULT_RETRY or
VM_FAULT_COMPLETED with the mmap lock dropped unless
FAULT_FLAG_ALLOW_RETRY allows that, so the NULL locked state is not
expected to be dereferenced"

Thanks,
Stanisav
