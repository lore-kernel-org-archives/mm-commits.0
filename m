Return-Path: <SRS0=97KN=AZ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94E9DC433E2
	for <mm-commits@archiver.kernel.org>; Tue, 14 Jul 2020 00:31:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E5BF21924
	for <mm-commits@archiver.kernel.org>; Tue, 14 Jul 2020 00:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594686683;
	bh=QP5oDCyi1uooIG5G3ydXSEM90F/FonUKlhUZFwHjCHs=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=gpGH8ZvjLQr04oQyCJjIGzVR+J+v4hrULfKvDZ72qq+EHcj5RpLVdAD/nFARnytXB
	 lSjPA+mdCGY84f7XK2SyYDsXdIOnhpYlNgza4IKkopyZqoQL8GPMFpys+aYFzPZ3nG
	 g0/w9WlO4DchECEw+HkgCTr72uZTI0BwjnU7SGK0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbgGNAbX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Jul 2020 20:31:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:44350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726823AbgGNAbV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 13 Jul 2020 20:31:21 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E5A1E21919;
        Tue, 14 Jul 2020 00:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594686680;
        bh=QP5oDCyi1uooIG5G3ydXSEM90F/FonUKlhUZFwHjCHs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=1wmM5RGvO/g/63gc85Po/O96DKlbZM6LQwGgbFgVOuZNu2a8RWf9Oek3K7w0wBHSC
         k4SVIzqijRL3aPy5cJNjg8V3slLxWy4CLPqAS3NV1S7uqJnn83S58AgTu6D6YDMeUA
         QFO4yL08ErYRA6u180AKKwwQ8MjEVNyYbx7VwJas=
Date:   Mon, 13 Jul 2020 17:31:19 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     amir73il@gmail.com, chris@chrisdown.name, hannes@cmpxchg.org,
        hughd@google.com, jlayton@kernel.org, mm-commits@vger.kernel.org,
        tj@kernel.org, viro@zeniv.linux.org.uk, willy@infradead.org
Subject:  + tmpfs-support-64-bit-inums-per-sb.patch added to -mm
 tree
Message-ID: <20200714003119.wk1EJGg3P%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tmpfs: support 64-bit inums per-sb
has been added to the -mm tree.  Its filename is
     tmpfs-support-64-bit-inums-per-sb.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/tmpfs-support-64-bit-inums-per-sb.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/tmpfs-support-64-bit-inums-per-sb.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chris Down <chris@chrisdown.name>
Subject: tmpfs: support 64-bit inums per-sb

The default is still set to inode32 for backwards compatibility, but
system administrators can opt in to the new 64-bit inode numbers by
either:

1. Passing inode64 on the command line when mounting, or
2. Configuring the kernel with CONFIG_TMPFS_INODE64=y

The inode64 and inode32 names are used based on existing precedent from
XFS.

Link: http://lkml.kernel.org/r/8b23758d0c66b5e2263e08baf9c4b6a7565cbd8f.1594661218.git.chris@chrisdown.name
Signed-off-by: Chris Down <chris@chrisdown.name>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/tmpfs.rst |   11 ++++
 fs/Kconfig                          |   15 ++++++
 include/linux/shmem_fs.h            |    1 
 mm/shmem.c                          |   65 +++++++++++++++++++++++++-
 4 files changed, 90 insertions(+), 2 deletions(-)

--- a/Documentation/filesystems/tmpfs.rst~tmpfs-support-64-bit-inums-per-sb
+++ a/Documentation/filesystems/tmpfs.rst
@@ -150,6 +150,15 @@ These options do not have any effect on
 parameters with chmod(1), chown(1) and chgrp(1) on a mounted filesystem.
 
 
+tmpfs has a mount option to select whether it will wrap at 32- or 64-bit inode
+numbers:
+
+inode64   Use 64-bit inode numbers
+inode32   Use 32-bit inode numbers
+
+On 64-bit, the default is set by CONFIG_TMPFS_INODE64. On 32-bit, inode64 is
+not legal and will produce an error at mount time.
+
 So 'mount -t tmpfs -o size=10G,nr_inodes=10k,mode=700 tmpfs /mytmpfs'
 will give you tmpfs instance on /mytmpfs which can allocate 10GB
 RAM/SWAP in 10240 inodes and it is only accessible by root.
