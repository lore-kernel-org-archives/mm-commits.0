Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 087ECC433EF
	for <mm-commits@archiver.kernel.org>; Tue, 26 Apr 2022 20:44:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355122AbiDZUr2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 26 Apr 2022 16:47:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355107AbiDZUrY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 26 Apr 2022 16:47:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A99B1A73DD
        for <mm-commits@vger.kernel.org>; Tue, 26 Apr 2022 13:44:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EC5C8B8215C
        for <mm-commits@vger.kernel.org>; Tue, 26 Apr 2022 20:44:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83DF7C385A0;
        Tue, 26 Apr 2022 20:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651005851;
        bh=cjdKx6Ow9/asuQtraLbEXKRhr16zBEFS23poOsObT3Q=;
        h=Date:To:From:Subject:From;
        b=PMbBoojIV92SO9b61TL99XYNq1nMIrqTQhp+3UBlYB9XAVjyMxcs8KBGN0v4BIXL8
         mo3dqVg4vU09wNYF/5VyXzevL68ZhLOfcPGwYS/P61FJAFAC2mkvyDFk1OlYc3V+Sz
         1EJotRq3duFyOsqKC6hvctzslldHV+HqM7lfOiII=
Date:   Tue, 26 Apr 2022 13:44:10 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, mwilck@suse.com,
        christian.brauner@ubuntu.com, ddiss@suse.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + initramfs-add-initramfs_preserve_mtime-kconfig-option.patch added to -mm tree
Message-Id: <20220426204411.83DF7C385A0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: initramfs: add INITRAMFS_PRESERVE_MTIME Kconfig option
has been added to the -mm tree.  Its filename is
     initramfs-add-initramfs_preserve_mtime-kconfig-option.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/initramfs-add-initramfs_preserve_mtime-kconfig-option.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/initramfs-add-initramfs_preserve_mtime-kconfig-option.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Disseldorp <ddiss@suse.de>
Subject: initramfs: add INITRAMFS_PRESERVE_MTIME Kconfig option

initramfs cpio mtime preservation, as implemented in commit 889d51a10712
("initramfs: add option to preserve mtime from initramfs cpio images"),
uses a linked list to defer directory mtime processing until after all
other items in the cpio archive have been processed.  This is done to
ensure that parent directory mtimes aren't overwritten via subsequent
child creation.

The lkml link below indicates that the mtime retention use case was for
embedded devices with applications running exclusively out of initramfs,
where the 32-bit mtime value provided a rough file version identifier. 
Linux distributions which discard an extracted initramfs immediately after
the root filesystem has been mounted may want to avoid the unnecessary
overhead.

This change adds a new INITRAMFS_PRESERVE_MTIME Kconfig option, which can
be used to disable on-by-default mtime retention and in turn speed up
initramfs extraction, particularly for cpio archives with large directory
counts.

Benchmarks with a one million directory cpio archive extracted 20 times
demonstrated: mean extraction time (s) std dev INITRAMFS_PRESERVE_MTIME=y
3.808 0.006 INITRAMFS_PRESERVE_MTIME unset 3.056 0.004

The above extraction times were measured using ftrace (initcall_finish -
initcall_start) values for populate_rootfs() with initramfs_async
disabled.

[ddiss@suse.de: rebase atop dir_entry.name flexible array member and drop  separate initramfs_mtime.h header]
Link: https://lkml.org/lkml/2008/9/3/424
Link: https://lkml.kernel.org/r/20220404093429.27570-4-ddiss@suse.de
Signed-off-by: David Disseldorp <ddiss@suse.de>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig     |   10 ++++++++++
 init/initramfs.c |   28 ++++++++++++++++------------
 2 files changed, 26 insertions(+), 12 deletions(-)

--- a/init/initramfs.c~initramfs-add-initramfs_preserve_mtime-kconfig-option
+++ a/init/initramfs.c
@@ -116,15 +116,17 @@ static void __init free_hash(void)
 	}
 }
 
-static long __init do_utime(char *filename, time64_t mtime)
+#ifdef CONFIG_INITRAMFS_PRESERVE_MTIME
+static void __init do_utime(char *filename, time64_t mtime)
 {
-	struct timespec64 t[2];
+	struct timespec64 t[2] = { { .tv_sec = mtime }, { .tv_sec = mtime } };
+	init_utimes(filename, t);
+}
 
-	t[0].tv_sec = mtime;
-	t[0].tv_nsec = 0;
-	t[1].tv_sec = mtime;
-	t[1].tv_nsec = 0;
-	return init_utimes(filename, t);
+static void __init do_utime_path(const struct path *path, time64_t mtime)
+{
+	struct timespec64 t[2] = { { .tv_sec = mtime }, { .tv_sec = mtime } };
+	vfs_utimes(path, t);
 }
 
 static __initdata LIST_HEAD(dir_list);
@@ -157,6 +159,12 @@ static void __init dir_utime(void)
 		kfree(de);
 	}
 }
+#else
+static void __init do_utime(char *filename, time64_t mtime) {}
+static void __init do_utime_path(const struct path *path, time64_t mtime) {}
+static void __init dir_add(const char *name, time64_t mtime) {}
+static void __init dir_utime(void) {}
+#endif
 
 static __initdata time64_t mtime;
 
@@ -381,14 +389,10 @@ static int __init do_name(void)
 static int __init do_copy(void)
 {
 	if (byte_count >= body_len) {
-		struct timespec64 t[2] = { };
 		if (xwrite(wfile, victim, body_len, &wfile_pos) != body_len)
 			error("write error");
 
-		t[0].tv_sec = mtime;
-		t[1].tv_sec = mtime;
-		vfs_utimes(&wfile->f_path, t);
-
+		do_utime_path(&wfile->f_path, mtime);
 		fput(wfile);
 		eat(body_len);
 		state = SkipIt;
--- a/init/Kconfig~initramfs-add-initramfs_preserve_mtime-kconfig-option
+++ a/init/Kconfig
@@ -1361,6 +1361,16 @@ config BOOT_CONFIG
 
 	  If unsure, say Y.
 
+config INITRAMFS_PRESERVE_MTIME
+	bool "Preserve cpio archive mtimes in initramfs"
+	default y
+	help
+	  Each entry in an initramfs cpio archive carries an mtime value. When
+	  enabled, extracted cpio items take this mtime, with directory mtime
+	  setting deferred until after creation of any child entries.
+
+	  If unsure, say Y.
+
 choice
 	prompt "Compiler optimization level"
 	default CC_OPTIMIZE_FOR_PERFORMANCE
_

Patches currently in -mm which might be from ddiss@suse.de are

initramfs-refactor-do_header-cpio-magic-checks.patch
initramfs-make-dir_entryname-a-flexible-array-member.patch
initramfs-add-initramfs_preserve_mtime-kconfig-option.patch
gen_init_cpio-fix-short-read-file-handling.patch
gen_init_cpio-support-file-checksum-archiving.patch
initramfs-support-cpio-extraction-with-file-checksums.patch

