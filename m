Received: from mail-yx1-f47.google.com (mail-yx1-f47.google.com [74.125.224.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 648AC3403EA
	for <mm-commits@vger.kernel.org>; Mon, 12 Oct 2026 22:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791844810; cv=pass; b=rtlIWPPJyQBafvIKgFiCK4FKvVK9FtK8pr1k17v7aBiIg85ua6drvogy0WeRXQX8WqxHdGzDEL0WSnGcVDgwzEQc47QBA5vmPpx6VW0IoCr07taPnSsb7IWEFXMNVio6y7McN4/VvQCwQs0O3ivQBOekH7JjdlxZ97sEMyX5ihQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791844810; c=relaxed/simple;
	bh=gpnO/9VzKDIKfgR5VIuV+GwmHTITAmrYb/Yl6OAA66Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=c8w8WpY8M2+R4q+JO86Aq/peZUE78PcC2DueMxHdZqyNWP480IVL+mj7tc6jEeENhCq+fjm4mC73MYWEtxahPaF5hnEzEtIPjoWfin6u4854e1jDkY1S+DcbsrkMNdjTDpQMt3Dbauo5K61H7cWrMBYd6imvuFL3+JrDHNBUg8A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Sz3h4cY4; arc=pass smtp.client-ip=74.125.224.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Sz3h4cY4"
Received: by mail-yx1-f47.google.com with SMTP id 956f58d0204a3-6793ff3d53dso1680538d50.2
        for <mm-commits@vger.kernel.org>; Mon, 12 Oct 2026 15:40:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791844808; cv=none;
        d=google.com; s=arc-20260327;
        b=BK0Skt1lXJOaN969TdUKZWtxWt6sQS2F6m9w6Zdap26t+7belZPhq++fUNMANh6A4T
         Lik+57r/yLXIqzmv+JG76NT3YE9ENmRY5pyrP1UVKWn+qYQLFIwJesqZlcOb47E2fU/E
         +9MLv90sqiSnI75hwul7Ruy5Yz1QUa7vsC1+Q/Zmm0DWRtev/ALQ2b+vFdyTnq+a5CZ0
         E+qrGDMIWmdBc3LhLpuNNCYz7VXv3iJaMT0CC0uGgyhyyKegz5ViNqKbzkFfJxkmDxhD
         IaK07NQA1CSmXNSg1fZITLrxF/SPzWDSbhS/y0e8OzypvIcW9fY0ZGnVUBjiS0nzkwzu
         khng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5JLXDGy6oAwMvUaEgVDf7U2+Ngy3SS45w6Lj1GjtxQY=;
        fh=f06oKNZiIIPdbaun5e3j5wG7cmZyyVaWdqVoBCI9768=;
        b=m2rxHeVW7uh3DbO7fkU7c53XJPiKFTSjHipPXzNgimMXrx4wU6wdr20KSx1Xt1q3Ok
         aWzr03DV+AdsVaU/2DJM+DWBDAsdLe3P0VI42Ar9GffL5+gVxPtj4ey/LnKSeN/vo1yI
         pBFssbRa2xnpHrrylEZ1tGdLaR9sW0tohILcbH2VnHEnxxNKDjGhs/mr0uLPGGaagkxI
         mNMiosikc7ZTwlmxbboSJ6Q5Zb4CZ3H6F4vYXFtW/1/YJWZF9RB88Hxuq4TTE8JqdPAo
         qq7FZaT4dQ3GL1oPD3S8UOrSQG4Ay7oPvxpNleS8o9sB0qCkCUWyTB+9pOQRpYhVdpPh
         C/zQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791844808; x=1792449608; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5JLXDGy6oAwMvUaEgVDf7U2+Ngy3SS45w6Lj1GjtxQY=;
        b=Sz3h4cY4bMmPdTQsISoDoiwOFvV/VOY2IWkDkYh+xUB6OhDWlR4AWDL9IzGuS5o70Z
         hKKGaE3btE+vWFLmjICx8ZVjPWlDGj9KsU2mya6+C4bRLV7jM1L9+kotJ2Ft0VIByF0F
         BzIol8gxXnhEWmIHxmssjTOS3aukC5zNSabth2IqHigSO4DjCAiEH1idiCkfw5eE+L+Z
         cr0fKnnlBZccGHH+VIyLoyv3G4SAiXGdwHXtP2d8Ev+NyETQCg+sN03eQSWz0L6D58gt
         EcmMNfbK4uuX1l/1mx0TQ0cK9d10WPx4gqoJJ71XQ1EOTJxzEnlzkhLqlAPPSItU8JtZ
         b1Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791844808; x=1792449608;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5JLXDGy6oAwMvUaEgVDf7U2+Ngy3SS45w6Lj1GjtxQY=;
        b=WXgx4rUhvwfUogYBE8/PDNIlQ5ohvHsixb+BLdTzrF3bDEgJkj4RdOvp5MakovZd1F
         Bp2Mjs4zwpcQpyiUBf7GFyjdAHlVqZy8nfbRh7Uat/18Tf+APWRdN6G3Ve4OFsihN2WA
         GjvKaQGFVApIoviG9im2rZnuV8vRyluWjCLsT3kBB6B+t45kYJizkErMAVMjBpM7JVp0
         h3bfD3lRpGIoWQweMfpKjMi97JoPysV67KDlKhHVjJgj4dZaNpPpTZp13zu9R32QFeKk
         pyklV/sk+yMXGlU2up4vDomR9Yegnci/aeLfkHdfTyPGaIxSUhJYjJqCKiFbpbIAIGHH
         k0GA==
X-Forwarded-Encrypted: i=1; AKwUvBykPXVf5ef32ENKcsXHc34gXP2edH3xDNUzJ6mrueduq6vkqVyCwtRx2I5x9Aj9yyhy0Y48V7Ug3gCO@vger.kernel.org
X-Gm-Message-State: AFq9FYJAPf4sW2U3Q69VxwuYMD3naekl72buf9zyH8uNJMb++qO7bq0L
	zT1if6C10KCvodQgvLm2F9Wgtj9avskYEV4r7C2wVzi4cUXYDC9OoAR7jCy/UifAmZU3+a135t1
	IkA4MRkP58fqqV/f2Ut1JVDTDB2dOckY=
X-Gm-Gg: AYBFou3vNdCYd0Alc/giP1ADVZEE2HPP+hLvMAJ9w/Xe5sJS39oBoRcxXgrKDWE4P1w
	o8fpCsWOS5IgM7AE0wkarogOPiT0JEWyBEDcr+aqq9KtyRJp13ETxsFh207/C+bAzxZuWJm0qAy
	mUE0RlMqSVf7vHOs4JPDy5id/AKoOyJZtlcCpYpoCebdN0tSSNgJHfFIvL412cD3c+yUdU+1wz4
	hszOO2bFQ8u3WY0keFWBhHD7btRoIMSKFChHi8qYjs1ISTZTTbtY0Jxqdlxd5PuW45Fu0eh/hXD
	Io6xrwhujcHX0FNEyhv89y7Wqgm15Dr6b8zaXTiLHG2yiUBNhU2CjrBXXFjGbogchANxySPtUhY
	qpQA3f0xMzTTA3mOwBWbn9OQdbHf3PBNqeGbPnENfoss4
X-Received: by 2002:a05:690e:1209:b0:679:42be:51a7 with SMTP id
 956f58d0204a3-67942be52e2mr2695857d50.18.1791844807903; Mon, 12 Oct 2026
 15:40:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261011002340.E44771F000FF@smtp.kernel.org> <20261011154401.479c51b6@pumpkin>
 <20261011081552.e6f08178e6fc8b865e2715d3@linux-foundation.org> <20261012111424.4b88e041@pumpkin>
In-Reply-To: <20261012111424.4b88e041@pumpkin>
From: jim.cromie@gmail.com
Date: Mon, 12 Oct 2026 16:39:41 -0600
X-Gm-Features: AclHuK8MPO4RoFfaOp0GgGbT5tcubiWaXzoHOnFi5i_YRA1eE4_fcgwf01QL60A
Message-ID: <CAJfuBxz9ezoEA26FK5pGrYnzoBo_EyjKJQDiXhfHr3=aUM8A+A@mail.gmail.com>
Subject: Re: + kallsyms-increase-marker-density-to-16-1-to-accelerate-lookups-fix.patch
 added to mm-nonmm-unstable branch
To: David Laight <david.laight.linux@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org, 
	thunder.leizhen@huawei.com, thomas.weissschuh@linutronix.de, 
	rostedt@goodmis.org, pmladek@suse.com, olsajiri@gmail.com, nsc@kernel.org, 
	nathan@kernel.org, mcgrof@kernel.org, masahiroy@kernel.org, ljs@kernel.org, 
	kees@kernel.org, geert@linux-m68k.org, denis.benato@linux.dev, 
	chewi@gentoo.org, andrey.grodzovsky@crowdstrike.com, abelvesa@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

hi David

On Mon, Oct 12, 2026 at 4:14=E2=80=AFAM David Laight
<david.laight.linux@gmail.com> wrote:
>
> On Sun, 11 Oct 2026 08:15:52 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
>
> > On Sun, 11 Oct 2026 15:44:01 +0100 David Laight <david.laight.linux@gma=
il.com> wrote:
> >
> > > On Sat, 10 Oct 2026 17:23:40 -0700
> > > Andrew Morton <akpm@linux-foundation.org> wrote:
> > >
> > > > The patch titled
> > > >      Subject: kallsyms: copy constants from __KERNEL__ to user, dro=
p the inclusion
> > > > has been added to the -mm mm-nonmm-unstable branch.  Its filename i=
s
> > > >      kallsyms-increase-marker-density-to-16-1-to-accelerate-lookups=
-fix.patch
> > >
> > > There is a problem with the way this change in implemented.
> > > Basically the kernel Makefile (etc) only builds scripts/kallsyms if i=
t doesn't exist.
> > > This means that if the header file is changed you can easily end up w=
ith a kernel
> > > that expects a different marker density from that in the data file.
> > > That will lead to all sorts of strange/confusing issues.
> > >


Is this problem fixed by making these all depend upon a CONFIG_  item ?

Nathan Chancellor suggested this earlier,
I demurred cuz it seemed like an unnecessary knob,
but solving a build problem is a higher purpose.

of course your v2 might make this moot, I'll try it when it lands here.


> > > It would be better to put the 'shift' value into the .S file.
> > > It isn't used anywhere where that will make a performance difference.
> >
> > OK, thanks.  I'll remove the v7 series from the 7.3-rcX queue - let's
> > revisit for the next -rc cycle.
> >
>
> The patch that changes the name comparison can go in.
> That saves 512 bytes of stack but doesn't make (much) difference to
> lookups because other things dominate (probably unless you have some
> very long symbols from rust code).
>
> I am working on an additional change.
> (I posted a v1, v2 adds some extra changes and is taking a while.)
> Performance wise it improves name lookup by a factor of ~18 while
> only increasing the 'density' to 64:1 (1 bit per two pixels).
>
> I've make the density a kernel config option (default 6 =3D> 64:1).
>
> One of the reasons it is taking 'ages' is because I discovered that four
> of the 'token' values aren't actually used in any symbol names (in the
> dataset I'm using) - so they can be reused reducing the main table by
> ~8k (in 1.7M).
>
> David
