Return-Path: <SRS0=eezP=A7=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FF20C433E4
	for <mm-commits@archiver.kernel.org>; Mon, 20 Jul 2020 23:31:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54B6921702
	for <mm-commits@archiver.kernel.org>; Mon, 20 Jul 2020 23:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595287893;
	bh=zmrSBJFNBTMHjlueC3vlNZpmaNh1p0WBjG7Hd4+I60w=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=Fq4iN5qsjTDInjLlO/CRNTj3LsvEQIPPRlUpy65IZLGxG818JotjGZk7knUB1PPcj
	 T5hy7/lsVlrOiTdqxlvLg0ugdiB+10pLxjyicbKucWT3dkpyPY8Yx9BAPEyUbunNYz
	 M9Vzls/auOVoJxXEzMSEaHOrci9WN4sxNvrNXx1g=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726611AbgGTXbd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 20 Jul 2020 19:31:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:57862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726521AbgGTXbc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 20 Jul 2020 19:31:32 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 682252080D;
        Mon, 20 Jul 2020 23:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595287892;
        bh=zmrSBJFNBTMHjlueC3vlNZpmaNh1p0WBjG7Hd4+I60w=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=HhXDMNThCP2r0h1adviGUoVcNZ+LixZCZt+ReKpNhb/IDizTlNkybQgixhIOuyaC6
         Ni6DZzKxI5mKgkyc6Tvl2gh8DYuL0yXJeb3G9U7FKk1cVyJJUAQLyrbHumYwdAC7ac
         Tjyq27b6mE/Yz18Qc8GOaeipj6QakHjuKm9BPSMc=
Date:   Mon, 20 Jul 2020 16:31:31 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     jlbec@evilplan.org, joseph.qi@linux.alibaba.com, mark@fasheh.com,
        mm-commits@vger.kernel.org, rdunlap@infradead.org
Subject:  + ocfs2-suballoch-delete-a-duplicated-word.patch added to
 -mm tree
Message-ID: <20200720233131.tSmwjqUfo%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: suballoc.h: delete a duplicated word
has been added to the -mm tree.  Its filename is
     ocfs2-suballoch-delete-a-duplicated-word.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-suballoch-delete-a-duplicated-word.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-suballoch-delete-a-duplicated-word.patch

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
Subject: ocfs2: suballoc.h: delete a duplicated word

Drop the repeated word "is" in a comment.

Link: http://lkml.kernel.org/r/20200720001421.28823-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/suballoc.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/suballoc.h~ocfs2-suballoch-delete-a-duplicated-word
+++ a/fs/ocfs2/suballoc.h
@@ -40,7 +40,7 @@ struct ocfs2_alloc_context {
 
 	u64    ac_last_group;
 	u64    ac_max_block;  /* Highest block number to allocate. 0 is
-				 is the same as ~0 - unlimited */
+				 the same as ~0 - unlimited */
 
 	int    ac_find_loc_only;  /* hack for reflink operation ordering */
 	struct ocfs2_suballoc_result *ac_find_loc_priv; /* */
_

Patches currently in -mm which might be from rdunlap@infradead.org are

ocfs2-suballoch-delete-a-duplicated-word.patch
linux-sched-mmh-drop-duplicated-words-in-comments.patch
mm-drop-duplicated-words-in-linux-pgtableh.patch
mm-drop-duplicated-words-in-linux-mmh.patch
autofs-fix-doubled-word.patch

