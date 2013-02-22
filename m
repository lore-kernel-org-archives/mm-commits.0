From: akpm@linux-foundation.org
Subject: [merged] ocfs2-wait-for-page-writeback-to-provide-stable-pages.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:39:29 -0800
Message-ID: <20130222203929.BD40031C1C1@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:37094 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757190Ab3BVUjb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:39:31 -0500
Received: by mail-vb0-f74.google.com with SMTP id r6so103512vbi.3
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:39:31 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, adrian.hunter@intel.com, axboe@kernel.dk, darrick.wong@oracle.com, dedekind1@gmail.com, ericvh@gmail.com, jlbec@evilplan.org, lucho@ionkov.net, luto@amacapital.net, mfasheh@suse.com, rminnich@sandia.gov, swhiteho@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: wait for page writeback to provide stable pages
has been removed from the -mm tree.  Its filename was
     ocfs2-wait-for-page-writeback-to-provide-stable-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: ocfs2: wait for page writeback to provide stable pages

When stable pages are required, we have to wait if the page is just going
to disk and we want to modify it.  Add proper callback to
ocfs2_grab_pages_for_write().

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Acked-by: Joel Becker <jlbec@evilplan.org>
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

origin.patch
linux-next.patch
fs-change-return-values-from-eacces-to-eperm.patch
fs-return-eagain-when-o_nonblock-write-should-block-on-frozen-fs.patch
fs-fix-hang-with-bsd-accounting-on-frozen-filesystem.patch
ocfs2-add-freeze-protection-to-ocfs2_file_splice_write.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch
hfsplus-add-on-disk-layout-declarations-related-to-attributes-tree.patch
hfsplus-add-functionality-of-manipulating-by-records-in-attributes-tree.patch
hfsplus-rework-functionality-of-getting-setting-and-deleting-of-extended-attributes.patch
hfsplus-add-support-of-manipulation-by-attributes-file.patch
hfsplus-fix-issue-with-unzeroed-unused-b-tree-nodes.patch
ocfs2-fix-possible-use-after-free-with-aio.patch
fs-direct-ioc-fix-possible-use-after-free-with-aio.patch

