From: akpm@linux-foundation.org
Subject: - configure-out-aio-support-fix.patch removed from -mm tree
Date: Wed, 15 Oct 2008 16:59:31 -0700
Message-ID: <200810152359.m9FNxWQu024745@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57969 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751736AbYJPAAJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Oct 2008 20:00:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mpm@selenic.com, thomas.petazzoni@free-electrons.com, mm-commits@vger.kernel.org


The patch titled
     aio: fix sysctl build error
has been removed from the -mm tree.  Its filename was
     configure-out-aio-support-fix.patch

This patch was dropped because it was folded into configure-out-aio-support.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: aio: fix sysctl build error
From: Randy Dunlap <randy.dunlap@oracle.com>

Put aio_nr sysctl inside ifdef CONFIG_AIO block to fix this build error:

kernel/built-in.o:(.data+0x2a2c): undefined reference to `aio_nr'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Matt Mackall <mpm@selenic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/sysctl.c~configure-out-aio-support-fix kernel/sysctl.c
--- a/kernel/sysctl.c~configure-out-aio-support-fix
+++ a/kernel/sysctl.c
@@ -1336,6 +1336,7 @@ static struct ctl_table fs_table[] = {
 		.extra2		= &two,
 	},
 #endif
+#ifdef CONFIG_AIO
 	{
 		.procname	= "aio-nr",
 		.data		= &aio_nr,
@@ -1343,7 +1344,6 @@ static struct ctl_table fs_table[] = {
 		.mode		= 0444,
 		.proc_handler	= &proc_doulongvec_minmax,
 	},
-#ifdef CONFIG_AIO
 	{
 		.procname	= "aio-max-nr",
 		.data		= &aio_max_nr,
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
eeepc-laptop-use-standard-interfaces-fix.patch
dontdiff-more-updates-to-be-closer-to-gitignore.patch
documentation-explain-memory-barriers.patch
taint-fix-kernel-doc.patch
framebuffer-fix-carminefb-section-mismatch.patch
docbook-update-procfs-credits.patch
w1-documentation-w1-masters-ds2490-update.patch
configure-out-aio-support.patch
configure-out-aio-support-fix.patch

