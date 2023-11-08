Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79A89C4332F
	for <mm-commits@archiver.kernel.org>; Wed,  8 Nov 2023 21:30:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbjKHVaH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 8 Nov 2023 16:30:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229885AbjKHVaD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 8 Nov 2023 16:30:03 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 870662588
        for <mm-commits@vger.kernel.org>; Wed,  8 Nov 2023 13:30:01 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21D08C433C8;
        Wed,  8 Nov 2023 21:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1699479001;
        bh=duWLok5oslAtJJmQ1WESPhePEzdbE2DBMmvwGwPITmg=;
        h=Date:To:From:Subject:From;
        b=lmBfzb9CIMSdyLzCnGfXBwc4ASAwQqqd9Jts4ASBnOfhdG8txzS2o4F/KI5EbXyRQ
         mOVmP6suKzALxknfj/g1nNvZ/Sev4Jlk1Yc6MA2QfvW1as6OmluYULxV7wBq0XMzE9
         HFSQp5W0K1uWMKdP59Y4yIiv74wePDNqPKVQ0sFA=
Date:   Wed, 08 Nov 2023 13:30:00 -0800
To:     mm-commits@vger.kernel.org, sfrench@samba.org, dhowells@redhat.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + smb-do-not-test-the-return-value-of-folio_start_writeback.patch added to mm-unstable branch
Message-Id: <20231108213001.21D08C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: smb: do not test the return value of folio_start_writeback()
has been added to the -mm mm-unstable branch.  Its filename is
     smb-do-not-test-the-return-value-of-folio_start_writeback.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/smb-do-not-test-the-return-value-of-folio_start_writeback.patch

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
Subject: smb: do not test the return value of folio_start_writeback()
Date: Wed, 8 Nov 2023 20:46:04 +0000

In preparation for removing the return value entirely, stop testing it
in smb.

Link: https://lkml.kernel.org/r/20231108204605.745109-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Steve French <sfrench@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/smb/client/file.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/fs/smb/client/file.c~smb-do-not-test-the-return-value-of-folio_start_writeback
+++ a/fs/smb/client/file.c
@@ -2706,8 +2706,7 @@ static void cifs_extend_writeback(struct
 			 */
 			if (!folio_clear_dirty_for_io(folio))
 				WARN_ON(1);
-			if (folio_start_writeback(folio))
-				WARN_ON(1);
+			folio_start_writeback(folio);
 
 			*_count -= folio_nr_pages(folio);
 			folio_unlock(folio);
@@ -2742,8 +2741,7 @@ static ssize_t cifs_write_back_from_lock
 	int rc;
 
 	/* The folio should be locked, dirty and not undergoing writeback. */
-	if (folio_start_writeback(folio))
-		WARN_ON(1);
+	folio_start_writeback(folio);
 
 	count -= folio_nr_pages(folio);
 	len = folio_size(folio);
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

