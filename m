Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3796F14D70E
	for <mm-commits@vger.kernel.org>; Mon, 11 Nov 2024 13:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731332625; cv=none; b=Qtb5jJh8wgQGy7cgKyw8N7knXBysQqb+xlV8U13ZNg2J1CEq2zkVZ7Vt8ygUmVVIPpdULc7GaKeqTfkCILXazERlXJrL6mChRDCohWN+z4H4gV3cntjsNWtRld6U5F1xBUz7p+VOjZHy0dHCcEpi9UVx7MccxoZvW1z2tWYCi8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731332625; c=relaxed/simple;
	bh=jYvLQr8HkhBTMi8Vwwvm/H234TJAgq+I/opC9vwgbeI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=m3tGPP/DXnCfU6xIB4xg5byDE/JBHiFhUAlq3G/J1aFNS8MuvQ9C/Jy8lNVEbgJbbrhn5IBkuYbCm3vCeNxJppFFAKoZKR4MVwpgM0APQanXA6As2BrREDf5YaxmWno8s/bm9ARKCWytmi9GyJmm5u8Hg4GGub3CoSJstWIXrDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OSQ/dXHc; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OSQ/dXHc"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-20c8ac50b79so256735ad.0
        for <mm-commits@vger.kernel.org>; Mon, 11 Nov 2024 05:43:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731332623; x=1731937423; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xDP+cDmyXee8Hd/DZmVZMRbGxd+UGKc4TIK2uER3Dco=;
        b=OSQ/dXHcmTiszrItgfstTXYtywBaD2kgFxd1NgLPM+xdrlmnWtw7fANGHzDffG4C1X
         BKxPye6HyxBC/hp9sKv5QwPi26YfTkldAgGh/SM+zBvMA6rBGgapbA30YEhBLJ70ZbI7
         zLFl8eY0EhIkAsygBB8mMbOs/mO3nSAEcmBsFfOUwPmX8JfjCM5bavqvih+saU1wW9Pj
         yBy0UtEDgenm9oYZNmhNDoJyEzwoQMJ/xB2kKJuOgqj+HLGcUjOnrf7QQocKyb9lJXGJ
         PAv+Chz3roB0NcAjkKb0b11xN5KRC/KXEvw/MpOoggIqhqh/sYzx1KR9JSDn/0rYXs2P
         C5Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731332623; x=1731937423;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xDP+cDmyXee8Hd/DZmVZMRbGxd+UGKc4TIK2uER3Dco=;
        b=NfSytglR22Je03IhxT0qTaf7kRCGEn7Krk+Yk+Dz/OtzXlMPEUjsxq/e4dG7YBoSPv
         Fwccs/j8F27IYp5tN5p2bZC3dsapvno15nJeccaxMYjv88FJ2wMDwv3u7m1nLgJHckPT
         FCUUJm0k0Jqh1kYd0DmB5lyig45sYbMPlgVEaHLXsZZ1xrPEcEsnfLOpyhC1KeM1/FnW
         /c+8CEWYmezQY1qH4GTDDm5/UoYRh8iVfpvmPUKM6he4TTmy1okSpefoFqetDEHlvBby
         ykEqbdUA94lV6u4SPiUq0ahNNkSGwfkP2urMnniA1tc7dcCoQIYRyvDn81Qb3+Cz5stY
         Wz+w==
X-Gm-Message-State: AOJu0Yzx4Wa/yNP5H8muNBdFnhGhHNG0ZWhpZf8bepOHzRBihTzUhUkc
	Dv7PIf9NafyOEZafTWiPMdSGlHEuucf8KayCLNn1lBftBAFnFWyDHheMO2OAt4zvFUPU7AXJUl7
	Gq2EzV/eGalPCRRt5P2R7uu1k1gxB8IHhXpcz
X-Gm-Gg: ASbGncutEKs5JfROjMKSP+YhGGYgpM1Y4/2LLDgZ3UJKIfyFj7KIzJQEl55zdt3JRMl
	AYcuo5ctBqf0zJ2iTIM1gTI3aI0OD8A==
X-Google-Smtp-Source: AGHT+IETPc+SVHj47N7mDi3y9b3P39arT7614Q9JWIkwIq84hMAFtIcLJ/cZOvbHbBU+mSpbxKQJa4AQPdsxtagSf6Q=
X-Received: by 2002:a17:903:2292:b0:20b:5e34:1850 with SMTP id
 d9443c01a7336-2118f1c8c0cmr3154185ad.23.1731332623385; Mon, 11 Nov 2024
 05:43:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241111082832.CB6B3C4CED0@smtp.kernel.org> <CADyq12zz+Di3FDANsZo1F79EvSSvUZt6fdRMDqG0tqbWoHq+rg@mail.gmail.com>
