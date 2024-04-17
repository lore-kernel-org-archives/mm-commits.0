Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 036557470;
	Wed, 17 Apr 2024 03:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713322837; cv=none; b=SEqMef/+woHjJAnT9jxAY/jKOCH+ujUCCwh+5XUecTnAgnZ5CdEfQ27VASO/lndzLeL8IgUwFvWJ0TRGXUVYs+Fuand3ejYM+qOkDH5lc82J9suEc/ytHuZeaciXBgnqak6zK0Q8QSh0XKdb0l+EwPE18r7v2P+kh+4iKvdCPvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713322837; c=relaxed/simple;
	bh=9HSKNEIg7UfBtH/pYkTdmUvHRog4yWl0rcs4vgBbgWw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UzGZMKEVsc6KgDlm38sKnhK9WlnXRcbJRkr3niMHqB+Ji09UgqX+kYojTeTWC69Y6suEPqMJmlAdfIpvMTVN8mOAWWxVS5b405TgjZVhzMoF4id7BleUFF5Icp3wVrBv7TVrlJfiy88ScdhdVBVv07cX77WJkED9Uk33M1niR6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lhbgh+Za; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lhbgh+Za"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84701C113CE;
	Wed, 17 Apr 2024 03:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713322836;
	bh=9HSKNEIg7UfBtH/pYkTdmUvHRog4yWl0rcs4vgBbgWw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lhbgh+Zaq5ekgMP2W8+P+iV0nf3lz+hfWqPU/SmJAzRG8MidhDp9uXvNjzZG/4h2b
	 1U42tjiQ+ozNgMo3xPViDuA4RJImJIYYcIZvSyOg7thTfGzIErEmKY/RQlRI5KUtHf
	 VWItVwmDLLFT8TmtX+P684lWtARLh8qy9x8LI1QhGwGT47a1Vus+t7rZ77MYhtvXKy
	 rfjbCZZJX8ubWSK7NBjsXn/lXP693lT6z00E+FZReJYiaGB6+QMC8A4uLfy3K3wVDd
	 U4T2Qbg/mkIFXrOySragBCcV9tbz5lf4tJNvvJFNzIHT5ASc4Dt+cmvRKClAjZmdoe
	 1MjiRucOPKtxw==
Date: Tue, 16 Apr 2024 20:00:35 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, stable@vger.kernel.org, jhubbard@nvidia.com,
	jgg@nvidia.com, hughd@google.com, david@redhat.com
Subject: Re: [merged mm-hotfixes-stable]
 mm-madvise-make-madv_populate_readwrite-handle-vm_fault_retry-properly.patch
 removed from -mm tree
Message-ID: <20240417030035.GC11972@frogsfrogsfrogs>
References: <20240416224016.77AA5C3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240416224016.77AA5C3277B@smtp.kernel.org>

On Tue, Apr 16, 2024 at 03:40:15PM -0700, Andrew Morton wrote:
> 
> The quilt patch titled
>      Subject: mm/madvise: make MADV_POPULATE_(READ|WRITE) handle VM_FAULT_RETRY properly
> has been removed from the -mm tree.  Its filename was
>      mm-madvise-make-madv_populate_readwrite-handle-vm_fault_retry-properly.patch
> 
> This patch was dropped because it was merged into the mm-hotfixes-stable branch
> of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Thank you all for getting this pushed towards mainline!

--D
