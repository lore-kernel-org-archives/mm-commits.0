Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82BC3416119
	for <mm-commits@vger.kernel.org>; Mon,  6 Jul 2026 14:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783349625; cv=none; b=d8uEZ8C2cogBsXhBWwqQrbL5Rg7Fylx+dXg7CqjK2uIP7xrenCFud0ns8DlvJdP+Z+NiZhn8qKEr9gnrq8o3hwt/2+wPwfNlqNB8ya7s2a8McVLCH78Ixg0ieDcVjHUmkWQCeBl5cNfuJdPO1UIAFiCV6+CIhe0296Z+38FyWdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783349625; c=relaxed/simple;
	bh=Di88XYwq89uePb2t4bhLGo2ZIPfXKAlCYJ0aGLx1yO0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q/3G+eMsqE1PjuhP9DA5OmQYgcaDSsq3WEcGOmGLMuLNfF6gNdzzlWbUuMtDgwJiGATO0HX1JXWQxPISPs8YrtB17tSaaSHHU3TaNFlPfbaXIh92558AP6PruQSfJofdNBFcPlhrO61SBGZ02bZ/ifbXU4ZI627vt5XTcbZ5Qow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=rffJPdYn; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="rffJPdYn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Reply-To:Content-ID:Content-Description;
	bh=nw2xksJ2l//O0s6ziBwMLeloW9mcv8S1MEOytpW4ojQ=; b=rffJPdYnTjZX+599eGMXvo5lNZ
	vjJ7B7yYU89EG7UxPyOqA8DHOk5/EC4CsHamRWHjpKugJk1Dp0XNYWwtRvpU1T7M7MJr+pohE3Q/W
	VWHY5CNgG1Crc1bEbxNe4Cxg3yjGSKeeNBlY3ZKndLwWyjU5Lt4U4UoXHV31z7PxTmpG7jwGz5i6I
	BFED0iLr868bH7zqlaRRQTYyXiN1Pv1hQO6lfbnvaWuPRePWaXePuDrTeq+lNCx6fqk4uzF6OEcui
	Ps7MMTtlfcegD2aGR5vJL+s/au/aFslBFuvcyEqbFEN5uIF0NREHpYngcbEhD/iUxHRhyeb/7gMZd
	HGMcNiCw==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wgkhU-001UiR-0E;
	Mon, 06 Jul 2026 14:53:36 +0000
Date: Mon, 6 Jul 2026 07:53:30 -0700
From: Breno Leitao <leitao@debian.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Matthew Wilcox <willy@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org, kent.overstreet@linux.dev, 
	bigeasy@linutronix.de, arnd@arndb.de
Subject: Re: +
 radix-tree-fix-kmemleak-false-positives-on-tree-head-reassignment.patch
 added to mm-new branch
Message-ID: <akuzsny_3EpxaPww@gmail.com>
References: <20260705021240.79E101F000E9@smtp.kernel.org>
 <ako1sMPVu4dfQR4K@casper.infradead.org>
 <akuFSv7JaXo6M8gx@gmail.com>
 <akuT8pEjBKvByPlA@arm.com>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <akuT8pEjBKvByPlA@arm.com>
X-Debian-User: leitao

Hello Catalin,

On Mon, Jul 06, 2026 at 12:39:30PM +0100, Catalin Marinas wrote:
> On Mon, Jul 06, 2026 at 03:41:54AM -0700, Breno Leitao wrote:
> > On Sun, Jul 05, 2026 at 11:45:04AM +0100, Matthew Wilcox wrote:
> > > > Add a matching kmemleak_transient_leak() stub to the radix tree test
> > > > harness so the userspace lib/radix-tree.c build keeps building.
> > >
> > > Last time this was proposed, the suggestion was that kmemleak needed to
> > > be fixed.
> > >
> > > https://lore.kernel.org/all/aCyI8T2sWlPLEYZ_@arm.com/
> > 
> > My understanding from that thread is that kmemleak could be made more
> > reliable by explicitly waiting for a rescan before reporting (which it
> > is a great addition).
> > 
> > This patch explictly tell kmemleak that this object will be temporarily
> > unreferenced, which is more cooperative.
> > 
> > That said, I believe both approaches. This transient-leak annotation and
> > Catalin's earlier proposal—can coexist as complementary mechanisms to
> > reduce kmemleak false positives (which has been my goal, given I run
> > kmemleak-enabled kernel at some scale)
> 
> I'm not happy with the transient leak annotations either but couldn't
> come up with something better. The last year's proposal to reset the
> checksum pretty much forces it to go through one more scan, something
> your patches already do, though maybe we could change the default.
> 
> I wonder whether we should force the scanning to happen twice in a row
> and drop the min_unref_count. Those transient leaks happen because of
> some micro/milliseconds miss of a pointer. If we have new white objects
> of the end of a scan, go one more round through the root and gray
> objects (but do not reset them to white) and only then report the leaks.
> If the white objects have been reported already or we don't have any
> left, skip this additional scan or bail out early. We could have a
> tunable for this one to go 2-3 times if needed, though I guess twice is
> sufficient. The interface is also preserved as you do an echo scan only
> once (or twice initially with the checksum calculation).

That is a good proposal, and I am happy to hack it up.

On the other side, I _think_ we want to have both approaches
(your rescan-after-white) and min_unref_count. They serve different
purposes. This is how I see them serving different purposes:

1) This rescan-after-white proposal:

  Target: Developers that cat manually scanning for leaks when they
  develop something.

    a) The goal is to produce a memory leaks after the scan is done.
    b) Latency is more important than false positives
    c) min_unref_count = 1

2) min_unref_count 

  Target: Production servers running kmemleak on some cloud "probe
  points", where the service will run for hours/days.

    a) Latency is not important (system is automatically deployed and
    tested)
    b) False positives is heavily undesirable. It causes an alarm to get
    some engineer to investigate.
    c) In this case min_unref_count will be super high (>10)
      - I.e, just report when you are pretty sure this is a real issue.
   
Anyway, that's what I'm seeing from my angle. Let me know if I'm way
off.
