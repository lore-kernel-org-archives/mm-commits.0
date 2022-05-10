Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 803D0C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:21:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236184AbiEJEZK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:25:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236370AbiEJEXr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:23:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A1D81D4A3E
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:18:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B564E6176A
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:18:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A639C385C5;
        Tue, 10 May 2022 04:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156286;
        bh=79qhkbLhriymJWLel3GxZdjR6dTa7lBgCSYXkdRb6Vk=;
        h=Date:To:From:Subject:From;
        b=KhW7KPzAp7PnylLYmCcnRPAB4re+Rf68deOciKKFmml4U4bydz4K/VELLGpSaaxBp
         RelsAKUXdL2XeZf9aCEGq7PT9uxOClT+8OMWMy8De9bBiDSUREQ8NIoYc1QY6WOqAo
         sbl1VQkalyqBsEgdRFJE9oc0QlSx7NRPN52+lJoU=
Date:   Mon, 09 May 2022 21:18:05 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, mwilck@suse.com,
        christian.brauner@ubuntu.com, ddiss@suse.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] initramfs-support-cpio-extraction-with-file-checksums.patch removed from -mm tree
Message-Id: <20220510041806.1A639C385C5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: initramfs: support cpio extraction with file checksums
has been removed from the -mm tree.  Its filename was
     initramfs-support-cpio-extraction-with-file-checksums.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Disseldorp <ddiss@suse.de>
Subject: initramfs: support cpio extraction with file checksums

Add support for extraction of checksum-enabled "070702" cpio archives,
specified in Documentation/driver-api/early-userspace/buffer-format.rst. 
Fail extraction if the calculated file data checksum doesn't match the
value carried in the header.

Link: https://lkml.kernel.org/r/20220404093429.27570-7-ddiss@suse.de
Signed-off-by: David Disseldorp <ddiss@suse.de>
Suggested-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Martin Wilck <mwilck@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/initramfs.c |   29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

--- a/init/initramfs.c~initramfs-support-cpio-extraction-with-file-checksums
+++ a/init/initramfs.c
@@ -17,8 +17,11 @@
 #include <linux/init_syscalls.h>
 #include <linux/umh.h>
 
-static ssize_t __init xwrite(struct file *file, const char *p, size_t count,
-		loff_t *pos)
+static __initdata bool csum_present;
+static __initdata u32 io_csum;
+
+static ssize_t __init xwrite(struct file *file, const unsigned char *p,
+		size_t count, loff_t *pos)
 {
 	ssize_t out = 0;
 
@@ -33,6 +36,13 @@ static ssize_t __init xwrite(struct file
 		} else if (rv == 0)
 			break;
 
+		if (csum_present) {
+			ssize_t i;
+
+			for (i = 0; i < rv; i++)
+				io_csum += p[i];
+		}
+
 		p += rv;
 		out += rv;
 		count -= rv;
@@ -176,15 +186,16 @@ static __initdata unsigned long body_len
 static __initdata uid_t uid;
 static __initdata gid_t gid;
 static __initdata unsigned rdev;
+static __initdata u32 hdr_csum;
 
 static void __init parse_header(char *s)
 {
-	unsigned long parsed[12];
+	unsigned long parsed[13];
 	char buf[9];
 	int i;
 
 	buf[8] = '\0';
-	for (i = 0, s += 6; i < 12; i++, s += 8) {
+	for (i = 0, s += 6; i < 13; i++, s += 8) {
 		memcpy(buf, s, 8);
 		parsed[i] = simple_strtoul(buf, NULL, 16);
 	}
@@ -199,6 +210,7 @@ static void __init parse_header(char *s)
 	minor = parsed[8];
 	rdev = new_encode_dev(MKDEV(parsed[9], parsed[10]));
 	name_len = parsed[11];
+	hdr_csum = parsed[12];
 }
 
 /* FSM */
@@ -267,7 +279,11 @@ static int __init do_collect(void)
 
 static int __init do_header(void)
 {
-	if (memcmp(collected, "070701", 6)) {
+	if (!memcmp(collected, "070701", 6)) {
+		csum_present = false;
+	} else if (!memcmp(collected, "070702", 6)) {
+		csum_present = true;
+	} else {
 		if (memcmp(collected, "070707", 6) == 0)
 			error("incorrect cpio method used: use -H newc option");
 		else
@@ -362,6 +378,7 @@ static int __init do_name(void)
 			if (IS_ERR(wfile))
 				return 0;
 			wfile_pos = 0;
+			io_csum = 0;
 
 			vfs_fchown(wfile, uid, gid);
 			vfs_fchmod(wfile, mode);
@@ -394,6 +411,8 @@ static int __init do_copy(void)
 
 		do_utime_path(&wfile->f_path, mtime);
 		fput(wfile);
+		if (csum_present && io_csum != hdr_csum)
+			error("bad data checksum");
 		eat(body_len);
 		state = SkipIt;
 		return 0;
_

Patches currently in -mm which might be from ddiss@suse.de are


