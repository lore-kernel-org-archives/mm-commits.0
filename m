Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A115D39CCEB
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 08:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791881505; cv=none; b=tqU9nYbZdtgdzT5oouLKo/t2ZEZwSx2hcfNBj+WmrdATR81GAGrSUg0YyVsw8a/tAAZADLcpSc4oEYF7imLOdcDZqPkPX0zZZik70FPc9ICo1TUiZDWzNSSVwEacSLrWqfwjflHV4RiOetX24uzvt9FpiObmlk9WzZFv/yEmow0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791881505; c=relaxed/simple;
	bh=GBm41JPkoJ4yv04tj7e77mohh+RpoWh86s+c5nS+wC8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uZWnnds4g+mrLJFan57F0F9pxwyy/GqArZUfDiNqb/UJin0x32UlU71xX7P9LtB8Q9mvjF8byMX4RYZXhdQaaZ2YtYYrLSNt90rubn5OhwV0sO6C6LnnMeINhK3xEbVI7TmdEl1t/5ueVRyPQBsTs2J06P6iufBom+lBJotGH4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bb8Trhm3; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bb8Trhm3"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4a0213948d3so16409495e9.2
        for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 01:51:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791881502; x=1792486302; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=GvYtBHJTu1Y2LgpwU0LKcogameFqe+1wZyvxYlwHfRw=;
        b=bb8Trhm3MPJdrTq1AAT1z9ZFfe9KrmfgnTJKntf3/Yp8iN7RioscnWr9QY55Ch6L4E
         oLpfHIGBsNSp8nQaoOIHxVGftCyuXEgcjVfrJnu/AzIRaosh2qcvLQrqfTT2fqJtBUC5
         r4d5J+3Vkd1bJi97RR5y/demiW6LTXcp/wYCH0H9XFkmNRIliavwYURtZmcyQruFxKiS
         3kUKk7+zL9PapAEJbnvqYaknuX898G+2XEzEFsGR0E/1YACSig7/kbqcjQpqaTny2M9b
         xAVLHbvZZbfvHwbN/t2nVC40LDdfQX0EOP99jBe051Yt57qAqKJDNhXPGnUqxDRLvv1L
         eNXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791881502; x=1792486302;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GvYtBHJTu1Y2LgpwU0LKcogameFqe+1wZyvxYlwHfRw=;
        b=a3KcKm9M9HGXAuhyC2PNLYUntmzne9OsE21+NR08pFSsPsALt/padCHGP6O9yPwvXu
         ViJRKb5SDGBk0poBks9QOp6fbbGom+z2dp/8VWuEJvukG5XFetvQa7jnWlpSIm1fliOk
         s/xGsXJJGswGkUg+qOoF1U9iT60EtkELfQKqAReTp9TNd6yQF20BMjGk9ambW72dHc8u
         UduXxOzlk+8Fy4b8FYo8UWgTYQ4JsUEUhHg+3Z9LzP6K/522jt5XH10nX7aTbpiSqXKI
         Hhess1lqkvpF/g9d9Fuo/l7MXDS/JN1Knx08LLLJYQjOmr1YwAj5akXHt/p075ggnapH
         4gAQ==
X-Forwarded-Encrypted: i=1; AKwUvByq7YuwhB40gpQP4xHVKmrj3P3fYj1P9P60ULKiFOAtgWUjkdLNUGmhwFfFCnPp+ZFEJDR5C3UiWNg7@vger.kernel.org
X-Gm-Message-State: AFq9FYIi/JIAHhaJ2tmR3+YSe1+XMsgEguvBXvq0PnFnmlLlMo2gtsAC
	8rixTcd63QqC2ohVPuQosn8TH98syGGZGyzZCMHZpeu/4Ngd0tQoEnDJ
X-Gm-Gg: AYBFou0gd/B6dDatJnX3Ij+CHep55NGrare4j7K1av6LFVsIsIqglg/wLzCPI+7NhCE
	AYMHK49fnQTfYpxnqwg3NdMqrJ4gQAxe2D3/Kt9s0i7lUntBVjBSUFIQI4ZzA0f/PwBbYUVc6EM
	yYFigdONLlH5ryzIm1ad+31y094+pfG66MNU1bWj7jYyiR+bg6kHJMD+wjPdI4xxbMqwlPjgwEl
	bzqndSmy043/0DYefaBUpBOZak9upEefBZw8hzdnjsXWr7BopsTpXVODw7/P1ggfqO3UIjfggif
	2DOjAUj6Se7dX25xbB4BXe0GURRa+djruCRzXWDMhR4K+rkBYnaevM5Dx2LPdc2fqTYhWNW2O+T
	H/SfFhtDrL9llC711hzkQplLw0IET0ctSSIAxCZEA91oxGqYtnnljEAQDFmJ2f61YGSD+ZheKBE
	KwCoNz7jwTt/sijl5HelOKCaASXbfioSbe1pqmN/Fw7aIXzKBP9/sP6ey2zm7uoWRdd1uxccCM+
	gleiqI7vsvlowhlr/3yMYt9XJhrGZ3On8Q=
