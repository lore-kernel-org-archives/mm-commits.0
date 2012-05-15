From: akpm@linux-foundation.org
Subject: + floppy-remove-floppy-specific-o_excl-handling-v2.patch added to -mm tree
Date: Tue, 15 May 2012 14:20:20 -0700
Message-ID: <20120515212020.C3BACA028F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:45218 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966192Ab2EOVUW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 May 2012 17:20:22 -0400
Received: by vbnl22 with SMTP id l22so11271vbn.1
        for <mm-commits@vger.kernel.org>; Tue, 15 May 2012 14:20:21 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jkosina@suse.cz, axboe@kernel.dk, joe@perches.com, neilb@suse.de, tj@kernel.org


The patch titled
     Subject: floppy-remove-floppy-specific-o_excl-handling-v2
has been added to the -mm tree.  Its filename is
     floppy-remove-floppy-specific-o_excl-handling-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: floppy-remove-floppy-specific-o_excl-handling-v2

Patches currently in -mm which might be from jkosina@suse.cz are

origin.patch
linux-next.patch
floppy-remove-floppy-specific-o_excl-handling.patch
floppy-remove-floppy-specific-o_excl-handling-v2.patch

