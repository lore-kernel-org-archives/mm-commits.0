Return-Path: <SRS0=09mD=BO=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41B13C433DF
	for <mm-commits@archiver.kernel.org>; Tue,  4 Aug 2020 03:21:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48E7D206DA
	for <mm-commits@archiver.kernel.org>; Tue,  4 Aug 2020 03:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596511308;
	bh=RtAYYuNX/5nJzt5RNyauk1u2kvjex6QoJltgqho/Rjs=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=14VwJHcuNsgJ8VJgXCOMWbUtQesW/YR9Vfx7ltoZKdMMGtXmczJQ0J5pmdfdqqHWd
	 o4sZGMKkLyxN0IJci0tj4Ortrb+ApkjjHokd2kAjvQ9/FIkCTWOjzJ9EjUjQDOHLWo
	 1qgDiZoMprtqRcHcidIn0A/PbI1Ew3HUWph9mOqE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730179AbgHDDVr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Aug 2020 23:21:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:40636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729636AbgHDDVr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 3 Aug 2020 23:21:47 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 00F3B2068F;
        Tue,  4 Aug 2020 03:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596511307;
        bh=RtAYYuNX/5nJzt5RNyauk1u2kvjex6QoJltgqho/Rjs=;
        h=Date:From:To:Subject:From;
        b=d/Dj/U12J8rsGi9EHhLGc1kfJ/rvyK9H+HfTNNJrBs9mT1vtT/uQ2hvA+quxRiq9U
         mxF8+W5edKQBu1OKXNgsxExJl+7ZK9CN506K9GRo/8GZtfOZYH90WsFfzRIp5LJoqG
         aG3mZURuknKjCrwdX744MJpt0MNI5VEdrX1g2g88=
Date:   Mon, 03 Aug 2020 20:21:46 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        rdunlap@infradead.org
Subject:  + mm-zpoolc-delete-duplicated-word-and-fix-grammar.patch
 added to -mm tree
Message-ID: <20200804032146.bTtlK40pB%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zpool.c: delete duplicated word and fix grammar
has been added to the -mm tree.  Its filename is
     mm-zpoolc-delete-duplicated-word-and-fix-grammar.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-zpoolc-delete-duplicated-word-and-fix-grammar.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-zpoolc-delete-duplicated-word-and-fix-grammar.patch

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
Subject: mm/zpool.c: delete duplicated word and fix grammar

Drop the repeated word "if".
Fix subject/verb agreement.

Link: http://lkml.kernel.org/r/20200801173822.14973-15-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zpool.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/zpool.c~mm-zpoolc-delete-duplicated-word-and-fix-grammar
+++ a/mm/zpool.c
@@ -239,15 +239,15 @@ const char *zpool_get_type(struct zpool
 }
 
 /**
- * zpool_malloc_support_movable() - Check if the zpool support
- * allocate movable memory
+ * zpool_malloc_support_movable() - Check if the zpool supports
+ *	allocating movable memory
  * @zpool:	The zpool to check
  *
- * This returns if the zpool support allocate movable memory.
+ * This returns if the zpool supports allocating movable memory.
  *
  * Implementations must guarantee this to be thread-safe.
  *
- * Returns: true if if the zpool support allocate movable memory, false if not
+ * Returns: true if the zpool supports allocating movable memory, false if not
  */
 bool zpool_malloc_support_movable(struct zpool *zpool)
 {
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

