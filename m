Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A694C4167B
	for <mm-commits@archiver.kernel.org>; Wed,  8 Nov 2023 21:30:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229460AbjKHVaD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 8 Nov 2023 16:30:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229885AbjKHVaC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 8 Nov 2023 16:30:02 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C87F1BE2
        for <mm-commits@vger.kernel.org>; Wed,  8 Nov 2023 13:30:00 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB6ABC433C7;
        Wed,  8 Nov 2023 21:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1699479000;
        bh=4T7+q7VkeAnC4QlmenSWCZmWfdsWPjRBD91kr69dnR8=;
        h=Date:To:From:Subject:From;
        b=La7xQtmYv5Fv5cHf7XVjIHuW5s28rPw03hANyc8Kv4uSt+qwHc3J7GOwWjmGLMg8I
         UdVUDauTFY3id56hTx0PPeYfQlhsf2ogWaoFYwx8rUHhDnexHg4Aua55P8KJSxCwov
         sLCLh9BLbJePQjZLpFFijYeqQCiQ3tBGwvBKBaL8=
Date:   Wed, 08 Nov 2023 13:29:59 -0800
To:     mm-commits@vger.kernel.org, sfrench@samba.org, dhowells@redhat.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + afs-do-not-test-the-return-value-of-folio_start_writeback.patch added to mm-unstable branch
Message-Id: <20231108212959.EB6ABC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: afs: do not test the return value of folio_start_writeback()
has been added to the -mm mm-unstable branch.  Its filename is
     afs-do-not-test-the-return-value-of-folio_start_writeback.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/afs-do-not-test-the-return-value-of-folio_start_writeback.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: afs: do not test the return value of folio_start_writeback()
Date: Wed, 8 Nov 2023 20:46:03 +0000

In preparation for removing the return value entirely, stop testing it
in afs.

Link: https://lkml.kernel.org/r/20231108204605.745109-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Steve French <sfrench@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/afs/write.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/fs/afs/write.c~afs-do-not-test-the-return-value-of-folio_start_writeback
+++ a/fs/afs/write.c
@@ -559,8 +559,7 @@ static void afs_extend_writeback(struct
 
 			if (!folio_clear_dirty_for_io(folio))
 				BUG();
-			if (folio_start_writeback(folio))
-				BUG();
+			folio_start_writeback(folio);
 			afs_folio_start_fscache(caching, folio);
 
 			*_count -= folio_nr_pages(folio);
@@ -595,8 +594,7 @@ static ssize_t afs_write_back_from_locke
 
 	_enter(",%lx,%llx-%llx", folio_index(folio), start, end);
 
-	if (folio_start_writeback(folio))
-		BUG();
+	folio_start_writeback(folio);
 	afs_folio_start_fscache(caching, folio);
 
 	count -= folio_nr_pages(folio);
_

Patches currently in -mm which might be from willy@infradead.org are

mm-make-mapping_evict_folio-the-preferred-way-to-evict-clean-folios.patch
mm-convert-__do_fault-to-use-a-folio.patch
mm-use-mapping_evict_folio-in-truncate_error_page.patch
mm-convert-soft_offline_in_use_page-to-use-a-folio.patch
mm-convert-isolate_page-to-mf_isolate_folio.patch
mm-remove-invalidate_inode_page.patch
mm-remove-test_set_page_writeback.patch
afs-do-not-test-the-return-value-of-folio_start_writeback.patch
smb-do-not-test-the-return-value-of-folio_start_writeback.patch
mm-return-void-from-folio_start_writeback-and-related-functions.patch

