From: akpm@linux-foundation.org
Subject: - add-vmcore-cleanup-the-coding-style-according-to-andrews-comments.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:57:01 -0700
Message-ID: <200710180657.l9I6v1JS030747@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42314 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762701AbXJRHPo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:15:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oomichi@mxs.nes.nec.co.jp, mm-commits@vger.kernel.org


The patch titled
     add-vmcore: cleanup the coding style according to Andrew's comments
has been removed from the -mm tree.  Its filename was
     add-vmcore-cleanup-the-coding-style-according-to-andrews-comments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: add-vmcore: cleanup the coding style according to Andrew's comments
From: "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>

[1/3] Cleanup the coding style according to Andrew's comments:
http://lists.infradead.org/pipermail/kexec/2007-August/000522.html
- vmcoreinfo_append_str() should have suitable __attribute__s so that
  the compiler can check its use.
- vmcoreinfo_max_size should have size_t.
- Use get_seconds() instead of xtime.tv_sec.
- Use init_uts_ns.name.release instead of UTS_RELEASE.

Signed-off-by: Ken'ichi Ohmichi <oomichi@mxs.nes.nec.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kexec.h |   16 +++++++++-------
 kernel/kexec.c        |   10 +++++-----
 kernel/ksysfs.c       |    2 +-
 3 files changed, 15 insertions(+), 13 deletions(-)

diff -puN include/linux/kexec.h~add-vmcore-cleanup-the-coding-style-according-to-andrews-comments include/linux/kexec.h
--- a/include/linux/kexec.h~add-vmcore-cleanup-the-coding-style-according-to-andrews-comments
+++ a/include/linux/kexec.h
@@ -123,18 +123,20 @@ int kexec_should_crash(struct task_struc
 void crash_save_cpu(struct pt_regs *regs, int cpu);
 void crash_save_vmcoreinfo(void);
 void arch_crash_save_vmcoreinfo(void);
-void vmcoreinfo_append_str(const char *fmt, ...);
+void vmcoreinfo_append_str(const char *fmt, ...)
+	__attribute__ ((format (printf, 1, 2)));
 unsigned long paddr_vmcoreinfo_note(void);
 
 #define SYMBOL(name) \
 	vmcoreinfo_append_str("SYMBOL(%s)=%lx\n", #name, (unsigned long)&name)
 #define SIZE(name) \
-	vmcoreinfo_append_str("SIZE(%s)=%d\n", #name, sizeof(struct name))
+	vmcoreinfo_append_str("SIZE(%s)=%lu\n", #name, \
+			      (unsigned long)sizeof(struct name))
 #define OFFSET(name, field) \
-	vmcoreinfo_append_str("OFFSET(%s.%s)=%d\n", #name, #field, \
-			      &(((struct name *)0)->field))
+	vmcoreinfo_append_str("OFFSET(%s.%s)=%lu\n", #name, #field, \
+			      (unsigned long)&(((struct name *)0)->field))
 #define LENGTH(name, value) \
-	vmcoreinfo_append_str("LENGTH(%s)=%d\n", #name, value)
+	vmcoreinfo_append_str("LENGTH(%s)=%lu\n", #name, (unsigned long)value)
 #define CONFIG(name) \
 	vmcoreinfo_append_str("CONFIG_%s=y\n", #name)
 
@@ -177,8 +179,8 @@ extern struct resource crashk_res;
 typedef u32 note_buf_t[KEXEC_NOTE_BYTES/4];
 extern note_buf_t *crash_notes;
 extern u32 vmcoreinfo_note[VMCOREINFO_NOTE_SIZE/4];
-extern unsigned int vmcoreinfo_size;
-extern unsigned int vmcoreinfo_max_size;
+extern size_t vmcoreinfo_size;
+extern size_t vmcoreinfo_max_size;
 
 
 #else /* !CONFIG_KEXEC */
diff -puN kernel/kexec.c~add-vmcore-cleanup-the-coding-style-according-to-andrews-comments kernel/kexec.c
--- a/kernel/kexec.c~add-vmcore-cleanup-the-coding-style-according-to-andrews-comments
+++ a/kernel/kexec.c
@@ -38,8 +38,8 @@ note_buf_t* crash_notes;
 /* vmcoreinfo stuff */
 unsigned char vmcoreinfo_data[VMCOREINFO_BYTES];
 u32 vmcoreinfo_note[VMCOREINFO_NOTE_SIZE/4];
-unsigned int vmcoreinfo_size = 0;
-unsigned int vmcoreinfo_max_size = sizeof(vmcoreinfo_data);
+size_t vmcoreinfo_size;
+size_t vmcoreinfo_max_size = sizeof(vmcoreinfo_data);
 
 /* Location of the reserved area for the crash kernel */
 struct resource crashk_res = {
@@ -1153,7 +1153,7 @@ void crash_save_vmcoreinfo(void)
 	if (!vmcoreinfo_size)
 		return;
 
-	vmcoreinfo_append_str("CRASHTIME=%d", xtime.tv_sec);
+	vmcoreinfo_append_str("CRASHTIME=%ld", get_seconds());
 
 	buf = (u32 *)vmcoreinfo_note;
 
@@ -1195,8 +1195,8 @@ unsigned long __attribute__ ((weak)) pad
 
 static int __init crash_save_vmcoreinfo_init(void)
 {
-	vmcoreinfo_append_str("OSRELEASE=%s\n", UTS_RELEASE);
-	vmcoreinfo_append_str("PAGESIZE=%d\n", PAGE_SIZE);
+	vmcoreinfo_append_str("OSRELEASE=%s\n", init_uts_ns.name.release);
+	vmcoreinfo_append_str("PAGESIZE=%ld\n", PAGE_SIZE);
 
 	SYMBOL(init_uts_ns);
 	SYMBOL(node_online_map);
diff -puN kernel/ksysfs.c~add-vmcore-cleanup-the-coding-style-according-to-andrews-comments kernel/ksysfs.c
--- a/kernel/ksysfs.c~add-vmcore-cleanup-the-coding-style-according-to-andrews-comments
+++ a/kernel/ksysfs.c
@@ -66,7 +66,7 @@ static ssize_t vmcoreinfo_show(struct ks
 {
 	return sprintf(page, "%lx %x\n",
 		       paddr_vmcoreinfo_note(),
-		       vmcoreinfo_max_size);
+		       (unsigned int)vmcoreinfo_max_size);
 }
 KERNEL_ATTR_RO(vmcoreinfo);
 
_

Patches currently in -mm which might be from oomichi@mxs.nes.nec.co.jp are

origin.patch
