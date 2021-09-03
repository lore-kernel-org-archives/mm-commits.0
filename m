Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0FC3C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:56:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C6B0260184
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:56:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350172AbhICU5e (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 16:57:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:56302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350048AbhICU5T (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 16:57:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 956DB60C3E;
        Fri,  3 Sep 2021 20:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702577;
        bh=8J0jF1xwcBZCK4RbLWnkygtYAcx18ypUcEzQ0hukCbU=;
        h=Date:From:To:Subject:From;
        b=rO6QtYg0x2HUJ8LTZsHbHgut9LyCszNWRde1Q5kQdh2CgKL4V3EKv2W2U3JdiaIRZ
         Wd+i3kcwX8jlo1sLv4gKtK6MhTe/SSN3X4N0M5uewKPTplR9M824lPceGwVv3H54ba
         DetTPMMbtr+yxb5Zf3LkCZSPV9jT35v+jGbDASng=
Date:   Fri, 03 Sep 2021 13:56:17 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, imbrenda@linux.ibm.com, jack@suse.cz,
        jhubbard@nvidia.com, kirill.shutemov@linux.intel.com,
        linmiaohe@huawei.com, mm-commits@vger.kernel.org
Subject:  [merged]
 mm-gup-remove-set-but-unused-local-variable-major.patch removed from -mm
 tree
Message-ID: <20210903205617.ls50Inskv%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: gup: remove set but unused local variable major
has been removed from the -mm tree.  Its filename was
     mm-gup-remove-set-but-unused-local-variable-major.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm: gup: remove set but unused local variable major

Patch series "Cleanups and fixup for gup".

This series contains cleanups to remove unneeded variable, useless BUG_ON
and use helper to improve readability.  Also we fix a potential pgmap
refcnt leak.  More details can be found in the respective changelogs.


This patch (of 5):

Since commit a2beb5f1efed ("mm: clean up the last pieces of page fault
accountings"), the local variable major is unused.  Remove it.

Link: https://lkml.kernel.org/r/20210807093620.21347-1-linmiaohe@huawei.com
Link: https://lkml.kernel.org/r/20210807093620.21347-2-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/gup.c~mm-gup-remove-set-but-unused-local-variable-major
+++ a/mm/gup.c
@@ -1276,7 +1276,7 @@ int fixup_user_fault(struct mm_struct *m
 		     bool *unlocked)
 {
 	struct vm_area_struct *vma;
-	vm_fault_t ret, major = 0;
+	vm_fault_t ret;
 
 	address = untagged_addr(address);
 
@@ -1296,7 +1296,6 @@ retry:
 		return -EINTR;
 
 	ret = handle_mm_fault(vma, address, fault_flags, NULL);
-	major |= ret & VM_FAULT_MAJOR;
 	if (ret & VM_FAULT_ERROR) {
 		int err = vm_fault_to_errno(ret, 0);
 
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-page_allocc-avoid-accessing-uninitialized-pcp-page-migratetype.patch
mm-memory_hotplug-use-helper-zone_is_zone_device-to-simplify-the-code.patch
mm-memory_hotplug-make-hwpoisoned-dirty-swapcache-pages-unmovable.patch
mm-zsmallocc-close-race-window-between-zs_pool_dec_isolated-and-zs_unregister_migration.patch
mm-zsmallocc-combine-two-atomic-ops-in-zs_pool_dec_isolated.patch

