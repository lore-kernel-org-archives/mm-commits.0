Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2900EEB64DD
	for <mm-commits@archiver.kernel.org>; Tue, 11 Jul 2023 20:07:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231179AbjGKUHj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Jul 2023 16:07:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230505AbjGKUHi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jul 2023 16:07:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 712E9139
        for <mm-commits@vger.kernel.org>; Tue, 11 Jul 2023 13:07:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC027615D5
        for <mm-commits@vger.kernel.org>; Tue, 11 Jul 2023 20:07:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ED2CC433C7;
        Tue, 11 Jul 2023 20:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689106056;
        bh=xSmghLPgr3ReJQCN8uv3f9NGMHWGPQapxOgP52eQLD8=;
        h=Date:To:From:Subject:From;
        b=EoeRNtpfjX3KTS8FoiRQLPHhrSnU/pmPrExQ+flgQPj13a4rUYd9sVusBa+ot0GRL
         jgh1xOKy2pFstS54A7TcX2eGwD5JsZ2plLWNE2GVbgbyPQ4oSvyxiLzhdBoJPKulYy
         2TH/kNYDtjnqE1XzsmiBJGOZzmYZIh0sS/GhPuFs=
Date:   Tue, 11 Jul 2023 13:07:35 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + minmax-add-in_range-macro-fix-fix.patch added to mm-unstable branch
Message-Id: <20230711200736.4ED2CC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: minmax-add-in_range-macro-fix-fix
has been added to the -mm mm-unstable branch.  Its filename is
     minmax-add-in_range-macro-fix-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/minmax-add-in_range-macro-fix-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: minmax-add-in_range-macro-fix-fix
Date: Tue Jul 11 01:04:11 PM PDT 2023

convert remaining local in_range() definitions, kernel-wide

Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/btrfs/misc.h  |    3 +--
 fs/ext2/balloc.c |    3 +--
 fs/ext4/ext4.h   |    3 +--
 fs/ufs/util.h    |    7 +------
 4 files changed, 4 insertions(+), 12 deletions(-)

--- a/fs/btrfs/misc.h~minmax-add-in_range-macro-fix-fix
+++ a/fs/btrfs/misc.h
@@ -7,8 +7,7 @@
 #include <linux/wait.h>
 #include <linux/math64.h>
 #include <linux/rbtree.h>
-
-#define in_range(b, first, len) ((b) >= (first) && (b) < (first) + (len))
+#include <linux/minmax.h>
 
 /*
  * Enumerate bits using enum autoincrement. Define the @name as the n-th bit.
--- a/fs/ext2/balloc.c~minmax-add-in_range-macro-fix-fix
+++ a/fs/ext2/balloc.c
@@ -16,6 +16,7 @@
 #include <linux/quotaops.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
+#include <linux/minmax.h>
 #include <linux/cred.h>
 #include <linux/buffer_head.h>
 #include <linux/capability.h>
@@ -36,8 +37,6 @@
  */
 
 
-#define in_range(b, first, len)	((b) >= (first) && (b) <= (first) + (len) - 1)
-
 struct ext2_group_desc * ext2_get_group_desc(struct super_block * sb,
 					     unsigned int block_group,
 					     struct buffer_head ** bh)
--- a/fs/ext4/ext4.h~minmax-add-in_range-macro-fix-fix
+++ a/fs/ext4/ext4.h
@@ -32,6 +32,7 @@
 #include <linux/sched/signal.h>
 #include <linux/blockgroup_lock.h>
 #include <linux/percpu_counter.h>
+#include <linux/minmax.h>
 #include <linux/ratelimit.h>
 #include <crypto/hash.h>
 #include <linux/falloc.h>
@@ -3774,8 +3775,6 @@ static inline void set_bitmap_uptodate(s
 	set_bit(BH_BITMAP_UPTODATE, &(bh)->b_state);
 }
 
-#define in_range(b, first, len)	((b) >= (first) && (b) <= (first) + (len) - 1)
-
 /* For ioend & aio unwritten conversion wait queues */
 #define EXT4_WQ_HASH_SZ		37
 #define ext4_ioend_wq(v)   (&ext4__ioend_wq[((unsigned long)(v)) %\
--- a/fs/ufs/util.h~minmax-add-in_range-macro-fix-fix
+++ a/fs/ufs/util.h
@@ -9,14 +9,9 @@
 
 #include <linux/buffer_head.h>
 #include <linux/fs.h>
+#include <linux/minmax.h>
 #include "swab.h"
 
-
-/*
- * some useful macros
- */
-#define in_range(b,first,len)	((b)>=(first)&&(b)<(first)+(len))
-
 /*
  * functions used for retyping
  */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
swap-stop-add-to-avail-list-is-swap-is-full-checkpatch-fixes.patch
fs-buffer-clean-up-block_commit_write-fix.patch
mm-page_alloc-avoid-false-page-outside-zone-error-info-fix.patch
mm-make-pte_marker_swapin_error-more-general-fix.patch
minmax-add-in_range-macro-fix.patch
minmax-add-in_range-macro-fix-fix.patch
signal-print-comm-and-exe-name-on-fatal-signals-fix.patch

