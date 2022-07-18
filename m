Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABD82C43334
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:32:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232937AbiGRAco (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:32:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231731AbiGRAci (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:32:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A31213CFC
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:32:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 00BEBB80EE3
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:32:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D886C3411E;
        Mon, 18 Jul 2022 00:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658104354;
        bh=C+XO1Too2bC7tNAYZQKFjqGMpu1EtFJWb6zY5Fd1Tlg=;
        h=Date:To:From:Subject:From;
        b=KIuLTF7MAX6qGgUsrsM13cMW6T/tXiMXDHKgnMjAdnY13WjxZ+oKXgctB1Rx8N4WP
         zlmIyhePK0XXT1d9f43W95k/F3bjhEpV9ZuIvtwl3bkVP/BOsTBX8+kiZy+ehMLAY9
         Q19zdtWNBmzrEr/z4pQPUdQmt3VtzPvFax5VG7cU=
Date:   Sun, 17 Jul 2022 17:32:34 -0700
To:     mm-commits@vger.kernel.org, dyoung@redhat.com, bhe@redhat.com,
        ltao@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kdump-round-up-the-total-memory-size-to-128m-for-crashkernel-reservation.patch removed from -mm tree
Message-Id: <20220718003234.9D886C3411E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kdump: round up the total memory size to 128M for crashkernel reservation
has been removed from the -mm tree.  Its filename was
     kdump-round-up-the-total-memory-size-to-128m-for-crashkernel-reservation.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Tao Liu <ltao@redhat.com>
Subject: kdump: round up the total memory size to 128M for crashkernel reservation
Date: Mon, 27 Jun 2022 15:44:41 +0800

The total memory size we get in kernel is usually slightly less than the
actual memory size because BIOS/firmware will reserve some memory region. 
So it won't export all memory as usable.

E.g, on my x86_64 kvm guest with 1G memory, the total_mem value shows:
UEFI boot with ovmf: 0x3faef000 Legacy boot kvm guest: 0x3ff7ec00

When specifying crashkernel=1G-2G:128M, if we have a 1G memory machine, we
get total size 1023M from firmware.  Then it will not fall into 1G-2G,
thus no memory reserved.  User will never know this, it is hard to let
user know the exact total value in kernel.

One way is to use dmi/smbios to get physical memory size, but it's not
reliable as well.  According to Prarit hardware vendors sometimes screw
this up.  Thus round up total size to 128M to work around this problem.

This patch is a resend of [1] and rebased onto v5.19-rc2, and the
original credit goes to Dave Young.

[1]: http://lists.infradead.org/pipermail/kexec/2018-April/020568.html

Link: https://lkml.kernel.org/r/20220627074440.187222-1-ltao@redhat.com
Signed-off-by: Tao Liu <ltao@redhat.com>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/crash_core.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/kernel/crash_core.c~kdump-round-up-the-total-memory-size-to-128m-for-crashkernel-reservation
+++ a/kernel/crash_core.c
@@ -9,6 +9,7 @@
 #include <linux/init.h>
 #include <linux/utsname.h>
 #include <linux/vmalloc.h>
+#include <linux/sizes.h>
 
 #include <asm/page.h>
 #include <asm/sections.h>
@@ -45,6 +46,15 @@ static int __init parse_crashkernel_mem(
 					unsigned long long *crash_base)
 {
 	char *cur = cmdline, *tmp;
+	unsigned long long total_mem = system_ram;
+
+	/*
+	 * Firmware sometimes reserves some memory regions for its own use,
+	 * so the system memory size is less than the actual physical memory
+	 * size. Work around this by rounding up the total size to 128M,
+	 * which is enough for most test cases.
+	 */
+	total_mem = roundup(total_mem, SZ_128M);
 
 	/* for each entry of the comma-separated list */
 	do {
@@ -89,13 +99,13 @@ static int __init parse_crashkernel_mem(
 			return -EINVAL;
 		}
 		cur = tmp;
-		if (size >= system_ram) {
+		if (size >= total_mem) {
 			pr_warn("crashkernel: invalid size\n");
 			return -EINVAL;
 		}
 
 		/* match ? */
-		if (system_ram >= start && system_ram < end) {
+		if (total_mem >= start && total_mem < end) {
 			*crash_size = size;
 			break;
 		}
_

Patches currently in -mm which might be from ltao@redhat.com are


