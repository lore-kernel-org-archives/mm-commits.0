Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A10033D890F
	for <mm-commits@vger.kernel.org>; Thu, 15 Oct 2026 18:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792089803; cv=none; b=nKk6IlywqfCdP/GAYP938lQz5AOxwg4xK05V/PK+vt6KRyb+S26eRCAo7/WJrKhEeAZdzQpHf1DKhOzTOrA8DfVaIGU7R1vV2trNfiOW7PWoF+/gLBXNVVB2FrQQTRK4dxICusgBgElRXVYfrlGiaRte1f6nfC5jWHefWR81FFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792089803; c=relaxed/simple;
	bh=/7EgcX3zaTYfr/ZaQG+R7lx2u8NlmOHelMWPsxsol7o=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U8Qhhd+MLqc7PhrYdYqXabNi0mJ3uY6heBuRwKpXq0aAL0I4eNrsrq57dF9q/kUfPjBXQANv0hDNb5eMhjiWUZkYaCYm6HyiHuLpeLfyKA5mojeum0yesZcj4ciTVxqbZJQxMo/OgPmj/XMtNC3FHsHVuAUJw5SZmJJtXu19CXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hGfidpAx; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hGfidpAx"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-48bbb06e746so1144894f8f.3
        for <mm-commits@vger.kernel.org>; Thu, 15 Oct 2026 11:43:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792089798; x=1792694598; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FWIaifelUN6/dl97uYEKu7PfYC3t8maFY6KWuYs3hHQ=;
        b=hGfidpAxEtQENDZi/aeYOc6o40TZwdX4VRkynHmfh3JsxdAmPotxkW1hCqavYTGW98
         05mapndtDtqqdxGlqKekfuqe0EAmWc38QRRKY+kPr67bK1UQbt+zHsEsshYW+VJfMut/
         rurLsk+lYFrGgYkZGtEpsEuKC/9j23Qqmv72wlny6AZO4MeBNYNkA7rcmIwVYX8PinHc
         QrurFSjMqrgonDgJ8OE/XKFHpTPgO6VShp10cl2H/i7gvcZxyaEoDoz1hI8fyrvi+91i
         Uw+arVb2Wkw21viaOtuDJQoeZ/AuwQFqKt5+rW/PMfQAWuWa4z0zTbnlSh3MG1YRVcJP
         s+hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792089798; x=1792694598;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FWIaifelUN6/dl97uYEKu7PfYC3t8maFY6KWuYs3hHQ=;
        b=FpZzetyfh6lVwnJCvbKIfIq5w/vPt8Xcj7HAjL8NMSdQJa+EZzd22pZl+pCjHd+dQG
         73wE+2zSEvBnHXwOJ2a2K3gNeMCTDFxGxmYzDlMJeqIkr5TV/eWAkZqxDPwAz5usSBqa
         jLwwyVXgwzkjPC3bqtwAFF4v2/1+2XjUCIXnNZrebS/vhknwY/biqp8MPk1yOyE5r8gZ
         3n8hkkWxd9N2kPLcPuFAPzyYAwtJWv8t5LGKPXdMExX14f7nHz+BehKjI4Ej7caUgL14
         FMoHoVj9Srw2ux+B9NPlsbryM6/ly5t5MnJkwNxXux0k3I7SJlWGrgkQlV6hi29BpiYX
         kM0A==
X-Forwarded-Encrypted: i=1; AKwUvBzJGdrLYHVCWSV2iISpn2CSO/6W09cZlnlwOluQ4HN9bXfMxUHj0he+lW1W0l3syr8MCcr0BtfQvjmI@vger.kernel.org
X-Gm-Message-State: AFq9FYL8zR/599L4iyTtfuOlMatrRunkOTeTGWCyEFoj42g8XbzucCwC
	er+9qsfZpkddO/S+ulSpz0oP7kUv84SCO4WR4g7kpZE5yLjuYDpu08BE
