Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D2D7C001B0
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:05:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237155AbjHKXFn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:05:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237132AbjHKXD5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:03:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 839BC3A94
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:02:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2247262BDB
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:02:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78899C433C7;
        Fri, 11 Aug 2023 23:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794920;
        bh=P16qG8O+SiqLxQbjvWpeONNr4Na1Q0FkAu4ijpm0BE8=;
        h=Date:To:From:Subject:From;
        b=druqoLR85FKqqoHzqBE6KfhXeN76zd/PXxse3+KM9xw2ASTsBRs9SkRoOSTCRwN4D
         czQRbnC8jDm8pZT5pLrUISukT5FyeicPAUQbEfo4+M0O7fSJe9iwomvXVWIADGtVt/
         P+PoS2sUQy3ryAIY58niW/KDpCjxZwkab+Px1JFk=
Date:   Fri, 11 Aug 2023 16:01:59 -0700
To:     mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        oliver.sang@intel.com, Liam.Howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-relax-lockdep-checks-for-on-stack-trees.patch removed from -mm tree
Message-Id: <20230811230200.78899C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: relax lockdep checks for on-stack trees
has been removed from the -mm tree.  Its filename was
     maple_tree-relax-lockdep-checks-for-on-stack-trees.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

maple_tree-add-hex-output-to-maple_arange64-dump.patch
maple_tree-reorder-replacement-of-nodes-to-avoid-live-lock.patch
maple_tree-introduce-mas_put_in_tree.patch
maple_tree-introduce-mas_tree_parent-definition.patch
maple_tree-change-mas_adopt_children-parent-usage.patch
maple_tree-replace-data-before-marking-dead-in-split-and-spanning-store.patch

