Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5355C77B6E
	for <mm-commits@archiver.kernel.org>; Thu, 13 Apr 2023 22:06:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbjDMWGH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 13 Apr 2023 18:06:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjDMWGG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Apr 2023 18:06:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E96159C0
        for <mm-commits@vger.kernel.org>; Thu, 13 Apr 2023 15:06:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DC2006164C
        for <mm-commits@vger.kernel.org>; Thu, 13 Apr 2023 22:06:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 145C4C433D2;
        Thu, 13 Apr 2023 22:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681423564;
        bh=iPY07Fvi5c1xUz3IT4PaA2umbJgG6d7F9fCfcBz35A8=;
        h=Date:To:From:Subject:From;
        b=k9AUFm+xJKxc4+0pqvEIjSr/5ixv5JhHkFSKeaY9dBzCZBp9c1iJj6M8HDZq8+wwK
         fcPNgbCgQ6+d1XombpilRODnzjQKfBStaLQiU5pQU30ZHw39l4G8lUqHY8K4WEuhzg
         zwrnZ4m0FWHJ0yWtVMZjMXr8LNj+YggN1QhRKGvk=
Date:   Thu, 13 Apr 2023 15:06:03 -0700
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hwpoison-coredump-support-recovery-from-dump_user_range-checkpatch-fixes.patch added to mm-unstable branch
Message-Id: <20230413220604.145C4C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hwpoison-coredump-support-recovery-from-dump_user_range-checkpatch-fixes
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hwpoison-coredump-support-recovery-from-dump_user_range-checkpatch-fixes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hwpoison-coredump-support-recovery-from-dump_user_range-checkpatch-fixes.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-hwpoison-coredump-support-recovery-from-dump_user_range-checkpatch-fixes
Date: Thu Apr 13 03:05:23 PM PDT 2023

WARNING: 'an user' may be misspelled - perhaps 'a user'?
#33: 
address may not always an user address, so introduce a new copy_mc flag in
                       ^^^^^^^

WARNING: please, no spaces at the start of a line
#133: FILE: lib/iov_iter.c:637:
+       if (iov_iter_is_copy_mc(i))$

WARNING: suspect code indent for conditional statements (7, 15)
#133: FILE: lib/iov_iter.c:637:
+       if (iov_iter_is_copy_mc(i))
+               return (void *)copy_mc_to_kernel(to, from, size);

ERROR: code indent should use tabs where possible
#134: FILE: lib/iov_iter.c:638:
+               return (void *)copy_mc_to_kernel(to, from, size);$

WARNING: please, no spaces at the start of a line
#134: FILE: lib/iov_iter.c:638:
+               return (void *)copy_mc_to_kernel(to, from, size);$

total: 1 errors, 4 warnings, 118 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

NOTE: Whitespace errors detected.
      You may wish to use scripts/cleanpatch or scripts/cleanfile

./patches/mm-hwpoison-coredump-support-recovery-from-dump_user_range.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/iov_iter.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/lib/iov_iter.c~mm-hwpoison-coredump-support-recovery-from-dump_user_range-checkpatch-fixes
+++ a/lib/iov_iter.c
@@ -634,8 +634,8 @@ EXPORT_SYMBOL_GPL(_copy_mc_to_iter);
 static void *memcpy_from_iter(struct iov_iter *i, void *to, const void *from,
 				 size_t size)
 {
-       if (iov_iter_is_copy_mc(i))
-               return (void *)copy_mc_to_kernel(to, from, size);
+	if (iov_iter_is_copy_mc(i))
+		return (void *)copy_mc_to_kernel(to, from, size);
 	return memcpy(to, from, size);
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-khugepaged-fix-kernel-bug-in-hpage_collapse_scan_file-fix.patch
mm-treewide-redefine-max_order-sanely-fix-fix-fix.patch
memcg-do-not-drain-charge-pcp-caches-on-remote-isolated-cpus-fix.patch
vmstat-add-pcp-remote-node-draining-via-cpu_vm_stats_fold-fix.patch
lib-test_vmallocc-add-vm_map_ram-vm_unmap_ram-test-case-fix.patch
mm-hwpoison-coredump-support-recovery-from-dump_user_range-checkpatch-fixes.patch
scripts-gdb-create-linux-vfspy-for-vfs-related-gdb-helpers-fix.patch

