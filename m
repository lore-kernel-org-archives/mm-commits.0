From: akpm@linux-foundation.org
Subject: [merged] floppy-remove-floppy-specific-o_excl-handling-v2.patch removed from -mm tree
Date: Wed, 23 May 2012 12:51:15 -0700
Message-ID: <20120523195115.7010EA0210@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:35981 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932897Ab2EWTvS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 May 2012 15:51:18 -0400
Received: by wibhn6 with SMTP id hn6so311158wib.1
        for <mm-commits@vger.kernel.org>; Wed, 23 May 2012 12:51:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jkosina@suse.cz, axboe@kernel.dk, joe@perches.com, neilb@suse.de, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: floppy-remove-floppy-specific-o_excl-handling-v2
has been removed from the -mm tree.  Its filename was
     floppy-remove-floppy-specific-o_excl-handling-v2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Jiri Kosina <jkosina@suse.cz>
Subject: floppy-remove-floppy-specific-o_excl-handling-v2

> As we no longer set fd_ref to -1, you should also remove:
>
> 	if (UDRS->fd_ref < 0)
> 		UDRS->fd_ref = 0;
> 	else
>
> from floppy_release(), and the 'out:' section of floppy_open().
>

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: NeilBrown <neilb@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/floppy.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff -puN drivers/block/floppy.c~floppy-remove-floppy-specific-o_excl-handling-v2 drivers/block/floppy.c
--- a/drivers/block/floppy.c~floppy-remove-floppy-specific-o_excl-handling-v2
+++ a/drivers/block/floppy.c
@@ -3612,9 +3612,7 @@ static int floppy_release(struct gendisk
 
 	mutex_lock(&floppy_mutex);
 	mutex_lock(&open_lock);
-	if (UDRS->fd_ref < 0)
-		UDRS->fd_ref = 0;
-	else if (!UDRS->fd_ref--) {
+	if (!UDRS->fd_ref--) {
 		DPRINT("floppy_release with fd_ref == 0");
 		UDRS->fd_ref = 0;
 	}
@@ -3713,10 +3711,8 @@ static int floppy_open(struct block_devi
 	mutex_unlock(&floppy_mutex);
 	return 0;
 out:
-	if (UDRS->fd_ref < 0)
-		UDRS->fd_ref = 0;
-	else
-		UDRS->fd_ref--;
+	UDRS->fd_ref--;
+
 	if (!UDRS->fd_ref)
 		opened_bdev[drive] = NULL;
 out2:
_

Patches currently in -mm which might be from jkosina@suse.cz are

origin.patch
linux-next.patch

