Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC22F170A0B
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 04:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736742267; cv=none; b=U2yQxu1z+VojfSxroRYflv6rlMwaLOk4B99Sjbo6aszCFnAj8+j6v1y9WHuBpqEYYqBcJ47RPIFq8xK1ORtsWIivbTkwFlq5HuEa0dgKybvj3BcEq1ipttLcsK7ftuKNgFAGfAhYV4gwGZ826DpJNTtwgLkTbYkH8BTgH/9jW3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736742267; c=relaxed/simple;
	bh=oLcMtIz1PhTCeccZN6Ie/B383UuyOPpqaO5VYeo+0hU=;
	h=Date:To:From:Subject:Message-Id; b=C3dpVyUJzbHFcYZfo5zCTTGOFXakzUUohYbAjIULYqolYZU5kWoJLyKpdogUc3iC5aj1NL7DRvCT8bhj6h/zAbypDoAD7tQks4yQEGOjffl4VhZMeDmPRMbltP+dR7moPMGZSTIvLxLOqdlFxjpq4ymNtmz7kqtg6eQhlig8SfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QD3eAA0l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QD3eAA0l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95689C4CED6;
	Mon, 13 Jan 2025 04:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736742267;
	bh=oLcMtIz1PhTCeccZN6Ie/B383UuyOPpqaO5VYeo+0hU=;
	h=Date:To:From:Subject:From;
	b=QD3eAA0lurIDxvRaJPpTLzTmkhSI4G+fwPU7CKc62BdqsiJrPjtdpQJbxLli6NfRS
	 3FWHRPFSkHYVjfCMp/kGJhJlBl81XPLxhbNpwTxVge9JPLweTT8+2IflC4mHLZJEKO
	 PyDEro2z6o/31FcXa/d5syFh+WY7PclfBumGJzsI=
Date: Sun, 12 Jan 2025 20:24:27 -0800
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-do-not-force-clear-folio-if-buffer-is-referenced.patch removed from -mm tree
Message-Id: <20250113042427.95689C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: do not force clear folio if buffer is referenced
has been removed from the -mm tree.  Its filename was
     nilfs2-do-not-force-clear-folio-if-buffer-is-referenced.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: do not force clear folio if buffer is referenced
Date: Wed, 8 Jan 2025 05:00:46 +0900

Patch series "nilfs2: protect busy buffer heads from being force-cleared".

This series fixes the buffer head state inconsistency issues reported by
syzbot that occurs when the filesystem is corrupted and falls back to
read-only, and the associated buffer head use-after-free issue.


This patch (of 2):

Syzbot has reported that after nilfs2 detects filesystem corruption and
falls back to read-only, inconsistencies in the buffer state may occur.

One of the inconsistencies is that when nilfs2 calls mark_buffer_dirty()
to set a data or metadata buffer as dirty, but it detects that the buffer
is not in the uptodate state:

 WARNING: CPU: 0 PID: 6049 at fs/buffer.c:1177 mark_buffer_dirty+0x2e5/0x520
  fs/buffer.c:1177
 ...
 Call Trace:
  <TASK>
  nilfs_palloc_commit_alloc_entry+0x4b/0x160 fs/nilfs2/alloc.c:598
  nilfs_ifile_create_inode+0x1dd/0x3a0 fs/nilfs2/ifile.c:73
  nilfs_new_inode+0x254/0x830 fs/nilfs2/inode.c:344
  nilfs_mkdir+0x10d/0x340 fs/nilfs2/namei.c:218
  vfs_mkdir+0x2f9/0x4f0 fs/namei.c:4257
  do_mkdirat+0x264/0x3a0 fs/namei.c:4280
  __do_sys_mkdirat fs/namei.c:4295 [inline]
  __se_sys_mkdirat fs/namei.c:4293 [inline]
  __x64_sys_mkdirat+0x87/0xa0 fs/namei.c:4293
  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
  do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
  entry_SYSCALL_64_after_hwframe+0x77/0x7f

