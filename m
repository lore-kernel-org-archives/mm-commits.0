From: akpm@linux-foundation.org
Subject: + kprobes-the-on-off-knob-thru-debugfs-updated-s390-fix.patch added to -mm tree
Date: Tue, 10 Apr 2007 15:08:45 -0700
Message-ID: <200704102208.l3AM8jqD018884@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48865 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753966AbXDJWJC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Apr 2007 18:09:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cornelia.huck@de.ibm.com, ananth@in.ibm.com


The patch titled
     kprobes-the-on-off-knob-thru-debugfs-updated s390 fix
has been added to the -mm tree.  Its filename is
     kprobes-the-on-off-knob-thru-debugfs-updated-s390-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kprobes-the-on-off-knob-thru-debugfs-updated s390 fix
From: Cornelia Huck <cornelia.huck@de.ibm.com>

Add the missing arch_trampoline_kprobe() for s390.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/kernel/kprobes.c |    7 +++++++
 1 files changed, 7 insertions(+)

diff -puN arch/s390/kernel/kprobes.c~kprobes-the-on-off-knob-thru-debugfs-updated-s390-fix arch/s390/kernel/kprobes.c
--- a/arch/s390/kernel/kprobes.c~kprobes-the-on-off-knob-thru-debugfs-updated-s390-fix
+++ a/arch/s390/kernel/kprobes.c
@@ -662,3 +662,10 @@ int __init arch_init_kprobes(void)
 {
 	return register_kprobe(&trampoline_p);
 }
+
+int __kprobes arch_trampoline_kprobe(struct kprobe *p)
+{
+	if (p->addr == (kprobe_opcode_t *) & kretprobe_trampoline)
+		return 1;
+	return 0;
+}
_

Patches currently in -mm which might be from cornelia.huck@de.ibm.com are

driver-core-suppress-uevents-via-filter.patch
driver-core-switch-firmware_class-to.patch
s390-cio-delay-uevents-for-subchannels.patch
uevent-use-add_uevent_var-instead-of-open-coding-it.patch
sysfs-fix-i_ino-handling-in-sysfs.patch
sysfs-fix-error-handling-in-binattr-write.patch
sysfs-move-release_sysfs_dirent-to-dirc.patch
sysfs-flatten-cleanup-paths-in-sysfs_add_link-and-create_dir.patch
sysfs-consolidate-sysfs_dirent-creation-functions.patch
sysfs-add-sysfs_dirent-s_parent.patch
sysfs-add-sysfs_dirent-s_name.patch
sysfs-make-sysfs_dirent-s_element-a-union.patch
sysfs-implement-kobj_sysfs_assoc_lock.patch
sysfs-reimplement-symlink-using-sysfs_dirent-tree.patch
sysfs-implement-bin_buffer.patch
sysfs-implement-sysfs_dirent-active-reference-and-immediate-disconnect.patch
sysfs-kill-attribute-file-orphaning.patch
sysfs-kill-unnecessary-attribute-owner.patch
sysfs-kill-unnecessary-attribute-owner-fix.patch
git-s390.patch
kprobes-the-on-off-knob-thru-debugfs-updated-s390-fix.patch
