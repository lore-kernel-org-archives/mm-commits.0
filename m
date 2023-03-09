Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE8C3C61DA4
	for <mm-commits@archiver.kernel.org>; Thu,  9 Mar 2023 23:19:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231140AbjCIXTI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Mar 2023 18:19:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230481AbjCIXTG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Mar 2023 18:19:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B33CF2484
        for <mm-commits@vger.kernel.org>; Thu,  9 Mar 2023 15:18:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 05BA861D21
        for <mm-commits@vger.kernel.org>; Thu,  9 Mar 2023 23:18:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5988BC433EF;
        Thu,  9 Mar 2023 23:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678403929;
        bh=s/PvjbRe+2oidnjAqe5rzXxo2qdII2HHNqOIBzJ1JNE=;
        h=Date:To:From:Subject:From;
        b=c36xmC11/YsaayEozmKGYo3nx20k/LbkyPvYst7I7D0UTmFF/CKW3alPI9Ihyc8rz
         pmePH1YROknuKVt5L7uV34qpaS04tK75UilyUBuxzVfNXgnooM/HBLOVLigh8BrupT
         QTtEH037yQEajFi7LhrbOhCMm41TxVXhZXPiSPNI=
Date:   Thu, 09 Mar 2023 15:18:48 -0800
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        willy@infradead.org, p.raghav@samsung.com, keescook@chromium.org,
        hughd@google.com, david@redhat.com, dave@stgolabs.net,
        brauner@kernel.org, a.manzanares@samsung.com, mcgrof@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + shmem-set-shmem_writepage-variables-early.patch added to mm-unstable branch
Message-Id: <20230309231849.5988BC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: shmem: set shmem_writepage() variables early
has been added to the -mm mm-unstable branch.  Its filename is
     shmem-set-shmem_writepage-variables-early.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/shmem-set-shmem_writepage-variables-early.patch

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
From: Luis Chamberlain <mcgrof@kernel.org>
Subject: shmem: set shmem_writepage() variables early
Date: Thu, 9 Mar 2023 15:05:41 -0800

shmem_writepage() sets up variables typically used *after* a possible huge
page split.  However even if that does happen the address space mapping
should not change, and the inode does not change either.  So it should be
safe to set that from the very beginning.

This commit makes no functional changes.

Link: https://lkml.kernel.org/r/20230309230545.2930737-3-mcgrof@kernel.org
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Christian Brauner <brauner@kernel.org>
Cc: Adam Manzanares <a.manzanares@samsung.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
---


--- a/mm/shmem.c~shmem-set-shmem_writepage-variables-early
+++ a/mm/shmem.c
@@ -1316,9 +1316,9 @@ int shmem_unuse(unsigned int type)
 static int shmem_writepage(struct page *page, struct writeback_control *wbc)
 {
 	struct folio *folio = page_folio(page);
-	struct shmem_inode_info *info;
-	struct address_space *mapping;
-	struct inode *inode;
+	struct address_space *mapping = folio->mapping;
+	struct inode *inode = mapping->host;
+	struct shmem_inode_info *info = SHMEM_I(inode);
 	swp_entry_t swap;
 	pgoff_t index;
 
@@ -1336,10 +1336,7 @@ static int shmem_writepage(struct page *
 		folio_clear_dirty(folio);
 	}
 
-	mapping = folio->mapping;
 	index = folio->index;
-	inode = mapping->host;
-	info = SHMEM_I(inode);
 	if (info->flags & VM_LOCKED)
 		goto redirty;
 	if (!total_swap_pages)
_

Patches currently in -mm which might be from mcgrof@kernel.org are

shmem-remove-check-for-folio-lock-on-writepage.patch
shmem-set-shmem_writepage-variables-early.patch
shmem-move-reclaim-check-early-on-writepages.patch
shmem-skip-page-split-if-were-not-reclaiming.patch
shmem-update-documentation.patch
shmem-add-support-to-ignore-swap.patch

