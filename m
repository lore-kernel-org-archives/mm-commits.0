Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793124821;
	b=kcDyd9zoZyjQEgP5vhcSb6n6cINwBbCqk+IW9dZWf8RcdryxnuJ3frkJoX5TQhevr2TH
	 SqZNvNwKc6U4svd3wAibMfkhbH7gQoWtzBppaDL3lrnZTWzofbiImEZUgwtPyF9oQuPW5
	 mr8vGA7PDn+AvBsCdXpIHz4LGdYlvlO/wKyeGJoEm7e0aHTcN8xi2MuiA/ZY7VvZl7TeZ
	 vnzpeaA1DJOGlHgcGutnaKqakkoXV7GfFaJiwILYm7NHkSqQMghkX96MpKOImWvZ6LzPq
	 8X5/jemSR6FWMPb6fX3505wKUvzy0eVqMJKWuJhlCihBiKFXP5e90yZQ8SdNiqg76dA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793124821;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-Id:
	 In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=RAZ/iVl/fsmrBPqbCB4Psd2pgLF4V2Sco/QGegU0DJ0=;
	b=f12KG7ZvompN2ire7lKM49R3YhwSVHyxn9H/QSl40KLYo1CT1fXChyCPfAWoI2bRtd3n
	 bxZuruXR0zwdbNXIZhjnYBbhtkVP0NC1HHx0xybXzjo0hF3snQ1sSQj7qp0bjSB1IUpvs
	 Ieu0FdL8izduC9/NhhmjmSKB1H4qtyScw99Nzzjt2YlesdAT0PFNBNyniAnt0jMiVZvlP
	 86etaDJoDZ12pUJywlNRPIOpYtxyHc2VwiC2+zNdDU0AG9/eJ2+FFGa3WxAJsLEzeKktn
	 TuS8r6Rz6B3wTjFhT4T3MAkfllcSuQPaeE5mM+HBKb9oSu1LW+YjE9h+Z61OkcZ5pBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=SMNavOoT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CE3B606A31A;
	Tue, 27 Oct 2026 18:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=SMNavOoT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A67931F01825;
	Tue, 27 Oct 2026 18:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793124820;
	bh=RAZ/iVl/fsmrBPqbCB4Psd2pgLF4V2Sco/QGegU0DJ0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=SMNavOoTSyfbu8F5d5cSsawUeeQbX/GqsxpDqs1QFj47SFM+YzKty83KB4TCdUtEY
	 q0UN97F1tB2GTpN4F83h3SWR4Jy1ai3F9dUxu8MQS4CHNU/1zcu5JA7SHlXSGxPvTL
	 Jmnum7zBI0QWGLryCUPp3DlRZ00GHqBEefbwQ+iQ=
Date: Tue, 27 Oct 2026 11:13:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: mm-commits@vger.kernel.org, stable@vger.kernel.org,
 nickolai@csail.mit.edu
Subject: Re: +
 xarray-clear-the-new-heads-parent-before-freeing-the-old-head.patch added
 to mm-unstable branch
Message-Id: <20261027111340.b33f2ae190f4cdbf215b9193@linux-foundation.org>
In-Reply-To: <auDiZyUI490v5Pgm@casper.infradead.org>
References: <20261023181200.53AF01F01825@smtp.kernel.org>
	<auDiZyUI490v5Pgm@casper.infradead.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 27 Oct 2026 17:41:59 +0000 Matthew Wilcox <willy@infradead.org> wrote:

> 
> i said this patch wasn't acceptable with the commit message the way it
> was, and the very next mail i get is you taking it into your tree.
> please stop doing this, it really makes me wonder if i have any value
> left.

You said the code change itself was OK so I grabbed it for testing and
added a note "TBU (changelog)".

So it won't be going any further until that open issue is resolved.

