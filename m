From: akpm@linux-foundation.org
Subject: - cgroup-simplify-space-stripping.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:02:44 -0800
Message-ID: <200802080802.m1882PkO014037@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40229 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760569AbYBHITs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:19:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pj@sgi.com, menage@google.com, mm-commits@vger.kernel.org


The patch titled
     cgroup simplify space stripping
has been removed from the -mm tree.  Its filename was
     cgroup-simplify-space-stripping.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroup simplify space stripping
From: Paul Jackson <pj@sgi.com>

Simplify the space stripping code in cgroup file write.

[akpm@linux-foundation.org: s/BUG_ON/BUILD_BUG_ON/]
Signed-off-by: Paul Jackson <pj@sgi.com>
Acked-by: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |   17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff -puN kernel/cgroup.c~cgroup-simplify-space-stripping kernel/cgroup.c
--- a/kernel/cgroup.c~cgroup-simplify-space-stripping
+++ a/kernel/cgroup.c
@@ -1326,6 +1326,7 @@ static ssize_t cgroup_common_file_write(
 		goto out1;
 	}
 	buffer[nbytes] = 0;	/* nul-terminate */
+	strstrip(buffer);	/* strip -just- trailing whitespace */
 
 	mutex_lock(&cgroup_mutex);
 
@@ -1346,21 +1347,9 @@ static ssize_t cgroup_common_file_write(
 			clear_bit(CGRP_NOTIFY_ON_RELEASE, &cgrp->flags);
 		break;
 	case FILE_RELEASE_AGENT:
-	{
-		struct cgroupfs_root *root = cgrp->root;
-		/* Strip trailing newline */
-		if (nbytes && (buffer[nbytes-1] == '\n'))
-			buffer[nbytes-1] = 0;
-
-		/* We never write anything other than '\0'
-		 * into the last char of release_agent_path,
-		 * so it always remains a NUL-terminated
-		 * string */
-		strncpy(root->release_agent_path, buffer, nbytes);
-		root->release_agent_path[nbytes] = 0;
-
+		BUILD_BUG_ON(sizeof(cgrp->root->release_agent_path) < PATH_MAX);
+		strcpy(cgrp->root->release_agent_path, buffer);
 		break;
-	}
 	default:
 		retval = -EINVAL;
 		goto out2;
_

Patches currently in -mm which might be from pj@sgi.com are

origin.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-checkpatch-fixes.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-nommu-fix.patch
