From: akpm@linux-foundation.org
Subject: - fix-gregkh-driver-sys-modules-holders.patch removed from -mm tree
Date: Fri, 09 Feb 2007 21:23:43 -0800
Message-ID: <200702100523.l1A5Nhi8004535@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36676 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752675AbXBJFYO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 10 Feb 2007 00:24:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: grant_lkml@dodo.com.au, gcoady.lk@gmail.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     kernel/params.c: compile fail when CONFIG_SYSFS not set
has been removed from the -mm tree.  Its filename was
     fix-gregkh-driver-sys-modules-holders.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: kernel/params.c: compile fail when CONFIG_SYSFS not set
From: Grant Coady <grant_lkml@dodo.com.au>

kernel/profile.c:247: warning: 'profile_flip_buffers' defined but not used
kernel/profile.c:270: warning: 'profile_discard_flip_buffers' defined but not used
kernel/profile.c:337: warning: 'profile_cpu_callback' defined but not used
kernel/params.c:700: error: `module_uevent_ops' undeclared here (not in a function)
kernel/params.c:700: error: initializer element is not constant
kernel/params.c:700: error: (near initialization for `module_subsys.kset.uevent_ops')
kernel/params.c:700: error: initializer element is not constant
kernel/params.c:700: error: (near initialization for `module_subsys.kset')
make[1]: *** [kernel/params.o] Error 1
make: *** [kernel] Error 2

Signed-off-by: Grant Coady <gcoady.lk@gmail.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/params.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN kernel/params.c~fix-gregkh-driver-sys-modules-holders kernel/params.c
--- a/kernel/params.c~fix-gregkh-driver-sys-modules-holders
+++ a/kernel/params.c
@@ -691,6 +691,10 @@ static struct sysfs_ops module_sysfs_ops
 	.show = NULL,
 	.store = NULL,
 };
+
+static struct kset_uevent_ops module_uevent_ops = {
+	.filter = NULL,
+};
 #endif
 
 static struct kobj_type module_ktype = {
_

Patches currently in -mm which might be from grant_lkml@dodo.com.au are

git-block-dupe-definitions.patch
