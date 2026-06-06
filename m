Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98F3D8634C
	for <mm-commits@vger.kernel.org>; Sat,  6 Jun 2026 02:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780713004; cv=pass; b=LhhPoUU3SZDZQyJZJGzXYB4cN9eYzhg/jVrOi/4ISQHaclwoCsGgOULUFxUIzAh8PhoH4Nbi58y0JoR+KKaVks1pPaYQQ0O4FSQLHVferN0z9oCfQJG2XTAeRGgs7la5c7zlLAB/kANkmcSoNtMiGAAzu3GGI1djpPFG+BzT8DI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780713004; c=relaxed/simple;
	bh=EXANmh/ywlK4e0hwJMwhFWkXDLwtigHSGAnIEtMnqv8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nfLJM+RQwiDc0jeNtMNqBgjXofgW+s3BMXIvCjuXq/lLlo7HakyPKzRqYNSA7xT609e+94bbeApmnDR9ZlKrlLEKPVb3mywARnFK36X5whWxkJYR6WumTRGfeGERa40NRFvBIBg6F7FOI98nFUqK6Rb7iS/Oq65DGiOJmSZL4QU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ns3x1xFH; arc=pass smtp.client-ip=209.85.128.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ns3x1xFH"
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-7de68222e96so23182487b3.2
        for <mm-commits@vger.kernel.org>; Fri, 05 Jun 2026 19:30:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780713003; cv=none;
        d=google.com; s=arc-20240605;
        b=hUvQYdK5vUb4wOt/te3xFX/ay2bH7zCW/s7JcLJeEKjQ1KXLvICJjKPU523exHIX+c
         WkZcvuCECP+1WnVvEvlDZAMJ+HJqYXgXQLDkTxLODP1XgAsFaFI72lbuxKGJhR5VoJhh
         eeKhMHuBXMtYT1GVXTaFjId2o/KKnVxFHeh0fBqu3oZ0WRCJ14NqoT/GvxBULmc/4uNC
         LkZhx97aH0NzEA7wTsC7FTyXjzbPN7dsYvmBjIl0MfRa8qD+WYzcCsFiuQx/d5sUd1jL
         3YDWzACz9wOwT5KYgbilfpIedcVJCztuFAHY7cOGVkliN8OumIOr++4/FmM95jb1UKqD
         x/8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=s3E730+rPMSwtRJDTdUu59jPzwPY+qvqBc0Pkksfv/o=;
        fh=h7CjvTGPFADvhjSdElGEYMcLuIzCRU0Jj4z7kog1nHc=;
        b=lqHuHby0UzLzt9frsi88UA+TLYeNiSfmHvENKKaAVfkHTOb7PW3czrCJISVJ1a5cnv
         6uLeIxdfRjr4Ihfu362Fsmr4utcxD3hxkTLWPha/y4lSlbB8agMLhejWkPq/Cfkz4Y7Y
         pxhUxNhtkxPVn3qzXmlMlwH9yy581RaytZcQaP+dYxEKwdeBnnyrz6qWhDkY90ApXJjO
         CsyYuMN55a9dqZgtcnTePw/G4q6qtTwAZOhr2dtMzUUnvihsm+k1nFRLLY+q8F45I37g
         YZoUY6nkPuOzc3TGZY0Dm+uvowPZIx/V8s5y2l8qNOexZ1SWvtPrjjLpckzSH+Da1FHs
         uNOQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780713003; x=1781317803; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s3E730+rPMSwtRJDTdUu59jPzwPY+qvqBc0Pkksfv/o=;
        b=ns3x1xFHj53JaSxujpYw3Oa8pOUBO5hvbVQy1+mcsDnuZsfZAuIg7YaZrvgxPDYwxf
         igf+GoSn5QlggfvE28lf6SXRmuA2T47V+gKdUHYX7zHGP+RTIJ/Q4kI/iibolVfkLwiU
         YioMOUQw6wLPxGpCbKfgnCnJoSklb6IcaG1wUigqJ0ILQ3Er/hqoTXGLieCDMV7Kgw0c
         Yw8QMV317ByxddkgMy9A3IpDpmyUVMcGKBkh6XV1zVEsyFUf8OoytBqfk7g4uJTx20lK
         SwiGp95Czmj7Q2Yyq/m5CddWsAZW9J0/7tkxbdex7OtnNvxH9ihA5gwxZr7klfFJt5Wb
         U5aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780713003; x=1781317803;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=s3E730+rPMSwtRJDTdUu59jPzwPY+qvqBc0Pkksfv/o=;
        b=asjbxrP1GP93MlufrNRNUIsSAQ13N4jZfb4M1WL15WRNkYnvlExl9GUgtdzmQSHaF9
         ZuG9bGltjsDKJcoL4B+hqhtM+VS9ECP6TCNY4P1E3ZWLBupigx3pywA0/CKgr9tN1HoT
         wJK+od+60wfhnjhPnHFJYgLLavG5VROuKF4Lxx6ymE8awda6VXnt0b67cCAQsjgdgdYr
         MiZN69ttkhl5omuv8HyBNVOkLwZixbpnIy+4mZQJI2d51VK6uDrIW+AWu/TuG4Mk9Z3k
         AlzYhs+079KM07Z5hMWOCvxFiWnBakrVB7pDAW/7JV/DrVF3GmYOZu9V/xFzPNGNbOOh
         g0YQ==
