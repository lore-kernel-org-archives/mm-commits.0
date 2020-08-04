Return-Path: <SRS0=09mD=BO=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33047C433E0
	for <mm-commits@archiver.kernel.org>; Tue,  4 Aug 2020 03:21:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3881D206DA
	for <mm-commits@archiver.kernel.org>; Tue,  4 Aug 2020 03:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596511296;
	bh=45fbW9FAUTS74SugYaAJfC84b6oweMXr8CwY7sMB1qU=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=AuiWgdJbxB+0kYPIMOQK5I8DZqy540lgaozBUyNbLWlMIzDAjYLcgUFwMIACaK5vb
	 m74jurNJ9HBPrNqyiNyWiZfTzD8TfIrt0ACXGAQz3eZUs0DGaSe1NW+nsEzc7E7o24
	 e01kU4xIs3NB7zbXbK9iqfEs88aLfSnnefQWf79A=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730090AbgHDDVf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Aug 2020 23:21:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:40496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729636AbgHDDVf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 3 Aug 2020 23:21:35 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E96552068F;
        Tue,  4 Aug 2020 03:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596511295;
        bh=45fbW9FAUTS74SugYaAJfC84b6oweMXr8CwY7sMB1qU=;
        h=Date:From:To:Subject:From;
        b=NpU8vJyiOs2wB6k4/xGg1hFKCDCqCZ4CWN810ttjm4c2ZMN1UFWG5tNSiPFtDq8SS
         pkmRSB3OdPYY/rP9vtEAUBB534YMEpNO0bQaysRezEZNrTGs+VR85D80GpEw+dLOIt
         icOSoiXq/vz46bFXbqfe+98nfVWa338qJ8K/zAKQ=
Date:   Mon, 03 Aug 2020 20:21:34 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        rdunlap@infradead.org
Subject:  + mm-nommuc-delete-duplicated-words.patch added to -mm
 tree
Message-ID: <20200804032134.-lRnd6faC%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/nommu.c: delete duplicated words
has been added to the -mm tree.  Its filename is
     mm-nommuc-delete-duplicated-words.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-nommuc-delete-duplicated-words.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-nommuc-delete-duplicated-words.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: mm/nommu.c: delete duplicated words

Drop the repeated word "that" in two places.

Link: http://lkml.kernel.org/r/20200801173822.14973-9-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/nommu.c~mm-nommuc-delete-duplicated-words
+++ a/mm/nommu.c
@@ -1762,8 +1762,8 @@ EXPORT_SYMBOL_GPL(access_process_vm);
  * @newsize: The proposed filesize of the inode
  *
  * Check the shared mappings on an inode on behalf of a shrinking truncate to
- * make sure that that any outstanding VMAs aren't broken and then shrink the
- * vm_regions that extend that beyond so that do_mmap() doesn't
+ * make sure that any outstanding VMAs aren't broken and then shrink the
+ * vm_regions that extend beyond so that do_mmap() doesn't
  * automatically grant mappings that are too large.
  */
 int nommu_shrink_inode_mappings(struct inode *inode, size_t size,
_

Patches currently in -mm which might be from rdunlap@infradead.org are

ocfs2-suballoch-delete-a-duplicated-word.patch
mm-drop-duplicated-words-in-linux-pgtableh.patch
mm-drop-duplicated-words-in-linux-mmh.patch
highmem-linux-highmemh-fix-duplicated-words-in-a-comment.patch
frontswap-linux-frontswaph-drop-duplicated-word-in-a-comment.patch
memcontrol-drop-duplicate-word-and-fix-spello-in-linux-memcontrolh.patch
mm-compactionc-delete-duplicated-word.patch
mm-filemapc-delete-duplicated-word.patch
mm-hmmc-delete-duplicated-word.patch
mm-hugetlbc-delete-duplicated-words.patch
mm-memcontrolc-delete-duplicated-words.patch
mm-memoryc-delete-duplicated-words.patch
mm-migratec-delete-duplicated-word.patch
mm-nommuc-delete-duplicated-words.patch
mm-page_allocc-delete-or-fix-duplicated-words.patch
mm-shmemc-delete-duplicated-word.patch
mm-slab_commonc-delete-duplicated-word.patch
mm-usercopyc-delete-duplicated-word.patch
mm-vmscanc-delete-or-fix-duplicated-words.patch
mm-zpoolc-delete-duplicated-word-and-fix-grammar.patch
mm-zsmallocc-fix-duplicated-words.patch
clang-linux-compiler-clangh-drop-duplicated-word-in-a-comment.patch
linux-exportfsh-drop-duplicated-word-in-a-comment.patch
linux-async_txh-drop-duplicated-word-in-a-comment.patch
xz-drop-duplicated-word-in-linux-xzh.patch
autofs-fix-doubled-word.patch

