Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF8A2188713
	for <mm-commits@vger.kernel.org>; Sat,  6 Jun 2026 02:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780713499; cv=pass; b=R6rmQQ/MaW7xTDbvwO+BByDhgksDvvnvOfhpfsqNNaAciyP6NRmdLdOQgKWlVnREyWluplW5rj0U3vryTGJ+5PS5CYEwoSPVivJygdGIaaiBuk0SZiOYzLmzBLnSVC+A+8O59warGPNd73ZFx640pys6NCPbn84yI1b3DPezKFc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780713499; c=relaxed/simple;
	bh=GnrDLODfK+Sd7LSjARshDxdwGqQkm/jizusI6WXNm/c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mbaHIq39mUV5qH/bgg+iXNcrbUqghEBrqVyz47PqDWpt1083rYFZyD/1/M9p+sWPx6xWFqsOerGrlQ2YkStqjpknSgTyrOgeee9gO05KWzgXhUDPmb1JyLErA9/tQvsC9R19G8qbvx4kDtvjTc9JnQDFuk3DDpags45GwupixzU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a8/X8iD7; arc=pass smtp.client-ip=209.85.128.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a8/X8iD7"
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-7ea16f090b4so35442587b3.2
        for <mm-commits@vger.kernel.org>; Fri, 05 Jun 2026 19:38:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780713497; cv=none;
        d=google.com; s=arc-20240605;
        b=YMcfaFJ2V0y7wOnPWO8ByZ9esmWzv7Dy2PEY7DpPIwBq2G2/d3rLF5oQRZ6p8uPdc0
         4k1Awvanzbp2yJAcTtOkZUbs/YPHB2KIjhWQFjEXshS8lwUaFSgAF8GI6aBu6xNIxEZw
         CRVPXPpuzSW8+bpbkaOoXDnv7giglBc3NO2jiim92PFVE+0ZHne0Rl1MgQIea+1Log30
         2AzrQwIqH3T0jQVOfEonUPYkRMRDIxieIbZ50zIkQ1yhxKOgtFsdDqhxaI0yY4OKmuF1
         d8KcBZssuNSFtRBp1WIxr/RpNZVn5PJDvv0jFfLkPjgCyvrgPP2Q+ingPNWLKLO+e20O
         wjhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ExWnRtUtQF+wRc/a1ltCbkvrjt2SUEm9s0qRivOGI0Q=;
        fh=h7CjvTGPFADvhjSdElGEYMcLuIzCRU0Jj4z7kog1nHc=;
        b=bc6M66Fhe9UaSguo2/78y5h604+Twbc87soZn803iAjrYe31i3gWOEvcsYd2khL6AB
         eGX8JgcR+y//SmAZMXuyANqaAfv7248D5I65rJnAgS7Dw6CQ4dTYZMYDam22Nl81kkQ3
         BVNLpLW/ToCpuSogLaXP6VMA8jIMDst8Os20YRlHmmbeTsgvIvp3Ust1PUEe4wSg75qi
         apKYR6eAn3/9cI02cDq8l2ZR2SsyuyCmlKIJR2UkzLx2TYeGRLuwd1Sl4ZPFSzK0QCnX
         8nWIQ1OYm8JHfHYhLGrODcMFkYtrtJiJI+Wvsu/atX0qKfjiocPGNz662T9Qpv0XL4mS
         VNpg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780713497; x=1781318297; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ExWnRtUtQF+wRc/a1ltCbkvrjt2SUEm9s0qRivOGI0Q=;
        b=a8/X8iD7odtFRfgbzIJvcTbCwK+EVV5lj5Y1rwa0k6blg/ZUQ5mob7E5AkCyFnXhjX
         /vBE7oJzwLkKvlxnGAVCuUoPNbm6thLqwnxLU4J8IFXF6X/NETu/RR/L681PU41iaBp0
         8qguq6NioO1A5pFWJygLgqgARzxSkWQk+zC16yUBHPFPZf5iM76G0WF91MsoCqnfv259
         7lsX/oMQI6wK2Vw9o+FoV1gTKc5CFV5Fv8xnzpRLPVGeDgVdNMfKxNEdnaMbmVGZrhta
         C5NOnRqK570UpfQEuOK7BwlL9ieB8WqGiHV0xxi0hqqF9LYwhIV6jfyYyrBd8YE4lD94
         7o9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780713497; x=1781318297;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ExWnRtUtQF+wRc/a1ltCbkvrjt2SUEm9s0qRivOGI0Q=;
        b=stjAYdqvCdv9pyeB2mrIpAJyRiNFqoJVH5st42pZpwLpn4FepPKcXL5bSLfyW+ScOt
         j5AqSZ8EtfqJhgc8fDVWNCoyxhm1MIZQypD40V9ldXjbJpwSrkQ7NaOhbDYFYFjVPJaw
         GzM6Ei3CU2gAcRdp3TH1aIFCEjqzrSnysth3bpf+ZhsqT3E+4Hd+VvCDXcYDzR5wXNZK
         +8NMDwmm5Y08IU0gRTwyiVnS4Hs3MZ3QFU5AEYT+9aFhl4tcVUjQCufv/3iszaBlwwoC
         eiI9fD4uSS7HqpBKDG1pV9as/H9w/zLjMhJxyeCxhhgT9AKIlZrgP6M/hUDQ/1YGaAX6
         40jg==
