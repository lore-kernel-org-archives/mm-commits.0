Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89BB21E7C1C
	for <mm-commits@vger.kernel.org>; Wed,  9 Apr 2025 21:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744235899; cv=none; b=tXCr6AqjdzNF+ryRbwWIV52HHC5kE/hkJnvKWEtRYIYjXaO1T6kIhqjgEnKKhUlx6M/zyfwMStJn/koDXiUTPNDL/IeP9vR78AfxBMsvddyUWCJH9zqDUp6n0yXAiS+xNAftLCNliNwjeOo3+djTS26m6sLJEmsmaVmikj9Z2HQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744235899; c=relaxed/simple;
	bh=0nFkHUPAlc0I1FOYvKUq8VmjB8LHwh1qovpVHIs6hAo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gr7xC0ppPOZLHR6rQ25NawIMzjS5/dvwiNX/woGF+283SaKnbvARea4t91AaTi8sbWr9ARp6+i5icOPjsvq6rIcCyDnPs5350URG61wSYoQdLTQpswIq7QZWGFlePg4sn8WH0xN4gVdUT7Nd+BVmx9IGMsjNojPxde0N43CGrqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=n2paZGHK; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="n2paZGHK"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-43cf3192d8bso8005e9.1
        for <mm-commits@vger.kernel.org>; Wed, 09 Apr 2025 14:58:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744235895; x=1744840695; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uHM9muTKfrXd9aqR5zV7SMKrJOiG+iDY4wChxrhJl6A=;
        b=n2paZGHKbsI31X++f+e9cQYwNf693BRscTTaWARct2lAqDKUTqjHQkFzcJrogoVznm
         rpF81v7PN0EwdT52msxyAMUuKtruIo/NpVA39lvl0GjyMNhkN1BnxNgACfTZD/cnhMgj
         PkW3noYyrYa743G2nikiDzfynxLpPdqAUwyu7KewZpPDY/v7LVjkCsUBPOcHHrlo6uav
         FXBTZ2RZYi00gIArqOGNjkdtRO7kVyE064E54Kgrl2SZs6d+AT5qNFN+B9gnElzClbnL
         4wwMa7VkQtKALHYOVlPGOLMqQFezWasQEVHnPWrqLOYVFyIKkSaNp5DpKRu/qewsPbmt
         T7/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744235895; x=1744840695;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uHM9muTKfrXd9aqR5zV7SMKrJOiG+iDY4wChxrhJl6A=;
        b=mZRpzYbor12LVCZQhDfKXS3qL9GGGcil5pAk1YVEu4pEIvDzY1v95wku0A9PXWN0kh
         6xYuwCldUperd/OGzg+4TuNX/xuRP70jVxBvsgPdPMWj70x37HUI6LExOkzOQIbImgwp
         osIW/ThPkpinaxSnxqG/azI5YjR8MUXTZfyzC260oVXFkPDOYURpl1VYoRQqhl5hEsxn
         vvW0e9vtIAhe67saY68N5oouYHz3Kwu6AXQw4h3/eDvqkAzUCUamzBjB2PoblOd/3e9+
         n/Wb2Iyu1f76wXpBoSqmDXvz15T+FF46Di6Hf69zoH1tDIzYQQuufP0lbNZA/GsLifbD
         xqJQ==
X-Gm-Message-State: AOJu0YyRx3iY+dLrLjKs5nOUWVdbL9NPplF/DuYDa6LgrAHWPhO+2emp
	X9XOTFn2mxDcFmYLmFXHZoynVIaT6vxsdP1naU1EJvQcpJXMjIOWRgMnQgMnM9NX7FlBJa/F5QU
	ZYjGrfkhONtmAOvwnjO9CD8DStZv4OIj5Zv9K
X-Gm-Gg: ASbGnctsdJv4MsxBzTAgB95aKjwSG1Revuj3cMjGkHMCG6eo7MRiMhqTY2iwzibd8z0
	uePt2joBFtcXi7hX++yZ0KZ7t/DUp6jDiIWxgNSW+u1X/GqrYwMqpvvJ1jjZzke+gaItH69vPLD
	aMpZuPKeIXM2u/RdLTG1CKhhylX2RdphDsTAPgmfyuD+B3Amiieac=
X-Google-Smtp-Source: AGHT+IGNGwnva+gICJ5WQa3hrf7rRIIOZmzHju1WvnqLhCD6/wZWRAw4agWWnzWJT9wURz7SJnk46zh8GGg+Xx50m9I=
X-Received: by 2002:a05:600c:1f8c:b0:43b:b106:bb1c with SMTP id
 5b1f17b1804b1-43f2dace339mr263625e9.0.1744235894548; Wed, 09 Apr 2025
 14:58:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250409211241.70C37C4CEE2@smtp.kernel.org>
