Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 327471DF99A;
	Fri,  6 Dec 2024 10:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733481593; cv=none; b=acKMSq9AIN51ayWMjG+0m+3hboiYR04tKraZFrgnEuXhRZ1zvVCQxh8JOnT3qczR/C4hxJoUICY3cZL4hunX9Fo2dxE0hH1S8K0nGqObkefp78HMPnpekmu1KzSyGZ0sRnosDd6plnUlQLDZ0zyebECNZKako2J6IfItTeDLhCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733481593; c=relaxed/simple;
	bh=jLBId6NXc0HZN+P13xArDXyMyR2VhzC42KAKwekU1TI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YuLrt8+Ju6bx2dgXk5lNP6thdEHN/N5YjUiNrQv74EbIAcBfh5d4yFzv6dUlO7Dx1ma+FMxyvsP5beveEdL7qbyH8/bI2AC/cCuYHTi8LYwOiEKvTshb+6x4kTwKdjTjVBjqg6PyqdtevigVJiLR+TE6wudf/oNCTb2bXchSLds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=usSzJt+w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="usSzJt+w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D802C4CEDF;
	Fri,  6 Dec 2024 10:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733481592;
	bh=jLBId6NXc0HZN+P13xArDXyMyR2VhzC42KAKwekU1TI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=usSzJt+wrL10fPtC4/BcjOwEdgpAfvDsB6btBtb3nV/T8F/7R+JLt353wKIWGhtKr
	 u/hyssIGwmdkJySWM/2KO+sK6XU4ZnyM1R4tS0BAi++gAItJgXKBJkmdadSAP9nUOF
	 +wx3YdiXmM3XhSnIGQ6MR4qR540iPBkBpSna9NLmC9bj4ekcR7g6ghrMhjkUPWIhAq
	 A/b3j5ylmZOcrg/7jo8wV63TppUIUEgoS4C6ZA630Olj+3eDnsexdjpNRV5mrJmmnd
	 QIPhKHb6hyWTJLVLiX4hkxRR2Ypt1VRxE0VxVb+SOXSB4AgFm4NJ7vrf4TR/6oGrV5
	 DuzNkHE1CkOcg==
Date: Fri, 6 Dec 2024 12:39:32 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
	will@kernel.org, vgupta@kernel.org, urezki@gmail.com,
	tsbogend@alpha.franken.de, tglx@linutronix.de, surenb@google.com,
	song@kernel.org, shorne@gmail.com, rostedt@goodmis.org,
	richard@nod.at, palmer@dabbelt.com, oleg@redhat.com,
	mpe@ellerman.id.au, monstr@monstr.eu, mingo@redhat.com,
	mhiramat@kernel.org, mcgrof@kernel.org, mattst88@gmail.com,
	mark.rutland@arm.com, luto@kernel.org, linux@armlinux.org.uk,
	Liam.Howlett@oracle.com, kent.overstreet@linux.dev,
	kdevops@lists.linux.dev, johannes@sipsolutions.net,
	jcmvbkbc@gmail.com, hch@lst.de, guoren@kernel.org,
	glaubitz@physik.fu-berlin.de, geert@linux-m68k.org,
	dinguyen@kernel.org, deller@gmx.de, dave.hansen@linux.intel.com,
	christophe.leroy@csgroup.eu, chenhuacai@kernel.org,
	catalin.marinas@arm.com, bp@alien8.de, bcain@quicinc.com,
	arnd@arndb.de, ardb@kernel.org, andreas@gaisler.com
Subject: Re: [merged mm-stable]
 x86-module-prepare-module-loading-for-rox-allocations-of-text.patch removed
 from -mm tree
Message-ID: <Z1LUZJdsDHrSV6oE@kernel.org>
References: <20241106010048.77E63C4CED1@smtp.kernel.org>
 <ZysRwR29Ji8CcbXc@kernel.org>
 <20241205084128.GH8562@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241205084128.GH8562@noisy.programming.kicks-ass.net>

Hi Peter,

On Thu, Dec 05, 2024 at 09:41:28AM +0100, Peter Zijlstra wrote:
> On Wed, Nov 06, 2024 at 08:50:41AM +0200, Mike Rapoport wrote:
> 
> Anyway, while noodling with all that, I think there's a fairly
> fundamental error in all of this. The mem->rw_copy should not be a whole
> second allocation, it should be a (page granular) RW alias of the
> (large) ROX map.

I've made mem->rw_copy an allocation because Andy raised a concern [1] that
we'll have an executable mapping of semi-formed code. 
With an actual copy rather than an alias the ROX pages contain invalid
instructions up to the point we're through with relocations and
alternatives patching and the actual code appears in ROX mappings in one
go.
 
[1] https://lore.kernel.org/all/a17c65c6-863f-4026-9c6f-a04b659e9ab4@app.fastmail.com

> That also gets rid of that whole copy operation.
> 
> I'm having to chase a few regressions of my own first, but after that
> I'll look at reworking all this.

-- 
Sincerely yours,
Mike.
