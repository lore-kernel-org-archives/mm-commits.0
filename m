Received: from server.lespinasse.org (server.lespinasse.org [63.205.204.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DC5826B2D6
	for <mm-commits@vger.kernel.org>; Thu, 27 Feb 2025 23:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=63.205.204.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740697618; cv=none; b=pqnyzkV7X9Jkd4wibMmL249lhM7NNo5bHnuNL0mjm6dgFTMthKXr1+XL758XkWblDUXDJLHBMHsxcmXhcEicdNeztiWoJVJBlb9cPIgxKOejVxmO52yCgK/nuivA7W6ked3AYgXIXYb45bx3u4uC1danEeheK8G60hwZYohviOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740697618; c=relaxed/simple;
	bh=7M7dZWSb43UfZJsble+3zDWDordLf3WtD6TpNzaqJD0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zkvm80vGRZfxMSdrKp2/1mu5fBdj6yv58PaYDVlFeevU+3cfXxbVTPdXfldx7d+OozWdRMeBwGk294KiOTv21V4MJsFrJDaW8z5U49TDElkLSagyokoxecRSdTaJlApOSp4p7REjoq7fqdlckzoShXJdyBU/ovMoX+xqM6DANRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lespinasse.org; spf=pass smtp.mailfrom=lespinasse.org; dkim=permerror (0-bit key) header.d=lespinasse.org header.i=@lespinasse.org header.b=h1grRNqF; dkim=pass (2048-bit key) header.d=lespinasse.org header.i=@lespinasse.org header.b=eU4DnXcW; arc=none smtp.client-ip=63.205.204.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lespinasse.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lespinasse.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=permerror (0-bit key) header.d=lespinasse.org header.i=@lespinasse.org header.b="h1grRNqF";
	dkim=pass (2048-bit key) header.d=lespinasse.org header.i=@lespinasse.org header.b="eU4DnXcW"
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed;
 d=lespinasse.org; i=@lespinasse.org; q=dns/txt; s=srv-213-ed;
 t=1740697197; h=date : from : to : cc : subject : message-id :
 references : mime-version : content-type : in-reply-to : from;
 bh=SkGD++vsMIHMNOxrw9bWlArzWjqIdXqJ2Pl5Bh+QClM=;
 b=h1grRNqFCIlSoPiKeCwJFMO6uH3+pIomk3rO169M4yuzB/RnqvT272gVyH7hNBEcWqE84
 qrJucM3jmCVM42oDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lespinasse.org;
 i=@lespinasse.org; q=dns/txt; s=srv-213-rsa; t=1740697197; h=date :
 from : to : cc : subject : message-id : references : mime-version :
 content-type : in-reply-to : from;
 bh=SkGD++vsMIHMNOxrw9bWlArzWjqIdXqJ2Pl5Bh+QClM=;
 b=eU4DnXcWLYmY1NFbA0mG04bP3dl13yuNx/RFCj5uNR/5RIYzNc7iGcXXXk22JYhGv5lnd
 zPlYwwJ5k8stAUQGE5IXGyQ4xCtLml6lDRnemsaPUyhO6XNrA+8w/rrdBHzrIQ0yYtDnjWZ
 nqftZ3VYZ5BkHUqff9ff+R2ghdx5NnjfpRaC3rBU6TiG6+Vjff04PDjsOeN3YFIKNJjj8el
 kE1SyWBE8+sXJmjAK8s7jMsHno5yrOh3cxN3+MYYMLqFHs8p8LdwGA9u9IrLEboUZRmHmb8
 azbsjgoYFRVATj8TcZyWxHcntZWAjdyYiR6OL2cV1oBxkQAtBwixIokp3fqA==
Received: by server.lespinasse.org (Postfix, from userid 1000)
	id 3537C10007D; Thu, 27 Feb 2025 14:59:57 -0800 (PST)
Date: Thu, 27 Feb 2025 14:59:57 -0800
From: Michel Lespinasse <michel@lespinasse.org>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	mm-commits@vger.kernel.org, michel@lespinasse.org
Subject: Re: +
 lib-interval_tree-skip-the-check-before-go-to-the-right-subtree.patch added
 to mm-nonmm-unstable branch
Message-ID: <Z8DubWlhB5K4WgGG@lespinasse.org>
References: <20250225042234.AC256C4CEDD@smtp.kernel.org>
 <Z725ERN5KDAANgD6@casper.infradead.org>
 <20250226022233.wjvxv2o6672vhkky@master>
 <Z76ZoxcFUIBSu63a@casper.infradead.org>
 <20250226131913.ugcy7ujy4rbohykb@master>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250226131913.ugcy7ujy4rbohykb@master>

On Wed, Feb 26, 2025 at 01:19:13PM +0000, Wei Yang wrote:
> On Wed, Feb 26, 2025 at 04:33:39AM +0000, Matthew Wilcox wrote:
> >On Wed, Feb 26, 2025 at 02:22:33AM +0000, Wei Yang wrote:
> >> On Tue, Feb 25, 2025 at 12:35:29PM +0000, Matthew Wilcox wrote:
> >> >On Mon, Feb 24, 2025 at 08:22:34PM -0800, Andrew Morton wrote:
> >> >> The patch titled
> >> >>      Subject: lib/interval_tree: skip the check before go to the right subtree
> >> >> has been added to the -mm mm-nonmm-unstable branch.  Its filename is
> >> >>      lib-interval_tree-skip-the-check-before-go-to-the-right-subtree.patch
> >> >
> >> >I don't think this patch should be added.  There's no claim of any
> >> >performance win.  Wei has a long history of tweaky little patches that
> >> >may or may not be buggy.  The interval tree has been around a long time
> >> >and doesn't have a test suite.  This feels like unnecessary risk.
> >> 
> >> Your concern is understandable. A change in fundamental data structure should
> >> be very careful. But I thought we don't take things personal.
> >
> >This isn't personal.  It's noting your history.
> >
> >If you want to add a test suite for the interval tree to the kernel,
> >that would be a useful set of patches.  And it would remove my concern
> >if we can demonstrate that we've exercised the code paths that you're
> >modifying and everything is fine.
> 
> Sure, if my understanding is correct, the test suite is supposed to be put
> tools/testing/, right?

(I accidentally sent this privately at first, resending publicly now)

I haven't touched the code much since I originally wrote it, but I
think the logic of Wei's patch is sound.

Even then, I agree a more robust test suite would be nice. There is an
existing suite at lib/interval_tree_test.c, but it's more oriented
towards performance testing that correctness. It would be nice if it
checked the interval tree invariants (i.e. that each node's ITSUBTREE
is the max of its ITLAST and its children's ITSUBTREE) between
operations, like lib/rbtree_test.c check_augmented() does.

I know many people don't like test suites that involve randomness, but
personally I think verifying that inserting 1000 random nodes works as
expected, and repeating that test 10000 times or so, should give
reasonable confidence in this code.

--
Michel "walken" Lespinasse
