From: akpm@linux-foundation.org
Subject: + fsnotify-fix-check-in-inotify-fdinfo-printing.patch added to
 -mm tree
Date: Wed, 15 Jul 2015 13:41:56 -0700
Message-ID: <55a6c594.w54shc36CBRoiWN4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55989 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753362AbbGOUl4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Jul 2015 16:41:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: fsnotify: fix check in inotify fdinfo printing
has been added to the -mm tree.  Its filename is
     fsnotify-fix-check-in-inotify-fdinfo-printing.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fsnotify-fix-check-in-inotify-fdinfo-printing.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fsnotify-fix-check-in-inotify-fdinfo-printing.patch

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
Subject: fsnotify: fix check in inotify fdinfo printing

A check in inotify_fdinfo() checking whether mark is valid was always true
due to a bug.  Luckily we can never get to invalidated marks since we hold
mark_mutex and invalidated marks get removed from the group list when they
are invalidated under that mutex.

Anyway fix the check to make code more future proof.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/fdinfo.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/notify/fdinfo.c~fsnotify-fix-check-in-inotify-fdinfo-printing fs/notify/fdinfo.c
--- a/fs/notify/fdinfo.c~fsnotify-fix-check-in-inotify-fdinfo-printing
+++ a/fs/notify/fdinfo.c
@@ -76,7 +76,8 @@ static void inotify_fdinfo(struct seq_fi
 	struct inotify_inode_mark *inode_mark;
 	struct inode *inode;
 
-	if (!(mark->flags & (FSNOTIFY_MARK_FLAG_ALIVE | FSNOTIFY_MARK_FLAG_INODE)))
+	if (!(mark->flags & FSNOTIFY_MARK_FLAG_ALIVE) ||
+	    !(mark->flags & FSNOTIFY_MARK_FLAG_INODE))
 		return;
 
 	inode_mark = container_of(mark, struct inotify_inode_mark, fsn_mark);
_

Patches currently in -mm which might be from jack@suse.cz are

fsnotify-fix-oops-in-fsnotify_clear_marks_by_group_flags.patch
fsnotify-fix-check-in-inotify-fdinfo-printing.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
thp-vma_adjust_trans_huge-adjust-file-backed-vma-too.patch
dax-move-dax-related-functions-to-a-new-header.patch
thp-prepare-for-dax-huge-pages.patch
mm-add-a-pmd_fault-handler.patch
mm-export-various-functions-for-the-benefit-of-dax.patch
mm-add-vmf_insert_pfn_pmd.patch
dax-add-huge-page-fault-support.patch
ext2-huge-page-fault-support.patch
ext4-huge-page-fault-support.patch
xfs-huge-page-fault-support.patch
fs-mpagec-forgotten-write_sync-in-case-of-data-integrity-write.patch
kstrto-accept-0-for-signed-conversion.patch
add-parse_integer-replacement-for-simple_strto.patch
parse_integer-add-runtime-testsuite.patch
parse_integer-convert-ext2-ext3-ext4.patch
mm-add-strictlimit-knob-v2.patch

