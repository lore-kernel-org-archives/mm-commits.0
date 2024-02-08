Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C4947B3C2
	for <mm-commits@vger.kernel.org>; Thu,  8 Feb 2024 18:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707415734; cv=none; b=gV4WKosTcURPk6mRt/XxQ3GFYiL3vDHO3g/p6/zWtwbxvtfH5YN4dbAIctGS6BDpLSRT/kljY6sNu7FCIYGUTynFyqJvLa7rKEdjq63AT2SIMDd00FO5bFAKjrrLGarmUxc8EeFFoU8NCAaTQF9di+Ci8A5WlXyeEj7duhp+JrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707415734; c=relaxed/simple;
	bh=nTJHlCv7cDadeS9h/6dUsRlEaUtEOIN6H9uKR/Drf8w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=J/5W7xwbwNDhX5sp5t/TlBL5eY67gXPF0D7QuangienzD9N943SWaF1PsPoROtBWNS+p/XjrFk+mc8aiKde/VieIh+lwgdXBQAbwQSQf0IWbSSFhg+BURPO9kVC3qagxQCk2a0j+iFao8AnrJl693C4RPCueagbaHL5i82zYD0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=soleen.com; spf=none smtp.mailfrom=soleen.com; dkim=fail (0-bit key) header.d=soleen.com header.i=@soleen.com header.b=I60pLSXi reason="key not found in DNS"; arc=none smtp.client-ip=209.85.210.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=soleen.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=soleen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=soleen.com header.i=@soleen.com header.b="I60pLSXi"
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-6e1214ae9d4so20824a34.3
        for <mm-commits@vger.kernel.org>; Thu, 08 Feb 2024 10:08:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1707415732; x=1708020532; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=nTJHlCv7cDadeS9h/6dUsRlEaUtEOIN6H9uKR/Drf8w=;
        b=I60pLSXiW3/fqoQMu6gzSHGvScjVsTiPMj9LvOZqAOmI8KvJ1OegmW3WCaurvc6HkC
         5GyulfhJGo2GVv1JdU+o/qooG8afeW75upEWK3Upteq1VXfCszl2tD3NKdsSmjjsMhRk
         61BmU6NTohMijKvZzCuovNbOj3zj2f0hhoOIvEvDQ02IbyDlDXOrY2U5VwxDAN9Sjwf5
         fyMUBdBwrVQFZBrugMT9wD0JWrIj4AI167R1Q2F3z/PjMGVsSDAF+ghBl5p8CQBfFqJ8
         Ts08otWa5dZyUSB2cvnIzs4mMZPKtrtav7iAA4svRcHg/G7d7SBp7PtP5sbUjStBlHLk
         Zyvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707415732; x=1708020532;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nTJHlCv7cDadeS9h/6dUsRlEaUtEOIN6H9uKR/Drf8w=;
        b=f/vgLC1NQWR92aK73fshJVPWjbv2hcEXRsvTpdimjZ1LeL42KvoE1eUABlIMVdbmrX
         m8QHGBsbPRBLWpjpCeBFvTuIvqHLg907W/G9eVt0ApgU+6Ua3FvtwggeXsCz+qnb1Obw
         4dFliTzazZtHacPoaFTls2Qz303Ozadtad3nzP4+fAI5LxACincKsDcd6X5XWPV46nt+
         LTNcHqqHlQnjB5upvROE4YtfG7cNItLyaq1tnfe6dnNh8DJU+YuD9y6/7A4CYfqSxQXA
         xrRujrGgagDNbF4NDvGmVCJEldEP1nQAqCDfwAECXtlR/XS9XKwrRetWXibB+uUhL6NX
         cHNw==
