Received: from mail-vk1-f173.google.com (mail-vk1-f173.google.com [209.85.221.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B98D413C833
	for <mm-commits@vger.kernel.org>; Mon, 25 Mar 2024 06:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711347160; cv=none; b=cb9hbe8ltfJ09O1YADR3l6iB2PYGGYDv3AZvBY6h/2pVieGmxG/tI5ZDIFZqCaRyEljGBVPZhxAWZQVtqeIpX/HjquR1J9BIipIivC9vsx0fCvixWVdPl3Dd6m+eCaDwUprB6SMAwLEFPWucKIVPtYCGdWgqNp8d7tqSRraXgqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711347160; c=relaxed/simple;
	bh=1kzT3zkpJrIS22MX0Kc7egXWtRriS4ToQUvve+FgHhk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Fs8xtRIDvZx2G3m1S/pYN3WY58d7NoPzer3cp1sixOF8gBWH1Wp7y9J+6b3gGf3AfPH4IdB7U68FJTyNtQLZwiZqQlPEc/sv5OnjXMKirlDEpe//OkDdGlkdgFujoC+r8NhS8G9jb3wRjqoRnjZ+Ti6TBHvwYN5o4rYPWEWXHXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XhUbJAwX; arc=none smtp.client-ip=209.85.221.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XhUbJAwX"
Received: by mail-vk1-f173.google.com with SMTP id 71dfb90a1353d-4d4404fbdf5so1424530e0c.0
        for <mm-commits@vger.kernel.org>; Sun, 24 Mar 2024 23:12:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1711347157; x=1711951957; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bOHWEF+IxFWw3T87YpuPIv/highHYx19WtdiRGP6c24=;
        b=XhUbJAwX4Ra23A2OlemLkBqZy4lI+ehOIeZbBTcgOfJKH84l3CaIpIW9jeVlCTFY4B
         tWUYRQCDw0ksJG+dt/M/IOtuHuJL6zCXDvA5tzNHgYg8z8sxze9k8E4Nq4Ad0BmXYgT3
         rm4h86EVD0BDYqShoz+sN078lzlLBz5d4Vp5mDqJF0ypQ6P6K/uEOBQ/S0xt87rmtFEb
         X1B7/G5THeY1ZGNyudeRu7mETn7eU9FzixQurBX9OfK5w6JO9jDyBGWhEgri2mUpYyoZ
         IA6h1md5eeVBSjbyXxa+pHqHkeopbCGgNO+1AM7wPIxvrp+WBr8F3pnWY49fLiad/GSo
         ugYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711347157; x=1711951957;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bOHWEF+IxFWw3T87YpuPIv/highHYx19WtdiRGP6c24=;
        b=FKOHfLYB/p0BRMmCNm/6n1Ge7QjudOy65cQ7k7JCUBLqAMmnPLBHeZONtEkzR6U9Xz
         n4sJor9s8sQIFbMGb2t5s6gxAtHLfDQcAaIe6hTvQYtGKm6Jo7EhVwX0vkestLKCbVpP
         ufj7DKlNdia+rNKUnuf/9RzcUAmA6PBWqXegZ+6LIQdVt+bQI8zZFwQPe57mpIiKefWm
         1/L9pDIObSdgeuG++6/5ShoYt0ubsIrbV1a5KjjQPq4A1q2YfViQXENs/7c3YQDya8Cp
         hDtZMegL0T8ouM8F5uZKUshKfj1bjGMKdkGZ6RbXyRyU/IWCG9Yk3Yi524wYUq+pDjjZ
         /A/w==
X-Forwarded-Encrypted: i=1; AJvYcCUpDG7sLMD7TCSHOyM+oKs1fdHAHcUq6MunOFUntqobg+LkFiIQ3wiiHQw+bkhecYP4bWYogV1rdvsmZH2WMO8Y94oVMAYfLVYh4g==
X-Gm-Message-State: AOJu0YzJiYVo+uyZo2u7SlVdxtFv2sjbZVk1x2XULBhBN/EH0kYGiR/t
	QZ/HrQHawTBnuy98YCzDmuWK0DP+i/Y+ckGtNAMewYw7W0J/3w0ZCdCCRJtUqapMqAad70k5Qby
	fWu75Kp4TcOzVmOfecjx0jBmuDxk=
X-Google-Smtp-Source: AGHT+IFKVkHiHJQtxE/Zp717l+CK3ykwCTpBgNYxI7ZmIgKEdJuFM7gFsNb10nu0juCQHTAQIyJdWhAOrKZe9J/YXE8=
X-Received: by 2002:a05:6122:104a:b0:4d4:4703:e7a8 with SMTP id
 z10-20020a056122104a00b004d44703e7a8mr2932299vkn.15.1711347156089; Sun, 24
 Mar 2024 23:12:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ea9e38e6f49786ecb88f810a45c65238a2ec5641.camel@perches.com>
 <20240323041401.6335-1-21cnbao@gmail.com> <b92d6a4f17a17cc8586fea9fa72396c22d748d35.camel@perches.com>
 <CAGsJ_4x+je5Tg9a92WXonaGqULQY56-KcijnWdO720qaefuWzw@mail.gmail.com> <cbd117f445dfc92fd0bf2e0d200c32f628fe1c46.camel@perches.com>
In-Reply-To: <cbd117f445dfc92fd0bf2e0d200c32f628fe1c46.camel@perches.com>
From: Barry Song <21cnbao@gmail.com>
Date: Mon, 25 Mar 2024 19:12:24 +1300
Message-ID: <CAGsJ_4zb6qsXbij8eyyjNQroAaq-Bb0KzO0q66rFu-QgFgcr4w@mail.gmail.com>
Subject: Re: + scripts-checkpatch-check-unused-parameters-for-function-like-macro.patch
 added to mm-nonmm-unstable branch
To: Joe Perches <joe@perches.com>
Cc: mac.xxn@outlook.com, akpm@linux-foundation.org, apw@canonical.com, 
	broonie@kernel.org, chenhuacai@loongson.cn, chris@zankel.net, corbet@lwn.net, 
	dwaipayanray1@gmail.com, herbert@gondor.apana.org.au, jcmvbkbc@gmail.com, 
	linux@roeck-us.net, lukas.bulwahn@gmail.com, mm-commits@vger.kernel.org, 
	sfr@canb.auug.org.au, v-songbaohua@oppo.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Mar 24, 2024 at 11:59=E2=80=AFAM Joe Perches <joe@perches.com> wrot=
e:
>
> On Sun, 2024-03-24 at 11:40 +1300, Barry Song wrote:
> > On Sat, Mar 23, 2024 at 7:16=E2=80=AFPM Joe Perches <joe@perches.com> w=
rote:
> > >
> > > On Sat, 2024-03-23 at 17:14 +1300, Barry Song wrote:
> > > > > > The patch titled
> > > > > >      Subject: scripts: checkpatch: check unused parameters for =
function-like macro
> > > > > > has been added to the -mm mm-nonmm-unstable branch.  Its filena=
me is
> > > > > >      scripts-checkpatch-check-unused-parameters-for-function-li=
ke-macro.patch
> > > > >
> > > > > Conceptually I don't disagree but I wonder what the false
> > > > > positive rate is.
> > > >
> > > > Hi Joe,
> > > >
> > > > If your concern is whether this script might produce inaccurate rep=
orts, I'm confident that
> > > > the false positive rate is 0%. Xining, please correct me if I'm mis=
taken.
> > >
> > > I presume it's low but non-zero.
> > >
> > > I think the false positives are going to be
> > > in some cases where a type is used as a macro
> > > argument in #ifdef/#else blocks
> > >
> > > #ifdef CONFIG_<FOO>
> > >
> > > #define foo(bar, baz, ...)              \
> > > static inline func##bar(baz, ...)       \
> > > {                                       \
> > >         bar baz =3D ...                   \
> > >         ...                             \
> > > }
> > >
> > > #else
> > >
> > > #define foo(bar, baz, ...)
> > >
> > > #endif
> > >
> > > where it's not reasonably possible to use a
> > > static inline.
> >
> > I do find some exceptions such as include/uapi/linux/const.h
> >
> > #ifdef __ASSEMBLY__
> > #define _AC(X,Y)        X
> > #define _AT(T,X)        X
> > #else
> > #define __AC(X,Y)       (X##Y)
> > #define _AC(X,Y)        __AC(X,Y)
> > #define _AT(T,X)        ((T)(X))
> > #endif
> []
> > I'll check if Xining has some approach to detect this kind of ifdef/els=
e/endif,
> > and remove those false positives.
>
> checkpatch isn't expected to be perfect.
>
> So I wouldn't worry about it, I just wondered if
> the exception rate is near the warning rate.
>
> I expect it's not, but if it is, then perhaps
> the warning isn't useful.
>
> Do you know how many existing cases there are in
> the kernel that might trip this warning?

I can find numerous cases, lots of func-like macros don't evaluate
their arguments.
They potentially might lead to build warnings.

for example,

WARNING: Parameter 'val' is not used in function-like macro #332:
FILE: arch/arm64/include/asm/fpsimd.h:332:
+#define sve_cond_update_zcr_vq(val, reg) do { } while (0)

WARNING: Parameter 'reg' is not used in function-like macro #332:
FILE: arch/arm64/include/asm/fpsimd.h:332:
+#define sve_cond_update_zcr_vq(val, reg) do { } while (0)

WARNING: Parameter 'p' is not used in function-like macro #21: FILE:
arch/arm64/include/asm/kprobes.h:21:
+#define flush_insn_slot(p)             do { } while (0)

WARNING: Parameter 'vcpu' is not used in function-like macro #875:
FILE: arch/arm64/include/asm/kvm_host.h:875:
+#define vcpu_has_ptrauth(vcpu)         false

WARNING: Parameter 'ex' is not used in function-like macro #120: FILE:
arch/arm64/include/asm/elf.h:120:
+#define compat_elf_read_implies_exec(ex, stk)  (stk =3D=3D EXSTACK_DEFAULT=
)

WARNING: Parameter 'ex' is not used in function-like macro #161: FILE:
arch/arm64/include/asm/elf.h:161:
+#define SET_PERSONALITY(ex)                                            \
+({                                                                     \
+       clear_thread_flag(TIF_32BIT);                                   \
+       current->personality &=3D ~READ_IMPLIES_EXEC;                     \
+})

WARNING: Parameter 'start' is not used in function-like macro #121:
FILE: arch/xtensa/include/asm/cacheflush.h:121:
+#define flush_cache_vunmap(start,end)          flush_cache_all()


WARNING: Parameter 'end' is not used in function-like macro #121:
FILE: arch/xtensa/include/asm/cacheflush.h:121:
+#define flush_cache_vunmap(start,end)          flush_cache_all()


WARNING: Parameter 'mm' is not used in function-like macro #140: FILE:
arch/xtensa/include/asm/cacheflush.h:140:
+#define flush_cache_mm(mm)                             do { } while (0)


WARNING: Parameter 'mm' is not used in function-like macro #141: FILE:
arch/xtensa/include/asm/cacheflush.h:141:
+#define flush_cache_dup_mm(mm)                         do { } while (0)

...

And I do find some funny false positive:

WARNING: Parameter '...' is not used in function-like macro #1090:
FILE: arch/arm64/include/asm/kvm_host.h:1090:
+#define kvm_call_hyp(f, ...) f(__VA_ARGS__)

...

I think we at least need to fix this '...' case.

And since sometimes we are reporting false positives, do we consider
downgrading it to WARN from ERROR?

Thanks
Barry
