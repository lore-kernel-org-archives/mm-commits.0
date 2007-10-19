From: akpm@linux-foundation.org
Subject: - extended-crashkernel-command-line.patch removed from -mm tree
Date: Fri, 19 Oct 2007 15:54:00 -0700
Message-ID: <200710192254.l9JMs0Bo024479@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59843 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967020AbXJSXGy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 19:06:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bwalle@suse.de, ak@suse.de, benh@kernel.crashing.org, ebiederm@xmission.com, lethal@linux-sh.org, paulus@samba.org, tony.luck@intel.com, vgoyal@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Extended crashkernel command line
has been removed from the -mm tree.  Its filename was
     extended-crashkernel-command-line.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Extended crashkernel command line
From: Bernhard Walle <bwalle@suse.de>

This patch adds a extended crashkernel syntax that makes the value of reserved
system RAM dependent on the system RAM itself:

    crashkernel=<range1>:<size1>[,<range2>:<size2>,...][@offset]
    range=start-[end]

For example:

    crashkernel=512M-2G:64M,2G-:128M

The motivation comes from distributors that configure their crashkernel
command line automatically with some configuration tool (YaST, you know ;)). 
Of course that tool knows the value of System RAM, but if the user removes
RAM, then the system becomes unbootable or at least unusable and error
handling is very difficult.

This series implements this change for i386, x86_64, ia64, ppc64 and sh.  That
should be all platforms that support kdump in current mainline.  I tested all
platforms except sh due to the lack of a sh processor.



This patch:

This is the generic part of the patch.  It adds a parse_crashkernel() function
in kernel/kexec.c that is called by the architecture specific code that
actually reserves the memory.  That function takes the whole command line and
looks itself for "crashkernel=" in it.

If there are multiple occurrences, then the last one is taken.  The advantage
is that if you have a bootloader like lilo or elilo which allows you to append
a command line parameter but not to remove one (like in GRUB), then you can
add another crashkernel value for testing at the boot command line and this
one overwrites the command line in the configuration then.

Signed-off-by: Bernhard Walle <bwalle@suse.de>
Cc: Andi Kleen <ak@suse.de>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Vivek Goyal <vgoyal@in.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kexec.h |    2 
 kernel/kexec.c        |  166 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 168 insertions(+)

diff -puN include/linux/kexec.h~extended-crashkernel-command-line include/linux/kexec.h
--- a/include/linux/kexec.h~extended-crashkernel-command-line
+++ a/include/linux/kexec.h
@@ -187,6 +187,8 @@ extern u32 vmcoreinfo_note[VMCOREINFO_NO
 extern size_t vmcoreinfo_size;
 extern size_t vmcoreinfo_max_size;
 
+int __init parse_crashkernel(char *cmdline, unsigned long long system_ram,
+		unsigned long long *crash_size, unsigned long long *crash_base);
 
 #else /* !CONFIG_KEXEC */
 struct pt_regs;
diff -puN kernel/kexec.c~extended-crashkernel-command-line kernel/kexec.c
--- a/kernel/kexec.c~extended-crashkernel-command-line
+++ a/kernel/kexec.c
@@ -1146,6 +1146,172 @@ static int __init crash_notes_memory_ini
 }
 module_init(crash_notes_memory_init)
 
