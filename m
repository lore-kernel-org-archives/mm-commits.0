Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C02D78E79
	for <mm-commits@vger.kernel.org>; Wed, 13 Dec 2023 20:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="S6sIaRne"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36C13C433C7;
	Wed, 13 Dec 2023 20:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702498475;
	bh=LyDeT0LhEzjfHECNpot3uvskj6H946Y40EAD0SR+A7g=;
	h=Date:To:From:Subject:From;
	b=S6sIaRne2vAYGUaX34oTVaNLfTXIqCY3eEGKVtAwAAqLeegixjvQ+dfnjQFVXgHQC
	 dDxlJU4yj0MgeVyRqQ3cQVKEhvqXeG29RY03d5zGSqQSadIktLmQz5kYIyBOxGCFYi
	 HX0xsKORBbC1rrJ4iw9hwKTMdheD+Cx8Yh9E8JtQ=
Date: Wed, 13 Dec 2023 12:14:34 -0800
To: mm-commits@vger.kernel.org,nathan@kernel.org,joe@perches.com,conor@kernel.org,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kexec_file-add-kexec_file-flag-to-control-debug-printing.patch added to mm-unstable branch
Message-Id: <20231213201435.36C13C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kexec_file: add kexec_file flag to control debug printing
has been added to the -mm mm-unstable branch.  Its filename is
     kexec_file-add-kexec_file-flag-to-control-debug-printing.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kexec_file-add-kexec_file-flag-to-control-debug-printing.patch

This patch will later appear in the mm-unstable branch at
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
Date: Wed, 13 Dec 2023 13:57:41 +0800

Patch series "kexec_file: print out debugging message if required", v4.

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
Testing was done in v1 on x86_64 and arm64. For v4, tested on x86_64
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

Link: https://lkml.kernel.org/r/20231213055747.61826-1-bhe@redhat.com
Link: https://lkml.kernel.org/r/20231213055747.61826-2-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Conor Dooley <conor@kernel.org>
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

kexec_file-add-kexec_file-flag-to-control-debug-printing.patch
kexec_file-print-out-debugging-message-if-required.patch
kexec_file-x86-print-out-debugging-message-if-required.patch
kexec_file-arm64-print-out-debugging-message-if-required.patch
kexec_file-ricv-print-out-debugging-message-if-required.patch
kexec_file-power-print-out-debugging-message-if-required.patch
kexec_file-parisc-print-out-debugging-message-if-required.patch
riscv-kexec-fix-the-ifdeffery-for-aflags_kexec_relocateo.patch

