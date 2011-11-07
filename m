From: akpm@linux-foundation.org
Subject: [merged] procfs-report-eisdir-when-reading-sysctl-dirs-in-proc.patch removed from -mm tree
Date: Mon, 07 Nov 2011 12:27:40 -0800
Message-ID: <201111072027.pA7KRe8v012271@hpaq12.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:47271 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778Ab1KGU1r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Nov 2011 15:27:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@openvz.org, adobriyan@gmail.com, gorcunov@openvz.org, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: procfs: report EISDIR when reading sysctl dirs in proc
has been removed from the -mm tree.  Its filename was
     procfs-report-eisdir-when-reading-sysctl-dirs-in-proc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Pavel Emelyanov <xemul@openvz.org>
Subject: procfs: report EISDIR when reading sysctl dirs in proc

On reading sysctl dirs we should return -EISDIR instead of -EINVAL.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/proc_sysctl.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/proc/proc_sysctl.c~procfs-report-eisdir-when-reading-sysctl-dirs-in-proc fs/proc/proc_sysctl.c
--- a/fs/proc/proc_sysctl.c~procfs-report-eisdir-when-reading-sysctl-dirs-in-proc
+++ a/fs/proc/proc_sysctl.c
@@ -370,6 +370,7 @@ static const struct file_operations proc
 };
 
 static const struct file_operations proc_sys_dir_file_operations = {
+	.read		= generic_read_dir,
 	.readdir	= proc_sys_readdir,
 	.llseek		= generic_file_llseek,
 };
_

Patches currently in -mm which might be from xemul@openvz.org are

origin.patch

