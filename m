Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CD40C197A0
	for <mm-commits@archiver.kernel.org>; Mon, 20 Nov 2023 17:39:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234359AbjKTRjd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 20 Nov 2023 12:39:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234303AbjKTRjE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Nov 2023 12:39:04 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E89C171D
        for <mm-commits@vger.kernel.org>; Mon, 20 Nov 2023 09:38:40 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 064FEC433C7;
        Mon, 20 Nov 2023 17:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700501920;
        bh=2ceBkoVdLX6jxuTQ7xtXulJMuVKWo+Alm3IF73c4rpY=;
        h=Date:To:From:Subject:From;
        b=zihbTuArZnhxTCOy9TGBBArdbbGYw+zZtZS72TLDqbWUTTwfUVKK5Af6gdyJ6oWV/
         X6mVxV5KCcVY1eYknqDjzmz21c8xzWrKGKdffRSAee03FNc5EhqMzll+GNY1ihKs1x
         VgwpHLCI+y+OhFKue6c8yzfjWjLCWOh3xwxmRTqQ=
Date:   Mon, 20 Nov 2023 09:38:39 -0800
To:     mm-commits@vger.kernel.org, serge@hallyn.com,
        phillip@squashfs.org.uk, corbet@lwn.net, bagasdotme@gmail.com,
        amiculas@cisco.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-filesystems-document-the-squashfs-specific-mount-options.patch added to mm-nonmm-unstable branch
Message-Id: <20231120173840.064FEC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: docs: filesystems: document the squashfs specific mount options
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     docs-filesystems-document-the-squashfs-specific-mount-options.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-filesystems-document-the-squashfs-specific-mount-options.patch

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
From: Ariel Miculas <amiculas@cisco.com>
Subject: docs: filesystems: document the squashfs specific mount options
Date: Fri, 17 Nov 2023 18:12:14 +0200

When SQUASHFS_CHOICE_DECOMP_BY_MOUNT is set, the "threads" mount option
can be used to specify the decompression mode: single-threaded,
multi-threaded, percpu or the number of threads used for decompression. 
When SQUASHFS_CHOICE_DECOMP_BY_MOUNT is not set, SQUASHFS_DECOMP_MULTI and
SQUASHFS_MOUNT_DECOMP_THREADS are both set, the "threads" option can also
be used to specify the number of threads used for decompression.  This
mount option is only mentioned in fs/squashfs/Kconfig, which makes it
difficult to find.

Another mount option available is "errors", which can be configured to
panic the kernel when squashfs errors are encountered.

Add both these options to the squashfs documentation, making them more
noticeable.

Link: https://lkml.kernel.org/r/20231117161215.140282-1-amiculas@cisco.com
Signed-off-by: Ariel Miculas <amiculas@cisco.com>
Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>
Reviewed-by: Phillip Lougher <phillip@squashfs.org.uk>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Serge Hallyn <serge@hallyn.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/squashfs.rst |   60 +++++++++++++++++++++++
 1 file changed, 60 insertions(+)

--- a/Documentation/filesystems/squashfs.rst~docs-filesystems-document-the-squashfs-specific-mount-options
+++ a/Documentation/filesystems/squashfs.rst
@@ -64,6 +64,66 @@ obtained from this site also.
 The squashfs-tools development tree is now located on kernel.org
 	git://git.kernel.org/pub/scm/fs/squashfs/squashfs-tools.git
 
+2.1 Mount options
+-----------------
+===================    =========================================================
+errors=%s              Specify whether squashfs errors trigger a kernel panic
+                       or not
+
+		       ==========  =============================================
+                         continue  errors don't trigger a panic (default)
+                            panic  trigger a panic when errors are encountered,
+                                   similar to several other filesystems (e.g.
+                                   btrfs, ext4, f2fs, GFS2, jfs, ntfs, ubifs)
+
+                                   This allows a kernel dump to be saved,
+                                   useful for analyzing and debugging the
+                                   corruption.
+                       ==========  =============================================
+threads=%s             Select the decompression mode or the number of threads
+
+                       If SQUASHFS_CHOICE_DECOMP_BY_MOUNT is set:
+
+		       ==========  =============================================
+                           single  use single-threaded decompression (default)
+
+                                   Only one block (data or metadata) can be
+                                   decompressed at any one time. This limits
+                                   CPU and memory usage to a minimum, but it
+                                   also gives poor performance on parallel I/O
+                                   workloads when using multiple CPU machines
+                                   due to waiting on decompressor availability.
+                            multi  use up to two parallel decompressors per core
+
+                                   If you have a parallel I/O workload and your
+                                   system has enough memory, using this option
+                                   may improve overall I/O performance. It
+                                   dynamically allocates decompressors on a
+                                   demand basis.
+                           percpu  use a maximum of one decompressor per core
+
+                                   It uses percpu variables to ensure
+                                   decompression is load-balanced across the
+                                   cores.
+                        1|2|3|...  configure the number of threads used for
+                                   decompression
+
+                                   The upper limit is num_online_cpus() * 2.
+                       ==========  =============================================
+
+                       If SQUASHFS_CHOICE_DECOMP_BY_MOUNT is **not** set and
+                       SQUASHFS_DECOMP_MULTI, SQUASHFS_MOUNT_DECOMP_THREADS are
+                       both set:
+
+		       ==========  =============================================
+                          2|3|...  configure the number of threads used for
+                                   decompression
+
+                                   The upper limit is num_online_cpus() * 2.
+                       ==========  =============================================
+
+===================    =========================================================
+
 3. Squashfs Filesystem Design
 -----------------------------
 
_

Patches currently in -mm which might be from amiculas@cisco.com are

docs-filesystems-document-the-squashfs-specific-mount-options.patch

