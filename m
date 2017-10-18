From: akpm@linux-foundation.org
Subject: + f2fs-simplify-page-iteration-loops-fix.patch added to -mm tree
Date: Wed, 18 Oct 2017 14:32:37 -0700
Message-ID: <59e7c875.HROIaWhrKuqgilla%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34648 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751048AbdJRVcj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2017 17:32:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, daniel.m.jordan@oracle.com, jack@suse.cz, jaegeuk@kernel.org, yuchao0@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: f2fs-simplify-page-iteration-loops-fix
has been added to the -mm tree.  Its filename is
     f2fs-simplify-page-iteration-loops-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/f2fs-simplify-page-iteration-loops-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/f2fs-simplify-page-iteration-loops-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: f2fs-simplify-page-iteration-loops-fix

fix warnings

fs/f2fs/checkpoint.c: In function 'sync_meta_pages':
fs/f2fs/checkpoint.c:322: warning: suggest parentheses around assignment used as truth value
fs/f2fs/node.c: In function 'last_fsync_dnode':
fs/f2fs/node.c:1289: warning: suggest parentheses around assignment used as truth value
fs/f2fs/node.c: In function 'fsync_node_pages':
fs/f2fs/node.c:1443: warning: suggest parentheses around assignment used as truth value
fs/f2fs/node.c: In function 'sync_node_pages':
fs/f2fs/node.c:1556: warning: suggest parentheses around assignment used as truth value
fs/f2fs/node.c: In function 'wait_on_node_pages_writeback':
fs/f2fs/node.c:1654: warning: suggest parentheses around assignment used as truth value

Cc: Chao Yu <yuchao0@huawei.com>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/f2fs/checkpoint.c |    4 ++--
 fs/f2fs/node.c       |   16 ++++++++--------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff -puN fs/f2fs/checkpoint.c~f2fs-simplify-page-iteration-loops-fix fs/f2fs/checkpoint.c
--- a/fs/f2fs/checkpoint.c~f2fs-simplify-page-iteration-loops-fix
+++ a/fs/f2fs/checkpoint.c
@@ -318,8 +318,8 @@ long sync_meta_pages(struct f2fs_sb_info
 
 	blk_start_plug(&plug);
 
-	while (nr_pages = pagevec_lookup_tag(&pvec, mapping, &index,
-				PAGECACHE_TAG_DIRTY, PAGEVEC_SIZE)) {
+	while ((nr_pages = pagevec_lookup_tag(&pvec, mapping, &index,
+				PAGECACHE_TAG_DIRTY, PAGEVEC_SIZE))) {
 		int i;
 
 		for (i = 0; i < nr_pages; i++) {
diff -puN fs/f2fs/node.c~f2fs-simplify-page-iteration-loops-fix fs/f2fs/node.c
--- a/fs/f2fs/node.c~f2fs-simplify-page-iteration-loops-fix
+++ a/fs/f2fs/node.c
@@ -1285,8 +1285,8 @@ static struct page *last_fsync_dnode(str
 	pagevec_init(&pvec, 0);
 	index = 0;
 
-	while (nr_pages = pagevec_lookup_tag(&pvec, NODE_MAPPING(sbi), &index,
-				PAGECACHE_TAG_DIRTY, PAGEVEC_SIZE)) {
+	while ((nr_pages = pagevec_lookup_tag(&pvec, NODE_MAPPING(sbi), &index,
+				PAGECACHE_TAG_DIRTY, PAGEVEC_SIZE))) {
 		int i;
 
 		for (i = 0; i < nr_pages; i++) {
@@ -1439,8 +1439,8 @@ retry:
 	pagevec_init(&pvec, 0);
 	index = 0;
 
-	while (nr_pages = pagevec_lookup_tag(&pvec, NODE_MAPPING(sbi), &index,
-				PAGECACHE_TAG_DIRTY, PAGEVEC_SIZE)) {
+	while ((nr_pages = pagevec_lookup_tag(&pvec, NODE_MAPPING(sbi), &index,
+				PAGECACHE_TAG_DIRTY, PAGEVEC_SIZE))) {
 		int i;
 
 		for (i = 0; i < nr_pages; i++) {
@@ -1552,8 +1552,8 @@ int sync_node_pages(struct f2fs_sb_info
 next_step:
 	index = 0;
 
-	while (nr_pages = pagevec_lookup_tag(&pvec, NODE_MAPPING(sbi), &index,
-				PAGECACHE_TAG_DIRTY, PAGEVEC_SIZE)) {
+	while ((nr_pages = pagevec_lookup_tag(&pvec, NODE_MAPPING(sbi), &index,
+				PAGECACHE_TAG_DIRTY, PAGEVEC_SIZE))) {
 		int i;
 
 		for (i = 0; i < nr_pages; i++) {
@@ -1650,8 +1650,8 @@ int wait_on_node_pages_writeback(struct
 
 	pagevec_init(&pvec, 0);
 
-	while (nr_pages = pagevec_lookup_tag(&pvec, NODE_MAPPING(sbi), &index,
-				PAGECACHE_TAG_WRITEBACK, PAGEVEC_SIZE)) {
+	while ((nr_pages = pagevec_lookup_tag(&pvec, NODE_MAPPING(sbi), &index,
+				PAGECACHE_TAG_WRITEBACK, PAGEVEC_SIZE))) {
 		int i;
 
 		for (i = 0; i < nr_pages; i++) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
mm.patch
include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-swap-skip-swapcache-only-if-swapped-page-has-no-other-reference-checkpatch-fixes.patch
mm-drop-migrate-type-checks-from-has_unmovable_pages-fix.patch
mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix.patch
mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix-fix.patch
f2fs-simplify-page-iteration-loops-fix.patch
support-resetting-warn_once-checkpatch-fixes.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
watchdog-core-make-use-of-devm_register_reboot_notifier-fix.patch
sysvipc-unteach-ids-next_id-for-checkpoint_restore-checkpatch-fixes.patch
sysvipc-make-get_maxid-o1-again-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

