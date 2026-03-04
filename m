Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B236381AEC
	for <mm-commits@vger.kernel.org>; Wed,  4 Mar 2026 14:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772633936; cv=none; b=LQIhpJNZGp9H+dc459nBOXGCOu6OfA5Tb5nwSbU1zN79ibBnp1lWLHEX00disadRX1csjqngkfe5yYRyif9rnL0pwuJ7xx2sUBAxILlk2NVnglLhzx0705MnfAwXU/5GgJzgm19O1EG/w3CAMDitS5PHXUqk7B7UbS0aQhCFpAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772633936; c=relaxed/simple;
	bh=vIxiVk31aA1tvht49R4TX0k8eZ7QSLuSaIGrKMITxvA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O9T5oOpqK4ejm3Xfm6bXq1yKhWj0HZAf75E1sm245ksAhiu3VEoUut0bFLB52PQMHVHKi9VSl+9354P1Lik6DR5Wz2tT5DMcCM9MAF76dk+4Tc3G8VRnbW+Q1a7bY4VSBCulmyGLR6LsoJhEioLlPi4iKYSK3F4yt+cP1aqcHcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F60Tq4pM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F60Tq4pM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB47EC4CEF7;
	Wed,  4 Mar 2026 14:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772633935;
	bh=vIxiVk31aA1tvht49R4TX0k8eZ7QSLuSaIGrKMITxvA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=F60Tq4pM/dg8zm8vq2GYSILlfNDVYZTXdkS2OQSRnTPbnInvAT0akHtJjzAfdn4x2
	 PVFJRE4wF0qJhVDuTKFkfdWjtrjqGLE33iURztuiXuYlaZLP31drj58HeCb1YdDk3q
	 xdFbNLtCPRSlhglULjGzAziv9maHlP8uWlR4/CE2oBjc9CVRTDfMS30d5gVqEP/lSJ
	 MhxesAstpxJ5QQrUXy2jCC1gr/ftOOQo5Fbpv57+OWy8JZ+Y1wk6ee7TXIOed3VGEU
	 yXLuH63XSRbJK3LVQpujzSXg3kp72o1r2tiLCoby7N36PSB2rSTC9bJos+fVDCMTDL
	 dtvONKf+rYYVg==
Date: Wed, 4 Mar 2026 14:18:49 +0000
From: Will Deacon <will@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, zengheng4@huawei.com,
	wangkefeng.wang@huawei.com, vbabka@suse.cz, surenb@google.com,
	ryan.roberts@arm.com, rppt@kernel.org, mhocko@suse.com,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
	david@kernel.org, catalin.marinas@arm.com,
	anshuman.khandual@arm.com, tujinjiang@huawei.com
Subject: Re: +
 arm64-mm-fix-pass-user-prot-to-ioremap_prot-in-generic_access_phys.patch
 added to mm-new branch
Message-ID: <aag_SYnlbbTcxfk6@willie-the-truck>
References: <20260131203925.6FE5DC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260131203925.6FE5DC4CEF1@smtp.kernel.org>

Hi Andrew,

On Sat, Jan 31, 2026 at 12:39:24PM -0800, Andrew Morton wrote:
> 
> The patch titled
>      Subject: arm64: mm: fix pass user prot to ioremap_prot in generic_access_phys
> has been added to the -mm mm-new branch.  Its filename is
>      arm64-mm-fix-pass-user-prot-to-ioremap_prot-in-generic_access_phys.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm64-mm-fix-pass-user-prot-to-ioremap_prot-in-generic_access_phys.patch
> 
> This patch will later appear in the mm-new branch at
>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> Note, mm-new is a provisional staging ground for work-in-progress
> patches, and acceptance into mm-new is a notification for others take
> notice and to finish up reviews.  Please do not hesitate to respond to
> review feedback and post updated versions to replace or incrementally
> fixup patches in mm-new.

You can drop this one, as we fixed the issue a slightly different way in
-rc2.

Ta,

Will
