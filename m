Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE1043FC2
	for <mm-commits@vger.kernel.org>; Sat, 30 Nov 2024 04:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732941762; cv=none; b=N5cntvnhVAOoh8kMvb2SIQDSFylA0K0prD88Ui7qszS13qTo2hOrJHKyAigZnBLq9H+fvQBkUXoh0TwMHXg1yB/br8z0BIzXoEWvJGTS1a1NzRFC49Ha9fhKkAzHIh3xm2UM1uXG6q0/qlif0KD2NB1tNi3n8O3O+jTTMT88XfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732941762; c=relaxed/simple;
	bh=gP9hnH5X28fpAImsbtBRDKU2m8gBUDO0PgTp572WjQQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qUb8XHXI5AtIOit06jMcBP/KYuROUK+r4P2Bs4kFp4LwvfEjc7ZeHFl4H6ol5yTYLP/QPMIHzlYqTmzwt1Lgs4VEc67EdAiKfW5yiKPjcsavE7wpgvOmzwPl+MDB4dnHYvK/nP5JQ6b9cCshIsxZKVYoj9zbPeBMBeBOdnbEopA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WmYRVXzx; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WmYRVXzx"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-aa530a94c0eso363890766b.2
        for <mm-commits@vger.kernel.org>; Fri, 29 Nov 2024 20:42:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1732941758; x=1733546558; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=AjhXiMV5HEwZJnpNqxQsIy4GaUWDgBhsoCToCucoffM=;
        b=WmYRVXzxjCwIEl1x3I4aLcEesTgfVuBVQ68zn8GpNB/EkoIDwL50DN3IFHjG/F0Hsg
         8JChYNwdQRaWi20mh5qhr/LjTO+kwHZeIF6/77lmRGXdv3O4iXS7T9RdQQaDgLCAN+12
         HEU8iX9TVKPgv9fkH1CpB5wT2vZ/e1dZKVe5I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732941758; x=1733546558;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AjhXiMV5HEwZJnpNqxQsIy4GaUWDgBhsoCToCucoffM=;
        b=ta3/WtBksxlW0Wt67KW1ckVFoKOyAEWJ2DmZnv0MaGg8TAqovMrzi+Izf/9RENvWUp
         AIn90tQqxlqLmXIQJx6g85bWtNbtxiGGnA5zR6wdzf6xvx0QFyShY/8fiZkrOxN3nKmT
         k9EK6FAeUIX86w03YSd7Vefg5AWaMYK+JRwFDS3snGYEXj7g6sENGhg0q0hSiflXMNcb
         lsRxwusez+a2Hyctlaby7MB2kExkZWU63ECu1v7CzXeFG9GCkQ0pTFfn7MdlwSTkaVWm
         vcnfz9LC65aRI9ExwYGuG3NLbnifQy29M2UI5iTWD1fMisklGwYp8k0hNUcm7yas0H0n
         vw7g==
X-Gm-Message-State: AOJu0YzzIj3vKAX8LT99oHaLgiwJMa2NJWdyexvIHit4AZ5h5HmgaTsI
	aRWqUB1YhwKZekPhVh/J52FYkm0E1vAusWkpM0C1P0HTTsMkVsNaI1OV9iAoU/ZwD9hoCHYQ/SW
	ss/g46g==
X-Gm-Gg: ASbGncviJbD6aJ9JDp0pqb3OizgeuYGDlrXjIiDlcQNEbgsiBfF/k5IbrIE5nZyghvA
	hZX+tvUa21aELcOYDnGlgMb7XAIdN5+EJXFXM+OFLQ5NXYcTjHMMfPg7PppZMMDX0LuWYw6nHiW
	+htuenvnliCfv5URtO1MkVnECUb1+It/5D4SNN2JjphVcOkD17JlYenPYTWoDJSaltyhxCk9ItW
	g2GerX6xabagvA79dkw7cX+C3N6OQEmbtSNBHz5Z60eko+cbCi98k1bvRihGHb3B33HqIZAs79/
	We//8B/98Kh7rOOmKkJrJXY=
X-Google-Smtp-Source: AGHT+IEnIzADkXUDZWUT8bfhhTaKuhKs+Cpi9AJnWuLNws4zA1z0YdUJR8D0VCINIFGldIIBOXfhXw==
X-Received: by 2002:a17:906:328f:b0:aa5:4b7f:e705 with SMTP id a640c23a62f3a-aa580eee492mr1200272766b.1.1732941757990;
        Fri, 29 Nov 2024 20:42:37 -0800 (PST)
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com. [209.85.218.47])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa5997d56eesm238977466b.81.2024.11.29.20.42.35
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Nov 2024 20:42:36 -0800 (PST)
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-aa530a94c0eso363887166b.2
        for <mm-commits@vger.kernel.org>; Fri, 29 Nov 2024 20:42:35 -0800 (PST)
X-Received: by 2002:a17:907:3f9f:b0:a9e:c267:78c5 with SMTP id
 a640c23a62f3a-aa58108aa97mr1066698866b.55.1732941755362; Fri, 29 Nov 2024
 20:42:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241130042554.D1083C4CECC@smtp.kernel.org>
In-Reply-To: <20241130042554.D1083C4CECC@smtp.kernel.org>
From: Linus Torvalds <torvalds@linuxfoundation.org>
Date: Fri, 29 Nov 2024 20:42:19 -0800
X-Gmail-Original-Message-ID: <CAHk-=whA+B4LbrtBi5hVRe8KAKDaaGCZ+3DVOiKEBXdPx59bPQ@mail.gmail.com>
Message-ID: <CAHk-=whA+B4LbrtBi5hVRe8KAKDaaGCZ+3DVOiKEBXdPx59bPQ@mail.gmail.com>
Subject: Re: + support-lockref-reference-count-if-enable-lock_stat.patch added
 to mm-unstable branch
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, yongli-oc@zhaoxin.com
Content-Type: text/plain; charset="UTF-8"

On Fri, 29 Nov 2024 at 20:25, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> Swap the positions of lock and count to support CMPXCHG_LOCKREF if
> SPINLOCK_SIZE > 4 when enable LOCK_STAT.  The reference count can always
> be used regardless of the spinlock_t size.

NAK.

This is not sane:

> +               struct {
> +                       int count;
> +                       spinlock_t lock;
> +               } __packed;

That spinlock_t might not be usable in a 'packed' format. For all we
know, some architecture might have alignment restrictions for
spinlock_t, and who the hell knows where the actual lock is anyway.

In fact, I pretty much *guarantee* that is the case. That 'spinlock_t'
will have a 'struct lockdep_map' in it that has pointers etc, and some
architectures will not deal with unaligned accesses, and this will
simply NOT WORK.

So no, this needs to die.

I would suggest

 (a) either just admit that LOCKREF doesn't work with spinlock
statistics or debugging (which is the current situation)

 (b) lockref cases would be changed to not use 'spinlock_t' at all,
but simply use 'struct raw_spinlock'.

but this kind of "let's play games with unaligned lockdep maps etc" is
not something that I will ever accept.

Note that (b) would be a *big* change. Because lockref users often use
the spinlock part quite independently, and now all of those would need
to be changed to use raw locks.

Just as an example, see this:

  $ git grep 'spin_.*->d_lock' | wc -l
      340

and while the dentry cache is probably the main user of lockref, it's
not the only one. So those 340 dentry uses are probably the majority,
but I bet there's another hundred or so non-dentry lockref spinlock
users in erofs and gfs2.

Andrew - please make sure that patch gets removed from all your queues.

            Linus
