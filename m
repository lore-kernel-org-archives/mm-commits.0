Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E0B0C77B7D
	for <mm-commits@archiver.kernel.org>; Thu, 18 May 2023 21:31:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230443AbjERVbc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 18 May 2023 17:31:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230141AbjERVbL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 18 May 2023 17:31:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0063D1BFA
        for <mm-commits@vger.kernel.org>; Thu, 18 May 2023 14:30:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 803E16524A
        for <mm-commits@vger.kernel.org>; Thu, 18 May 2023 21:29:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6695C433D2;
        Thu, 18 May 2023 21:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1684445348;
        bh=VM8JNt6NF+N3qb7auXFafuW4tf6AbQZK1s4QZYun/SI=;
        h=Date:To:From:Subject:From;
        b=gZxNmm4uY6Ti90rdx8rdw8KHnYX50re60WlGaGtp43NkJFcGiKJhBXHOvmdhm1ieH
         uuJJKavhhXLNFAgQPE9y2MzlRJqWxgRY69nr03uKT6ID2TP16B5e+Fl7GcJj3B1Piw
         wWCX0ExE9Z0meX5ImlpaGihAeoh3z1CldZYP+GuI=
Date:   Thu, 18 May 2023 14:29:08 -0700
To:     mm-commits@vger.kernel.org, zhangpeng.00@bytedance.com,
        vernon2gm@gmail.com, senozhatsky@chromium.org,
        richard.weiyang@gmail.com, Liam.Howlett@oracle.com,
        dcb314@hotmail.com, Liam.Howlett@Oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-change-rcu-checks-to-warn_on-instead-of-bug_on.patch added to mm-unstable branch
Message-Id: <20230518212908.D6695C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: change RCU checks to WARN_ON() instead of BUG_ON()
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-change-rcu-checks-to-warn_on-instead-of-bug_on.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-change-rcu-checks-to-warn_on-instead-of-bug_on.patch

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
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: maple_tree: change RCU checks to WARN_ON() instead of BUG_ON()
Date: Thu, 18 May 2023 10:55:17 -0400

If RCU is enabled and the tree isn't locked, just warn the user and avoid
crashing the kernel.

Link: https://lkml.kernel.org/r/20230518145544.1722059-9-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: David Binderman <dcb314@hotmail.com>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Vernon Yang <vernon2gm@gmail.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/maple_tree.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/maple_tree.h~maple_tree-change-rcu-checks-to-warn_on-instead-of-bug_on
+++ a/include/linux/maple_tree.h
@@ -616,7 +616,7 @@ static inline void mt_clear_in_rcu(struc
 		return;
 
 	if (mt_external_lock(mt)) {
-		BUG_ON(!mt_lock_is_held(mt));
+		WARN_ON(!mt_lock_is_held(mt));
 		mt->ma_flags &= ~MT_FLAGS_USE_RCU;
 	} else {
 		mtree_lock(mt);
@@ -635,7 +635,7 @@ static inline void mt_set_in_rcu(struct
 		return;
 
 	if (mt_external_lock(mt)) {
-		BUG_ON(!mt_lock_is_held(mt));
+		WARN_ON(!mt_lock_is_held(mt));
 		mt->ma_flags |= MT_FLAGS_USE_RCU;
 	} else {
 		mtree_lock(mt);
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are

maple_tree-clean-up-mas_parent_enum-and-rename-to-mas_parent_type.patch
maple_tree-add-format-option-to-mt_dump.patch
maple_tree-convert-bug_on-to-mt_bug_on.patch
maple_tree-change-rcu-checks-to-warn_on-instead-of-bug_on.patch
maple_tree-convert-debug-code-to-use-mt_warn_on-and-mas_warn_on.patch

