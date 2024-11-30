Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E6141DFF7
	for <mm-commits@vger.kernel.org>; Sat, 30 Nov 2024 17:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732987410; cv=none; b=rhu2gDivXhIhKtpLB3VKSmISOuOq5U3ja0wz8sM0f3v6rbIqB/z8emhgJqrqO4cbMlT8OVZLNlmVFUO1sl2BgM/QpecAdQJNRGfJlFPcVKsdspDdH/qL7FF6d6gmTZXxFo+4iF6ON4J2POp5RRnP+ZdiNdnWE/C3hzNaaf2teuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732987410; c=relaxed/simple;
	bh=Tkg0QX3XL9XLStL5bgizORW1AgIqXkjnn1luaOlSI0Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=F5lIpYo/41PbGeENK8w2wGu3iEalu7MdRJnyYTQyl8zv31td7gxWl4VCi+Jz8PhlWq+qAJBIpnvUYtLxsOf0/OkKNHyl5ESASyNgENelQA9jr4YNQAM59QTmpvREMEvs93K0M58RIW835x+dfQqR+rEVdVyfSPvr/Eb5yocbw1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wa3bmovX; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wa3bmovX"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-aa5366d3b47so439813866b.0
        for <mm-commits@vger.kernel.org>; Sat, 30 Nov 2024 09:23:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1732987404; x=1733592204; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Y2wAfdeAYk+TjTkUDJfc0/KG1lfEDnVRt1eYPKWECqc=;
        b=Wa3bmovXQ1VnCCsYyOQmkoOyiuFa9FltaqCvjBL7m8p8NcYuutNgEvUafXoAFnscxN
         XIj5p5B1G6qXC7BZ4iT6oXahvUXTOnNAhLtwcCORDU+4ipQ1cDY5FcRamWH4Cf8Owy1/
         P4LAX0pFHUx7uUbwsJ+OLIY4CVRBBlIqvaqpE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732987404; x=1733592204;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Y2wAfdeAYk+TjTkUDJfc0/KG1lfEDnVRt1eYPKWECqc=;
        b=sn6Eq+LIp1oBdHmeA/wedyKvmUCkgjHsQO4PuZhKrRa+obloFrMZN8saM8So3QXfw2
         TMMClUyQ/vGRI/uBmjIYFp9Rh0FZ5Vo0fvTe+17KrZT+b2kt1CK1xbg3qpFkMG8IzzcK
         bgYZGRIdREogOp4jOkE5SZfs58wflY9V6ovQ01famUfhX0IuG+a/lZYVWqb9WMKrbiqy
         Gki4rKMWYRlN8LBV9GXSHy9vLobmHyyMpHEB7ySFFKHnZK4BsovnezozEQgIUzFVbiXU
         3qg54Le4nl8mZGva2XhagCnknnkVTHISQiSedKDhIBUrYw1ao/OIwmnU0sjdsiKyDwU4
         NSyQ==
X-Gm-Message-State: AOJu0YxM/ffua3z2335+AknD9miuSzjthog6NLUVnqqm6f2e6CutaCHG
	c9nqa+tYjlUADRrmKS6JX8qxG8l85JhQEd5TCu5liDTypVzQitA5kBXIoBiydgvJUeYNup4Dbz5
	asp8FaA==
X-Gm-Gg: ASbGncslqWVWX2nPz+qfAdRCp4OS8E1GBcMWCOUeAP/OZM3oFh89JEWM/GM/be0c3aA
	zX2uCtOdtC2Hz2Hb72TSKS7349Pp7iv4bYrH+qn83Ts2cCpXYzp9Y2EQKypCFo7KOX3PVUpmrKP
	2SIwbGDTePyG7FBqUR7DSvNGIsNYb8eaQmlgSbq89yEwNyQ7qe+ldheIZuT755xTcMncjb//q0Q
	S4cNl+oj8TtcInS+WvxdA0h3a6SGh8ypztemidDX68EoqD+weLnVOXVuGI4DUJB9b57GK/ZTNGT
	XIkUH+E+5bFKgo2wI91ls3Q=
X-Google-Smtp-Source: AGHT+IFLlJL/GVHNvGC1DDwNP5fUvvQn+IEiGP/oTwWEwdiHNaYRUO0wHmssy8WzibkHR8ox3p4iXw==
X-Received: by 2002:a17:907:77d4:b0:a99:fba0:e135 with SMTP id a640c23a62f3a-aa58103c790mr1308508866b.46.1732987404454;
        Sat, 30 Nov 2024 09:23:24 -0800 (PST)
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com. [209.85.218.43])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa5997ffc67sm298200266b.89.2024.11.30.09.23.23
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 Nov 2024 09:23:23 -0800 (PST)
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-aa5366d3b47so439810166b.0
        for <mm-commits@vger.kernel.org>; Sat, 30 Nov 2024 09:23:23 -0800 (PST)
X-Received: by 2002:a17:907:77d4:b0:a99:fba0:e135 with SMTP id
 a640c23a62f3a-aa58103c790mr1308504066b.46.1732987403463; Sat, 30 Nov 2024
 09:23:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241130042554.D1083C4CECC@smtp.kernel.org> <CAHk-=whA+B4LbrtBi5hVRe8KAKDaaGCZ+3DVOiKEBXdPx59bPQ@mail.gmail.com>
In-Reply-To: <CAHk-=whA+B4LbrtBi5hVRe8KAKDaaGCZ+3DVOiKEBXdPx59bPQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linuxfoundation.org>
Date: Sat, 30 Nov 2024 09:23:07 -0800
X-Gmail-Original-Message-ID: <CAHk-=wh9qosmBodJb4GcGBXC-A+6ng_LOR0KxTA6OU9Zd+DuvA@mail.gmail.com>
Message-ID: <CAHk-=wh9qosmBodJb4GcGBXC-A+6ng_LOR0KxTA6OU9Zd+DuvA@mail.gmail.com>
Subject: Re: + support-lockref-reference-count-if-enable-lock_stat.patch added
 to mm-unstable branch
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, yongli-oc@zhaoxin.com
Content-Type: text/plain; charset="UTF-8"

On Fri, 29 Nov 2024 at 20:42, Linus Torvalds
<torvalds@linuxfoundation.org> wrote:
>
> I would suggest
>
>  (a) either just admit that LOCKREF doesn't work with spinlock
> statistics or debugging (which is the current situation)
>
>  (b) lockref cases would be changed to not use 'spinlock_t' at all,
> but simply use 'struct raw_spinlock'.

Actually, even 'raw_spinlock' wouldn't work, we'd have to go one level
lower and use 'arch_spinlock_t'.

Both CONFIG_DEBUG_SPINLOCK and CONFIG_DEBUG_LOCK_ALLOC end up messing
with raw_spinlock_t, and it's really only the very lowest
arch-specific level that is then typically the 4-byte case that we can
use atomically together with

There is possibly a third (c) alternative, though.

Right now the lockref code embeds the spinlock_t into the lockref_t.
That works fine for the "spinlock is 4 bytes in size".

But we *could* possibly turn that on its head, and say that when lock
debugging is enabled, we embed the lockref count into the
raw_spinlock_t instead (along with all the other crud we embed in
there), and then "lockref_t" simply *becomes* the spinlock (and uses
the "lock_count" that is in raw_spinlock_t).

That would be less invasive than limiting the lockref_t spinlock to
just the raw architecture spinlock, because the non-lockref spinlock
users would continue to work fine.

Not pretty, but I think it might be workable.

                      Linus
