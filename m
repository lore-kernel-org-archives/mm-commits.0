Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D422B30ACF1
	for <mm-commits@vger.kernel.org>; Fri,  2 Oct 2026 12:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790943865; cv=none; b=u9fP5hV05BUVVoWI1Bvvk8M3dqaz/k1YBVPA0Qtep7qukL01fMr/5lmF1IWrZ2+7UU3Bz/A8EZLQJyt80940ZLQQNvB9NtPXy1RBv2qSnh2IdL8uABv1QFoYjFpjeO9RrI9vhPZe2FUehfeOTALQOZV4ouskRuf0q/lFUerBW6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790943865; c=relaxed/simple;
	bh=GW76cs7ysmkBpVYeQ08jcP5vvhMghnsqZOiXl7ID1Xs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ji/OXTQz7NPC/0t3x+wkqfTrFFx5qsEGwyoAWA1VsWIwm+gRBxntsDurjUZM0MSfD/Ruo1S/pbfb5MEvDpxAsITH4TdGb+U0TJMXhsfnDNbtRuz/i3F3/awHc2OkafGQM7QJlhAiRY+j6Ik1ZJeSJdwXeFt9+3y/ZtK0fTCnPGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m1adaKPY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m1adaKPY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5A621F000FF;
	Fri,  2 Oct 2026 12:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790943864;
	bh=ldHzaJ8xA1ytVviqwa8a4cfueNntrG3WiJlwdKywdmI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=m1adaKPYY6e4SCvt0HqEj42JmKBsU+QznGMY2dyuUO1tGL72+dOWXqnKzF7hFlZo4
	 kS5FGynMtocpb8Ylxwrqa1avBYorni9CFEmbWC/H4Q3q3tZ8Pxgq4DGOJ2qPQgtixe
	 NBhx5/+Sv0iYMjKPHYS0HunCiwnFcHTF+7VO17eNdmT6ULsCzHBmxfrCRLIaTB/TQV
	 rzENPBQVvmOpWBEq52W+9mm2JrNswEJ8ZTRmdsq8Rii+tVnqfkh1p2J+xYZq4y33ju
	 NDFFelCahFOwQ2aiR9adYkp6QTpfvigs27mKonYmVaC3TfjZHqHNzyPPDYMCK2y5jZ
	 gwxmXc7I/QMbw==
Date: Fri, 2 Oct 2026 13:24:20 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Zi Yan <ziy@nvidia.com>
Subject: Re: mm-next: manual merge of the akpm/mm-unstable branch
Message-ID: <ar-iaDmUZIIfrk0k@gremlin>
References: <75edc952-3ada-4875-b3a9-6338d6f4d36e@kernel.org>
 <ar9n7y0cnAoAEVkx@gremlin>
 <949c4da0-6e2c-419a-9ce4-9fb6b5b36524@kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <949c4da0-6e2c-419a-9ce4-9fb6b5b36524@kernel.org>

On Fri, Oct 02, 2026 at 02:16:14PM +0200, David Hildenbrand (Arm) wrote:
> On 10/2/26 10:15, Lorenzo Stoakes (ARM) wrote:
> > On Fri, Oct 02, 2026 at 08:22:17AM +0200, David Hildenbrand (Arm) wrote:
> >> Hi,
> >>
> >> today's mm-next merge of the akpm/mm-unstable branch tree got a conflict in:
> >>
> >>   arch/arm64/kvm/mmu.c
> >>
> >> between the commit:
> >>
> >>   71cc2c67fb8f KVM: arm64: Use stage-1 leaf size for VM_PFNMAP
> >>
> >> from Linus' tree and commits:
> >>
> >>   7a41ed87f53f mm: drop some redundant checks around hugetlb VMAs
> >>   f09773c2c4d0 mm: rename is_vm_hugetlb_page() to vma_is_hugetlb()
> >>
> >> from the akpm/mm-unstable branch.
> >>
> >> I resolved the conflicts manually:
> >
> > Nice to see this from mm-next :)
> >
> > This looks the same as [0] and similar to that this LGTM.
>
> Yes, there are some situations where we hit that in -next first and later (once
> fixes go upstream) in mm-next. In other situations (primarily as we add new
> material into mm-next when conflicting fixes are already upstream) we get the
> conflicts only in mm-next.
>
> All good dry runs for our incoming intra-mm conflicts that will be entirely in
> mm-next :)

Yes love to see it! <3

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo
