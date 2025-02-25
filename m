Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DB08198A32
	for <mm-commits@vger.kernel.org>; Tue, 25 Feb 2025 21:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740520570; cv=none; b=cT9ErxnHbuf+T6TYTTNzFqL8zA8YnhzXkA3kbT4G8zuArLTISIdTVZzf+e1EkYcT5DuXK8Pc7fHl1cYtzlzEkU+RqrRBuTEb7lI2yRf2CbeVpVmfbPDUP2orDT2JIsXO+/n1UmNaL8k4wZsh8zIDPj8VqmbdkDpns5GuGGXXoJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740520570; c=relaxed/simple;
	bh=1zgwlvgfjGb1DNdU75ZRBMoi6/5HNIR3p2boXnqsbGo=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=h1SUo6AicKTjcQO/E+9xlRRHmbalTT+TnuEB1kD84SacZpEIX0OnyH4iTLuCAhXb5GJXC4jBQFfEbZl3++vS4IuGTp8k7jaxhKaEwDiLirb0hbLW8zHPmvqZa7fwR3nBXxJKJCfIYljWc/odpLm0/dcsWy/WvKxr3fzRBxwDFk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=C3g6ZXZL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="C3g6ZXZL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B33D8C4CEDD;
	Tue, 25 Feb 2025 21:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740520569;
	bh=1zgwlvgfjGb1DNdU75ZRBMoi6/5HNIR3p2boXnqsbGo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=C3g6ZXZLTuxx0QJd5AYU5mJVLdVxlU+BRyGGLLq8TOZ3z2sErwbSSWOo3HOL6NLMw
	 /GLqkI31BAjEbD1jqjevulpMNUfEJcvWLSaUcl3CjeQt69S4LNMiv1kcz1r7UXckeP
	 VtUZ62qMbzDawTAJLgQ8STaSrV1yKtTSP68v2iDo=
Date: Tue, 25 Feb 2025 13:56:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Snitzer <snitzer@kernel.org>
Cc: mm-commits@vger.kernel.org, trond.myklebust@hammerspace.com,
 anna.schumaker@oracle.com
Subject: Re: +
 nfs-fix-nfs_release_folio-to-not-deadlock-via-kcompactd-writeback-fix.patch
 added to mm-hotfixes-unstable branch
Message-Id: <20250225135609.f0dfd0c2f920460b876376c0@linux-foundation.org>
In-Reply-To: <Z73g4bjBLh9SyKUC@kernel.org>
References: <20250225065454.722B4C4CEE7@smtp.kernel.org>
	<Z73g4bjBLh9SyKUC@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 25 Feb 2025 10:25:21 -0500 Mike Snitzer <snitzer@kernel.org> wrote:

> > -	tsk->flags &= ~PF_KCOMPACTD;
> > +	current->flags &= ~PF_KCOMPACTD;
> >  
> >  	return 0;
> >  }
> 
> I wrote my patch against stable 6.12.16 and didn't think to check
> latest code (sorry!).  I can easily see we need your fix given commit
> 54880b5a2b5e ("mm: Create/affine kcompactd to its preferred node").
> 
> Will you fold your fix before sending to Linus or should I send a
> proper v3 patch rebased to latest code?

Yes, I'll fold the fix.
