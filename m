Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA49D13C8FF
	for <mm-commits@vger.kernel.org>; Sun,  8 Jun 2025 22:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749421284; cv=none; b=D44NvySXq5Q8utMeMykGFJdkIgFV0febYDXgyV2O6su8wCuLHOUdgg/9GMgaRO8bXiNZe2zlxlI/Pws/yGuj297k76jPBKeM1/QJ5Nd3YuyMn1rZujSviTaZU00eIzN7vMUccIB42p1y+xPE1Fl61vRUFdL0N4W6sax2o9Hb6nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749421284; c=relaxed/simple;
	bh=uYmCBDQjkhMr5Nt9xdPJIWKmmdV77T+OAhC1YudBW1A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FKak8Sdd6eFNooh6DyU8HSCLurIKn1mU9q8OfY0ONHNUYZ7lVtcfkN1VRt4evZLuTxuNrRr9az4ugvVhrXKSy2ijwz3idyjs3b+SVl5KxtqafFLe5OuuBdm8D4EUnyskjBByvImWaS/nU36SlSV7CvbzmYnQf1ZxnlIRiqaKR40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CY/4W3gk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CY/4W3gk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 582A1C4CEEE;
	Sun,  8 Jun 2025 22:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749421284;
	bh=uYmCBDQjkhMr5Nt9xdPJIWKmmdV77T+OAhC1YudBW1A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CY/4W3gk7PpeYWeNkL6E1BeZ7vRu7c0jXwin0xEs7noCbumj3nvcEPdS18UDnC4Mf
	 zvIXm61R0NplPFuqG8u5wjPxD9hz27TO6wvOV7qykz15vYamufg/ngPit37JS6jf/L
	 nErrcE0lIJoYWBg5xWqIsItf918C3skYx/1KOcls4EOVT5zQZB1aDXX+BSkjWdDfT9
	 O7Oh2ncDp2mM1I4DPjlsdSpm4XECM5Bk6djwr02R57nBittcvWQZCCHyPyW2gUZ9w8
	 jbQlQ+eSLfF4QwvOLJtrY3csiR6PpQ2I+VGiCtOAYBQ5tNsNAU4+l3Ccpy4UUkATnb
	 zqeZOzrj7gmUQ==
Date: Sun, 8 Jun 2025 23:21:19 +0100
From: Mark Brown <broonie@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, osalvador@suse.de, liam.howlett@oracle.com,
	david@redhat.com, christophe.leroy@csgroup.eu,
	catalin.marinas@arm.com, andrii@kernel.org, wangfushuai@baidu.com
Subject: Re: +
 fs-proc-task_mmu-add-vm_shadow_stack-for-arm64-when-support-gcs.patch added
 to mm-hotfixes-unstable branch
Message-ID: <1ea4c4aa-d69a-42cd-a946-6f56d3b27f24@sirena.org.uk>
References: <20250607213220.E77A1C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="DaoaAdNCIuHd1fP2"
Content-Disposition: inline
In-Reply-To: <20250607213220.E77A1C4CEE4@smtp.kernel.org>
X-Cookie: The eyes of taxes are upon you.


--DaoaAdNCIuHd1fP2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jun 07, 2025 at 02:32:20PM -0700, Andrew Morton wrote:

> @@ -994,6 +994,9 @@ static void show_smap_vma_flags(struct s
>  #ifdef CONFIG_ARCH_HAS_USER_SHADOW_STACK
>  		[ilog2(VM_SHADOW_STACK)] = "ss",
>  #endif
> +#if defined(CONFIG_ARM64_GCS)
> +		[ilog2(VM_SHADOW_STACK)] = "ss",
> +#endif

This is redundant and will lead to duplicate entries, ARM64_GCS selects
ARCH_HAS_USER_SHADOW_STACK.

--DaoaAdNCIuHd1fP2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmhGDN4ACgkQJNaLcl1U
h9Dl2Af+I+ArS3pVa+9bS53fb1d7+3B2VvgM4NxnJEFEtpmZ/EZbxDjkEc/y0Cp6
YqF5TUdzoHarVBmIDJCT0/c+bEClqmBjHYEHe1SmbHoCrDz48wr8tlPfVb2QZqrk
hZM5dkqti0Q1b8pjWhKX/XVlSaPe7QqlXPUcKpLQi727GcXERji5w9jMPDzZxHaf
j2oiFuyAZVvMrx4+M+YqFJPquyfa77p9mQ0SQn0u23XU/K4y3WIyyKgeA/IVJngg
B8YjyHShxQvGfQ4rRm5a6CEP19LlSccr2zcXWQWQLrlyA3KXBMu0iF9p/B7vD4Fl
ymxhLZ3Py4smbziEf87DDpUTT6/9uw==
=f27G
-----END PGP SIGNATURE-----

--DaoaAdNCIuHd1fP2--
