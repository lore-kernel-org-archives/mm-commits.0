Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75FD6EE49B1
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:08:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230320AbjHUUIM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:08:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230325AbjHUUIL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:08:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 640B9136;
        Mon, 21 Aug 2023 13:08:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE8F7649DE;
        Mon, 21 Aug 2023 20:08:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51E6DC433CA;
        Mon, 21 Aug 2023 20:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692648489;
        bh=pv1GDTTLRWiIAOyUOoCjCozQSc41+3ARBtwu03wA7UE=;
        h=Date:To:From:Subject:From;
        b=OH1J2tB3Ovi49KRY82kLeAxrFBs7mfz6oNJL9g3JzLCYX/qvOtYdsPzwwdaeYdOXX
         PBZOP5uWSXS8HRzwkKjDtLTEV7SRxY/6dPIapOCEbuBgLcUPKbeWVoTgBWP7qUtW+U
         7GuWQEKPL9dsrIoo9EjLz9/ll339mG5Vt6rokIMY=
Date:   Mon, 21 Aug 2023 13:08:08 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        raghavendra.kt@amd.com, jhubbard@nvidia.com, jgg@nvidia.com,
        david@redhat.com, ayush.jain3@amd.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] selftests-mm-foll_longterm-need-to-be-updated-to-0x100.patch removed from -mm tree
Message-Id: <20230821200809.51E6DC433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/mm: FOLL_LONGTERM need to be updated to 0x100
has been removed from the -mm tree.  Its filename was
     selftests-mm-foll_longterm-need-to-be-updated-to-0x100.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ayush Jain <ayush.jain3@amd.com>
Subject: selftests/mm: FOLL_LONGTERM need to be updated to 0x100
Date: Tue, 8 Aug 2023 07:43:47 -0500

After commit 2c2241081f7d ("mm/gup: move private gup FOLL_ flags to
internal.h") FOLL_LONGTERM flag value got updated from 0x10000 to 0x100 at
include/linux/mm_types.h.

As hmm.hmm_device_private.hmm_gup_test uses FOLL_LONGTERM Updating same
here as well.

Before this change test goes in an infinite assert loop in
hmm.hmm_device_private.hmm_gup_test
==========================================================
 RUN           hmm.hmm_device_private.hmm_gup_test ...
hmm-tests.c:1962:hmm_gup_test:Expected HMM_DMIRROR_PROT_WRITE..
..(2) == m[2] (34)
hmm-tests.c:157:hmm_gup_test:Expected ret (-1) == 0 (0)
hmm-tests.c:157:hmm_gup_test:Expected ret (-1) == 0 (0)
...
==========================================================

 Call Trace:
 <TASK>
 ? sched_clock+0xd/0x20
 ? __lock_acquire.constprop.0+0x120/0x6c0
 ? ktime_get+0x2c/0xd0
 ? sched_clock+0xd/0x20
 ? local_clock+0x12/0xd0
 ? lock_release+0x26e/0x3b0
 pin_user_pages_fast+0x4c/0x70
 gup_test_ioctl+0x4ff/0xbb0
 ? gup_test_ioctl+0x68c/0xbb0
 __x64_sys_ioctl+0x99/0xd0
 do_syscall_64+0x60/0x90
 ? syscall_exit_to_user_mode+0x2a/0x50
 ? do_syscall_64+0x6d/0x90
 ? syscall_exit_to_user_mode+0x2a/0x50
 ? do_syscall_64+0x6d/0x90
 ? irqentry_exit_to_user_mode+0xd/0x20
 ? irqentry_exit+0x3f/0x50
 ? exc_page_fault+0x96/0x200
 entry_SYSCALL_64_after_hwframe+0x72/0xdc
 RIP: 0033:0x7f6aaa31aaff

After this change test is able to pass successfully.

Link: https://lkml.kernel.org/r/20230808124347.79163-1-ayush.jain3@amd.com
Fixes: 2c2241081f7d ("mm/gup: move private gup FOLL_ flags to internal.h")
Signed-off-by: Ayush Jain <ayush.jain3@amd.com>
Reviewed-by: Raghavendra K T <raghavendra.kt@amd.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/hmm-tests.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/hmm-tests.c~selftests-mm-foll_longterm-need-to-be-updated-to-0x100
+++ a/tools/testing/selftests/mm/hmm-tests.c
@@ -57,9 +57,14 @@ enum {
 
 #define ALIGN(x, a) (((x) + (a - 1)) & (~((a) - 1)))
 /* Just the flags we need, copied from mm.h: */
+
+#ifndef FOLL_WRITE
 #define FOLL_WRITE	0x01	/* check pte is writable */
-#define FOLL_LONGTERM   0x10000 /* mapping lifetime is indefinite */
+#endif
 
+#ifndef FOLL_LONGTERM
+#define FOLL_LONGTERM   0x100 /* mapping lifetime is indefinite */
+#endif
 FIXTURE(hmm)
 {
 	int		fd;
_

Patches currently in -mm which might be from ayush.jain3@amd.com are

selftests-mm-add-ksm_merge_time-tests.patch

