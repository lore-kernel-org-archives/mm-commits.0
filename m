Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 430C34A1D;
	Sun, 26 Jan 2025 23:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737934077; cv=none; b=iRJX0GBRVQ0UfmSpo37gm6CoqAuhcPzgKIt26ZyEPKddzaZ58qZ7Ful80ZES9E27GHpI6YMf4GCwCOwSakivTASjiNcbYlzzOdaPu40l5UcUtXaAv8sS//Ece0OFE9bbEyyFdox2M7f1ghlzXYCHuh5a27JY7U+U64jfacViy8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737934077; c=relaxed/simple;
	bh=C1aSx+jGzsjOs/7FnJrsAkb27Gz5mzZTTsaVG+LDBAY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bVc1gLbcKgABUezoaM3n575n/YEF0p3YpSkC9Lt1hy/+HHM2qQOvCiTVh2cQdC30XQ4JsIlRSFHqc3zfA/8uIEQisNz4iJLDjEHacdAyK2E+82LSfjkETOdB8AN/A5+3QorAbPgEZTtjyCR8qEp3ni3x6bsl/oTFwesmdhjIDOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ArS9MgBB; arc=none smtp.client-ip=209.85.208.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ArS9MgBB"
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-3043e84c687so32885761fa.1;
        Sun, 26 Jan 2025 15:27:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737934073; x=1738538873; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=3IRwCnv7W7pXatZi8FC19DBe9YIc5UlOSytWvb/DyOA=;
        b=ArS9MgBBFfu5dsqspYPUKIVDSymoHL5auIeDTqIhCDXYfdaiNLk7snchtdaECigDcM
         jeZZ3aKtwBDjQLKry3nSSBeYHQhs8dV1FrmRVC0G+IL3x4LnwBPKZi7nPnEqI4Ns2qXP
         5RMavlxp3Ai35kaEmSJLOJKJ7n1WhYib1YsBiabvqRlwKcG7n38lNzio0raTXWTeEfXv
         p/BkMXeZDRrqgYZcYnOBTyYsYrNCHAWgv7kEQ8p6p8yrLx4a54/NAx5zNqMoshXETN5H
         ehnFQ6P81NcTXTNNEV47p9lrLs7/Bg1/EngFZXB/+WVMGlDly1R9wC20U4h8/EEiE4hq
         1ogQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737934073; x=1738538873;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3IRwCnv7W7pXatZi8FC19DBe9YIc5UlOSytWvb/DyOA=;
        b=h8oGlIe96Fm2RvhoTEXia/dCcIFKMi/V+pj4XvYFp6/sxMtC01jKDannguJxXzXyuB
         VAdli0NqkKjIjeF1cjoBawhh7nCTL6i+WrBxWpPZfG+ohF3w438WhElWc4NatwfZXD3P
         AJKKy4engb5QdXNfXjGwjhOkpckP0SagSrzd3D0kv66ZbBDtBm2hlOenG3wIzlmdZGzs
         AkgVA5UrtCaZA5oNabvGKJIxYU7bUN3DLTkcN29lT5AWL0BM+HbECddETmn8cptbq+Lc
         DZ5cLqfwbcDPWq6H7/oR7MQo51qqs5r+Pdo4kTaiTBmLykOnWjBI3hv8/njaOxRw/72u
         Y2hg==
X-Forwarded-Encrypted: i=1; AJvYcCWupbPo3yG+b6bKDj9A/jZihXTGPp6x4bcV1aEK2VCxw/ogZKVd7uSqBp7oir7lfkgdjNKFtXhIPoXr6Q==@vger.kernel.org, AJvYcCXt9H+ccKl3lSY1JxISkoXyFck4F6+r/Ajd9hFUy2S3fCWwYZSKJ/aJR3UKRFL1uNkvu8rZ0aEyU6j+sDk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7B+Hs2/p4mCTb89njXVdqpcGf3jFQS1U1pVsdY1N2Xy6uD3w7
	y4qx7NF+CB7aFUg9dhbH1G5MgR4iPz7ufP0ZMK91kFmiDLCtiitorqES5Ghy3qr6RPCfii3F4LQ
	xkR4zG9A84ueiSJA9M2OG2PKNSfvT9eEO
