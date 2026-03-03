Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71DC214AD20
	for <mm-commits@vger.kernel.org>; Tue,  3 Mar 2026 00:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772496853; cv=none; b=XxegRwhu/8NsJ4Qy8rZAvY+StFAEiCFYApbFm3ZGUEBNCXhKmCigfjVptxhWeYMAJ2FS8pxsfDvy0Po+S+UomAoCgxHV30WbuXE7RcyHx2ZtLmCQsWxvofsuiCD4bcIR1CCumo/PBR7z7hgD8xAS6OMPsy9+U52nbcuXX2P1ijI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772496853; c=relaxed/simple;
	bh=u3rTTFgE6dLn4UN1rggA67ZtDgzaclH4xp8kQqPnfoY=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=dVtSTvrgsQbqf5YAirzlJXFsEQ5jBL118M4MWdFpB1TSVwawwoMAgs07qpT3BncB8k9tPf1i03au/JZZuODA946KdIv0okkJeVUgAYMKOo9TyKyLPOn/hMsFLXZF2xG9WunBvJ9Qd83ZvDLEB0c+wYeiN4y8aBgslKsUFveUMuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rm3H38s6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rm3H38s6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8C36C19423;
	Tue,  3 Mar 2026 00:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772496853;
	bh=u3rTTFgE6dLn4UN1rggA67ZtDgzaclH4xp8kQqPnfoY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=rm3H38s6jOr9obSuDbOnIHjFmDI+i2+Pf6jjCdHBaEz+wLTB3lJ7rlywL8OBgm7q+
	 81lyub+D83ddC4fXlnxBxS5qF3t760LgQ1f4J9ukTiSslWHbCzVXcBz1y+0QG8H5c2
	 wMSMjmIoKFclsd1c0ka6HMXiWtXURkMfPL9p9YAY=
Date: Mon, 2 Mar 2026 16:14:12 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: mm-commits@vger.kernel.org, peterx@redhat.com, joshua.hahnjy@gmail.com,
 jhubbard@nvidia.com, jgg@ziepe.ca, dywoq.contact@gmail.com,
 david@kernel.org, aleks.koyf@gmail.com
Subject: Re: +
 mm-initialize-seq-in-gup_fast-to-remove-wmaybe-uninitialized-warning.patch
 added to mm-new branch
Message-Id: <20260302161412.f5e5c1944509449fb8b11ef9@linux-foundation.org>
In-Reply-To: <aaYl99AXj-mKHDbO@casper.infradead.org>
References: <20260302204309.E824DC19423@smtp.kernel.org>
	<aaYl99AXj-mKHDbO@casper.infradead.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 3 Mar 2026 00:06:15 +0000 Matthew Wilcox <willy@infradead.org> wrote:

> On Mon, Mar 02, 2026 at 12:43:09PM -0800, Andrew Morton wrote:
> > The patch titled
> >      Subject: mm: initialize 'seq' in gup_fast to remove -Wmaybe-uninitialized warning
> > has been added to the -mm mm-new branch.  Its filename is
> >      mm-initialize-seq-in-gup_fast-to-remove-wmaybe-uninitialized-warning.patch
> 
> This was a W=2 warning.  We don't usually fix those.

yeah.

I thought there was a more recognized way of enabling this, but it
seems I dreamed it.

otoh, there's value in having people privately testing W=2 - they might
find bugs, so making life better for those people also has value.  It
depends how much other noise the W=2 build creates.

<tries it>

./arch/x86/include/asm/text-patching.h: In function '__emulate_cc':
./arch/x86/include/asm/text-patching.h:183:36: error: declaration of 'cc_mask' s

immediate fail.   How are people even using this thing?