X-Received: by 2002:a05:600c:3f06:b0:49f:ce78:356f with SMTP id 5b1f17b1804b1-4a18e4ca2acmr230932795e9.32.1791881501441;
        Tue, 13 Oct 2026 01:51:41 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a18be8c5e7sm438281625e9.4.2026.10.13.01.51.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 01:51:41 -0700 (PDT)
Date: Tue, 13 Oct 2026 09:51:38 +0100
From: David Laight <david.laight.linux@gmail.com>
To: jim.cromie@gmail.com
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
 thunder.leizhen@huawei.com, thomas.weissschuh@linutronix.de,
 rostedt@goodmis.org, pmladek@suse.com, olsajiri@gmail.com, nsc@kernel.org,
 nathan@kernel.org, mcgrof@kernel.org, masahiroy@kernel.org, ljs@kernel.org,
 kees@kernel.org, geert@linux-m68k.org, denis.benato@linux.dev,
 chewi@gentoo.org, andrey.grodzovsky@crowdstrike.com, abelvesa@kernel.org
Subject: Re: +
 kallsyms-increase-marker-density-to-16-1-to-accelerate-lookups-fix.patch
 added to mm-nonmm-unstable branch
Message-ID: <20261013095138.42291cb2@pumpkin>
In-Reply-To: <CAJfuBxz9ezoEA26FK5pGrYnzoBo_EyjKJQDiXhfHr3=aUM8A+A@mail.gmail.com>
References: <20261011002340.E44771F000FF@smtp.kernel.org>
	<20261011154401.479c51b6@pumpkin>
	<20261011081552.e6f08178e6fc8b865e2715d3@linux-foundation.org>
	<20261012111424.4b88e041@pumpkin>
	<CAJfuBxz9ezoEA26FK5pGrYnzoBo_EyjKJQDiXhfHr3=aUM8A+A@mail.gmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 12 Oct 2026 16:39:41 -0600
jim.cromie@gmail.com wrote:

> hi David
>=20
> On Mon, Oct 12, 2026 at 4:14=E2=80=AFAM David Laight
> <david.laight.linux@gmail.com> wrote:
> >
> > On Sun, 11 Oct 2026 08:15:52 -0700
> > Andrew Morton <akpm@linux-foundation.org> wrote:
> > =20
> > > On Sun, 11 Oct 2026 15:44:01 +0100 David Laight <david.laight.linux@g=
mail.com> wrote:
> > > =20
> > > > On Sat, 10 Oct 2026 17:23:40 -0700
> > > > Andrew Morton <akpm@linux-foundation.org> wrote:
> > > > =20
> > > > > The patch titled
> > > > >      Subject: kallsyms: copy constants from __KERNEL__ to user, d=
rop the inclusion
> > > > > has been added to the -mm mm-nonmm-unstable branch.  Its filename=
 is
> > > > >      kallsyms-increase-marker-density-to-16-1-to-accelerate-looku=
ps-fix.patch =20
> > > >
> > > > There is a problem with the way this change in implemented.
> > > > Basically the kernel Makefile (etc) only builds scripts/kallsyms if=
 it doesn't exist.
> > > > This means that if the header file is changed you can easily end up=
 with a kernel
> > > > that expects a different marker density from that in the data file.
> > > > That will lead to all sorts of strange/confusing issues.
> > > > =20
>=20
>=20
> Is this problem fixed by making these all depend upon a CONFIG_  item ?
>=20
> Nathan Chancellor suggested this earlier,
> I demurred cuz it seemed like an unnecessary knob,
> but solving a build problem is a higher purpose.
>=20
> of course your v2 might make this moot, I'll try it when it lands here.

That is what I end up doing, it has to get passed to scripts/kallsyms
as a command line parameter and then written to the output file.
That way nothing can go wrong (honest).

My v2 should be along soon.
I'm busy going through my changes and reordering them into a reasonable
set of patches.
It's raining, progress might be made.

Oh, try looking up _sub_D_65535_0 in an allyesconfig kernel; it is repeated
some 24610 times. I'm not trying that one with the old code.
Even a normal kernel has __func__.0 repeated hundreds of times.

David

>=20
>=20
> > > > It would be better to put the 'shift' value into the .S file.
> > > > It isn't used anywhere where that will make a performance differenc=
e. =20
> > >
> > > OK, thanks.  I'll remove the v7 series from the 7.3-rcX queue - let's
> > > revisit for the next -rc cycle.
> > > =20
> >
> > The patch that changes the name comparison can go in.
> > That saves 512 bytes of stack but doesn't make (much) difference to
> > lookups because other things dominate (probably unless you have some
> > very long symbols from rust code).
> >
> > I am working on an additional change.
> > (I posted a v1, v2 adds some extra changes and is taking a while.)
> > Performance wise it improves name lookup by a factor of ~18 while
> > only increasing the 'density' to 64:1 (1 bit per two pixels).
> >
> > I've make the density a kernel config option (default 6 =3D> 64:1).
> >
> > One of the reasons it is taking 'ages' is because I discovered that four
> > of the 'token' values aren't actually used in any symbol names (in the
> > dataset I'm using) - so they can be reused reducing the main table by
> > ~8k (in 1.7M).
> >
> > David =20

