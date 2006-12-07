From: akpm@osdl.org
Subject: - retries-in-ext3_prepare_write-violate-ordering-requirements-fix.patch removed from -mm tree
Date: Wed, 06 Dec 2006 19:27:49 -0800
Message-ID: <200612070327.kB73RnPv027308@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:42258 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967949AbWLGD1w (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 6 Dec 2006 22:27:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dev@openvz.org, dmonakhov@openvz.org, mm-commits@vger.kernel.org


The patch titled
     ext3: small fix for previous retries patch in ext3_prepare_write()
has been removed from the -mm tree.  Its filename was
     retries-in-ext3_prepare_write-violate-ordering-requirements-fix.patch

This patch was dropped because it was folded into retries-in-ext3_prepare_write-violate-ordering-requirements.patch

------------------------------------------------------
Subject: ext3: small fix for previous retries patch in ext3_prepare_write()
From: Kirill Korotaev <dev@openvz.org>

Patch from Dmitry Monakhov:
Previous fix for retries in ext3_prepare_write() violation
was a bit errorneuos:
- it missed return of error code from ext3_journal_stop()
- it missed do_journal_get_write_access() before commit_write

a few comments added also.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
Signed-off-by: Kirill Korotaev <dev@openvz.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/ext3/inode.c |   17 +++++++++++++++--
 1 files changed, 15 insertions(+), 2 deletions(-)

diff -puN fs/ext3/inode.c~retries-in-ext3_prepare_write-violate-ordering-requirements-fix fs/ext3/inode.c
--- a/fs/ext3/inode.c~retries-in-ext3_prepare_write-violate-ordering-requirements-fix
+++ a/fs/ext3/inode.c
@@ -1162,13 +1162,14 @@ static int ext3_prepare_failure(struct f
 	struct buffer_head *bh, *head, *next;
 	unsigned block_start, block_end;
 	unsigned blocksize;
+	int ret;
+	handle_t *handle = ext3_journal_current_handle();
 
 	mapping = page->mapping;
 	if (ext3_should_writeback_data(mapping->host)) {
 		/* optimization: no constraints about data */
 skip:
-		ext3_journal_stop(ext3_journal_current_handle());
-		return 0;
+		return ext3_journal_stop(handle);
 	}
 
 	head = page_buffers(page);
@@ -1186,7 +1187,19 @@ skip:
 			break;
 		}
 		if (!buffer_mapped(bh))
+		/* prepare_write failed on this bh */
 			break;
+		if (ext3_should_journal_data(mapping->host)) {
+			ret = do_journal_get_write_access(handle, bh);
+			if (ret) {
+				ext3_journal_stop(handle);
+				return ret;
+			}
+		}
+	/*
+	 * block_start here becomes the first block where the current iteration
+	 * of prepare_write failed.
+	 */
 	}
 	if (block_start <= from)
 		goto skip;
_

Patches currently in -mm which might be from dev@openvz.org are

oom-can-panic-due-to-processes-stuck-in-__alloc_pages.patch
retries-in-ext3_prepare_write-violate-ordering-requirements.patch
retries-in-ext3_prepare_write-violate-ordering-requirements-fix.patch
add-process_session-helper-routine.patch
add-an-identifier-to-nsproxy.patch
rename-struct-pspace-to-struct-pid_namespace.patch
add-pid_namespace-to-nsproxy.patch
use-current-nsproxy-pid_ns.patch
add-child-reaper-to-pid_namespace.patch
move_task_off_dead_cpu-should-be-called-with-disabled-ints.patch

