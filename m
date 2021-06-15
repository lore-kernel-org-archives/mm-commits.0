Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC15BC2B9F4
	for <mm-commits@archiver.kernel.org>; Tue, 15 Jun 2021 00:14:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9648161378
	for <mm-commits@archiver.kernel.org>; Tue, 15 Jun 2021 00:14:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbhFOAQh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Jun 2021 20:16:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:40496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229536AbhFOAQf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Jun 2021 20:16:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D0018611CE;
        Tue, 15 Jun 2021 00:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623716060;
        bh=JfEBDd7ywc56f9CN65TZTLsPBGL9ZhrwejRYClhYO/g=;
        h=Date:From:To:Subject:From;
        b=T6HaI/E7hZwQchbLgerQO3grNjJV4/SIj8rHcALLS/2aZJNl8QXsJ0iteCBmHa1ia
         T5KIlcH0gB5N3z0pcEYVI6swSzJXdvsRJPzpv2ARI4scx1x5dVgbfYUUcSugbnugOU
         4w+P5KVOEMDfagXSW1VamfHnCK32XTiIXfID9Fac=
Date:   Mon, 14 Jun 2021 17:14:19 -0700
From:   akpm@linux-foundation.org
To:     borntraeger@de.ibm.com, catalin.marinas@arm.com, david@redhat.com,
        frankja@linux.ibm.com, hch@infradead.org, imbrenda@linux.ibm.com,
        mingo@redhat.com, mm-commits@vger.kernel.org, npiggin@gmail.com,
        rientjes@google.com, tglx@linutronix.de, urezki@gmail.com
Subject:  + kvm-s390-prepare-for-hugepage-vmalloc.patch added to
 -mm tree
Message-ID: <20210615001419.59pQKT5nq%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: KVM: s390: prepare for hugepage vmalloc
has been added to the -mm tree.  Its filename is
     kvm-s390-prepare-for-hugepage-vmalloc.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kvm-s390-prepare-for-hugepage-vmalloc.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kvm-s390-prepare-for-hugepage-vmalloc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: KVM: s390: prepare for hugepage vmalloc

The Create Secure Configuration Ultravisor Call does not support using
large pages for the virtual memory area.  This is a hardware limitation.

This patch replaces the vzalloc call with an almost equivalent call to the
newly introduced vmalloc_no_huge function, which guarantees that only
small pages will be used for the backing.

The new call will not clear the allocated memory, but that has never been
an actual requirement.

Link: https://lkml.kernel.org/r/20210614132357.10202-3-imbrenda@linux.ibm.com
Fixes: 121e6f3258fe3 ("mm/vmalloc: hugepage vmalloc mappings") 
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
Acked-by: Nicholas Piggin <npiggin@gmail.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/kvm/pv.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/arch/s390/kvm/pv.c~kvm-s390-prepare-for-hugepage-vmalloc
+++ a/arch/s390/kvm/pv.c
@@ -140,7 +140,12 @@ static int kvm_s390_pv_alloc_vm(struct k
 	/* Allocate variable storage */
 	vlen = ALIGN(virt * ((npages * PAGE_SIZE) / HPAGE_SIZE), PAGE_SIZE);
 	vlen += uv_info.guest_virt_base_stor_len;
-	kvm->arch.pv.stor_var = vzalloc(vlen);
+	/*
+	 * The Create Secure Configuration Ultravisor Call does not support
+	 * using large pages for the virtual memory area.
+	 * This is a hardware limitation.
+	 */
+	kvm->arch.pv.stor_var = vmalloc_no_huge(vlen);
 	if (!kvm->arch.pv.stor_var)
 		goto out_err;
 	return 0;
_

Patches currently in -mm which might be from imbrenda@linux.ibm.com are

mm-vmalloc-add-vmalloc_no_huge.patch
kvm-s390-prepare-for-hugepage-vmalloc.patch

