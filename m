From: akpm@linux-foundation.org
Subject: + fsnotify-fix-handling-of-renames-in-audit.patch added to -mm
 tree
Date: Tue, 10 Feb 2015 12:05:16 -0800
Message-ID: <54da647c.Q5QBjpHbVI8dAIVt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48950 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbbBJUFR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Feb 2015 15:05:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, eparis@redhat.com, paul@paul-moore.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: fsnotify: fix handling of renames in audit
has been added to the -mm tree.  Its filename is
     fsnotify-fix-handling-of-renames-in-audit.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fsnotify-fix-handling-of-renames-in-audit.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fsnotify-fix-handling-of-renames-in-audit.patch

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
Subject: fsnotify: fix handling of renames in audit

Commit e9fd702a58c4 ("audit: convert audit watches to use fsnotify instead
of inotify") broke handling of renames in audit.  Audit code wants to
update inode number of an inode corresponding to watched name in a
directory.  When something gets renamed into a directory to a watched
name, inotify previously passed moved inode to audit code however new
fsnotify code passes directory inode where the change happened.  That
confuses audit and it starts watching parent directory instead of a file
in a directory.

This can be observed for example by doing:
cd /tmp
touch foo bar
auditctl -w /tmp/foo
touch foo
mv bar foo
touch foo

In audit log we see events like:
type=CONFIG_CHANGE msg=audit(1423563584.155:90): auid=1000 ses=2
op="updated rules" path="/tmp/foo" key=(null) list=4 res=1
...
type=PATH msg=audit(1423563584.155:91): item=2 name="bar" inode=1046884
dev=08:0
2 mode=0100644 ouid=0 ogid=0 rdev=00:00 nametype=DELETE
type=PATH msg=audit(1423563584.155:91): item=3 name="foo" inode=1046842
dev=08:0
2 mode=0100644 ouid=0 ogid=0 rdev=00:00 nametype=DELETE
type=PATH msg=audit(1423563584.155:91): item=4 name="foo" inode=1046884
dev=08:0
2 mode=0100644 ouid=0 ogid=0 rdev=00:00 nametype=CREATE
...

and that's it - we see event for the first touch after creating the audit
rule, we see events for rename but we don't see any event for the last
touch.  However we start seeing events for unrelated stuff happening in
/tmp.

Fix the problem by passing moved inode as data in the FS_MOVED_FROM and
FS_MOVED_TO events instead of the directory where the change happens. 
This doesn't introduce any new problems because noone besides
audit_watch.c cares about the passed value:

fs/notify/fanotify/fanotify.c cares only about FSNOTIFY_EVENT_PATH events.
fs/notify/dnotify/dnotify.c doesn't care about passed 'data' value at all.
fs/notify/inotify/inotify_fsnotify.c uses 'data' only for FSNOTIFY_EVENT_PATH.
kernel/audit_tree.c doesn't care about passed 'data' at all.
kernel/audit_watch.c expects moved inode as 'data'.

Fixes: e9fd702a58c49db ("audit: convert audit watches to use fsnotify instead of inotify")
Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Eric Paris <eparis@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fsnotify.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN include/linux/fsnotify.h~fsnotify-fix-handling-of-renames-in-audit include/linux/fsnotify.h
--- a/include/linux/fsnotify.h~fsnotify-fix-handling-of-renames-in-audit
+++ a/include/linux/fsnotify.h
@@ -101,8 +101,10 @@ static inline void fsnotify_move(struct
 		new_dir_mask |= FS_ISDIR;
 	}
 
-	fsnotify(old_dir, old_dir_mask, old_dir, FSNOTIFY_EVENT_INODE, old_name, fs_cookie);
-	fsnotify(new_dir, new_dir_mask, new_dir, FSNOTIFY_EVENT_INODE, new_name, fs_cookie);
+	fsnotify(old_dir, old_dir_mask, source, FSNOTIFY_EVENT_INODE, old_name,
+		 fs_cookie);
+	fsnotify(new_dir, new_dir_mask, source, FSNOTIFY_EVENT_INODE, new_name,
+		 fs_cookie);
 
 	if (target)
 		fsnotify_link_count(target);
_

Patches currently in -mm which might be from jack@suse.cz are

fanotify-only-destroy-mark-when-both-mask-and-ignored_mask-are-cleared.patch
fanotify-dont-recalculate-a-marks-mask-if-only-the-ignored-mask-changed.patch
fanotify-dont-set-fan_ondir-implicitly-on-a-marks-ignored-mask.patch
inotify-update-documentation-to-reflect-code-changes.patch
fsnotify-fix-handling-of-renames-in-audit.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
ocfs2-remove-pointless-assignment-from-ocfs2_calc_refcount_meta_credits.patch
mm-memory-remove-vm_file-check-on-shared-writable-vmas.patch
mm-memory-merge-shared-writable-dirtying-branches-in-do_wp_page.patch
fs-mpagec-forgotten-write_sync-in-case-of-data-integrity-write.patch
genalloc-check-result-of-devres_alloc.patch
fs-affs-filec-fix-direct-io-writes-beyond-eof.patch
fs-affs-superc-destroy-sbi-mutex-in-affs_kill_sb.patch
linux-next.patch
mm-fix-xip-fault-vs-truncate-race.patch
mm-fix-xip-fault-vs-truncate-race-fix.patch
mm-allow-page-fault-handlers-to-perform-the-cow.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix.patch
vfsext2-introduce-is_daxinode.patch
daxext2-replace-xip-read-and-write-with-dax-i-o.patch
daxext2-replace-ext2_clear_xip_target-with-dax_clear_blocks.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix.patch
daxext2-replace-xip_truncate_page-with-dax_truncate_page.patch
dax-replace-xip-documentation-with-dax-documentation.patch
vfs-remove-get_xip_mem.patch
ext2-remove-ext2_xip_verify_sb.patch
ext2-remove-ext2_use_xip.patch
ext2-remove-xipc-and-xiph.patch
vfsext2-remove-config_ext2_fs_xip-and-rename-config_fs_xip-to-config_fs_dax.patch
ext2-remove-ext2_aops_xip.patch
ext2-get-rid-of-most-mentions-of-xip-in-ext2.patch
dax-add-dax_zero_page_range.patch
dax-add-dax_zero_page_range-fix.patch
ext4-add-dax-functionality.patch
brd-rename-xip-to-dax.patch
mm-add-strictlimit-knob-v2.patch

