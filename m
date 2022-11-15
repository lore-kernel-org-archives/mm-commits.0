Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7A97C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 15 Nov 2022 22:14:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbiKOWOV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Nov 2022 17:14:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbiKOWOR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Nov 2022 17:14:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F19FFD95
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 14:14:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9FC10B816CF
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 22:14:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FEA9C433D6;
        Tue, 15 Nov 2022 22:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668550453;
        bh=iterDfGpJQUKkHR7A0PXbD+to77AokuZ/DUdxCzWN8E=;
        h=Date:To:From:Subject:From;
        b=zbiyZj1eP6AcFn81+/KjZWHDz6cwIXl0RUGGfvksY7mW8Ky6onyMHSX/LgrMv3lsM
         bEtZxHWp+x9zeZq+owqWdZP/ND2jqw1Gzl5HWH2G8oe8s3aAquit/a+292DHho+TMV
         kOXK/bRflJ4YtTup6ShjVUd4zX4WZryODxxxCykM=
Date:   Tue, 15 Nov 2022 14:14:12 -0800
To:     mm-commits@vger.kernel.org, adobriyan@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] proc-give-proc-cmdline-size.patch removed from -mm tree
Message-Id: <20221115221413.4FEA9C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: proc: give /proc/cmdline size
has been removed from the -mm tree.  Its filename was
     proc-give-proc-cmdline-size.patch

This patch was dropped because it was folded into checkpatch-add-warning-for-non-lore-mailing-list-urls.patch

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

checkpatch-add-warning-for-non-lore-mailing-list-urls.patch
proc-fixup-uptime-test.patch

