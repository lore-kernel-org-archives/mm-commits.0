Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C9472C3242;
	Mon,  2 Jun 2025 19:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748891872; cv=none; b=udCk3vgdrqsg+YKjHEcKaPk9peQovTYiPXUjA9OwgQQ12jByAnlQcXw4W4K3Wuwvu+mO5m3mteRsnd5cvyGCgpkJHi3ZMUMCoTWYE5H6JEigZY+mGGPbts9rYOjj8eggTUvcuV84UHytsMA4Mg7r11P/bwhKmrkKLFbrXecGmE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748891872; c=relaxed/simple;
	bh=JbBE2BSt4IuIp/mHpK/1woVzzTCCuTRSikmM/SfpxhY=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=rkfaiAqqrbY13Kb46XvtuPTU45XRIouZ2hgceSiJKM1IhSjs/Rhbchj9LikkH7RJZ5Hk5ZT3OCtnnu+kXekRJkor5TkNMOfn9Odwwg4eNz/fMDV3vnYo4c/dSghYrQ9EL2Y2cbt3k0k4LVnK4708ZAIve7N5WyGPHnNOcwsfR34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RPrYj70D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RPrYj70D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCDB7C4CEEB;
	Mon,  2 Jun 2025 19:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748891872;
	bh=JbBE2BSt4IuIp/mHpK/1woVzzTCCuTRSikmM/SfpxhY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=RPrYj70DmEmC7GBiB8PpxtPpU/sbGbi6aG9rrPIRKVx7x62oNDMBzL3sdd6zk3AfA
	 JnimY6oTs8hWj0hO1nCK76iCMRfVhK8g7IZG4g3OyCZat2uwoQuoMBHdqb8KjZ42T1
	 2r2AxubAjvJN+V0z5Sft2RiPFyUJrOzvVsWAzHeA=
Date: Mon, 2 Jun 2025 12:17:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
 mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Additional MM updates for 6.16-rc1
Message-Id: <20250602121751.53ee502779a2f746404a3548@linux-foundation.org>
In-Reply-To: <aD29wnb5zR-afWpM@casper.infradead.org>
References: <20250601151222.60ead71e7d8492a18c711a05@linux-foundation.org>
	<aD29wnb5zR-afWpM@casper.infradead.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 2 Jun 2025 16:05:38 +0100 Matthew Wilcox <willy@infradead.org> wrote:

> On Sun, Jun 01, 2025 at 03:12:22PM -0700, Andrew Morton wrote:
> > Linus, please merge this second batch of MM updates for the 6.16-rcX cycle.
> 
> A word of warning for Linus since he wouldn't've been cc'd on the
> earlier email.  This branch is based on v6.15-rc6 but contains a
> commit which depends on 97dfbbd135cb which was merged during the
> current merge window.  You might want to do a rebase or ask Andrew to
> do it in order to prevent a bisection hazard.
> 
> 0day-ci found the problem here:
> https://lore.kernel.org/linux-mm/202506022027.IYQzZghL-lkp@intel.com/

I think it's OK?  I did the merge and 

	d9736929445e iov: remove copy_page_from_iter_atomic()

lands later than

	97dfbbd135cb highmem: add folio_test_partial_kmap()


