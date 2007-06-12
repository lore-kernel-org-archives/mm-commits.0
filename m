From: akpm@linux-foundation.org
Subject: - protect-linux-console_structh-from-multiple-inclusion.patch removed from -mm tree
Date: Tue, 12 Jun 2007 11:57:40 -0700
Message-ID: <200706121857.l5CIvexd018491@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48231 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750771AbXFLTBW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Jun 2007 15:01:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, mm-commits@vger.kernel.org


The patch titled
     Protect <linux/console_struct.h> from multiple inclusion
has been removed from the -mm tree.  Its filename was
     protect-linux-console_structh-from-multiple-inclusion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Protect <linux/console_struct.h> from multiple inclusion
From: "Robert P. J. Day" <rpjday@mindspring.com>

Prevent <linux/console_struct.h> from being included more than once,
otherwise you get a redefinition error if you happen to include
<linux/vt_kern.h> first.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/console_struct.h |    5 +++++
 1 files changed, 5 insertions(+)

diff -puN include/linux/console_struct.h~protect-linux-console_structh-from-multiple-inclusion include/linux/console_struct.h
--- a/include/linux/console_struct.h~protect-linux-console_structh-from-multiple-inclusion
+++ a/include/linux/console_struct.h
@@ -9,6 +9,9 @@
  * to achieve effects such as fast scrolling by changing the origin.
  */
 
+#ifndef _LINUX_CONSOLE_STRUCT_H
+#define _LINUX_CONSOLE_STRUCT_H
+
 #include <linux/wait.h>
 #include <linux/vt.h>
 #include <linux/workqueue.h>
@@ -130,3 +133,5 @@ extern void vc_SAK(struct work_struct *w
 #define CUR_DEFAULT CUR_UNDERLINE
 
 #define CON_IS_VISIBLE(conp) (*conp->vc_display_fg == conp)
+
+#endif /* _LINUX_CONSOLE_STRUCT_H */
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
ppc-remove-dead-code-for-preventing-pread-and-pwrite-calls.patch
viotape-use-designated-initializers-for-fops-member.patch
git-dvb.patch
git-ieee1394.patch
input-delete-useless-reference-to-dead-module_parm-macro.patch
git-kbuild.patch
git-kvm.patch
bluetooth-remove-the-redundant-non-seekable-llseek-method.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
git-s390.patch
git-scsi-misc.patch
remove-dead-references-to-module_parm-macro.patch
git-watchdog.patch
remove-the-deprecated-kmem_cache_t-typedef-from-slabh.patch
cris-replace-old-style-member-inits-with-designated-inits.patch
remove-unnecessary-includes-of-spinlockh-under-include-linux.patch
drop-an-empty-isicomh-from-being-exported-to-user-space.patch
remove-apparently-useless-commented-apm_get_battery_status.patch
cobalt-remove-all-references-to-cobalt-nvram.patch
centralize-checking-for-an-acceptable-version-of-gcc.patch
