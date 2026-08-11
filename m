Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1C29317163
	for <mm-commits@vger.kernel.org>; Tue, 11 Aug 2026 23:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786492218; cv=none; b=bfQPyiP76uuqV9K6UbcGQQraERoDFfxxuiwZ5zW5gsZFH2vgtj1CElwHVtuYSJBSQnYFjrASy3av63JA7xGyd0KPgCzPs00F9SzwJZ7QnUbSNRlpKH718tW9f54gQzw4LK2wmq8gvya8QLZevS/epuFNJsZP+uroD/VynLdnWVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786492218; c=relaxed/simple;
	bh=qYUjbXpz8E4uZ/xKE0BQ9L10xrE6fNKAfQ7bNdV9MP0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A0uewEA8nMw8hx2dNwjmCIDMd0Tk6aWT10mkRH2O9twSjxI4caeL0kvysdXlUePZyqDZVxLCUI/vNOEuk0wJia+M6mTq1Al8iQsrLcMIsJx90DovQbeFxXH/WIFvJr+4/ThNdRbwBmucePgS/Y1oRkiDNpwGFGdynjG7tk+f5yM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KKEghRcV; arc=none smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KKEghRcV"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-8f1a8e914a9so3366716d6.1
        for <mm-commits@vger.kernel.org>; Tue, 11 Aug 2026 16:50:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786492215; x=1787097015; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=JUJlehNradj4bdcRGpoJrN6Nl2Yt17W/u3/rUGCliQc=;
        b=KKEghRcVlXXiAN2RKb+KCPkjoqc69i3LV+Xoc3R28jqIludE4hRUnW7BN7UsZSF0F3
         JP7YuUO9VGG6UetL2LatYmFaDxpBiOQw/iLf8Xh8XoptnNiYi1L6JBTcRwgH+H0LHwou
         6iNws/ZKD4ma9RD0i8X2v0FUDlRzhisyvEof8gQxX87/yJo7+8XQk8iyT4ISStwmAf3b
         jpfhaw81FBF92E29HiLZu7cIRRj5FEt1nnFFDg+s87DrKfCARNcVGZZHdo9GSKUEbuyY
         RbTltMHphjHacnjsa1nsQ6aALvy14OH3ZezoNBe5UOivn3yo/rdcmkC7yxQrpO+dZH9h
         t7Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786492215; x=1787097015;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JUJlehNradj4bdcRGpoJrN6Nl2Yt17W/u3/rUGCliQc=;
        b=UOCb/1wEVkFGsJomY26GskSGd+dHdohwSg9o98ICwotTxz9GSCexIxW2M4KtzToFo6
         Ok8RWltPhwr7jqicndpQbhE7ITOZtCskNDGN4O3yN6NqIS1Vgq/ICxUODAA6IKzAQGsY
         HNCfKZdkJjlRZqOoqS5Fb7S7TFcb0Gfs1xRZ3t984Ck3k/PDzs7J2lSxvc8W/eyijHTt
         c0FC4CVbwRK9dw7cX+IqXWx8IQzz1KHTNVexYSSolkVPHjr8rDXQLdXQD8jz4j32jqHd
         mXELQU5lhgQaGkMoSrFgZsROJKp3+JSwQb6jOAaOhyhk/Ft965YX1wRMW6MdfYhHumnK
         hZrw==
X-Forwarded-Encrypted: i=1; AHgh+RoWmx/sFdc4Z1VB+G7Nmq5OS8aYoTl/w1FSfb1d98qsNZlKjMQkFs1Zzil6UqAfw5Zr/MPZyGfW3WrW@vger.kernel.org
X-Gm-Message-State: AOJu0YyAvUiHBugj6uQwfHzqv+HQxJiS05eEE5w08NEr+OwW937JsRmI
	VBMOd0v/fRBLfoajwQ0wuly5dMOipXx9FYULAyCye9PnXZEa28h3BK/z
X-Gm-Gg: AR+sD11SlJ7wrbNgYfc2lmyAtTKCrr7Ff1uBbhfFGCaULbDc1798338MFVysi+BVw6q
	hxz8ZsyMxa9TQV2xur1wcPZTyu/XT9gZ+mc/XUbcs+FIuiZHdK5nAAyHuThlU7c8VELQp9CXqyY
	CE0SesnInZDr2VFPSW9EnaH3rI1u6HNzBoxhCwpyr+WOZx/nDD6bdnImILL9wzj6YQfGBeSt4In
	kL28/pBJGZes3GQ7ZuNTUukfj11mMGK6VdiCnzPPqaRtPEpYjmvjazXAxraa8a86SD0wCkb7Eb2
	9Gvys5SsSDxDJDC9y6+AcQhOPtznfn7t6peDTTrQ35CGwjOlcS9hBXFTXzYVfkwsUT1FDGA7SzT
	UCwmP5YBxMuQEVdyNSLHFJpN8ktP0nGzr6VmlfaHRRkOJJ5xl7ovnIRjH05nmwwickJNs4Wc3nI
	6EV/31Cvm7h5VRCgXCI3JmyZCFUjpAwuMAkkj9PjkpTg8eoLhaClJRqxAEeg9d/EUX
