Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795013148;
	b=WF4fd2KVQZ87tdEjR5FnZRmXSlcdBmq0ZB2WP37rnbksybiOYYJuYS60bCb+1hCC9iRz
	 hZSr7Li+WMACdFlwizwr1CpbyyVU1e0LvcnhwUo5CnJsN+ehvOFKcEbHQ7MSZzDKsVUyp
	 O+02EvRrIvupwDiBlDxkL3/0WNYfuQjMA9GB0fxfgnKIt3Wb3y3QWNlHN7M7JpaCWVb7Q
	 fJA4cpfD6ssEzA7FlDRrLM5K/R5suf0cpLG6vZ7AtOAgNRuVv2OkHsAk0rZUJdKpmSUDu
	 xwmPCq/8FebL1osOX2d23vhc6C//1+ORdSujTDlZxnU8OlZCALaNEiwpXCE1cVtK5OA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795013148;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=zNE7X+3DYW75uXYvfYY5UP1hFvDHIX7llYk/KG3aVlU=;
	b=G0MPuNw8/ouwXIHL1PhCxI9VrzLv4Qr7Jq3sz7v61YWSqdN98XOBh8x+9YuYLUI8eoOT
	 tgwt1nygSDM510f8VXmOTnSe9rNB+TMQxc2iQfqH7LDIC0lZpXE+OGlaHDZxm0o70goV/
	 Mim+QZ8hkyGJ8ZgK+c1ir59J54n4iK8L+O+T9HWq/JD9jP51gjFE+RwhqvAZ3QmInVhf3
	 +z41jNjETodzjqTynbMegOS3NaimM2SJFALCzBsekpoygxswiIcjZ4ocG7GPya+IeVs52
	 3Q+ffCFadgwDlSgZFQgCuiX3f8wDThBF8LR9MnmC4LvRCQuKXXwS+djHR/mFF7V39SQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=o2ixFF98;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id E975160A2602;
	Wed, 18 Nov 2026 14:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=o2ixFF98
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 0C6771F000C5;
	Wed, 18 Nov 2026 14:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795013147;
	bh=zNE7X+3DYW75uXYvfYY5UP1hFvDHIX7llYk/KG3aVlU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=o2ixFF98qQUeygoFJSlyX4IbJQ/IAEaxPrzHrLfaerXV9mT/CQuTaGeVSSZ4x1H91
	 wsfoDr4IgbksO2AuofRef/c2U2YUllzDW2mEMeC0GYfvvoMRPV2sjg3Zwji6gik8wF
	 W4RjHFkM9yMq7rmeuVkNhG9qwzKYz2FKHx4StovfwuW8A7xVODUQgzbMvldiL8Xxat
	 tO2RoLM4HaJ7gVlNWLpqhGIRUSZbXBPbRwwxTdnyQuRUjf2G7DEaFnrnpEsji52ecb
	 n2eSkN/jM1guxxu73VGY6f0kKuhCOABYoM0cz36HuzDStvsDOAd3PpEqiLVVOA+AUQ
	 sBaeGiNH8jADw==
Date: Wed, 18 Nov 2026 16:45:43 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	mm-commits@vger.kernel.org, stable@vger.kernel.org,
	dhowells@redhat.com, 4ncienth@gmail.com
Subject: Re: [merged mm-hotfixes-stable]
 assoc_array-discard-shortcut-when-collapsing-a-leaf-only-node.patch removed
 from -mm tree
Message-ID: <av26FwgpF8kJhr33@kernel.org>
References: <20261110064551.3EA5D1F008A1@smtp.kernel.org>
 <86f9796a-2d2f-4e5a-875c-d2714bd76c58@kernel.org>
 <avxh82yWCs_bQq_w@kernel.org>
 <20261117090657.4a69ab63152011076171883e@linux-foundation.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261117090657.4a69ab63152011076171883e@linux-foundation.org>

> > > to resolve this (or if it is still required).
> > 
> > I think you're right, thanks.
> > 
> > I temporarily removed the commits from my next mirror branch.
> > 
> > I'll go through this with time and re-push them later.
> 
> Thanks.  I've removed Daehyeon's patch from mm.git.
> 
> Here's the latest version:

Yeah, my problem is oversupply of improvements ATM; not complaining :-)
And I just fulfilled my new year's promise to empty my kernel backlog as
rootns namespace was the last remaining bullet (draining took 11
months). I guess next year goes scheduling all of this to kernel
releases.

Br, Jarkko
