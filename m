Received: from mail-oo1-f50.google.com (mail-oo1-f50.google.com [209.85.161.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7F8F25EF94
	for <mm-commits@vger.kernel.org>; Tue, 11 Mar 2025 22:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741731096; cv=none; b=PDEt1Jvd6BsS7Cd5q7wzWc5xNsSkng2GNnMReUih9bQGLQPK+S2p6RwGYWBwfw9kMN4Zwyp/1NYPWpV8MCztLouSz14sw7I8MU3cF7A/Gmo+XisklHqYcN/sScMdNQ9L8ZKlNIOyppj980Z5jI3lAKuFbdiD+F+eK3AOswZ4Wc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741731096; c=relaxed/simple;
	bh=H638nurSNv/gXZBVdx7BG+74Ne/ItEPqCBlDtXNkMV4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Aii4hgTDiTpRwTqXS43mdEaReznqkOKy/+8qvbS7Xsj86WXvQXSAWxrrrqbJyF70iQxkms8VHzvXmPm78BAfUkQ8Zb0lquBFDZwpQx9JNwQoJZWUX0PzpmLZ6sHCoy3AKoBlnFI7/N80f/Ki6OtqN55IXsvuHvBURZ5l8WM8cNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=iu6wIRe2; arc=none smtp.client-ip=209.85.161.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="iu6wIRe2"
Received: by mail-oo1-f50.google.com with SMTP id 006d021491bc7-6002337132eso203203eaf.0
        for <mm-commits@vger.kernel.org>; Tue, 11 Mar 2025 15:11:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1741731094; x=1742335894; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=laQ4qLi2Jx6SgYLBdzGp6aVAMZXKU+qnYHEebIDbzms=;
        b=iu6wIRe20f7MEbGP5jHNVPvGEIAwJXA0mVx8Rq+sJLQSPsQP7NMu1FUhK92RAFnFRa
         UlGnES8D5arT9f2SVQlw3dbOEBo+XJNA/oUoBwBt6KuG/yp0j9xOXfdPYjizTLtVBvwk
         F0FO1hUL2H0Z8X9vgoCZ2CRleQVHF9t6PvaiM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741731094; x=1742335894;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=laQ4qLi2Jx6SgYLBdzGp6aVAMZXKU+qnYHEebIDbzms=;
        b=tGuWYVP6DN7ROAPdXWNMj3fG1wqmNXBwDA0bjlsQnlxCSohJGu+ZOsjGMGxRE5foKs
         /SJpnmc69NgRjohZWb0kr3b7t5jcjfIlGI4ZU3OoiCTh7qOkssfLHGrXwJn1C5vqdlUg
         bQ3De4RapgxVBUMe6wtkyfUjBfxC97hzALGw/KROWDgar1qtU0q3fJJkocCgw5CEqPh9
         ZDUGDk1RTxO7kltpXsebmmd14yxK2q7mvIZj4ZwaM4iRCyk1hyQdtQH0pMeKzlnP72fb
         SfoWJnIFRqlRv+Gen6XqMXTRPRGHd/9Z6EFpqg92lRwrJGBuWPoSlHQVRPftB2UKFopI
         qJmg==
X-Gm-Message-State: AOJu0YwByiYnOXyg5lpq4hKdU+bn/L/N2dYpeJ9B8icf2tF6eMw8mkrX
	00Lm1mTJlqZq/y7dHJLZioCxmZSqpuLC+1Z8YnidKKeO64ERvRb+dljUdGMHNuVxhkMqsdwRXQj
	74C4xXNEgKxHgThDs2h0uO5AU9ou8VRsLF3BJ
X-Gm-Gg: ASbGnctVrOtwBDtn/Ai2vgnvafRX3K0Sm71ZT54T1OWIueIM2HMLcTW0GgMQ+mn6GZp
	lT3H8iTPPDgbtTeBkSx1R+jlTlwSX/ZrAO/CJDi3ppjm4rH+F01TY0Ih7+zxpe8dQ6on9JpiVlO
	msVtbbOa1qVynzRAr6flphGNU0
X-Google-Smtp-Source: AGHT+IF0pJduw1ma59xwRVSNs97llx9AIjMxE1hIAivFmUNIEjJwvq/C38Tdbfy62mn2+fhi9PmPoimqaJcb4pOvZxQ=
X-Received: by 2002:a05:6820:458f:b0:5fc:92ed:639a with SMTP id
 006d021491bc7-6005a21992bmr1692622eaf.2.1741731093895; Tue, 11 Mar 2025
 15:11:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250311174209.D1BC2C4CEF0@smtp.kernel.org>
In-Reply-To: <20250311174209.D1BC2C4CEF0@smtp.kernel.org>
From: Jeff Xu <jeffxu@chromium.org>
Date: Tue, 11 Mar 2025 15:11:22 -0700
X-Gm-Features: AQ5f1JrU-LpZv7OwHwsPVTyoHiNWlLZDuvYtDTpSvJ6mRFmIRe_LcLV5kqKYRzQ
Message-ID: <CABi2SkU2YnTV7caq+JqsO1baC0dbHm8ZibBPRfg+_WebmbC2Zg@mail.gmail.com>
Subject: Re: + mseal-sysmap-generic-vdso-vvar-mapping.patch added to
 mm-unstable branch
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, thomas.weissschuh@linutronix.de, 
	svens@linux.ibm.com, lorenzo.stoakes@oracle.com, liam.howlett@oracle.com, 
	gor@linux.ibm.com, borntraeger@linux.ibm.com, agordeev@linux.ibm.com, 
	hca@linux.ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 11, 2025 at 10:42=E2=80=AFAM Andrew Morton
<akpm@linux-foundation.org> wrote:
>
>
> The patch titled
>      Subject: mseal sysmap: generic vdso vvar mapping
> has been added to the -mm mm-unstable branch.  Its filename is
>      mseal-sysmap-generic-vdso-vvar-mapping.patch
>
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree=
/patches/mseal-sysmap-generic-vdso-vvar-mapping.patch
>
> This patch will later appear in the mm-unstable branch at
>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
>
> *** Remember to use Documentation/process/submit-checklist.rst when testi=
ng your code ***
>
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days
>
> ------------------------------------------------------
> From: Heiko Carstens <hca@linux.ibm.com>
> Subject: mseal sysmap: generic vdso vvar mapping
> Date: Tue, 11 Mar 2025 13:33:25 +0100
>
> With the introduction of the generic vdso data storage the VM_SEALED_SYSM=
AP
> vm flag must be moved from the architecture specific
> _install_special_mapping() call [1] [2] which maps the vvar mapping to
> generic code.
>
> [1] https://lkml.kernel.org/r/20250305021711.3867874-4-jeffxu@google.com
> [2] https://lkml.kernel.org/r/20250305021711.3867874-5-jeffxu@google.com
>
> Link: https://lkml.kernel.org/r/20250311123326.2686682-2-hca@linux.ibm.co=
m
> Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
> Cc: Alexander Gordeev <agordeev@linux.ibm.com>
> Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
> Cc: Jeff Xu <jeffxu@chromium.org>
> Cc: Liam Howlett <liam.howlett@oracle.com>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Sven Schnelle <svens@linux.ibm.com>
> Cc: Thomas Wei=C3=9Fschuh <thomas.weissschuh@linutronix.de>
> Cc: Vasily Gorbik <gor@linux.ibm.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  lib/vdso/datastore.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> --- a/lib/vdso/datastore.c~mseal-sysmap-generic-vdso-vvar-mapping
> +++ a/lib/vdso/datastore.c
> @@ -99,7 +99,8 @@ const struct vm_special_mapping vdso_vva
>  struct vm_area_struct *vdso_install_vvar_mapping(struct mm_struct *mm, u=
nsigned long addr)
>  {
>         return _install_special_mapping(mm, addr, VDSO_NR_PAGES * PAGE_SI=
ZE,
> -                                       VM_READ | VM_MAYREAD | VM_IO | VM=
_DONTDUMP | VM_PFNMAP,
> +                                       VM_READ | VM_MAYREAD | VM_IO | VM=
_DONTDUMP |
> +                                       VM_PFNMAP | VM_SEALED_SYSMAP,
>                                         &vdso_vvar_mapping);
>  }
>
> _
>
> Patches currently in -mm which might be from hca@linux.ibm.com are
>
It is better to insert this patch before the architect specific change,
and right after
selftests: x86: test_mremap_vdso: skip if vdso is sealed

So the newly added selftest (selftest: test system mappings are
sealed) would pass in bisect.

Thanks
-Jeff









> mseal-sysmap-generic-vdso-vvar-mapping.patch
>
