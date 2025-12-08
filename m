Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66B1B27F005
	for <mm-commits@vger.kernel.org>; Mon,  8 Dec 2025 04:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765166958; cv=none; b=SDdBrUsK/v+Ce2Vfaps9vXG1cjztAlQURaxVRi1JQ6Kfh02wVlLqdyOKDjVIk0m0DU2iPrtd32A4WMDE2NjVR82JZjRckUVgv3+BJ+8W77ymCQ3JSUFdg5gLdfdUr8UriiaLqZRWQcGLl1fbykTe0VxHaKCUBKzVTvkoi5XAz/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765166958; c=relaxed/simple;
	bh=90HZCskzrFowV8NiUnXNf+ROEmC0IuQ6bKs3p/jgp38=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VVTgfQIFUN2sZI/H9/Tk2pD4GrA2Qp95ITNgeb3tuoJz5NeXGUr+sHdBqvoQr/bXg7Dt/qAXNpBZe8h2E9d6IMl1sxSzwCYNrkXtVIpjWe04OhX0Tb86hb4hpY4EKxEzbCB3fEvvJUX0GFwC5cqVhopeOut/vZVuaf3ox2MIaic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bnZXdOrl; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bnZXdOrl"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6419aaced59so5387502a12.0
        for <mm-commits@vger.kernel.org>; Sun, 07 Dec 2025 20:09:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1765166954; x=1765771754; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=yjpMpxTSEmH7ETp9HeUWdoHVAlweFsF90v8ynWQoJSU=;
        b=bnZXdOrlRYsxNELjMrWohoT24/ttvVkQTHoVD5qgxiDbjE0cv2IDPh+ONNZ85F5Y39
         BrTc7NF+zO9ahZOIRYA+u5DYl7znNU8F9gt9Leq9WCaWUlM60kvJafi00ltI1Lwmd1Oy
         HIMeHVsMuhfULBvsf/J6oiWaqzlADOfUfxs8k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765166954; x=1765771754;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yjpMpxTSEmH7ETp9HeUWdoHVAlweFsF90v8ynWQoJSU=;
        b=ZfXdvfB8glRl9qjHbbAM+y/1LlH8nwxsTiJy1IxNg4HZlGIIaQuXaVeO+5YOgCZ4iP
         QkvrcCwtWZmKPL8Cqj4QmvrXay1UIinb+PPbjTXKTs8T6NN6Uwgs3wOMmClYhM+WpjIS
         vaCtUsTc3O7gkvccFRKFCsVZsDyyCa/hIv1sZDwB/2E1tIS5kddAlk8t0g6neljaaAM6
         RI6x0y40v23+MAfsr0feuZ+30fZTmBte3TnAj3pEaELgFf+QtES0hIyfiUDKSdMH3d9H
         xda+dTpVWNgVpkCnk6yvPMFMc0CiyWvJ7+IM1OhoJy1qzTMQk9wXjxE1QfERdQmI201E
         n+/Q==
X-Forwarded-Encrypted: i=1; AJvYcCVaMkRbNl1sNytAOAtw496YDH2YJrzNyUccpDPNpQEFh2mpmjFbFJiswUNeXr+1Ez6wRK5DrHP87Cud@vger.kernel.org
X-Gm-Message-State: AOJu0YxEBM+C9MYD8VHKEkMapC2944lXjZ3AY4yj6OMREOG6G51epn4A
	BXT0IFioA/BNtb4+KDefKpqVj0xI2Gq003yBK5r62Zp0zTMJO/gPFKGVHnOLcyvwVJIrSDJLYeC
	PNzw0oIL+Yw==
