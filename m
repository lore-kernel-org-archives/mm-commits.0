Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44FF421519F;
	Mon,  9 Dec 2024 08:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733733546; cv=none; b=Bu4jcPMqWvR5aDwaBEF9bPTE8cadTn3pu3AXf90T9Wy58Mp99aHWxhBQhgj+in4L+F7ZEnWZnZJlIFE/DCYxBpJPSWsiZ2oXiQLPBDcLn6MCheU9C9fgInekD3saPxn/bDqKC9YBKnz737oHgn7YFV8iEK+4PIoymV5qgz5IYPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733733546; c=relaxed/simple;
	bh=SPncf33Av9UZ6RJFqTB9SPNNJ01DbjDnvIfiqk9IO7A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YU1MTrxPE5ScN024revz4ieC9UU+BNzIosG8//tRIQqLj3iztD1kqtkSAVSNcTjKHsBStn2Ut6B8JLgppdJ4YuKk5hHoGmximsk/wxPSkto6GfnFaPFttjZb6xegUysJ26IHq0sI2xkPVGFC1S23Posx0RV1BlI7mHRus6VzcP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Z4D6/uW6; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Z4D6/uW6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=7kZGkmmKTj6T8igwuKlINqiucEaDDw3QiewWTsPTCvU=; b=Z4D6/uW6tjFlfHIFIx5rL6cCap
	6/mmsa48Nic7Kv1a7ZhRggcepXOSbqNDZmLJ0bJRuhXUlONFgrhN3wfhCELcTOKvTNfzzcoFh/FMw
	R7w/VJeq2w/Pg8mNF0vJGfq4761hE9ynUrxU1xXhWQHxZhjL8BgVHfhy3tjQTZlHHTe3oTA+4kPfW
	2TytraR3vPw+KsgoLX7CUofiEjyjqmxTASrydcjbJjhPnRC+Dd43iQP6GpUCaFdiMws1ong0Zx9t0
	EONPhLj94LZ08PAOhRjym9nTBnE8kN2DBJx98/gVjheYv/Is8lVmbzDuab8CcFEju6L23Wxv/yBfX
	Vz6ko+Ag==;
Received: from 77-249-17-89.cable.dynamic.v4.ziggo.nl ([77.249.17.89] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tKZHX-00000003Vd7-3CQy;
	Mon, 09 Dec 2024 08:38:20 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 5DDD83003FF; Mon,  9 Dec 2024 09:38:18 +0100 (CET)
Date: Mon, 9 Dec 2024 09:38:18 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Rapoport <rppt@kernel.org>
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
Message-ID: <20241209083818.GK8562@noisy.programming.kicks-ass.net>
References: <20241106010048.77E63C4CED1@smtp.kernel.org>
 <ZysRwR29Ji8CcbXc@kernel.org>
 <20241205084128.GH8562@noisy.programming.kicks-ass.net>
 <Z1LUZJdsDHrSV6oE@kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z1LUZJdsDHrSV6oE@kernel.org>

On Fri, Dec 06, 2024 at 12:39:32PM +0200, Mike Rapoport wrote:
> Hi Peter,
> 
> On Thu, Dec 05, 2024 at 09:41:28AM +0100, Peter Zijlstra wrote:
> > On Wed, Nov 06, 2024 at 08:50:41AM +0200, Mike Rapoport wrote:
> > 
> > Anyway, while noodling with all that, I think there's a fairly
> > fundamental error in all of this. The mem->rw_copy should not be a whole
> > second allocation, it should be a (page granular) RW alias of the
> > (large) ROX map.
> 
> I've made mem->rw_copy an allocation because Andy raised a concern [1] that
> we'll have an executable mapping of semi-formed code. 
> With an actual copy rather than an alias the ROX pages contain invalid
> instructions up to the point we're through with relocations and
> alternatives patching and the actual code appears in ROX mappings in one
> go.
>  
> [1] https://lore.kernel.org/all/a17c65c6-863f-4026-9c6f-a04b659e9ab4@app.fastmail.com

Right, but at the same time he also calls out the problem with this;
you're now forced to carry two pointers, one to indicate where the code
is going to live and one to actually read/write to.

(Not to mention the disparity of module_writable_address() only implying
writes, but in actual reality it is required for reads too.)

Pushing this dual pointer through all the pre-existing code that
rewrites our code is done haphazardly and incomplete (and is quite
ugly and error prone -- as evidenced by my ADL's current inability to
load modules).

He also then goes on to suggest a better approach would be to remap
inplace to RW and back to RX.  Now the problem with this is ofcourse
that the remap to RW will shatter the large pages we're so very keen on
preserving, but this can be rectified at the point where er remap back
to RX -- it's just that the current code does not.

All in all, I really don't like the place where we've end up, it is
quite horrible :/

