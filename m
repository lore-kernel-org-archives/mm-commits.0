Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FD0AC61DA4
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 00:58:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230501AbjBJA6U (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Feb 2023 19:58:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230194AbjBJA4Y (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2023 19:56:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 416B070967
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 16:54:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C193C61BA3
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 00:54:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B220C433EF;
        Fri, 10 Feb 2023 00:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675990489;
        bh=W4zJKvTlZ5OjMRIt4qoNNBFjcxYNbQeJE/crfsgu/Lc=;
        h=Date:To:From:Subject:From;
        b=aiMNonvUZeKZi1ulrAHiTnxPcs/U7iuS82i+BQYYVxP03iEdr7hpMKApH70dO3nbC
         OfmP4W6SJ9f2+KDTqz3d5K4+zDYcGL8IvS/coeWEgobElvLmIERFXppyA3Iox1C+DG
         mmvcLOUz7Y0EYgToDKeesrw7Cx52q/9+LJ7Ydcsc=
Date:   Thu, 09 Feb 2023 16:54:48 -0800
To:     mm-commits@vger.kernel.org, dan.j.williams@intel.com,
        lizhijian@fujitsu.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memremapc-fix-outdated-comment-in-devm_memremap_pages.patch removed from -mm tree
Message-Id: <20230210005449.2B220C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/memremap.c: fix outdated comment in devm_memremap_pages
has been removed from the -mm tree.  Its filename was
     mm-memremapc-fix-outdated-comment-in-devm_memremap_pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Li Zhijian <lizhijian@fujitsu.com>
Subject: mm/memremap.c: fix outdated comment in devm_memremap_pages
Date: Tue, 7 Feb 2023 06:27:00 +0000

commit a4574f63edc6 ("mm/memremap_pages: convert to 'struct range'")
converted res to range, update the comment correspondingly.

Link: https://lkml.kernel.org/r/1675751220-2-1-git-send-email-lizhijian@fujitsu.com
Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memremap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memremap.c~mm-memremapc-fix-outdated-comment-in-devm_memremap_pages
+++ a/mm/memremap.c
@@ -385,7 +385,7 @@ EXPORT_SYMBOL_GPL(memremap_pages);
  * @pgmap: pointer to a struct dev_pagemap
  *
  * Notes:
- * 1/ At a minimum the res and type members of @pgmap must be initialized
+ * 1/ At a minimum the range and type members of @pgmap must be initialized
  *    by the caller before passing it to this function
  *
  * 2/ The altmap field may optionally be initialized, in which case
_

Patches currently in -mm which might be from lizhijian@fujitsu.com are


