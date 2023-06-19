Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4839DEB64DB
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:26:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbjFSX0W (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:26:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbjFSXY3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:24:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F47F19B9
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:23:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3A8C260FBF
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:23:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92785C433C8;
        Mon, 19 Jun 2023 23:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216981;
        bh=C4JpKyzy9+UhqxDd7pHXNe1iLvSBWm5kyqCvSUHaJ2E=;
        h=Date:To:From:Subject:From;
        b=ezMzFIlf5+GeywtVAIcUWfL4Sl4+VwxCMexLZdlvNOK3lfpz0fIWp4zoWob+0XkPK
         ysaSzy8trXJUfKcJHcZ4fHb/6sF3oiwxPZJpxrZJL3ZUYRZKEOiKkWqmO8F0ce60Dz
         cNE8CTG2sKRWTWbW3r+Zd/tnHl51HKPI7jHkCPWk=
Date:   Mon, 19 Jun 2023 16:23:00 -0700
To:     mm-commits@vger.kernel.org, shy828301@gmail.com,
        ndesaulniers@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-use-define_read_mostly_hashtable-macro.patch removed from -mm tree
Message-Id: <20230619232301.92785C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/khugepaged: use DEFINE_READ_MOSTLY_HASHTABLE macro
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-use-define_read_mostly_hashtable-macro.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nick Desaulniers <ndesaulniers@google.com>
Subject: mm/khugepaged: use DEFINE_READ_MOSTLY_HASHTABLE macro
Date: Fri, 09 Jun 2023 16:44:45 -0700

These are equivalent, but DEFINE_READ_MOSTLY_HASHTABLE exists to define
a hashtable in the .data..read_mostly section.

Link: https://lkml.kernel.org/r/20230609-khugepage-v1-1-dad4e8382298@google.com
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
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


