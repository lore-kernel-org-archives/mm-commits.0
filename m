Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C3832D781E
	for <mm-commits@vger.kernel.org>; Mon,  8 Dec 2025 19:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765220885; cv=none; b=kH5hsf1vttGPBUopaxrevsKv7fbKNYKd0wYxUuN8cJa+5NnHna3AtuMNSciTG77s13uIRnPFe8ornmgKviKRR8HFxupZBIx+3Z96dtt08vXigt6Juk9652FLM763rduwmjPtwgFWvxlvHmsyls44j1rI+vDS/6fLpzUwebb3R6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765220885; c=relaxed/simple;
	bh=kKYXRUbrumnXW2PR0/tHpdw7DwQx/a9r4iGjW7qlEm8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YYJ4sSDE4V0h/o6wO+yJqdnsSUzyKi5WjiTDHsc6J48wUkPQz0oKDb5RIgIqlTb/LVbjLf0n8EgBGHnIz8JG2UkP83X/XarQBjrBUO+DAMzM2xtMJhGeZQqozcjlN6MJTADkepZKYMPS5aBojYRRGW5kEcDb/jvl/3REVNrHj74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fasheh.com; spf=none smtp.mailfrom=fasheh.com; dkim=pass (2048-bit key) header.d=fasheh.com header.i=@fasheh.com header.b=PVNEfjQz; arc=none smtp.client-ip=209.85.222.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fasheh.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fasheh.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fasheh.com header.i=@fasheh.com header.b="PVNEfjQz"
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-8b2a4b6876fso741469385a.3
        for <mm-commits@vger.kernel.org>; Mon, 08 Dec 2025 11:08:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fasheh.com; s=google; t=1765220883; x=1765825683; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4yPID28DpX/lRAgXOsnJ1NIPQsZ48K9MGkXMnfljxvE=;
        b=PVNEfjQzmbRuzlmplJ4m23rfRaisgIVcTPNDBqvUiwJBAEsJjuFwD6W4VfZ6hSq8qu
         pzxwIu+RJPEv6MhxbSRDWnLMdKvCqOztrQC6Ut/7n1ao3pvsRlZ2eHdtdWhHsupmUS4o
         wYVDPLSrXT25nLLye+M03lX5EE+NOAdUj984n/opl1R6TBtmR5V/q/vLjcJC0NaGZVUg
         Q0OuVOCpDnFs/ANffcNZm8s/0gSP6gsiCo89TPOdL4jLFmOUi3NjoTNiGW6NHv1WKCjq
         XJawF8y1u2NpmIew3k3a1VYIMpm/hKR98KNKYTegjEmQvHaF0vX1DqxeHJGtVMQEZS+D
         ie4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765220883; x=1765825683;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4yPID28DpX/lRAgXOsnJ1NIPQsZ48K9MGkXMnfljxvE=;
        b=vb49NrirM1uX0QW9Y1aqIZp4pVfUuX/DabbuKmIjgITDmxUT1Y/IxgrxJYWnh6fLir
         v1qeRl3/WH/xbbSXlW3sabfKrvUN60gqMXLtc9jffhG82JTkvmRUFxhg6spBIsqaDlah
         lkmOHCcxNWeWjjLAwl7A+Wdf9rVdFFUbBlKV/20diM6Y9ScN654Ox17HBW8m9KVtoQGG
         Be1HNMsyzlzOgwosmM+3kLfNdRKmPlvy7ILAjFm81RVDJJCrtf5jtWspzaKfTnwV773f
         ReHajW10f5ay02ytfj2JQPZxljDS1WklHidvra2sF6mbyUpaIkeUMODUZFz6NTaMdvlf
         fLzA==
X-Forwarded-Encrypted: i=1; AJvYcCV4Yl56Bc6FYB7wYo0skg0s59BdWBs8YFItS4dYWzLiiu9e1BccR6/2QXgf2HFz0g4vNH7XiRV01gdN@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8PO2vhMcKGzpaylJlJriXqiOlvKQVddw4RFYPZ/oSqL4VW4Zr
	oZaiswFGx+2ra3YSrXzmcJRtwYA82igLpa5UrTKU5RtB4g6H6a3+SK8ZoAEGmD1AEguiV4vg0wI
	7k7LGS5EY64Q8ZminO/kFHoBegyw3cwH6w8KGcmIOCA==
