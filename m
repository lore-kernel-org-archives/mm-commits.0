Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC8FAC433DF
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:18:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D24422C9F
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781081;
	bh=cx03duJfSEM3xER1ayQx0ZitLE6DIqG3as1jVLmYEOo=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=rHEJ6cDelgDMlFpR184JsuAUF0ufpgdtvCY3hWffAYyx+w4ImWLOS1z75yc8/T1d2
	 g6C9IEu2yqzGWmGiet1uB7Z5kFEqddwB4mWU/Y3J9zk3zWrHe05PM39dn02V1q6eIC
	 YzW23RZ86uc/HTKna7nJc8sDaXPoN3Y2+0Avw2/c=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726038AbgHGGSB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:18:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:53158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgHGGSA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:18:00 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E4492177B;
        Fri,  7 Aug 2020 06:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781080;
        bh=cx03duJfSEM3xER1ayQx0ZitLE6DIqG3as1jVLmYEOo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=XvtMAZA1Bq82d+C6tHdR757PD9Yl2E15jGoEJw1Q2kCDXJTS/u7wDiydsTY1jEpti
         g16jRoWCXXEVLEAI1gMHspctF87LI2MMwisG8E3urzLGcN6vnFNkOpJ7E2TTAdggcL
         avFonacXYKptcpwvN3+7OVn2EbKHPPWzoVJUNmAY=
Date:   Thu, 06 Aug 2020 23:17:59 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, jlbec@evilplan.org,
        joseph.qi@linux.alibaba.com, linux-mm@kvack.org, mark@fasheh.com,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        torvalds@linux-foundation.org
Subject:  [patch 018/163] ocfs2: suballoc.h: delete a duplicated
 word
Message-ID: <20200807061759.oznPk9awL%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
