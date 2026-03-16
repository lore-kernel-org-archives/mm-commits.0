Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FEED33ADA2
	for <mm-commits@vger.kernel.org>; Mon, 16 Mar 2026 10:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773658067; cv=pass; b=pMLL7u436Ww/5Tt2YjxpHrz3MJKqZkPm4pLuDC+7VDz7psJJT1ooxwwMFLvjUVQLOczBcVquv6xSVHPbdBvk9sDmg/GUxn07vkyhJSd8zeBMLZWlxrGAoKfAAcuZuBGgfyGkkSgu5thk8LYHh5v5ntQFf0WchIXYODxH7pyDQJU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773658067; c=relaxed/simple;
	bh=nTosVJ9mhWmC63TXexRUX3Wkpx1bcmrmNS7E+UkgIns=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=N/qpJa4f3c8hskN4BOI5a9NpwdoB48+7Yda+cH/Fs04HlIUrJMosuxf1M6vgoGZ1IssMoZq5OaTjZp3cABs8X3P8LusSt5YsTCJSLeG9inUGC9Ox1II5FDOdaKztFnBgMSsQZKPnMf1gK3rKUQrcf5TksibQERNGUtpyFKUMeYA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YJQ+tqSu; arc=pass smtp.client-ip=209.85.128.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YJQ+tqSu"
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-79a2ee65171so16252037b3.2
        for <mm-commits@vger.kernel.org>; Mon, 16 Mar 2026 03:47:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773658065; cv=none;
        d=google.com; s=arc-20240605;
        b=M57gsuT5dR3iWsw2T1U6SQbOo5ykPe/aW+RbhLsLs9hAGU7ii70+bnmDCFXonQ3ONi
         CPnJ73DPRfqH9ZSj4yzUzXjfe2BeAclQsap5rAjQ81Xl0F5hZcZnZoOeBA9+ko3E8rGk
         njnSv5/OdzZCVJScUvrYsIEo+O+WQUoaH2gpVAWyeTXsu44fNJvNi6KF707Iv+VRiv3y
         KAUOa7YhWuzcG/ERRgLv06R5hf9/rkwoAxy7m2eo+YcUvfJt/xjtc3i4YlKarkDgr1lU
         2A1E9ltBY1bM08jofhPgCYKSX1MdAOINWNlKKHctGKALrmPpZugXzkNzltEYF98lyWZj
         zzOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=MrV/NL92Zn3KnR5e8dfOczc7+UeGzUJg+utprCqYevI=;
        fh=wSvwpzyzW+nXzCrAs80lvyKUYIWV7K6hPT0pKseK65k=;
        b=PUSUrySIL7LfhQYE3lwzplNId/qBSHFNWjURpv9Ui0QQg4/8im3Wx6WooX9wRBv5j4
         Lr370s9l5wIk0Qoyq7zEFnDU4I1OVnFNEQCRp8ikDy/XLzOPvqcN8OqHoVIAQ3jI3jIu
         NdVVQZEUA75qS/b/0dmfCbYqLqzXbispFt0yFEXpcicI8b9oeBlMa4hQv2YjKjjS8VUj
         r0GdeHA0zGBWi2rsV8Zygt/z+5ZAmLg6tla2B6Td8fZfiB6MBP3AwWYFiUgdtzbRL2ds
         4ghQ4JCpN3V58uBy9+xtCWUge+lkEIYBuLwyU57Xm76Z6CdyI2rlbhQTT2DWT6SfhFmY
         pU3w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773658065; x=1774262865; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MrV/NL92Zn3KnR5e8dfOczc7+UeGzUJg+utprCqYevI=;
        b=YJQ+tqSu8HgdXk9WyYxf2TBma7PAnpzO2Pxl1HG1auIKjo+bm0L6i93T5KxePw29jp
         yr4CIDMpOnekaAjybdcHI+mO4r5ZbxIgcYh54PfGRtiBOIJSMgvL11UTXGPLRrCnoTfH
         VWk1EiFcHHAKobbGadxyjsgRLyiqu76bnIybapAChikyhE0ExwQSGpMwAyz5UTwsp/ew
         suA6X9wMbamRGls3Ot5lvMLtlEXKdM9aW0azxM/mX6ldUoY7E7QM3j/j7mhP7uy4MD93
         /uMAnjEhRYhvsvEH+EBDxwIDUyStZDAsNKgdyVvBmqnjkojLSeb/twzHtKJ7E7HP4Qhp
         jaFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773658065; x=1774262865;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MrV/NL92Zn3KnR5e8dfOczc7+UeGzUJg+utprCqYevI=;
        b=E8MzZpJcrdKm3pu8hWprcka/G7VB6VoYJS1VOi+PNagzRJsTWiWlVf/IAVrRXZ55Cb
         mKKHOM67atjqlkScKrNslImH9BNr1WkAaC+uzYKiga2ONFYUJMT9/Lu6ikWOUhLWyN9h
         m2P7EYhYSth+ucoTNqyqAKdpNVr1egWKMOlCFD9Ty8k1v46mIm+/BYPUYavaxltdOL1Z
         mvxEemXUPFnv9ZL9kRkE4CtLW1wCz/QFKJP92ibDjERrXR+QOqoL3rAO8ZdN+f7uhntR
         knZdkuwYlMIx1ZB6YNGBvijhJak78cVhLzALeqG0d4aVu4j7AwCpP2qbLb28fC+YWotp
         sHfw==
