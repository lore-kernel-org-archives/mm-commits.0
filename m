Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 308DCC49EA7
	for <mm-commits@archiver.kernel.org>; Fri, 25 Jun 2021 01:39:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1CBEB613BD
	for <mm-commits@archiver.kernel.org>; Fri, 25 Jun 2021 01:39:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233030AbhFYBmA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Jun 2021 21:42:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:60864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232973AbhFYBl7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 24 Jun 2021 21:41:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A52AC60232;
        Fri, 25 Jun 2021 01:39:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624585180;
        bh=jXQexAp7uCJqp7UJssXaInCjqk7jF5DIsxgf31ksxs8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=hEyspiQfjaEySMWq2p/90vtL6U+KXDfwQ85OWBOqeaFRzTKAFdys1jkDZqsC7Bo70
         bqOUu2wZOfePLhVL2jON9y8XkEtNw5KUjoNd77DcKw1tLBlJHX/vka/JflB+Z1BpJN
         YX564oTiOVoHAKwsHVK1gw9WTmNBwv5MaVJVIR8k=
Date:   Thu, 24 Jun 2021 18:39:39 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, borntraeger@de.ibm.com,
        catalin.marinas@arm.com, david@redhat.com, frankja@linux.ibm.com,
        hch@infradead.org, imbrenda@linux.ibm.com, linux-mm@kvack.org,
        mingo@redhat.com, mm-commits@vger.kernel.org, npiggin@gmail.com,
        rientjes@google.com, tglx@linutronix.de,
        torvalds@linux-foundation.org, urezki@gmail.com
Subject:  [patch 13/24] KVM: s390: prepare for hugepage vmalloc
Message-ID: <20210625013939.606vJComT%akpm@linux-foundation.org>
In-Reply-To: <20210624183838.ac3161ca4a43989665ac8b2f@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