In-Reply-To: <20250409211241.70C37C4CEE2@smtp.kernel.org>
From: "T.J. Mercier" <tjmercier@google.com>
Date: Wed, 9 Apr 2025 14:58:02 -0700
X-Gm-Features: ATxdqUEbE3CZxtKpHpWKZp7E8dj3fHaqRF1Zy1BhbdU0bnSVU8IkMU0Q14OJmBc
Message-ID: <CABdmKX21Bw1JrY5YxvTHpSOj5qAqAifcBRUxvC7BSNw4EUpEPw@mail.gmail.com>
Subject: Re: + alloc_tag-handle-incomplete-bulk-allocations-in-vm_module_tags_populate.patch
 added to mm-hotfixes-unstable branch
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, surenb@google.com, stable@vger.kernel.org, 
	kent.overstreet@linux.dev, janghyuck.kim@samsung.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 9, 2025 at 2:12=E2=80=AFPM Andrew Morton <akpm@linux-foundation=
.org> wrote:
>
>
> The patch titled
>      Subject: alloc_tag: handle incomplete bulk allocations in vm_module_=
tags_populate
> has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
>      alloc_tag-handle-incomplete-bulk-allocations-in-vm_module_tags_popul=
ate.patch
>
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree=
/patches/alloc_tag-handle-incomplete-bulk-allocations-in-vm_module_tags_pop=
ulate.patch
>
> This patch will later appear in the mm-hotfixes-unstable branch at
>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
>
> *** Remember to use Documentation/process/submit-checklist.rst when testi=
ng your code ***
>
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days
>
> ------------------------------------------------------
> From: "T.J. Mercier" <tjmercier@google.com>
> Subject: alloc_tag: handle incomplete bulk allocations in vm_module_tags_=
populate
> Date: Wed, 9 Apr 2025 19:54:47 +0000
>
> alloc_pages_bulk_node may partially succeed and allocate fewer than the
> requested nr_pages.  There are several conditions under which this can
> occur, but we have encountered the case where CONFIG_PAGE_OWNER is enable=
d
> causing all bulk allocations to always fallback to single page allocation=
s
> due to commit 187ad460b841 ("mm/page_alloc: avoid page allocator recursio=
n
> with pagesets.lock held").
>
> Currently vm_module_tags_populate immediately fails when
> alloc_pages_bulk_node returns fewer than the requested number of pages.
> This patch causes vm_module_tags_populate to retry bulk allocations for
> the remaining memory instead.
>
> Link: https://lkml.kernel.org/r/20250409195448.3697351-1-tjmercier@google=
.com
> Fixes: 187ad460b841 ("mm/page_alloc: avoid page allocator recursion with =
pagesets.lock held")

I wasn't sure if this should have a Fixes: but since allocation tags
came after the commit above, I think it'd be better to reference
0f9b685626da ("alloc_tag: populate memory for module tags as needed")
which introduced this bulk allocation.

> Signed-off-by: T.J. Mercier <tjmercier@google.com>
> Reported-by: Janghyuck Kim <janghyuck.kim@samsung.com>
> Cc: Kent Overstreet <kent.overstreet@linux.dev>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  lib/alloc_tag.c |   15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
>
> --- a/lib/alloc_tag.c~alloc_tag-handle-incomplete-bulk-allocations-in-vm_=
module_tags_populate
> +++ a/lib/alloc_tag.c
> @@ -422,11 +422,20 @@ static int vm_module_tags_populate(void)
>                 unsigned long old_shadow_end =3D ALIGN(phys_end, MODULE_A=
LIGN);
>                 unsigned long new_shadow_end =3D ALIGN(new_end, MODULE_AL=
IGN);
>                 unsigned long more_pages;
> -               unsigned long nr;
> +               unsigned long nr =3D 0;
>
>                 more_pages =3D ALIGN(new_end - phys_end, PAGE_SIZE) >> PA=
GE_SHIFT;
> -               nr =3D alloc_pages_bulk_node(GFP_KERNEL | __GFP_NOWARN,
> -                                          NUMA_NO_NODE, more_pages, next=
_page);
> +               while (nr < more_pages) {
> +                       unsigned long allocated;
> +
> +                       allocated =3D alloc_pages_bulk_node(GFP_KERNEL | =
__GFP_NOWARN,
> +                               NUMA_NO_NODE, more_pages - nr, next_page =
+ nr);
> +
> +                       if (!allocated)
> +                               break;
> +                       nr +=3D allocated;
> +               }
> +
>                 if (nr < more_pages ||
>                     vmap_pages_range(phys_end, phys_end + (nr << PAGE_SHI=
FT), PAGE_KERNEL,
>                                      next_page, PAGE_SHIFT) < 0) {
> _
>
> Patches currently in -mm which might be from tjmercier@google.com are
>
> alloc_tag-handle-incomplete-bulk-allocations-in-vm_module_tags_populate.p=
atch
>
