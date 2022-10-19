Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00865C433FE
	for <mm-commits@archiver.kernel.org>; Wed, 19 Oct 2022 23:36:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231765AbiJSXgz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Oct 2022 19:36:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231226AbiJSXgy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Oct 2022 19:36:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DF961C813B
        for <mm-commits@vger.kernel.org>; Wed, 19 Oct 2022 16:36:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B63EB6125A
        for <mm-commits@vger.kernel.org>; Wed, 19 Oct 2022 23:36:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16D98C433D7;
        Wed, 19 Oct 2022 23:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666222612;
        bh=/EBKXyXukMGNP4fweS2PSWeLF6rzAqKQqtFv47P2C6Y=;
        h=Date:To:From:Subject:From;
        b=dnE8oPK2SsSpRdAwneq0StGdVxZ/hzJmAificBi+2ydUd156xEdclxaBgjCSfYs8e
         YvcbgkYN4kuXhcp6pH5M0V6qk5SeSYuabclCPCccg1Hr/c9kfpsHEd289lX9tAOjld
         2MiFgHx22BIVOixyu0Exv95W3ICLd7JKiBvV/ijM=
Date:   Wed, 19 Oct 2022 16:36:51 -0700
To:     mm-commits@vger.kernel.org, adobriyan@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + proc-give-proc-cmdline-size.patch added to mm-nonmm-unstable branch
Message-Id: <20221019233652.16D98C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: proc: give /proc/cmdline size
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     proc-give-proc-cmdline-size.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/proc-give-proc-cmdline-size.patch

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
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: proc: give /proc/cmdline size
Date: Thu, 8 Sep 2022 21:21:54 +0300

Most /proc files don't have length (in fstat sense).  This leads to
inefficiencies when reading such files with APIs commonly found in modern
programming languages.  They open file, then fstat descriptor, get st_size
== 0 and either assume file is empty or start reading without knowing
target size.

cat(1) does OK because it uses large enough buffer by default.  But naive
programs copy-pasted from SO aren't:

	let mut f = std::fs::File::open("/proc/cmdline").unwrap();
	let mut buf: Vec<u8> = Vec::new();
	f.read_to_end(&mut buf).unwrap();

will result in

	openat(AT_FDCWD, "/proc/cmdline", O_RDONLY|O_CLOEXEC) = 3
	statx(0, NULL, AT_STATX_SYNC_AS_STAT, STATX_ALL, NULL) = -1 EFAULT (Bad address)
	statx(3, "", AT_STATX_SYNC_AS_STAT|AT_EMPTY_PATH, STATX_ALL, {stx_mask=STATX_BASIC_STATS|STATX_MNT_ID, stx_attributes=0, stx_mode=S_IFREG|0444, stx_size=0, ...}) = 0
	lseek(3, 0, SEEK_CUR)                   = 0
	read(3, "BOOT_IMAGE=(hd3,gpt2)/vmlinuz-5.", 32) = 32
	read(3, "19.6-100.fc35.x86_64 root=/dev/m", 32) = 32
	read(3, "apper/fedora_localhost--live-roo"..., 64) = 64
	read(3, "ocalhost--live-swap rd.lvm.lv=fe"..., 128) = 116
	read(3, "", 12)

open/stat is OK, lseek looks silly but there are 3 unnecessary reads
because Rust starts with 32 bytes per Vec<u8> and grows from there.

In case of /proc/cmdline, the length is known precisely.

Make variables readonly while I'm at it.

P.S.: I tried to scp /proc/cpuinfo today and got empty file
	but this is separate story.

Link: https://lkml.kernel.org/r/YxoywlbM73JJN3r+@localhost.localdomain
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/cmdline.c    |    6 +++++-
 include/linux/init.h |    1 +
 init/main.c          |    7 +++++--
 3 files changed, 11 insertions(+), 3 deletions(-)

--- a/fs/proc/cmdline.c~proc-give-proc-cmdline-size
+++ a/fs/proc/cmdline.c
@@ -3,6 +3,7 @@
 #include <linux/init.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
+#include "internal.h"
 
 static int cmdline_proc_show(struct seq_file *m, void *v)
 {
@@ -13,7 +14,10 @@ static int cmdline_proc_show(struct seq_
 
 static int __init proc_cmdline_init(void)
 {
-	proc_create_single("cmdline", 0, NULL, cmdline_proc_show);
+	struct proc_dir_entry *pde;
+
+	pde = proc_create_single("cmdline", 0, NULL, cmdline_proc_show);
+	pde->size = saved_command_line_len + 1;
 	return 0;
 }
 fs_initcall(proc_cmdline_init);
--- a/include/linux/init.h~proc-give-proc-cmdline-size
+++ a/include/linux/init.h
@@ -143,6 +143,7 @@ struct file_system_type;
 extern int do_one_initcall(initcall_t fn);
 extern char __initdata boot_command_line[];
 extern char *saved_command_line;
+extern unsigned int saved_command_line_len;
 extern unsigned int reset_devices;
 
 /* used by init/main.c */
--- a/init/main.c~proc-give-proc-cmdline-size
+++ a/init/main.c
@@ -145,7 +145,8 @@ void (*__initdata late_time_init)(void);
 /* Untouched command line saved by arch-specific code. */
 char __initdata boot_command_line[COMMAND_LINE_SIZE];
 /* Untouched saved command line (eg. for /proc) */
-char *saved_command_line;
+char *saved_command_line __ro_after_init;
+unsigned int saved_command_line_len __ro_after_init;
 /* Command line for parameter parsing */
 static char *static_command_line;
 /* Untouched extra command line */
@@ -667,6 +668,8 @@ static void __init setup_command_line(ch
 			strcpy(saved_command_line + len, extra_init_args);
 		}
 	}
+
+	saved_command_line_len = strlen(saved_command_line);
 }
 
 /*
@@ -1379,7 +1382,7 @@ static void __init do_initcall_level(int
 static void __init do_initcalls(void)
 {
 	int level;
-	size_t len = strlen(saved_command_line) + 1;
+	size_t len = saved_command_line_len + 1;
 	char *command_line;
 
 	command_line = kzalloc(len, GFP_KERNEL);
_

Patches currently in -mm which might be from adobriyan@gmail.com are

proc-give-proc-cmdline-size.patch

