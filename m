Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0D0BC7EE29
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:29:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232130AbjFIX3D (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:29:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231981AbjFIX2G (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:28:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E775030E5
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:27:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7CC8F61AE1
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:27:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD705C433EF;
        Fri,  9 Jun 2023 23:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353268;
        bh=X7kSzFn5j0nOdJLvUospcfKBZ6wFcn2K2HY95Ra6YwI=;
        h=Date:To:From:Subject:From;
        b=mSSZvbHF/+Jw2Hv+qoOSVt3E4apDxeloG+KBvcapwMsLxiiPGouLXlWlifwFFzsSR
         AgcPErWhT43Oa6GJvAFz/H0ZtSSsd+UvGV4Z4L4EG/ZJ1YggLUlWBICX8Asw3WZ8Mi
         FpAnlVg3f2dJ6QYau88SVUZ0pgQGAQOjmttDin4s=
Date:   Fri, 09 Jun 2023 16:27:48 -0700
To:     mm-commits@vger.kernel.org, yzaikin@google.com,
        ying.huang@intel.com, rppt@kernel.org, rafael@kernel.org,
        pavel@ucw.cz, osalvador@suse.de, mcgrof@kernel.org,
        len.brown@intel.com, keescook@chromium.org, david@redhat.com,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscan-use-gfp_has_io_fs.patch removed from -mm tree
Message-Id: <20230609232748.CD705C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: vmscan: use gfp_has_io_fs()
has been removed from the -mm tree.  Its filename was
     mm-vmscan-use-gfp_has_io_fs.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: vmscan: use gfp_has_io_fs()
Date: Tue, 16 May 2023 14:38:19 +0800

Use gfp_has_io_fs() instead of open-code.

Link: https://lkml.kernel.org/r/20230516063821.121844-12-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Len Brown <len.brown@intel.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Rafael J. Wysocki <rafael@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-vmscan-use-gfp_has_io_fs
+++ a/mm/vmscan.c
@@ -2458,7 +2458,7 @@ static int too_many_isolated(struct pgli
 	 * won't get blocked by normal direct-reclaimers, forming a circular
 	 * deadlock.
 	 */
-	if ((sc->gfp_mask & (__GFP_IO | __GFP_FS)) == (__GFP_IO | __GFP_FS))
+	if (gfp_has_io_fs(sc->gfp_mask))
 		inactive >>= 3;
 
 	too_many = isolated > inactive;
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


