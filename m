Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6273BC4708E
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:06:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230241AbiLAAGr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:06:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230312AbiLAAEi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:04:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BB8390776
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:02:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 47124B81D86
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:02:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E12D7C433D6;
        Thu,  1 Dec 2022 00:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852928;
        bh=uDS6w5CiYvz9XEzBjM4rdYo74iAvpINGsj/fPxlHveM=;
        h=Date:To:From:Subject:From;
        b=Bpeu4PCNNpgqcfOvifMnnEAXNk0Estu89/0lByDmOTPPRgeJmPAlHxRUdzEB7nuHq
         +DzyklYrEYWnbScniYrrXy97NvXFGQgmrm74Sfhle4yzhhYqX8N8Q/C0nHGuyA5Pzp
         YNsGGxuQojNnuPZBHFLcYHT7LYokysm6D8NtFCHM=
Date:   Wed, 30 Nov 2022 16:02:07 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-early-fault_flag_write-consistency-checks.patch removed from -mm tree
Message-Id: <20221201000207.E12D7C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: add early FAULT_FLAG_WRITE consistency checks
has been removed from the -mm tree.  Its filename was
     mm-add-early-fault_flag_write-consistency-checks.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm: add early FAULT_FLAG_WRITE consistency checks
Date: Wed, 16 Nov 2022 11:26:44 +0100

Let's catch abuse of FAULT_FLAG_WRITE early, such that we don't have to
care in all other handlers and might get "surprises" if we forget to do
so.

Write faults without VM_MAYWRITE don't make any sense, and our
maybe_mkwrite() logic could have hidden such abuse for now.

Write faults without VM_WRITE on something that is not a COW mapping is
similarly broken, and e.g., do_wp_page() could end up placing an
anonymous page into a shared mapping, which would be bad.

This is a preparation for reliable R/O long-term pinning of pages in
private mappings, whereby we want to make sure that we will never break
COW in a read-only private mapping.

Link: https://lkml.kernel.org/r/20221116102659.70287-6-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/mm/memory.c~mm-add-early-fault_flag_write-consistency-checks
+++ a/mm/memory.c
@@ -5170,6 +5170,14 @@ static vm_fault_t sanitize_fault_flags(s
 		 */
 		if (!is_cow_mapping(vma->vm_flags))
 			*flags &= ~FAULT_FLAG_UNSHARE;
+	} else if (*flags & FAULT_FLAG_WRITE) {
+		/* Write faults on read-only mappings are impossible ... */
+		if (WARN_ON_ONCE(!(vma->vm_flags & VM_MAYWRITE)))
+			return VM_FAULT_SIGSEGV;
+		/* ... and FOLL_FORCE only applies to COW mappings. */
+		if (WARN_ON_ONCE(!(vma->vm_flags & VM_WRITE) &&
+				 !is_cow_mapping(vma->vm_flags)))
+			return VM_FAULT_SIGSEGV;
 	}
 	return 0;
 }
_

Patches currently in -mm which might be from david@redhat.com are

selftests-vm-add-ksm-unmerge-tests.patch
mm-pagewalk-dont-trigger-test_walk-in-walk_page_vma.patch
selftests-vm-add-test-to-measure-madv_unmergeable-performance.patch
mm-ksm-simplify-break_ksm-to-not-rely-on-vm_fault_write.patch
mm-remove-vm_fault_write.patch
mm-ksm-fix-ksm-cow-breaking-with-userfaultfd-wp-via-fault_flag_unshare.patch
mm-pagewalk-add-walk_page_range_vma.patch
mm-ksm-convert-break_ksm-to-use-walk_page_range_vma.patch
mm-gup-remove-foll_migration.patch

