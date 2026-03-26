Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D208B84039
	for <mm-commits@vger.kernel.org>; Thu, 26 Mar 2026 00:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774485277; cv=none; b=rZ5Me4d3AGMSBv6YK7jnfBuK0uesFe1tvbgqMYefB671YWrJ8Qhk2+KAuqsKu7kbJRRsYrMq0bW+11SqWW7Ev8gC1R7kf/w/khsdOaDNZdgNCZoPP8V/NiW96ng1Q7ZYyN0pIbX83enH6FJ1XeuflFW8RpRvRwJuF16kqxObR+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774485277; c=relaxed/simple;
	bh=WYdoEArv17DBv+bxs3Vxv+GtY8Paog+HnltKxfTCk7Q=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=sL8+GbtiX3icWyxZXYYeIJgMefLZjXCuALMZdLyqjObTiR+TpWct1lOKsz1JUpvj+HxwA24qlUl7UIQJwDhG4ARF5boC3fR7AhbwVXBImC2n/vGfdl2RxZ+nopfc4h6z6ur3iHZOoLgAL+wdCoqNFAMS239W4xnkslxqjIxiu84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Uen2CeT6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Uen2CeT6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2B26C4CEF7;
	Thu, 26 Mar 2026 00:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774485277;
	bh=WYdoEArv17DBv+bxs3Vxv+GtY8Paog+HnltKxfTCk7Q=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Uen2CeT63wXn4fJCzOP/j2DSzYi7fcchdGxZ1FKHpn/btdB03o0AsTIdLjBwNXvAJ
	 v9jSpPX4ilTD+vLwBUA3HND2wtMTz7RJPEz+0/JaVzIYBIIpJg7rNOwLCrSiNm9QAF
	 Qy2GNm7qkH/dT9qHCsaPFxoGm2D9liDV0KyRKzq4=
Date: Wed, 25 Mar 2026 17:34:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: SeongJae Park <sj@kernel.org>
Cc: mm-commits@vger.kernel.org, skhawaja@google.com, shuah@kernel.org,
 rppt@kernel.org, pratyush@kernel.org, dmatlack@google.com,
 pasha.tatashin@soleen.com
Subject: Re: + liveupdate-prevent-double-management-of-files.patch added to
 mm-new branch
Message-Id: <20260325173436.ec1a5b6d0f0315e5a99d2ae9@linux-foundation.org>
In-Reply-To: <20260326002112.77105-1-sj@kernel.org>
References: <20260324150331.BBF14C19424@smtp.kernel.org>
	<20260326002112.77105-1-sj@kernel.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 25 Mar 2026 17:21:11 -0700 SeongJae Park <sj@kernel.org> wrote:

> > same file is not preserved twice beside using inode or some slower and
> > expensive method like hashtables.
> > 
> > 
> > 
> > Currently, LUO does not prevent the same file from being managed twice
> > across different active sessions.
> 
> Seems the usual "This patch (of X):" line above this paragraph is mistakenly
> not added?

Seems this was accidentally fixed in v3 ;)

> No issue for me, but I just wanted to inform you for a case that you care about
> that.

Thanks, not the first time.  Let me add a rule to my
check-for-usual-screwups cron script...
