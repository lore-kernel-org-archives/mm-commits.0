Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5A222F745E
	for <mm-commits@vger.kernel.org>; Tue,  3 Feb 2026 07:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770104644; cv=none; b=JFeyuDsTOJRvl9Y5tA8VVWi0dY5rogOtk+o1D0OW7UCWoVGXIVx3qG4CFYHykcy9hf5w51/RXW2+zTY9RvwDovyRHH1SZ0KbZz0Bi84Bq3+rg2D3IyBV8Rvwt0UExf65NytKbR1xTomBNyir0jOCTl4i/pVp8aD5XiDm3gGlH5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770104644; c=relaxed/simple;
	bh=oFgfLAZ/IOIFOyrCSdwIt3C2ZXGMzoBOQqSueXBNLvM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DLsFp/B3O0oZ3/7fHGq0+iGRDYsMHUhUAUqetp6bV7cTVI8L5/yLuie+5b9BYKfwMda3IyudqsoGQMxLFldhS7WEcr8r8iA6/OT5ZyIeJChqkn6ALpoeeguR5trYwHv9j0dsqjuZyrIoHe05amtMSFhIK2dQtXp/mDKi1k616QA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K7Rdr3qS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K7Rdr3qS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB9F2C116D0;
	Tue,  3 Feb 2026 07:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770104644;
	bh=oFgfLAZ/IOIFOyrCSdwIt3C2ZXGMzoBOQqSueXBNLvM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=K7Rdr3qSqvsZiz6b6rVHCCmnL3cOqs0b5+MbpYv9mvKPftzm0ui0uO0Z7Z5qnegDL
	 mMKeqEBU3k9zOnaqMdCI9FsyYZ4RX0jvZIdPEA1ZvY7XIXrtDyGQMMJE4X/Je1hGGh
	 GzSAcvuSQF59qc5GBtoATkm99+ENlP2sv9gT/Q6agbxoDjUxfRO8zN5fFNVDOyArra
	 58qbr74wWT+gDx5sRY9Kn9VlbvwSvtP6rzAV0Jwhfz9pMQanu39ejVVasF5VC4gyMl
	 RwS8c9lH1+VVfOykqiTrcZUTj0UHK/p3i2ZmHnYsMsA41LlpHY8chEcRJFyvSVhg5x
	 uKgvJv/isBF2Q==
Date: Tue, 3 Feb 2026 09:43:52 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, vishal.moola@gmail.com,
	songshuaishuai@tinylab.org, samuel.holland@sifive.com,
	rdunlap@infradead.org, pawan.kumar.gupta@linux.intel.com,
	palmer@dabbelt.com, mingo@kernel.org, lirongqing@baidu.com,
	leitao@debian.org, kevin.brodsky@arm.com, kees@kernel.org,
	fvdl@google.com, elver@google.com, cuiyunhui@bytedance.com,
	corbet@lwn.net, bp@alien8.de, bjorn@rivosinc.com,
	bhelgaas@google.com, arnd@arndb.de, aou@eecs.berkeley.edu,
	alex@ghiti.fr, ruanjinjie@huawei.com
Subject: Re: [merged mm-nonmm-stable]
 riscv-kexec-add-support-for-crashkernel-cma-reservation.patch removed from
 -mm tree
Message-ID: <aYGnODFtgjyiRLB9@kernel.org>
References: <20260201001710.A3CE5C4CEF1@smtp.kernel.org>
 <aX9jPbkG7QYNWH73@kernel.org>
 <20260202125404.343361f6696777efc3acaab1@linux-foundation.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260202125404.343361f6696777efc3acaab1@linux-foundation.org>

On Mon, Feb 02, 2026 at 12:54:04PM -0800, Andrew Morton wrote:
> On Sun, 1 Feb 2026 15:29:17 +0100 Mike Rapoport <rppt@kernel.org> wrote:
> 
> > > From: Jinjie Ruan <ruanjinjie@huawei.com>
> > > Subject: riscv: kexec: add support for crashkernel CMA reservation
> > > Date: Mon, 26 Jan 2026 16:07:38 +0800
> > 
> > I commented on almost identical patch for arm64 
> > 
> > https://lore.kernel.org/all/20260126081334.699147-1-ruanjinjie@huawei.com/
> > 
> > about moving the exclusion of CMA regions into the core crash code.
> > The same comment applies to this one as well. Sorry I didn't mention that
> > more explicitly.
> 
> Thanks.
> 
> So IIUC this patch is OK, but we should reduce the code duplication in
> this area?

The patch is Ok in the sense it does not break anything :)

I'd like to see series with PATCH 1/3 moving the duplicated code from x86
and powerpc to the crash_core.c and patches 2 and 3 adding arm64 and riscv
support for CMA.

Requiring refactoring upfront rather than fixing this afterwards makes
maintainers life easier ;-)

-- 
Sincerely yours,
Mike.
