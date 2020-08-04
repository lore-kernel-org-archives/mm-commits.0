Return-Path: <SRS0=09mD=BO=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4AE4C433E0
	for <mm-commits@archiver.kernel.org>; Tue,  4 Aug 2020 03:21:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB265206DA
	for <mm-commits@archiver.kernel.org>; Tue,  4 Aug 2020 03:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596511303;
	bh=QaC5ffKvOz/iDBQ6O9Q0po1Wcdw+nQtaupsDTrE+OD4=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=i56BSJ3jpXvkxpcKcP+3qtJGbhMN6/rA5ZfYatZXhdh3W/wG6iNCXPN7EvHDhV1sI
	 EV7HthH3pVTOns7fVqqSM4ZpnR1O3UP9poyB/SPKXa7TEDh1EzS5pU3qVEvOSzLygQ
	 LUvGmgJsJYhNtZaaua8Ae3qJZxTilSCVYnzypEyk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730099AbgHDDVn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Aug 2020 23:21:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:40592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729636AbgHDDVn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 3 Aug 2020 23:21:43 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA1882068F;
        Tue,  4 Aug 2020 03:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596511303;
        bh=QaC5ffKvOz/iDBQ6O9Q0po1Wcdw+nQtaupsDTrE+OD4=;
        h=Date:From:To:Subject:From;
        b=phOkV1CxbNEWm4wj/yZHz/2ZDR5anIUZ6PLSgZVFf5nq0e9as8V64in6GYrUNtaGR
         LhMYezGhKmhBF2yRiH+PMuh5/pjykQbeAOTyV/tPCxVtGHkCKBg0TnxA/gbd9HGZDc
         fCIdl2V5C0bNQJlJ3B+hxwY9wCk/TqefnRdcYVHQ=
Date:   Mon, 03 Aug 2020 20:21:42 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        rdunlap@infradead.org
Subject:  + mm-usercopyc-delete-duplicated-word.patch added to -mm
 tree
Message-ID: <20200804032142.0dfTlw8y5%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/usercopy.c: delete duplicated word
has been added to the -mm tree.  Its filename is
     mm-usercopyc-delete-duplicated-word.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-usercopyc-delete-duplicated-word.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-usercopyc-delete-duplicated-word.patch

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
Subject: mm/usercopy.c: delete duplicated word

Drop the repeated word "the".

Link: http://lkml.kernel.org/r/20200801173822.14973-13-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/usercopy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/usercopy.c~mm-usercopyc-delete-duplicated-word
+++ a/mm/usercopy.c
@@ -43,7 +43,7 @@ static noinline int check_stack_object(c
 
 	/*
 	 * Reject: object partially overlaps the stack (passing the
-	 * the check above means at least one end is within the stack,
+	 * check above means at least one end is within the stack,
 	 * so if this check fails, the other end is outside the stack).
 	 */
 	if (obj < stack || stackend < obj + len)
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