X-Gm-Gg: ASbGncvLgDYPDBTO5s3BCYOppTAPKY18JWIiIritdW5dH5FFtmLZFYC3QTVL6B8CvZ5
	7GI/nBuIq6rW2HqeAABffIHm+ghc/EoAOB3ogEQPxketpT0gxZB/lz/Oxk8P5eg==
X-Google-Smtp-Source: AGHT+IF0hfD1QLAUjhJOhP9juTjaQr9SX7CyasHVYeczo0EabLdSjUt1Zl5DQQqqF9oE4KI8LdQ6wARPhaJUWq08VbM=
X-Received: by 2002:a05:651c:501:b0:300:33b1:f0cc with SMTP id
 38308e7fff4ca-3072cb3cd3fmr167929911fa.34.1737934072816; Sun, 26 Jan 2025
 15:27:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250124162248.60104eec848619a187242392@linux-foundation.org>
 <CAHk-=whddBhfi5DUi370W3pYs+z3r2E7KYuHjwR=a1eRig5Gxg@mail.gmail.com>
 <CAFULd4ZWS4Cxv0CELosQHJh9vTqOJFdr+Fk9NMgSREr_dFG05A@mail.gmail.com>
 <CAFULd4a-2F_zKMeR0Yjo2WhRLmyoOQ1VdR2qdV34BrM-b_cQCQ@mail.gmail.com>
 <CAHk-=whgufZwjAuL1PBs1gjSMK95TEhGj1SiMbNvkysWBcEPMw@mail.gmail.com>
 <CAFULd4Z2eSJhE0qF0QEtsb-7zoOMKH=KvvrfK0M5UozLw_TYUA@mail.gmail.com> <CAHk-=wjmThGBZCxmBTypng2NEczY7cdJi2Dotf7ygun=hu_EGQ@mail.gmail.com>
In-Reply-To: <CAHk-=wjmThGBZCxmBTypng2NEczY7cdJi2Dotf7ygun=hu_EGQ@mail.gmail.com>
From: Uros Bizjak <ubizjak@gmail.com>
Date: Mon, 27 Jan 2025 00:27:40 +0100
X-Gm-Features: AWEUYZldCS95-C_CY74lGUf-7ro2thZvXRcJtAU-V2rnBGmh4kdpc6IEIMF3_oY
Message-ID: <CAFULd4aDuPA3rig9BzD_P1Y62S0Y5Yv_8AxpjtwTddv4OPNoHg@mail.gmail.com>
Subject: Re: [GIT PULL] MM updates for 6.14-rc1
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary="0000000000000dc00d062ca44fc4"

--0000000000000dc00d062ca44fc4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 26, 2025 at 11:00=E2=80=AFPM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Sun, 26 Jan 2025 at 11:47, Uros Bizjak <ubizjak@gmail.com> wrote:
> >
> > >   #if __clang_major__ >=3D 19
> > >   # define CC_HAS_TYPEOF_UNQUAL 1
> > >   #endif
> >
> > It is available in gcc-14.
>
> Ok, let's take that approach, instead of messing with CONFIG_CC_HAS_xyz.

Please find attached an incremental patch that implements the proposed appr=
oach.

The detection is put in include/linux/compiler.h where we can
consolidate checks for both compilers:

--cut here--
/*
 * Declare compiler support for __typeof_unqual__() operator.
 *
 * bindgen uses LLVM even if our C compiler is gcc, so we cannot
 * rely on the auto-detected CONFIG_CC_HAS_TYPEOF_UNQUAL.
 *
 * XXX: Remove test for __CHECKER__ once
 * sparse learns about __typeof_unqual__.
 */
#if ((defined(__GNUC__) && __GNUC__ >=3D 14) ||        \
     (defined(__clang__) && __clang_major__ >=3D 19)) &&    \
    !defined(__CHECKER__)
# define CC_HAS_TYPEOF_UNQUAL 1
#endif

/*
 * Define TYPEOF_UNQUAL() to use __typeof_unqual__() as typeof
 * operator when available, to return an unqualified type of the exp.
 */
#if defined(CC_HAS_TYPEOF_UNQUAL)
# define TYPEOF_UNQUAL(exp) __typeof_unqual__(exp)
#else
# define TYPEOF_UNQUAL(exp) __typeof__(exp)
#endif
--cut here--

