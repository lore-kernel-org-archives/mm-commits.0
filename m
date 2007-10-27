From: akpm@linux-foundation.org
Subject: + cgroup-simplify-space-stripping.patch added to -mm tree
Date: Sat, 27 Oct 2007 01:02:57 -0700
Message-ID: <200710270802.l9R82v0l003971@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56809 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751429AbXJ0IDE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 27 Oct 2007 04:03:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pj@sgi.com, menage@google.com


The patch titled
     cgroup simplify space stripping
has been added to the -mm tree.  Its filename is
     cgroup-simplify-space-stripping.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cgroup simplify space stripping
From: Paul Jackson <pj@sgi.com>

Simplify the space stripping code in cgroup file write.

Signed-off-by: Paul Jackson <pj@sgi.com>
Acked-by: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |   17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff -puN kernel/cgroup.c~cgroup-simplify-space-stripping kernel/cgroup.c
--- a/kernel/cgroup.c~cgroup-simplify-space-stripping
+++ a/kernel/cgroup.c
@@ -1328,6 +1328,7 @@ static ssize_t cgroup_common_file_write(
 		goto out1;
 	}
 	buffer[nbytes] = 0;	/* nul-terminate */
+	strstrip(buffer);	/* strip -just- trailing whitespace */
 
 	mutex_lock(&cgroup_mutex);
 
@@ -1348,21 +1349,9 @@ static ssize_t cgroup_common_file_write(
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
+		BUG_ON(sizeof(cgrp->root->release_agent_path) < PATH_MAX);
+		strcpy(cgrp->root->release_agent_path, buffer);
 		break;
-	}
 	default:
 		retval = -EINVAL;
 		goto out2;
_

Patches currently in -mm which might be from pj@sgi.com are

kernel-cgroupc-remove-dead-code.patch
cgroup-brace-coding-style-fix.patch
cgroup-simplify-space-stripping.patch
cgroup-simplify-space-stripping-fix.patch
