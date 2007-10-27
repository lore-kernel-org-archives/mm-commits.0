From: akpm@linux-foundation.org
Subject: + kernel-cgroupc-remove-dead-code.patch added to -mm tree
Date: Sat, 27 Oct 2007 01:02:53 -0700
Message-ID: <200710270802.l9R82rLt003965@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51564 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751563AbXJ0IDT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 27 Oct 2007 04:03:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, menage@google.com, pj@sgi.com


The patch titled
     kernel/cgroup.c: remove dead code
has been added to the -mm tree.  Its filename is
     kernel-cgroupc-remove-dead-code.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kernel/cgroup.c: remove dead code
From: Adrian Bunk <bunk@kernel.org>

This patch removes dead code spotted by the Coverity checker
(look at the "(nbytes >= PATH_MAX)" check).

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Paul Jackson <pj@sgi.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff -puN kernel/cgroup.c~kernel-cgroupc-remove-dead-code kernel/cgroup.c
--- a/kernel/cgroup.c~kernel-cgroupc-remove-dead-code
+++ a/kernel/cgroup.c
@@ -1357,16 +1357,14 @@ static ssize_t cgroup_common_file_write(
 		if (nbytes && (buffer[nbytes-1] == '\n')) {
 			buffer[nbytes-1] = 0;
 		}
-		if (nbytes < sizeof(root->release_agent_path)) {
-			/* We never write anything other than '\0'
-			 * into the last char of release_agent_path,
-			 * so it always remains a NUL-terminated
-			 * string */
-			strncpy(root->release_agent_path, buffer, nbytes);
-			root->release_agent_path[nbytes] = 0;
-		} else {
-			retval = -ENOSPC;
-		}
+
+		/* We never write anything other than '\0'
+		 * into the last char of release_agent_path,
+		 * so it always remains a NUL-terminated
+		 * string */
+		strncpy(root->release_agent_path, buffer, nbytes);
+		root->release_agent_path[nbytes] = 0;
+
 		break;
 	}
 	default:
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
ipmi-fix-comparison-in-demangle_device_id.patch
git-acpi.patch
git-dvb.patch
git-hwmon.patch
git-nfs-make-nfs_wb_page_priority-static.patch
git-ocfs2.patch
git-sh64.patch
sunrpc-xprtrdma-transportc-fix-use-after-free.patch
fix-mm-utilckrealloc.patch
fuse_file_alloc-fix-null-dereferences.patch
make-jbd-journalc__journal_abort_hard-static.patch
kernel-cgroupc-remove-dead-code.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
reiser4.patch
