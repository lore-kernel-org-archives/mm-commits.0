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
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9678C48BDF
	for <mm-commits@archiver.kernel.org>; Mon, 14 Jun 2021 01:14:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 87BC36134F
	for <mm-commits@archiver.kernel.org>; Mon, 14 Jun 2021 01:14:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232286AbhFNBQP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 13 Jun 2021 21:16:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232244AbhFNBQP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 13 Jun 2021 21:16:15 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA229C061574
        for <mm-commits@vger.kernel.org>; Sun, 13 Jun 2021 18:14:02 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id m2so626835pgk.7
        for <mm-commits@vger.kernel.org>; Sun, 13 Jun 2021 18:14:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:references:in-reply-to:mime-version:message-id
         :content-transfer-encoding;
        bh=aZ8/ATcEtBxrOhxFI3DnUHpmtZmlGKuTXdU3asNNn8w=;
        b=hKtKRPzBKnSMvaUffxbkj0bOoKGYp9TFQ+X/Vu5jWs0E6GkTpaH83/duoi+bScKuEU
         rDfwiKFlC+Of0S0Z3PFY7SbbGcX4vRDR6mCPB+5dqbKhqdF/Efrb/uqBNWULhEenJ8U5
         6MLSxRdNOszqLjvRn5Rx57LBpynjh3TX/Xg9QCkja8dIqfZu+jxnNuykN1SiXgWmREzm
         6kVit/uJSEVUxggmCaSQvWpbRQhgh8s+bNR5icCqh24VdaTzKXGRbbgUgpL3UByGFyhF
         sF+7VG+qz0YwPBGfxlPUsfEdef1x9w2HIZ28rZ1xnnwJBDNnbpfQHagOS505HJXkOgpY
         e6Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=aZ8/ATcEtBxrOhxFI3DnUHpmtZmlGKuTXdU3asNNn8w=;
        b=tNC47DtgBFR3erB4pSMxqmga2fvRwKeB4pJVuzB6D3WZoNktIYh3iHRX9yXQRsymhU
         cLcZeb9XF3jPwbvAbb2iImcs/SatCGlOE6HrvEtuXRUW3YLW0FqNmIhePd8ebQpZRprv
         QCI9nzUA1yzKj4jalV91/Wx1wmcGVkyFVvGrj/HBwGzhQU0Qp52EeXzdt845n9NHiBqP
         4kNgCy4D1p9atvAu0JUVgQRcEpC99LS4vwzv2Wlc/6bKSCeiarD7pCze5Aejik01nXET
         eNlSN0C5XckTFpPPYQXYJuKB9eSPEn7hp8ZxkgHLXnCOzbk6m0HyvFhkPEpdN/D3SDnP
         gYWA==
X-Gm-Message-State: AOAM531jSZkNVYC9Fg/xPDBpEGyDMO0Smh84PPk9Z4H0zvI7d3nZSX3+
        Kc2Gb6eq/Cf6LnrmOOJSO50=
X-Google-Smtp-Source: ABdhPJwtsdi9RH9ocs/zeT46k9R2q+45N9FPzGFW1uyH03sS0t9rcny5FYDsSSqAqN9M6mZkxoo+hg==
X-Received: by 2002:aa7:8f3a:0:b029:2e9:c63a:312e with SMTP id y26-20020aa78f3a0000b02902e9c63a312emr19696132pfr.73.1623633242107;
        Sun, 13 Jun 2021 18:14:02 -0700 (PDT)
Received: from localhost (60-242-147-73.tpgi.com.au. [60.242.147.73])
        by smtp.gmail.com with ESMTPSA id n11sm10556138pfu.29.2021.06.13.18.14.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Jun 2021 18:14:01 -0700 (PDT)
Date:   Mon, 14 Jun 2021 11:13:56 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: + kvm-s390-fix-for-hugepage-vmalloc.patch added to -mm tree
To:     akpm@linux-foundation.org, borntraeger@de.ibm.com,
        catalin.marinas@arm.com, david@redhat.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, mingo@redhat.com,
        mm-commits@vger.kernel.org, rientjes@google.com,
        tglx@linutronix.de, urezki@gmail.com
References: <20210608210623.oyQ1Gh4H3%akpm@linux-foundation.org>
        <1623631892.c5eaco2ojh.astroid@bobo.none>
