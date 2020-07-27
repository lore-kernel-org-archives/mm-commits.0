Return-Path: <SRS0=lzHQ=BG=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E45E6C433E5
	for <mm-commits@archiver.kernel.org>; Mon, 27 Jul 2020 18:27:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7D0B2075A
	for <mm-commits@archiver.kernel.org>; Mon, 27 Jul 2020 18:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595874476;
	bh=IWzf2q64/K9ENSXAVExJezjlyrgTiX2Xh2dQvw2L3vQ=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=ihtFkI/rj+XeGMlC3BUjXSVmwW21OVaBMmURogCzAeS/Xgi8fbL4jpaVcq76c4NYP
	 LT0Nd45PGeElKGjx4DoSmyBRacooYflP164T6CDOuab8iL8fxwW/ghmK7piZlKPANN
	 ro87Cn/gZa5JPnLjmq8Id8XXTXKJuZ96IoOqXjoA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730415AbgG0S14 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Jul 2020 14:27:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:51998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729267AbgG0S14 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 27 Jul 2020 14:27:56 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E1132074F;
        Mon, 27 Jul 2020 18:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595874475;
        bh=IWzf2q64/K9ENSXAVExJezjlyrgTiX2Xh2dQvw2L3vQ=;
        h=Date:From:To:Subject:From;
        b=RZypgyVBi5ndpUKPsH7qUZEuGmXIKqO3Ts6ME5kRWj4c2RR4TYOc83FKQ8/Pfp72O
         LSMIeylTfToj+9wXpSuvJzm4rF4bAozJeoD6N/79Lagma6+sJu/5bvrMdV4qGveUBd
         7lUjADmwccp48/yqVPXn3ELFuDqVHoUwPPAOpYEk=
Date:   Mon, 27 Jul 2020 11:27:55 -0700
From:   akpm@linux-foundation.org
To:     mingo@redhat.com, mm-commits@vger.kernel.org, peterz@infradead.org,
        rdunlap@infradead.org, sjpark@amazon.de
Subject:  [merged]
 linux-sched-mmh-drop-duplicated-words-in-comments.patch removed from -mm
 tree
Message-ID: <20200727182755.OSPbyaD-I%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux/sched/mm.h: drop duplicated words in comments
has been removed from the -mm tree.  Its filename was
     linux-sched-mmh-drop-duplicated-words-in-comments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: linux/sched/mm.h: drop duplicated words in comments

Drop doubled words "to" and "that".

Link: http://lkml.kernel.org/r/927ea8d8-3f6c-9b65-4c2b-63ab4bd59ef1@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: SeongJae Park <sjpark@amazon.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched/mm.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/include/linux/sched/mm.h~linux-sched-mmh-drop-duplicated-words-in-comments
+++ a/include/linux/sched/mm.h
@@ -23,7 +23,7 @@ extern struct mm_struct *mm_alloc(void);
  * will still exist later on and mmget_not_zero() has to be used before
  * accessing it.
  *
- * This is a preferred way to to pin @mm for a longer/unbounded amount
+ * This is a preferred way to pin @mm for a longer/unbounded amount
  * of time.
  *
  * Use mmdrop() to release the reference acquired by mmgrab().
@@ -236,7 +236,7 @@ static inline unsigned int memalloc_noio
  * @flags: Flags to restore.
  *
  * Ends the implicit GFP_NOIO scope started by memalloc_noio_save function.
- * Always make sure that that the given flags is the return value from the
+ * Always make sure that the given flags is the return value from the
  * pairing memalloc_noio_save call.
  */
 static inline void memalloc_noio_restore(unsigned int flags)
@@ -267,7 +267,7 @@ static inline unsigned int memalloc_nofs
  * @flags: Flags to restore.
  *
  * Ends the implicit GFP_NOFS scope started by memalloc_nofs_save function.
- * Always make sure that that the given flags is the return value from the
+ * Always make sure that the given flags is the return value from the
  * pairing memalloc_nofs_save call.
  */
 static inline void memalloc_nofs_restore(unsigned int flags)
_

Patches currently in -mm which might be from rdunlap@infradead.org are

ocfs2-suballoch-delete-a-duplicated-word.patch
mm-drop-duplicated-words-in-linux-pgtableh.patch
mm-drop-duplicated-words-in-linux-mmh.patch
highmem-linux-highmemh-fix-duplicated-words-in-a-comment.patch
frontswap-linux-frontswaph-drop-duplicated-word-in-a-comment.patch
memcontrol-drop-duplicate-word-and-fix-spello-in-linux-memcontrolh.patch
clang-linux-compiler-clangh-drop-duplicated-word-in-a-comment.patch
linux-exportfsh-drop-duplicated-word-in-a-comment.patch
linux-async_txh-drop-duplicated-word-in-a-comment.patch
xz-drop-duplicated-word-in-linux-xzh.patch
autofs-fix-doubled-word.patch

