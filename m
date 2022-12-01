Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35A37C4321E
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:05:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230353AbiLAAFx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:05:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230259AbiLAADw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:03:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62FAC8EE63
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:01:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1BF4BB81AD6
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:01:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD77AC433D6;
        Thu,  1 Dec 2022 00:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852907;
        bh=4DCBEU68fpkT+7/xvlYjWarkFsREGjVKTB7slISV3o4=;
        h=Date:To:From:Subject:From;
        b=bh4kMSWJ8tniqpHw0TclW4juafO9plZ7GS+NghHOVkUZjnNWluQYgUhNjyADt8JI1
         0ZvnaRkg4LNX/AwmSW3tyTVdewC9EwxGC3NRub+eV/W+PfvEH1bOg29sXC9YzHKkX9
         y7R7ktzGHpvwkpxLXdAGRUhCWowgUHIxPm5FlqvU=
Date:   Wed, 30 Nov 2022 16:01:47 -0800
To:     mm-commits@vger.kernel.org, wenjian1@xiaomi.com,
        wenjianhn@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-admin-guide-cgroup-v1-update-description-of-inactive_file.patch removed from -mm tree
Message-Id: <20221201000147.CD77AC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: docs: admin-guide: cgroup-v1: update description of inactive_file
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-cgroup-v1-update-description-of-inactive_file.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jian Wen <wenjianhn@gmail.com>
Subject: docs: admin-guide: cgroup-v1: update description of inactive_file
Date: Fri, 11 Nov 2022 11:46:39 +0800

MADV_FREE pages have been moved into the LRU_INACTIVE_FILE list by commit
f7ad2a6cb9f7 ("mm: move MADV_FREE pages into LRU_INACTIVE_FILE list").

Link: https://lkml.kernel.org/r/20221111034639.3593380-1-wenjian1@xiaomi.com
Signed-off-by: Jian Wen <wenjian1@xiaomi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v1/memory.rst |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/Documentation/admin-guide/cgroup-v1/memory.rst~docs-admin-guide-cgroup-v1-update-description-of-inactive_file
+++ a/Documentation/admin-guide/cgroup-v1/memory.rst
@@ -543,7 +543,8 @@ inactive_anon	# of bytes of anonymous an
 		LRU list.
 active_anon	# of bytes of anonymous and swap cache memory on active
 		LRU list.
-inactive_file	# of bytes of file-backed memory on inactive LRU list.
+inactive_file	# of bytes of file-backed memory and MADV_FREE anonymous memory(
+                LazyFree pages) on inactive LRU list.
 active_file	# of bytes of file-backed memory on active LRU list.
 unevictable	# of bytes of memory that cannot be reclaimed (mlocked etc).
 =============== ===============================================================
_

Patches currently in -mm which might be from wenjianhn@gmail.com are


