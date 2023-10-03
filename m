Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E950E7AD77
	for <mm-commits@archiver.kernel.org>; Tue,  3 Oct 2023 16:52:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235282AbjJCQwB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 3 Oct 2023 12:52:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231620AbjJCQwB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 3 Oct 2023 12:52:01 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BF199B
        for <mm-commits@vger.kernel.org>; Tue,  3 Oct 2023 09:51:58 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12452C433C7;
        Tue,  3 Oct 2023 16:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696351918;
        bh=0zo5249TOOOhZaJNDgS40PxhKqYXZ2WpOgk5QHlToVE=;
        h=Date:To:From:Subject:From;
        b=Z7HDtjZr3Qzx6uXniI/OW+TzOS50LYMl+78bWOL5jN9clGYKgAFonoMkpksS5ZN20
         UJs1HtQhmg6iS3fEVobcfrq/8HJJmv+8pdjzgWx0lxz1uZ0u4eoaelekeehOB0hvhC
         461OGIwITihwMj+RXmS23XaXEsCEaN8iIuM2xdzo=
Date:   Tue, 03 Oct 2023 09:51:55 -0700
To:     mm-commits@vger.kernel.org, Jonathan.Cameron@huawei.com,
        gregory.price@memverge.com, arnd@arndb.de,
        gourry.memverge@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-fix-do_pages_move-for-compat-pointers.patch added to mm-unstable branch
Message-Id: <20231003165158.12452C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migrate: fix do_pages_move for compat pointers
has been added to the -mm mm-unstable branch.  Its filename is
     mm-migrate-fix-do_pages_move-for-compat-pointers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-fix-do_pages_move-for-compat-pointers.patch

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
From: Gregory Price <gourry.memverge@gmail.com>
Subject: mm/migrate: fix do_pages_move for compat pointers
Date: Tue, 3 Oct 2023 10:48:56 -0400

do_pages_move does not handle compat pointers for the page list. 
correctly.  Add in_compat_syscall check and appropriate get_user fetch
when iterating the page list.

Link: https://lkml.kernel.org/r/20231003144857.752952-1-gregory.price@memverge.com
Fixes: 5b1b561ba73c ("mm: simplify compat_sys_move_pages")
Signed-off-by: Gregory Price <gregory.price@memverge.com>
Reported-by: Arnd Bergmann <arnd@arndb.de>
Co-developed-by: Arnd Bergmann <arnd@arndb.de>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/mm/migrate.c~mm-migrate-fix-do_pages_move-for-compat-pointers
+++ a/mm/migrate.c
@@ -2155,6 +2155,7 @@ static int do_pages_move(struct mm_struc
 			 const int __user *nodes,
 			 int __user *status, int flags)
 {
+	compat_uptr_t __user *compat_pages = (void __user *)pages;
 	int current_node = NUMA_NO_NODE;
 	LIST_HEAD(pagelist);
 	int start, i;
@@ -2167,8 +2168,17 @@ static int do_pages_move(struct mm_struc
 		int node;
 
 		err = -EFAULT;
-		if (get_user(p, pages + i))
-			goto out_flush;
+		if (in_compat_syscall()) {
+			compat_uptr_t cp;
+
+			if (get_user(cp, compat_pages + i))
+				goto out_flush;
+
+			p = compat_ptr(cp);
+		} else {
+			if (get_user(p, pages + i))
+				goto out_flush;
+		}
 		if (get_user(node, nodes + i))
 			goto out_flush;
 
_

Patches currently in -mm which might be from gourry.memverge@gmail.com are

mm-migrate-fix-do_pages_move-for-compat-pointers.patch
mm-migrate-remove-unused-mm-argument-from-do_move_pages_to_node.patch

