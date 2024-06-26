Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7990E54D
	for <mm-commits@vger.kernel.org>; Wed, 26 Jun 2024 01:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719365759; cv=none; b=Cit+c80gqKaMGDKwNvAEq0GRS03gOx72Z66KZPMMCI+yq+9ONMukPqfHPR4uElciG5CAU+OPpQ6KZh6FzxwliFUHivcwP/XQlCzdd2tx6peHX5J5pMWI5XoCmKKFLVD4hqbd6OTA4L08WIVK+4KzmppAFYiPcuzX6qufnbaDp6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719365759; c=relaxed/simple;
	bh=4QDnpjQXXtuLwXJz+XaETK7fmKm9LwWa6q7IDWfZfe4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SY7xy5NnBBc9ASH1PUSU/iO2OAAOPvo6TY5sJv8NW34Fg/zqLgv5lx/qy/Ilvy78HbJ8PWOnexy08eSC5iMniTYENySjeKtjH5+RiXUufeZXFFj7vlZopqdfQbLzF93NS62eCQHkbHIBRcmExp0I6Xq8flqPydHISL857Gyf19s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C1bBkhdz; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C1bBkhdz"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-57cc30eaf0aso3709320a12.2
        for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 18:35:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719365756; x=1719970556; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2pn5UY2YjmF/74MyvrfgCrPVH+7c1dPWHCBBJc/nGPw=;
        b=C1bBkhdz+FPJvMAqom2Sy1Y7pX2hXNoVKn8gLkTgNPkymNcQZhh2T+ZSGRCt2TyLsp
         JHT1IbjB3TDBvjG0xHMsyB/5KiiZ1H6LAMxYU5oNzG/OZmENQKCnlfTTJHYHsJpSOq/7
         h3SoWWU34d69OGfEkVIbh9PylrricSwKb4Eig6aZE8jj1KgzRPs1tzUI+rhcq4wFF5Ia
         DlThb46CQ/2Kwl/L2dz9nSqVvqjKdShoxGEnClE/VJbMUbRT42hQjFD61FqHuLY1lysd
         XncFnwt6yHbTENgcRV83jTs4HCD3ou+zlcpt96/xFkCSIpbX+MifmX758+WjSmbwbpm+
         YNxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719365756; x=1719970556;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2pn5UY2YjmF/74MyvrfgCrPVH+7c1dPWHCBBJc/nGPw=;
        b=TijcTWbo8ujY9ZO7QfaBLeg2Lkql2b1G+2PvAZ2AT4G3DLnzg5xWUVTSVpQSl/cYoG
         nvI5XndpiMOROYzeyNc0S2L2Pdu77g0MYjeVVbX/V5/0O1ymkw5SfwqzNr1jbuiIMyg4
         XueX7l5ufC7XZVRTI4PbWmNTxXvtF6+6xBpA3hAe/U0B0PwP25tUN+8jeu+906vl9KHV
         G4lEqBXRXwTTVvmQ6bVUUMsSJx7Sra7m5bli0kTbOSIdsHywWWJ+dGuHxeqb6h2t2lG0
         cHQM7UYvfwjxK1WKP/b6qqXlETbf3MsW7t6rsW6KRrKymnsl3SLZtpgSXVnUeuLj2K4T
         pA8Q==
X-Gm-Message-State: AOJu0YxKZLDv5QAg2UZty+2rjSsE3mmeSdD1xZ/GOfF5jirN8ocovr0Q
	sfp4i1BmFdBYdrytjAz/DfwMVv0+c9YPV3C66DGpt5UjxXxUNdH8ELhqkhfoL0onV81eCnkIBl+
	1HRonpH+UY1ufweJwct40FlBUW516ZwYtRGiAgThc
X-Google-Smtp-Source: AGHT+IH0vFXKU6R2VzZFlzu9+4LU6IE102FgnREK1vqS8ZyMU/5G/gO3Z7cobxe+IM4tJNTEG2D5y4Ur8LBdxgtXvCg=
X-Received: by 2002:a50:d55b:0:b0:57d:669:caf2 with SMTP id
 4fb4d7f45d1cf-57d4bd9705amr7436790a12.25.1719365755818; Tue, 25 Jun 2024
 18:35:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240625215530.EC3B2C32781@smtp.kernel.org>
In-Reply-To: <20240625215530.EC3B2C32781@smtp.kernel.org>
From: Lance Yang <ioworker0@gmail.com>
Date: Wed, 26 Jun 2024 09:35:44 +0800
Message-ID: <CAK1f24kbhKvGwsJwopdXZd6wU+pA3M5wRE4PMvzB88O_3+U75A@mail.gmail.com>
Subject: Re: + hack.patch added to mm-unstable branch
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 26, 2024 at 5:55=E2=80=AFAM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
>
> The patch titled
>      Subject: hack
> has been added to the -mm mm-unstable branch.  Its filename is
>      hack.patch
>
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree=
/patches/hack.patch
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
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: hack
> Date: Tue Jun 25 02:51:36 PM PDT 2024
>
> um, Lance?

LGTM.

I think this patch has fixed the bug[1] introduced by me.

[1] https://lore.kernel.org/all/20240622100057.3352-1-ioworker0@gmail.com/T=
/#u
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202406260514.SLhNM9kQ-lkp@int=
el.com/

Thanks again for stepping in to help!
Lance

>
> Cc: Lance Yang <ioworker0@gmail.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  mm/huge_memory.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> --- a/mm/huge_memory.c~hack
> +++ a/mm/huge_memory.c
> @@ -2696,7 +2696,6 @@ static bool __discard_anon_folio_pmd_loc
>         struct mm_struct *mm =3D vma->vm_mm;
>         int ref_count, map_count;
>         pmd_t orig_pmd =3D *pmdp;
> -       struct page *page;
>
>         if (folio_test_dirty(folio) || pmd_dirty(orig_pmd))
>                 return false;
> @@ -2732,7 +2731,7 @@ static bool __discard_anon_folio_pmd_loc
>                 return false;
>         }
>
> -       folio_remove_rmap_pmd(folio, page, vma);
> +       folio_remove_rmap_pmd(folio, pmd_page(orig_pmd), vma);
>         zap_deposited_table(mm, pmdp);
>         add_mm_counter(mm, MM_ANONPAGES, -HPAGE_PMD_NR);
>         if (vma->vm_flags & VM_LOCKED)
> _
>
> Patches currently in -mm which might be from akpm@linux-foundation.org ar=
e
>
> hack.patch
> mm-allow-reuse-of-the-lower-16-bit-of-the-page-type-with-an-actual-type-f=
ix.patch
> mm-extend-rmap-flags-arguments-for-folio_add_new_anon_rmap-fix.patch
> mm-use-folio_add_new_anon_rmap-if-folio_test_anonfolio=3D=3Dfalse-fix.pat=
ch
> tools-mm-introduce-a-tool-to-assess-swap-entry-allocation-for-thp_swapout=
-fix.patch
>
