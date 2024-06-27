Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF1C044C76
	for <mm-commits@vger.kernel.org>; Thu, 27 Jun 2024 06:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719471554; cv=none; b=jKwGNXbzlG96XGCUFX8GjiMVOIt9cWSUE1wsyZ8gqUk5IQD0/Zq7F+7e0zpwzAaA+ySPdfv4VK9UCgKtAqoBawTM2DpJrGPvIQ8Ncak0yMbSKb9aBUun2Qlfo0TTO3aCYLYO+i7ewvdisBWtnf7TpgdMmjDfJGT5Ta19tWG8aoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719471554; c=relaxed/simple;
	bh=2+M9zgmo49P4+Iv6guSNDkSUDT0aEHaf+tcuD+YOtB4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gB3wVDoeOLVFB+RViscFuC/Bg+qopRKl3rfrryWAw4a9puA2n3pbWIQb0y/J4lam0ASAKDXdMO+xfCtPaAfN+FjxP0rO08M8iezJKsLLkxRqY3gwlqbWgTJc2aG5a7x/hZx9KxWp5wD1Z2yeTHRwyVOiN+RQ4AVuKrovZ3ZPNFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=EnoqBMp2; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="EnoqBMp2"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-584ef6c07c2so405622a12.1
        for <mm-commits@vger.kernel.org>; Wed, 26 Jun 2024 23:59:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1719471551; x=1720076351; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=olgT+EEl6yH2WjkmndnMpR/RQv4i7Hs0PI6jUb94NIE=;
        b=EnoqBMp2Bx195WJABOCzOB1lcXfTkDbZDteIWE2TVXXz7WXH5pLacmSO+GMuxJkuvw
         HKeN0t+SvzsyFo7hTF8YrpkoEPJ1T9KYXv2AsIY5VhTQN+/tIC5ChHy7BhQQHHZrsli7
         u/jRJUbhmv2qhgzrJ/Y49xQGxOSPws+T4s9ZY82fyP/60VpgHdzeoDImvOX10vfNefIr
         DBkrWwUEJMPY5howVY5w2EyFuJ38EIRcsDQmSLGYt+L9hl/1N2w0Xc2P5fH1A1LgX1wP
         SvQmfdNrvUSTvvK9cJqiIvUSiP6TeGyEah9zl0Zv/fLbR8JT3WNHE7FmKArVSrj2V1ha
         qrUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719471551; x=1720076351;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=olgT+EEl6yH2WjkmndnMpR/RQv4i7Hs0PI6jUb94NIE=;
        b=bGpeUIQAUZVX7T4GjPfCflMzycHUlqA7PrwHe7M8xWAghj/h/vtwBq4ril+g1bb9hs
         IiCSWHICQP99QMbAvkvPBkABsY/jLq2ZTy4nPBppXZuGpsKRTEAs1oihoJQ+F2en32an
         Ead9JdEbgsf4Zv8QnKl5qsxvA1y5oJHsqNN3E4ctyJ/8HamujMLpJzAufHpy+w0+dVQS
         QAqMwZQr1bh0T9xl8JUzoTnRDoGwJrxIjEiIXDYMcSxMorQ1LmIEQ2xqLbmAGYi1mlN5
         jvveNtArSxiJIJo3ndR2LmpV4LnRb1jB8H/hAyGNslEB0cjxBw0bg8Z9qitFXuJChCrw
         tNAA==
X-Forwarded-Encrypted: i=1; AJvYcCU076JdHswVgANOoVrmt9QCVd3C6BySkGBf9QpqmEIkR3vDCRGOokCnRIB9wnCxfQNBhP6Wy8kcwafjaypkwz/BFCnr8BeBooBzDA==
X-Gm-Message-State: AOJu0Yz+DjpZ44WW3xbizRUEvyK8fEh+zZFppMofDKsW7C6OGaI5Vqll
	Fb2KAwAmW6U1Jhzx9gXDRIIy+UpTNbSewP3/6eqZILJ4tl3PtjJs+N3TZ3MM6Fk=
X-Google-Smtp-Source: AGHT+IH5tHd0NQMHgk33Cwbnum019QipXEqIv+YcbjDRaoj0Aa3z2Pj5kytKwktSP9mdS5s452M5zQ==
X-Received: by 2002:a17:907:7e8b:b0:a6f:259d:9a5f with SMTP id a640c23a62f3a-a729b93b85bmr91792266b.35.1719471551144;
        Wed, 26 Jun 2024 23:59:11 -0700 (PDT)
Received: from localhost (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a729d71f76fsm30568466b.84.2024.06.26.23.59.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jun 2024 23:59:10 -0700 (PDT)
Date: Thu, 27 Jun 2024 08:59:10 +0200
From: Michal Hocko <mhocko@suse.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Schatzberg <schatzberg.dan@gmail.com>, mm-commits@vger.kernel.org,
	yosryahmed@google.com, willy@infradead.org,
	wangkefeng.wang@huawei.com, tj@kernel.org, shakeel.butt@linux.dev,
	shakeelb@google.com, roman.gushchin@linux.dev, rientjes@google.com,
	nphamcs@gmail.com, muchun.song@linux.dev, lizefan.x@bytedance.com,
	hughd@google.com, hannes@cmpxchg.org, findns94@gmail.com,
	david@redhat.com, corbet@lwn.net, chrisl@kernel.org
Subject: Re: [nacked] mm-add-swapiness=-arg-to-memoryreclaim.patch removed
 from -mm tree
Message-ID: <Zn0Nvv82FzVdeNTP@tiehlicka>
References: <20240625210334.0BCA0C32781@smtp.kernel.org>
 <ZnuxTAcFbW0mI5uD@tiehlicka>
 <20240626101137.135997396b4e184643e045a4@linux-foundation.org>
 <ZnxQZkREehawir0F@dschatzberg-fedora-PC0Y6AEN>
 <20240626104325.9dff86f6a4adc94cb1a5b4a4@linux-foundation.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240626104325.9dff86f6a4adc94cb1a5b4a4@linux-foundation.org>

On Wed 26-06-24 10:43:25, Andrew Morton wrote:
> On Wed, 26 Jun 2024 13:31:18 -0400 Dan Schatzberg <schatzberg.dan@gmail.com> wrote:
> 
> >  After the patch was accepted in
> > mm-unstable, I contacted you directly a month or two ago asking if
> > there were any next steps or if it would be sent to Linus and you
> > indicated that you would send it to Linus as-is. More recently,
> > Shakeel asked about the status of this patch[1] and Yu Zhao said he'd
> > take another look but that he didn't remember having any strong
> > concerns.
> 
> Ah, gotcha, thanks.  I must have failed to update my notes at the time.
> 
> I restored the two patches and queued them for the next merge window.

Ups, missed this reply. Thanks!

-- 
Michal Hocko
SUSE Labs
