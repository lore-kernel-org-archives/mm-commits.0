Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2252AC4361B
	for <mm-commits@archiver.kernel.org>; Fri, 18 Dec 2020 22:02:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D967D23BCA
	for <mm-commits@archiver.kernel.org>; Fri, 18 Dec 2020 22:02:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725925AbgLRWCT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 18 Dec 2020 17:02:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:35686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725898AbgLRWCT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 18 Dec 2020 17:02:19 -0500
Date:   Fri, 18 Dec 2020 14:01:38 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608328898;
        bh=dT9nSEPUIKhNbItOB3oWwaqWFWWxw2n6x52oi/m/ECQ=;
        h=From:To:Subject:In-Reply-To:From;
        b=L48jDJ2F2RcMxh6G6WXMh3cOHyQJw8P/gRY7bA8AlPwnvU0ZFJhCZSMXfhHBRaEmT
         X0YQKg4tHib9+RDF7iGFEm2M6Fqdo459jg9RSw3nYXPlx9pCYCWUvww7rF5MJRvwle
         MJFd+znO/RJEuicHdJEfTqSCKWUjm6e6774JDbDc=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, guro@fb.com, hannes@cmpxchg.org,
        linux-mm@kvack.org, mhocko@suse.com, mm-commits@vger.kernel.org,
        pbonzini@redhat.com, shakeelb@google.com,
        torvalds@linux-foundation.org
Subject:  [patch 04/78] mm, kvm: account kvm_vcpu_mmap to kmemcg
Message-ID: <20201218220138.ZaFbo4Y29%akpm@linux-foundation.org>
In-Reply-To: <20201218140046.497484741326828e5b5d46ec@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Shakeel Butt <shakeelb@google.com>
Subject: mm, kvm: account kvm_vcpu_mmap to kmemcg

A VCPU of a VM can allocate couple of pages which can be mmap'ed by the
user space application. At the moment this memory is not charged to the
memcg of the VMM. On a large machine running large number of VMs or
small number of VMs having large number of VCPUs, this unaccounted
memory can be very significant. So, charge this memory to the memcg of
the VMM. Please note that lifetime of these allocations corresponds to
the lifetime of the VMM.

Link: https://lkml.kernel.org/r/20201106202923.2087414-1-shakeelb@google.com
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Roman Gushchin <guro@fb.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kvm/x86.c        |    2 +-
 virt/kvm/coalesced_mmio.c |    2 +-
 virt/kvm/kvm_main.c       |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

--- a/arch/x86/kvm/x86.c~mm-kvm-account-kvm_vcpu_mmap-to-kmemcg
+++ a/arch/x86/kvm/x86.c
@@ -9869,7 +9869,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu
 
 	r = -ENOMEM;
 
-	page = alloc_page(GFP_KERNEL | __GFP_ZERO);
+	page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
 	if (!page)
 		goto fail_free_lapic;
 	vcpu->arch.pio_data = page_address(page);
--- a/virt/kvm/coalesced_mmio.c~mm-kvm-account-kvm_vcpu_mmap-to-kmemcg
+++ a/virt/kvm/coalesced_mmio.c
@@ -111,7 +111,7 @@ int kvm_coalesced_mmio_init(struct kvm *
 {
 	struct page *page;
 
-	page = alloc_page(GFP_KERNEL | __GFP_ZERO);
+	page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
 	if (!page)
 		return -ENOMEM;
 
--- a/virt/kvm/kvm_main.c~mm-kvm-account-kvm_vcpu_mmap-to-kmemcg
+++ a/virt/kvm/kvm_main.c
@@ -3116,7 +3116,7 @@ static int kvm_vm_ioctl_create_vcpu(stru
 	}
 
 	BUILD_BUG_ON(sizeof(struct kvm_run) > PAGE_SIZE);
-	page = alloc_page(GFP_KERNEL | __GFP_ZERO);
+	page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
 	if (!page) {
 		r = -ENOMEM;
 		goto vcpu_free;
_
