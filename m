Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 285A625A324
	for <mm-commits@vger.kernel.org>; Sat,  1 Nov 2025 11:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761995069; cv=none; b=MbJSGof03HsfbXvFIbVVQYZoRPvapjbgUGXD/qo2RxcZCjcGLAmBxExAzk3lsuBbFPFtsY5tvDbOtXWD1rDL6L2fUuVIf/VS1afnl9iNlrwD9OmWY7SA1XDaMfX+itY6EE5AtkxJbA4vKTY1aJ/D0gIlLpvEKi7UZ19JTEmWeWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761995069; c=relaxed/simple;
	bh=FheBURbV7TZDxnNW8n5vX2FTuORT7qAWohk/pmM0aH4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=STYHmd20PvLdZkoOJT8PfrkmUmD1iE/4Uu825FKDNADsEo+/pcNuBTDlIoso2rKIMGAUNjy1NE3hVeYThTVHP/uA32VTdQLZlwbgpwrJxhiMdKZSQWW+thyudZwBwEi8A7gCJP1ABTra1Hgis0lj9oXg41WyBF5QJ31k+BX3fCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gpPnqwTQ; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gpPnqwTQ"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-429c48e05aeso743485f8f.1
        for <mm-commits@vger.kernel.org>; Sat, 01 Nov 2025 04:04:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761995065; x=1762599865; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=apl1Cu2rbpZhYZwCLV2QIVTvMntERYkzsffY+tEoBEQ=;
        b=gpPnqwTQoEADYdfhxk3Yv+yo64v4jiuYBp4Q6nAKKNZcb7kwtzGhBTicFIa9JLCyl8
         S5+hIuxPZ8xMLCt08wNDzVt835o5c7fhpvYMqsvQOjlax1s3BGymduH89eMxRkKsQ2wJ
         zCRdil1zyXLFnpWiWA9Sm8VVeo3A5ANC4TJBsopeDw9NDACRFWxRr5ZQMouK0orhiAPP
         UizUzIrsb46MEfeLOokcsqH0TRt8Qt8HOxQiGMbFiTvVofanoTwwVc4pB48qrqEi8MZv
         cvW5HsHpmLbAXbFggLURC5smIhnoKZHVTjMDBGhN2mmDqOBnj80WG9bkidTNEambI1IU
         cwJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761995065; x=1762599865;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=apl1Cu2rbpZhYZwCLV2QIVTvMntERYkzsffY+tEoBEQ=;
        b=FmG3NRp8ubRft9+9bFlUWka1qFtzLuwL2EspkHTqOh/ZeWSV6PHqM5ox8k7z6xxW5M
         slZNj98F5C3LZCyGkeQjOUj2oJiP6A9+wBoSFUOo+j0d22TtZzfd6H6ErvYtsvN4HkW/
         TowNfE+pgWfhyrejIhovmbvRbh6tznqMf9yYdNkph3APsyfbILRisxlYvUlsYvJu9OJ0
         2roiuxS6enydFCOBYJ2HHbHHY7W/SYZEzBcXJ79BsWDmlfscrdk3dwormJClwbuFqb7E
         BvvzYZCngwLCqNUGFNWeJzU769r+PBYr5u0NeghvACFVv0ClhvhelqCVwx990W/zv2nD
         +iQQ==
X-Gm-Message-State: AOJu0Yw+KWzHkQBxQgq3BzIUhevMOU0fuE/sKwEHxjSbAMOtk3na0KEl
	v345FRndyn/9iweJv1KztKB3QvLVtXYmFbWMV6NSwuSox8lEKMLlV8QW
X-Gm-Gg: ASbGncv8k5zqaU3tiYCGAq/Ruc5dQEeGKzKt3smUodixzCSyPWz2P3hjI5Lf7vFNnJO
	HoyGfO5DA+Pco5PcJ177G9dT+TQIQZBJBHirYfDR830WPBDVLUrBFYLAPsRsCFG8t7/6G+nyjor
	XQMrXYzbPXDzqwWl58brJAG+ZOBouHwVNmT5/l9yUXd0VZwqzt5v3AVh5kO2BVF1PpK0XX2ddO0
	Uo/XFFt4VX3OKtLA0iLEI2VxqucG7FJ3JtliNl9rkQSfDPvntJkCzEaCYAXmfgnFgkrKUyYT4nM
	TPro691BxF/ii5uDt0uJ8HSys/U6C4DoAYOjSKlmcJvI31Gn06qdwesIvVDaZbyGN0sm8IqLHG7
	jHedf2p41QjsQ52WRnxyNu2icjOO2yTyPN8MCkRuHvJ/Ngk0L/W5kuQvb498z1bmlPz8aCoc+zG
	NtX5pYAzDohi40dk0q3aQDkaerUE+jAeISjp0N1s8KsiNn6wmEsIayMh7v5QIuvJg=
