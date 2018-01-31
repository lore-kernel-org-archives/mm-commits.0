From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-zsmalloc-simplify-shrinker-init-destroy-fix.patch removed from -mm tree
Date: Wed, 31 Jan 2018 15:58:07 -0800
Message-ID: <5a72580f.aavjIMhuq789HHOn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57392 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752209AbeAaX6J (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Jan 2018 18:58:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, akaraliou.dev@gmail.com, mhocko@kernel.org, minchan@kernel.org, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-zsmalloc-simplify-shrinker-init-destroy-fix
has been removed from the -mm tree.  Its filename was
     mm-zsmalloc-simplify-shrinker-init-destroy-fix.patch

This patch was dropped because it was folded into mm-zsmalloc-simplify-shrinker-init-destroy.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-zsmalloc-simplify-shrinker-init-destroy-fix

update comment (Aliaksei), remove unneeded cast

Cc: Aliaksei Karaliou <akaraliou.dev@gmail.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN mm/zsmalloc.c~mm-zsmalloc-simplify-shrinker-init-destroy-fix mm/zsmalloc.c
--- a/mm/zsmalloc.c~mm-zsmalloc-simplify-shrinker-init-destroy-fix
+++ a/mm/zsmalloc.c
@@ -2420,10 +2420,12 @@ struct zs_pool *zs_create_pool(const cha
 		goto err;
 
 	/*
-	 * Not critical, we still can use the pool
-	 * and user can trigger compaction manually.
+	 * Not critical since shrinker is only used to trigger internal
+	 * defragmentation of the pool which is pretty optional thing.  If
+	 * registration fails we still can use the pool normally and user can
+	 * trigger compaction manually. Thus, ignore return code.
 	 */
-	(void) zs_register_shrinker(pool);
+	zs_register_shrinker(pool);
 
 	return pool;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-zsmalloc-simplify-shrinker-init-destroy.patch
mm-fadvise-discard-partial-page-if-endbyte-is-also-eof-fix.patch
mm-page_owner-clean-up-init_pages_in_zone-v3-fix.patch
tools-vm-new-option-to-specify-kpageflags-file-fix.patch

