From: akpm@linux-foundation.org
Subject: + writeback-do-not-sync-data-dirtied-after-sync-start-fix-2.patch added to -mm tree
Date: Thu, 10 Oct 2013 12:59:49 -0700
Message-ID: <52570735.ec13z5H4ptbm6sPE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36709 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755783Ab3JJT7u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 Oct 2013 15:59:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, fengguang.wu@intel.com, dchinner@redhat.com, jack@suse.cz

Subject: + writeback-do-not-sync-data-dirtied-after-sync-start-fix-2.patch added to -mm tree
To: jack@suse.cz,dchinner@redhat.com,fengguang.wu@intel.com
From: akpm@linux-foundation.org
Date: Thu, 10 Oct 2013 12:59:49 -0700


The patch titled
     Subject: writeback-do-not-sync-data-dirtied-after-sync-start-fix-2.txt
has been added to the -mm tree.  Its filename is
     writeback-do-not-sync-data-dirtied-after-sync-start-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/writeback-do-not-sync-data-dirtied-after-sync-start-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/writeback-do-not-sync-data-dirtied-after-sync-start-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: writeback-do-not-sync-data-dirtied-after-sync-start-fix-2.txt

On Wed 09-10-13 14:21:25, Andrew Morton wrote:
> On Wed, 9 Oct 2013 17:03:25 +0200 Jan Kara <jack@suse.cz> wrote:
>
> > From: Jan Kara <jack@suse.cz>
> > Date: Wed, 9 Oct 2013 15:41:50 +0200
> > Subject: [PATCH] writeback: Use older_than_this_is_set instead of magic
> >  older_than_this == 0
> >
> > Currently we use 0 as a special value of work->older_than_this to
> > indicate that wb_writeback() should set work->older_that_this to current
> > time. This works but it is a bit magic. So use a special flag in
> > work_struct for that.
>
> OK.
>
> > -	if (!work->older_than_this)
> > +	if (!work->older_than_this_is_set)
> > 		work->older_than_this = jiffies;
>
> It would be logical although presumably unneeded to set
> older_than_this_is_set here?
  Yes. Updated.

> > Also fixup writeback from workqueue rescuer to include all inodes.
>
> There's nothing in the patch which matches this sentence?
  The sentence is about the hunk below. writeback_inodes_wb() is special in
that it directly calls queue_io() (everything else goes through
wb_writeback()) and my previous patch thus resulted in using 0 as an
older_than_this value => likely we wouldn't queue any inodes for writeback.

I've added WARN_ON_ONCE into move_expired_inodes() to increase a chance of
catching such mistakes in future (although in this particular case it
wouldn't really help because writeback_inodes_wb() gets hardly ever
called).

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Cc: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN fs/fs-writeback.c~writeback-do-not-sync-data-dirtied-after-sync-start-fix-2 fs/fs-writeback.c
--- a/fs/fs-writeback.c~writeback-do-not-sync-data-dirtied-after-sync-start-fix-2
+++ a/fs/fs-writeback.c
@@ -251,6 +251,7 @@ static int move_expired_inodes(struct li
 	int do_sb_sort = 0;
 	int moved = 0;
 
+	WARN_ON_ONCE(!work->older_than_this_is_set);
 	while (!list_empty(delaying_queue)) {
 		inode = wb_inode(delaying_queue->prev);
 		if (inode_dirtied_after(inode, work->older_than_this))
@@ -800,8 +801,10 @@ static long wb_writeback(struct bdi_writ
 	struct inode *inode;
 	long progress;
 
-	if (!work->older_than_this_is_set)
+	if (!work->older_than_this_is_set) {
 		work->older_than_this = jiffies;
+		work->older_than_this_is_set = 1;
+	}
 
 	spin_lock(&wb->list_lock);
 	for (;;) {
_

Patches currently in -mm which might be from jack@suse.cz are

ocfs2-dont-spam-on-edquot.patch
writeback-do-not-sync-data-dirtied-after-sync-start.patch
writeback-do-not-sync-data-dirtied-after-sync-start-fix.patch
writeback-do-not-sync-data-dirtied-after-sync-start-fix-2.patch
linux-next.patch

