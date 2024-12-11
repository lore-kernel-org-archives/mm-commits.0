Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3706F236FB0
	for <mm-commits@vger.kernel.org>; Wed, 11 Dec 2024 10:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733913103; cv=none; b=K36YxbSL+rVakPqdga9tvnlhNe84OhOv/vzMUd58EDigt8d8E1vnsQalYLpEe3XIsooJYtNXp+X9XD2KULYr3zS/N1VfOLaTymYgtU0Op/6+eJqCIh82ntYfnWJYhIyh4oGCs/cJb9hPXaRFxi94Ftc1BbHTKa0LZHduJ9NsOFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733913103; c=relaxed/simple;
	bh=Hnh8+3zLEvdwE5XJLO/tWSy3ORHc5DQjGA6X55PceGA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Dltmpy0sleLFkzORUNnr+UP1PmxxgFJDj1Vnx8pWeWDp107PgYREca5mHlPIjFkTrzEpCKeun25zZFZCBBFXHJiLoUiG+Y0pLAbJHNf5fMrdWTRiVSoaXdZoDcdEpcSfm6/JEV4chkK7WANIV8MQEkFVBDlipKRhtOpoeQCzJOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=AZ4/OzPw; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="AZ4/OzPw"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-728f28744c5so255597b3a.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Dec 2024 02:31:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1733913100; x=1734517900; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=k7i6n647BE9dHuYOqwOtsKEScU+JUkrRpc5bg8z66Mw=;
        b=AZ4/OzPwR/agUbPickW5OVsDrYfv1hsl1xglcvAcjMDD1QhN6Jxp1luj09Fqzw5bJE
         Wo3Sc8MKfoXEXb+IECYNKEoJgsflV5ivlx6+7CXXLSI9Gtx0yD0EYg0tj1Gcf4JX+mDD
         nQw75zw7jOgW/Ag01Df9ZJ7e02O2AMiXkRoNX9M00r3BdwGnjVC9gBKWvKJAbn+p4ph9
         BOGw785TrGbrNY33rheLY7c5j4PeYr7VOUype9Grtj8nMbbgNG54mWTA28RrowTgdsvM
         2a7kV1FVFN5dM8doAkg1CVTp5yn61LW7GjdJ8yIJFE2x8rLiNA/0tj1Y3bh0+6oY1O8Q
         i4sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733913100; x=1734517900;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=k7i6n647BE9dHuYOqwOtsKEScU+JUkrRpc5bg8z66Mw=;
        b=M0WDT8WHmsZQzbeJNWv09/ufw3C6pHNaEA7MVMbxbF9IrF6h/A/fVY7H8yt1DupSJP
         jnvh0oeC1z0bN7oWDgz/m14bUNr4qEqzLnlgZApYII+LgT1V//Z+yvOD8/HNpzCMkY4b
         DnFK/H8ztNlCx4tiow4Avqky831F7xEVT+eo3D7i9hmwWkWRWGLfNaas2FDJhKufU+jv
         oj77oUxn6FRO6R4wkq6HYAuZ0UDxuT4PbtNnueNkdKIvEg47j0UzioBvp3qC4cI+p8C/
         PFBybS2fESiD/7RUlt7mWEfUPBo3IUZrpatKMe0whJvStMOGLxsPXxgd7ZHVgjKVBy2T
         NLbA==
X-Forwarded-Encrypted: i=1; AJvYcCV+clpIyCzFEx0DQWHskLZUYiIYHGRRQWNVQxiDyng9HQBlSqYgPSgaNFUh4bGPGs948plpyJIoUXSH@vger.kernel.org
X-Gm-Message-State: AOJu0YzdSq+lBEB0+NdlftsZVyk/mYTenDLYv8AlV0EtB0jt5t1sGZmG
	Tbiw9PKtiOT+vQ4v1S8B/MUcv0zM1AzLWwJiYpRmebuiohuEhzjE7xsfMU5KhuT1uA5KhCYwG07
	N
X-Gm-Gg: ASbGncs3wbBSM0HACmWgawvjZX/pdWotBzEUNPzAATKIOib5TjB7S2HXmnLEOmSRZE/
	c+A+mLkx9hlSSMv8RLpg0oFde1zDm0lus/Vb1vbxdwAl0GIdjGBtIuFeSx7oqn6zhynD1RLkbD5
	cG6Mh9sIZE68V1ONQAsX/9zVXrwl1To+nL4u5LfKZGPVB0oFGI3PM6IXf7r45l3m4KBdhcHv7ip
	efRrXDzdaXaY9igksFD8e9EcAB3ZwRf4Jtmutsex+9uu/EjRBINFKjouwdFfB1m9n1ecWFlv0Zg
	BEM=
