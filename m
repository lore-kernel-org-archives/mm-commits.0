Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31A0B39AC2
	for <mm-commits@vger.kernel.org>; Tue, 19 Dec 2023 20:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hCKaOCVC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB78CC433C7;
	Tue, 19 Dec 2023 20:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703016849;
	bh=3jYAoSXSCdcwtEwmES4Z7y+5PMLav2xjQhNOTy64cS0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=hCKaOCVCgOED11mul5ZAgxYnZT2kyK+0B+aA7KEmu1FATffkzcq4nG8qRgfg0ixFw
	 8SrbM1pc2LSclI61jtrqvb2A7LT6npP609ZWW2NVufpREXGXk+MLMVk04rBbkpEerv
	 xBV1dn+kugS0kF7U8K3O20hgS3//TAa8HcuD2FsM=
Date: Tue, 19 Dec 2023 12:14:08 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: David Hildenbrand <david@redhat.com>, Will Deacon <will@kernel.org>,
 mm-commits@vger.kernel.org, ziy@nvidia.com, yuzhao@google.com,
 yuzenghui@huawei.com, willy@infradead.org, wangkefeng.wang@huawei.com,
 vincenzo.frascino@arm.com, suzuki.poulose@arm.com, shy828301@gmail.com,
 ryabinin.a.a@gmail.com, oliver.upton@linux.dev, maz@kernel.org,
 mark.rutland@arm.com, jhubbard@nvidia.com, james.morse@arm.com,
 glider@google.com, dvyukov@google.com, catalin.marinas@arm.com,
 ardb@kernel.org, apopple@nvidia.com, anshuman.khandual@arm.com,
 andreyknvl@gmail.com, 21cnbao@gmail.com
Subject: Re: + arm64-mm-set_pte-new-layer-to-manage-contig-bit.patch added
 to mm-unstable branch
Message-Id: <20231219121408.91d98a72cf938c0fa4831d71@linux-foundation.org>
In-Reply-To: <5e49d4cf-3ba3-4d8f-9c98-09c0ef898e35@arm.com>
References: <20231218172316.08623C433C8@smtp.kernel.org>
	<20231219101038.GA6307@willie-the-truck>
	<563d4703-e726-4e53-b163-2af192423373@arm.com>
	<145ac178-3bed-46fb-8fa5-0ae8293e43b4@redhat.com>
	<5e49d4cf-3ba3-4d8f-9c98-09c0ef898e35@arm.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 19 Dec 2023 11:25:12 +0000 Ryan Roberts <ryan.roberts@arm.com> wrote:

> On 19/12/2023 10:53, David Hildenbrand wrote:
> >>> In any case, this series makes significant changes to the low-level
> >>> arm64 mm code and I don't think many of us will be around in the next
> >>> couple of weeks to deal with the fallout if it kicks up any issues.
> >>>
> >>> Andrew -- if Ryan doesn't object, please can you drop this for now?
> >>
> >> It's always nice to get linux-next soak time; Is there a middle ground where we
> >> keep it in mm-unstable for a bit but don't progress it to mm-stable, and if
> >> there are any arm64 bug reports we drop it? Or is that too complicated?
> > 
> > If stuff is lurking too long in -next/mm-unstable, it might create conflicts
> > with other patch sets that might go upstream / to mm-stable faster.
> 
> Yeah fair enough (can't imagine what you might be thinking of :) ).
> 
> Let's drop it then.

Gone, thanks.
