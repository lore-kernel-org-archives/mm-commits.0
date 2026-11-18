Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795003789;
	b=bCFuJ81U9/BJCaXMWA8JJ4ZZlRBByTmIRcrXdWMbZKHGOZVYnm/uRus96xhx76teh6fR
	 1d7zHC20nfA3+56Uwmgm7ezIf9tYdsm3l2SPIoIqkRx+flYWQl14pHwDCuK7D4jOt6D82
	 oRZuhB7PEbIE6uMZmz2vCzY3IcrFhhqPHTRyOmME+1pLDAJVtw0tJR/Qrfz1mq9jk7i6v
	 0e68Ny13gegUGy+C6UaQa02q/V10plNxQtVVKagkJi9RWNMh92kZgvRLFEZ7J9K39L7Fp
	 Vsq+/Y/CnJ9N4FRSy3GQd13FRjVNyVx6lpHAMJwtPAnA9YpV48kF2OY+BZAfkgSkslA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795003789;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=SliBFCiuXH8Pgow6ev+m+UUcW7KKoAdntnZ69kSC5B4=;
	b=4jnCNPH7BevYWFwc192m31R2gr1TMoQymEnFcqlIswAhaZY91NINs5x9d9eT+DTxs9rP
	 am8on52HW6t8syNz3Hqak/hyyVUAf9ms+6xwYN3hjSx0ETlLK3Qw246CgX99bRVF0n7/J
	 zktHvyHW61TGCHzoH3q3aOAzjnU21QA5P952yeLGpmodBLavRZ1pjV/Va2VJEsHThqngN
	 souXY5c5ZK/ZeuisYXoUY2YuEeMaLUtQTgShHovtVjgXRDIrGr9mUsW6o0LnJevnmNVMT
	 T/2eOTszP50dk0Mi7eg7enU4ZDFydjYAPbUrX5MSqe95hFJnKcjbrS/RETrCwIZHWMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hwcttIRx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FDF2606A31C
	for <mm-commits@vger.kernel.org>; Wed, 18 Nov 2026 12:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hwcttIRx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41E211F000C4;
	Wed, 18 Nov 2026 12:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795003789;
	bh=SliBFCiuXH8Pgow6ev+m+UUcW7KKoAdntnZ69kSC5B4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hwcttIRxEQ1d1U3aHdQFf28Y+Uv3ujPjGBD0ZSyiDaBYZwWSqybmPkExviI/gmtzS
	 2LUq+hcBLdDzdAfi9g23PAnLNhT+XIii/UxXrWSAy+8yO6EosQghwxAs1GF9aUiylq
	 OE8cb4hVk3SSC64YKsrhu9W4m6ggDvwcL5XKQf4AnISxcpWa9yiwW1ag6BHJSV1WEI
	 GCL36KN5QwPMbrjr0ei8RuvPjdmBavysaHvFl949vtdU4I0MS09W7Qw9wmVcEV3PHU
	 vkw9q5O3gl1fURldMP0lwI3TDBq8df/xB4eVm2i5+0B6xNRfVjGMWwCpKXhPSc9cum
	 nVV2++OnkoMHA==
Date: Wed, 18 Nov 2026 12:09:44 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>, mm-commits@vger.kernel.org
Subject: Re: Using In-reply-to: <patch posting> in mm-commits mails?
Message-ID: <av2UtIIP202zN2jJ@gremlin>
References: <9ba54069-3dc4-422f-8cf6-f81cb806e999@kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9ba54069-3dc4-422f-8cf6-f81cb806e999@kernel.org>

On Wed, Nov 18, 2026 at 11:21:47AM +0100, Vlastimil Babka (SUSE) wrote:
> Hi Andrew,
>
> during some chat with Lorenzo, it occured me that it could be useful if your
> mm-commit mails (addition, merging to mm-stable, drop etc.) were replies to
> the respective patch postings, which would put them next to the patches in
> everyone's inboxes. I think Lorenzo started to doing that on his receive
> side with postprocessing.

Ack to confirm I had claude schlopp me something to do that and it's already
extremely useful - let's me see at glance if a patch/series has been taken, etc.

Especially useful in neomutt set up to show emails hierarchically.

>
> While I haven't checked your scripts, I naively imagine it shouldn't be hard
> to add that In-reply-to: <msgid> header. You already have the msgid for the
>
> Link: https://lore.kernel.org/<msgid>
>
> part. Maybe it's tricky when there are more Link:'s than the patch posting
> itself. But actually after Linus initially hated these automatic Link:
> additions, he later settled on the Link: https://patch.msgid.link/ template
> as acceptable to him. It's sort of documented in
> Documentation/process/maintainer-tip.rst too. So changing to use that
> template should allow to easily grab the right msgid to reply to even for
> later actions on the patch, than the initial addition.

Should be straightforward I think?

>
> Thoughs?
> Thanks,
> Vlastimil

--
Cheers, Lorenzo
