Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40F7FC636D6
	for <mm-commits@archiver.kernel.org>; Sat,  4 Feb 2023 01:53:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231654AbjBDBxO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 20:53:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233133AbjBDBxH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 20:53:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 861C8A25B
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 17:53:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D7FC662047
        for <mm-commits@vger.kernel.org>; Sat,  4 Feb 2023 01:53:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CD5EC433A0;
        Sat,  4 Feb 2023 01:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675475584;
        bh=zS5p9si6zzxMS7dFp15897KzH0PMPrXRLWN/MIk9UpQ=;
        h=Date:To:From:Subject:From;
        b=D/7+/b88KqH/KHs3jMHjpacO2/Xdkofgamkouj3AxojXUF4I3I1GsXTHxVApZY5KG
         pbasdpxWKqHmbqeJPcnLPW8KELU5cuBv3+rYNDdcOPfXddPn7CZw72J0Fiowr0uf0i
         6omFQn4/+kCqERgFDgqPWeDE6z8pLUTQbPDP2e4s=
Date:   Fri, 03 Feb 2023 17:53:03 -0800
To:     mm-commits@vger.kernel.org, phillip@squashfs.org.uk,
        pchelkin@ispras.ru, khoroshilov@ispras.ru,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] revert-squashfs-harden-sanity-check-in-squashfs_read_xattr_id_table.patch removed from -mm tree
Message-Id: <20230204015304.3CD5EC433A0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: revert "squashfs: harden sanity check in squashfs_read_xattr_id_table"
has been removed from the -mm tree.  Its filename was
     revert-squashfs-harden-sanity-check-in-squashfs_read_xattr_id_table.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: revert "squashfs: harden sanity check in squashfs_read_xattr_id_table"
Date: Thu Feb  2 06:07:35 PM PST 2023

This fix was nacked by Philip, for reasons identified in the email linked
below.

Link: https://lkml.kernel.org/r/68f15d67-8945-2728-1f17-5b53a80ec52d@squashfs.org.uk
Fixes: 72e544b1b28325 ("squashfs: harden sanity check in squashfs_read_xattr_id_table")
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: Fedor Pchelkin <pchelkin@ispras.ru>
Cc: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/fs/squashfs/xattr_id.c~revert-squashfs-harden-sanity-check-in-squashfs_read_xattr_id_table
+++ a/fs/squashfs/xattr_id.c
@@ -76,7 +76,7 @@ __le64 *squashfs_read_xattr_id_table(str
 	/* Sanity check values */
 
 	/* there is always at least one xattr id */
-	if (*xattr_ids <= 0)
+	if (*xattr_ids == 0)
 		return ERR_PTR(-EINVAL);
 
 	len = SQUASHFS_XATTR_BLOCK_BYTES(*xattr_ids);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shrinkers-fix-deadlock-in-shrinker-debugfs-fix.patch
mm-replace-vma-vm_flags-direct-modifications-with-modifier-calls-fix.patch
kasan-infer-allocation-size-by-scanning-metadata-fix.patch
lib-stackdepot-mm-rename-stack_depot_want_early_init-fix.patch
lib-stackdepot-annotate-racy-slab_index-accesses-fix.patch

