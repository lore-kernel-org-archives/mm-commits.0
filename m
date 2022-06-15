Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53E78C43334
	for <mm-commits@archiver.kernel.org>; Wed, 15 Jun 2022 20:36:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344717AbiFOUge (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 15 Jun 2022 16:36:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244033AbiFOUg3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Jun 2022 16:36:29 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44D7654F93
        for <mm-commits@vger.kernel.org>; Wed, 15 Jun 2022 13:36:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C0613CE22D8
        for <mm-commits@vger.kernel.org>; Wed, 15 Jun 2022 20:36:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8B6FC3411A;
        Wed, 15 Jun 2022 20:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655325383;
        bh=074h3vmz+MJ0tmnH2fQIw28h7Fj1Q1rVkDLwicUgOJM=;
        h=Date:To:From:Subject:From;
        b=kgz2HFjQUekHPhqT3mB4G5BvyuYgchAiwAbA3OGKLbWYrsT542i9FSOcQ/Iarnnxn
         89SOlaQmGIfeav3VJEYFyjmlNXI30AkfO47V2u25wzrC7jVL9TTxa+wCamBXoFXYzC
         uiunb/6AH/BBfIC6F6o5AnbwJ+mFLLap8LW67GSM=
Date:   Wed, 15 Jun 2022 13:36:22 -0700
To:     mm-commits@vger.kernel.org, adobriyan@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + proc-delete-unused-linux-uaccessh-includes.patch added to mm-nonmm-unstable branch
Message-Id: <20220615203622.E8B6FC3411A@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: proc: delete unused <linux/uaccess.h> includes
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     proc-delete-unused-linux-uaccessh-includes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/proc-delete-unused-linux-uaccessh-includes.patch

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
Subject: proc: delete unused <linux/uaccess.h> includes
Date: Wed, 15 Jun 2022 14:22:06 +0300

Those aren't necessary after seq files won.

Link: https://lkml.kernel.org/r/YqnA3mS7KBt8Z4If@localhost.localdomain
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/array.c    |    1 -
 fs/proc/inode.c    |    2 --
 fs/proc/kmsg.c     |    1 -
 fs/proc/nommu.c    |    1 -
 fs/proc/proc_net.c |    3 ---
 fs/proc/proc_tty.c |    2 --
 fs/proc/root.c     |    3 ---
 fs/proc/vmcore.c   |    1 -
 8 files changed, 14 deletions(-)

--- a/fs/proc/array.c~proc-delete-unused-linux-uaccessh-includes
+++ a/fs/proc/array.c
@@ -69,7 +69,6 @@
 #include <linux/sched/cputime.h>
 #include <linux/proc_fs.h>
 #include <linux/ioport.h>
-#include <linux/uaccess.h>
 #include <linux/io.h>
 #include <linux/mm.h>
 #include <linux/hugetlb.h>
--- a/fs/proc/inode.c~proc-delete-unused-linux-uaccessh-includes
+++ a/fs/proc/inode.c
@@ -26,8 +26,6 @@
 #include <linux/mount.h>
 #include <linux/bug.h>
 
-#include <linux/uaccess.h>
-
 #include "internal.h"
 
 static void proc_evict_inode(struct inode *inode)
--- a/fs/proc/kmsg.c~proc-delete-unused-linux-uaccessh-includes
+++ a/fs/proc/kmsg.c
@@ -15,7 +15,6 @@
 #include <linux/fs.h>
 #include <linux/syslog.h>
 
-#include <linux/uaccess.h>
 #include <asm/io.h>
 
 extern wait_queue_head_t log_wait;
--- a/fs/proc/nommu.c~proc-delete-unused-linux-uaccessh-includes
+++ a/fs/proc/nommu.c
@@ -21,7 +21,6 @@
 #include <linux/seq_file.h>
 #include <linux/hugetlb.h>
 #include <linux/vmalloc.h>
-#include <linux/uaccess.h>
 #include <asm/tlb.h>
 #include <asm/div64.h>
 #include "internal.h"
--- a/fs/proc/proc_net.c~proc-delete-unused-linux-uaccessh-includes
+++ a/fs/proc/proc_net.c
@@ -8,9 +8,6 @@
  *
  *  proc net directory handling functions
  */
-
-#include <linux/uaccess.h>
-
 #include <linux/errno.h>
 #include <linux/time.h>
 #include <linux/proc_fs.h>
--- a/fs/proc/proc_tty.c~proc-delete-unused-linux-uaccessh-includes
+++ a/fs/proc/proc_tty.c
@@ -4,8 +4,6 @@
  *
  * Copyright 1997, Theodore Ts'o
  */
-
-#include <linux/uaccess.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/errno.h>
--- a/fs/proc/root.c~proc-delete-unused-linux-uaccessh-includes
+++ a/fs/proc/root.c
@@ -6,9 +6,6 @@
  *
  *  proc root directory handling functions
  */
-
-#include <linux/uaccess.h>
-
 #include <linux/errno.h>
 #include <linux/time.h>
 #include <linux/proc_fs.h>
--- a/fs/proc/vmcore.c~proc-delete-unused-linux-uaccessh-includes
+++ a/fs/proc/vmcore.c
@@ -25,7 +25,6 @@
 #include <linux/mutex.h>
 #include <linux/vmalloc.h>
 #include <linux/pagemap.h>
-#include <linux/uaccess.h>
 #include <linux/uio.h>
 #include <linux/cc_platform.h>
 #include <asm/io.h>
_

Patches currently in -mm which might be from adobriyan@gmail.com are

proc-delete-unused-linux-uaccessh-includes.patch