X-Forwarded-Encrypted: i=1; AJvYcCVahGhBamndVocokN2I1Yr0UsYYDj/+WaLG0CFW+uTR6BbsIKSdjvl/OeDUQubg5zzbKFXa0G8S+Wq/b1l7+Eh8spkaYOv+VJQCbA==
X-Gm-Message-State: AOJu0YyRmmcVvnQss8qKfWaxuwGCBBo2Lsch17+ygD5CQZGuN1BV4p8a
	FgDWQ1PlefsmHuzmoVN/l4sElMxqL8ZwyKzxSZhlKDWwZrKDMkzg9SM6Lz1XTHZkfaDzWldUxTW
	MCd9TBJW8xmi8nEQ/YGt4Sz3rr5NtDvRDQAMYcQ==
X-Google-Smtp-Source: AGHT+IFo8sr0A/wm9vHFl5R7DYVtg6xPXwWhZb+yUXdK8j55aG5jJOUf4uGytmBYA24Mgxhj7WY/9aTo6o8z8W/fs+c=
X-Received: by 2002:a9d:73ca:0:b0:6e2:b28f:6179 with SMTP id
 m10-20020a9d73ca000000b006e2b28f6179mr287814otk.1.1707415732212; Thu, 08 Feb
 2024 10:08:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240207231014.3A3F0C433C7@smtp.kernel.org> <20240208031413.GA185687@cmpxchg.org>
 <CAJD7tkbdzwjhhgK_-6iAHLn05Q-7wCOzEn9xug1Udr+Df-hLkA@mail.gmail.com> <20240208064411.GE185687@cmpxchg.org>
In-Reply-To: <20240208064411.GE185687@cmpxchg.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Thu, 8 Feb 2024 13:08:16 -0500
Message-ID: <CA+CK2bCxPVyB8ZVk3dA5TKROScNHMzdu_PkBTK9b3zStvgemDA@mail.gmail.com>
Subject: Re: + mm-report-per-page-metadata-information.patch added to
 mm-unstable branch
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Yosry Ahmed <yosryahmed@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	mm-commits@vger.kernel.org, yang.yang29@zte.com.cn, willy@infradead.org, 
	weixugc@google.com, wangkefeng.wang@huawei.com, vbabka@suse.cz, 
	tomas.mudrunka@gmail.com, surenb@google.com, shakeelb@google.com, 
	rppt@kernel.org, rdunlap@infradead.org, rafael@kernel.org, 
	muchun.song@linux.dev, Liam.Howlett@oracle.com, 
	kirill.shutemov@linux.intel.com, ivan@cloudflare.com, 
	gregkh@linuxfoundation.org, david@redhat.com, corbet@lwn.net, 
	chenlinxuan@uniontech.com, bhelgaas@google.com, adobriyan@gmail.com, 
	souravpanda@google.com
Content-Type: text/plain; charset="UTF-8"

> > I am not closely following this series, but I just wanted to point out
> > that this is not always true. We are actively extending
> > NR_SECONDARY_PAGETABLE to add IOMMU page tables in addition to KVM
> > page tables [1]. In that case as well, the name was left open-ended
> > exactly for this purpose [2].
>
> I think you're glossing over quite some nuance here.
>
> Sure there might be highly specific scenarios where you can get away
> with it. Like with a very recently introduced counter for somewhat
> niche audiences, and bucketing/grouping that was IIRC planned from the
> start. It's probably not reasonable to advocate nondescript interface
> names as a strategy for getting out of ABI commitments.
>
> My point was that "memmap" is the established term for what the author
> describes. And that this concept is sufficiently first-class that
> mixing it with other things later is unlikely to be acceptable. I
> didn't know WHY a new name for this was chosen, so I provided
> arguments for two motivations that I could think of, that's all.

Sure, we can rename it to NR_MEMMAP_BOOT / NR_MEMMAP. We picked
NR_PAGE_METADATA_BOOT/NR_PAGE_METADATA as we thought it was a clearer
choice. It directly conveys the concept of page metadata overhead,
eliminating ambiguity about future potential structures. Today, it is
"struct page", and "pag_ext", tomorrow memdesc and more.

Pasha
