Received: from mail.mainlining.org (mail.mainlining.org [5.75.144.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DAE8420486
	for <mm-commits@vger.kernel.org>; Sat, 29 Aug 2026 23:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.75.144.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788046448; cv=none; b=Or58n3Q3qgtswWgUoKHfTr8+bJxIlpkr7WwJLaJADGlfLXpV+SrdUlVefoteglqDOZNfwoJyhTspCnkpF2iClRXv3YibFsajrj2HfJ+SV1o5TgtLzubrG4oM6w21jNo6osdmkSSd25RcIfqbE1p7kpOpIu8eHQaJwaqhqKzreGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788046448; c=relaxed/simple;
	bh=XihCiZqYEk3nRUXRhSMhrcO40lvQFTtwoqvjt5pSgns=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=bVrXiKVlsLkmY9vcYJJAsMOgFLl6GXjJvxVjS7+8WqF1PUw1zbsryiKimm3FTDL80iN//5P0id9KgvWb5vWZfkX53ndJ3ugweYb2ybuugEeSbFfW8WQH8CwiGiCN5fTrR9tdYL6tSsXDwRjqW/IkZh7L60NZCFCNFvnwiRy7SIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mainlining.org; spf=pass smtp.mailfrom=mainlining.org; dkim=pass (2048-bit key) header.d=mainlining.org header.i=@mainlining.org header.b=St2BD1Tr; dkim=permerror (0-bit key) header.d=mainlining.org header.i=@mainlining.org header.b=QBiVmFWN; arc=none smtp.client-ip=5.75.144.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mainlining.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mainlining.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mainlining.org header.i=@mainlining.org header.b="St2BD1Tr";
	dkim=permerror (0-bit key) header.d=mainlining.org header.i=@mainlining.org header.b="QBiVmFWN"
DKIM-Signature: v=1; a=rsa-sha256; s=202507r; d=mainlining.org; c=relaxed/relaxed;
	h=Message-ID:Subject:To:From:Date; t=1788046444; bh=GV+n10zvhGgNawHC5gLqPhZ
	PFoshUpZhNNE1k8hKLrg=; b=St2BD1Tr93qa4a6C4mr7gYSwrZEMqzXavLwzL64AjJh/n/Urdn
	sNio7XDP4D4WeN9A2TyRTVsGC/M7OrBXHvEQlju9YPRhFOY9OOWlaKcti1uKqxeVIld78RKfTqO
	OvTj2yKna5I6y0Ui4FMO08eBkz7LsbbGEILRvFHWdkj+bgb1Kp451ZQRpeSFqDB7z8T2JAH4gk4
	s2xYyPPUwppNQgh/0ADT1Jw9+I8zkfB0a3tEj3sSqs80TWi6Xm4ZM2pqJYdkgFdPcaf7LYxP6th
	UednY+aKZhl6EOh/SYT2giaAMuP/tWt7PRUpWdS7Y2/XptmZbtNFda1FayK4slcEKQQ==;
DKIM-Signature: v=1; a=ed25519-sha256; s=202507e; d=mainlining.org; c=relaxed/relaxed;
	h=Message-ID:Subject:To:From:Date; t=1788046444; bh=GV+n10zvhGgNawHC5gLqPhZ
	PFoshUpZhNNE1k8hKLrg=; b=QBiVmFWNywfgolrmLIrIS2JExcW9Au4oqkDFHjsuJ/bIut0zsN
	GDXpLLjD5havMECka90drJch9ScIgNGil5Cg==;
Date: Sun, 30 Aug 2026 00:34:05 +0100
From: Bradley Morgan <brads@mainlining.org>
To: Andrew Morton <akpm@linux-foundation.org>
CC: mm-commits@vger.kernel.org, pmladek@suse.com, mhiramat@kernel.org,
 lance.yang@linux.dev, david.laight.linux@gmail.com, atomlin@atomlin.com
Subject: =?US-ASCII?Q?Re=3A_+_hung=5Ftask-reset-warning-budget-when-problem-g?=
 =?US-ASCII?Q?ets-resolved=2Epatch_added_to_mm-nonmm-unstable_branch?=
In-Reply-To: <20260829162541.50f77ff5de42c35b7eadffe1@linux-foundation.org>
References: <20260829224704.C3D0B1F000E9@smtp.kernel.org> <1C7F9139-85AC-44C5-A1D2-6C7429C84661@mainlining.org> <20260829162541.50f77ff5de42c35b7eadffe1@linux-foundation.org>
Message-ID: <255A8DAB-0314-41F5-9641-D31D9B5A67A5@mainlining.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit

On 30 August 2026 00:25:41 BST, Andrew Morton <akpm@linux-foundation.org>
wrote:
>On Sat, 29 Aug 2026 23:48:39 +0100 Bradley Morgan <brads@mainlining.org>
>wrote:
>
>> >Link:
>https://lore.kernel.org/20260829145321.18423-1-atomlin@atomlin.com
>> >Link:
>https://lore.kernel.org/20260829145321.18423-2-atomlin@atomlin.com
>> >Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
>> >Suggested-by: Petr Mladek <pmladek@suse.com>
>> >Suggested-by: Lance Yang <lance.yang@linux.dev>
>> >Tested-by: Lance Yang <lance.yang@linux.dev>
>> >Reviewed-by: Lance Yang <lance.yang@linux.dev>
>> >Cc: Bradley Morgan <brads@mainlining.org>
>> 
>> 
>> 
>> Andrewwwwww, your gonna killlll meeee but can u plssss add my
>taggggg.....
>> My client had issues.
>
>If you mean you want a Reviewed-by: in there then please send one!

Oh and also your repo is gone for me
.



<https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git/>

Resolves as

No repositories found

Sigh.

--- Thanks!
https://lore.kernel.org/all/EE579805-42F2-4C58-B752-F28779EEB717@grrlz.net/
