From: akpm@google.com
Subject: + bio-use-a-static-inline-function-for-bio_integrity_clone.patch added to -mm tree
Date: Thu, 06 Oct 2011 16:23:21 -0700
Message-ID: <201110062323.p96NNLvL005621@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:21757 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965298Ab1JFXXb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Oct 2011 19:23:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sfr@canb.auug.org.au, axboe@kernel.dk


The patch titled
     Subject: include/linux/bio.h: use a static inline function for bio_integrity_clone()
has been added to the -mm tree.  Its filename is
     bio-use-a-static-inline-function-for-bio_integrity_clone.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
Signed-off-by: Andrew Morton <akpm@google.com>
---

 include/linux/bio.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN include/linux/bio.h~bio-use-a-static-inline-function-for-bio_integrity_clone include/linux/bio.h
--- a/include/linux/bio.h~bio-use-a-static-inline-function-for-bio_integrity_clone
+++ a/include/linux/bio.h
@@ -527,7 +527,11 @@ extern void bio_integrity_init(void);
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
Subject: Subject: include/linux/bio.h: use a static inline function for bio_integrity_clone()

Patches currently in -mm which might be from sfr@canb.auug.org.au are

origin.patch
linux-next.patch
ipc-mqueue-update-maximums-for-the-mqueue-subsystem-fix.patch
bio-use-a-static-inline-function-for-bio_integrity_clone.patch
consolidate-config_debug_strict_user_copy_checks.patch
treewide-use-__printf-not-__attribute__formatprintf-fix.patch
cgroups-add-a-task-counter-subsystem-fix.patch
init-add-root=partuuid=uuid-partnroff=%d-support-fix.patch
dio-optimize-cache-misses-in-the-submission-path-v2-fix.patch

