Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6649548F832
	for <mm-commits@vger.kernel.org>; Tue, 22 Sep 2026 19:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790106538; cv=none; b=ops4pnbQmT5kN/LOULUNhNA15OvQAjbSjhyMhswMN+Oi1SbbMXq8LPtQnBZZNnss2dhNz43TlPGkk4xWFQ+GD6mvtznZLRmvMW1rDKno9itiR2qDzoHwTVnRDuGK5aU7r2ZrODZfChzjuSK64SYFIYP+kkWwpXVEzEQZRCPoGJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790106538; c=relaxed/simple;
	bh=qkQArPnvwK32AkZXWHby5kIvClRDqKnntOIV1p6RnJQ=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=EuOKyofzelH51147nyLnq7LzeJ+pksB0O0iEqBLsQuMIWp5dqSpfGyHVXaf94XbUPt0xrYDUMytQ/RMMl3mDPgS8/3SdMxEEFWCjAqSjw70GpBjonGaPgbIBZKgzX9QKNGCWxcHmilwAt+HnKt59UGSJsQHCOJuXNZE4VGhwlEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OTV0JBzS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OTV0JBzS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C271D1F000FF;
	Tue, 22 Sep 2026 19:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790106536;
	bh=IauX5ynTEqIMx3uZKzbDd0YIApuVdCbzPz2YHyWQk0o=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=OTV0JBzSsdWVa1Fm5cgaN4c076LjdsnPSiusDDT+CYuMeml9AdEAsxNTf9IWhthXC
	 X8pVChb7RR4NgZ8Y9r5lDXo/mZWkup9HCFTeksRoGKboTV9D2MA98z1H9JFKzQXE8H
	 45dunqwx4BSBCKKaeXfqjxbhgeMj6G6abGJz+YDk=
Date: Tue, 22 Sep 2026 12:48:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: mm-commits@vger.kernel.org
Subject: Re: mm-next: manual merge of the akpm/mm-unstable branch
Message-Id: <20260922124856.481e6c4b9be9a93e247acacd@linux-foundation.org>
In-Reply-To: <0eff7de9-b379-472b-a1c3-07b55758b389@kernel.org>
References: <0eff7de9-b379-472b-a1c3-07b55758b389@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 22 Sep 2026 21:17:56 +0200 "David Hildenbrand (Arm)" <david@kernel.org> wrote:

> Hi,
> 
> today's (well, and the last couple of days) mm-next merge of the
> akpm/mm-unstable branch tree got a conflict in:
> 
>   drivers/infiniband/hw/hfi1/file_ops.c
> 
> between the commit:
> 
>   62f0f34fbd2b ("IB/hfi1: Fix the PIO_CRED credit-return mmap")
> 
> from Linus' tree and commit:
> 
>   e7d9f14bb73b ("infiniband: update hfi1 to use remap_vmalloc_range()")
> 
> from the akpm/mm-unstable branch.
> 

Thanks, I've now resynced with Linus and fixed that up.
