Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B7B5C6FD1F
	for <mm-commits@archiver.kernel.org>; Sun, 19 Mar 2023 20:11:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229490AbjCSULB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 19 Mar 2023 16:11:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbjCSUK6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 19 Mar 2023 16:10:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6342213527
        for <mm-commits@vger.kernel.org>; Sun, 19 Mar 2023 13:10:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B6DDC61184
        for <mm-commits@vger.kernel.org>; Sun, 19 Mar 2023 20:10:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12EE0C4339B;
        Sun, 19 Mar 2023 20:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679256655;
        bh=CKvEslXYUzv5frZ3Z9c/jhT0z2N9q1Dilx7kHAMWw2A=;
        h=Date:To:From:Subject:From;
        b=y4EBqiV0G5JCjDjfxjytvcD85XJJUY9PJAZsBt51i77lV4DzetTohncbKUadPrtMG
         iHn7FLM2ovcrTabuTPpV8pJLj8tizFToBOCZk65yU0N0zgFa5wD/IyAIw+dT2WCtUj
         L/Oz6fPDDyhxtNHz3/dFE3c9mF7uWMXJtuo0vaeA=
Date:   Sun, 19 Mar 2023 13:10:54 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, urezki@gmail.com,
        liushixin2@huawei.com, jolsa@kernel.org, david@redhat.com,
        bhe@redhat.com, lstoakes@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-proc-kcore-avoid-bounce-buffer-for-ktext-data.patch added to mm-unstable branch
Message-Id: <20230319201055.12EE0C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc/kcore: avoid bounce buffer for ktext data
has been added to the -mm mm-unstable branch.  Its filename is
     fs-proc-kcore-avoid-bounce-buffer-for-ktext-data.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-proc-kcore-avoid-bounce-buffer-for-ktext-data.patch

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
From: Lorenzo Stoakes <lstoakes@gmail.com>
Subject: fs/proc/kcore: avoid bounce buffer for ktext data
Date: Sun, 19 Mar 2023 07:09:30 +0000

Patch series "convert read_kcore(), vread() to use iterators".

While reviewing Baoquan's recent changes to permit vread() access to
vm_map_ram regions of vmalloc allocations, Willy pointed out [1] that it
would be nice to refactor vread() as a whole, since its only user is
read_kcore() and the existing form of vread() necessitates the use of a
bounce buffer.

This patch series does exactly that, as well as adjusting how we read the
kernel text section to avoid the use of a bounce buffer in this case as
well.

This patch series necessarily changes the locking used in vmalloc, however
tests indicate that this has very little impact on allocation performance
(test results are shown in the relevant patch).

This has been tested against the test case which motivated Baoquan's
changes in the first place [2] which continues to function correctly, as
do the vmalloc self tests.


This patch (of 4):

Commit df04abfd181a ("fs/proc/kcore.c: Add bounce buffer for ktext data")
introduced the use of a bounce buffer to retrieve kernel text data for
/proc/kcore in order to avoid failures arising from hardened user copies
enabled by CONFIG_HARDENED_USERCOPY in check_kernel_text_object().

We can avoid doing this if instead of copy_to_user() we use
_copy_to_user() which bypasses the hardening check.  This is more
efficient than using a bounce buffer and simplifies the code.

We do so as part an overall effort to eliminate bounce buffer usage in the
function with an eye to converting it into an iterator read.

Link: https://lkml.kernel.org/r/cover.1679209395.git.lstoakes@gmail.com
Link: https://lore.kernel.org/all/Y8WfDSRkc%2FOHP3oD@casper.infradead.org/ [1]
Link: https://lore.kernel.org/all/87ilk6gos2.fsf@oracle.com/T/#u [2]
Link: https://lkml.kernel.org/r/2ed992d6604965fd9eea05fed4473ddf54540989.1679209395.git.lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Liu Shixin <liushixin2@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/fs/proc/kcore.c~fs-proc-kcore-avoid-bounce-buffer-for-ktext-data
+++ a/fs/proc/kcore.c
@@ -541,19 +541,12 @@ read_kcore(struct file *file, char __use
 		case KCORE_VMEMMAP:
 		case KCORE_TEXT:
 			/*
-			 * Using bounce buffer to bypass the
-			 * hardened user copy kernel text checks.
+			 * We use _copy_to_user() to bypass usermode hardening
+			 * which would otherwise prevent this operation.
 			 */
-			if (copy_from_kernel_nofault(buf, (void *)start, tsz)) {
-				if (clear_user(buffer, tsz)) {
-					ret = -EFAULT;
-					goto out;
-				}
-			} else {
-				if (copy_to_user(buffer, buf, tsz)) {
-					ret = -EFAULT;
-					goto out;
-				}
+			if (_copy_to_user(buffer, (char *)start, tsz)) {
+				ret = -EFAULT;
+				goto out;
 			}
 			break;
 		default:
_

Patches currently in -mm which might be from lstoakes@gmail.com are

mm-remove-unused-vmf_insert_mixed_prot.patch
mm-remove-vmf_insert_pfn_xxx_prot-for-huge-page-table-entries.patch
drm-ttm-remove-comment-referencing-now-removed-vmf_insert_mixed_prot.patch
mm-prefer-xxx_page-alloc-free-functions-for-order-0-pages.patch
mm-refactor-do_fault_around.patch
mm-pefer-fault_around_pages-to-fault_around_bytes.patch
fs-proc-kcore-avoid-bounce-buffer-for-ktext-data.patch
mm-vmalloc-use-rwsem-mutex-for-vmap_area_lock-and-vmap_block-lock.patch
fs-proc-kcore-convert-read_kcore-to-read_kcore_iter.patch
mm-vmalloc-convert-vread-to-vread_iter.patch

