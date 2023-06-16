Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA2F3EB64DB
	for <mm-commits@archiver.kernel.org>; Fri, 16 Jun 2023 20:49:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233002AbjFPUt3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Jun 2023 16:49:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbjFPUt1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Jun 2023 16:49:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D85033AA4
        for <mm-commits@vger.kernel.org>; Fri, 16 Jun 2023 13:49:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6B63362CD3
        for <mm-commits@vger.kernel.org>; Fri, 16 Jun 2023 20:49:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5459C433C0;
        Fri, 16 Jun 2023 20:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686948565;
        bh=2tGauCRM1LuWfsXTgas2qaAuc3ZbeOx2W8jWZ8Hj/oQ=;
        h=Date:To:From:Subject:From;
        b=k7TWorivi33loHyOv7bUWKae1XP0viHoBDYYDKUiZp/yJekig+6M5JNeQ/AbDEJdO
         YNSpuf2dXvtp5iGNX13H7zFTt0gFHJdHdyDTV2fqbNBSVkJQSPLXaRUwwYAiIZEo7T
         cvMV3WH39vSUSb6EkqrIMW0VUKgPYHgdeTYzqlhE=
Date:   Fri, 16 Jun 2023 13:49:25 -0700
To:     mm-commits@vger.kernel.org, yujie.liu@intel.com,
        peterz@infradead.org, peterx@redhat.com, odion@efficios.com,
        michael.christie@oracle.com, jhubbard@nvidia.com, jgg@nvidia.com,
        feng.tang@intel.com, aaron.lu@intel.com,
        mathieu.desnoyers@efficios.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-move-mm_count-into-its-own-cache-line.patch added to mm-unstable branch
Message-Id: <20230616204925.B5459C433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: move mm_count into its own cache line
has been added to the -mm mm-unstable branch.  Its filename is
     mm-move-mm_count-into-its-own-cache-line.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-move-mm_count-into-its-own-cache-line.patch

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
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: mm: move mm_count into its own cache line
Date: Mon, 15 May 2023 10:35:36 -0400

The mm_struct mm_count field is frequently updated by mmgrab/mmdrop
performed by context switch.  This causes false-sharing for surrounding
mm_struct fields which are read-mostly.

This has been observed on a 2sockets/112core/224cpu Intel Sapphire Rapids
server running hackbench, and by the kernel test robot will-it-scale
testcase.

Move the mm_count field into its own cache line to prevent false-sharing
with other mm_struct fields.

Move mm_count to the first field of mm_struct to minimize the amount of
padding required: rather than adding padding before and after the mm_count
field, padding is only added after mm_count.

Note that I noticed this odd comment in mm_struct:

commit 2e3025434a6b ("mm: relocate 'write_protect_seq' in struct mm_struct")

                /*
                 * With some kernel config, the current mmap_lock's offset
                 * inside 'mm_struct' is at 0x120, which is very optimal, as
                 * its two hot fields 'count' and 'owner' sit in 2 different
                 * cachelines,  and when mmap_lock is highly contended, both
                 * of the 2 fields will be accessed frequently, current layout
                 * will help to reduce cache bouncing.
                 *
                 * So please be careful with adding new fields before
                 * mmap_lock, which can easily push the 2 fields into one
                 * cacheline.
                 */
                struct rw_semaphore mmap_lock;

This comment is rather odd for a few reasons:

- It requires addition/removal of mm_struct fields to carefully consider
  field alignment of _other_ fields,
- It expresses the wish to keep an "optimal" alignment for a specific
  kernel config.

I suspect that the author of this comment may want to revisit this topic
and perhaps introduce a split-struct approach for struct rw_semaphore,
if the need is to place various fields of this structure in different
cache lines.

Link: https://lkml.kernel.org/r/20230515143536.114960-1-mathieu.desnoyers@efficios.com
Fixes: 223baf9d17f2 ("sched: Fix performance regression introduced by mm_cid")
Fixes: af7f588d8f73 ("sched: Introduce per-memory-map concurrency ID")
Link: https://lore.kernel.org/lkml/7a0c1db1-103d-d518-ed96-1584a28fbf32@efficios.com
Reported-by: kernel test robot <yujie.liu@intel.com>
Link: https://lore.kernel.org/oe-lkp/202305151017.27581d75-yujie.liu@intel.com
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Reviewed-by: Aaron Lu <aaron.lu@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Olivier Dion <odion@efficios.com>
Cc: <michael.christie@oracle.com>
Cc: Feng Tang <feng.tang@intel.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |   23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

--- a/include/linux/mm_types.h~mm-move-mm_count-into-its-own-cache-line
+++ a/include/linux/mm_types.h
@@ -583,6 +583,21 @@ struct mm_cid {
 struct kioctx_table;
 struct mm_struct {
 	struct {
+		/*
+		 * Fields which are often written to are placed in a separate
+		 * cache line.
+		 */
+		struct {
+			/**
+			 * @mm_count: The number of references to &struct
+			 * mm_struct (@mm_users count as 1).
+			 *
+			 * Use mmgrab()/mmdrop() to modify. When this drops to
+			 * 0, the &struct mm_struct is freed.
+			 */
+			atomic_t mm_count;
+		} ____cacheline_aligned_in_smp;
+
 		struct maple_tree mm_mt;
 #ifdef CONFIG_MMU
 		unsigned long (*get_unmapped_area) (struct file *filp,
@@ -620,14 +635,6 @@ struct mm_struct {
 		 */
 		atomic_t mm_users;
 
-		/**
-		 * @mm_count: The number of references to &struct mm_struct
-		 * (@mm_users count as 1).
-		 *
-		 * Use mmgrab()/mmdrop() to modify. When this drops to 0, the
-		 * &struct mm_struct is freed.
-		 */
-		atomic_t mm_count;
 #ifdef CONFIG_SCHED_MM_CID
 		/**
 		 * @pcpu_cid: Per-cpu current cid.
_

Patches currently in -mm which might be from mathieu.desnoyers@efficios.com are

mm-move-mm_count-into-its-own-cache-line.patch

