Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2BFAEB64D9
	for <mm-commits@archiver.kernel.org>; Sun,  2 Jul 2023 23:34:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbjGBXeZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 2 Jul 2023 19:34:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbjGBXeZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 2 Jul 2023 19:34:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45F6AE40
        for <mm-commits@vger.kernel.org>; Sun,  2 Jul 2023 16:34:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D4EFE60CD4
        for <mm-commits@vger.kernel.org>; Sun,  2 Jul 2023 23:34:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E948C433C9;
        Sun,  2 Jul 2023 23:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688340863;
        bh=pyNSNCPDI6ZsmZO0WamR8LfBKyDxfDhbh17+hp4/Yvw=;
        h=Date:To:From:Subject:From;
        b=tP6wnohOi2cXn9vllDvzqSQCF9rrovxiu7kcSIvHXa47lxPmjpupr/4IO5Rb38HKP
         BB2W/IwJ0lGhUbHoSlERgF6UxBfR3Q6MLtRqtBBv9j5Ix2Kpxb1a8GPb/8wmJKNRgh
         KEEXGtpvJ1KCd5OIXj2fmvM+u4MzJywkUPY8wYh8=
Date:   Sun, 02 Jul 2023 16:34:22 -0700
To:     mm-commits@vger.kernel.org, minchan@kernel.org,
        AVRomanov@sberdevices.ru, avromanov@sberdevices.ru,
        senozhatsky@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zsmalloc-do-not-scan-for-allocated-objects-in-empty-zspage.patch added to mm-unstable branch
Message-Id: <20230702233423.2E948C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: do not scan for allocated objects in empty zspage
has been added to the -mm mm-unstable branch.  Its filename is
     zsmalloc-do-not-scan-for-allocated-objects-in-empty-zspage.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zsmalloc-do-not-scan-for-allocated-objects-in-empty-zspage.patch

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

zsmalloc-do-not-scan-for-allocated-objects-in-empty-zspage.patch
zsmalloc-move-migration-destination-zspage-inuse-check.patch

