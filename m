Return-Path: <SRS0=pZAw=EM=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F8D5C2D0A3
	for <mm-commits@archiver.kernel.org>; Fri,  6 Nov 2020 22:17:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 19F71206F9
	for <mm-commits@archiver.kernel.org>; Fri,  6 Nov 2020 22:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604701021;
	bh=ZXswNsuRNyVZBnc9ksjDeTql3h1sBpEEU+RYRuzZtXQ=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=wRCij4qYPDm/jQrIilXJ9JO4D70ewbtAis1kPTHZFfKEMQK6wku1Wzl7eom2BW/L/
	 wzeV7PlnEOQnALcN579IGUSkV47HEpIlvOpVIS4IzapWu+SgchpcGy4LQiCTZMA4Y4
	 9Ino9pPPIirZEQSdhDlUir8e5NfSOkYeivnwx38g=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728131AbgKFWRA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 Nov 2020 17:17:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:40338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728520AbgKFWRA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 6 Nov 2020 17:17:00 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E272206C1;
        Fri,  6 Nov 2020 22:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604701019;
        bh=ZXswNsuRNyVZBnc9ksjDeTql3h1sBpEEU+RYRuzZtXQ=;
        h=Date:From:To:Subject:From;
        b=HuJpU/qjNpD2F2mv3Rv1D5q4EWWvvqZSQdcOOLGgo3G9t5U2C/lXCtJoIWGOvpe34
         cwTUKlZq4Ys8Zt28r+rTu+KF8nY8Xnn6F4vKWqvWTL1EJHfPSn/svTTAkzAGCZ/jyg
         3W76eZezE0OLqrxYWLNEvu6NEBzfbpWvKyp0BTC4=
Date:   Fri, 06 Nov 2020 14:16:58 -0800
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, pbonzini@redhat.com,
        shakeelb@google.com
Subject:  + mm-kvm-account-kvm_vcpu_mmap-to-kmemcg.patch added to
 -mm tree
Message-ID: <20201106221658.aHqNx4vDs%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, kvm: account kvm_vcpu_mmap to kmemcg
has been added to the -mm tree.  Its filename is
     mm-kvm-account-kvm_vcpu_mmap-to-kmemcg.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-kvm-account-kvm_vcpu_mmap-to-kmemcg.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-kvm-account-kvm_vcpu_mmap-to-kmemcg.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/kvm/kvm-s390.c  |    2 +-
 arch/x86/kvm/x86.c        |    2 +-
 virt/kvm/coalesced_mmio.c |    2 +-
 virt/kvm/kvm_main.c       |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

--- a/arch/s390/kvm/kvm-s390.c~mm-kvm-account-kvm_vcpu_mmap-to-kmemcg
+++ a/arch/s390/kvm/kvm-s390.c
@@ -3243,7 +3243,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu
 	int rc;
 
 	BUILD_BUG_ON(sizeof(struct sie_page) != 4096);
-	sie_page = (struct sie_page *) get_zeroed_page(GFP_KERNEL);
+	sie_page = (struct sie_page *) get_zeroed_page(GFP_KERNEL_ACCOUNT);
 	if (!sie_page)
 		return -ENOMEM;
 
--- a/arch/x86/kvm/x86.c~mm-kvm-account-kvm_vcpu_mmap-to-kmemcg
+++ a/arch/x86/kvm/x86.c
@@ -9829,7 +9829,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu
 
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

Patches currently in -mm which might be from shakeelb@google.com are

mm-rmap-always-do-ttu_ignore_access.patch
mm-kvm-account-kvm_vcpu_mmap-to-kmemcg.patch