X-Forwarded-Encrypted: i=1; AJvYcCWZGnSR6m8URoPAYXlrfBt/ewdQ/prUqNYeBYmvD04/PvvGn3FUpJlP5M4BkMYEGB3wDOIvR/s3TNUj@vger.kernel.org
X-Gm-Message-State: AOJu0YyJrzVwu8na1ldREWl5b4JFxT4ix3xU1Ju1BVPL4eHtIUoaALFo
	3P6sQS8ttOrACrqfv+IYlxGYXwJlpOjlrA1OGW6mqFgs6DY8UMMoU2pG0lUOt30bMy/5RHn+3PI
	OFgBTFVuLWGD+Y0ASMHoL5Lxtl23KsQ4=
X-Gm-Gg: ATEYQzzKI+J3U/SIlk1+wZkkdi+8Vz3GYfmvhlI04RfmSvbGoqc75VveR7W+tuUiWNk
	FV5WiYU3QQFoV5zL1ztTl+aVv3NCVEz3Tgq3AsRN4FM7C3K8p7sAMiRdRZ9YeODrXY/cAITsAFr
	ZdlCvo+fepajK3d5j1W4DKhiJtwrPtzWFDuepfAVxZ6FO9Zj3yTJu2e3Nht/L+S3lKWRWf50xeE
	QUSO8ibguUN2PGIPFwVhban8qQjDrOHga6zjuNjgCKuZVBHe3Mia56PGlwUYq7zmzKPrHRIXnvj
	Rpivo3eh/URCCt1ZOZWlPJIAJfe9ho6KnYOY2hC4WMHEbzKcUGp6AYsITJfsD3enYBrFzN0s
X-Received: by 2002:a05:690c:698f:b0:798:613a:2efa with SMTP id
 00721157ae682-79a1c1a7074mr132018017b3.40.1773658065304; Mon, 16 Mar 2026
 03:47:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260309200920.56FCFC4CEF7@smtp.kernel.org> <abcQ4o0BipVJkT_8@redhat.com>
In-Reply-To: <abcQ4o0BipVJkT_8@redhat.com>
From: Deepanshu Kartikey <kartikey406@gmail.com>
Date: Mon, 16 Mar 2026 16:17:34 +0530
X-Gm-Features: AaiRm51HsxqXpi679PZAsuJUEVKirWHtjhCTMM3c2IQ2owFDZnN2RMgcE2DSrYk
Message-ID: <CADhLXY7k7roiZ3gw3GhmNmX50erQ6dz2xp4pD9HP1vHftLnAkQ@mail.gmail.com>
Subject: Re: [withdrawn] do_notify_parent-sanitize-the-valid_signal-checks.patch
 removed from -mm tree
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org, 
	mjguzik@gmail.com, kees@kernel.org, brauner@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 16, 2026 at 1:34=E2=80=AFAM Oleg Nesterov <oleg@redhat.com> wro=
te:
>
> but then please also drop kernel-fork-validate-exit_signal-in-clone-sysca=
ll.patch
> from Deepanshu (cc'ed).
>
> Because that patch:
>
>         - is not complete in any case
>
>         - makes no sense (at least with its current changelog) without
>           do_notify_parent-sanitize-the-valid_signal-checks.patch
>
> If Deepanshu sends V2 (with the updated changelog), we can reconsider
> both patches from Deepanshu and me.
>
> Oleg.

I have sent patch v2

Thanks

Deepanshu
