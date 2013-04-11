From: akpm@linux-foundation.org
Subject: + dmi-morph-dmi_dump_ids-into-dmi_format_ids-which-formats-into-a-buffer.patch added to -mm tree
Date: Thu, 11 Apr 2013 13:07:41 -0700
Message-ID: <20130411200741.EE2BE31C10E@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:40886 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753650Ab3DKUHo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Apr 2013 16:07:44 -0400
Received: by mail-yh0-f74.google.com with SMTP id q10so179873yhf.3
        for <mm-commits@vger.kernel.org>; Thu, 11 Apr 2013 13:07:42 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tj@kernel.org, bhelgaas@google.com, davem@davemloft.net, fengguang.wu@intel.com, heiko.carstens@de.ibm.com, jesper.nilsson@axis.com, sam@ravnborg.org, schwidefsky@de.ibm.com, vapier@gentoo.org, vgupta@synopsys.com


The patch titled
     Subject: dmi: morph dmi_dump_ids() into dmi_format_ids() which formats into a buffer
has been added to the -mm tree.  Its filename is
     dmi-morph-dmi_dump_ids-into-dmi_format_ids-which-formats-into-a-buffer.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: dmi: morph dmi_dump_ids() into dmi_format_ids() which formats into a buffer

We're gonna use DMI identification for other purposes too.  Morph
dmi_dump_ids() which is used to print DMI identification as a debug
message during boot into dmi_format_ids() which formats the same
information sans the leading "DMI:" tag into a string buffer.

dmi_present() is updated to format the information into dmi_ids_string[]
using the new function and print it with "DMI:" prefix.  dmi_ids_string[]
will be used for another purpose by a future patch.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/dmi_scan.c |   44 ++++++++++++++++++++--------------
 1 file changed, 27 insertions(+), 17 deletions(-)

diff -puN drivers/firmware/dmi_scan.c~dmi-morph-dmi_dump_ids-into-dmi_format_ids-which-formats-into-a-buffer drivers/firmware/dmi_scan.c
--- a/drivers/firmware/dmi_scan.c~dmi-morph-dmi_dump_ids-into-dmi_format_ids-which-formats-into-a-buffer
+++ a/drivers/firmware/dmi_scan.c
@@ -22,6 +22,9 @@ static u16 __initdata dmi_ver;
  */
 static int dmi_initialized;
 
+/* DMI system identification string used during boot */
+static char dmi_ids_string[128] __initdata;
+
 static const char * __init dmi_string_nosave(const struct dmi_header *dm, u8 s)
 {
 	const u8 *bp = ((u8 *) dm) + dm->length;
@@ -376,38 +379,44 @@ static void __init dmi_decode(const stru
 	}
 }
 
-static void __init print_filtered(const char *info)
+static int __init print_filtered(char *buf, size_t len, const char *info)
 {
+	int c = 0;
 	const char *p;
 
 	if (!info)
-		return;
+		return c;
 
 	for (p = info; *p; p++)
 		if (isprint(*p))
-			printk(KERN_CONT "%c", *p);
+			c += scnprintf(buf + c, len - c, "%c", *p);
 		else
-			printk(KERN_CONT "\\x%02x", *p & 0xff);
+			c += scnprintf(buf + c, len - c, "\\x%02x", *p & 0xff);
+	return c;
 }
 
