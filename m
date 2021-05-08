Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0FECC433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:43:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D37F861415
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:43:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbhEHWol (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:44:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:52398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229631AbhEHWok (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:44:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A99961402;
        Sat,  8 May 2021 22:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513818;
        bh=dOG9/OQAPQXk36rJ4M9nJGNgwiUhX0cLkwDqsXOyjGY=;
        h=Date:From:To:Subject:From;
        b=cyfoKbnlVpcpH1icG5txg3CuVyxegoEgIyY4PJ8pjPr6vk4dgbVBT4ZfQCFsgabvT
         FRjvIRSbogMgq+ik40ivEHjR1qSIQaOXO1Q2TQZXrTaYwr/mpFr2Hq1fK3xb7Np0Ke
         1zoq+zbR5CloVTUu9c9y4GSOVdH6HxtmsbkeUUHw=
Date:   Sat, 08 May 2021 15:43:38 -0700
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, jhubbard@nvidia.com, mm-commits@vger.kernel.org,
        rppt@linux.ibm.com, willy@infradead.org
Subject:  [merged]
 mm-doc-fix-fault_flag_allow_retry_first-kerneldoc.patch removed from -mm
 tree
Message-ID: <20210508224338.6SyNTmUEq%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/doc: fix fault_flag_allow_retry_first kerneldoc
has been removed from the -mm tree.  Its filename was
     mm-doc-fix-fault_flag_allow_retry_first-kerneldoc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/doc: fix fault_flag_allow_retry_first kerneldoc

make htmldocs reports:

./include/linux/mm.h:496: warning: Function parameter or member 'flags' not described in 'fault_flag_allow_retry_first'

Add a description.

Link: https://lkml.kernel.org/r/20210322195022.2143603-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/mm.h~mm-doc-fix-fault_flag_allow_retry_first-kerneldoc
+++ a/include/linux/mm.h
@@ -485,6 +485,7 @@ extern pgprot_t protection_map[16];
 
 /**
  * fault_flag_allow_retry_first - check ALLOW_RETRY the first time
+ * @flags: Fault flags.
  *
  * This is mostly used for places where we want to try to avoid taking
  * the mmap_lock for too long a time when waiting for another condition
_

Patches currently in -mm which might be from willy@infradead.org are


