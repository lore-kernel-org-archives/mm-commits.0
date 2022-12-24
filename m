Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BEB0C4332F
	for <mm-commits@archiver.kernel.org>; Sat, 24 Dec 2022 22:15:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbiLXWPH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 24 Dec 2022 17:15:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbiLXWPH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 24 Dec 2022 17:15:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0547A8FC0
        for <mm-commits@vger.kernel.org>; Sat, 24 Dec 2022 14:15:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7BDAE60B0C
        for <mm-commits@vger.kernel.org>; Sat, 24 Dec 2022 22:15:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C62BEC433D2;
        Sat, 24 Dec 2022 22:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671920104;
        bh=jVeGQEJyf5jBqB5MumlfqFhPI7hmPvsA5RwddJ4Rx7E=;
        h=Date:To:From:Subject:From;
        b=MfJMDZsh1SGzAxAT2mBQTBYFB/+6IQYIHuSSVrUVCsRnRneA6QO9OwgBTipF8EZrR
         iDJGjDeumVfMCfoovjyUZExB368/UpJRh9K8fA9jTg9J0faAWKOGKgQ94iO4xqvYp3
         AyZZUl1d/6tPS61Xi4UE8y9ILSRVs/gNDxZKekT0=
Date:   Sat, 24 Dec 2022 14:15:01 -0800
To:     mm-commits@vger.kernel.org, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mprotect-drop-pgprot_t-parameter-from-change_protection-fix.patch added to mm-unstable branch
Message-Id: <20221224221504.C62BEC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fixup: mm/mprotect: drop pgprot_t parameter from change_protection()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mprotect-drop-pgprot_t-parameter-from-change_protection-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mprotect-drop-pgprot_t-parameter-from-change_protection-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: fixup: mm/mprotect: drop pgprot_t parameter from change_protection()
Date: Sat, 24 Dec 2022 15:01:18 +0100

PAGE_NONE might not be defined without CONFIG_NUMA_BALANCING

Link: https://lkml.kernel.org/r/5084ff1c-ebb3-f918-6a60-bacabf550a88@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/mprotect.c~mm-mprotect-drop-pgprot_t-parameter-from-change_protection-fix
+++ a/mm/mprotect.c
@@ -514,6 +514,7 @@ unsigned long change_protection(struct m
 
 	BUG_ON((cp_flags & MM_CP_UFFD_WP_ALL) == MM_CP_UFFD_WP_ALL);
 
+#ifdef CONFIG_NUMA_BALANCING
 	/*
 	 * Ordinary protection updates (mprotect, uffd-wp, softdirty tracking)
 	 * are expected to reflect their requirements via VMA flags such that
@@ -521,6 +522,9 @@ unsigned long change_protection(struct m
 	 */
 	if (cp_flags & MM_CP_PROT_NUMA)
 		newprot = PAGE_NONE;
+#else
+	WARN_ON_ONCE(cp_flags & MM_CP_PROT_NUMA);
+#endif
 
 	if (is_vm_hugetlb_page(vma))
 		pages = hugetlb_change_protection(vma, start, end, newprot,
_

Patches currently in -mm which might be from david@redhat.com are

mm-hugetlb-fix-pte-marker-handling-in-hugetlb_change_protection.patch
mm-hugetlb-fix-uffd-wp-handling-for-migration-entries-in-hugetlb_change_protection.patch
mm-userfaultfd-enable-writenotify-while-userfaultfd-wp-is-enabled-for-a-vma.patch
mm-userfaultfd-rely-on-vma-vm_page_prot-in-uffd_wp_range.patch
mm-mprotect-drop-pgprot_t-parameter-from-change_protection.patch
mm-mprotect-drop-pgprot_t-parameter-from-change_protection-fix.patch

