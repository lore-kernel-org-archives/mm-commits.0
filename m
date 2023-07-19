Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82AB1C0015E
	for <mm-commits@archiver.kernel.org>; Wed, 19 Jul 2023 19:21:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231207AbjGSTVa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Jul 2023 15:21:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231150AbjGSTVV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Jul 2023 15:21:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18AE52102
        for <mm-commits@vger.kernel.org>; Wed, 19 Jul 2023 12:21:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 38A92617F2
        for <mm-commits@vger.kernel.org>; Wed, 19 Jul 2023 19:21:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86AAFC433CA;
        Wed, 19 Jul 2023 19:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689794475;
        bh=curAQm2DnBtClxlf1c6Z0NjYs0TmL3ramPcV+EeBljo=;
        h=Date:To:From:Subject:From;
        b=HlWw64yI+bd/Vgrps2dauIzxpkZ7T33ci7kisQMZH+XW+rN7qnhtW1NFLCbdLWH2x
         zoSXm5UuBlEZ1ohXkNFUq2ZZk94Ioh4HXnZGHqh420lS2vVUHyWBFVFyqZelykTw12
         CGwxOTpqwbgvtywB8GhRzdY8RUZ6sGi9makHeDMs=
Date:   Wed, 19 Jul 2023 12:21:14 -0700
To:     mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        oliver.sang@intel.com, Liam.Howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-relax-lockdep-checks-for-on-stack-trees.patch added to mm-unstable branch
Message-Id: <20230719192115.86AAFC433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: relax lockdep checks for on-stack trees
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-relax-lockdep-checks-for-on-stack-trees.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-relax-lockdep-checks-for-on-stack-trees.patch

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
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree: relax lockdep checks for on-stack trees
Date: Fri, 14 Jul 2023 15:55:49 -0400

To support early release of the maple tree locks, do not lockdep check the
lock if it is set to NULL.  This is intended for the special case on-stack
use of tracking entries and not for general use.

Link: https://lkml.kernel.org/r/20230714195551.894800-3-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oliver Sang <oliver.sang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/maple_tree.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/include/linux/maple_tree.h~maple_tree-relax-lockdep-checks-for-on-stack-trees
+++ a/include/linux/maple_tree.h
@@ -182,7 +182,9 @@ enum maple_type {
 
 #ifdef CONFIG_LOCKDEP
 typedef struct lockdep_map *lockdep_map_p;
-#define mt_lock_is_held(mt)	lock_is_held(mt->ma_external_lock)
+#define mt_lock_is_held(mt)                                             \
+	(!(mt)->ma_external_lock || lock_is_held((mt)->ma_external_lock))
+
 #define mt_set_external_lock(mt, lock)					\
 	(mt)->ma_external_lock = &(lock)->dep_map
 #else
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

mm-mmap-clean-up-validate_mm-calls.patch
maple_tree-relax-lockdep-checks-for-on-stack-trees.patch
mm-mmap-change-detached-vma-locking-scheme.patch
maple_tree-be-more-strict-about-locking.patch

