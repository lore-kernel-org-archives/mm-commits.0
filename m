From: akpm@linux-foundation.org
Subject: + ocfs2-wait-for-page-writeback-to-provide-stable-pages.patch added to -mm tree
Date: Wed, 23 Jan 2013 13:40:18 -0800
Message-ID: <20130123214019.5F8AE31C071@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:56758 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885Ab3AWVkV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Jan 2013 16:40:21 -0500
Received: by mail-gg0-f201.google.com with SMTP id l2so541944ggn.2
        for <mm-commits@vger.kernel.org>; Wed, 23 Jan 2013 13:40:20 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jack@suse.cz, adrian.hunter@intel.com, axboe@kernel.dk, darrick.wong@oracle.com, dedekind1@gmail.com, ericvh@gmail.com, jlbec@evilplan.org, lucho@ionkov.net, luto@amacapital.net, mfasheh@suse.com, rminnich@sandia.gov, swhiteho@redhat.com


The patch titled
     Subject: ocfs2: wait for page writeback to provide stable pages
has been added to the -mm tree.  Its filename is
     ocfs2-wait-for-page-writeback-to-provide-stable-pages.patch

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
Subject: ocfs2: wait for page writeback to provide stable pages

When stable pages are required, we have to wait if the page is just going
to disk and we want to modify it.  Add proper callback to
ocfs2_grab_pages_for_write().

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Eric Van Hensbergen <ericvh@gmail.com>
Cc: Ron Minnich <rminnich@sandia.gov>
Cc: Latchesar Ionkov <lucho@ionkov.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/ocfs2/aops.c~ocfs2-wait-for-page-writeback-to-provide-stable-pages fs/ocfs2/aops.c
--- a/fs/ocfs2/aops.c~ocfs2-wait-for-page-writeback-to-provide-stable-pages
+++ a/fs/ocfs2/aops.c
@@ -1194,6 +1194,7 @@ static int ocfs2_grab_pages_for_write(st
 				goto out;
 			}
 		}
+		wait_for_stable_page(wc->w_pages[i]);
 
 		if (index == target_index)
 			wc->w_target_page = wc->w_pages[i];
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

