Received: from mail.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DDE333998;
	Sun, 26 Jan 2025 08:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737880094; cv=none; b=tgLIUoBWIKry/iaXDkBMjTzRJAeSzp7fOlyYyeqXp4F57rafkICgCjIm5go2e1sd92xXYIfCGYHUQAbwJ2QmQkiGRL4+npa3piTVt4LX7/ehI3CnmJ5FmdoB00EisKGfOPoZ8ShPUOrVNeilgKfx1gFd9srkoU+xYsbQLdwqIHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737880094; c=relaxed/simple;
	bh=FlmhSjlBv36BlFJhqvgNmih9Nnvcz/AwSmH+Tuy/hx0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AhHNv7rj9vhT1uHi5rrN/SVvKfSMtRd+TlMuQhSFXUAZ7dXubXLdHnOito3B8zqgCmY8iH7Ya2lgIxuhjkarUILOtlC+MLp9fi9syrjiEUbHHt8f5xQOtkCxG0hCnfk41ZgEcWQsSxZtF3VbFzysANoOtxc32Ptq728VL0t8nOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au; spf=pass smtp.mailfrom=canb.auug.org.au; dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b=HsIftm/+; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canb.auug.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="HsIftm/+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
	s=201702; t=1737880077;
	bh=z7cRlnOF1/kC5po1eT9/ip29wU/LR+RPSC5FE+FsZ4Q=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=HsIftm/+ygw8TWPs5FUnrRSLDxTKvXGCX2SbPDnvBsuPQW+6n9CedYWJhcuJq6GYs
	 OCKpXnmCMmnZJ5NCU1Rl7B3PVYW4hKh22gy9dEPBFyzRTrrvnNDiFz+hIuLF4LixSr
	 OvFbAXFMdZ9pjcc4CehTOyh+UlgOdf7IYylhsDfu11FiSvfF8zoL/4PjszG6jjEAx1
	 4AQj+WVJ6afu+1f7FIDN3m/GFpbDq/NoarTfO6gxvtVTiEg0gj1an8ZS08DA17Lyaf
	 ddnMlTf40tI3h3mO5WJvlDllQyhiiCtPVyrZ+Txb1qziJmius+ppZF7XE7Xysiskyu
	 hHsrjtaQDDdkg==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4Ygl6h71rLz4wc2;
	Sun, 26 Jan 2025 19:27:56 +1100 (AEDT)
Date: Sun, 26 Jan 2025 19:27:48 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Uros Bizjak
 <ubizjak@gmail.com>, linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org, Dan Carpenter <dan.carpenter@linaro.org>,
 Anders Roxell <anders.roxell@linaro.org>, Naresh Kamboju
 <naresh.kamboju@linaro.org>
Subject: Re: [GIT PULL] MM updates for 6.14-rc1
Message-ID: <20250126192748.30c36ddd@canb.auug.org.au>
In-Reply-To: <20250125210016.815b4260ad539b1e66298d98@linux-foundation.org>
References: <20250124162248.60104eec848619a187242392@linux-foundation.org>
	<CAHk-=whddBhfi5DUi370W3pYs+z3r2E7KYuHjwR=a1eRig5Gxg@mail.gmail.com>
	<20250125210016.815b4260ad539b1e66298d98@linux-foundation.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/yBlNzHbr3TlgHPNsrYnF7YC";
 protocol="application/pgp-signature"; micalg=pgp-sha256

--Sig_/yBlNzHbr3TlgHPNsrYnF7YC
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Sat, 25 Jan 2025 21:00:16 -0800 Andrew Morton <akpm@linux-foundation.org=
> wrote:
>
> On Sat, 25 Jan 2025 14:09:16 -0800 Linus Torvalds <torvalds@linux-foundat=
ion.org> wrote:
>=20
> > On Fri, 24 Jan 2025 at 16:22, Andrew Morton <akpm@linux-foundation.org>=
 wrote: =20
> > >
> > > Linus, please merge the MM updates for the 6.14 development cycle, =20
> >=20
> > This does not build at all for me.
> >=20
> > I get
> >=20
> >     ./arch/x86/include/asm/current.h:49:9: error: call to undeclared
> > function '__typeof_unqual__'; ISO C99 and later do not support
> > implicit function declarations [-Wimplicit-function-declaration]
> >=20
> > when running the Rust 'bindgen', and what seems to be going on is that
> > my version of *gcc* does support __typeof_unqual__, so I end up with
> >=20
> >     CONFIG_CC_HAS_TYPEOF_UNQUAL=3Dy
> >=20
> > in my kernel config, but I think that 'bindgen' that generates the
> > Rust bindings is based on LLVM, and clearly does not understand
> > __typeof_unqual__.
> >=20
> > I have bindgen 0.69.5 (plain F40 install), in case somebody wants to te=
st.
> >=20
> > Apparently few people test linux-next with Rust enabled, and the
> > reports that I find on lkml were ignored.

I don't recall seeing them ... were they cc'd to linux-next@vger or me?

> > I do see reports of this failure on lkml from mid-December, so it's
> > not like I'm the first person ever to see this.
>=20
> Well dang, nobody told me, and I assume Stephen didn't find out.

I did not get any errors in my builds.  I am running Debian Testing on
a PowerPC LE machine (so my x86_64 allmodconfig builds are cross
builds).

$ gcc --version
gcc (Debian 14.2.0-12) 14.2.0
$ bindgen --version
bindgen 0.70.1
~/next/x86_64_allmodconfig$ grep -E '(CONFIG_CC_HAS_TYPEOF_UNQUAL|_RUST)' .=
config=20
CONFIG_RUSTC_VERSION=3D108300
CONFIG_RUST_IS_AVAILABLE=3Dy
CONFIG_RUSTC_LLVM_VERSION=3D190104
CONFIG_CC_HAS_TYPEOF_UNQUAL=3Dy
CONFIG_RUST=3Dy
CONFIG_RUSTC_VERSION_TEXT=3D"rustc 1.83.0 (90b35a623 2024-11-26) (built fro=
m a source tarball)"
CONFIG_HAVE_RUST=3Dy
CONFIG_RUST_FW_LOADER_ABSTRACTIONS=3Dy
CONFIG_BLK_DEV_RUST_NULL=3Dm
CONFIG_SAMPLES_RUST=3Dy
CONFIG_SAMPLE_RUST_MINIMAL=3Dm
CONFIG_SAMPLE_RUST_MISC_DEVICE=3Dm
CONFIG_SAMPLE_RUST_PRINT=3Dm
CONFIG_SAMPLE_RUST_DRIVER_PCI=3Dm
CONFIG_SAMPLE_RUST_DRIVER_PLATFORM=3Dm
CONFIG_SAMPLE_RUST_HOSTPROGS=3Dy
CONFIG_RUST_DEBUG_ASSERTIONS=3Dy
CONFIG_RUST_OVERFLOW_CHECKS=3Dy
CONFIG_RUST_BUILD_ASSERT_ALLOW=3Dy

--=20
Cheers,
Stephen Rothwell

--Sig_/yBlNzHbr3TlgHPNsrYnF7YC
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmeV8gQACgkQAVBC80lX
0GzZHgf9E8QBvC0oVW7OL0q3aQv79VEhlZdbMj7imKk0yw2NIM54Y7MZqi8IZ4SR
ODKiN0bDvbYRGix2nsFjisV+9oA0As21lZsqrhvmOFCwQiQbrZSWuPBDeZvyQioi
5CIGSVkrI2PNPwvmsQ+9whCxRmOLEEJxivrlPct/9jXHxMOEA3OiE5qRO5V521U3
GO4vpkDDcIREXippTUckwyvXhRnIQGUkCuH9DOoHOe0nkB+u+lk3sfdmlVhzk1Wi
rZNp8UbNdtC4ByJGDR4tvg3cl7fGaMfFhwu7QkynPkGgYS9l7HqwCIRIsrS8mnvQ
lVpWhvZjGaPqP2EHbrJyLhZOsVZcFA==
=HVDT
-----END PGP SIGNATURE-----

--Sig_/yBlNzHbr3TlgHPNsrYnF7YC--
