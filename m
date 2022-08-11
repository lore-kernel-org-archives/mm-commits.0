Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F481C19F2A
	for <mm-commits@archiver.kernel.org>; Thu, 11 Aug 2022 21:20:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236128AbiHKVUr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 11 Aug 2022 17:20:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236042AbiHKVUo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 11 Aug 2022 17:20:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4E789BB74
        for <mm-commits@vger.kernel.org>; Thu, 11 Aug 2022 14:20:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 42ABE61465
        for <mm-commits@vger.kernel.org>; Thu, 11 Aug 2022 21:20:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BE6CC433C1;
        Thu, 11 Aug 2022 21:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660252842;
        bh=Id5K/D/tZX3SD+SGRrzQ7i2cq2Lf5LIgNWgWBE3BM+s=;
        h=Date:To:From:Subject:From;
        b=W+A7x7V780GZn9EKQa45Qm+o74gv/HqRecLg73/tWXtJ0NVYxcH7LTxSfda+GbyW+
         tht02775uuCAhbL5UJO0iQXsxCL8HO8o9A+IdLX/18swy6uq94OVCfO3QWwgDECP1X
         mn0FOGKCo/zG+IltK0bCPO0IF09zcUX6hrCNJwH4=
Date:   Thu, 11 Aug 2022 14:20:41 -0700
To:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        ngupta@vflare.org, minchan@kernel.org, avromanov@sberdevices.ru,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zsmalloc-zs_object_copy-add-clarifying-comment.patch added to mm-unstable branch
Message-Id: <20220811212042.8BE6CC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: zs_object_copy: add clarifying comment
has been added to the -mm mm-unstable branch.  Its filename is
     zsmalloc-zs_object_copy-add-clarifying-comment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zsmalloc-zs_object_copy-add-clarifying-comment.patch

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
From: Alexey Romanov <avromanov@sberdevices.ru>
Subject: zsmalloc: zs_object_copy: add clarifying comment
Date: Thu, 11 Aug 2022 18:37:54 +0300

Patch series "tidy up zsmalloc implementation"

This patchset remove some unnecessary checks and adds a clarifying
comment.  While analysing zs_object_copy() function code, I spent some
time to understand what the call kunmap_atomic(d_addr) is for.  It seems
that this point is not trivial and it is worth adding a comment.


This patch (of 2):

It's not obvious why kunmap_atomic(d_addr) call is needed.

Link: https://lkml.kernel.org/r/20220811153755.16102-1-avromanov@sberdevices.ru
Link: https://lkml.kernel.org/r/20220811153755.16102-2-avromanov@sberdevices.ru
Signed-off-by: Alexey Romanov <avromanov@sberdevices.ru>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/zsmalloc.c~zsmalloc-zs_object_copy-add-clarifying-comment
+++ a/mm/zsmalloc.c
@@ -1555,6 +1555,12 @@ static void zs_object_copy(struct size_c
 		d_off += size;
 		d_size -= size;
 
+		/* Calling kunmap_atomic(d_addr) is necessary. kunmap_atomic() calls
+		 * must occurs in reverse order of calls to kmap_atomic().
+		 * So, to call kunmap_atomic(s_addr) we should first call kunmap_atomic(d_addr).
+		 * For more details see:
+		 * https://lore.kernel.org/linux-mm/5512421D.4000603@samsung.com/
+		 */
 		if (s_off >= PAGE_SIZE) {
 			kunmap_atomic(d_addr);
 			kunmap_atomic(s_addr);
_

Patches currently in -mm which might be from avromanov@sberdevices.ru are

zsmalloc-zs_object_copy-add-clarifying-comment.patch
zsmalloc-remove-unnecessary-size_class-null-check.patch

