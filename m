Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0D1AC43217
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:53:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE32E61131
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:53:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347761AbhIBVyq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:54:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:48366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347872AbhIBVyc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:54:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8466E610E6;
        Thu,  2 Sep 2021 21:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619613;
        bh=VUVOBWdSPUH4PA866e+HMUiIASj5sT/ZS2S9K3DHp2w=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=eDecjC+jQue+7jcYjn6bOdiiIsyXMGlo7MfBhObfomYgbahI+sxndJKdSiUDFdX1w
         Ro2mZQezlZk7jBO9iC5NYw8+MVMHuD4x8rUOMt/Owo2No7ne4RypvhbGXSU7DcB9IB
         d+pYUTJaK/vMI2/6KrkDyklcgb3CgCZ7a68wXX1I=
Date:   Thu, 02 Sep 2021 14:53:33 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com,
        imbrenda@linux.ibm.com, jack@suse.cz, jhubbard@nvidia.com,
        kirill.shutemov@linux.intel.com, linmiaohe@huawei.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 068/212] mm: gup: remove set but unused local
 variable major
Message-ID: <20210902215333.qxqbtUl1Q%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