X-Google-Smtp-Source: AGHT+IH3fJdnmka2R5cZZPfUjML3wuj4J87bQ6+hEe5+6kzYgs8iJIPHRt8xFjtNAtTBns17z4gvnA==
X-Received: by 2002:a17:902:ce86:b0:215:577b:ab77 with SMTP id d9443c01a7336-2177858a890mr31397625ad.39.1733913100385;
        Wed, 11 Dec 2024 02:31:40 -0800 (PST)
Received: from [10.84.148.23] ([203.208.167.148])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21650ccda7esm48062405ad.143.2024.12.11.02.31.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Dec 2024 02:31:39 -0800 (PST)
Message-ID: <e8ec5fa7-8742-4e30-afbf-279d09c49d6c@bytedance.com>
Date: Wed, 11 Dec 2024 18:31:31 +0800
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: + mm-pgtable-make-ptlock-be-freed-by-rcu.patch added to
 mm-unstable branch
Content-Language: en-US
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
 zokeefe@google.com, willy@infradead.org, will@kernel.org,
 rientjes@google.com, peterx@redhat.com, muchun.song@linux.dev,
 mgorman@suse.de, luto@kernel.org, lorenzo.stoakes@oracle.com,
 jannh@google.com, hughd@google.com, david@redhat.com,
 dave.hansen@linux.intel.com, dan.carpenter@linaro.org,
 catalin.marinas@arm.com
References: <20241211030932.4DA94C4CED6@smtp.kernel.org>
 <20241211091202.GS21636@noisy.programming.kicks-ass.net>
From: Qi Zheng <zhengqi.arch@bytedance.com>
In-Reply-To: <20241211091202.GS21636@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Peter,

On 2024/12/11 17:12, Peter Zijlstra wrote:
> On Tue, Dec 10, 2024 at 07:09:31PM -0800, Andrew Morton wrote:
>>
>> The patch titled
>>       Subject: mm: pgtable: make ptlock be freed by RCU
>> has been added to the -mm mm-unstable branch.  Its filename is
>>       mm-pgtable-make-ptlock-be-freed-by-rcu.patch
>>
>> This patch will shortly appear at
>>       https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-pgtable-make-ptlock-be-freed-by-rcu.patch
>>
>> This patch will later appear in the mm-unstable branch at
>>      git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>>
>> Before you just go and hit "reply", please:
>>     a) Consider who else should be cc'ed
>>     b) Prefer to cc a suitable mailing list as well
>>     c) Ideally: find the original patch on the mailing list and do a
>>        reply-to-all to that, adding suitable additional cc's
>>
>> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
>>
>> The -mm tree is included into linux-next via the mm-everything
>> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>> and is updated there every 2-3 working days
>>
>> ------------------------------------------------------
>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>> Subject: mm: pgtable: make ptlock be freed by RCU
>> Date: Tue, 10 Dec 2024 16:44:31 +0800
>>
>> If ALLOC_SPLIT_PTLOCKS is enabled, the ptdesc->ptl will be a pointer and a
>> ptlock will be allocated for it, and it will be freed immediately before
>> the PTE page is freed.  Once we support empty PTE page reclaimation, it
>> may result in the following use-after-free problem:
>>
>> 	CPU 0				CPU 1
>>
>> 					pte_offset_map_rw_nolock(&ptlock)
>> 					--> rcu_read_lock()
>> 	madvise(MADV_DONTNEED)
>> 	--> ptlock_free (free ptlock immediately!)
>> 	    free PTE page via RCU
>> 					/* UAF!! */
>> 					spin_lock(ptlock)
>>
>> To avoid this problem, make ptlock also be freed by RCU.
>>
>> Link: https://lkml.kernel.org/r/20241210084431.91414-1-zhengqi.arch@bytedance.com
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> UURGGH... why can't we move the freeing of the lock into
> __tlb_remove_table() ?

Thanks for taking a look!

Now, it is also possible not to use the mmu gather mechanism to
free PTE pages:

pte_free_tlb
--> ___pte_free_tlb
     --> pagetable_pte_dtor
	--> ptlock_free
         paravirt_tlb_remove_table
	--> free PTE page

pte_free
--> pagetable_pte_dtor
     --> ptlock_free
     pagetable_free

If we want to move the freeing of the ptlock into __tlb_remove_table(),
we may need to define a pagetable_pte_dtor_no_ptlock() and let
___pte_free_tlb() to call it.

And ALLOC_SPLIT_PTLOCKS only be enabled when the spinlock debug function
is turned on, so I finally choose to only change ptlock itself without
changing the general path.

Thanks,
Qi