X-Gm-Message-State: AOJu0YxC/JCSCruKrf1G4SlWquYRZDg5mLGb0/61Vnkiermeon2BWckN
	99OEAmC7TZU5qsxWcoqNZtnmiMN9j0me5+x4rKckJgGWj498PDj03b5PN3FknHBXof5HXpQCkqz
	zgPAHBCFreyMZclmiM9xyapUzXt6BViR+iHt1BCc=
X-Gm-Gg: Acq92OHq9c5/MnHB2LGuVrvu5a6cbB9VL4dhZkBVGKRX0VL8vN/6+UDYad5K0mcHHuQ
	Mli7F3m8VWh0wpXOycptcE97w8LLgB6zB3C6uYeLZX5SyKZQCKaBippolheL/meqKxVLY9a54gk
	6CcbOkl9Bs+SQE6QBffdtFJs6BtsS1p8IfRU425reLGklu0XtiS66KDlW6DSu4Pc+MAn0v+SYYd
	hQ15zVSBKaY1ycpnqUdUffj0r8ePjDfAJ1H7373WJOEUfl4v2Xf6KJsz8UDh1GhOtp4FcPPJmsy
	tecvTx5/lpBcAkZqyA==
X-Received: by 2002:a05:690e:1248:b0:660:6b45:18c2 with SMTP id
 956f58d0204a3-66106fb3ce0mr5759295d50.63.1780713496995; Fri, 05 Jun 2026
 19:38:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260606013254.96CA41F00893@smtp.kernel.org> <CAKqfh0Eenm536jtRZ=0dwobpanBxXHk+4sauON-tQcTi9dcQZg@mail.gmail.com>
 <20260605193524.f277071da69189161e84e327@linux-foundation.org>
In-Reply-To: <20260605193524.f277071da69189161e84e327@linux-foundation.org>
From: Maxwell Doose <m32285159@gmail.com>
Date: Fri, 5 Jun 2026 21:36:17 -0500
X-Gm-Features: AVVi8Ce6jFKg97PXaalhAA8hF48Ag22B4TLU-0wKFLhvEAaQqp2NB8syhBaoVqw
Message-ID: <CAKqfh0GDX9kpUYfu72U+qQi8FUQZ0w6aQRrZngtfsM6j1fn1ZA@mail.gmail.com>
Subject: Re: + fs-efs-remove-unneeded-debug-prints.patch added to
 mm-nonmm-unstable branch
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, fabf@skynet.be, brauner@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 5, 2026 at 9:35=E2=80=AFPM Andrew Morton <akpm@linux-foundation=
.org> wrote:
>
> On Fri, 5 Jun 2026 21:28:03 -0500 Maxwell Doose <m32285159@gmail.com> wro=
te:
>
> > On Fri, Jun 5, 2026 at 8:32=E2=80=AFPM Andrew Morton <akpm@linux-founda=
tion.org> wrote:
> > >
> > > The patch titled
> > >      Subject: fs: efs: remove unneeded debug prints
> > > has been added to the -mm mm-nonmm-unstable branch.  Its filename is
> > >      fs-efs-remove-unneeded-debug-prints.patch
> > >
> > > This patch will shortly appear at
> > >      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/=
tree/patches/fs-efs-remove-unneeded-debug-prints.patch
> > >
> > > This patch will later appear in the mm-nonmm-unstable branch at
> > >     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> > >
> >
> > Thanks for merging this. I know that EFS is orphaned, so I was
> > wondering if I could step up to maintain it. Mathew Wilcox had
> > mentioned how this filesystem is incredibly outdated and it should
> > probably see conversion to a FUSE, however in the meantime it should
> > probably see more fixes, modernizations, dead code removal, etc. I
> > hope I'm not being too hasty, given I've only sent about 2 patches in
> > fs!
>
> Fine by me, and thanks.  But I believe Christian is the guy to speak
> with regarding this.

Thanks, I'll shoot him an email and note that you were fine with it.
