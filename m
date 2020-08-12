Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B0C1C433E1
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:02:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5024C20838
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266156;
	bh=00eEvFLozIiQqP/LxbejGawx17W168cFE2dAlayYgh0=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=MlAidWA/bSA74sfZJ9SfgcMEf4jYPQYoKvtfgLPuPsmLkBJG0iD3TyDqKOLYwIWhb
	 61H5dWfBd+M/A4GJNtz4jmDZAdgxPdiB83Qu3pI1Y6kSS8EPWl/5xgHy6swB/cnYqj
	 OCjKPusov0Cj3AiQg+HcjWs/4j8NB4QkWN8ZVsPY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726564AbgHLVCg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:02:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:50116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726526AbgHLVCf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:02:35 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74CBF207F7;
        Wed, 12 Aug 2020 21:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266155;
        bh=00eEvFLozIiQqP/LxbejGawx17W168cFE2dAlayYgh0=;
        h=Date:From:To:Subject:From;
        b=I8lC7HEQLwsozMJsfD9ZpwoX72RjJMyVyEh3/OkRv7Jh4xeXcdDGaWDgbmNBebhwB
         8IOwpXiQbKAGkawqMg+cbQOpiL8PzMofS/BZmCUGh18hP2tmvIj6FbofZrTAA7Ty3U
         IXixMZ9uaGRm2yJd3PGN5vj/sBtHJ6tOEwEd/J+E=
Date:   Wed, 12 Aug 2020 14:02:35 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rdunlap@infradead.org, sjpark@amazon.de
Subject:  [merged] mm-drop-duplicated-words-in-linux-mmh.patch
 removed from -mm tree
Message-ID: <20200812210235.Z9oPzalUn%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: drop duplicated words in <linux/mm.h>
has been removed from the -mm tree.  Its filename was
     mm-drop-duplicated-words-in-linux-mmh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: mm: drop duplicated words in <linux/mm.h>

Drop the doubled words "to" and "the".

Link: http://lkml.kernel.org/r/d9fae8d6-0d60-4d52-9385-3199ee98de49@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: SeongJae Park <sjpark@amazon.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/mm.h~mm-drop-duplicated-words-in-linux-mmh
+++ a/include/linux/mm.h
@@ -479,7 +479,7 @@ static inline bool fault_flag_allow_retr
 	{ FAULT_FLAG_INTERRUPTIBLE,	"INTERRUPTIBLE" }
 
 /*
- * vm_fault is filled by the the pagefault handler and passed to the vma's
+ * vm_fault is filled by the pagefault handler and passed to the vma's
  * ->fault function. The vma's ->fault is responsible for returning a bitmask
  * of VM_FAULT_xxx flags that give details about how the fault was handled.
  *
@@ -2599,7 +2599,7 @@ extern unsigned long stack_guard_gap;
 /* Generic expand stack which grows the stack according to GROWS{UP,DOWN} */
 extern int expand_stack(struct vm_area_struct *vma, unsigned long address);
 
-/* CONFIG_STACK_GROWSUP still needs to to grow downwards at some places */
+/* CONFIG_STACK_GROWSUP still needs to grow downwards at some places */
 extern int expand_downwards(struct vm_area_struct *vma,
 		unsigned long address);
 #if VM_GROWSUP
_

Patches currently in -mm which might be from rdunlap@infradead.org are