X-Google-Smtp-Source: AGHT+IFymuQXpY5xegfvh98e0AYi28i/OHVRmemty2RDDy2BKtfaO/El+NxPTit0UaTEVbg5AwQgKQ==
X-Received: by 2002:adf:e193:0:b0:425:86da:325f with SMTP id ffacd0b85a97d-429bcda2109mr6809870f8f.27.1761995065233;
        Sat, 01 Nov 2025 04:04:25 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429c140629dsm8510167f8f.46.2025.11.01.04.04.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Nov 2025 04:04:24 -0700 (PDT)
Date: Sat, 1 Nov 2025 11:04:23 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, yukuai3@huawei.com,
 u.kleine-koenig@baylibre.com, tglx@linutronix.de, peterz@infradead.org,
 oleg@redhat.com, npitre@baylibre.com, mingo@redhat.com,
 lirongqing@baidu.com, hpa@zytor.com, bp@alien8.de,
 biju.das.jz@bp.renesas.com, axboe@kernel.dk
Subject: Re: +
 lib-add-mul_u64_add_u64_div_u64-and-mul_u64_u64_div_u64_roundup-fix.patch
 added to mm-nonmm-unstable branch
Message-ID: <20251101110423.5225d94a@pumpkin>
In-Reply-To: <20251101021205.F0A89C4CEE7@smtp.kernel.org>
References: <20251101021205.F0A89C4CEE7@smtp.kernel.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 31 Oct 2025 19:12:05 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> The patch titled
>      Subject: lib-add-mul_u64_add_u64_div_u64-and-mul_u64_u64_div_u64_rou=
ndup-fix
> has been added to the -mm mm-nonmm-unstable branch.  Its filename is
>      lib-add-mul_u64_add_u64_div_u64-and-mul_u64_u64_div_u64_roundup-fix.=
patch
>=20
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree=
/patches/lib-add-mul_u64_add_u64_div_u64-and-mul_u64_u64_div_u64_roundup-fi=
x.patch
>=20
> This patch will later appear in the mm-nonmm-unstable branch at
>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>=20
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
>=20
> *** Remember to use Documentation/process/submit-checklist.rst when testi=
ng your code ***
>=20
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days
>=20
> ------------------------------------------------------
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: lib-add-mul_u64_add_u64_div_u64-and-mul_u64_u64_div_u64_roundup-=
fix
> Date: Fri Oct 31 07:10:15 PM PDT 2025
>=20
> fix mul_u64_add_u64_div_u64() test, per David
>=20
> Link: https://lkml.kernel.org/r/20251031205917.56763269@pumpkin
> Cc: Biju Das <biju.das.jz@bp.renesas.com>
> Cc: Borislav Betkov <bp@alien8.de>
> Cc: David Laight <david.laight.linux@gmail.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Li RongQing <lirongqing@baidu.com>
> Cc: Nicolas Pitre <npitre@baylibre.com>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Thomas Gleinxer <tglx@linutronix.de>
> Cc: Uwe Kleine-K=C3=B6nig <u.kleine-koenig@baylibre.com>
> Cc: "yukuai (C)" <yukuai3@huawei.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>=20
>  arch/x86/include/asm/div64.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> --- a/arch/x86/include/asm/div64.h~lib-add-mul_u64_add_u64_div_u64-and-mu=
l_u64_u64_div_u64_roundup-fix
> +++ a/arch/x86/include/asm/div64.h
> @@ -90,7 +90,7 @@ static inline u64 mul_u64_add_u64_div_u6
> =20
>  	asm ("mulq %[mul]" : "+a" (rax), "=3Dd" (rdx) : [mul] "rm" (mul));
> =20
> -	if (statically_true(add))
> +	if (!statically_true(add))

That is wrong you failed to add both !
Should be:
	if (!statically_true(!add))
The test is there to remove the add/adc pair when 'add' is a constant zero.

I'd tested the code for constant 0 and constant non-zero, but not
for non-constant non-zero.
Then managed to post the patches without running the tests :-(

	David

>  		asm ("addq %[add], %[lo]; adcq $0, %[hi]" :
>  			[lo] "+r" (rax), [hi] "+r" (rdx) : [add] "irm" (add));
> =20
> _
>=20
> Patches currently in -mm which might be from akpm@linux-foundation.org are
>=20
> mm-vmscan-remove-folio_test_private-check-in-pageout-fix.patch
> mm-khugepaged-unify-pmd-folio-installation-with-map_anon_folio_pmd-fix.pa=
tch
> drivers-base-node-fold-register_node-into-register_one_node-fix.patch
> mm-vmstat-fix-indentation-in-fold_diff-function-fix.patch
> memcg-manually-uninline-__memcg_memory_event-fix.patch
> mm-change-type-of-state-in-struct-memory_block-fix.patch
> init-mainc-wrap-long-kernel-cmdline-when-printing-to-logs-fix.patch
> panic-sys_info-factor-out-read-and-write-handlers-checkpatch-fixes.patch
> lib-add-mul_u64_add_u64_div_u64-and-mul_u64_u64_div_u64_roundup-fix.patch
>=20

