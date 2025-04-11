Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7EFB42AAF
	for <mm-commits@vger.kernel.org>; Fri, 11 Apr 2025 02:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744339651; cv=none; b=rMQHgGAnIO/W7IgROrm9rOkkUxZ7XLeV7uhOLy6w8jXqSoqSroFNnE1448UlUlvMQR5SinmlcrvlSIHW0ZPIrV8ZGZZTOawUnU6jA+hmhwkq4LOp5zDw4eJiYt+6TLS61WYUd7VyeITABc6Rp5chXZrSrLgglHumXSMY3+KncNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744339651; c=relaxed/simple;
	bh=Vp44Udias24WrUVGohCSBUShKsZnSw6BjTtQ3v4PbTs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GtiKmdXIBr3Oeh8Ev8HsO6RAyGsP8Tl0yXUtr02tDT0vLJ6k8zZZQULKFNfUndNAMArTt7reQEAsNADTX4djCeFxM/SUeeImKLLG+fzXbpFpM6DxsBgSFo+3IqhHO6fSl58M9YFwAH8IW0vpj4z89bjZ3gSs5JCp1mrEfOh7GpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JUiDFLRQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JUiDFLRQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9052DC4CEDD;
	Fri, 11 Apr 2025 02:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744339651;
	bh=Vp44Udias24WrUVGohCSBUShKsZnSw6BjTtQ3v4PbTs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JUiDFLRQ67/vmz3yRB4Ra6+wNNx9nDuLmPRa3kq8b2K+6bwcthUcn5fiuQfiM51xf
	 pReleH4PIAossOvBYz5bUNWLZd0mZSDIjUcVolpbcDLdPhvjuNF1FEd6oyBm119GLB
	 xvO0cQ50s2myacapO5TZI8h2GJ8RDlal/4F7mnOPFY9SubsfhTYxpU0flybvktDBX4
	 FbwLFreB5VbJh6Y37fl8hfLNic7VrPlHhHqqGMJi9eHn8AKMdJqZnkaboL3zsZaGD2
	 JwbmIQ/9k6LfUu8rZanCWjrsvf9MVJIBGTl/lijUNGmpKzuP/F0RTEXDkhV8qd2e/+
	 2XPIsGAtykO/Q==
Date: Thu, 10 Apr 2025 19:47:26 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, paul.walmsley@sifive.com,
	palmer@dabbelt.com, ldv@strace.io, charlie@rivosinc.com,
	aou@eecs.berkeley.edu, alex@ghiti.fr
Subject: Re: + syscallh-add-syscall_set_arguments-fix.patch added to mm-new
 branch
Message-ID: <20250411024726.GA2717907@ax162>
References: <20250411014303.CF55AC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250411014303.CF55AC4CEDD@smtp.kernel.org>

Hi Andrew,

On Thu, Apr 10, 2025 at 06:43:03PM -0700, Andrew Morton wrote:
> 
> The patch titled
>      Subject: riscv: avoid fortify warning in syscall_get_arguments()
> has been added to the -mm mm-new branch.  Its filename is
>      syscallh-add-syscall_set_arguments-fix.patch
...
> ------------------------------------------------------
> From: Nathan Chancellor <nathan@kernel.org>
> Subject: riscv: avoid fortify warning in syscall_get_arguments()

I do not think I made myself clear enough in my request when reading it
back, so I do apologize for that. I need the diff at the end of [1]
applied to syscallh-add-syscall_set_arguments.patch, not [2], which is a
standalone patch for the existing syscall_get_arguments() that should go
via the RISC-V tree because it is an existing issue (or at least be kept
in standalone patch form).

[1]: https://lore.kernel.org/20250408213131.GA2872426@ax162/
[2]: https://lore.kernel.org/20250409-riscv-avoid-fortify-warning-syscall_get_arguments-v1-1-7853436d4755@kernel.org/

Cheers,
Nathan