X-Gm-Gg: ASbGncvaE2XC7lWc7Nv9tkGFGsPsnJtQCSQ4s1BXsEnPoEUX7kIqmop+9GUJII5xVEP
	hqowkQnhXEHIvg1ef4MCvN1L5cy5mW5vbZXe+SRyjcaeu4qVNiF+AWdi9lG/MdYunXEPJ7GcoxG
	G3WZqM/OPt4Y3+lgp2KuP7IJntrEFRqxaVLJb73JrWhSg9GSLzRUD139Va//pQZDEIuOBxlXoh/
	qzr6FNGRD/53qShvgfUG+GT3nbjSvbOmPTZZSSbsFFWOlKnKtC6ieYkoJG9fqf4HDJ/HSm1mUJV
	MMfFaMaOaL9um4XS99Wf504+GXgT5KJ27EXEKY2/W8s0Ys/wxZLaKec994VxNSH06hRIPcofzaL
	0CRMgfTRLrIOUWYT8fTmnoBTYy9liosaO9RGsLGdelkQO4q0Y5auo2DtK2uNIUatZu44F8KbvYB
	VF6SfqtJEjz8ecDtZBoPJpGevA9Xu/jbFZBBDvt/W61mjj2IUVoNJVir1ElnS6KzsxSW/sIw==
X-Google-Smtp-Source: AGHT+IEvbPGxVVVT5vnVNcrdHYijNz190Plmw+0gizbPNNirnKzv9Veum2p32JsIPJ1uZg55e9raQg==
X-Received: by 2002:a05:6402:5244:b0:649:2cc5:795a with SMTP id 4fb4d7f45d1cf-6492cc57a04mr3418068a12.18.1765166954455;
        Sun, 07 Dec 2025 20:09:14 -0800 (PST)
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com. [209.85.208.45])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-647b2ec31a7sm9742914a12.2.2025.12.07.20.09.11
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Dec 2025 20:09:13 -0800 (PST)
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6419aaced59so5387455a12.0
        for <mm-commits@vger.kernel.org>; Sun, 07 Dec 2025 20:09:11 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVOCI1PKlQie33ucjg+7UVSYHDBLI29/s82buYqnY9J0wXfYXgLlE9XtviOYtUsHG32IY2Zun/cqKt2@vger.kernel.org
X-Received: by 2002:a05:6402:144a:b0:647:72a2:771 with SMTP id
 4fb4d7f45d1cf-6491adf5cb1mr5006982a12.22.1765166951064; Sun, 07 Dec 2025
 20:09:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251206111533.f1b18ce84d0854b5f6d86a8f@linux-foundation.org>
 <CAHk-=wgG3xqJn1=SVw-npsdwCRtyY=sYbLa7HFkmj_Q0U=vdHQ@mail.gmail.com>
 <5e5e24eb-6af9-464c-ab1e-f9ee55a05a24@linux.alibaba.com> <CAHk-=wgvMBRrcR=DzsRKcLdZpmg-kJz49D1CzafjrWj+BzAGiQ@mail.gmail.com>
 <f72b8316-ddae-466e-a72d-0df9960d6c82@linux.alibaba.com>
In-Reply-To: <f72b8316-ddae-466e-a72d-0df9960d6c82@linux.alibaba.com>
From: Linus Torvalds <torvalds@linuxfoundation.org>
Date: Mon, 8 Dec 2025 13:08:54 +0900
X-Gmail-Original-Message-ID: <CAHk-=wjiiHNi9iCNZG58zH-AXpfM85giXho9m5YC8t8us4aWAA@mail.gmail.com>
X-Gm-Features: AQt7F2qwZ98ba2_lKzAT1Sk2bdcZpr0oj3bTXTVca09vBhmN_TYgXCKX_2Zkd3Y
Message-ID: <CAHk-=wjiiHNi9iCNZG58zH-AXpfM85giXho9m5YC8t8us4aWAA@mail.gmail.com>
Subject: Re: [GIT PULL] non-MM updates for 6.19-rc1
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Heming Zhao <heming.zhao@suse.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Dmitry Antipov <dmantipov@yandex.ru>, Mark Fasheh <mark@fasheh.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, mm-commits@vger.kernel.org, 
	Pasha Tatashin <pasha.tatashin@soleen.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 8 Dec 2025 at 13:01, Joseph Qi <joseph.qi@linux.alibaba.com> wrote:
>
> It seems now new_xh->xh_count is 0. That's means, it is trying to add a
> new entry and here 'last' is pointing the next free entry.

No. If new_xh->xh_count is 0, nothing ever happens, because it checks
for that case:

                        if (new_xh->xh_count) {

and that's the only place where 'last' is ever used.

                Linus
