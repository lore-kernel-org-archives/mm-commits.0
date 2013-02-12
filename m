From: akpm@linux-foundation.org
Subject: + fs-fix-hang-with-bsd-accounting-on-frozen-filesystem.patch added to -mm tree
Date: Tue, 12 Feb 2013 15:16:35 -0800
Message-ID: <20130212231636.5DA4531C200@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:44595 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756723Ab3BLXQh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Feb 2013 18:16:37 -0500
Received: by mail-gg0-f202.google.com with SMTP id l4so524211ggi.3
        for <mm-commits@vger.kernel.org>; Tue, 12 Feb 2013 15:16:37 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jack@suse.cz, dchinner@redhat.com, jlbec@evilplan.org, marco.stornelli@gmail.com, mfasheh@suse.com, nikola.ciprich@linuxbox.cz, viro@ZenIV.linux.org.uk


The patch titled
     Subject: fs: fix hang with BSD accounting on frozen filesystem
has been added to the -mm tree.  Its filename is
     fs-fix-hang-with-bsd-accounting-on-frozen-filesystem.patch

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
Subject: fs: fix hang with BSD accounting on frozen filesystem

When BSD process accounting is enabled and logs information to a
filesystem which gets frozen, system easily becomes unusable because each
attempt to account process information blocks.  Thus e.g.  every task gets
blocked in exit.

It seems better to drop accounting information (which can already happen
when filesystem is running out of space) instead of locking system up.  So
we open the accounting file with O_NONBLOCK.

Signed-off-by: Jan Kara <jack@suse.cz>
Reported-by: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Tested-by: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Marco Stornelli <marco.stornelli@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/acct.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN kernel/acct.c~fs-fix-hang-with-bsd-accounting-on-frozen-filesystem kernel/acct.c
--- a/kernel/acct.c~fs-fix-hang-with-bsd-accounting-on-frozen-filesystem
+++ a/kernel/acct.c
@@ -201,7 +201,8 @@ static int acct_on(struct filename *path
 	struct bsd_acct_struct *acct = NULL;
 
 	/* Difference from BSD - they don't do O_APPEND */
-	file = file_open_name(pathname, O_WRONLY|O_APPEND|O_LARGEFILE, 0);
+	file = file_open_name(pathname,
+			      O_WRONLY|O_APPEND|O_LARGEFILE|O_NONBLOCK, 0);
 	if (IS_ERR(file))
 		return PTR_ERR(file);
 
_

Patches currently in -mm which might be from jack@suse.cz are

linux-next.patch
fs-change-return-values-from-eacces-to-eperm.patch
fs-return-eagain-when-o_nonblock-write-should-block-on-frozen-fs.patch
fs-fix-hang-with-bsd-accounting-on-frozen-filesystem.patch
ocfs2-add-freeze-protection-to-ocfs2_file_splice_write.patch
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
hfsplus-fix-issue-with-unzeroed-unused-b-tree-nodes.patch
ocfs2-fix-possible-use-after-free-with-aio.patch
fs-direct-ioc-fix-possible-use-after-free-with-aio.patch