In-Reply-To: <CADyq12zz+Di3FDANsZo1F79EvSSvUZt6fdRMDqG0tqbWoHq+rg@mail.gmail.com>
From: Brian Geffon <bgeffon@google.com>
Date: Mon, 11 Nov 2024 08:43:07 -0500
Message-ID: <CADyq12wbX6Jn0aPgm4EpMtFcE1d=K7qAWan=g9L7RtQ674Escw@mail.gmail.com>
Subject: Re: [merged mm-stable] zram-clear-idle-flag-after-recompression.patch
 removed from -mm tree
To: Andrew Morton <akpm@linux-foundation.org>, "# v4 . 10+" <stable@vger.kernel.org>
Cc: mm-commits@vger.kernel.org, minchan@kernel.org, kawasin@google.com, 
	senozhatsky@chromium.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 11, 2024 at 8:42=E2=80=AFAM Brian Geffon <bgeffon@google.com> w=
rote:
>
> On Mon, Nov 11, 2024 at 3:28=E2=80=AFAM Andrew Morton <akpm@linux-foundat=
ion.org> wrote:
> >
> >
> > The quilt patch titled
> >      Subject: zram: clear IDLE flag after recompression
> > has been removed from the -mm tree.  Its filename was
> >      zram-clear-idle-flag-after-recompression.patch
> >
> > This patch was dropped because it was merged into the mm-stable branch
> > of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> >
> > ------------------------------------------------------
> > From: Sergey Senozhatsky <senozhatsky@chromium.org>
> > Subject: zram: clear IDLE flag after recompression
> > Date: Tue, 29 Oct 2024 00:36:14 +0900
> >
> > Patch series "zram: IDLE flag handling fixes", v2.
> >
> > zram can wrongly preserve ZRAM_IDLE flag on its entries which can resul=
t
> > in premature post-processing (writeback and recompression) of such
> > entries.
> >
> >
> > This patch (of 2)
> >
> > Recompression should clear ZRAM_IDLE flag on the entries it has accesse=
d,
> > because otherwise some entries, specifically those for which recompress=
ion
> > has failed, become immediate candidate entries for another post-process=
ing
> > (e.g.  writeback).
> >
> > Consider the following case:
> > - recompression marks entries IDLE every 4 hours and attempts
> >   to recompress them
> > - some entries are incompressible, so we keep them intact and
> >   hence preserve IDLE flag
> > - writeback marks entries IDLE every 8 hours and writebacks
> >   IDLE entries, however we have IDLE entries left from
> >   recompression, so writeback prematurely writebacks those
> >   entries.
> >
> > The bug was reported by Shin Kawamura.
> >
> > Link: https://lkml.kernel.org/r/20241028153629.1479791-1-senozhatsky@ch=
romium.org
> > Link: https://lkml.kernel.org/r/20241028153629.1479791-2-senozhatsky@ch=
romium.org
> > Fixes: 84b33bf78889 ("zram: introduce recompress sysfs knob")
> > Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
> > Reported-by: Shin Kawamura <kawasin@google.com>
> > Acked-by: Brian Geffon <bgeffon@google.com>
> > Cc: Minchan Kim <minchan@kernel.org>
Cc: stable@vger.kernel.org

> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > ---
> >
> >  drivers/block/zram/zram_drv.c |    7 +++++++
> >  1 file changed, 7 insertions(+)
> >
> > --- a/drivers/block/zram/zram_drv.c~zram-clear-idle-flag-after-recompre=
ssion
> > +++ a/drivers/block/zram/zram_drv.c
> > @@ -1864,6 +1864,13 @@ static int recompress_slot(struct zram *
> >         if (ret)
> >                 return ret;
> >
> > +       /*
> > +        * We touched this entry so mark it as non-IDLE. This makes sur=
e that
> > +        * we don't preserve IDLE flag and don't incorrectly pick this =
entry
> > +        * for different post-processing type (e.g. writeback).
> > +        */
> > +       zram_clear_flag(zram, index, ZRAM_IDLE);
> > +
> >         class_index_old =3D zs_lookup_class_index(zram->mem_pool, comp_=
len_old);
> >         /*
> >          * Iterate the secondary comp algorithms list (in order of prio=
rity)
> > _
> >
> > Patches currently in -mm which might be from senozhatsky@chromium.org a=
re
> >
> >
