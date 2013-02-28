From: akpm@linux-foundation.org
Subject: [merged] fs-seq_filec-seq_lseek-fix-switch-statement-indenting.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:11:58 -0800
Message-ID: <20130228201158.A3BBD5A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:43942 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755781Ab3B1UMA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:12:00 -0500
Received: by mail-vc0-f201.google.com with SMTP id n11so244676vch.2
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:11:59 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, gorcunov@openvz.org, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/seq_file.c:seq_lseek(): fix switch statement indenting
has been removed from the -mm tree.  Its filename was
     fs-seq_filec-seq_lseek-fix-switch-statement-indenting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs/seq_file.c:seq_lseek(): fix switch statement indenting

[akpm@linux-foundation.org: checkpatch fixes]
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/seq_file.c |   40 ++++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff -puN fs/seq_file.c~fs-seq_filec-seq_lseek-fix-switch-statement-indenting fs/seq_file.c
--- a/fs/seq_file.c~fs-seq_filec-seq_lseek-fix-switch-statement-indenting
+++ a/fs/seq_file.c
@@ -308,27 +308,27 @@ loff_t seq_lseek(struct file *file, loff
 	mutex_lock(&m->lock);
 	m->version = file->f_version;
 	switch (whence) {
-		case SEEK_CUR:
-			offset += file->f_pos;
-		case SEEK_SET:
-			if (offset < 0)
-				break;
-			retval = offset;
-			if (offset != m->read_pos) {
-				while ((retval=traverse(m, offset)) == -EAGAIN)
-					;
-				if (retval) {
-					/* with extreme prejudice... */
-					file->f_pos = 0;
-					m->read_pos = 0;
-					m->version = 0;
-					m->index = 0;
-					m->count = 0;
-				} else {
-					m->read_pos = offset;
-					retval = file->f_pos = offset;
-				}
+	case SEEK_CUR:
+		offset += file->f_pos;
+	case SEEK_SET:
+		if (offset < 0)
+			break;
+		retval = offset;
+		if (offset != m->read_pos) {
+			while ((retval = traverse(m, offset)) == -EAGAIN)
+				;
+			if (retval) {
+				/* with extreme prejudice... */
+				file->f_pos = 0;
+				m->read_pos = 0;
+				m->version = 0;
+				m->index = 0;
+				m->count = 0;
+			} else {
+				m->read_pos = offset;
+				retval = file->f_pos = offset;
 			}
+		}
 	}
 	file->f_version = m->version;
 	mutex_unlock(&m->lock);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-v3-fix.patch
mm.patch
include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
kernel-smpc-cleanups.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
rtc-ds1307-long-block-operations-bugfix-fix.patch
kexec-use-min_t-to-simplify-logic-fix.patch
nfsd-idr_destroy-no-longer-needs-idr_remove_all.patch
aio-kiocb_cancel-fix.patch
wait-add-wait_event_hrtimeout-fix.patch
aio-use-cancellation-list-lazily-fix-fix.patch
aio-give-shared-kioctx-fields-their-own-cachelines-fix.patch
generic-dynamic-per-cpu-refcounting-fix.patch
generic-dynamic-per-cpu-refcounting-sparse-fixes-fix.patch
generic-dynamic-per-cpu-refcounting-doc-fix.patch
aio-dont-include-aioh-in-schedh-fix.patch
aio-dont-include-aioh-in-schedh-fix-fix.patch
aio-dont-include-aioh-in-schedh-fix-3.patch
aio-dont-include-aioh-in-schedh-fix-3-fix.patch
aio-dont-include-aioh-in-schedh-fix-3-fix-fix.patch
aio-kill-ki_retry-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix-fix-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