X-Gm-Gg: ASbGnctHRJW2Uhhe8gT8jJ73HaOBVRytAu0bjAiCfGJmMGKAR8MrkVUxa5GjakE/Ymy
	0lxyu7vhwYCjSeNS+LOjDx1YK3GlffCxqofr6PLzL4QOYzcKgngBlYeYtFM2PuLWwWI2GwmMHMM
	+HqYq4NJQAV+Ttoo6fs+mMlh0R56d5Q2BWwo6P0SuWlzlJ/dQcX5UFiAeNS8ToPmv7b0yNBxYZ0
	0dhPUecbEMxQEQCD335CEaaoW+c454tOUZoViY+qbYYF66ZqNaXFGG4BSqJ2fn6nO1kz5xljM9O
	9Duilv+GA18ophMfJjsl4HNLkts=
X-Google-Smtp-Source: AGHT+IF1FXVD37QbUsQ0Ik7oXHDWD0jOrlfrEIfFomFdjurHr8pgoEPacv+H7BJz2eBcQ5cFiqmqRanY3KfCqKHA/R8=
X-Received: by 2002:a05:622a:4d91:b0:4ee:56c0:712f with SMTP id
 d75a77b69052e-4f03ff60e91mr134665501cf.76.1765220882981; Mon, 08 Dec 2025
 11:08:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251206111533.f1b18ce84d0854b5f6d86a8f@linux-foundation.org>
 <CAHk-=wgG3xqJn1=SVw-npsdwCRtyY=sYbLa7HFkmj_Q0U=vdHQ@mail.gmail.com>
 <5e5e24eb-6af9-464c-ab1e-f9ee55a05a24@linux.alibaba.com> <CAHk-=wgvMBRrcR=DzsRKcLdZpmg-kJz49D1CzafjrWj+BzAGiQ@mail.gmail.com>
 <f72b8316-ddae-466e-a72d-0df9960d6c82@linux.alibaba.com> <nrgonfemkkz2bnwfkpzycfbz3luspjm65dakyjt4e4nuawklbw@cw3jqnedbyjf>
In-Reply-To: <nrgonfemkkz2bnwfkpzycfbz3luspjm65dakyjt4e4nuawklbw@cw3jqnedbyjf>
From: Mark Fasheh <mark@fasheh.com>
Date: Mon, 8 Dec 2025 11:07:52 -0800
X-Gm-Features: AQt7F2q3dlmMzj7bH-szN3EmMIipF57sJYb2u4-9z5qtFRDR9mlHljT3ULZgYkg
Message-ID: <CAGe7X7kDBqTn_G458pAvDMJPw6GUjrZAow1DEkzZJiry+kNH1A@mail.gmail.com>
Subject: Re: [GIT PULL] non-MM updates for 6.19-rc1
To: Heming Zhao <heming.zhao@suse.com>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>, 
	Linus Torvalds <torvalds@linuxfoundation.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Dmitry Antipov <dmantipov@yandex.ru>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	mm-commits@vger.kernel.org, Pasha Tatashin <pasha.tatashin@soleen.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Dec 7, 2025 at 11:58=E2=80=AFPM Heming Zhao <heming.zhao@suse.com> =
wrote:
>
> On Mon, Dec 08, 2025 at 12:01:09PM +0800, Joseph Qi wrote:
> > It seems now new_xh->xh_count is 0. That's means, it is trying to add a
> > new entry and here 'last' is pointing the next free entry.
> > If so, the original code seems right.
> >
> > Heming, could you please verify this? I'm not familiar with this logic.=
..
> >
> > Thanks,
> > Joseph

Thanks Joseph and Heming for looking into this.


> In ocfs2_reflink_xattrs(), when preserve_security is false, the function =
sets
> 'args.xattr_reflinked'. IMUC, it means that if users want to preserve sec=
urity
> xattr items, the args.xattr_reflinked is NULL, this then results in
> ocfs2_reflink_xattr_header() not executing the cleanup jobs, (in the code=
 area
> defined by "if (args->xattr_reflinked && !args->xattr_reflinked(xe))").
>
> Regarding the clean jobs:
> - by default, it only handles three types:
>   OCFS2_XATTR_INDEX_[SECURITY|POSIX_ACL_ACCESS|POSIX_ACL_DEFAULT]
> - it cleans the first item and shifts forward the remaining items.
>
> It seems Linus' patch does not handle all cases. If new_xh->xh_count is 1=
,
> le16_add_cpu(&new_xh->xh_count, -1) makes it to 0, and it will miss the c=
leanup
> job.

It's been a while since I've look at Ocfs2 xattr so take what I say
with a grain of salt :)

That said, I agree that the cleanup code looks suspect. I think the
answer is to always memset the entry that we just removed even when
xh_count becomes zero.

Thanks,
  --Mark
