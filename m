Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5181B2750E6
	for <mm-commits@vger.kernel.org>; Wed, 27 Aug 2025 20:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756327959; cv=none; b=HzUjM0gPYeoMHoCsvzvOBFqBFCCBhu09tN4785qRtl6R+vlp3VICYgPsOsBaEKu6hX0K1NUddQ6OF6J0umItz/+6mSTZeIctQXIyglbWwIxFRJgEZ1EIbW/vFmIu2mD/wr9SzLfIrykdghgjt2nwl5nTMnYsEjCwJUuNRtHnDHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756327959; c=relaxed/simple;
	bh=JyL6TmjjLpAp0WV5Gjn35VDpZyJINInAEKuaqMrWPqU=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=bFPP6gnAY6Gmni7bkUE4OuRJCEkLB7dmP3XHIauithzWGTGj5crkGPxNsdeLheluFSz/IkgbSTriYA+4I1GIr17bWQf0qokxLkEp7On0wb+jRpnJbUr9UzYjqQ35oDkxyh09vNT60IiDoEHAjw2XC29j2s4qvw4mrda4GC0/moE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IHFP8dQJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IHFP8dQJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0E66C4CEEB;
	Wed, 27 Aug 2025 20:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756327957;
	bh=JyL6TmjjLpAp0WV5Gjn35VDpZyJINInAEKuaqMrWPqU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=IHFP8dQJCOPE6H7nkhKhCVxssnO3R12L17myxf1fkd1oHy8jhX7EPmRyJguKSi6L/
	 PegVVU3NNtHtHrRsij+d77JJJBhVtr21EqsaWDvQR2hCbCYDqR8cRs8dJXqy7Ys+Uh
	 gunSzzbzm0mmCkICZur3cKycLLnYHOoGUaV7xeP4=
Date: Wed, 27 Aug 2025 13:52:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: mm-commits@vger.kernel.org, david@redhat.com
Subject: Re: + memblock-fix-kernel-doc-for-memblock_rsrv_noinit.patch added
 to mm-unstable branch
Message-Id: <20250827135237.5f6cf04ccf6772bf621e42ef@linux-foundation.org>
In-Reply-To: <aK64IsMNJUvMbn5Y@kernel.org>
References: <20250827032507.C1989C4CEEB@smtp.kernel.org>
	<aK64IsMNJUvMbn5Y@kernel.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 27 Aug 2025 10:47:46 +0300 Mike Rapoport <rppt@kernel.org> wrote:

> Hi Andrew,
> 
> On Tue, Aug 26, 2025 at 08:25:07PM -0700, Andrew Morton wrote:
> > 
> > The patch titled
> >      Subject: memblock: fix kernel-doc for MEMBLOCK_RSRV_NOINIT
> > has been added to the -mm mm-unstable branch.  Its filename is
> >      memblock-fix-kernel-doc-for-memblock_rsrv_noinit.patch
> 
> Can you drop it please?
> I am meaning to take it via memblock tree.

Sure, but my usual workflow is to drop the mm.git copy after Stephen has
reported the duplicate.  To minimize the possibility of things getting
lost.

So if there's something you'd rather carry in the memblock tree, just
merge away.  The subsequent removal from mm.git is effectively
automatic,