+
+/*
+ * parsing the "crashkernel" commandline
+ *
+ * this code is intended to be called from architecture specific code
+ */
+
+
+/*
+ * This function parses command lines in the format
+ *
+ *   crashkernel=ramsize-range:size[,...][@offset]
+ *
+ * The function returns 0 on success and -EINVAL on failure.
+ */
+static int __init parse_crashkernel_mem(char 			*cmdline,
+					unsigned long long	system_ram,
+					unsigned long long	*crash_size,
+					unsigned long long	*crash_base)
+{
+	char *cur = cmdline, *tmp;
+
+	/* for each entry of the comma-separated list */
+	do {
+		unsigned long long start, end = ULLONG_MAX, size;
+
+		/* get the start of the range */
+		start = memparse(cur, &tmp);
+		if (cur == tmp) {
+			pr_warning("crashkernel: Memory value expected\n");
+			return -EINVAL;
+		}
+		cur = tmp;
+		if (*cur != '-') {
+			pr_warning("crashkernel: '-' expected\n");
+			return -EINVAL;
+		}
+		cur++;
+
+		/* if no ':' is here, than we read the end */
+		if (*cur != ':') {
+			end = memparse(cur, &tmp);
+			if (cur == tmp) {
+				pr_warning("crashkernel: Memory "
+						"value expected\n");
+				return -EINVAL;
+			}
+			cur = tmp;
+			if (end <= start) {
+				pr_warning("crashkernel: end <= start\n");
+				return -EINVAL;
+			}
+		}
+
+		if (*cur != ':') {
+			pr_warning("crashkernel: ':' expected\n");
+			return -EINVAL;
+		}
+		cur++;
+
+		size = memparse(cur, &tmp);
+		if (cur == tmp) {
+			pr_warning("Memory value expected\n");
+			return -EINVAL;
+		}
+		cur = tmp;
+		if (size >= system_ram) {
+			pr_warning("crashkernel: invalid size\n");
+			return -EINVAL;
+		}
+
+		/* match ? */
+		if (system_ram >= start && system_ram <= end) {
+			*crash_size = size;
+			break;
+		}
+	} while (*cur++ == ',');
+
+	if (*crash_size > 0) {
+		while (*cur != ' ' && *cur != '@')
+			cur++;
+		if (*cur == '@') {
+			cur++;
+			*crash_base = memparse(cur, &tmp);
+			if (cur == tmp) {
+				pr_warning("Memory value expected "
+						"after '@'\n");
+				return -EINVAL;
+			}
+		}
+	}
+
+	return 0;
+}
+
+/*
+ * That function parses "simple" (old) crashkernel command lines like
+ *
+ * 	crashkernel=size[@offset]
+ *
+ * It returns 0 on success and -EINVAL on failure.
+ */
+static int __init parse_crashkernel_simple(char 		*cmdline,
+					   unsigned long long 	*crash_size,
+					   unsigned long long 	*crash_base)
+{
+	char *cur = cmdline;
+
+	*crash_size = memparse(cmdline, &cur);
+	if (cmdline == cur) {
+		pr_warning("crashkernel: memory value expected\n");
+		return -EINVAL;
+	}
+
+	if (*cur == '@')
+		*crash_base = memparse(cur+1, &cur);
+
+	return 0;
+}
+
+/*
+ * That function is the entry point for command line parsing and should be
+ * called from the arch-specific code.
+ */
+int __init parse_crashkernel(char 		 *cmdline,
+			     unsigned long long system_ram,
+			     unsigned long long *crash_size,
+			     unsigned long long *crash_base)
+{
+	char 	*p = cmdline, *ck_cmdline = NULL;
+	char	*first_colon, *first_space;
+
+	BUG_ON(!crash_size || !crash_base);
+	*crash_size = 0;
+	*crash_base = 0;
+
+	/* find crashkernel and use the last one if there are more */
+	p = strstr(p, "crashkernel=");
+	while (p) {
+		ck_cmdline = p;
+		p = strstr(p+1, "crashkernel=");
+	}
+
+	if (!ck_cmdline)
+		return -EINVAL;
+
+	ck_cmdline += 12; /* strlen("crashkernel=") */
+
+	/*
+	 * if the commandline contains a ':', then that's the extended
+	 * syntax -- if not, it must be the classic syntax
+	 */
+	first_colon = strchr(ck_cmdline, ':');
+	first_space = strchr(ck_cmdline, ' ');
+	if (first_colon && (!first_space || first_colon < first_space))
+		return parse_crashkernel_mem(ck_cmdline, system_ram,
+				crash_size, crash_base);
+	else
+		return parse_crashkernel_simple(ck_cmdline, crash_size,
+				crash_base);
+
+	return 0;
+}
+
+
+
 void crash_save_vmcoreinfo(void)
 {
 	u32 *buf;
_

Patches currently in -mm which might be from bwalle@suse.de are

origin.patch
kexec-add-bss-to-resource-tree.patch
kexec-add-bss-to-resource-tree-checkpatch-fixes.patch
kexec-introduce-bootmem_exclusive.patch
kexec-introduce-bootmem_exclusive-checkpatch-fixes.patch
kexec-use-bootmem_exclusive-on-x86.patch