-static void __init dmi_dump_ids(void)
+static void __init dmi_format_ids(char *buf, size_t len)
 {
+	int c = 0;
 	const char *board;	/* Board Name is optional */
 
-	printk(KERN_DEBUG "DMI: ");
-	print_filtered(dmi_get_system_info(DMI_SYS_VENDOR));
-	printk(KERN_CONT " ");
-	print_filtered(dmi_get_system_info(DMI_PRODUCT_NAME));
+	c += print_filtered(buf + c, len - c,
+			    dmi_get_system_info(DMI_SYS_VENDOR));
+	c += scnprintf(buf + c, len - c, " ");
+	c += print_filtered(buf + c, len - c,
+			    dmi_get_system_info(DMI_PRODUCT_NAME));
+
 	board = dmi_get_system_info(DMI_BOARD_NAME);
 	if (board) {
-		printk(KERN_CONT "/");
-		print_filtered(board);
+		c += scnprintf(buf + c, len - c, "/");
+		c += print_filtered(buf + c, len - c, board);
 	}
-	printk(KERN_CONT ", BIOS ");
-	print_filtered(dmi_get_system_info(DMI_BIOS_VERSION));
-	printk(KERN_CONT " ");
-	print_filtered(dmi_get_system_info(DMI_BIOS_DATE));
-	printk(KERN_CONT "\n");
+	c += scnprintf(buf + c, len - c, ", BIOS ");
+	c += print_filtered(buf + c, len - c,
+			    dmi_get_system_info(DMI_BIOS_VERSION));
+	c += scnprintf(buf + c, len - c, " ");
+	c += print_filtered(buf + c, len - c,
+			    dmi_get_system_info(DMI_BIOS_DATE));
 }
 
 static int __init dmi_present(const char __iomem *p)
@@ -431,7 +440,8 @@ static int __init dmi_present(const char
 				pr_info("Legacy DMI %d.%d present.\n",
 				       dmi_ver >> 8, dmi_ver & 0xFF);
 			}
-			dmi_dump_ids();
+			dmi_format_ids(dmi_ids_string, sizeof(dmi_ids_string));
+			printk(KERN_DEBUG "DMI: %s\n", dmi_ids_string);
 			return 0;
 		}
 	}
_

Patches currently in -mm which might be from tj@kernel.org are

origin.patch
linux-next.patch
thinkpad-acpi-kill-hotkey_thread_mutex.patch
block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch
memblock-add-assertion-for-zero-allocation-alignment.patch
memcg-do-not-check-for-do_swap_account-in-mem_cgroup_readwritereset.patch
kernel-cpusetc-use-register_hotmemory_notifier.patch
rpmsg-fix-error-return-code-in-rpmsg_probe.patch
x86-dont-show-trace-beyond-show_stacknull-null.patch
sparc32-make-show_stack-acquire-%fp-if-_ksp-is-not-specified.patch
dump_stack-consolidate-dump_stack-implementations-and-unify-their-behaviors.patch
dmi-morph-dmi_dump_ids-into-dmi_format_ids-which-formats-into-a-buffer.patch
dump_stack-implement-arch-specific-hardware-description-in-task-dumps.patch
dump_stack-unify-debug-information-printed-by-show_regs.patch
arc-print-fatal-signals-reduce-duplicated-information.patch
rtc-add-devm_rtc_device_registerunregister.patch
rtc-use-struct-device-as-the-first-argument-for-devm_rtc_device_register.patch
usermodehelper-export-_exec-and-_setup-functions.patch
usermodehelper-export-_exec-and-_setup-functions-fix.patch
kmod-split-call-to-call_usermodehelper_fns.patch
keys-split-call-to-call_usermodehelper_fns.patch
coredump-remove-trailling-whitespaces.patch
split-remaining-calls-to-call_usermodehelper_fns.patch
kmod-remove-call_usermodehelper_fns.patch
coredump-only-sigkill-should-interrupt-the-coredumping-task.patch
coredump-ensure-that-sigkill-always-kills-the-dumping-thread.patch
coredump-sanitize-the-setting-of-signal-group_exit_code.patch
coredump-introduce-dump_interrupted.patch
coredump-factor-out-the-setting-of-pf_dumpcore.patch
coredump-change-wait_for_dump_helpers-to-use-wait_event_interruptible.patch
exec-do-not-abuse-cred_guard_mutex-in-threadgroup_lock.patch
idr-introduce-idr_alloc_cyclic.patch
drivers-infiniband-hw-amso1100-convert-to-using-idr_alloc_cyclic.patch
drivers-infiniband-hw-mlx4-convert-to-using-idr_alloc_cyclic.patch
nfsd-convert-nfs4_alloc_stid-to-use-idr_alloc_cyclic.patch
inotify-convert-inotify_add_to_idr-to-use-idr_alloc_cyclic.patch
sctp-convert-sctp_assoc_set_id-to-use-idr_alloc_cyclic.patch