X-Gm-Message-State: AOJu0YxvsmPCreECk+SSzgnpepGc61NAWplGjnPfANV2L5L9ll2GCshy
	+qnUQzJPteRnjUG5Dx106d9wLjUiS53JFY5IkqlBTrUkgQGrdt91ZGdAlhgKgQtHRi9ezr5TQVW
	v00Shcu5FWrtNTv/Yk1wnL/ZPIjbmXZY=
X-Gm-Gg: Acq92OEvNyQgEIdyhJjyNeUPmCanQj6JPi1cNis9lXeD/XR2l6nKXLbdhT1VyqdSD/e
	Rcu95TNYL4Xi3j8iHlFMLqLCKs8jkJV25c2vn3YymFE9k0co4PCHPiwBaXpINa+RQJdlSWnRcmx
	Z6Dy+gJpwoz4ABei2txEO/6XFPfue64IZMmwsnja1uFJPDxm3DAu4hmc3RMzSABd/STp+cF6s3y
	DdNLUfJFVQT+CxBiHzak5tUKcebpwyN+H5nDPB+8CVwziylQGPIabZOEoJAeHfyTu/koMV6TwFN
	c9IgEyw0Auon163W2w==
X-Received: by 2002:a05:690e:1381:b0:65d:7db3:5598 with SMTP id
 956f58d0204a3-66106e00e55mr5542163d50.1.1780713002748; Fri, 05 Jun 2026
 19:30:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260606013254.96CA41F00893@smtp.kernel.org>
In-Reply-To: <20260606013254.96CA41F00893@smtp.kernel.org>
From: Maxwell Doose <m32285159@gmail.com>
Date: Fri, 5 Jun 2026 21:28:03 -0500
X-Gm-Features: AVVi8CffonNZe03BUnNyDQCPJ3vNW658y8pmeeb8XRBUFjm7SOxVEAUVSMFTDWg
Message-ID: <CAKqfh0Eenm536jtRZ=0dwobpanBxXHk+4sauON-tQcTi9dcQZg@mail.gmail.com>
Subject: Re: + fs-efs-remove-unneeded-debug-prints.patch added to
 mm-nonmm-unstable branch
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, fabf@skynet.be, brauner@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 5, 2026 at 8:32=E2=80=AFPM Andrew Morton <akpm@linux-foundation=
.org> wrote:
>
> The patch titled
>      Subject: fs: efs: remove unneeded debug prints
> has been added to the -mm mm-nonmm-unstable branch.  Its filename is
>      fs-efs-remove-unneeded-debug-prints.patch
>
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree=
/patches/fs-efs-remove-unneeded-debug-prints.patch
>
> This patch will later appear in the mm-nonmm-unstable branch at
>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>

Thanks for merging this. I know that EFS is orphaned, so I was
wondering if I could step up to maintain it. Mathew Wilcox had
mentioned how this filesystem is incredibly outdated and it should
probably see conversion to a FUSE, however in the meantime it should
probably see more fixes, modernizations, dead code removal, etc. I
hope I'm not being too hasty, given I've only sent about 2 patches in
fs!
