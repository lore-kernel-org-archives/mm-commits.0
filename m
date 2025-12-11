Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE0E532C8B
	for <mm-commits@vger.kernel.org>; Thu, 11 Dec 2025 00:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765411749; cv=none; b=SOb3qGNVbgqfvhrQNOEVnegw8tnbNjdb1x4kpMznPRt5f3rN6B2nQqt63kLkUADHOVSz9CnyBEn2JFJyMXqEdOIHMrE8UVHZK1DPCZ3KKcCkcbDmEAmhkJ2PcUFjeVwDxh3SYc4M2vGnFVey3T6Zyy1kGwjUBxZq0kTWBoBwlVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765411749; c=relaxed/simple;
	bh=wc+/zaoFCGNMxA6o1iJvP9MnG6xNO/jdVuTJjmEg2t4=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=TKo0mRMF2DEJM4jEu9uKBcrJG12Szixwaftr89c6Kl7nK2TD1AxsfmybOwgtm9RoOkPVhlk8jzBwWMR3dFEQhDXHAUs3HsEW+yfjGtYuDUHVOCvx6drDhLXTqwy9SVQiIaE6Yj27N4gSKG12W9YHJRPFbZBTkTtsMmconvrU0Mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ly9cIREW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ly9cIREW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 025EEC4CEF1;
	Thu, 11 Dec 2025 00:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765411748;
	bh=wc+/zaoFCGNMxA6o1iJvP9MnG6xNO/jdVuTJjmEg2t4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ly9cIREWg94rOuZLnrRLNjKf49POtFXKYgovb+F4FsmA1SH/v7Bb1TmbJUqVPdi0a
	 Tu4+XFBRLBnPJiRMHQQy0W+1Z9cuqUJ3KdPmuRFSJWfLtNlmV7caGMxhhse/dK4FId
	 JkvA8NYw8QZlzXVD5y1d+mXt54n5pas0sCzWotIg=
Date: Wed, 10 Dec 2025 16:09:07 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: mm-commits@vger.kernel.org, skhawaja@google.com, rientjes@google.com,
 pratyush@kernel.org, pmladek@suse.com, kees@kernel.org,
 dmatlack@google.com, davidgow@google.com, corbet@lwn.net,
 pasha.tatashin@soleen.com
Subject: Re: [merged mm-nonmm-stable]
 liveupdate-luo_flb-introduce-file-lifecycle-bound-global-state.patch
 removed from -mm tree
Message-Id: <20251210160907.8a613081f07250e84ec62481@linux-foundation.org>
In-Reply-To: <aTn9jyHeIR_AidS-@kernel.org>
References: <20251209193312.7CF12C4CEF5@smtp.kernel.org>
	<aTn9jyHeIR_AidS-@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 11 Dec 2025 08:09:03 +0900 Mike Rapoport <rppt@kernel.org> wrote:

> On Tue, Dec 09, 2025 at 11:33:11AM -0800, Andrew Morton wrote:
> > 
> > The quilt patch titled
> >      Subject: liveupdate: luo_flb: introduce File-Lifecycle-Bound global state
> > has been removed from the -mm tree.  Its filename was
> >      liveupdate-luo_flb-introduce-file-lifecycle-bound-global-state.patch
> > 
> > This patch was dropped because it was merged into the mm-nonmm-stable branch
> > of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> Didn't we agree to keep this in mm-nonmm-unstable until either LUO support
> for VFIO or hugetlb are ready to merge?

I missed that, sorry.  Undone.


