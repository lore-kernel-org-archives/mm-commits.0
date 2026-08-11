Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 163AD41CB5E
	for <mm-commits@vger.kernel.org>; Tue, 11 Aug 2026 08:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786438369; cv=none; b=X1kdqxdRhQRhUUv+841zd1aTApFiMybxTWq4I4AQS9FDs6QQiR/j69vCsql3fZ1yy7vjlPUaGaXjlioGmTyy4pYPg3SIoX8aqITKpRVZ1CVtNvWBQLKg622dkkKitrxPUPfMzE6yRYeCYZWIfbxkxvGwwntNYqMnzOgmivssffU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786438369; c=relaxed/simple;
	bh=1sT/8/bXGlgWWr8sT4d1akxiHSx5+WimWbSLwBHtz88=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ffsEtMvdTe9UKHDoxmaubY5EupZjvTuPQcaaylgPMoNIZaowCraCcmqPSSFvE3krkzhlpLJOHMkZZROrFXP3aY48gQ+yokiPavfRyPtcCumQFoOGPbA1n8hnAot+ztsKp1Z23VuPsABOYdtaeOfnAG/qaDptZJiXCfj6rKCYdSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=kXcYbnH7; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="kXcYbnH7"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 931AF1516;
	Tue, 11 Aug 2026 01:52:42 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 43A5F3F86F;
	Tue, 11 Aug 2026 01:52:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786438366; bh=1sT/8/bXGlgWWr8sT4d1akxiHSx5+WimWbSLwBHtz88=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kXcYbnH7pM2nuGcXXj7v4u44FrUkIEqCR4193OEnL7ib2Hl67f5ZIGEQ53iAGonaT
	 baDA4wNyaVa4GsEeju8jsESb6RRaXAkraLA8eOdIagVZWiCIPfXEUAoGebrmmmK+dN
	 b5437M9+lWTZ3vDuzN15NEVaWhur8rxA9OHeHn8A=
Date: Tue, 11 Aug 2026 09:52:42 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Breno Leitao <leitao@debian.org>, Matthew Wilcox <willy@infradead.org>,
	mm-commits@vger.kernel.org, kent.overstreet@linux.dev,
	bigeasy@linutronix.de, arnd@arndb.de
Subject: Re: +
 radix-tree-fix-kmemleak-false-positives-on-tree-head-reassignment.patch
 added to mm-new branch
Message-ID: <anri2rKW2gG28tXC@arm.com>
References: <20260705021240.79E101F000E9@smtp.kernel.org>
 <ako1sMPVu4dfQR4K@casper.infradead.org>
 <akuFSv7JaXo6M8gx@gmail.com>
 <akuT8pEjBKvByPlA@arm.com>
 <akuzsny_3EpxaPww@gmail.com>
 <akvW9RwjVmRnNzHM@arm.com>
 <akw4FspAoT60tQeu@arm.com>
 <akzZSIN5ALd8iH52@gmail.com>
 <20260810201814.52d1353d5c3f1ce27ba10186@linux-foundation.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260810201814.52d1353d5c3f1ce27ba10186@linux-foundation.org>

On Mon, Aug 10, 2026 at 08:18:14PM -0700, Andrew Morton wrote:
> On Tue, 7 Jul 2026 04:26:43 -0700 Breno Leitao <leitao@debian.org> wrote:
> 
> > > Anyway, a better diff for the first idea below. I need to do more
> > > testing and can turn it into a proper commit (if we don't deem it
> > > redundant because of the other min_unref_count).
> > 
> > Thanks for it. I've reviewed it and it looks sane.
> > 
> > I am also testing it on my side.
> 
> This went quiet.  I take it that we won't be proceeding with this
> patch, "radix-tree: fix kmemleak false positives on tree head
> reassignment", v2?

Yeah, I think the recent heuristics additions make this annotation
unnecessary. Well, Breno to confirm.

-- 
Catalin
