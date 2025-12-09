Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02B33285C96
	for <mm-commits@vger.kernel.org>; Tue,  9 Dec 2025 19:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765308585; cv=none; b=MZ0Y5+Ico6vSM36o058FxrxjOgXXIhzPcWdwnLdKoPeSYrfo1cFNxeR2wOqp2pa75kCYfadrtyK8Bx6hqlXd4Wo+jrXfsc0R3RcKJMbRME33MQ8AiA+utJTm/JS6p+x2xqocLDL+JgGGwqLKvoJ3RwXy3tJyCZZ5QQSithrx4WU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765308585; c=relaxed/simple;
	bh=7FGubCvwWIB3Vba1LvaXWAgDsU9oaxGA5KsUesEqSI0=;
	h=Date:From:To:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=nXBKYJUXTdTsoxofRAiKXfvAlbdQZkYWcV5fFS+RTrelR9ehZnhsGYkZQqeN4GfUzBusODIcF02ENvJsGmvvaElQ86TE6PnQlxiBqgbGiu5uXuxaBSqCN+Bh3kjipTg4kdoWvTx3SiRjHUUe3hFYONyifPottrGMNfRnIQZkvYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=k0WvObcv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="k0WvObcv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77653C4CEF5;
	Tue,  9 Dec 2025 19:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765308584;
	bh=7FGubCvwWIB3Vba1LvaXWAgDsU9oaxGA5KsUesEqSI0=;
	h=Date:From:To:Subject:In-Reply-To:References:From;
	b=k0WvObcvhBdS5tKPMNKBLNVm09RWkXfS+KJeMWYdN5KI3rkk8JztV+QxevmVhsIT2
	 mQKyc+6ULc52Hx9of/WlAS1hPlJ1zrTJKF/fibK2AhQ0ssxh45mAYEb+kakXbK7U5B
	 Vr0RZKzwQx7pT7YfZhtgOWP3oOnkA3DdI0nPxAjc=
Date: Tue, 9 Dec 2025 11:29:43 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Vlastimil Babka <vbabka@suse.cz>, mm-commits@vger.kernel.org,
 surenb@google.com, rppt@kernel.org, oliver.sang@intel.com, mhocko@suse.com,
 liam.howlett@oracle.com, jhubbard@nvidia.com, david.laight.linux@gmail.com,
 lorenzo.stoakes@oracle.com
Subject: Re: + mm-avoid-use-of-bit-macro-for-initialising-vma-flags.patch
 added to mm-unstable branch
Message-Id: <20251209112943.6f5e405590671076f55bf4a3@linux-foundation.org>
In-Reply-To: <20251208174009.f982210c3a12ecd2459f59ce@linux-foundation.org>
References: <20251205201510.3D83EC4CEF1@smtp.kernel.org>
	<95d18dbe-9055-43b8-bb4b-da40da670c10@suse.cz>
	<20251208174009.f982210c3a12ecd2459f59ce@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 8 Dec 2025 17:40:09 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:

> > On 12/5/25 21:15, Andrew Morton wrote:
> > > The patch titled
> > >      Subject: mm: avoid use of BIT() macro for initialising VMA flags
> > > has been added to the -mm mm-unstable branch.  Its filename is
> > 
> > Can we move it to mm-hotfixes-unstable please, to have this resolved within
> > 6.19 itself.
> 
> It's in mm-unstable at present and I'll be moving it into mm-stable
> soon in preparation for another merge window mm updates batch.

So I haven't moved it into mm-stable.  It's a bit unclear what way the
wind is blowing on this one, unclear whether the performance regression
is real and we've yet to hear back from viro.

So I'm holding it in want-and-see mode - we can add it later as a
hotfix.