The other is when nilfs_btree_propagate(), which propagates the dirty
state to the ancestor nodes of a b-tree that point to a dirty buffer,
detects that the origin buffer is not dirty, even though it should be:

 WARNING: CPU: 0 PID: 5245 at fs/nilfs2/btree.c:2089
  nilfs_btree_propagate+0xc79/0xdf0 fs/nilfs2/btree.c:2089
 ...
 Call Trace:
  <TASK>
  nilfs_bmap_propagate+0x75/0x120 fs/nilfs2/bmap.c:345
  nilfs_collect_file_data+0x4d/0xd0 fs/nilfs2/segment.c:587
  nilfs_segctor_apply_buffers+0x184/0x340 fs/nilfs2/segment.c:1006
  nilfs_segctor_scan_file+0x28c/0xa50 fs/nilfs2/segment.c:1045
  nilfs_segctor_collect_blocks fs/nilfs2/segment.c:1216 [inline]
  nilfs_segctor_collect fs/nilfs2/segment.c:1540 [inline]
  nilfs_segctor_do_construct+0x1c28/0x6b90 fs/nilfs2/segment.c:2115
  nilfs_segctor_construct+0x181/0x6b0 fs/nilfs2/segment.c:2479
  nilfs_segctor_thread_construct fs/nilfs2/segment.c:2587 [inline]
  nilfs_segctor_thread+0x69e/0xe80 fs/nilfs2/segment.c:2701
  kthread+0x2f0/0x390 kernel/kthread.c:389
  ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
  </TASK>

Both of these issues are caused by the callbacks that handle the
page/folio write requests, forcibly clear various states, including the
working state of the buffers they hold, at unexpected times when they
detect read-only fallback.

Fix these issues by checking if the buffer is referenced before clearing
the page/folio state, and skipping the clear if it is.

Link: https://lkml.kernel.org/r/20250107200202.6432-1-konishi.ryusuke@gmail.com
Link: https://lkml.kernel.org/r/20250107200202.6432-2-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+b2b14916b77acf8626d7@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=b2b14916b77acf8626d7
Reported-by: syzbot+d98fd19acd08b36ff422@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=d98fd19acd08b36ff422
Fixes: 8c26c4e2694a ("nilfs2: fix issue with flush kernel thread after remount in RO mode because of driver's internal error or metadata corruption")
Tested-by: syzbot+b2b14916b77acf8626d7@syzkaller.appspotmail.com
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/page.c |   31 +++++++++++++++++++++++++++----
 1 file changed, 27 insertions(+), 4 deletions(-)

--- a/fs/nilfs2/page.c~nilfs2-do-not-force-clear-folio-if-buffer-is-referenced
+++ a/fs/nilfs2/page.c
@@ -392,6 +392,11 @@ void nilfs_clear_dirty_pages(struct addr
 /**
  * nilfs_clear_folio_dirty - discard dirty folio
  * @folio: dirty folio that will be discarded
+ *
+ * nilfs_clear_folio_dirty() clears working states including dirty state for
+ * the folio and its buffers.  If the folio has buffers, clear only if it is
+ * confirmed that none of the buffer heads are busy (none have valid
+ * references and none are locked).
  */
 void nilfs_clear_folio_dirty(struct folio *folio)
 {
@@ -399,10 +404,6 @@ void nilfs_clear_folio_dirty(struct foli
 
 	BUG_ON(!folio_test_locked(folio));
 
-	folio_clear_uptodate(folio);
-	folio_clear_mappedtodisk(folio);
-	folio_clear_checked(folio);
-
 	head = folio_buffers(folio);
 	if (head) {
 		const unsigned long clear_bits =
@@ -410,6 +411,25 @@ void nilfs_clear_folio_dirty(struct foli
 			 BIT(BH_Async_Write) | BIT(BH_NILFS_Volatile) |
 			 BIT(BH_NILFS_Checked) | BIT(BH_NILFS_Redirected) |
 			 BIT(BH_Delay));
+		bool busy, invalidated = false;
+
+recheck_buffers:
+		busy = false;
+		bh = head;
+		do {
+			if (atomic_read(&bh->b_count) | buffer_locked(bh)) {
+				busy = true;
+				break;
+			}
+		} while (bh = bh->b_this_page, bh != head);
+
+		if (busy) {
+			if (invalidated)
+				return;
+			invalidate_bh_lrus();
+			invalidated = true;
+			goto recheck_buffers;
+		}
 
 		bh = head;
 		do {
@@ -419,6 +439,9 @@ void nilfs_clear_folio_dirty(struct foli
 		} while (bh = bh->b_this_page, bh != head);
 	}
 
+	folio_clear_uptodate(folio);
+	folio_clear_mappedtodisk(folio);
+	folio_clear_checked(folio);
 	__nilfs_clear_folio_dirty(folio);
 }
 
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are