The above also consolidates checks for __CHECKER__, resulting in a
much simpler compile check in arch/x86/include/percpu.h.

I have tested the new patch series with a bunch of compilers, works as
expected, but it is getting a bit late here. I'll resend the series
tomorrow, after some more testing.

Uros.

--0000000000000dc00d062ca44fc4
Content-Type: text/plain; charset="US-ASCII"; name="p.diff.txt"
Content-Disposition: attachment; filename="p.diff.txt"
Content-Transfer-Encoding: base64
Content-ID: <f_m6e92crf0>
X-Attachment-Id: f_m6e92crf0

ZGlmZiAtLWdpdCBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL3BlcmNwdS5oIGIvYXJjaC94ODYvaW5j
bHVkZS9hc20vcGVyY3B1LmgKaW5kZXggMWVmMDgyODllNjY3Li45ZjA4MzFhNWU3MTIgMTAwNjQ0
Ci0tLSBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL3BlcmNwdS5oCisrKyBiL2FyY2gveDg2L2luY2x1
ZGUvYXNtL3BlcmNwdS5oCkBAIC05NSwxMiArOTUsNyBAQAogCiAjZW5kaWYgLyogQ09ORklHX1NN
UCAqLwogCi0vKgotICogWFhYOiBSZW1vdmUgdGVzdCBmb3IgX19DSEVDS0VSX18gb25jZQotICog
c3BhcnNlIGxlYXJucyBhYm91dCBfX3R5cGVvZl91bnF1YWxfXy4KLSAqLwotI2lmIGRlZmluZWQo
Q09ORklHX1VTRV9YODZfU0VHX1NVUFBPUlQpICYmIFwKLSAgICBkZWZpbmVkKENPTkZJR19DQ19I
QVNfVFlQRU9GX1VOUVVBTCkgJiYgIWRlZmluZWQoX19DSEVDS0VSX18pCisjaWYgZGVmaW5lZChD
T05GSUdfVVNFX1g4Nl9TRUdfU1VQUE9SVCkgJiYgZGVmaW5lZChDQ19IQVNfVFlQRU9GX1VOUVVB
TCkKICMgZGVmaW5lIF9fbXlfY3B1X3R5cGUodmFyKQl0eXBlb2YodmFyKQogIyBkZWZpbmUgX19t
eV9jcHVfcHRyKHB0cikJKHB0cikKICMgZGVmaW5lIF9fbXlfY3B1X3Zhcih2YXIpCSh2YXIpCmRp
ZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L2NvbXBpbGVyLmggYi9pbmNsdWRlL2xpbnV4L2NvbXBp
bGVyLmgKaW5kZXggZWFjNTgwMjVlY2ZjLi43YTUyYmVhNGJhNzYgMTAwNjQ0Ci0tLSBhL2luY2x1
ZGUvbGludXgvY29tcGlsZXIuaAorKysgYi9pbmNsdWRlL2xpbnV4L2NvbXBpbGVyLmgKQEAgLTMx
NCwxMyArMzE0LDI1IEBAIHN0YXRpYyBpbmxpbmUgdm9pZCAqb2Zmc2V0X3RvX3B0cihjb25zdCBp
bnQgKm9mZikKICNkZWZpbmUgcHJldmVudF90YWlsX2NhbGxfb3B0aW1pemF0aW9uKCkJbWIoKQog
CiAvKgotICogRGVmaW5lIFRZUEVPRl9VTlFVQUwoKSB0byB1c2UgX190eXBlb2ZfdW5xdWFsX18o
KSBhcyB0eXBlb2YKLSAqIG9wZXJhdG9yIHdoZW4gYXZhaWxhYmxlLCB0byByZXR1cm4gdW5xdWFs
aWZpZWQgdHlwZSBvZiB0aGUgZXhwLgorICogRGVjbGFyZSBjb21waWxlciBzdXBwb3J0IGZvciBf
X3R5cGVvZl91bnF1YWxfXygpIG9wZXJhdG9yLgorICoKKyAqIGJpbmRnZW4gdXNlcyBMTFZNIGV2
ZW4gaWYgb3VyIEMgY29tcGlsZXIgaXMgZ2NjLCBzbyB3ZSBjYW5ub3QKKyAqIHJlbHkgb24gdGhl
IGF1dG8tZGV0ZWN0ZWQgQ09ORklHX0NDX0hBU19UWVBFT0ZfVU5RVUFMLgogICoKICAqIFhYWDog
UmVtb3ZlIHRlc3QgZm9yIF9fQ0hFQ0tFUl9fIG9uY2UKICAqIHNwYXJzZSBsZWFybnMgYWJvdXQg
X190eXBlb2ZfdW5xdWFsX18uCiAgKi8KLSNpZiBkZWZpbmVkKENPTkZJR19DQ19IQVNfVFlQRU9G
X1VOUVVBTCkgJiYgIWRlZmluZWQoX19DSEVDS0VSX18pCisjaWYgKChkZWZpbmVkKF9fR05VQ19f
KSAmJiBfX0dOVUNfXyA+PSAxNCkgfHwJCVwKKyAgICAgKGRlZmluZWQoX19jbGFuZ19fKSAmJiBf
X2NsYW5nX21ham9yX18gPj0gMTkpKSAmJglcCisgICAgIWRlZmluZWQoX19DSEVDS0VSX18pCisj
IGRlZmluZSBDQ19IQVNfVFlQRU9GX1VOUVVBTCAxCisjZW5kaWYKKworLyoKKyAqIERlZmluZSBU
WVBFT0ZfVU5RVUFMKCkgdG8gdXNlIF9fdHlwZW9mX3VucXVhbF9fKCkgYXMgdHlwZW9mCisgKiBv
cGVyYXRvciB3aGVuIGF2YWlsYWJsZSwgdG8gcmV0dXJuIGFuIHVucXVhbGlmaWVkIHR5cGUgb2Yg
dGhlIGV4cC4KKyAqLworI2lmIGRlZmluZWQoQ0NfSEFTX1RZUEVPRl9VTlFVQUwpCiAjIGRlZmlu
ZSBUWVBFT0ZfVU5RVUFMKGV4cCkgX190eXBlb2ZfdW5xdWFsX18oZXhwKQogI2Vsc2UKICMgZGVm
aW5lIFRZUEVPRl9VTlFVQUwoZXhwKSBfX3R5cGVvZl9fKGV4cCkKZGlmZiAtLWdpdCBhL2luaXQv
S2NvbmZpZyBiL2luaXQvS2NvbmZpZwppbmRleCBhMTUwN2I4NzE0ZTQuLjdmZTgyYTQ2ZTg4YyAx
MDA2NDQKLS0tIGEvaW5pdC9LY29uZmlnCisrKyBiL2luaXQvS2NvbmZpZwpAQCAtODk3LDkgKzg5
Nyw2IEBAIGNvbmZpZyBBUkNIX1dBTlRfQkFUQ0hFRF9VTk1BUF9UTEJfRkxVU0gKIGNvbmZpZyBD
Q19IQVNfSU5UMTI4CiAJZGVmX2Jvb2wgISQoY2Mtb3B0aW9uLCQobTY0LWZsYWcpIC1EX19TSVpF
T0ZfSU5UMTI4X189MCkgJiYgNjRCSVQKIAotY29uZmlnIENDX0hBU19UWVBFT0ZfVU5RVUFMCi0J
ZGVmX2Jvb2wgJChzdWNjZXNzLGVjaG8gJ2ludCBmb28gKGludCBhKSB7IF9fdHlwZW9mX3VucXVh
bF9fKGEpIGIgPSBhOyByZXR1cm4gYjsgfScgfCAkKENDKSAteCBjIC0gLVMgLW8gL2Rldi9udWxs
KQotCiBjb25maWcgQ0NfSU1QTElDSVRfRkFMTFRIUk9VR0gKIAlzdHJpbmcKIAlkZWZhdWx0ICIt
V2ltcGxpY2l0LWZhbGx0aHJvdWdoPTUiIGlmIENDX0lTX0dDQyAmJiAkKGNjLW9wdGlvbiwtV2lt
cGxpY2l0LWZhbGx0aHJvdWdoPTUpCg==
--0000000000000dc00d062ca44fc4--
