Return-Path: <SRS0=1Kf1=EE=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75858C388F7
	for <mm-commits@archiver.kernel.org>; Thu, 29 Oct 2020 01:54:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 27FFB206E9
	for <mm-commits@archiver.kernel.org>; Thu, 29 Oct 2020 01:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603936472;
	bh=fX1J/ZISl8uzvFF3tkTo0MI5mn7L+PItW5J2p3pwVHs=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=f/858bNf+RKQ9AJrlMeP8cZOErpe9Z1MD4PiZ/Rp7J0Aei3lxPv4h5VhR109Qk9Bt
	 D9Vba4LSSBHO8jvliiHIpz1styX9oheuTL8g4GYIJVPx2c+5EhXiSdO6QFLrstTjav
	 Cmq6ag4qHePTCVOnVv8zhNQF3OOykSOXpXEhhSBk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728672AbgJ1V4s (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 28 Oct 2020 17:56:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:46412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728761AbgJ1VyX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 28 Oct 2020 17:54:23 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 207D22470E;
        Wed, 28 Oct 2020 21:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603922063;
        bh=fX1J/ZISl8uzvFF3tkTo0MI5mn7L+PItW5J2p3pwVHs=;
        h=Date:From:To:Subject:From;
        b=YeniuvI2SfAZVKfXq4k197U2wZTRKH2+1DVg+TK7KBlZ74TGodwSPX3ky5noxAE9P
         df7lJhzzWfkpexJPB9EEIxTdtl7NJNe+9CBOS4NgQOUmqHe1NlwSpTapHvk21G9xAM
         TRIS/ilBvgardDMupdhg0Z4SNaG5JyXb5YiiPm7U=
Date:   Wed, 28 Oct 2020 14:54:22 -0700
From:   akpm@linux-foundation.org
To:     mhocko@kernel.org, mm-commits@vger.kernel.org, sh_def@163.com
Subject:  [to-be-updated]
 mmoom_kill-fix-the-comment-of-is_dump_unreclaim_slabs.patch removed from
 -mm tree
Message-ID: <20201028215422.OffR-s5KT%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/oom_kill.c: fix the comment of is_dump_unreclaim_slabs()
has been removed from the -mm tree.  Its filename was
     mmoom_kill-fix-the-comment-of-is_dump_unreclaim_slabs.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Hui Su <sh_def@163.com>
Subject: mm/oom_kill.c: fix the comment of is_dump_unreclaim_slabs()

Fix the comment of is_dump_unreclaim_slabs().  It just checks whether
nr_unreclaimable slabs amount is greater than user memory.

[akpm@linux-foundation.org: remove incorrect kerneldoc token]
Link: https://lkml.kernel.org/r/20200926041526.GA179745@rlk
Signed-off-by: Hui Su <sh_def@163.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/oom_kill.c~mmoom_kill-fix-the-comment-of-is_dump_unreclaim_slabs
+++ a/mm/oom_kill.c
@@ -171,8 +171,8 @@ static bool oom_unkillable_task(struct t
 }
 
 /*
- * Print out unreclaimble slabs info when unreclaimable slabs amount is greater
- * than all user memory (LRU pages)
+ * Check whether unreclaimable slabs amount is greater than
+ * all user memory(LRU pages).
  */
 static bool is_dump_unreclaim_slabs(void)
 {
_

Patches currently in -mm which might be from sh_def@163.com are

mmslab_common-use-list_for_each_entry-in-dump_unreclaimable_slab.patch
mm-hugetlbc-just-use-put_page_testzero-instead-of-page_count.patch
acctc-use-elif-instead-of-end-and-elif.patch

