From: akpm@linux-foundation.org
Subject: [merged] fs-hfsplus-bnodec-replace-min-casting-by-min_t.patch
 removed from -mm tree
Date: Mon, 09 Jun 2014 12:31:57 -0700
Message-ID: <53960bad.mfbH5HHF2agw6UTL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53918 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992AbaFITb5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:31:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, slava@dubeyko.com, fabf@skynet.be

Subject: [merged] fs-hfsplus-bnodec-replace-min-casting-by-min_t.patch removed from -mm tree
To: fabf@skynet.be,slava@dubeyko.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:31:57 -0700


The patch titled
     Subject: fs/hfsplus/bnode.c: replace min/casting by min_t
has been removed from the -mm tree.  Its filename was
     fs-hfsplus-bnodec-replace-min-casting-by-min_t.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/hfsplus/bnode.c: replace min/casting by min_t

Also fixes some pr_ formats

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Vyacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/bnode.c |   32 +++++++++++++++-----------------
 1 file changed, 15 insertions(+), 17 deletions(-)

diff -puN fs/hfsplus/bnode.c~fs-hfsplus-bnodec-replace-min-casting-by-min_t fs/hfsplus/bnode.c
--- a/fs/hfsplus/bnode.c~fs-hfsplus-bnodec-replace-min-casting-by-min_t
+++ a/fs/hfsplus/bnode.c
@@ -27,13 +27,13 @@ void hfs_bnode_read(struct hfs_bnode *no
 	pagep = node->page + (off >> PAGE_CACHE_SHIFT);
 	off &= ~PAGE_CACHE_MASK;
 
-	l = min(len, (int)PAGE_CACHE_SIZE - off);
+	l = min_t(int, len, PAGE_CACHE_SIZE - off);
 	memcpy(buf, kmap(*pagep) + off, l);
 	kunmap(*pagep);
 
 	while ((len -= l) != 0) {
 		buf += l;
-		l = min(len, (int)PAGE_CACHE_SIZE);
+		l = min_t(int, len, PAGE_CACHE_SIZE);
 		memcpy(buf, kmap(*++pagep), l);
 		kunmap(*pagep);
 	}
@@ -80,14 +80,14 @@ void hfs_bnode_write(struct hfs_bnode *n
 	pagep = node->page + (off >> PAGE_CACHE_SHIFT);
 	off &= ~PAGE_CACHE_MASK;
 
-	l = min(len, (int)PAGE_CACHE_SIZE - off);
+	l = min_t(int, len, PAGE_CACHE_SIZE - off);
 	memcpy(kmap(*pagep) + off, buf, l);
 	set_page_dirty(*pagep);
 	kunmap(*pagep);
 
 	while ((len -= l) != 0) {
 		buf += l;
-		l = min(len, (int)PAGE_CACHE_SIZE);
+		l = min_t(int, len, PAGE_CACHE_SIZE);
 		memcpy(kmap(*++pagep), buf, l);
 		set_page_dirty(*pagep);
 		kunmap(*pagep);
@@ -110,13 +110,13 @@ void hfs_bnode_clear(struct hfs_bnode *n
 	pagep = node->page + (off >> PAGE_CACHE_SHIFT);
 	off &= ~PAGE_CACHE_MASK;
 
-	l = min(len, (int)PAGE_CACHE_SIZE - off);
+	l = min_t(int, len, PAGE_CACHE_SIZE - off);
 	memset(kmap(*pagep) + off, 0, l);
 	set_page_dirty(*pagep);
 	kunmap(*pagep);
 
 	while ((len -= l) != 0) {
-		l = min(len, (int)PAGE_CACHE_SIZE);
+		l = min_t(int, len, PAGE_CACHE_SIZE);
 		memset(kmap(*++pagep), 0, l);
 		set_page_dirty(*pagep);
 		kunmap(*pagep);
@@ -142,14 +142,14 @@ void hfs_bnode_copy(struct hfs_bnode *ds
 	dst &= ~PAGE_CACHE_MASK;
 
 	if (src == dst) {
-		l = min(len, (int)PAGE_CACHE_SIZE - src);
+		l = min_t(int, len, PAGE_CACHE_SIZE - src);
 		memcpy(kmap(*dst_page) + src, kmap(*src_page) + src, l);
 		kunmap(*src_page);
 		set_page_dirty(*dst_page);
 		kunmap(*dst_page);
 
 		while ((len -= l) != 0) {
-			l = min(len, (int)PAGE_CACHE_SIZE);
+			l = min_t(int, len, PAGE_CACHE_SIZE);
 			memcpy(kmap(*++dst_page), kmap(*++src_page), l);
 			kunmap(*src_page);
 			set_page_dirty(*dst_page);
@@ -251,7 +251,7 @@ void hfs_bnode_move(struct hfs_bnode *no
 		dst &= ~PAGE_CACHE_MASK;
 
 		if (src == dst) {
-			l = min(len, (int)PAGE_CACHE_SIZE - src);
+			l = min_t(int, len, PAGE_CACHE_SIZE - src);
 			memmove(kmap(*dst_page) + src,
 				kmap(*src_page) + src, l);
 			kunmap(*src_page);
@@ -259,7 +259,7 @@ void hfs_bnode_move(struct hfs_bnode *no
 			kunmap(*dst_page);
 
 			while ((len -= l) != 0) {
-				l = min(len, (int)PAGE_CACHE_SIZE);
+				l = min_t(int, len, PAGE_CACHE_SIZE);
 				memmove(kmap(*++dst_page),
 					kmap(*++src_page), l);
 				kunmap(*src_page);
@@ -386,9 +386,8 @@ struct hfs_bnode *hfs_bnode_findhash(str
 	struct hfs_bnode *node;
 
 	if (cnid >= tree->node_count) {
-		pr_err("request for non-existent node "
-				"%d in B*Tree\n",
-			cnid);
+		pr_err("request for non-existent node %d in B*Tree\n",
+		       cnid);
 		return NULL;
 	}
 
@@ -409,9 +408,8 @@ static struct hfs_bnode *__hfs_bnode_cre
 	loff_t off;
 
 	if (cnid >= tree->node_count) {
-		pr_err("request for non-existent node "
-				"%d in B*Tree\n",
-			cnid);
+		pr_err("request for non-existent node %d in B*Tree\n",
+		       cnid);
 		return NULL;
 	}
 
@@ -602,7 +600,7 @@ struct hfs_bnode *hfs_bnode_create(struc
 
 	pagep = node->page;
 	memset(kmap(*pagep) + node->page_offset, 0,
-	       min((int)PAGE_CACHE_SIZE, (int)tree->node_size));
+	       min_t(int, PAGE_CACHE_SIZE, tree->node_size));
 	set_page_dirty(*pagep);
 	kunmap(*pagep);
 	for (i = 1; i < tree->pages_per_bnode; i++) {
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-cifs-remove-obsolete-__constant.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-isofs-logging-clean-up.patch
linux-next.patch
kernel-watchdogc-convert-printk-pr_warning-to-pr_foo.patch
init-mainc-code-clean-up.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch

