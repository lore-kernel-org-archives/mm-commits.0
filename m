Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 427CF2DBF75;
	Fri,  6 Mar 2026 11:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772796435; cv=none; b=GQlPoUiR1EexYGzU7EB28xujFu44tZ1fECT32Msh4M/Prb69rXLqi0AzyU1XbnPo0BFzwLXcFi+1VJty2LN1knVH4uV2DX5iPSAxD51sPOTTLkQKN4VxFaH/556+SA4RtHpJiB2Vit+KXVP4J5VWA4ej9G2NSpQYcp/Bt98pEyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772796435; c=relaxed/simple;
	bh=j/K8I3jVG6Bt/uXmPNV+V3MKYNqc1O7pmt5S7Y54LuY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PdbXATA7Qm5Y45nLJZKIcaFQSz7+Yzz4o4OF1LqXIPumo1djhbLb1fElr4t/EEUswvta4QFkNj/22nccQm9bUzX+vbXOqHCUGk0ljDN4X+K+3A70dry+Syb2JeK5tHYLXaqdw+a9NZkjE3+yFZNKwkWZl8jtltJjo/E1oSok/CM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M/oTlek6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M/oTlek6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E8E6C4CEF7;
	Fri,  6 Mar 2026 11:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772796435;
	bh=j/K8I3jVG6Bt/uXmPNV+V3MKYNqc1O7pmt5S7Y54LuY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=M/oTlek6boSrBZGmOvGNtil8EcszKIAFDZcZ77vlTYYnjumY+oVQs9k5B7ZcalBU6
	 qdUVF1w1sCuLE20ixmPAOYzPbjs+KoVNyv94Qx47gHN7+xJmZi6RlBOrxj/b6AvCLI
	 mDmOZoImPjcGAOCWeSwBAW3Hf4eJdEz7lsddJiJr5Z4ljpGhGxdql6T/N/46B1tsgm
	 nlqFLlxBD71UtT2U2C2KlQN+Ci8pob04jl4r6n7xx4pdbqZtZdI37iZ/KnWeM6B94z
	 ZUS3uyIchZEMpfyNoNHEPUHoxUHifZTytRmqCXFAf85c/VCEbo6uTByvd5c2DMtKSu
	 2ofMuWI052k4Q==
Date: Fri, 6 Mar 2026 11:27:09 +0000
From: Will Deacon <will@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, ziy@nvidia.com, stable@vger.kernel.org,
	ryan.roberts@arm.com, leitao@debian.org, jthoughton@google.com,
	jhubbard@nvidia.com, jgg@nvidia.com, catalin.marinas@arm.com,
	apopple@nvidia.com, pjaroszynski@nvidia.com
Subject: Re: +
 arm64-contpte-fix-set_access_flags-no-op-check-for-smmu-ats-faults.patch
 added to mm-hotfixes-unstable branch
Message-ID: <aaq6DTGcm5agvanh@willie-the-truck>
References: <20260306011907.67CE4C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260306011907.67CE4C116C6@smtp.kernel.org>

On Thu, Mar 05, 2026 at 05:19:06PM -0800, Andrew Morton wrote:
> 
> The patch titled
>      Subject: arm64: contpte: fix set_access_flags() no-op check for SMMU/ATS faults
> has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
>      arm64-contpte-fix-set_access_flags-no-op-check-for-smmu-ats-faults.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm64-contpte-fix-set_access_flags-no-op-check-for-smmu-ats-faults.patch
> 
> This patch will later appear in the mm-hotfixes-unstable branch at
>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

I'll take this one via arm64, as we already have a few fixes queued up
there.

Will
