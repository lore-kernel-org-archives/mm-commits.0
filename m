From: akpm@linux-foundation.org
Subject: + ubifs-wait-for-page-writeback-to-provide-stable-pages.patch added to -mm tree
Date: Wed, 23 Jan 2013 13:40:22 -0800
Message-ID: <20130123214023.5FC135A419C@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:37176 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885Ab3AWVkZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Jan 2013 16:40:25 -0500
Received: by mail-ve0-f202.google.com with SMTP id ox1so107178veb.1
        for <mm-commits@vger.kernel.org>; Wed, 23 Jan 2013 13:40:24 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jack@suse.cz, adrian.hunter@intel.com, axboe@kernel.dk, darrick.wong@oracle.com, dedekind1@gmail.com, ericvh@gmail.com, jlbec@evilplan.org, lucho@ionkov.net, luto@amacapital.net, mfasheh@suse.com, rminnich@sandia.gov, swhiteho@redhat.com


The patch titled
     Subject: ubifs: wait for page writeback to provide stable pages
has been added to the -mm tree.  Its filename is
     ubifs-wait-for-page-writeback-to-provide-stable-pages.patch

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
Subject: ubifs: wait for page writeback to provide stable pages

When stable pages are required, we have to wait if the page is just going
to disk and we want to modify it.  Add proper callback to
ubifs_vm_page_mkwrite().

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Cc: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Eric Van Hensbergen <ericvh@gmail.com>
Cc: Ron Minnich <rminnich@sandia.gov>
Cc: Latchesar Ionkov <lucho@ionkov.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ubifs/file.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/ubifs/file.c~ubifs-wait-for-page-writeback-to-provide-stable-pages fs/ubifs/file.c
--- a/fs/ubifs/file.c~ubifs-wait-for-page-writeback-to-provide-stable-pages
+++ a/fs/ubifs/file.c
@@ -1522,6 +1522,7 @@ static int ubifs_vm_page_mkwrite(struct 
 			ubifs_release_dirty_inode_budget(c, ui);
 	}
 
+	wait_for_stable_page(page);
 	unlock_page(page);
 	return 0;
 
_

Patches currently in -mm which might be from jack@suse.cz are

linux-next.patch
fs-change-return-values-from-eacces-to-eperm.patch
bdi-allow-block-devices-to-say-that-they-require-stable-page-writes.patch
mm-only-enforce-stable-page-writes-if-the-backing-device-requires-it.patch
9pfs-fix-filesystem-to-wait-for-stable-page-writeback.patch
block-optionally-snapshot-page-contents-to-provide-stable-pages-during-write.patch
ocfs2-wait-for-page-writeback-to-provide-stable-pages.patch
ubifs-wait-for-page-writeback-to-provide-stable-pages.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch
hfsplus-add-on-disk-layout-declarations-related-to-attributes-tree.patch
hfsplus-add-functionality-of-manipulating-by-records-in-attributes-tree.patch
hfsplus-rework-functionality-of-getting-setting-and-deleting-of-extended-attributes.patch
hfsplus-add-support-of-manipulation-by-attributes-file.patch

