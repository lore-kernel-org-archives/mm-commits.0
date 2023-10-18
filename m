Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D470CDB47E
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 21:22:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbjJRVW0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 17:22:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjJRVWZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 17:22:25 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D974C9B
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 14:22:23 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74064C433C7;
        Wed, 18 Oct 2023 21:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697664143;
        bh=gZefPs+PO/jLWR/L0q0cvomaFexT/omDjsh/s1iRf+o=;
        h=Date:To:From:Subject:From;
        b=m7iy/0+ij9Cv4hUYkDAGAdg5BTw0AIrQUATxIKaDws1pr6M1iDAB1i96jabxb9qk6
         9vWEXY3OJNtC4WuxSkSPl2dGwq42v77RrUh8fwZBGv6daH6gy0r2Sl7pfL1rwSw2ea
         pu/OwUkgD2UllDWbbfLvYnqh/YY8We/qN4opG7GU=
Date:   Wed, 18 Oct 2023 14:22:22 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, jack@suse.cz,
        hch@lst.de, lstoakes@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-filemap-clarify-filemap_fault-comments-for-not-uptodate-case-fix.patch removed from -mm tree
Message-Id: <20231018212223.74064C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-filemap-clarify-filemap_fault-comments-for-not-uptodate-case-fix
has been removed from the -mm tree.  Its filename was
     mm-filemap-clarify-filemap_fault-comments-for-not-uptodate-case-fix.patch

This patch was dropped because it was folded into mm-filemap-clarify-filemap_fault-comments-for-not-uptodate-case.patch

------------------------------------------------------
From: Lorenzo Stoakes <lstoakes@gmail.com>
Subject: mm-filemap-clarify-filemap_fault-comments-for-not-uptodate-case-fix
Date: Mon, 2 Oct 2023 07:37:24 +0100

correct identation as per Christopher's feedback

Link: https://lkml.kernel.org/r/2c7014c0-6343-4e76-8697-3f84f54350bd@lucifer.local
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/filemap.c~mm-filemap-clarify-filemap_fault-comments-for-not-uptodate-case-fix
+++ a/mm/filemap.c
@@ -3313,10 +3313,10 @@ retry_find:
 	 */
 	if (unlikely(!folio_test_uptodate(folio))) {
 		/*
-		 * If the invalidate lock is not held, the folio was in cache and
-		 * uptodate and now it is not. Strange but possible since we
-		 * didn't hold the page lock all the time. Let's drop everything,
-		 * get the invalidate lock and try again.
+		 * If the invalidate lock is not held, the folio was in cache
+		 * and uptodate and now it is not. Strange but possible since we
+		 * didn't hold the page lock all the time. Let's drop
+		 * everything, get the invalidate lock and try again.
 		 */
 		if (!mapping_locked) {
 			folio_unlock(folio);
_

Patches currently in -mm which might be from lstoakes@gmail.com are

mm-filemap-clarify-filemap_fault-comments-for-not-uptodate-case.patch
mm-make-__access_remote_vm-static.patch
mm-gup-explicitly-define-and-check-internal-gup-flags-disallow-foll_touch.patch
mm-gup-make-failure-to-pin-an-error-if-foll_nowait-not-specified.patch
mm-gup-adapt-get_user_page_vma_remote-to-never-return-null.patch
mm-mprotect-allow-unfaulted-vmas-to-be-unaccounted-on-mprotect.patch
mm-move-vma_policy-and-anon_vma_name-decls-to-mm_typesh.patch
mm-abstract-the-vma_merge-split_vma-pattern-for-mprotect-et-al.patch
mm-make-vma_merge-and-split_vma-internal.patch
mm-abstract-merge-for-new-vmas-into-vma_merge_new_vma.patch
mm-abstract-vma-merge-and-extend-into-vma_merge_extend-helper.patch
mm-drop-the-assumption-that-vm_shared-always-implies-writable.patch
mm-update-memfd-seal-write-check-to-include-f_seal_write.patch
mm-perform-the-mapping_map_writable-check-after-call_mmap.patch
mm-perform-the-mapping_map_writable-check-after-call_mmap-fix.patch

