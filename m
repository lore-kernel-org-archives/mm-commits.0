Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59A95C07E99
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jul 2021 21:33:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4034B613EB
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jul 2021 21:33:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbhGIVga (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jul 2021 17:36:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:47246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231146AbhGIVga (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 9 Jul 2021 17:36:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C69DA613C3;
        Fri,  9 Jul 2021 21:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625866426;
        bh=koLcoSYcyO44lvfcRv/lncn7XsRAufoOqKz6V/1Mjpw=;
        h=Date:From:To:Subject:From;
        b=g+nv+agLN4WZqcBZ4fn7X78XGcyOhJa7EiiKhsbFc273ws00o9o/9V447nmCgVcJc
         SXijP7xjHO/t3OkcZNJgoKvJRUi++qKkqSH7H1FU5ZPF3CbJkVDTK1NPDbq8WvkZfy
         fxGzmMWgniaEMm9NyqhdOEpnAMIIezHli9OosSI4=
Date:   Fri, 09 Jul 2021 14:33:45 -0700
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, ast@kernel.org, bhe@redhat.com,
        bp@alien8.de, catalin.marinas@arm.com, dyoung@redhat.com,
        evgreen@chromium.org, hsinyi@chromium.org, jeyu@kernel.org,
        jolsa@kernel.org, khlebnikov@yandex-team.ru,
        linux@rasmusvillemoes.dk, mingo@redhat.com,
        mm-commits@vger.kernel.org, pmladek@suse.com, rostedt@goodmis.org,
        sashal@kernel.org, sergey.senozhatsky@gmail.com,
        swboyd@chromium.org, tglx@linutronix.de, vgoyal@redhat.com,
        will@kernel.org, willy@infradead.org
Subject:  [merged] kdump-use-vmlinux_build_id-to-simplify.patch
 removed from -mm tree
Message-ID: <20210709213345.n_HZ49dFW%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kdump: use vmlinux_build_id to simplify
has been removed from the -mm tree.  Its filename was
     kdump-use-vmlinux_build_id-to-simplify.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Stephen Boyd <swboyd@chromium.org>
Subject: kdump: use vmlinux_build_id to simplify

We can use the vmlinux_build_id array here now instead of open coding it. 
This mostly consolidates code.

Link: https://lkml.kernel.org/r/20210511003845.2429846-14-swboyd@chromium.org
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Jessica Yu <jeyu@kernel.org>
Cc: Evan Green <evgreen@chromium.org>
Cc: Hsin-Yi Wang <hsinyi@chromium.org>
Cc: Dave Young <dyoung@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/buildid.h    |    2 -
 include/linux/crash_core.h |   12 ++++----
 kernel/crash_core.c        |   50 +----------------------------------
 lib/buildid.c              |    2 -
 4 files changed, 10 insertions(+), 56 deletions(-)

--- a/include/linux/buildid.h~kdump-use-vmlinux_build_id-to-simplify
+++ a/include/linux/buildid.h
@@ -10,7 +10,7 @@ int build_id_parse(struct vm_area_struct
 		   __u32 *size);
 int build_id_parse_buf(const void *buf, unsigned char *build_id, u32 buf_size);
 
-#if IS_ENABLED(CONFIG_STACKTRACE_BUILD_ID)
+#if IS_ENABLED(CONFIG_STACKTRACE_BUILD_ID) || IS_ENABLED(CONFIG_CRASH_CORE)
 extern unsigned char vmlinux_build_id[BUILD_ID_SIZE_MAX];
 void init_vmlinux_build_id(void);
 #else
--- a/include/linux/crash_core.h~kdump-use-vmlinux_build_id-to-simplify
+++ a/include/linux/crash_core.h
@@ -38,8 +38,12 @@ phys_addr_t paddr_vmcoreinfo_note(void);
 
 #define VMCOREINFO_OSRELEASE(value) \
 	vmcoreinfo_append_str("OSRELEASE=%s\n", value)
-#define VMCOREINFO_BUILD_ID(value) \
-	vmcoreinfo_append_str("BUILD-ID=%s\n", value)
+#define VMCOREINFO_BUILD_ID()						\
+	({								\
+		static_assert(sizeof(vmlinux_build_id) == 20);		\
+		vmcoreinfo_append_str("BUILD-ID=%20phN\n", vmlinux_build_id); \
+	})
+
 #define VMCOREINFO_PAGESIZE(value) \
 	vmcoreinfo_append_str("PAGESIZE=%ld\n", value)
 #define VMCOREINFO_SYMBOL(name) \
@@ -69,10 +73,6 @@ extern unsigned char *vmcoreinfo_data;
 extern size_t vmcoreinfo_size;
 extern u32 *vmcoreinfo_note;
 
-/* raw contents of kernel .notes section */
-extern const void __start_notes __weak;
-extern const void __stop_notes __weak;
-
 Elf_Word *append_elf_note(Elf_Word *buf, char *name, unsigned int type,
 			  void *data, size_t data_len);
 void final_note(Elf_Word *buf);
--- a/kernel/crash_core.c~kdump-use-vmlinux_build_id-to-simplify
+++ a/kernel/crash_core.c
@@ -4,6 +4,7 @@
  * Copyright (C) 2002-2004 Eric Biederman  <ebiederm@xmission.com>
  */
 
+#include <linux/buildid.h>
 #include <linux/crash_core.h>
 #include <linux/utsname.h>
 #include <linux/vmalloc.h>
@@ -378,53 +379,6 @@ phys_addr_t __weak paddr_vmcoreinfo_note
 }
 EXPORT_SYMBOL(paddr_vmcoreinfo_note);
 
-#define NOTES_SIZE (&__stop_notes - &__start_notes)
-#define BUILD_ID_MAX SHA1_DIGEST_SIZE
-#define NT_GNU_BUILD_ID 3
-
-struct elf_note_section {
-	struct elf_note	n_hdr;
-	u8 n_data[];
-};
-
-/*
- * Add build ID from .notes section as generated by the GNU ld(1)
- * or LLVM lld(1) --build-id option.
- */
-static void add_build_id_vmcoreinfo(void)
-{
-	char build_id[BUILD_ID_MAX * 2 + 1];
-	int n_remain = NOTES_SIZE;
-
-	while (n_remain >= sizeof(struct elf_note)) {
-		const struct elf_note_section *note_sec =
-			&__start_notes + NOTES_SIZE - n_remain;
-		const u32 n_namesz = note_sec->n_hdr.n_namesz;
-
-		if (note_sec->n_hdr.n_type == NT_GNU_BUILD_ID &&
-		    n_namesz != 0 &&
-		    !strcmp((char *)&note_sec->n_data[0], "GNU")) {
-			if (note_sec->n_hdr.n_descsz <= BUILD_ID_MAX) {
-				const u32 n_descsz = note_sec->n_hdr.n_descsz;
-				const u8 *s = &note_sec->n_data[n_namesz];
-
-				s = PTR_ALIGN(s, 4);
-				bin2hex(build_id, s, n_descsz);
-				build_id[2 * n_descsz] = '\0';
-				VMCOREINFO_BUILD_ID(build_id);
-				return;
-			}
-			pr_warn("Build ID is too large to include in vmcoreinfo: %u > %u\n",
-				note_sec->n_hdr.n_descsz,
-				BUILD_ID_MAX);
-			return;
-		}
-		n_remain -= sizeof(struct elf_note) +
-			ALIGN(note_sec->n_hdr.n_namesz, 4) +
-			ALIGN(note_sec->n_hdr.n_descsz, 4);
-	}
-}
-
 static int __init crash_save_vmcoreinfo_init(void)
 {
 	vmcoreinfo_data = (unsigned char *)get_zeroed_page(GFP_KERNEL);
@@ -443,7 +397,7 @@ static int __init crash_save_vmcoreinfo_
 	}
 
 	VMCOREINFO_OSRELEASE(init_uts_ns.name.release);
-	add_build_id_vmcoreinfo();
+	VMCOREINFO_BUILD_ID();
 	VMCOREINFO_PAGESIZE(PAGE_SIZE);
 
 	VMCOREINFO_SYMBOL(init_uts_ns);
--- a/lib/buildid.c~kdump-use-vmlinux_build_id-to-simplify
+++ a/lib/buildid.c
@@ -174,7 +174,7 @@ int build_id_parse_buf(const void *buf,
 	return parse_build_id_buf(build_id, NULL, buf, buf_size);
 }
 
-#if IS_ENABLED(CONFIG_STACKTRACE_BUILD_ID)
+#if IS_ENABLED(CONFIG_STACKTRACE_BUILD_ID) || IS_ENABLED(CONFIG_CRASH_CORE)
 unsigned char vmlinux_build_id[BUILD_ID_SIZE_MAX] __ro_after_init;
 
 /**
_

Patches currently in -mm which might be from swboyd@chromium.org are


