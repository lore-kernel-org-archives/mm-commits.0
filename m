From: akpm@osdl.org
Subject: - cpuset-allow-a-larger-buffer-for-writes-to-cpuset-files.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:18:20 -0800
Message-ID: <200612072318.kB7NIKC8031015@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:53978 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163906AbWLGXSZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:18:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: menage@google.com, pj@sgi.com, mm-commits@vger.kernel.org


The patch titled
     cpuset: allow a larger buffer for writes to cpuset files
has been removed from the -mm tree.  Its filename was
     cpuset-allow-a-larger-buffer-for-writes-to-cpuset-files.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cpuset: allow a larger buffer for writes to cpuset files
From: "Paul Menage" <menage@google.com>

When using fake NUMA setup, the number of memory nodes can greatly exceed
the number of CPUs.  So the current limit in cpuset_common_file_write() is
insufficient.

Signed-off-by: Paul Menage <menage@google.com>
Acked-by: Paul Jackson <pj@sgi.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/cpuset.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN kernel/cpuset.c~cpuset-allow-a-larger-buffer-for-writes-to-cpuset-files kernel/cpuset.c
--- a/kernel/cpuset.c~cpuset-allow-a-larger-buffer-for-writes-to-cpuset-files
+++ a/kernel/cpuset.c
@@ -1280,7 +1280,8 @@ typedef enum {
 	FILE_TASKLIST,
 } cpuset_filetype_t;
 
-static ssize_t cpuset_common_file_write(struct file *file, const char __user *userbuf,
+static ssize_t cpuset_common_file_write(struct file *file,
+					const char __user *userbuf,
 					size_t nbytes, loff_t *unused_ppos)
 {
 	struct cpuset *cs = __d_cs(file->f_dentry->d_parent);
@@ -1291,7 +1292,7 @@ static ssize_t cpuset_common_file_write(
 	int retval = 0;
 
 	/* Crude upper limit on largest legitimate cpulist user might write. */
-	if (nbytes > 100 + 6 * NR_CPUS)
+	if (nbytes > 100 + 6 * max(NR_CPUS, MAX_NUMNODES))
 		return -E2BIG;
 
 	/* +1 for nul-terminator */
_

Patches currently in -mm which might be from menage@google.com are

origin.patch
mm-fallback_alloc-cpuset_zone_allowed-irq-fix.patch

