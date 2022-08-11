Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17C89C25B07
	for <mm-commits@archiver.kernel.org>; Thu, 11 Aug 2022 01:17:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233400AbiHKBRh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Aug 2022 21:17:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbiHKBRc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 10 Aug 2022 21:17:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9133E7B1D4
        for <mm-commits@vger.kernel.org>; Wed, 10 Aug 2022 18:17:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3353E6116C
        for <mm-commits@vger.kernel.org>; Thu, 11 Aug 2022 01:17:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FE32C433D7;
        Thu, 11 Aug 2022 01:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660180650;
        bh=QjLevX7Y5XhYekfj6s0It9wjhH/t+de0JUmRi8aOiko=;
        h=Date:To:From:Subject:From;
        b=jAKVkmOPrjNU0ExZzekxr2kpAZ5lT+qLwXJa8EifVMGFxa5OyCfRpp4qsdvRJfqMa
         aciBayoMZhZyymR2aQzhub1+LLW5uQBWcxzOIy4dLJLwd4f6DAEkH0+WyS9DgLoAjw
         UX9Mmakzj6hemP9VLf3cV+Ec9znGKo8aK1ujpS6I=
Date:   Wed, 10 Aug 2022 18:17:28 -0700
To:     mm-commits@vger.kernel.org, hannes@cmpxchg.org,
        yang.yang29@zte.com.cn, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-define-macros-for-refaults-in-struct-lruvec.patch added to mm-unstable branch
Message-Id: <20220811011730.7FE32C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan: define macros for refaults in struct lruvec
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmscan-define-macros-for-refaults-in-struct-lruvec.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-define-macros-for-refaults-in-struct-lruvec.patch

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
From: Yang Yang <yang.yang29@zte.com.cn>
Subject: mm/vmscan: define macros for refaults in struct lruvec
Date: Mon, 8 Aug 2022 00:56:45 +0000

The magic number 0 and 1 are used in several places in vmscan.c.
Define macros for them to improve code readability.

Link: https://lkml.kernel.org/r/20220808005644.1721066-1-yang.yang29@zte.com.cn
Signed-off-by: Yang Yang <yang.yang29@zte.com.cn>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    2 ++
 mm/vmscan.c            |    8 ++++----
 2 files changed, 6 insertions(+), 4 deletions(-)

--- a/include/linux/mmzone.h~mm-vmscan-define-macros-for-refaults-in-struct-lruvec
+++ a/include/linux/mmzone.h
@@ -306,6 +306,8 @@ static inline bool is_active_lru(enum lr
 	return (lru == LRU_ACTIVE_ANON || lru == LRU_ACTIVE_FILE);
 }
 
+#define WORKINGSET_ANON 0
+#define WORKINGSET_FILE 1
 #define ANON_AND_FILE 2
 
 enum lruvec_flags {
--- a/mm/vmscan.c~mm-vmscan-define-macros-for-refaults-in-struct-lruvec
+++ a/mm/vmscan.c
@@ -3228,7 +3228,7 @@ again:
 
 		refaults = lruvec_page_state(target_lruvec,
 				WORKINGSET_ACTIVATE_ANON);
-		if (refaults != target_lruvec->refaults[0] ||
+		if (refaults != target_lruvec->refaults[WORKINGSET_ANON] ||
 			inactive_is_low(target_lruvec, LRU_INACTIVE_ANON))
 			sc->may_deactivate |= DEACTIVATE_ANON;
 		else
@@ -3241,7 +3241,7 @@ again:
 		 */
 		refaults = lruvec_page_state(target_lruvec,
 				WORKINGSET_ACTIVATE_FILE);
-		if (refaults != target_lruvec->refaults[1] ||
+		if (refaults != target_lruvec->refaults[WORKINGSET_FILE] ||
 		    inactive_is_low(target_lruvec, LRU_INACTIVE_FILE))
 			sc->may_deactivate |= DEACTIVATE_FILE;
 		else
@@ -3557,9 +3557,9 @@ static void snapshot_refaults(struct mem
 
 	target_lruvec = mem_cgroup_lruvec(target_memcg, pgdat);
 	refaults = lruvec_page_state(target_lruvec, WORKINGSET_ACTIVATE_ANON);
-	target_lruvec->refaults[0] = refaults;
+	target_lruvec->refaults[WORKINGSET_ANON] = refaults;
 	refaults = lruvec_page_state(target_lruvec, WORKINGSET_ACTIVATE_FILE);
-	target_lruvec->refaults[1] = refaults;
+	target_lruvec->refaults[WORKINGSET_FILE] = refaults;
 }
 
 /*
_

Patches currently in -mm which might be from yang.yang29@zte.com.cn are

mm-vmscan-define-macros-for-refaults-in-struct-lruvec.patch