X-Received: by 2002:a05:6214:2607:b0:8f3:13e4:739d with SMTP id 6a1803df08f44-90a6ff67324mr8542036d6.7.1786492215512;
        Tue, 11 Aug 2026 16:50:15 -0700 (PDT)
Received: from skinsburskii ([38.69.194.34])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90a6c299be7sm10134006d6.14.2026.08.11.16.50.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2026 16:50:14 -0700 (PDT)
Date: Tue, 11 Aug 2026 16:50:15 -0700
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kernel test robot <lkp@intel.com>, David Hildenbrand <david@kernel.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	mm-commits@vger.kernel.org
Subject: Re: [akpm-mm:mm-new] BUILD SUCCESS WITH UNVERIFIED WARNING
 e0ffd277b09a7c9f1a436e5f75be37ac490bc59f
Message-ID: <anu1N-DOnQwxO1kF@skinsburskii>
References: <202608101053.PhnVUM4u-lkp@intel.com>
 <20260810132334.3cf85dc3e9061bc7072759f8@linux-foundation.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260810132334.3cf85dc3e9061bc7072759f8@linux-foundation.org>

On Mon, Aug 10, 2026 at 01:23:34PM -0700, Andrew Morton wrote:
> On Mon, 10 Aug 2026 10:44:13 +0800 kernel test robot <lkp@intel.com> wrote:
> 
> > tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> > branch HEAD: e0ffd277b09a7c9f1a436e5f75be37ac490bc59f  mm/swap, PM: hibernate: atomically replace hibernation pin
> > 
> > Unverified Warning (likely false positive, kindly check if interested):
> > 
> >     https://lore.kernel.org/oe-kbuild/202607120402.clBrrZQA-lkp@intel.com
> > 
> >     mm/hmm.c:673 hmm_do_fault() error: we previously assumed 'hmm_vma_walk->locked' could be null (see line 654)
> > 
> > Warning ids grouped by kconfigs:
> 
> Thanks.  I assume this warning was produced by sparse?  The report
> doesn't tell us this, and I suggest that it do so.
> 
> > recent_errors
> > `-- s390-randconfig-r071-20260809
> >     `-- mm-hmm.c-hmm_do_fault()-error:we-previously-assumed-hmm_vma_walk-locked-could-be-null-(see-line-)
> 
> Caused by
> 
> 	121170831228 ("mm/hmm: add hmm_range_fault_unlocked_timeout() for mmap lock-drop support")
> 
> 
> Stanislaw, you've previously said that this is a can't-happen, but boy
> I'm getting tired of seeing this warning report.  Would the below change
> hurt anything?  I can't immediately think of a cost-free way of doing
> this.
> 

I think this change doesn't do any harm.
Perhaps it worth a WARN_ON_ONCE to expose a wrong fault handler
behavior?

Thanks,
Stanislav

> 
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: mm/hmm.c:hmm_do_fault(): suppress sparse warning
> Date: Mon Aug 10 01:16:37 PM PDT 2026
> 
> mm/hmm.c:673 hmm_do_fault() error: we previously assumed 'hmm_vma_walk->locked' could be null (see line 654)
> 
> Stanislav says this can't happen.  Waste a few cycles to make the warning
> go away.
> 
> Fixes: 121170831228 ("mm/hmm: add hmm_range_fault_unlocked_timeout() for mmap lock-drop support")
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/202608101053.PhnVUM4u-lkp@intel.com
> Cc: Stanislav Kinsburskii <skinsburskii@gmail.com>
> Cc: David Hildenbrand <david@kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  mm/hmm.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> --- a/mm/hmm.c~mm-hmmc-hmm_do_fault-suppress-sparse-warning
> +++ a/mm/hmm.c
> @@ -670,7 +670,8 @@ static int hmm_do_fault(struct mm_struct
>  		ret = handle_mm_fault(vma, addr, fault_flags, NULL);
>  
>  		if (ret & (VM_FAULT_COMPLETED | VM_FAULT_RETRY)) {
> -			*hmm_vma_walk->locked = false;
> +			if (hmm_vma_walk->locked)	/* needed by sparse */
> +				*hmm_vma_walk->locked = false;
>  			return HMM_FAULT_UNLOCKED;
>  		}
>  
> _
> 
