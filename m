Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68B75C61DA4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 02:10:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbjBCCK2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Feb 2023 21:10:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjBCCK1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 2 Feb 2023 21:10:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3610677B1
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 18:10:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7FCDE61D60
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 02:10:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2AF6C433D2;
        Fri,  3 Feb 2023 02:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675390224;
        bh=mjQvqYZnr3GLaSMInVE9djG49fnx2dqPwDlPX3uItwo=;
        h=Date:To:From:Subject:From;
        b=XJTB+vYS2VH3vOocd77PyY+RpuzEBzuOyEGe2Y9ifJ1ru2ndcHO21btjdxymQYF7i
         uZlXt6afracJSDFMurAqC3u+rnRyGVkZS4maURQmMHZMfxs2HGTES1fgHd8haARz8m
         753Gejo1MQnYcuH+CnlH6oK3Y2Wz+m0s+ZVFx5kE=
Date:   Thu, 02 Feb 2023 18:10:24 -0800
To:     mm-commits@vger.kernel.org, phillip@squashfs.org.uk,
        pchelkin@ispras.ru, khoroshilov@ispras.ru,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + revert-squashfs-harden-sanity-check-in-squashfs_read_xattr_id_table.patch added to mm-hotfixes-unstable branch
Message-Id: <20230203021024.D2AF6C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: revert "squashfs: harden sanity check in squashfs_read_xattr_id_table"
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     revert-squashfs-harden-sanity-check-in-squashfs_read_xattr_id_table.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/revert-squashfs-harden-sanity-check-in-squashfs_read_xattr_id_table.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

fsdax-dax_unshare_iter-should-return-a-valid-length-fix.patch
revert-squashfs-harden-sanity-check-in-squashfs_read_xattr_id_table.patch
mm-add-folio_add_new_anon_rmap-fix.patch
mm-remove-page_evictable-fix.patch
mm-remove-the-swap_readpage-return-value-fix.patch
block-remove-rw_page-fix.patch
mm-add-memcpy_from_file_folio-fix.patch
mm-replace-vma-vm_flags-direct-modifications-with-modifier-calls-fix.patch
kasan-infer-allocation-size-by-scanning-metadata-fix.patch
mm-shrinkers-fix-deadlock-in-shrinker-debugfs-fix.patch
error-injection-remove-ei_etype_none-fix.patch
hfsplus-remove-unnecessary-variable-initialization-fix.patch
scripts-gdb-add-mm-introspection-utils-fix.patch
lib-stackdepot-mm-rename-stack_depot_want_early_init-fix.patch
lib-stackdepot-annotate-racy-slab_index-accesses-fix.patch

