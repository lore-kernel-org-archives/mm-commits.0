From: akpm@linux-foundation.org
Subject: [merged] bio-use-a-static-inline-function-for-bio_integrity_clone.patch removed from -mm tree
Date: Thu, 17 Nov 2011 12:21:47 -0800
Message-ID: <201111172021.pAHKLl7j023391@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:33946 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203Ab1KQUVu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Nov 2011 15:21:50 -0500
Received: by mail-ey0-f202.google.com with SMTP id 5so48436eyg.1
        for <mm-commits@vger.kernel.org>; Thu, 17 Nov 2011 12:21:49 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, axboe@kernel.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/bio.h: use a static inline function for bio_integrity_clone()
has been removed from the -mm tree.  Its filename was
     bio-use-a-static-inline-function-for-bio_integrity_clone.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: include/linux/bio.h: use a static inline function for bio_integrity_clone()

When CONFIG_BLK_DEV_INTEGRITY is not set, we get these warnings:

drivers/md/dm.c: In function 'split_bvec':
drivers/md/dm.c:1061:3: warning: statement with no effect
drivers/md/dm.c: In function 'clone_bio':
drivers/md/dm.c:1088:3: warning: statement with no effect

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bio.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN include/linux/bio.h~bio-use-a-static-inline-function-for-bio_integrity_clone include/linux/bio.h
--- a/include/linux/bio.h~bio-use-a-static-inline-function-for-bio_integrity_clone
+++ a/include/linux/bio.h
@@ -519,7 +519,11 @@ extern void bio_integrity_init(void);
 #define bioset_integrity_create(a, b)	(0)
 #define bio_integrity_prep(a)		(0)
 #define bio_integrity_enabled(a)	(0)
-#define bio_integrity_clone(a, b, c, d)	(0)
+static inline int bio_integrity_clone(struct bio *bio, struct bio *bio_src,
+				      gfp_t gfp_mask, struct bio_set *bs)
+{
+	return 0;
+}
 #define bioset_integrity_free(a)	do { } while (0)
 #define bio_integrity_free(a, b)	do { } while (0)
 #define bio_integrity_endio(a, b)	do { } while (0)
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

origin.patch
linux-next.patch
ipc-mqueue-update-maximums-for-the-mqueue-subsystem-fix.patch
consolidate-config_debug_strict_user_copy_checks.patch
cgroups-add-a-task-counter-subsystem-fix.patch
dio-optimize-cache-misses-in-the-submission-path-v2-fix.patch

