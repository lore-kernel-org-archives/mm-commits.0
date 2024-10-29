Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8B7B1DD543;
	Tue, 29 Oct 2024 04:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730176695; cv=none; b=qS2TaOcin4J3iDOT6LTxijAYZJ+G/CfgyPoORy5HRE3FhiXIKa7teNzqLplBmcj56G3hRDuLQoG+it9qEKQE5dm9dau1wIq3czceW0LaivoJQNrUcnwqhFaBhhyPo5UGQStKr+C615cyrRoHnVOQ9w1pjH292RPPZuKNEzh7Frg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730176695; c=relaxed/simple;
	bh=+IRtR0eRYdMflE+S4aK+4d21w0hTDB7iwJgSdIEgVdw=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=UHzOlWFArmw3vjLC3wJ/rga70N8/KopcAKoCCsWSOTGDJaMcTlxxrWwdnKIuRb9z1Z0gI/GS2qJGrBuw6kz32nUG2H9hN/U6e8d7dpgBRBtrmap+xFSmhIw5acpAlIkFSOyD4JPEtQMlqQk+0k/TdcQP8yUaIfRzVxSIixIl8A8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vkanm3kd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vkanm3kd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 047A2C4CECD;
	Tue, 29 Oct 2024 04:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730176695;
	bh=+IRtR0eRYdMflE+S4aK+4d21w0hTDB7iwJgSdIEgVdw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=vkanm3kdRQ7eOddJC71hdSA0RMWSUBNXFu9IYsad9+czvIpTMYY9zCXVgw6qpBsF7
	 83qXJADI+8yT+4OK8YduafSgxunp8HrRguZm+F9NvHUteN89M54kvsvcyy8DBd6a/U
	 LrEDURm35Zz0BIU6zbeC5qEEs5Aw1p6XsF98byKs=
Date: Mon, 28 Oct 2024 21:38:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: John Hubbard <jhubbard@nvidia.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
 <mm-commits@vger.kernel.org>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] hotfixes for 6.12-rc6
Message-Id: <20241028213814.131e0e9a0421a1fbf6b713db@linux-foundation.org>
In-Reply-To: <6434b6fc-d3c7-4f1c-baa4-25215a185eec@nvidia.com>
References: <20241028203743.3fe4d95463aaafe23a239b51@linux-foundation.org>
	<6434b6fc-d3c7-4f1c-baa4-25215a185eec@nvidia.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 28 Oct 2024 20:45:56 -0700 John Hubbard <jhubbard@nvidia.com> wrote:

> On 10/28/24 8:37 PM, Andrew Morton wrote:
> > 
> > Linus, please merge this batch of hotfixes, thanks.
> > 
> ...
> > John Hubbard (2):
> >        mm/gup: stop leaking pinned pages in low memory conditions
> >        mm/gup: memfd: stop leaking pinned pages in low memory conditions
> > 
> 
> That's the v2 series, but after some more review, we settled on a single-patch solution,
> which is v3.
> 
> v2: https://lore.kernel.org/linux-mm/fc42d9bf-3460-4d85-a09d-39b5634363d4@nvidia.com/T/
> 
> v3: https://lore.kernel.org/all/20241018223411.310331-1-jhubbard@nvidia.com/

OK, thanks, I'll fix up and rebase.
