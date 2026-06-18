Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDBEC14AD20;
	Thu, 18 Jun 2026 21:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781816839; cv=none; b=Io+tICpCnxDBr//IEE8GE7dJnkqdfQiu3+E1HW9uu97uYbsmH1IFtkQ/9bxFpq9D7d1OYoj24fZ2IZty/EhmREX804BvCs/r5Uw3fFmbUPaAHafCoR3S6PkXWCY+TlHYH84Hp3zvBs9AKGaMJ7s/0LSMj6pqXlGlnf1V7DQjgwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781816839; c=relaxed/simple;
	bh=P8ahyLEUSY/L+t9kwvK/Sx6Q5A/PLuVM9mZGX59bw28=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=StP0+rGJhz+sga54TWavD/ZQ4fziksakm2Q80hX0G4X0O3fGb+E4AghDm0P5m/c7PnwiGvyQn1msLKefMJCFDxWGU/OjIFX8lgntEzh/Q/zlshjfssifFuTidUsLHidQdFwvKQcw4USWiG2Cl62s/BC3aJpGFAT98sZNZh9g/aA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EMcXFAty; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EMcXFAty"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7690C1F000E9;
	Thu, 18 Jun 2026 21:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781816838;
	bh=aKcLcoZc0XbVzuHW4tda6GVNppvLxUk/gwYmWzl7I5E=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=EMcXFAtyzSsNQyMRTvmswqzR7TyPIw3JlPF7ox/H40xevTpNXWy7pGoIjsCEI6xf/
	 thIFDhQ/Vyw5TM5ujiSWtbsyuf72sYpCGIXXtjQdMx1qGMKLc69RRmUipG+hsIQoA0
	 4UpMJyRXbNkMGK8GuC+uU4eS9/W788gto4jNVnywGjPC/Fm9mFEN9dQKyJO+48NZog
	 pYQP4jQcWiu7idC1eUdSZq0cJJmIaQXWOaNslyDyoCYVbHhw70JragMXbYoChjWjMC
	 ZouNe1jU1Nh8OUvJr8M5AbQV+mcylLVzAfEoiBPtpmM3x/KMyupSG7BBdXdm78t2mv
	 1z1qRP9+pJN5A==
Message-ID: <9bbaa053-ea06-4b36-98ba-dc487a28964e@kernel.org>
Date: Thu, 18 Jun 2026 23:07:13 +0200
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: + userfaultfd-prevent-registration-of-special-vmas.patch added to
 mm-hotfixes-unstable branch
To: Linus Torvalds <torvalds@linuxfoundation.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, vladimirelitokarev@gmail.com,
 viro@zeniv.linux.org.uk, stable@vger.kernel.org, peterx@redhat.com,
 oleg@redhat.com, jack@suse.cz, brauner@kernel.org, rppt@kernel.org
References: <20260618183442.BBCD71F000E9@smtp.kernel.org>
 <CAHk-=wiQ_10MRYYW+aRfLP4Ah9gDrShOvLESXtz+Q32-9M9Y9w@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAHk-=wiQ_10MRYYW+aRfLP4Ah9gDrShOvLESXtz+Q32-9M9Y9w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/18/26 21:25, Linus Torvalds wrote:
> On Thu, 18 Jun 2026 at 11:34, Andrew Morton <akpm@linux-foundation.org> wrote:
>>
>> Since VM_SPECIAL includes VM_DONTEXPAND which is set but hugetlb, exclude
>> hugetlb VMAs from the check for VM_SPECIAL.
> 
> This seems bogus.
> 
> If somebody sets DONTEXPAND, then that mapping *is* special, and
> userfaultfd should not mess with it.

Right, it's one kind of special.

> 
> It feels like hugetlbfs is just wrong to do this.
> 
> This has caused problems before, see MADV_DODUMP which has that same
> "hugetlb doesn't follow the rules" check.
> 
> What exactly is it that hugetlbfs wants that DONTEXPAND thing to be?

I tried digging into the history: hugetlb doesn't support VMA merging (or VMA
expansion through mremap), apparently because of hugetlb reservation
interactions. Just nasty.

So I guess for userfaultd at least the VMA mergability/expansion doesn't matter.
Hopefully.

> 
> That said, I don't like the VM_SPECIAL bit mask all that much, because
> it doesn't specify *what* kind of "special" it is.

Right. It's documented as

	"Special vmas that are non-mergable, non-mlock()able."

It's a bit weird that we throw both things into one bin but ok.

And we use it in other context, like

	#define VM_NO_KHUGEPAGED (VM_SPECIAL | VM_HUGETLB)


Maybe we should rename and possibly split that up, like

	VM_NO_MLOCK
	VM_NO_VMA_MERGE

And then have some generic "there are really special things mapped in here"

	VM_HAS_SPECIAL_MAPPINGS


This might become a bigger (overdue?) audit, because I wouldn't immediately be
able to tell why MLOCK would have a problem with VM_DONTEXPAND.

VMA_REMAP_FLAGS is also odd, because it talks about "Physically remapped pages
are special" but then also includes VM_DONTEXPAND.

Any suggestion?

-- 
Cheers,

David
