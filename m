Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA924E94130
	for <mm-commits@archiver.kernel.org>; Fri,  6 Oct 2023 21:47:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233794AbjJFVrC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 Oct 2023 17:47:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233789AbjJFVq7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 6 Oct 2023 17:46:59 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06E83BD;
        Fri,  6 Oct 2023 14:46:58 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E191C433C7;
        Fri,  6 Oct 2023 21:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696628817;
        bh=8EH6af39gP68L2bR47iCfwIfZq1PTJVGBFtsA+9cCAU=;
        h=Date:To:From:Subject:From;
        b=WM9IKxrakyIh6KcgrdXflQsL/FaXdwon7/b92g05gVGcMv/tCIbHJeU4uJ6A5NhY5
         2KNofkYCA5Ly/XWo9SzEYfXziPCa351HwjsBPaoSaYRwgZQnbJunIRXOrEBsmZG13R
         PF4lyXv+oiS1GRVuzySmL7mF5KSr3PfrduqNetOY=
Date:   Fri, 06 Oct 2023 14:46:55 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        Jonathan.Cameron@huawei.com, gregory.price@memverge.com,
        arnd@arndb.de, gourry.memverge@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-migrate-fix-do_pages_move-for-compat-pointers.patch removed from -mm tree
Message-Id: <20231006214657.3E191C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/migrate: fix do_pages_move for compat pointers
has been removed from the -mm tree.  Its filename was
     mm-migrate-fix-do_pages_move-for-compat-pointers.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Gregory Price <gourry.memverge@gmail.com>
Subject: mm/migrate: fix do_pages_move for compat pointers
Date: Tue, 3 Oct 2023 10:48:56 -0400

do_pages_move does not handle compat pointers for the page list. 
correctly.  Add in_compat_syscall check and appropriate get_user fetch
when iterating the page list.

It makes the syscall in compat mode (32-bit userspace, 64-bit kernel)
work the same way as the native 32-bit syscall again, restoring the
behavior before my broken commit 5b1b561ba73c ("mm: simplify
compat_sys_move_pages").

More specifically, my patch moved the parsing of the 'pages' array from
the main entry point into do_pages_stat(), which left the syscall
working correctly for the 'stat' operation (nodes = NULL), while the
'move' operation (nodes != NULL) is now missing the conversion and
interprets 'pages' as an array of 64-bit pointers instead of the
intended 32-bit userspace pointers.

It is possible that nobody noticed this bug because the few
applications that actually call move_pages are unlikely to run in
compat mode because of their large memory requirements, but this
clearly fixes a user-visible regression and should have been caught by
ltp.

Link: https://lkml.kernel.org/r/20231003144857.752952-1-gregory.price@memverge.com
Fixes: 5b1b561ba73c ("mm: simplify compat_sys_move_pages")
Signed-off-by: Gregory Price <gregory.price@memverge.com>
Reported-by: Arnd Bergmann <arnd@arndb.de>
Co-developed-by: Arnd Bergmann <arnd@arndb.de>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/mm/migrate.c~mm-migrate-fix-do_pages_move-for-compat-pointers
+++ a/mm/migrate.c
@@ -2162,6 +2162,7 @@ static int do_pages_move(struct mm_struc
 			 const int __user *nodes,
 			 int __user *status, int flags)
 {
+	compat_uptr_t __user *compat_pages = (void __user *)pages;
 	int current_node = NUMA_NO_NODE;
 	LIST_HEAD(pagelist);
 	int start, i;
@@ -2174,8 +2175,17 @@ static int do_pages_move(struct mm_struc
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

mm-migrate-remove-unused-mm-argument-from-do_move_pages_to_node.patch

