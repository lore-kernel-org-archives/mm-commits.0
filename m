Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCB9420125D;
	Tue, 29 Oct 2024 19:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730230248; cv=none; b=cpE3U0O9VA90CUYEb6RXh0eUP368hd1rgtfC+bzu4PSLd4Mx+8lBbpQsIDskWnHz/YQY+yGCeTxGwconKd6SZRZHFQYKajHYs/J/yJ0np/eGBH1S51c63wsYWOiCpaE4AvFD9+WFaT728G8eD92YpMBh7zvfU2g1/CrGf9XRqmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730230248; c=relaxed/simple;
	bh=LZuyG69K/meju8pWtFlcZEibdSANaQtcyFehvMeZgg0=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=XAQCUeJ/vasRbFMFEgk0W+tcao53hgDM4cv1Z7Ma5vD5+TirraRLzJEt+iFtmUy1YXfG8plwStY7V9a2wyA5Bdtf9zIXlRYzHIYvkcwAVKhfDvZ2ewRdPLO+UC3HU8fHazKEBUqhDREyhdz8GFoXIfjXZdMmUQVu8WPXm/P1xyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2XuusiOv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2XuusiOv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FFE6C4CECD;
	Tue, 29 Oct 2024 19:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730230247;
	bh=LZuyG69K/meju8pWtFlcZEibdSANaQtcyFehvMeZgg0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=2XuusiOvoE/g6e8Ib7b0ipluTZw/yEBVP+T2ta9QbmFxZGYVXnrK+k385cJw7XMea
	 XzMUncguQEthcyyoiSUaMMmt7kJhHaAuajj7DTWRSBbb6PTlaV1VYQHd64jHOvU4XT
	 GZG6/x9SQ67xBJFNPSNSsmayuTuyzH8+9fJti48Y=
Date: Tue, 29 Oct 2024 12:30:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: mm-commits@vger.kernel.org, stable@vger.kernel.org, rientjes@google.com,
 linkl@google.com, yuzhao@google.com
Subject: Re: + mm-page_alloc-keep-track-of-free-highatomic.patch added to
 mm-hotfixes-unstable branch
Message-Id: <20241029123046.b81890f3c5fa181d667cc4d4@linux-foundation.org>
In-Reply-To: <cbbad18f-80ad-4283-b437-65f86411f803@suse.cz>
References: <20241029005805.9BEF2C4CEC3@smtp.kernel.org>
	<cbbad18f-80ad-4283-b437-65f86411f803@suse.cz>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 29 Oct 2024 10:05:43 +0100 Vlastimil Babka <vbabka@suse.cz> wrote:

> On 10/29/24 01:58, Andrew Morton wrote:
> > The patch titled
> >      Subject: mm/page_alloc: keep track of free highatomic
> > has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
> >      mm-page_alloc-keep-track-of-free-highatomic.patch
> 
> In case of mm-hotfixes, the cc stable for 6.12 is unnecessary as it should
> make it there directly. Perhaps it's the best way, yeah.

Oh, yeah, right.  There's no Fixes:.  How do we know it's 6.12+?

