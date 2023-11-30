Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE31AC4167B
	for <mm-commits@archiver.kernel.org>; Thu, 30 Nov 2023 21:57:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232317AbjK3V5J (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 30 Nov 2023 16:57:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbjK3V5I (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 30 Nov 2023 16:57:08 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 121B310DC
        for <mm-commits@vger.kernel.org>; Thu, 30 Nov 2023 13:57:14 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F996C433C8;
        Thu, 30 Nov 2023 21:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701381433;
        bh=EhH4qGz1SVzCq4QAEtDmER4lchkzaX9zp/vInzBbiSo=;
        h=Date:To:From:Subject:From;
        b=i+BuPvkRBBjjhKqixla12OiBIdD6/W0pUIEiuKOiwIwjNNW0Z5mZGw6F3aUVM8ymV
         kRNw6Lde+8iVPF5WA844qQ96XvNgmw9AScZY5GVaaobzGJc6XeZ6KbchviN0mTkcBW
         m2wjN0KQTWp2Vtp6l0qbAtxXOXpfXvyeWFiy0L+A=
Date:   Thu, 30 Nov 2023 13:57:12 -0800
To:     mm-commits@vger.kernel.org, nathan@kernel.org, joe@perches.com,
        bhe@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kexec_file-add-kexec_file-flag-to-control-debug-printing.patch added to mm-nonmm-unstable branch
Message-Id: <20231130215713.8F996C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kexec_file: add kexec_file flag to control debug printing
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kexec_file-add-kexec_file-flag-to-control-debug-printing.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kexec_file-add-kexec_file-flag-to-control-debug-printing.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: kexec_file: add kexec_file flag to control debug printing
Date: Thu, 30 Nov 2023 10:39:49 +0800

Patch series "kexec_file: print out debugging message if required", v3.

Currently, specifying '-d' on kexec command will print a lot of debugging
informationabout kexec/kdump loading with kexec_load interface.

However, kexec_file_load prints nothing even though '-d' is specified. 
It's very inconvenient to debug or analyze the kexec/kdump loading when
something wrong happened with kexec/kdump itself or develper want to check
the kexec/kdump loading.

In this patchset, a kexec_file flag is KEXEC_FILE_DEBUG added and checked
in code.  If it's passed in, debugging message of kexec_file code will be
printed out and can be seen from console and dmesg.  Otherwise, the
debugging message is printed like beofre when pr_debug() is taken.

Note:
****
=====
1) The code in kexec-tools utility also need be changed to support
passing KEXEC_FILE_DEBUG to kernel when 'kexec -s -d' is specified.
The patch link is here:
=========
[PATCH] kexec_file: add kexec_file flag to support debug printing
http://lists.infradead.org/pipermail/kexec/2023-November/028505.html

2) s390 also has kexec_file code, while I am not sure what debugging
information is necessary. So leave it to s390 developer.

Test:
****
====
Testing was done in v1 on x86_64 and arm64. For v3, tested on x86_64
again. And on x86_64, the printed messages look like below:
--------------------------------------------------------------
kexec measurement buffer for the loaded kernel at 0x207fffe000.
Loaded purgatory at 0x207fff9000
Loaded boot_param, command line and misc at 0x207fff3000 bufsz=0x1180 memsz=0x1180
Loaded 64bit kernel at 0x207c000000 bufsz=0xc88200 memsz=0x3c4a000
Loaded initrd at 0x2079e79000 bufsz=0x2186280 memsz=0x2186280
Final command line is: root=/dev/mapper/fedora_intel--knightslanding--lb--02-root ro
rd.lvm.lv=fedora_intel-knightslanding-lb-02/root console=ttyS0,115200N81 crashkernel=256M
E820 memmap:
0000000000000000-000000000009a3ff (1)
000000000009a400-000000000009ffff (2)
00000000000e0000-00000000000fffff (2)
0000000000100000-000000006ff83fff (1)
000000006ff84000-000000007ac50fff (2)
......
000000207fff6150-000000207fff615f (128)
000000207fff6160-000000207fff714f (1)
000000207fff7150-000000207fff715f (128)
000000207fff7160-000000207fff814f (1)
000000207fff8150-000000207fff815f (128)
000000207fff8160-000000207fffffff (1)
nr_segments = 5
segment[0]: buf=0x000000004e5ece74 bufsz=0x211 mem=0x207fffe000 memsz=0x1000
segment[1]: buf=0x000000009e871498 bufsz=0x4000 mem=0x207fff9000 memsz=0x5000
segment[2]: buf=0x00000000d879f1fe bufsz=0x1180 mem=0x207fff3000 memsz=0x2000
segment[3]: buf=0x000000001101cd86 bufsz=0xc88200 mem=0x207c000000 memsz=0x3c4a000
segment[4]: buf=0x00000000c6e38ac7 bufsz=0x2186280 mem=0x2079e79000 memsz=0x2187000
kexec_file_load: type:0, start:0x207fff91a0 head:0x109e004002 flags:0x8
---------------------------------------------------------------------------


This patch (of 7):

When specifying 'kexec -c -d', kexec_load interface will print loading
information, e.g the regions where kernel/initrd/purgatory/cmdline are
put, the memmap passed to 2nd kernel taken as system RAM ranges, and
printing all contents of struct kexec_segment, etc.  These are very
helpful for analyzing or positioning what's happening when kexec/kdump
itself failed.  The debugging printing for kexec_load interface is made in
user space utility kexec-tools.

