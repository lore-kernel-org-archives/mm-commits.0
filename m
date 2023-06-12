Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCFB8C7EE43
	for <mm-commits@archiver.kernel.org>; Mon, 12 Jun 2023 21:46:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237905AbjFLVqL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Jun 2023 17:46:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbjFLVqK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Jun 2023 17:46:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3FBBD2
        for <mm-commits@vger.kernel.org>; Mon, 12 Jun 2023 14:46:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 616A46204F
        for <mm-commits@vger.kernel.org>; Mon, 12 Jun 2023 21:46:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBA53C433EF;
        Mon, 12 Jun 2023 21:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686606368;
        bh=7i5IXlnia3AfdKOS91ccgfUNrF35oBMzowNVNwZHCIQ=;
        h=Date:To:From:Subject:From;
        b=2YNcN0XzPpduFGz60AhPaatOll9P49h8sXq3mNeVcUBKz/l0hylXrjgTlqDTWiGNm
         EiRA1w2Vyak+e1XmSj31Xwi9Y4RYktZ8GMIsfRG3KmFqv/QM9HLP8Hz+wqpSYfRTZp
         GfS9LORXcH4T/6/2vkAtl6VNbeNNQ8mfhzVrttls=
Date:   Mon, 12 Jun 2023 14:46:07 -0700
To:     mm-commits@vger.kernel.org, ndesaulniers@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-use-define_read_mostly_hashtable-macro.patch added to mm-unstable branch
Message-Id: <20230612214608.BBA53C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/khugepaged: use DEFINE_READ_MOSTLY_HASHTABLE macro
has been added to the -mm mm-unstable branch.  Its filename is
     mm-khugepaged-use-define_read_mostly_hashtable-macro.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-use-define_read_mostly_hashtable-macro.patch

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
From: Nick Desaulniers <ndesaulniers@google.com>
Subject: mm/khugepaged: use DEFINE_READ_MOSTLY_HASHTABLE macro
Date: Fri, 09 Jun 2023 16:44:45 -0700

These are equivalent, but DEFINE_READ_MOSTLY_HASHTABLE exists to define
a hashtable in the .data..read_mostly section.

Link: https://lkml.kernel.org/r/20230609-khugepage-v1-1-dad4e8382298@google.com
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/khugepaged.c~mm-khugepaged-use-define_read_mostly_hashtable-macro
+++ a/mm/khugepaged.c
@@ -88,7 +88,7 @@ static unsigned int khugepaged_max_ptes_
 static unsigned int khugepaged_max_ptes_shared __read_mostly;
 
 #define MM_SLOTS_HASH_BITS 10
-static __read_mostly DEFINE_HASHTABLE(mm_slots_hash, MM_SLOTS_HASH_BITS);
+static DEFINE_READ_MOSTLY_HASHTABLE(mm_slots_hash, MM_SLOTS_HASH_BITS);
 
 static struct kmem_cache *mm_slot_cache __read_mostly;
 
_

Patches currently in -mm which might be from ndesaulniers@google.com are

mm-khugepaged-use-define_read_mostly_hashtable-macro.patch

