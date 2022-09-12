Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B617ECAAD3
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:29:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229748AbiILD3R (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:29:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229693AbiILD2w (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:28:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52CED275ED
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:28:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0B3A4B80C70
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:28:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8783C433D6;
        Mon, 12 Sep 2022 03:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953315;
        bh=EsVT0dv/yVV4+NGKjIN/W3yVpy/t/NphqaQvvUzaq3g=;
        h=Date:To:From:Subject:From;
        b=GIeeL8Iry+GWRKfHbX9qgegyuCjUmF0ZRwV+FQKEhZ0JS5W/SF7mYueZ/XQR/wjZm
         IptJ2Dae4KrDw4Sk0lnSX5pycIHckRGEKDRWEdl5noFGBVXoFurZ2GBATZJlOMRCIM
         vUJ4buUO5v5C6c7HM9XqbT16cAj5qpoHjwgGNhIY=
Date:   Sun, 11 Sep 2022 20:28:35 -0700
To:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        ngupta@vflare.org, minchan@kernel.org, avromanov@sberdevices.ru,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zsmalloc-zs_object_copy-add-clarifying-comment.patch removed from -mm tree
Message-Id: <20220912032835.A8783C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: zsmalloc: zs_object_copy: add clarifying comment
has been removed from the -mm tree.  Its filename was
     zsmalloc-zs_object_copy-add-clarifying-comment.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

[akpm@linux-foundation.org: tweak comment layout]
Link: https://lkml.kernel.org/r/20220811153755.16102-1-avromanov@sberdevices.ru
Link: https://lkml.kernel.org/r/20220811153755.16102-2-avromanov@sberdevices.ru
Signed-off-by: Alexey Romanov <avromanov@sberdevices.ru>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/zsmalloc.c~zsmalloc-zs_object_copy-add-clarifying-comment
+++ a/mm/zsmalloc.c
@@ -1555,6 +1555,13 @@ static void zs_object_copy(struct size_c
 		d_off += size;
 		d_size -= size;
 
+		/*
+		 * Calling kunmap_atomic(d_addr) is necessary. kunmap_atomic()
+		 * calls must occurs in reverse order of calls to kmap_atomic().
+		 * So, to call kunmap_atomic(s_addr) we should first call
+		 * kunmap_atomic(d_addr).  For more details see
+		 * https://lore.kernel.org/linux-mm/5512421D.4000603@samsung.com/
+		 */
 		if (s_off >= PAGE_SIZE) {
 			kunmap_atomic(d_addr);
 			kunmap_atomic(s_addr);
_

Patches currently in -mm which might be from avromanov@sberdevices.ru are

zsmalloc-use-correct-types-in-_first_obj_offset-functions.patch

