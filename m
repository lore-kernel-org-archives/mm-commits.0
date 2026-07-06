Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D748B346E59
	for <mm-commits@vger.kernel.org>; Mon,  6 Jul 2026 11:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783337975; cv=none; b=pHUSkv/M6P70TIZEz6pCfdofh/1eHiXs54ZYMUiHq8mAFitbmZelns3YhBLwIxFF/DPcyl6exD+vdmZCJeNp7DtzEf534X1ABH7Y7eAdzYxBgbBID+oLSs61JqJveywXB+5Ypai4J/tYMqUN/zYd5NS2ZtIy89d4Va/RVI74Kxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783337975; c=relaxed/simple;
	bh=YVBTtMT2du2xluNR7fZH3LJHEsEZ42DEWW3zpSe5PXg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DUANUXWt62vA/0oYd82AOAh+US7vdFC0ckqr+h+fShz0ZyUR7AHjmeLXxj8WVhuA9t6PNJNpF1dSv+ZH5X0MW1JXB6Fb+FYllSNt5TYXXOdBI8GdKhlyozD1zf5ij3OxrTe2OyR5zt61p2ziq3WyI1j8cQbJ4lvBFpkkblHd0bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=kB0FO0l6; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="kB0FO0l6"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9201D1D13;
	Mon,  6 Jul 2026 04:39:28 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D537F3F7B4;
	Mon,  6 Jul 2026 04:39:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783337972; bh=YVBTtMT2du2xluNR7fZH3LJHEsEZ42DEWW3zpSe5PXg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kB0FO0l6NIY8qRutrxljD1+FABNgrebJjlLqkla0PlxtXNd5B77Lkd29HSqRZSpPX
	 kIrTR/h+FkmPgmQerH083A7Uj5VmQyeHikTCI5RE0R9lO85AXEgs12ZruPBwNUfKhh
	 rsdqtwKMke1EBJ/xOWYB7w73JrKsFxk1BZdz2gJg=
Date: Mon, 6 Jul 2026 12:39:30 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Breno Leitao <leitao@debian.org>
Cc: Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	mm-commits@vger.kernel.org, kent.overstreet@linux.dev,
	bigeasy@linutronix.de, arnd@arndb.de
Subject: Re: +
 radix-tree-fix-kmemleak-false-positives-on-tree-head-reassignment.patch
 added to mm-new branch
Message-ID: <akuT8pEjBKvByPlA@arm.com>
References: <20260705021240.79E101F000E9@smtp.kernel.org>
 <ako1sMPVu4dfQR4K@casper.infradead.org>
 <akuFSv7JaXo6M8gx@gmail.com>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <akuFSv7JaXo6M8gx@gmail.com>

On Mon, Jul 06, 2026 at 03:41:54AM -0700, Breno Leitao wrote:
> On Sun, Jul 05, 2026 at 11:45:04AM +0100, Matthew Wilcox wrote:
> > > Add a matching kmemleak_transient_leak() stub to the radix tree test
> > > harness so the userspace lib/radix-tree.c build keeps building.
> >
> > Last time this was proposed, the suggestion was that kmemleak needed to
> > be fixed.
> >
> > https://lore.kernel.org/all/aCyI8T2sWlPLEYZ_@arm.com/
> 
> My understanding from that thread is that kmemleak could be made more
> reliable by explicitly waiting for a rescan before reporting (which it
> is a great addition).
> 
> This patch explictly tell kmemleak that this object will be temporarily
> unreferenced, which is more cooperative.
> 
> That said, I believe both approaches. This transient-leak annotation and
> Catalin's earlier proposal—can coexist as complementary mechanisms to
> reduce kmemleak false positives (which has been my goal, given I run
> kmemleak-enabled kernel at some scale)

I'm not happy with the transient leak annotations either but couldn't
come up with something better. The last year's proposal to reset the
checksum pretty much forces it to go through one more scan, something
your patches already do, though maybe we could change the default.

I wonder whether we should force the scanning to happen twice in a row
and drop the min_unref_count. Those transient leaks happen because of
some micro/milliseconds miss of a pointer. If we have new white objects
of the end of a scan, go one more round through the root and gray
objects (but do not reset them to white) and only then report the leaks.
If the white objects have been reported already or we don't have any
left, skip this additional scan or bail out early. We could have a
tunable for this one to go 2-3 times if needed, though I guess twice is
sufficient. The interface is also preserved as you do an echo scan only
once (or twice initially with the checksum calculation).

-- 
Catalin
