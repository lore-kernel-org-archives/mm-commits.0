From: akpm@linux-foundation.org
Subject: + kernel-sysctl-resolve-missing-field-initializers-warnings.patch added to -mm tree
Date: Tue, 14 Oct 2014 13:24:18 -0700
Message-ID: <543d8672.FqRgpGBE3p3gXOaC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45375 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755656AbaJNUYS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 16:24:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mark.d.rustad@intel.com, jeffrey.t.kirsher@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/sysctl: Resolve missing-field-initializers warnings
has been added to the -mm tree.  Its filename is
     kernel-sysctl-resolve-missing-field-initializers-warnings.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-sysctl-resolve-missing-field-initializers-warnings.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-sysctl-resolve-missing-field-initializers-warnings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

origin.patch
kernel-sysctl-resolve-missing-field-initializers-warnings.patch

