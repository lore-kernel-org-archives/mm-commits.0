Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E6F12D1F64
	for <mm-commits@vger.kernel.org>; Tue,  9 Dec 2025 01:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765244411; cv=none; b=S2UntwXeEN00p1yxywxXCHss+fLCoBzwu5j/B7keyLVi+k6rwVGB/OogGi0esMCmGtunO90jv6ZsCpcEma+rQjRoUjMwru+JLMwCxqRE7/JuQITphI2B4PVhJXdnnepREH7jy9WciK/Dpn2LR255bBv2O3Ht7leR7fsz09FA7QQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765244411; c=relaxed/simple;
	bh=lwGpu8xCXjQUnXA30dd5+0O9GozhRc0kDunbFQ25oMM=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=b6CltpVnxcSrrqlAOPxsI4aPQYe94jPgMuCrM0nUooEq1cV7XFK2lx1NP0/P3aA96W9g3ubrVZoNiuQGxszkUg4MQHxKPHsPoZbRNC55VL9U2HVq4eOFjUrMNi2/HnfaBnMuKRIr+rJNbNsPD2P2v4ssZvyWhqU1iEfgEbwjbrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qBEfQpaW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qBEfQpaW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 992F7C4CEF1;
	Tue,  9 Dec 2025 01:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765244411;
	bh=lwGpu8xCXjQUnXA30dd5+0O9GozhRc0kDunbFQ25oMM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=qBEfQpaWP/jGNqT24uhcaptI/iTY4Qb3nDfnW4PMdfjJEfckT2gq/zbx919gw/DUJ
	 V+y3+eYXujB+FjQ5CKU+M63IVLzd4CAxU681GktDRlAjzzpFmqxu4ur1KibkGwIOlJ
	 Lh6cizBth18vubAlZJmZGEbxN9EfMAvRYOJ/gidY=
Date: Mon, 8 Dec 2025 17:40:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: mm-commits@vger.kernel.org, surenb@google.com, rppt@kernel.org,
 oliver.sang@intel.com, mhocko@suse.com, liam.howlett@oracle.com,
 jhubbard@nvidia.com, david.laight.linux@gmail.com,
 lorenzo.stoakes@oracle.com
Subject: Re: + mm-avoid-use-of-bit-macro-for-initialising-vma-flags.patch
 added to mm-unstable branch
Message-Id: <20251208174009.f982210c3a12ecd2459f59ce@linux-foundation.org>
In-Reply-To: <95d18dbe-9055-43b8-bb4b-da40da670c10@suse.cz>
References: <20251205201510.3D83EC4CEF1@smtp.kernel.org>
	<95d18dbe-9055-43b8-bb4b-da40da670c10@suse.cz>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 8 Dec 2025 17:09:05 +0100 Vlastimil Babka <vbabka@suse.cz> wrote:

> On 12/5/25 21:15, Andrew Morton wrote:
> > The patch titled
> >      Subject: mm: avoid use of BIT() macro for initialising VMA flags
> > has been added to the -mm mm-unstable branch.  Its filename is
> 
> Can we move it to mm-hotfixes-unstable please, to have this resolved within
> 6.19 itself.

It's in mm-unstable at present and I'll be moving it into mm-stable
soon in preparation for another merge window mm updates batch.
