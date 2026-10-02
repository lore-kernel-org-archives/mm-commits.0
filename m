Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 638AE38B12B
	for <mm-commits@vger.kernel.org>; Fri,  2 Oct 2026 23:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790983322; cv=none; b=IqiYGZ1v/iBWdQ2/dpOb2+Tq8A9hAHCpGpRR8zxk3ZKh2U1FYtJHjiSVwZKSEMPPXiqW78mDJU+ZeXaLAdCUsfW9J7qPf1L7gtW+ddrXYxizEiYu5Xtsm/JLWp5RR8TBfG5oqeL7gqDU4L+Z5FjXKdmTb/wrYpQbqw+u+lfqd20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790983322; c=relaxed/simple;
	bh=k1Tk91vOC9LKvlGMlinlU6UReF6qLVzenTiJ2CKBZnI=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=fYD7/eoSGmVsDRUxHUrHZm07/Bu4gE+KSE0XbzA0MqSp/ylLrvmB79kANaHF9K9pSMX00kqXgmjDUMZi4RG13cOdjs0WvzoygRF3x0qL67eD+B+m6gWTSYRI6Dum+uu8jnhehzvsI460OKZnzjv5SwH3ctqYss6bkmuxbVMbPfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=L/FYedNa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="L/FYedNa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA76A1F000FF;
	Fri,  2 Oct 2026 23:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790983321;
	bh=C8ybf5Ep3fbVu6tZK754jHAu6FeohNQb/UuW/Kiyc3I=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=L/FYedNacboS54yFgKk9Ap4bBUz7KvYVq5mVVnwwlI7eQURDMdAh3fOyhKpp4P8kk
	 o/uxlSMJD/gGGKUfD6KIydCvC9t6ZdUy/GZM6ey+CiqqYJ7CrCc6iOtkV1jdl3Smfg
	 B3KyNXhSgmiAWfzsAjkLuv6wBRB17H2bMauv8b2I=
Date: Fri, 2 Oct 2026 16:22:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: mm-commits@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 "Lorenzo Stoakes (Arm)" <ljs@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oupton@kernel.org>, Zi Yan <ziy@nvidia.com>
Subject: Re: mm-next: manual merge of the akpm/mm-unstable branch
Message-Id: <20261002162200.cb415c8a3310d6f7578d1930@linux-foundation.org>
In-Reply-To: <75edc952-3ada-4875-b3a9-6338d6f4d36e@kernel.org>
References: <75edc952-3ada-4875-b3a9-6338d6f4d36e@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 2 Oct 2026 08:22:17 +0200 "David Hildenbrand (Arm)" <david@kernel.org> wrote:

> Hi,
> 
> today's mm-next merge of the akpm/mm-unstable branch tree got a conflict in:
> 
>   arch/arm64/kvm/mmu.c
> 
> between the commit:
> 
>   71cc2c67fb8f KVM: arm64: Use stage-1 leaf size for VM_PFNMAP
> 
> from Linus' tree and commits:
> 
>   7a41ed87f53f mm: drop some redundant checks around hugetlb VMAs
>   f09773c2c4d0 mm: rename is_vm_hugetlb_page() to vma_is_hugetlb()
> 
> from the akpm/mm-unstable branch.
> 
> I resolved the conflicts manually:

Thanks.  I rebased mm.git on latest Linus (ff47652a4b66) and fixed this
up (check my handiwork!), so that should go away.

I'll attempt to make ff47652a4b66 the base for the next merge window.
