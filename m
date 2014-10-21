From: akpm@linux-foundation.org
Subject: [nacked]
 kernel-sysctl-resolve-missing-field-initializers-warnings.patch removed
 from -mm tree
Date: Tue, 21 Oct 2014 12:05:57 -0700
Message-ID: <5446ae95.gmVZueNCqyIDq3tD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39810 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755357AbaJUTF5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Oct 2014 15:05:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mark.d.rustad@intel.com, jeffrey.t.kirsher@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/sysctl: Resolve missing-field-initializers warnings
has been removed from the -mm tree.  Its filename was
     kernel-sysctl-resolve-missing-field-initializers-warnings.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Mark Rustad <mark.d.rustad@intel.com>
Subject: kernel/sysctl: Resolve missing-field-initializers warnings

Resolve missing-field-initializers warnings in W=2 builds by
using designated initialization.

Signed-off-by: Mark Rustad <mark.d.rustad@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN kernel/sysctl.c~kernel-sysctl-resolve-missing-field-initializers-warnings kernel/sysctl.c
--- a/kernel/sysctl.c~kernel-sysctl-resolve-missing-field-initializers-warnings
+++ a/kernel/sysctl.c
@@ -257,7 +257,7 @@ static struct ctl_table sysctl_base_tabl
 		.mode		= 0555,
 		.child		= dev_table,
 	},
-	{ }
+	{ .procname = NULL }
 };
 
 #ifdef CONFIG_SCHED_DEBUG
@@ -1103,7 +1103,7 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= proc_dointvec,
 	},
 #endif
-	{ }
+	{ .procname = NULL }
 };
 
 static struct ctl_table vm_table[] = {
@@ -1485,12 +1485,12 @@ static struct ctl_table vm_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_doulongvec_minmax,
 	},
-	{ }
+	{ .procname = NULL }
 };
 
 #if defined(CONFIG_BINFMT_MISC) || defined(CONFIG_BINFMT_MISC_MODULE)
 static struct ctl_table binfmt_misc_table[] = {
-	{ }
+	{ .procname = NULL }
 };
 #endif
 
@@ -1658,7 +1658,7 @@ static struct ctl_table fs_table[] = {
 		.proc_handler	= &pipe_proc_fn,
 		.extra1		= &pipe_min_size,
 	},
-	{ }
+	{ .procname = NULL }
 };
 
 static struct ctl_table debug_table[] = {
@@ -1682,11 +1682,11 @@ static struct ctl_table debug_table[] =
 		.extra2		= &one,
 	},
 #endif
-	{ }
+	{ .procname = NULL }
 };
 
 static struct ctl_table dev_table[] = {
-	{ }
+	{ .procname = NULL }
 };
 
 int __init sysctl_init(void)
_

Patches currently in -mm which might be from mark.d.rustad@intel.com are

linux-next.patch

