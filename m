Received: from sonic311-30.consmr.mail.ir2.yahoo.com (sonic311-30.consmr.mail.ir2.yahoo.com [77.238.176.162])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A99F029A0
	for <mm-commits@vger.kernel.org>; Sat, 30 Nov 2024 09:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=77.238.176.162
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732959518; cv=none; b=mxvlFE26QZW81psLift4DiIsTPL8iRnmVKgjZOxZhhrif7FxIVzOE/FHw5jPjOzCOmSQ/9uBWZxcoOoEj/UMYGY9+CyJ8T/sCgwk8VzxkkEuLwm4FW1MKIkud3F1jLqCe4tKM66+ZSF2MB1bXtvjR+OS/DMsUVXCiLYBEjZmBeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732959518; c=relaxed/simple;
	bh=NEdLnqFEK5w29mmVhU1D1poIH/8w14Nm4Y/sdcm+MR4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:Cc:
	 In-Reply-To:Content-Type; b=daSYn+T8iyxuexlcC7+jt9pNcjzvyi5NfB7h2KFi6mcwbVR0d99CiS6QlTohdE3ytuLNWeP2tH+iXnwi6grUV/GhdA1D7FzoLktLBwAE56+OyWwSSpPVAPRm/fRrejh18uDDyq1P9AI2kvzH+n2LoaYdK45le20rvs96Bvf8QWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rocketmail.com; spf=pass smtp.mailfrom=rocketmail.com; dkim=pass (2048-bit key) header.d=rocketmail.com header.i=@rocketmail.com header.b=ivBhlMnw; arc=none smtp.client-ip=77.238.176.162
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rocketmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rocketmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rocketmail.com header.i=@rocketmail.com header.b="ivBhlMnw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rocketmail.com; s=s2048; t=1732959509; bh=kv/OGB9tyX1EiQOgEesCUwv7jip8A4AT+1f0LMnceJ4=; h=Date:Subject:To:References:From:Cc:In-Reply-To:From:Subject:Reply-To; b=ivBhlMnwgs6/4pVaTF/Ds112NNu8qPqGPCR6Lo4GhdBZXcAAXRsvO6nxWTE6vASrSh8UeZvMkGH/OEDETVfhDF+ek/zqXvNhAjunD+aUaw4hAgUaQkcULNkEP7X5gIyP6U5E9CNNR9V4To+sGSODZUS/IIY1ZMa/9kLbZrCyOHb6II1V6CSCs/76ba7fflXwdG4v+RQ3yN5xghnaA3NAQf3pUUxfzZ+v2thA6m7Jjou6l+kkkekq9xB8VfLRntUmLY67qtz4hHqtDQ3TykZsrJCZ9asB1mLfBC811Df+rXoUz8u78qeS8YYHEpoN3qQ1u9esw7fiCo+nutKOR20Xgg==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1732959509; bh=2pXR08lkXl+5lV3y64ZRvvhsXx3ulkIn1N5jN16yfjm=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=sWiSDZop8YjtCcNSfTblO82xPwy9qugNcq1LeZ/lTUUlKIsdWPOjHTgCJc3wHVM2BOhUR8Uj7RQ2OGttfjaDDz8EdQhXbFTfCE4Bu3h8ENdZ/xXpc5b5t9WIcEX8Eedw/hq9yY81oBvoVgr44XR3GSqI5+SihU3xzFeWH2kt4LJFQUbrWGfFXJHccao6B18YFWbxbsLM/k6OoYC3ULcKNGaQuSiw1C/yoO2TtoSROijmVG3TieqAwcdXUuMz30Arkrz9qYabDO3CzTsMk0iMfHmv+EWAC1WS7FWxWrSSx2USURIeQOY3I/lNCBshYtp7yq0j5Q5VYvWw4425s/Odeg==
X-YMail-OSG: oNo56bwVM1mnttzkt4TqTcx511Bh0dQOahZlT6_2xdYKwAPFXGZvUxf3W4tImre
 _6i4LmWvNL2OReHxKUS8luG_iczRiVUmRdLANZPND9nkKzPbXIKwVWdjJK1jQZiBhHxFmf.HgjbA
 S_fNV6HcKwuLnI49xgk6C4C3oKWXBDEaCMxCay588SfZxCrespoi7Hj01L_j11uKVJqoMkEWqKjH
 AA3ItQVJsxRS4IPlZfeWU80kxEfvwnpaG7ERdPI9I72xMNCAIPKmKKZITVt2tSTxzHNzxy2FPZr.
 H7TQofBB3lsBqqEr2hIXr5GGIA5GRDhNl1KJ8SOOw1uV4s4UCMcoKZ4OZ.WWcktvg_O.aSly.9Rq
 JTz5LnRJwPNwE5CbhlixzWwT118rjPMMYLVY9LsN2uNcUL_FnLFloI0tcexeU0pXRZg_6ozdjTiv
 M1CGYTIlfeM1qfyPvmTga_IRHUnS0cjbxgprEkBFAFqChDHAPCF7d6rE_P0B9I4kmVIOqZR01tlw
 8gUpvKIvy57A2neWbQOC3CdmOsyN5XiEVrsxk8LMwS0X0.WYbm2pd8fB7kTm4wtgPg4978O0X9eh
 NldrPQNmGDa0gfmsALNN_lXSmsaJdQWTpuUGA5.x9az2.37EeQLJqcmK7K.A3a1IlZg3ejpe_FWL
 oZrmMXjNOAkcYxYa4BQ6D9u4t2jZDt_k4zcrkOiCzsnoyQCKV4IhFdjjdkuAHouR8ZeqFWEB2Gex
 bXx0RjU0MkDISxtvZLBp4aRuQouPeGa1nwEifqt59N9Z4Jg7WGC.biMr_08EsJwPl2LucBV09bhC
 jBMrNLb03yy.WhUmzvi2xNglOTGyyU_9Y3xFWxZjsvCIIF8C47W2e7038FdsKymGDkEHVEXVP2m9
 tX_OL10cSav7.n3etupsVAM646RJCcbeP8C_qU41yjOnqtinxv_KWzGhwv619lMh6GDcHLsWMKh9
 JL71n3cu4HG_JioWXK5e3rGy1infYoubQqoWj_RtB.bfGMkuiQdx_tXUr0c2qHxWwFLsyLCKLHzy
 yKxWYAqJ7UTREPP0R_YWSzy3ZkV5E2ePIsI06q1wTFEQ6auRxbPhrbc.dAVhKB_S4k__PtYrUntB
 t5yJgBkP2d8DeyWUJH3iaO3Rha5IFwJaIFDwSKUYCTYzfAEuuLh7yMkqwfBTNxZeuhlgUXRzbgAh
 IrogD9eEWEGAzIMeRAnGUqZZcMN18.fCqOFqmZWG1DM.ViZxl5VM2LKTlrQbKLLoMF80UhvCIUNp
 okR00Z2GStFz1cpk5q0xESIIdY8Ubg7IQ2mFBsR4hwIMWMbfd_5Ws7iF.5yPUbW.NiADkAUBoVAV
 Lmp_djIFtcZCwiP2jgrOpLks1cUFSb4hgKH5pyoaoYnqUsFTKdCcsvEN3zG40gTdUsROFRhIsALp
 UDTiLGMxmx0WVPey7XENA4bfN6YBFhfpbguUlWj023bR6MQ1IuRyDZ8J9FwnTviPV.jbqglmKioA
 8rH0lxW_JZYmDNEez2yR5.a01X4c8h0ojLA094fSVmvvMECJyZKoKN7MRRoWVGXAjE5BM8_vmOwD
 rkbf1AsTiCxRMHBsIhisBNTsq.QlFInTr.0FNIj6M5fuZrBldfoDn25R73nTNGe5lMrwQsomoPDp
 sgUf9Bi6vJp1ZR62q7WJaJVbqidxD0Eljxzdn1Wgp6I1vmKBvGhSiR323YygznIMUCO.0EwoDAH7
 wl0fBd7AnOt1I5POg0ZE2KmFHcUP7lnHpbsWri1Anz39s_ZPou90MAGlVyh2LS9uNhJjM.5JkaV_
 1SjePfl0VrtpaNONWCupVUj_PYmOgezrhpH5bFyw6PFtzzVcCOVJ.25cPUTk8OXhwts_DVoB7N59
 4YKwO1sq4sooXQEbUzjGjIuADgb0MtNnPYc.ctZVxGVXwmKWPSNsP8UwZu5xhY7gF5DdKZG6VZr7
 8eo3.VRPkmNId_dTnWbwnu9a7vycaj8EZv0cnywx.59GU1Q6wOHTbmBdVvAcsCNF96nMcUHbDE5Q
 dGppckF3EHgo8RO3zVUyrcpTQ4NRmeGagboLfUYuKXH2UkkRUZn_pY_yM3E4MQI1kIXI6E6vi3UB
 571_16vWDl5IXDdO_HkSbEZRvX.J.SkFmXJo6yHI3jGhgTWjv6nqsdo.FIqLUDLeHHM8kK0Ijs3m
 sQdbF.WVdQC4poSpT5Il3DbbG8rRR_cXW6s.i.FMXuugM.KGP2F6m1OzJqbjRPqM0waqVUoJhe03
 B3dON0_gKPGx_ppDSyla6Ciob90L5qXqtJRP8zcAOMjJIjUZ8IpCIPxzVIhu42HqXpWADtUkQ1Pa
 FCNH3Gtrnzeufjc1yP_iTtyFigGP.sg--
