From: akpm@osdl.org
Subject: + fix-gregkh-driver-sys-modules-holders.patch added to -mm tree
Date: Wed, 31 Jan 2007 13:43:56 -0800
Message-ID: <200701312143.l0VLhuv9027559@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:53016 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933352AbXAaVoJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 31 Jan 2007 16:44:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: grant_lkml@dodo.com.au, gcoady.lk@gmail.com, greg@kroah.com


The patch titled
     kernel/params.c: compile fail when CONFIG_SYSFS not set
has been added to the -mm tree.  Its filename is
     fix-gregkh-driver-sys-modules-holders.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/params.c |    4 ++++
 1 files changed, 4 insertions(+)

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

fix-gregkh-driver-sys-modules-holders.patch
git-block-dupe-definitions.patch