In-Reply-To: <1623631892.c5eaco2ojh.astroid@bobo.none>
MIME-Version: 1.0
Message-Id: <1623632435.4kfx35vz3e.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Excerpts from Nicholas Piggin's message of June 14, 2021 10:58 am:
> Excerpts from akpm@linux-foundation.org's message of June 9, 2021 7:06 am=
:
>>=20
>> The patch titled
>>      Subject: KVM: s390: fix for hugepage vmalloc
>> has been added to the -mm tree.  Its filename is
>>      kvm-s390-fix-for-hugepage-vmalloc.patch
>>=20
>> This patch should soon appear at
>>     https://ozlabs.org/~akpm/mmots/broken-out/kvm-s390-fix-for-hugepage-=
vmalloc.patch
>> and later at
>>     https://ozlabs.org/~akpm/mmotm/broken-out/kvm-s390-fix-for-hugepage-=
vmalloc.patch
>>=20
>> Before you just go and hit "reply", please:
>>    a) Consider who else should be cc'ed
>>    b) Prefer to cc a suitable mailing list as well
>>    c) Ideally: find the original patch on the mailing list and do a
>>       reply-to-all to that, adding suitable additional cc's
>>=20
>> *** Remember to use Documentation/process/submit-checklist.rst when test=
ing your code ***
>>=20
>> The -mm tree is included into linux-next and is updated
>> there every 3-4 working days
>>=20
>> ------------------------------------------------------
>> From: Claudio Imbrenda <imbrenda@linux.ibm.com>
>> Subject: KVM: s390: fix for hugepage vmalloc
>>=20
>> The Create Secure Configuration Ultravisor Call does not support using
>> large pages for the virtual memory area.  This is a hardware limitation.
>>=20
>> This patch replaces the vzalloc call with a longer but equivalent
>> __vmalloc_node_range call, also setting the VM_NO_HUGE_VMAP flag, to
>> guarantee that this allocation will not be performed with large pages.
>>=20
>> Link: https://lkml.kernel.org/r/20210608180618.477766-3-imbrenda@linux.i=
bm.com
>> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
>> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
>> Fixes: 121e6f3258fe393e22c3 ("mm/vmalloc: hugepage vmalloc mappings")
>=20
> Hmm, s390 does not select HAVE_ARCH_HUGE_VMALLOC so it was intended that=20
> "mm/vmalloc: hugepage vmalloc mappings" does not introduce huge vmallocs
> for you.
>=20
> I can't see how this would happen, any clue what I'm missing?

Ah, read into the mailing list thread for the other patch and it seems=20
it only becomes a problem if/when you do enable it, is that right?

From the changelog it appears that this fixes a bug introduced by that
patch. I think instead it should go with the series that enables the
option, and without the fixes tag.

Or if you wanted to get this core API change in first and need a caller=20
in-tree, explain in the changelog that huge vmalloc enablement is coming=20
later and requires it. The enable patch that comes later could reference=20
this commit to help with backporting, if that's what you are concerned
about.

Thanks,
Nick

>=20
> Thanks,
> Nick
>=20
>> Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>	[s390]
>> Cc: Nicholas Piggin <npiggin@gmail.com>
>> Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Ingo Molnar <mingo@redhat.com>
>> Cc: David Rientjes <rientjes@google.com>
>> Cc: Janosch Frank <frankja@linux.ibm.com>
>> Cc: David Hildenbrand <david@redhat.com>
>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>> ---
>>=20
>>  arch/s390/kvm/pv.c |    5 ++++-
>>  1 file changed, 4 insertions(+), 1 deletion(-)
>>=20
>> --- a/arch/s390/kvm/pv.c~kvm-s390-fix-for-hugepage-vmalloc
>> +++ a/arch/s390/kvm/pv.c
>> @@ -140,7 +140,10 @@ static int kvm_s390_pv_alloc_vm(struct k
>>  	/* Allocate variable storage */
>>  	vlen =3D ALIGN(virt * ((npages * PAGE_SIZE) / HPAGE_SIZE), PAGE_SIZE);
>>  	vlen +=3D uv_info.guest_virt_base_stor_len;
>> -	kvm->arch.pv.stor_var =3D vzalloc(vlen);
>> +	kvm->arch.pv.stor_var =3D __vmalloc_node_range(vlen, PAGE_SIZE, VMALLO=
C_START, VMALLOC_END,
>> +						     GFP_KERNEL | __GFP_ZERO, PAGE_KERNEL,
>> +						     VM_NO_HUGE_VMAP, NUMA_NO_NODE,
>> +						     __builtin_return_address(0));
>>  	if (!kvm->arch.pv.stor_var)
>>  		goto out_err;
>>  	return 0;
>> _
>>=20
>> Patches currently in -mm which might be from imbrenda@linux.ibm.com are
>>=20
>> mm-vmalloc-export-__vmalloc_node_range.patch
>> kvm-s390-fix-for-hugepage-vmalloc.patch
>>=20
>>=20
>=20
