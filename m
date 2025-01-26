Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61FA322098
	for <mm-commits@vger.kernel.org>; Sun, 26 Jan 2025 04:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737866850; cv=none; b=Spphtp4NMF7cNi1Id+WJttBRmCGTJdkKgeLHSAyUPtDkwwxyiHrB0Hiyn8yihlZGfq7ySM4pu2v0KU/IngQl1uDUo1Rat8K5RznnOhKjlAbJAzTK/rwdQ5C8rvqpAXNYdS6Qg5KVSnzu11s4hBE49V1TouwSsFBoj5bxQmDOFWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737866850; c=relaxed/simple;
	bh=4WnRPF5TGh4fQDKVjNQ8CuQhTkH/ttzEVQHRW1FinVI=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=OqNuot/34oBaQHZWZyQ0fNFOaoQ/pFaTi8iFpreDmpmKXdPYMWTpSrkcmTm4wvokbiAzxaj+B8fPw47SQWnFvYIGVl0BrNGrrbQvscIHaZzJNNsS1MkE2x82RTu1O2AeHPdHngv7vqocuK2XtUV5pGM6esK85/yZimeM3Tmtvag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Mc3fDIBj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Mc3fDIBj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB220C4CEE1;
	Sun, 26 Jan 2025 04:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737866849;
	bh=4WnRPF5TGh4fQDKVjNQ8CuQhTkH/ttzEVQHRW1FinVI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Mc3fDIBjI80ouNGCvEPOmbky/Mq/pq0P3+9bo8plx1cl+g/bZen87ka5w1Gcn3JlC
	 Ur3y7tZMc4+OOTc6FRP5rc6mua8NO1djUBvj+Pq8f0mPXsTc5PYx2UGEMrrSW1Lu8l
	 f8t1Amg8VFOCjoc0D8RxwbxIfa761+W+0pE+2NZY=
Date: Sat, 25 Jan 2025 20:47:29 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Zhijian Li (Fujitsu)" <lizhijian@fujitsu.com>
Cc: "mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>,
 "kaiyang2@cs.cmu.edu" <kaiyang2@cs.cmu.edu>, "Yasunori Gotou (Fujitsu)"
 <y-goto@fujitsu.com>
Subject: Re: +
 mm-vmscan-accumulate-nr_demoted-for-accurate-demotion-statistics-v2.patch
 added to mm-hotfixes-unstable branch
Message-Id: <20250125204729.f5d60b8bd56ff42ad411d624@linux-foundation.org>
In-Reply-To: <TY1PR01MB156214A4B0222803E9D02770A5ED2@TY1PR01MB1562.jpnprd01.prod.outlook.com>
References: <20250111025946.ED72BC4CED6@smtp.kernel.org>
	<TY1PR01MB156214A4B0222803E9D02770A5ED2@TY1PR01MB1562.jpnprd01.prod.outlook.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 26 Jan 2025 04:14:22 +0000 "Zhijian Li (Fujitsu)" <lizhijian@fujitsu.com> wrote:

> Hi Andrew
> 
> I just noticed this patch was not included in -mm PR for v6.14-rc1[1]
> 
> However, our product needs to incorporate this patch as soon as possible. So I would like to ask if it can make it catch up 6.14?

Note that is was added to mm.git's hotfixes branch.  So expect this to
be sent into Linus as a hot fix within the next week.

Note also that the patch has cc:stable, so expect the -stable
maintainers to backport it into -stable trees as appropriate.

