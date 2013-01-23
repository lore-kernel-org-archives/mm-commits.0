From: akpm@linux-foundation.org
Subject: + 9pfs-fix-filesystem-to-wait-for-stable-page-writeback.patch added to -mm tree
Date: Wed, 23 Jan 2013 13:40:09 -0800
Message-ID: <20130123214010.61E815A415F@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:33981 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345Ab3AWVkM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Jan 2013 16:40:12 -0500
Received: by mail-vc0-f201.google.com with SMTP id n11so427208vch.4
        for <mm-commits@vger.kernel.org>; Wed, 23 Jan 2013 13:40:11 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: darrick.wong@oracle.com, adrian.hunter@intel.com, axboe@kernel.dk, dedekind1@gmail.com, ericvh@gmail.com, jack@suse.cz, jlbec@evilplan.org, lucho@ionkov.net, luto@amacapital.net, mfasheh@suse.com, rminnich@sandia.gov, swhiteho@redhat.com


The patch titled
     Subject: 9pfs: fix filesystem to wait for stable page writeback
has been added to the -mm tree.  Its filename is
     9pfs-fix-filesystem-to-wait-for-stable-page-writeback.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: 9pfs: fix filesystem to wait for stable page writeback

Fix up the ->page_mkwrite handler to provide stable page writes if necessary.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Eric Van Hensbergen <ericvh@gmail.com>
Cc: Ron Minnich <rminnich@sandia.gov>
Cc: Latchesar Ionkov <lucho@ionkov.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/9p/vfs_file.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/9p/vfs_file.c~9pfs-fix-filesystem-to-wait-for-stable-page-writeback fs/9p/vfs_file.c
--- a/fs/9p/vfs_file.c~9pfs-fix-filesystem-to-wait-for-stable-page-writeback
+++ a/fs/9p/vfs_file.c
@@ -620,6 +620,7 @@ v9fs_vm_page_mkwrite(struct vm_area_stru
 	lock_page(page);
 	if (page->mapping != inode->i_mapping)
 		goto out_unlock;
+	wait_for_stable_page(page);
 
 	return VM_FAULT_LOCKED;
 out_unlock:
_

Patches currently in -mm which might be from darrick.wong@oracle.com are

bdi-allow-block-devices-to-say-that-they-require-stable-page-writes.patch
mm-only-enforce-stable-page-writes-if-the-backing-device-requires-it.patch
9pfs-fix-filesystem-to-wait-for-stable-page-writeback.patch
block-optionally-snapshot-page-contents-to-provide-stable-pages-during-write.patch
ocfs2-wait-for-page-writeback-to-provide-stable-pages.patch
ubifs-wait-for-page-writeback-to-provide-stable-pages.patch