@@ -161,3 +170,5 @@ RAM/SWAP in 10240 inodes and it is only
    Hugh Dickins, 4 June 2007
 :Updated:
    KOSAKI Motohiro, 16 Mar 2010
+Updated:
+   Chris Down, 13 July 2020
--- a/fs/Kconfig~tmpfs-support-64-bit-inums-per-sb
+++ a/fs/Kconfig
@@ -201,6 +201,21 @@ config TMPFS_XATTR
 
 	  If unsure, say N.
 
+config TMPFS_INODE64
+	bool "Use 64-bit ino_t by default in tmpfs"
+	depends on TMPFS && 64BIT
+	default n
+	help
+	  tmpfs has historically used only inode numbers as wide as an unsigned
+	  int. In some cases this can cause wraparound, potentially resulting in
+	  multiple files with the same inode number on a single device. This option
+	  makes tmpfs use the full width of ino_t by default, similarly to the
+	  inode64 mount option.
+
+	  To override this default, use the inode32 or inode64 mount options.
+
+	  If unsure, say N.
+
 config HUGETLBFS
 	bool "HugeTLB file system support"
 	depends on X86 || IA64 || SPARC64 || (S390 && 64BIT) || \
--- a/include/linux/shmem_fs.h~tmpfs-support-64-bit-inums-per-sb
+++ a/include/linux/shmem_fs.h
@@ -36,6 +36,7 @@ struct shmem_sb_info {
 	unsigned char huge;	    /* Whether to try for hugepages */
 	kuid_t uid;		    /* Mount uid for root directory */
 	kgid_t gid;		    /* Mount gid for root directory */
+	bool full_inums;	    /* If i_ino should be uint or ino_t */
 	ino_t next_ino;		    /* The next per-sb inode number to use */
 	ino_t __percpu *ino_batch;  /* The next per-cpu inode number to use */
 	struct mempolicy *mpol;     /* default memory policy for mappings */
--- a/mm/shmem.c~tmpfs-support-64-bit-inums-per-sb
+++ a/mm/shmem.c
@@ -114,11 +114,13 @@ struct shmem_options {
 	kuid_t uid;
 	kgid_t gid;
 	umode_t mode;
+	bool full_inums;
 	int huge;
 	int seen;
 #define SHMEM_SEEN_BLOCKS 1
 #define SHMEM_SEEN_INODES 2
 #define SHMEM_SEEN_HUGE 4
+#define SHMEM_SEEN_INUMS 8
 };
 
 #ifdef CONFIG_TMPFS
@@ -286,12 +288,17 @@ static int shmem_reserve_inode(struct su
 			ino = sbinfo->next_ino++;
 			if (unlikely(is_zero_ino(ino)))
 				ino = sbinfo->next_ino++;
-			if (unlikely(ino > UINT_MAX)) {
+			if (unlikely(!sbinfo->full_inums &&
+				     ino > UINT_MAX)) {
 				/*
 				 * Emulate get_next_ino uint wraparound for
 				 * compatibility
 				 */
-				ino = 1;
+				if (IS_ENABLED(CONFIG_64BIT))
+					pr_warn("%s: inode number overflow on device %d, consider using inode64 mount option\n",
+						__func__, MINOR(sb->s_dev));
+				sbinfo->next_ino = 1;
+				ino = sbinfo->next_ino++;
 			}
 			*inop = ino;
 		}
@@ -304,6 +311,10 @@ static int shmem_reserve_inode(struct su
 		 * unknown contexts. As such, use a per-cpu batched allocator
 		 * which doesn't require the per-sb stat_lock unless we are at
 		 * the batch boundary.
+		 *
+		 * We don't need to worry about inode{32,64} since SB_KERNMOUNT
+		 * shmem mounts are not exposed to userspace, so we don't need
+		 * to worry about things like glibc compatibility.
 		 */
 		ino_t *next_ino;
 		next_ino = per_cpu_ptr(sbinfo->ino_batch, get_cpu());
@@ -3397,6 +3408,8 @@ enum shmem_param {
 	Opt_nr_inodes,
 	Opt_size,
 	Opt_uid,
+	Opt_inode32,
+	Opt_inode64,
 };
 
 static const struct constant_table shmem_param_enums_huge[] = {
@@ -3416,6 +3429,8 @@ const struct fs_parameter_spec shmem_fs_
 	fsparam_string("nr_inodes",	Opt_nr_inodes),
 	fsparam_string("size",		Opt_size),
 	fsparam_u32   ("uid",		Opt_uid),
+	fsparam_flag  ("inode32",	Opt_inode32),
+	fsparam_flag  ("inode64",	Opt_inode64),
 	{}
 };
 
@@ -3487,6 +3502,18 @@ static int shmem_parse_one(struct fs_con
 			break;
 		}
 		goto unsupported_parameter;
+	case Opt_inode32:
+		ctx->full_inums = false;
+		ctx->seen |= SHMEM_SEEN_INUMS;
+		break;
+	case Opt_inode64:
+		if (sizeof(ino_t) < 8) {
+			return invalfc(fc,
+				       "Cannot use inode64 with <64bit inums in kernel\n");
+		}
+		ctx->full_inums = true;
+		ctx->seen |= SHMEM_SEEN_INUMS;
+		break;
 	}
 	return 0;
 
@@ -3578,8 +3605,16 @@ static int shmem_reconfigure(struct fs_c
 		}
 	}
 
+	if ((ctx->seen & SHMEM_SEEN_INUMS) && !ctx->full_inums &&
+	    sbinfo->next_ino > UINT_MAX) {
+		err = "Current inum too high to switch to 32-bit inums";
+		goto out;
+	}
+
 	if (ctx->seen & SHMEM_SEEN_HUGE)
 		sbinfo->huge = ctx->huge;
+	if (ctx->seen & SHMEM_SEEN_INUMS)
+		sbinfo->full_inums = ctx->full_inums;
 	if (ctx->seen & SHMEM_SEEN_BLOCKS)
 		sbinfo->max_blocks  = ctx->blocks;
 	if (ctx->seen & SHMEM_SEEN_INODES) {
@@ -3619,6 +3654,29 @@ static int shmem_show_options(struct seq
 	if (!gid_eq(sbinfo->gid, GLOBAL_ROOT_GID))
 		seq_printf(seq, ",gid=%u",
 				from_kgid_munged(&init_user_ns, sbinfo->gid));
+
+	/*
+	 * Showing inode{64,32} might be useful even if it's the system default,
+	 * since then people don't have to resort to checking both here and
+	 * /proc/config.gz to confirm 64-bit inums were successfully applied
+	 * (which may not even exist if IKCONFIG_PROC isn't enabled).
+	 *
+	 * We hide it when inode64 isn't the default and we are using 32-bit
+	 * inodes, since that probably just means the feature isn't even under
+	 * consideration.
+	 *
+	 * As such:
+	 *
+	 *                     +-----------------+-----------------+
+	 *                     | TMPFS_INODE64=y | TMPFS_INODE64=n |
+	 *  +------------------+-----------------+-----------------+
+	 *  | full_inums=true  | show            | show            |
+	 *  | full_inums=false | show            | hide            |
+	 *  +------------------+-----------------+-----------------+
+	 *
+	 */
+	if (IS_ENABLED(CONFIG_TMPFS_INODE64) || sbinfo->full_inums)
+		seq_printf(seq, ",inode%d", (sbinfo->full_inums ? 64 : 32));
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	/* Rightly or wrongly, show huge mount option unmasked by shmem_huge */
 	if (sbinfo->huge)
@@ -3667,6 +3725,8 @@ static int shmem_fill_super(struct super
 			ctx->blocks = shmem_default_max_blocks();
 		if (!(ctx->seen & SHMEM_SEEN_INODES))
 			ctx->inodes = shmem_default_max_inodes();
+		if (!(ctx->seen & SHMEM_SEEN_INUMS))
+			ctx->full_inums = IS_ENABLED(CONFIG_TMPFS_INODE64);
 	} else {
 		sb->s_flags |= SB_NOUSER;
 	}
@@ -3684,6 +3744,7 @@ static int shmem_fill_super(struct super
 	}
 	sbinfo->uid = ctx->uid;
 	sbinfo->gid = ctx->gid;
+	sbinfo->full_inums = ctx->full_inums;
 	sbinfo->mode = ctx->mode;
 	sbinfo->huge = ctx->huge;
 	sbinfo->mpol = ctx->mpol;
_

Patches currently in -mm which might be from chris@chrisdown.name are

tmpfs-per-superblock-i_ino-support.patch
tmpfs-support-64-bit-inums-per-sb.patch

