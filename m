Received: from mail-yb1-f178.google.com (mail-yb1-f178.google.com [209.85.219.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D24B655C3D
	for <mm-commits@vger.kernel.org>; Mon, 29 Jan 2024 13:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706535800; cv=none; b=iVXcgvyfhyWRrNfpnWjnsc6smnq8Cww/vgGYuaPmYuYaRnlasjBkuaykHhNIuz4yR9ZLtOO+Rnjg5xeD/oRniUUA/6WEVOLSSye3ODi9aYbahPvDbW3OvwrbMAWM3NTn7vPjvnUaLj6Mlym1oy/kNBq202pbQbCAvJaiFAVdBpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706535800; c=relaxed/simple;
	bh=cTT74gfEWee8/hMyUTvdyIkagbVjzUAO6GnDNuetlw8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UZc8oj0b0mfopiXa8Qga9JakbA5fy5+PwZSfaGJEug8vgPMFewPZUIeNC8qEhM0ZJwyaFm69l9zYXWeHSTxzUFsd7FaGIpJaqWEQpi6oGOiTP0tD0zKkK7IovCRlQQKTiTdSStd2x9FA9HhUoTfw9H3V20xVuORNNJt+S38qX+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OwFZcNBN; arc=none smtp.client-ip=209.85.219.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OwFZcNBN"
Received: by mail-yb1-f178.google.com with SMTP id 3f1490d57ef6-db4364ecd6aso2099084276.2
        for <mm-commits@vger.kernel.org>; Mon, 29 Jan 2024 05:43:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706535798; x=1707140598; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wbJkIXpKY9RRl74KuGYOCEHMwoMb+cG2EL6DXTSuVvE=;
        b=OwFZcNBNepEl5zzWuQgg2ayzmTF1Q2OKYDTvTbPzIbl+T1fl8x5vhqNAXGOo/NTbHP
         MZqKwwcLLgad78YHOK85K27GyxZsdKiPNe6zfEfKKdcUzpVJMp1Fdjiy24uL8J/526G8
         GT+pY9jH2+uvvb7dWvlTgmf3jlH7JV/Ll+WVFqra3TlQRb2WF4V/l+6PTBkZjVmgiJOA
         DGUqSQ2JhZVl6ecCXDqxDcmM9mOxNtI67+9b96Tv03VHf5vZmG6Un+dvPjs15GDoZL2q
         WfmYxQQnbxno4mozd/bIfBin7sXadG/HQg8QVyTdCiJInpY2erzGlA4mgxSF/9csA858
         M9mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706535798; x=1707140598;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wbJkIXpKY9RRl74KuGYOCEHMwoMb+cG2EL6DXTSuVvE=;
        b=bcRfeoGrA/H8wFAVUYJXPLWJF8LMiqi24BA/fxJt7C9bOVMBYl5gPmzfSh2uaULJnm
         y5Ho14t9YyuIMCJgf0V2Rz61/rzcIZutTCA52/aKD15sBt8oV2FfB/WbhqEx8MVv/cEp
         V2xiBNKt2tEt1el5ZskaQGFkkm5qH9ZnyvAZmfMZNh0tD1UCNF5M1Yk6UN7RhKxIKqVF
         yf135MHlZUPhyQAYEKdCHRvgO/LhZoHr8nV4qcZnAinpn+7ATpKhBuyqDq8xWZQWxqIB
         XNtLC75e6SoBV7iqBhsACMu70xmEuB4jecdimUK7KKTFChAwcRP1uQq8AVxUsVlkNDHy
         OZeg==
X-Gm-Message-State: AOJu0Yz/0aq3jYriPUyRmE10xY8SweMxlWSuLd80KNy+FBL3bjCcQ7j3
	HarCnK3OeLZdk2akOGQ5uRkWiCmSYnNk3wRYNTc/Lu25hMDCplYWDEytaL8xvb/HuETcAzQD13h
	iuhsJ34W3ykRk/kSv4Jkcpnq0h04=
X-Google-Smtp-Source: AGHT+IHZRHfVMwFGt0WV3+g1xv1qI/HysJO3My+Kan7UfcI1txKpdQ8r1jiz9CdSrVvUwoCCbMCrrsx6fcb2UHdgFhw=
X-Received: by 2002:a25:8491:0:b0:dbe:346b:b9d with SMTP id
 v17-20020a258491000000b00dbe346b0b9dmr2161819ybk.125.1706535797648; Mon, 29
 Jan 2024 05:43:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240129104741.204D7C433F1@smtp.kernel.org>
In-Reply-To: <20240129104741.204D7C433F1@smtp.kernel.org>
From: Lance Yang <ioworker0@gmail.com>
Date: Mon, 29 Jan 2024 21:43:06 +0800
Message-ID: <CAK1f24mUQC8KZYG7G3-==90aXhUjA5CConBhzDip58M_TLKs1A@mail.gmail.com>
Subject: Re: + mm-khugepaged-bypassing-unnecessary-scans-with-mmf_disable_thp-check.patch
 added to mm-unstable branch
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, zokeefe@google.com, songmuchun@bytedance.com, 
	peterx@redhat.com, minchan@kernel.org, mhocko@suse.com, david@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hey Andrew,

Thanks for taking time to review!
I really appreciate your time!

BR,
Lance


On Mon, Jan 29, 2024 at 6:47=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
>
> The patch titled
>      Subject: mm/khugepaged: bypassing unnecessary scans with MMF_DISABLE=
_THP check
> has been added to the -mm mm-unstable branch.  Its filename is
>      mm-khugepaged-bypassing-unnecessary-scans-with-mmf_disable_thp-check=
.patch
>
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree=
/patches/mm-khugepaged-bypassing-unnecessary-scans-with-mmf_disable_thp-che=
ck.patch
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
> From: Lance Yang <ioworker0@gmail.com>
> Subject: mm/khugepaged: bypassing unnecessary scans with MMF_DISABLE_THP =
check
> Date: Mon, 29 Jan 2024 13:45:51 +0800
>
> khugepaged scans the entire address space in the background for each give=
n
> mm, looking for opportunities to merge sequences of basic pages into huge
> pages.  However, when an mm is inserted to the mm_slots list, and the
> MMF_DISABLE_THP flag is set later, this scanning process becomes
> unnecessary for that mm and can be skipped to avoid redundant operations,
> especially in scenarios with a large address space.
>
> This commit introduces a check before each scanning process to test the
> MMF_DISABLE_THP flag for the given mm; if the flag is set, the scanning
> process is bypassed, thereby improving the efficiency of khugepaged.
>
> Link: https://lkml.kernel.org/r/20240129054551.57728-1-ioworker0@gmail.co=
m
> Signed-off-by: Lance Yang <ioworker0@gmail.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: Muchun Song <songmuchun@bytedance.com>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: Zach O'Keefe <zokeefe@google.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  mm/khugepaged.c |   18 ++++++++++++------
>  1 file changed, 12 insertions(+), 6 deletions(-)
>
> --- a/mm/khugepaged.c~mm-khugepaged-bypassing-unnecessary-scans-with-mmf_=
disable_thp-check
> +++ a/mm/khugepaged.c
> @@ -410,6 +410,12 @@ static inline int hpage_collapse_test_ex
>         return atomic_read(&mm->mm_users) =3D=3D 0;
>  }
>
> +static inline int hpage_collapse_test_exit_or_disable(struct mm_struct *=
mm)
> +{
> +       return hpage_collapse_test_exit(mm) ||
> +              test_bit(MMF_DISABLE_THP, &mm->flags);
> +}
> +
>  void __khugepaged_enter(struct mm_struct *mm)
>  {
>         struct khugepaged_mm_slot *mm_slot;
> @@ -1422,7 +1428,7 @@ static void collect_mm_slot(struct khuge
>
>         lockdep_assert_held(&khugepaged_mm_lock);
>
> -       if (hpage_collapse_test_exit(mm)) {
> +       if (hpage_collapse_test_exit_or_disable(mm)) {
>                 /* free mm_slot */
>                 hash_del(&slot->hash);
>                 list_del(&slot->mm_node);
> @@ -2360,7 +2366,7 @@ static unsigned int khugepaged_scan_mm_s
>                 goto breakouterloop_mmap_lock;
>
>         progress++;
> -       if (unlikely(hpage_collapse_test_exit(mm)))
> +       if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
>                 goto breakouterloop;
>
>         vma_iter_init(&vmi, mm, khugepaged_scan.address);
> @@ -2368,7 +2374,7 @@ static unsigned int khugepaged_scan_mm_s
>                 unsigned long hstart, hend;
>
>                 cond_resched();
> -               if (unlikely(hpage_collapse_test_exit(mm))) {
> +               if (unlikely(hpage_collapse_test_exit_or_disable(mm))) {
>                         progress++;
>                         break;
>                 }
> @@ -2390,7 +2396,7 @@ skip:
>                         bool mmap_locked =3D true;
>
>                         cond_resched();
> -                       if (unlikely(hpage_collapse_test_exit(mm)))
> +                       if (unlikely(hpage_collapse_test_exit_or_disable(=
mm)))
>                                 goto breakouterloop;
>
>                         VM_BUG_ON(khugepaged_scan.address < hstart ||
> @@ -2408,7 +2414,7 @@ skip:
>                                 fput(file);
>                                 if (*result =3D=3D SCAN_PTE_MAPPED_HUGEPA=
GE) {
>                                         mmap_read_lock(mm);
> -                                       if (hpage_collapse_test_exit(mm))
> +                                       if (hpage_collapse_test_exit_or_d=
isable(mm))
>                                                 goto breakouterloop;
>                                         *result =3D collapse_pte_mapped_t=
hp(mm,
>                                                 khugepaged_scan.address, =
false);
> @@ -2450,7 +2456,7 @@ breakouterloop_mmap_lock:
>          * Release the current mm_slot if this mm is about to die, or
>          * if we scanned all vmas of this mm.
>          */
> -       if (hpage_collapse_test_exit(mm) || !vma) {
> +       if (hpage_collapse_test_exit_or_disable(mm) || !vma) {
>                 /*
>                  * Make sure that if mm_users is reaching zero while
>                  * khugepaged runs here, khugepaged_exit will find
> _
>
> Patches currently in -mm which might be from ioworker0@gmail.com are
>
> mm-khugepaged-bypassing-unnecessary-scans-with-mmf_disable_thp-check.patc=
h
>
