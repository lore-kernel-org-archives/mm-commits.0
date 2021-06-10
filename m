Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E663BC48BDF
	for <mm-commits@archiver.kernel.org>; Thu, 10 Jun 2021 20:49:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD9EE61404
	for <mm-commits@archiver.kernel.org>; Thu, 10 Jun 2021 20:49:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230001AbhFJUv3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 10 Jun 2021 16:51:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:41508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230059AbhFJUv3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 10 Jun 2021 16:51:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AED1D61374;
        Thu, 10 Jun 2021 20:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623358173;
        bh=+FoCyXQF/n177n3wbZzos8ICsyXjiPTZwcyzrN3f+Zk=;
        h=Date:From:To:Subject:From;
        b=oBLMciXh2Jjk9OV5e0QvDlJf1ATwdcvlDiaMJWnMyYRmlg+s6hS1eOh0Dhn54NAeN
         WiD56FgwvWSsbV+NomYioQdv71K0l7nB3jMyuepMOXE8qlAa7zGNefoNH4a8NORs/U
         3rkSZfda42riUKNlbjnHmwMU7KBqbUW1HdAQ+RVI=
Date:   Thu, 10 Jun 2021 13:49:32 -0700
From:   akpm@linux-foundation.org
To:     borntraeger@de.ibm.com, catalin.marinas@arm.com, david@redhat.com,
        frankja@linux.ibm.com, imbrenda@linux.ibm.com, mingo@redhat.com,
        mm-commits@vger.kernel.org, npiggin@gmail.com, rientjes@google.com,
        tglx@linutronix.de, urezki@gmail.com
Subject:  [to-be-updated] kvm-s390-fix-for-hugepage-vmalloc.patch
 removed from -mm tree
Message-ID: <20210610204932.AmqSV7sor%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: KVM: s390: fix for hugepage vmalloc
has been removed from the -mm tree.  Its filename was
     kvm-s390-fix-for-hugepage-vmalloc.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: KVM: s390: fix for hugepage vmalloc

The Create Secure Configuration Ultravisor Call does not support using
large pages for the virtual memory area.  This is a hardware limitation.

This patch replaces the vzalloc call with a longer but equivalent
__vmalloc_node_range call, also setting the VM_NO_HUGE_VMAP flag, to
guarantee that this allocation will not be performed with large pages.

Link: https://lkml.kernel.org/r/20210608180618.477766-3-imbrenda@linux.ibm.com
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Fixes: 121e6f3258fe393e22c3 ("mm/vmalloc: hugepage vmalloc mappings")
Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>	[s390]
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/kvm/pv.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/arch/s390/kvm/pv.c~kvm-s390-fix-for-hugepage-vmalloc
+++ a/arch/s390/kvm/pv.c
@@ -140,7 +140,10 @@ static int kvm_s390_pv_alloc_vm(struct k
 	/* Allocate variable storage */
 	vlen = ALIGN(virt * ((npages * PAGE_SIZE) / HPAGE_SIZE), PAGE_SIZE);
 	vlen += uv_info.guest_virt_base_stor_len;
-	kvm->arch.pv.stor_var = vzalloc(vlen);
+	kvm->arch.pv.stor_var = __vmalloc_node_range(vlen, PAGE_SIZE, VMALLOC_START, VMALLOC_END,
+						     GFP_KERNEL | __GFP_ZERO, PAGE_KERNEL,
+						     VM_NO_HUGE_VMAP, NUMA_NO_NODE,
+						     __builtin_return_address(0));
 	if (!kvm->arch.pv.stor_var)
 		goto out_err;
 	return 0;
_

Patches currently in -mm which might be from imbrenda@linux.ibm.com are


