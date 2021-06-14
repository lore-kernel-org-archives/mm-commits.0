Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49EABC48BDF
	for <mm-commits@archiver.kernel.org>; Mon, 14 Jun 2021 00:58:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24C9E60FE4
	for <mm-commits@archiver.kernel.org>; Mon, 14 Jun 2021 00:58:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232230AbhFNBAs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 13 Jun 2021 21:00:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232212AbhFNBAr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 13 Jun 2021 21:00:47 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99D8AC061574
        for <mm-commits@vger.kernel.org>; Sun, 13 Jun 2021 17:58:45 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id d16so9300322pfn.12
        for <mm-commits@vger.kernel.org>; Sun, 13 Jun 2021 17:58:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:references:in-reply-to:mime-version:message-id
         :content-transfer-encoding;
        bh=yu19Ci2qVMALZSkJJyk30I9+LyPST3qZOAR8f441pLU=;
        b=pQN5QUIwUPRfzA8tCFSJMG9L9TClGEJxaFhf/RRRo8IPrqyG9KGaMqVlAR11NN2Reu
         lXbx4du94NdZNDHRCur8dPqCVkr1zw62cQ+kyzW5tf9s9cyAVu/Ez5xNb8LvwdTCJZpk
         53Ho3efuhxfaNb20EVhgu08zlQ8+4qc5mOzZEizlGiaUf2YPzk0UeBpW9SyxzwYO/ICC
         LL7zWG4BwhC4PNAjHgpHvUtZ2yXVGakctEnhK5JLZytJliN4iUerH6vgGsfuVB77XEEE
         3XRrJvDZJg+RLON2mIkeeFYn5HokBk7yKtBfje8Rzv5SY3o+hjdG8l4ZmavlpFCGRHga
         1tRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=yu19Ci2qVMALZSkJJyk30I9+LyPST3qZOAR8f441pLU=;
        b=i+Fq2M+h/9j8/sC0zlhmtB4x61SJYXUKud/1gztkopihQulYXri74SibZcdXGiNY6s
         bofvUUEhWP0jhudCsypq7SUXWeIbTnZ48p/TQ1fxjk8UsSiXR4EQyeOtOIJSwFt4vzev
         8UJM3sRBwrd8EFw8NpeJcJWW2UO2im/iXNhs/KEj1N0xhI1k3JyDC/e5uUgkyiJsQBCf
         r+mEBK/KZkDoxiWx0EhDdhJAyVf12twmhHfiuAS5r5TlGP5lQciXo74h0ZHCmPXQw38S
         hYyHk3CK+ufacT0S9JT9AgookfQcenhmCvaCDGJmFnka1c1ADNsJTFRme7zMGUthv9BF
         9+6w==
X-Gm-Message-State: AOAM531Vec7Eq6ZwwM9rD+UznY6MfUwUVyd65GcFp8ke3AkGhPW6gWG/
        ICCCgC9yDfKkzXPNK/C2bEU=
X-Google-Smtp-Source: ABdhPJxJVtVsiO0v/cIo00aqO3ARTxQs++6qgWJDjf8MQuzfYfAcDvCz99R2up6cF3si5jNhuvZodw==
X-Received: by 2002:a63:1210:: with SMTP id h16mr14576169pgl.189.1623632323861;
        Sun, 13 Jun 2021 17:58:43 -0700 (PDT)
Received: from localhost (60-242-147-73.tpgi.com.au. [60.242.147.73])
        by smtp.gmail.com with ESMTPSA id t62sm2423420pfc.189.2021.06.13.17.58.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Jun 2021 17:58:43 -0700 (PDT)
Date:   Mon, 14 Jun 2021 10:58:38 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: + kvm-s390-fix-for-hugepage-vmalloc.patch added to -mm tree
To:     akpm@linux-foundation.org, borntraeger@de.ibm.com,
        catalin.marinas@arm.com, david@redhat.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, mingo@redhat.com,
        mm-commits@vger.kernel.org, rientjes@google.com,
        tglx@linutronix.de, urezki@gmail.com
References: <20210608210623.oyQ1Gh4H3%akpm@linux-foundation.org>
In-Reply-To: <20210608210623.oyQ1Gh4H3%akpm@linux-foundation.org>
MIME-Version: 1.0
Message-Id: <1623631892.c5eaco2ojh.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Excerpts from akpm@linux-foundation.org's message of June 9, 2021 7:06 am:
>=20
> The patch titled
>      Subject: KVM: s390: fix for hugepage vmalloc
> has been added to the -mm tree.  Its filename is
>      kvm-s390-fix-for-hugepage-vmalloc.patch
>=20
> This patch should soon appear at
>     https://ozlabs.org/~akpm/mmots/broken-out/kvm-s390-fix-for-hugepage-v=
malloc.patch
> and later at
>     https://ozlabs.org/~akpm/mmotm/broken-out/kvm-s390-fix-for-hugepage-v=
malloc.patch
>=20
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
>=20
> *** Remember to use Documentation/process/submit-checklist.rst when testi=
ng your code ***
>=20
> The -mm tree is included into linux-next and is updated
> there every 3-4 working days
>=20
> ------------------------------------------------------
> From: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Subject: KVM: s390: fix for hugepage vmalloc
>=20
> The Create Secure Configuration Ultravisor Call does not support using
> large pages for the virtual memory area.  This is a hardware limitation.
>=20
> This patch replaces the vzalloc call with a longer but equivalent
> __vmalloc_node_range call, also setting the VM_NO_HUGE_VMAP flag, to
> guarantee that this allocation will not be performed with large pages.
>=20
> Link: https://lkml.kernel.org/r/20210608180618.477766-3-imbrenda@linux.ib=
m.com
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
> Fixes: 121e6f3258fe393e22c3 ("mm/vmalloc: hugepage vmalloc mappings")

Hmm, s390 does not select HAVE_ARCH_HUGE_VMALLOC so it was intended that=20
"mm/vmalloc: hugepage vmalloc mappings" does not introduce huge vmallocs
for you.

I can't see how this would happen, any clue what I'm missing?

Thanks,
Nick

> Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>	[s390]
> Cc: Nicholas Piggin <npiggin@gmail.com>
> Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Janosch Frank <frankja@linux.ibm.com>
> Cc: David Hildenbrand <david@redhat.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>=20
>  arch/s390/kvm/pv.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>=20
> --- a/arch/s390/kvm/pv.c~kvm-s390-fix-for-hugepage-vmalloc
> +++ a/arch/s390/kvm/pv.c
> @@ -140,7 +140,10 @@ static int kvm_s390_pv_alloc_vm(struct k
>  	/* Allocate variable storage */
>  	vlen =3D ALIGN(virt * ((npages * PAGE_SIZE) / HPAGE_SIZE), PAGE_SIZE);
>  	vlen +=3D uv_info.guest_virt_base_stor_len;
> -	kvm->arch.pv.stor_var =3D vzalloc(vlen);
> +	kvm->arch.pv.stor_var =3D __vmalloc_node_range(vlen, PAGE_SIZE, VMALLOC=
_START, VMALLOC_END,
> +						     GFP_KERNEL | __GFP_ZERO, PAGE_KERNEL,
> +						     VM_NO_HUGE_VMAP, NUMA_NO_NODE,
> +						     __builtin_return_address(0));
>  	if (!kvm->arch.pv.stor_var)
>  		goto out_err;
>  	return 0;
> _
>=20
> Patches currently in -mm which might be from imbrenda@linux.ibm.com are
>=20
> mm-vmalloc-export-__vmalloc_node_range.patch
> kvm-s390-fix-for-hugepage-vmalloc.patch
>=20
>=20
