From: akpm@linux-foundation.org
Subject: [withdrawn] fs-execc-provide-the-correct-process-pid-to-the-pipe-helper.patch removed from -mm tree
Date: Thu, 26 May 2011 13:11:44 -0700
Message-ID: <201105262011.p4QKBigI017119@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33920 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758320Ab1EZUM0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 May 2011 16:12:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wad@chromium.org, ebiederm@xmission.com, nhorman@tuxdriver.com, oleg@redhat.com, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     fs/exec.c: provide the correct process pid to the pipe helper
has been removed from the -mm tree.  Its filename was
     fs-execc-provide-the-correct-process-pid-to-the-pipe-helper.patch

This patch was dropped because it was withdrawn

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/exec.c: provide the correct process pid to the pipe helper
From: Will Drewry <wad@chromium.org>

format_corename() uses task_tgid_vnr to provide the numeric pid of a
core-dumping process.  For file-based coredumps, this is perfectly
satisfactory.  However, when the core_pattern contains a pipe, the
substituted PID is invalid in the namespace of the core_pattern pipe
helper, the init namespace.

By changing this, any core collector may now find the process in the init
namespace /proc.  This helps with VFS namespacing too since the mount root
is available via /proc.  Unfortunately, it does not help in cases of more
complex namespacing, like net namespaces.  For that, the helper thread
will need to be migrated to the core-dump namespaces.

I have a separate patch series which implements migrating the
____call_usermodehelper thread to the coredump namespace, but it adds a
fair amount of complexity which might be better handled by someone who
understands that code.  I'm happy to mail it out as well though (it works,
but I don't assign a namespaced pid which may open up issues on its own).

Signed-off-by: Will Drewry <wad@chromium.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff -puN fs/exec.c~fs-execc-provide-the-correct-process-pid-to-the-pipe-helper fs/exec.c
--- a/fs/exec.c~fs-execc-provide-the-correct-process-pid-to-the-pipe-helper
+++ a/fs/exec.c
@@ -1601,6 +1601,13 @@ static int format_corename(struct core_n
 	int ispipe = (*pat_ptr == '|');
 	int pid_in_pattern = 0;
 	int err = 0;
+	pid_t pid = task_tgid_vnr(current);
+
+	/* The pipe helper runs in the init namespace and should
+	 * receive the matching pid until that changes.
+	 */
+	if (ispipe)
+		pid = task_tgid_nr(current);
 
 	cn->size = CORENAME_MAX_SIZE * atomic_read(&call_count);
 	cn->corename = kmalloc(cn->size, GFP_KERNEL);
@@ -1628,8 +1635,7 @@ static int format_corename(struct core_n
 			/* pid */
 			case 'p':
 				pid_in_pattern = 1;
-				err = cn_printf(cn, "%d",
-					      task_tgid_vnr(current));
+				err = cn_printf(cn, "%d", pid);
 				break;
 			/* uid */
 			case 'u':
@@ -1691,7 +1697,7 @@ static int format_corename(struct core_n
 	 * and core_uses_pid is set, then .%pid will be appended to
 	 * the filename. Do not do this for piped commands. */
 	if (!ispipe && !pid_in_pattern && core_uses_pid) {
-		err = cn_printf(cn, ".%d", task_tgid_vnr(current));
+		err = cn_printf(cn, ".%d", pid);
 		if (err)
 			return err;
 	}
_

Patches currently in -mm which might be from wad@chromium.org are


