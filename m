Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DED81218AA8
	for <mm-commits@vger.kernel.org>; Thu,  5 Dec 2024 13:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733404890; cv=none; b=txqM7+WI3wjME+7Aan3RE1Nf62HDjxgIEf2s1Z3i4JEGh/77IVYNnikvL/M/WwcIgeDmw79CiKEMt4bjRX/reMmVFMTsqvg0L3ON8WwYOxwnDGWCu55bUHJ009CMldEJeBA+0j/boGOy9JW2CAu9okOjljxMsTIkVNC+pmjvJ1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733404890; c=relaxed/simple;
	bh=1ligVCx1ifx0pX3gynWyxNBonvwLTX9ZP+7H/cc2t2I=;
	h=From:To:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=DhFKnoqde5hMFYMPtavQaG09hh273EZdNEscsV2kAfdZSCFdU0V+hQEqHts1ncuCv6p7do4MGPmSh9mG0GObsvXeyEXbQEUurH5vQts6ZRHZxR+jmxCd2EHEFul+nWiOti/5FYHVZngBDdG6QhGg/MVY+JJoeOgcLX/aYCpLzgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=SU81Uukb; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=CjVTMOWc; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="SU81Uukb";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="CjVTMOWc"
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1733404886;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4kohpi8WkO8MFtN36Xm8qFuSCI+Bvog/Hsz7XJc7dng=;
	b=SU81UukbnLix65BFGfUQ5R045kgzyIZzUWC9drEUdhNCaNY2i4fdXJZZIsfsGN0Jjp+m+m
	7I/V+yeRlZf5OyR07HpxHdycV/YD0yu/oJhuxXlHgKSzxo2IWXmsbCgdkUEw5ag0PsD/BV
	9mSeqbqBk0jbz9xF0wcf9vOwAm1Zrb8ziELsKgSTmctveQ7y4c5lHrOqyVi94Ockb8f9Y5
	a9d7RZYaGieZOpatHRtjuEuRcwVYSUVegahOez72tHd3bZygVxthm/BCBehHfXlBabHydc
	aksi7P/yFG07LlJmCYGGVY533+g43bEk6tQjdDvnD5gvfGdM9Z0N3Nvda+8Tjw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1733404886;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4kohpi8WkO8MFtN36Xm8qFuSCI+Bvog/Hsz7XJc7dng=;
	b=CjVTMOWcCZgWi8tYgfp0bmTY0id3jaRIYy7lPElOF4ToaVho5QP88Tt74j7RTo1OrxJ9b6
	KtnsV0PF6XcjS7Cg==
To: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
 will@kernel.org, takakura@valinux.co.jp, sourabhjain@linux.ibm.com,
 songshuaishuai@tinylab.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 npiggin@gmail.com, naveen@kernel.org, mpe@ellerman.id.au,
 maddy@linux.ibm.com, linux@armlinux.org.uk, jonnyc@amazon.com,
 hbathini@linux.ibm.com, christophe.leroy@csgroup.eu,
 catalin.marinas@arm.com, bhe@redhat.com, aou@eecs.berkeley.edu,
 adityag@linux.ibm.com, farbere@amazon.com, akpm@linux-foundation.org
Subject: Re: +
 kexec-prevent-redundant-irq-masking-by-checking-state-before-shutdown.patch
 added to mm-nonmm-unstable branch
In-Reply-To: <20241204215939.EB364C4CECD@smtp.kernel.org>
References: <20241204215939.EB364C4CECD@smtp.kernel.org>
Date: Thu, 05 Dec 2024 14:21:05 +0100
Message-ID: <87o71qqn9a.ffs@tglx>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Wed, Dec 04 2024 at 13:59, Andrew Morton wrote:
> The patch titled
>      Subject: kexec: prevent redundant IRQ masking by checking state before shutdown
> has been added to the -mm mm-nonmm-unstable branch.  Its filename is
>      kexec-prevent-redundant-irq-masking-by-checking-state-before-shutdown.patch

Can you please drop that as there is a fix for this stuff upcoming which
needs generic interrupt core changes. And that fix should be reordered
as it is stable material. I'm going to take care of this set then.

Thanks,

        tglx


