Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69B66C001DB
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 22:59:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237060AbjHKW7h (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 18:59:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236980AbjHKW7I (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 18:59:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 976C235A6
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 15:59:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2DE826699C
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 22:59:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89126C433C8;
        Fri, 11 Aug 2023 22:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794744;
        bh=nEGNE/UWHT+teMyvXreYyLyT6GbFTglRoqnUi40aDCo=;
        h=Date:To:From:Subject:From;
        b=yKubLj8010yii4v0Gat66ReYSLDiObCT7flzrqCFVEKv2f/q62jl9tN12Dev+tQWI
         ZEjI/OFSdtXR7KlBkHGDsMbLFBuMUlaFDfemMChagbIf+R5pP0jeZswq6oOeoMvSIT
         TSrg8hmt+NX6BsjbShqPUKtbnZl5lymsaiy0QLZw=
Date:   Fri, 11 Aug 2023 15:59:03 -0700
To:     mm-commits@vger.kernel.org, minchan@kernel.org,
        AVRomanov@sberdevices.ru, avromanov@sberdevices.ru,
        senozhatsky@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zsmalloc-do-not-scan-for-allocated-objects-in-empty-zspage.patch removed from -mm tree
Message-Id: <20230811225904.89126C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: zsmalloc: do not scan for allocated objects in empty zspage
has been removed from the -mm tree.  Its filename was
     zsmalloc-do-not-scan-for-allocated-objects-in-empty-zspage.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zsmalloc: do not scan for allocated objects in empty zspage
Date: Sat, 24 Jun 2023 14:12:14 +0900

Patch series "zsmalloc: small compaction improvements", v2.

A tiny series that can reduce the number of find_alloced_obj() invocations
(which perform a linear scan of sub-page) during compaction.  Inspired by
Alexey Romanov's findings.


This patch (of 3):

zspage migration can terminate as soon as it moves the last allocated
object from the source zspage.  Add a simple helper zspage_empty() that
tests zspage ->inuse on each migration iteration.

Link: https://lkml.kernel.org/r/20230624053120.643409-2-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Suggested-by: Alexey Romanov <AVRomanov@sberdevices.ru>
Reviewed-by: Alexey Romanov <avromanov@sberdevices.ru>
Acked-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/mm/zsmalloc.c~zsmalloc-do-not-scan-for-allocated-objects-in-empty-zspage
+++ a/mm/zsmalloc.c
@@ -1147,6 +1147,11 @@ static bool zspage_full(struct size_clas
 	return get_zspage_inuse(zspage) == class->objs_per_zspage;
 }
 
+static bool zspage_empty(struct zspage *zspage)
+{
+	return get_zspage_inuse(zspage) == 0;
+}
+
 /**
  * zs_lookup_class_index() - Returns index of the zsmalloc &size_class
  * that hold objects of the provided size.
@@ -1625,6 +1630,10 @@ static void migrate_zspage(struct zs_poo
 		obj_idx++;
 		record_obj(handle, free_obj);
 		obj_free(class->size, used_obj);
+
+		/* Stop if there are no more objects to migrate */
+		if (zspage_empty(get_zspage(s_page)))
+			break;
 	}
 
 	/* Remember last position in this iteration */
_

Patches currently in -mm which might be from senozhatsky@chromium.org are