Whereas, with kexec_file_load interface, 'kexec -s -d' print nothing. 
Because kexec_file code is mostly implemented in kernel space, and the
debugging printing functionality is missed.  It's not convenient when
debugging kexec/kdump loading and jumping with kexec_file_load interface.

Now add KEXEC_FILE_DEBUG to kexec_file flag to control the debugging
message printing.  And add global variable kexec_file_dbg_print and macro
kexec_dprintk() to facilitate the printing.

This is a preparation, later kexec_dprintk() will be used to replace the
existing pr_debug().  Once 'kexec -s -d' is specified, it will print out
kexec/kdump loading information.  If '-d' is not specified, it regresses
to pr_debug().

Link: https://lkml.kernel.org/r/20231130023955.5257-1-bhe@redhat.com
Link: https://lkml.kernel.org/r/20231130023955.5257-2-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Joe Perches <joe@perches.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kexec.h      |    9 ++++++++-
 include/uapi/linux/kexec.h |    1 +
 kernel/kexec_core.c        |    2 ++
 kernel/kexec_file.c        |    3 +++
 4 files changed, 14 insertions(+), 1 deletion(-)

--- a/include/linux/kexec.h~kexec_file-add-kexec_file-flag-to-control-debug-printing
+++ a/include/linux/kexec.h
@@ -403,7 +403,7 @@ bool kexec_load_permitted(int kexec_imag
 
 /* List of defined/legal kexec file flags */
 #define KEXEC_FILE_FLAGS	(KEXEC_FILE_UNLOAD | KEXEC_FILE_ON_CRASH | \
-				 KEXEC_FILE_NO_INITRAMFS)
+				 KEXEC_FILE_NO_INITRAMFS | KEXEC_FILE_DEBUG)
 
 /* flag to track if kexec reboot is in progress */
 extern bool kexec_in_progress;
@@ -500,6 +500,13 @@ static inline int crash_hotplug_memory_s
 static inline unsigned int crash_get_elfcorehdr_size(void) { return 0; }
 #endif
 
+extern bool kexec_file_dbg_print;
+
+#define kexec_dprintk(fmt, ...)					\
+	printk("%s" fmt,					\
+	       kexec_file_dbg_print ? KERN_INFO : KERN_DEBUG,	\
+	       ##__VA_ARGS__)
+
 #else /* !CONFIG_KEXEC_CORE */
 struct pt_regs;
 struct task_struct;
--- a/include/uapi/linux/kexec.h~kexec_file-add-kexec_file-flag-to-control-debug-printing
+++ a/include/uapi/linux/kexec.h
@@ -25,6 +25,7 @@
 #define KEXEC_FILE_UNLOAD	0x00000001
 #define KEXEC_FILE_ON_CRASH	0x00000002
 #define KEXEC_FILE_NO_INITRAMFS	0x00000004
+#define KEXEC_FILE_DEBUG	0x00000008
 
 /* These values match the ELF architecture values.
  * Unless there is a good reason that should continue to be the case.
--- a/kernel/kexec_core.c~kexec_file-add-kexec_file-flag-to-control-debug-printing
+++ a/kernel/kexec_core.c
@@ -52,6 +52,8 @@ atomic_t __kexec_lock = ATOMIC_INIT(0);
 /* Flag to indicate we are going to kexec a new kernel */
 bool kexec_in_progress = false;
 
+bool kexec_file_dbg_print;
+
 int kexec_should_crash(struct task_struct *p)
 {
 	/*
--- a/kernel/kexec_file.c~kexec_file-add-kexec_file-flag-to-control-debug-printing
+++ a/kernel/kexec_file.c
@@ -123,6 +123,8 @@ void kimage_file_post_load_cleanup(struc
 	 */
 	kfree(image->image_loader_data);
 	image->image_loader_data = NULL;
+
+	kexec_file_dbg_print = false;
 }
 
 #ifdef CONFIG_KEXEC_SIG
@@ -278,6 +280,7 @@ kimage_file_alloc_init(struct kimage **r
 	if (!image)
 		return -ENOMEM;
 
+	kexec_file_dbg_print = !!(flags & KEXEC_FILE_DEBUG);
 	image->file_mode = 1;
 
 	if (kexec_on_panic) {
_

Patches currently in -mm which might be from bhe@redhat.com are

drivers-base-cpu-crash-data-showing-should-depends-on-kexec_core.patch
kernel-kconfigkexec-drop-select-of-kexec-for-crash_dump.patch
loongarch-change-dependency-of-object-files.patch
resource-add-walk_system_ram_res_rev.patch
kexec_file-load-kernel-at-top-of-system-ram-if-required.patch
kexec_file-add-kexec_file-flag-to-control-debug-printing.patch
kexec_file-print-out-debugging-message-if-required.patch
kexec_file-x86-print-out-debugging-message-if-required.patch
kexec_file-arm64-print-out-debugging-message-if-required.patch
kexec_file-ricv-print-out-debugging-message-if-required.patch
kexec_file-power-print-out-debugging-message-if-required.patch
kexec_file-parisc-print-out-debugging-message-if-required.patch

