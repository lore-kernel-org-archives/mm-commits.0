Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C9AEC6FD19
	for <mm-commits@archiver.kernel.org>; Sun, 12 Mar 2023 21:11:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbjCLVLB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 12 Mar 2023 17:11:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229828AbjCLVLA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 12 Mar 2023 17:11:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9350223A42
        for <mm-commits@vger.kernel.org>; Sun, 12 Mar 2023 14:10:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 465EAB80B08
        for <mm-commits@vger.kernel.org>; Sun, 12 Mar 2023 21:10:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04967C433EF;
        Sun, 12 Mar 2023 21:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678655457;
        bh=DbrjE3x+xP6bKrINVJgLBfWSlD8xs3cqhFD6nVyVPxg=;
        h=Date:To:From:Subject:From;
        b=vRARS8XcpXQq+FFhMgZHwig8YgCb8PV4kt4n5xEubEgIFlafnpoxCgNQzF/No8EeP
         kJiW9AjulerwMSkfDH8GyoY0QT3Xg0iwZ/fOx3n2UBqfRczi0Tv6q9k+FQP7RWe+o0
         +U9l9z9ad5iha0mC9P4tTXEjyTg+rh0K5TIXAaCU=
Date:   Sun, 12 Mar 2023 14:10:56 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        naoya.horiguchi@linux.dev, konishi.ryusuke@gmail.com,
        hughd@google.com, agruenba@redhat.com, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-return-an-err_ptr-from-__filemap_get_folio-fix.patch added to mm-unstable branch
Message-Id: <20230312211057.04967C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-return-an-err_ptr-from-__filemap_get_folio-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-return-an-err_ptr-from-__filemap_get_folio-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-return-an-err_ptr-from-__filemap_get_folio-fix.patch

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
From: Christoph Hellwig <hch@lst.de>
Subject: mm-return-an-err_ptr-from-__filemap_get_folio-fix
Date: Fri, 10 Mar 2023 08:00:23 +0100

fix null-pointer deref

Link: https://lkml.kernel.org/r/20230310070023.GA13563@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reported-by: Naoya Horiguchi <naoya.horiguchi@linux.dev>
  Link: https://lkml.kernel.org/r/20230310043137.GA1624890@u2004
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/swap_state.c~mm-return-an-err_ptr-from-__filemap_get_folio-fix
+++ a/mm/swap_state.c
@@ -390,6 +390,8 @@ struct folio *filemap_get_incore_folio(s
 	struct swap_info_struct *si;
 	struct folio *folio = filemap_get_entry(mapping, index);
 
+	if (!folio)
+		return ERR_PTR(-ENOENT);
 	if (!xa_is_value(folio))
 		return folio;
 	if (!shmem_mapping(mapping))
_

Patches currently in -mm which might be from hch@lst.de are

ufs-dont-flush-page-immediately-for-dirsync-directories.patch
ocfs2-dont-use-write_one_page-in-ocfs2_duplicate_clusters_by_page.patch
mmjfs-move-write_one_page-folio_write_one-to-jfs.patch
mm-dont-look-at-xarray-value-entries-in-split_huge_pages_in_file.patch
mm-make-mapping_get_entry-available-outside-of-filemapc.patch
mm-use-filemap_get_entry-in-filemap_get_incore_folio.patch
shmem-remove-shmem_get_partial_folio.patch
shmem-open-code-the-page-cache-lookup-in-shmem_get_folio_gfp.patch
mm-remove-fgp_entry.patch
mm-return-an-err_ptr-from-__filemap_get_folio.patch
mm-return-an-err_ptr-from-__filemap_get_folio-fix.patch

