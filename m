Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5F901429E
	for <mm-commits@vger.kernel.org>; Tue, 19 Dec 2023 10:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LBIC2mKL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2DA3C433C8;
	Tue, 19 Dec 2023 10:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702980647;
	bh=Rsj8hYhx7Kpy16A9rLOqPZ012vp3B/7jkIGp3hwbf1g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LBIC2mKLOo77srlFrKCfX6OqVM34GEElwrwGZ+/qfnbQnhPqtJWXGvUEZdryvIqmh
	 3C2AQL/WNevlDzRhbhKkwfWziQNWijU+WRwyXgOYERuKWFb28I5PppyeWQ5yE2BX3j
	 B1LqzMDJXHcXhjNSFw+MZ5OMrIlc9yqghcm+O+UH7I7u7Tx4vQ/KR8wR97CNm21J1V
	 0xhU8kkPrSLYTOz33JxJwLglViy2v5FzLqL4CFWHFNvJ/fAncPicrb7+O+VZnf9rBt
	 /nlHa0SdcEcnTVaxiqLfKXRb0jTpvAEy/ZCdj1E816syljLE/MKfszGLfryg5Bxh9H
	 4GPo5wpS9mO+A==
Date: Tue, 19 Dec 2023 10:10:39 +0000
From: Will Deacon <will@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, ziy@nvidia.com, yuzhao@google.com,
	yuzenghui@huawei.com, willy@infradead.org,
	wangkefeng.wang@huawei.com, vincenzo.frascino@arm.com,
	suzuki.poulose@arm.com, shy828301@gmail.com, ryabinin.a.a@gmail.com,
	oliver.upton@linux.dev, maz@kernel.org, mark.rutland@arm.com,
	jhubbard@nvidia.com, james.morse@arm.com, glider@google.com,
	dvyukov@google.com, david@redhat.com, catalin.marinas@arm.com,
	ardb@kernel.org, apopple@nvidia.com, anshuman.khandual@arm.com,
	andreyknvl@gmail.com, 21cnbao@gmail.com, ryan.roberts@arm.com
Subject: Re: + arm64-mm-set_pte-new-layer-to-manage-contig-bit.patch added to
 mm-unstable branch
Message-ID: <20231219101038.GA6307@willie-the-truck>
References: <20231218172316.08623C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231218172316.08623C433C8@smtp.kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Mon, Dec 18, 2023 at 09:23:15AM -0800, Andrew Morton wrote:
> 
> The patch titled
>      Subject: arm64/mm: set_pte(): new layer to manage contig bit
> has been added to the -mm mm-unstable branch.  Its filename is
>      arm64-mm-set_pte-new-layer-to-manage-contig-bit.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm64-mm-set_pte-new-layer-to-manage-contig-bit.patch
> 
> This patch will later appear in the mm-unstable branch at
>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days
> 
> ------------------------------------------------------
> From: Ryan Roberts <ryan.roberts@arm.com>
> Subject: arm64/mm: set_pte(): new layer to manage contig bit
> Date: Mon, 18 Dec 2023 10:50:48 +0000
> 
> Create a new layer for the in-table PTE manipulation APIs.  For now, The
> existing API is prefixed with double underscore to become the arch-private
> API and the public API is just a simple wrapper that calls the private
> API.
> 
> The public API implementation will subsequently be used to transparently
> manipulate the contiguous bit where appropriate.  But since there are
> already some contig-aware users (e.g.  hugetlb, kernel mapper), we must
> first ensure those users use the private API directly so that the future
> contig-bit manipulations in the public API do not interfere with those
> existing uses.

Hmm, I certainly didn't have this series earmarked as v4.8 material. I
gave it a quick once-over last week but, with the looming holidays, I was
planning to come back to it properly in the New Year. I also thought ther
was a fork() regression that was under investigation?

Ryan -- what is your expectation here?

In any case, this series makes significant changes to the low-level
arm64 mm code and I don't think many of us will be around in the next
couple of weeks to deal with the fallout if it kicks up any issues.

Andrew -- if Ryan doesn't object, please can you drop this for now?

Cheers,

Will
