Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0E046A33B;
	Sun, 26 Jan 2025 21:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737926398; cv=none; b=fOS1VUnBDaN2r8VlitJHrQK3kofs4JWhajnt6K7TDVyXXTB2LKgopbVWCIi+J6j3BRVxmsay60iswJdzssWSkVgCvjaMOI5KMRj0bB/nrvGbd9C9ukLciTC5pHkbwpcffquoAd+gS5SZyYd3a7XXQx2I9e9s1ycAXhE0Rm0JJ4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737926398; c=relaxed/simple;
	bh=+F9bZN/Fxihk/I5XRnJzh2oDgn02+SkIjrk11Skejyo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aQ0hrAfs5hBOoybQgTk0OZhVg+06jlL93eB+gBf9YnLHf2xYm4VZuPaKlGvBBnnjI5zuKoeEpzcqpAv8Z1S03h8k76BOz5gbMnHMlFoIFd9GnEYzAnUUDFBzdhvAGqZVZ8wSTHszlpxqsHklKdZ2B1bUFc7+Quj9PPeexesJJFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=sE+lr97/; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sE+lr97/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=SP0H87our6hAcQr0Iut1rYjsavElxZJoRVBN900DLUc=; b=sE+lr97/U6vPHZ4reefqzuX1Kl
	ySkazPv7r+9W4OzK1B/pLlsL7QuMddR3u2NSRy5XKMa24uyl/sxRl5FGk7n0R2VFjLnXJkf+ka0ic
	Ugv6/YRhg9Z6XbIL778jdIuNonT1b+cvf2/lwCmAxS0D5dt1DB84UTt+oBrizXTkEX+7r5zpo9ytS
	6lGs6WgCJ8L87uSwJgVOmpsaIkj+QH2Y7xLVF7AMuUE0+pScUoxyXfWYTHXpRhIO/xFfv8VONOgvl
	466a1TL4E8n70dFFfpW6tvs3VUlRyNxK1Gxft5mU/iMxyfHhD+2D/EuZkTy2bwZ8ND4/6s6nueBSX
	f/CCAvMg==;
Received: from willy by casper.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tcA2j-00000008WRL-23IW;
	Sun, 26 Jan 2025 21:19:45 +0000
Date: Sun, 26 Jan 2025 21:19:45 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Uros Bizjak <ubizjak@gmail.com>, Miguel Ojeda <ojeda@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] MM updates for 6.14-rc1
Message-ID: <Z5am8bRw4lSJY8jF@casper.infradead.org>
References: <20250124162248.60104eec848619a187242392@linux-foundation.org>
 <CAHk-=whddBhfi5DUi370W3pYs+z3r2E7KYuHjwR=a1eRig5Gxg@mail.gmail.com>
 <CAFULd4ZWS4Cxv0CELosQHJh9vTqOJFdr+Fk9NMgSREr_dFG05A@mail.gmail.com>
 <CAFULd4a-2F_zKMeR0Yjo2WhRLmyoOQ1VdR2qdV34BrM-b_cQCQ@mail.gmail.com>
 <CAHk-=whgufZwjAuL1PBs1gjSMK95TEhGj1SiMbNvkysWBcEPMw@mail.gmail.com>
 <CANiq72mC7Fr6pB-D_JT9A2gCc2Yr0TLf16eRyY4_UWqRrKNVZg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANiq72mC7Fr6pB-D_JT9A2gCc2Yr0TLf16eRyY4_UWqRrKNVZg@mail.gmail.com>

On Sun, Jan 26, 2025 at 09:28:09PM +0100, Miguel Ojeda wrote:
> I will add a couple distro builds for linux-next in my matrix, one
> including GCC, so that hopefully at least you don't get blocked with
> something like this.

FYI, this was picked up:

https://lore.kernel.org/all/CA+G9fYuP2bHnDvJwfMm6+8Y8UYk74qCw-2HsFyRzJDFiQ5dbpQ@mail.gmail.com/

But, I guess due to the xmas break, nobody figured it out.  It even
went to the Rust list via Dan Carpenter's response.
