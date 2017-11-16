From: akpm@linux-foundation.org
Subject: [folded-merged] f2fs-simplify-page-iteration-loops-fix.patch
 removed from -mm tree
Date: Wed, 15 Nov 2017 16:58:51 -0800
Message-ID: <5a0ce2cb.3wO6JDg/UfYtu2Ur%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35736 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758345AbdKPA6w (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 19:58:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, daniel.m.jordan@oracle.com, jack@suse.cz, jaegeuk@kernel.org, yuchao0@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: f2fs-simplify-page-iteration-loops-fix
has been removed from the -mm tree.  Its filename was
     f2fs-simplify-page-iteration-loops-fix.patch

This patch was dropped because it was folded into f2fs-simplify-page-iteration-loops.patch

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

include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
f2fs-simplify-page-iteration-loops.patch
mm-consolidate-page-table-accounting-fix-fix.patch
mm-stop-zeroing-memory-during-allocation-in-vmemmap-fix.patch
mm-batch-radix-tree-operations-when-truncating-pages-fix-fix.patch
mm-simplify-nodemask-printing-fix.patch
mm-make-alloc_node_mem_map-a-voidcall-if-we-dont-have-config_flat_node_mem_map-fix.patch

