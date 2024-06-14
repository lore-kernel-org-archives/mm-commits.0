Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20334FBFD
	for <mm-commits@vger.kernel.org>; Fri, 14 Jun 2024 14:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718375542; cv=none; b=BA/vhcfy4SmnV0jdvasyez1sI+L1GfPsAA458itvW6s1YMWm7UDF3LGDFgydsyxzG4boeHIj+HbpzP+xziCdqpAPzgFOhfQ9+4QdPQ4ZjKMmIznxzu8u0ANgGumht1tJDkQqthGWm0NWaYZ2hlvPHBbVISaYqMTh6VHXk/KnUr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718375542; c=relaxed/simple;
	bh=xsASbtE5WL9HQWweP3+jadPtcj/gM10cfxD0j3St3jU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TItYiXO0tieUS/SPF8DwVgiyKGHv/XIAjiBxkf1RsvnhhrnF5qeqhxwkms4JvhRTuC2BFiAdXat6LTTcDMJyurxx1oMQSj5flAdlwzYvZp2nJL5VNvF5EKbB8l3+brh9rzim1jmlJY/qxYRN2oFNMu2ZuwUbTg5bAuAYbv9K/9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=L4wH6mgg; arc=none smtp.client-ip=209.85.160.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="L4wH6mgg"
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-24c9f892aeaso1066543fac.2
        for <mm-commits@vger.kernel.org>; Fri, 14 Jun 2024 07:32:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1718375540; x=1718980340; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HhRhTfzuQX8dMprZm34DZGp+p2/jXLtKC2TaH9/0MEM=;
        b=L4wH6mggJXH0d6a4JgEVTTxprhef2rZYFofpNRwpaVwzFI7cZLXomduuoMobgkVvv+
         w1eAmw7SH65/QyYfv7a9EFAhYMPbyydTh6K59QE/pNC2V+3CWniQ/qlE40PAfqR0vMrZ
         HJKkL41s/dMy+mz2BzdTJRpA6OAWYniNooy5I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718375540; x=1718980340;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HhRhTfzuQX8dMprZm34DZGp+p2/jXLtKC2TaH9/0MEM=;
        b=SMHA94tpAldv1+i4XylsT6ZDLt+dHofh0nyB1WbBEUmaKfoaqD3YGH9kEVojvGzOb1
         XFzMbwsVhXDmJdexzCFNoJab08MjPEg62Wrv2WE9J2dZFGeGKTgzK+k1c6DnaYH9Nh2A
         tU30c5qvDnzi9doUEcvdP8C5dDGxdxjiYAMiE/vUFyQOPdrjx2mKQp6ZHIZew7LHlGzM
         W8x/bbPrMIDoUTgV4ZwSw8IKyVu8FnnicXzbU3b7x6asCk3SR/M2XAND58sCazB85Gs8
         MvIjJVPKxfMpEPgq7jJov8SXGodqK19UvD9FvhUiBu6Yprnc6ZFtk7FDUfAyV+vAlmlM
         +Vdg==
X-Gm-Message-State: AOJu0YwxA+UXqn+q+ze61CIbhBxxgojE4JD/Ojo6epciqRMDRIdjvZRy
	h+naiuxxfd/AumHaaP/4k/Co4nMNRueqhyE0uWTsR1Pxc9NGzFOdOhsLjvUW0C4n+9edjeCcrIc
	6T9um30UK08iZfK9gjh+0UmB7OT7KCt7PbWJgVqRMiP2PCHhzCA==
X-Google-Smtp-Source: AGHT+IFEtqpk7cOOpxrAfvKzVwLfHvcbaBhVNl4LHLUUFvix2mFlJ+vlAjnLm7LJhzxJyqo0NwOOeO0/6ME51zdKkg0=
X-Received: by 2002:a05:6870:8a28:b0:250:725f:ed4d with SMTP id
 586e51a60fabf-2584288ff26mr3289574fac.3.1718375540282; Fri, 14 Jun 2024
 07:32:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240612192325.009E0C116B1@smtp.kernel.org>
In-Reply-To: <20240612192325.009E0C116B1@smtp.kernel.org>
From: Jeff Xu <jeffxu@chromium.org>
Date: Fri, 14 Jun 2024 07:32:07 -0700
Message-ID: <CABi2SkW4eg27XTe6otutK8P1MgK0MMnLdwWAuEDks98_aZku=Q@mail.gmail.com>
Subject: Re: + mm-memfd-add-documentation-for-mfd_noexec_seal-mfd_exec-v3.patch
 added to mm-hotfixes-unstable branch
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, rdunlap@infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

By fixing the document, the usage of MFD_NOEXEC_SEAL shall be clear.
Was the previous patch (which  changed ABI)  removed from unstable ?

I pulled the mm-unstable this morning, it seems that patch is still here.
I'm not sure about the process of reverting it, hence asking.

c1e11be9abae86ebe5cecc42abc412f61ae563c6
 memfd: `MFD_NOEXEC_SEAL` should not imply `MFD_ALLOW_SEALING`

Thanks
-Jeff

On Wed, Jun 12, 2024 at 12:23=E2=80=AFPM Andrew Morton
<akpm@linux-foundation.org> wrote:
>
>
> The patch titled
>      Subject: mm-memfd-add-documentation-for-mfd_noexec_seal-mfd_exec-v3
> has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
>      mm-memfd-add-documentation-for-mfd_noexec_seal-mfd_exec-v3.patch
>
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree=
/patches/mm-memfd-add-documentation-for-mfd_noexec_seal-mfd_exec-v3.patch
>
> This patch will later appear in the mm-hotfixes-unstable branch at
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
> From: Jeff Xu <jeffxu@chromium.org>
> Subject: mm-memfd-add-documentation-for-mfd_noexec_seal-mfd_exec-v3
> Date: Tue, 11 Jun 2024 23:14:08 +0000
>
> Link: https://lkml.kernel.org/r/20240611231409.3899809-2-jeffxu@chromium.=
org
> Signed-off-by: Jeff Xu <jeffxu@chromium.org>
> Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  Documentation/userspace-api/mfd_noexec.rst |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> --- a/Documentation/userspace-api/mfd_noexec.rst~mm-memfd-add-documentati=
on-for-mfd_noexec_seal-mfd_exec-v3
> +++ a/Documentation/userspace-api/mfd_noexec.rst
> @@ -1,7 +1,7 @@
>  .. SPDX-License-Identifier: GPL-2.0
>
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> -Introduction of non executable mfd
> +Introduction of non-executable mfd
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>  :Author:
>      Daniel Verkamp <dverkamp@chromium.org>
> @@ -30,7 +30,7 @@ use of executable memfds and an attacker
>  To address those above:
>   - Let memfd_create() set X bit at creation time.
>   - Let memfd be sealed for modifying X bit when NX is set.
> - - Add a new pid namespace sysctl: vm.memfd_noexec to help applications =
to
> + - Add a new pid namespace sysctl: vm.memfd_noexec to help applications =
in
>     migrating and enforcing non-executable MFD.
>
>  User API
> _
>
> Patches currently in -mm which might be from jeffxu@chromium.org are
>
> mm-memfd-add-documentation-for-mfd_noexec_seal-mfd_exec.patch
> mm-memfd-add-documentation-for-mfd_noexec_seal-mfd_exec-v2.patch
> mm-memfd-add-documentation-for-mfd_noexec_seal-mfd_exec-v3.patch
>