X-Sonic-MF: <jahau@rocketmail.com>
X-Sonic-ID: 7d371562-10d7-4df8-9a77-a8d0dbac7ec0
Received: from sonic.gate.mail.ne1.yahoo.com by sonic311.consmr.mail.ir2.yahoo.com with HTTP; Sat, 30 Nov 2024 09:38:29 +0000
Received: by hermes--production-ir2-c694d79d9-h5tj6 (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 93363045095c70c2eed3b7a8bbe7d7b1;
          Sat, 30 Nov 2024 09:18:10 +0000 (UTC)
Message-ID: <4f9c5ded-799c-44f7-8911-f8df85f18208@rocketmail.com>
Date: Sat, 30 Nov 2024 10:18:09 +0100
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: +
 drivers-iio-magnetometer-yamaha-yas530c-hack-around-build-error.patch added
 to mm-nonmm-unstable branch
To: Andrew Morton <akpm@linux-foundation.org>
References: <20241130064522.04220C4CED3@smtp.kernel.org>
Content-Language: en-US
From: Jakob Hauser <jahau@rocketmail.com>
Cc: David.Laight@ACULAB.COM, mm-commits@vger.kernel.org
In-Reply-To: <20241130064522.04220C4CED3@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Mailer: WebService/1.1.22941 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo

Hi Andrew,

On 30.11.24 07:45, Andrew Morton wrote:
> The patch titled
>       Subject: drivers/iio/magnetometer/yamaha-yas530.c: hack around build error
> has been added to the -mm mm-nonmm-unstable branch.  Its filename is
>       drivers-iio-magnetometer-yamaha-yas530c-hack-around-build-error.patch
> 
> This patch will shortly appear at
>       https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/drivers-iio-magnetometer-yamaha-yas530c-hack-around-build-error.patch
> 
> This patch will later appear in the mm-nonmm-unstable branch at
>      git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> Before you just go and hit "reply", please:
>     a) Consider who else should be cc'ed
>     b) Prefer to cc a suitable mailing list as well
>     c) Ideally: find the original patch on the mailing list and do a
>        reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days
> 
> ------------------------------------------------------
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: drivers/iio/magnetometer/yamaha-yas530.c: hack around build error
> Date: Fri Nov 29 10:26:17 PM PST 2024
> 
> a temporary thing to avoid breaking people's builds
> 
> Cc: David Laight <David.Laight@ACULAB.COM>
> Cc: Jakob Hauser <jahau@rocketmail.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>   drivers/iio/magnetometer/yamaha-yas530.c |    6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
> 
> --- a/drivers/iio/magnetometer/yamaha-yas530.c~drivers-iio-magnetometer-yamaha-yas530c-hack-around-build-error
> +++ a/drivers/iio/magnetometer/yamaha-yas530.c
> @@ -411,8 +411,10 @@ static int yas537_measure(struct yas5xx
>   		h[1] = (c->k * (c->a4 * s[0] + c->a5 * s[1] + c->a6 * s[2])) / BIT(13);
>   		h[2] = (c->k * (c->a7 * s[0] + c->a8 * s[1] + c->a9 * s[2])) / BIT(13);
>   		for (i = 0; i < 3; i++) {
> -			clamp_val(h[i], -BIT(13), BIT(13) - 1);
> -			xy1y2[i] = h[i] + BIT(13);
> +			if (h[i] < (s32)-BIT(13))
> +				h[i] = (s32)-BIT(13);
> +			if (h[i] > (s32)BIT(13) - 1)
> +				h[i] = (s32)BIT(13) - 1;
>   		}
>   	}

The line "xy1y2[i] = h[i] + BIT(13);" is missing now.

As this is just a temporary patch to avoid build errors, it might not 
matter much. It's unlikely that the Yamaha YAS537 magnetometer comes in 
use in that context. I assume the patch will disappear at some point.

> _
> 
> Patches currently in -mm which might be from akpm@linux-foundation.org are
> 
> fs-proc-vmcorec-fix-warning-when-config_mmu=n.patch
> mm-mempolicy-fix-migrate_to_node-assuming-there-is-at-least-one-vma-in-a-mm-fix.patch
> mm-swap_cgroup-allocate-swap_cgroup-map-using-vcalloc-fix.patch
> mm-page_alloc-add-some-detailed-comments-in-can_steal_fallback-fix.patch
> drivers-iio-magnetometer-yamaha-yas530c-hack-around-build-error.patch

Kind regards,
Jakob

