From: akpm@linux-foundation.org
Subject: - add-sys-kernel-notes.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:02:50 -0700
Message-ID: <200707192002.l6JK2oEc019790@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36504 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757531AbXGSUfH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:35:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roland@redhat.com, ak@suse.de, benh@kernel.crashing.org, heiko.carstens@de.ibm.com, ink@jurassic.park.msu.ru, paulus@samba.org, rth@twiddle.net, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Add /sys/kernel/notes
has been removed from the -mm tree.  Its filename was
     add-sys-kernel-notes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Add /sys/kernel/notes
From: Roland McGrath <roland@redhat.com>

This patch adds the /sys/kernel/notes magic file.  Reading this delivers the
contents of the kernel's .notes section.  This lets userland easily glean any
detailed information about the running kernel's build that was stored there at
compile time.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/ksysfs.c |   28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff -puN kernel/ksysfs.c~add-sys-kernel-notes kernel/ksysfs.c
--- a/kernel/ksysfs.c~add-sys-kernel-notes
+++ a/kernel/ksysfs.c
@@ -62,6 +62,28 @@ static ssize_t kexec_crash_loaded_show(s
 KERNEL_ATTR_RO(kexec_crash_loaded);
 #endif /* CONFIG_KEXEC */
 
+/*
+ * Make /sys/kernel/notes give the raw contents of our kernel .notes section.
+ */
+extern const char __start_notes __attribute__((weak));
+extern const char __stop_notes __attribute__((weak));
+#define	notes_size (&__stop_notes - &__start_notes)
+
+static ssize_t notes_read(struct kobject *kobj, struct bin_attribute *bin_attr,
+			  char *buf, loff_t off, size_t count)
+{
+	memcpy(buf, &__start_notes + off, count);
+	return count;
+}
+
+static struct bin_attribute notes_attr = {
+	.attr = {
+		.name = "notes",
+		.mode = S_IRUGO,
+	},
+	.read = &notes_read,
+};
+
 decl_subsys(kernel, NULL, NULL);
 EXPORT_SYMBOL_GPL(kernel_subsys);
 
@@ -88,6 +110,12 @@ static int __init ksysfs_init(void)
 		error = sysfs_create_group(&kernel_subsys.kobj,
 					   &kernel_attr_group);
 
+	if (!error && notes_size > 0) {
+		notes_attr.size = notes_size;
+		error = sysfs_create_bin_file(&kernel_subsys.kobj,
+					      &notes_attr);
+	}
+
 	return error;
 }
 
_

Patches currently in -mm which might be from roland@redhat.com are

origin.patch
xen-disable-vdso-nosegneg-on-native-boot.patch
powerpc-vdso-install-unstripped-copies-on-disk.patch
pass-g-to-assembler-under-config_debug_info.patch
i386-vdso-install-unstripped-copies-on-disk.patch
i386-vdso-install-unstripped-copies-on-disk-fix.patch
x86_64-ia32-vdso-install-unstripped-copies-on-disk.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
