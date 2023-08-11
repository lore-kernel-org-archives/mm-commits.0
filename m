Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A3D9C001DB
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 22:20:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232895AbjHKWUU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 18:20:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237118AbjHKWUO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 18:20:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ACBC3582
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 15:20:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE1016743D
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 22:20:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FFE8C433C7;
        Fri, 11 Aug 2023 22:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691792409;
        bh=FbaHHE9FH490GbOhkAuWQBRxzTrLo6a5qzbztLUZvsM=;
        h=Date:To:From:Subject:From;
        b=wjf6VmWjVE/CUEtvuaMWoh+iyjYGKjGdNDTWXR7FbYo4dmBOEs8OKv9yn1hT37cgL
         pDMs5eOHadtOIHb0qpUcO0rOgkyan5ZZMcG+tz3PLnYVgYYWqhm6c7InhQrT33RJAT
         IYsCd+O3OQWWuXvcYSPFCuE3qXpB5gncWATLuUU8=
Date:   Fri, 11 Aug 2023 15:20:08 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, tytso@mit.edu, ocfs2-devel@oss.oracle.com,
        mark@fasheh.com, joseph.qi@linux.alibaba.com, jlbec@evilplan.org,
        jack@suse.cz, hch@lst.de, brauner@kernel.org, beanhuo@micron.com,
        adilger.kernel@dilger.ca, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] fs-buffer-clean-up-block_commit_write-fix.patch removed from -mm tree
Message-Id: <20230811222009.3FFE8C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fs-buffer-clean-up-block_commit_write-fix
has been removed from the -mm tree.  Its filename was
     fs-buffer-clean-up-block_commit_write-fix.patch

This patch was dropped because it was folded into fs-buffer-clean-up-block_commit_write.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs-buffer-clean-up-block_commit_write-fix
Date: Sun Jul  2 05:03:36 PM PDT 2023

remove now-unused local `inode'

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Bean Huo <beanhuo@micron.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Luís Henriques <ocfs2-devel@oss.oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/buffer.c~fs-buffer-clean-up-block_commit_write-fix
+++ a/fs/buffer.c
@@ -2252,7 +2252,6 @@ int block_write_end(struct file *file, s
 			struct page *page, void *fsdata)
 {
 	struct folio *folio = page_folio(page);
-	struct inode *inode = mapping->host;
 	size_t start = pos - folio_pos(folio);
 
 	if (unlikely(copied < len)) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
fs-buffer-clean-up-block_commit_write.patch
mm-page_alloc-avoid-false-page-outside-zone-error-info-fix.patch
mm-make-pte_marker_swapin_error-more-general-fix.patch
mm-kfence-allocate-kfence_metadata-at-runtime-fix.patch
acpi-hmat-calculate-abstract-distance-with-hmat-checkpatch-fixes.patch
mm-remove-redundant-k-macro-definition-fix.patch
signal-print-comm-and-exe-name-on-fatal-signals-fix.patch
drm-i915-move-abs_diff-to-mathh-fix-fix.patch
nmi_backtrace-allow-excluding-an-arbitrary-cpu-fix.patch