X-Gm-Gg: AYBFou0w8o2anZFjebI+BLYzWO+0Np+uo+79u386aa9YthrlN7HTJ/6PaadeBl8aMOO
	zGDnF19IQo48J8X0e9iPbp5L6OWPO2t6QEZ7CldCm0lpDrfteIMEpu3VN/05SdP8yyFXgxL4DS3
	qGCqQx41uSuaI7dHIPY/9xahHjaoFsC80RBRmuScl0eCsIVjRTNXQmuZ01DcOJ0MFZSZ28RROGY
	pOd5tQECkTiVAVm2sNz5kmBTw6FhUFSvNxlIG1To7ZFMkOmeJSplte8FBH42WXLmS38n1LOv3pY
	6JKrcSV4+QgbEJhI2xSDNzBirammt4pl2xFQkOdaj9DdTt635mxdw202fobBx4bSTlOvPN82gRr
	9WhCMdBxl75nJP2DR8wHM9GEIQ/bRzscJZ8JW4aJABvmh7r3vbv0adGQmZN/c2J9f6QZtI/q5/j
	gBkX6L1MulCkzchLq2lQkhLuz+5C3x0tW/r2lKhfIJcuv71HZHFerZ41+JL1kRFUwCpwgVi9ARE
	uAprJO+D01yDqTbI344btNZWla+8u0gOpE=
X-Received: by 2002:a05:6000:41cd:b0:48d:f14a:917e with SMTP id ffacd0b85a97d-48df14a9316mr9600867f8f.11.1792089798346;
        Thu, 15 Oct 2026 11:43:18 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48de0ab4f34sm21375242f8f.28.2026.10.15.11.43.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 11:43:17 -0700 (PDT)
Date: Thu, 15 Oct 2026 19:43:15 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Nicolas Schier <n.schier@fritz.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
 thunder.leizhen@huawei.com, thomas.weissschuh@linutronix.de,
 rostedt@goodmis.org, pmladek@suse.com, olsajiri@gmail.com,
 nathan@kernel.org, mcgrof@kernel.org, masahiroy@kernel.org, ljs@kernel.org,
 kees@kernel.org, geert@linux-m68k.org, denis.benato@linux.dev,
 chewi@gentoo.org, andrey.grodzovsky@crowdstrike.com, abelvesa@kernel.org,
 jim.cromie@gmail.com
Subject: Re: +
 kallsyms-increase-marker-density-to-16-1-to-accelerate-lookups-fix.patch
 added to mm-nonmm-unstable branch
Message-ID: <20261015194315.518f75d7@pumpkin>
In-Reply-To: <20261015-curious-spiritual-buzzard-cd9aa8@l-nschier-aarch64>
References: <20261011002340.E44771F000FF@smtp.kernel.org>
	<20261011154401.479c51b6@pumpkin>
	<20261015-curious-spiritual-buzzard-cd9aa8@l-nschier-aarch64>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 15 Oct 2026 14:11:28 +0200
Nicolas Schier <n.schier@fritz.com> wrote:

> On Sun, Oct 11, 2026 at 03:44:01PM +0100, David Laight wrote:
> > On Sat, 10 Oct 2026 17:23:40 -0700
> > Andrew Morton <akpm@linux-foundation.org> wrote:
> >   
> > > The patch titled
> > >      Subject: kallsyms: copy constants from __KERNEL__ to user, drop the inclusion
> > > has been added to the -mm mm-nonmm-unstable branch.  Its filename is
> > >      kallsyms-increase-marker-density-to-16-1-to-accelerate-lookups-fix.patch  
> > 
> > There is a problem with the way this change in implemented.
> > Basically the kernel Makefile (etc) only builds scripts/kallsyms if it doesn't exist.  
> 
> Why do you think so?  Kbuild generates 
> $(objtree)/scripts/.kallsyms.o.cmd that should list all included header 
> files and other sources.  If any of them is touched, a rebuild will 
> happen next time the kernel build wants kallsyms binary.  It seems to 
> work exactly that way on my machine.  Or have I overlooked something 
> here?
> 

I've been doing a lot of test build through the kernel makefile.
They definitely weren't doing the correct rebuilds unless I deleted
both vmlinux.o and scripts/kallsyms, I didn't look why.

I wasn't booting the kernel, I just wanted the .S file to link with
a user program that included (most of) kernel/kallsyms.c and
kernel/kallsyms_seltests.c
(I've changed testing to do it differently most of the time.)

I'm nearly ready to submit some patches that speed the 'by name' lookup
by a factor of 12 with 256:1 markers and by 18 with 64:1.
They also reduce the compressed symbol table by about 10k for my 'normal'
kernel.
I've also run the selftests on the .S file from an x86-64 allyesconfig
kernel - don't try that with the current code regardless of the marker
density.

David
