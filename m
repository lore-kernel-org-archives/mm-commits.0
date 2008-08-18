From: akpm@linux-foundation.org
Subject: + fs-make-linux-kernel-parsers-match_table_t-const.patch added to -mm tree
Date: Mon, 18 Aug 2008 15:29:19 -0700
Message-ID: <200808182229.m7IMTJfP016390@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46898 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752671AbYHRWaM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Aug 2008 18:30:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: swhiteho@redhat.com, aviro@redhat.com


The patch titled
     fs: make linux kernel parser's match_table_t const
has been added to the -mm tree.  Its filename is
     fs-make-linux-kernel-parsers-match_table_t-const.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs: make linux kernel parser's match_table_t const
From: Steven Whitehouse <swhiteho@redhat.com>

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Cc: Alexander Viro <aviro@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/cell/spufs/inode.c |    2 +-
 arch/s390/hypfs/inode.c                   |    2 +-
 drivers/infiniband/ulp/srp/ib_srp.c       |    2 +-
 drivers/usb/core/inode.c                  |    2 +-
 fs/9p/v9fs.c                              |    2 +-
 fs/adfs/super.c                           |    2 +-
 fs/affs/super.c                           |    2 +-
 fs/afs/super.c                            |    2 +-
 fs/autofs/inode.c                         |    2 +-
 fs/autofs4/inode.c                        |    2 +-
 fs/befs/linuxvfs.c                        |    2 +-
 fs/devpts/inode.c                         |    2 +-
 fs/ecryptfs/main.c                        |    2 +-
 fs/ext2/super.c                           |    2 +-
 fs/ext3/super.c                           |    2 +-
 fs/ext4/super.c                           |    2 +-
 fs/fat/inode.c                            |    6 +++---
 fs/fuse/inode.c                           |    2 +-
 fs/gfs2/mount.c                           |    2 +-
 fs/hfs/super.c                            |    2 +-
 fs/hfsplus/options.c                      |    2 +-
 fs/hpfs/super.c                           |    2 +-
 fs/hugetlbfs/inode.c                      |    2 +-
 fs/isofs/inode.c                          |    2 +-
 fs/jfs/super.c                            |    2 +-
 fs/nfs/nfsroot.c                          |    2 +-
 fs/nfs/super.c                            |    6 +++---
 fs/ocfs2/super.c                          |    2 +-
 fs/omfs/inode.c                           |    2 +-
 fs/ubifs/super.c                          |    2 +-
 fs/udf/super.c                            |    2 +-
 fs/ufs/super.c                            |    4 ++--
 fs/xfs/linux-2.6/xfs_super.c              |    2 +-
 include/linux/parser.h                    |    2 +-
 lib/parser.c                              |    2 +-
 net/9p/client.c                           |    2 +-
 net/9p/trans_fd.c                         |    2 +-
 security/selinux/hooks.c                  |    2 +-
 38 files changed, 43 insertions(+), 43 deletions(-)

diff -puN arch/powerpc/platforms/cell/spufs/inode.c~fs-make-linux-kernel-parsers-match_table_t-const arch/powerpc/platforms/cell/spufs/inode.c
--- a/arch/powerpc/platforms/cell/spufs/inode.c~fs-make-linux-kernel-parsers-match_table_t-const
+++ a/arch/powerpc/platforms/cell/spufs/inode.c
@@ -660,7 +660,7 @@ enum {
 	Opt_uid, Opt_gid, Opt_mode, Opt_debug, Opt_err,
 };
 
-static match_table_t spufs_tokens = {
+static const match_table_t spufs_tokens = {
 	{ Opt_uid,   "uid=%d" },
 	{ Opt_gid,   "gid=%d" },
 	{ Opt_mode,  "mode=%o" },
diff -puN arch/s390/hypfs/inode.c~fs-make-linux-kernel-parsers-match_table_t-const arch/s390/hypfs/inode.c
--- a/arch/s390/hypfs/inode.c~fs-make-linux-kernel-parsers-match_table_t-const
+++ a/arch/s390/hypfs/inode.c
@@ -219,7 +219,7 @@ static int hypfs_release(struct inode *i
 
 enum { opt_uid, opt_gid, opt_err };
 
-static match_table_t hypfs_tokens = {
+static const match_table_t hypfs_tokens = {
 	{opt_uid, "uid=%u"},
 	{opt_gid, "gid=%u"},
 	{opt_err, NULL}
diff -puN drivers/infiniband/ulp/srp/ib_srp.c~fs-make-linux-kernel-parsers-match_table_t-const drivers/infiniband/ulp/srp/ib_srp.c
--- a/drivers/infiniband/ulp/srp/ib_srp.c~fs-make-linux-kernel-parsers-match_table_t-const
+++ a/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1683,7 +1683,7 @@ enum {
 				   SRP_OPT_SERVICE_ID),
 };
 
-static match_table_t srp_opt_tokens = {
+static const match_table_t srp_opt_tokens = {
 	{ SRP_OPT_ID_EXT,		"id_ext=%s" 		},
 	{ SRP_OPT_IOC_GUID,		"ioc_guid=%s" 		},
 	{ SRP_OPT_DGID,			"dgid=%s" 		},
diff -puN drivers/usb/core/inode.c~fs-make-linux-kernel-parsers-match_table_t-const drivers/usb/core/inode.c
--- a/drivers/usb/core/inode.c~fs-make-linux-kernel-parsers-match_table_t-const
+++ a/drivers/usb/core/inode.c
@@ -97,7 +97,7 @@ enum {
 	Opt_err,
 };
 
-static match_table_t tokens = {
+static const match_table_t tokens = {
 	{Opt_devuid, "devuid=%u"},
 	{Opt_devgid, "devgid=%u"},
 	{Opt_devmode, "devmode=%o"},
diff -puN fs/9p/v9fs.c~fs-make-linux-kernel-parsers-match_table_t-const fs/9p/v9fs.c
--- a/fs/9p/v9fs.c~fs-make-linux-kernel-parsers-match_table_t-const
+++ a/fs/9p/v9fs.c
@@ -55,7 +55,7 @@ enum {
 	Opt_err
 };
 
-static match_table_t tokens = {
+static const match_table_t tokens = {
 	{Opt_debug, "debug=%x"},
 	{Opt_dfltuid, "dfltuid=%u"},
 	{Opt_dfltgid, "dfltgid=%u"},
diff -puN fs/adfs/super.c~fs-make-linux-kernel-parsers-match_table_t-const fs/adfs/super.c
--- a/fs/adfs/super.c~fs-make-linux-kernel-parsers-match_table_t-const
+++ a/fs/adfs/super.c
@@ -157,7 +157,7 @@ static int adfs_show_options(struct seq_
 
 enum {Opt_uid, Opt_gid, Opt_ownmask, Opt_othmask, Opt_err};
 
-static match_table_t tokens = {
+static const match_table_t tokens = {
 	{Opt_uid, "uid=%u"},
 	{Opt_gid, "gid=%u"},
 	{Opt_ownmask, "ownmask=%o"},
diff -puN fs/affs/super.c~fs-make-linux-kernel-parsers-match_table_t-const fs/affs/super.c
--- a/fs/affs/super.c~fs-make-linux-kernel-parsers-match_table_t-const
+++ a/fs/affs/super.c
@@ -135,7 +135,7 @@ enum {
 	Opt_verbose, Opt_volume, Opt_ignore, Opt_err,
 };
 
-static match_table_t tokens = {
+static const match_table_t tokens = {
 	{Opt_bs, "bs=%u"},
 	{Opt_mode, "mode=%o"},
 	{Opt_mufs, "mufs"},
diff -puN fs/afs/super.c~fs-make-linux-kernel-parsers-match_table_t-const fs/afs/super.c
--- a/fs/afs/super.c~fs-make-linux-kernel-parsers-match_table_t-const
+++ a/fs/afs/super.c
@@ -64,7 +64,7 @@ enum {
 	afs_opt_vol,
 };
 
-static match_table_t afs_options_list = {
+static const match_table_t afs_options_list = {
 	{ afs_opt_cell,		"cell=%s"	},
 	{ afs_opt_rwpath,	"rwpath"	},
 	{ afs_opt_vol,		"vol=%s"	},
diff -puN fs/autofs/inode.c~fs-make-linux-kernel-parsers-match_table_t-const fs/autofs/inode.c
--- a/fs/autofs/inode.c~fs-make-linux-kernel-parsers-match_table_t-const
+++ a/fs/autofs/inode.c
@@ -59,7 +59,7 @@ static const struct super_operations aut
 
 enum {Opt_err, Opt_fd, Opt_uid, Opt_gid, Opt_pgrp, Opt_minproto, Opt_maxproto};
 
-static match_table_t autofs_tokens = {
+static const match_table_t autofs_tokens = {
 	{Opt_fd, "fd=%u"},
 	{Opt_uid, "uid=%u"},
 	{Opt_gid, "gid=%u"},
diff -puN fs/autofs4/inode.c~fs-make-linux-kernel-parsers-match_table_t-const fs/autofs4/inode.c
--- a/fs/autofs4/inode.c~fs-make-linux-kernel-parsers-match_table_t-const
+++ a/fs/autofs4/inode.c
@@ -213,7 +213,7 @@ static const struct super_operations aut
 enum {Opt_err, Opt_fd, Opt_uid, Opt_gid, Opt_pgrp, Opt_minproto, Opt_maxproto,
 	Opt_indirect, Opt_direct, Opt_offset};
 
-static match_table_t tokens = {
+static const match_table_t tokens = {
 	{Opt_fd, "fd=%u"},
 	{Opt_uid, "uid=%u"},
 	{Opt_gid, "gid=%u"},
diff -puN fs/befs/linuxvfs.c~fs-make-linux-kernel-parsers-match_table_t-const fs/befs/linuxvfs.c
--- a/fs/befs/linuxvfs.c~fs-make-linux-kernel-parsers-match_table_t-const
+++ a/fs/befs/linuxvfs.c
@@ -649,7 +649,7 @@ enum {
 	Opt_uid, Opt_gid, Opt_charset, Opt_debug, Opt_err,
 };
 
-static match_table_t befs_tokens = {
+static const match_table_t befs_tokens = {
 	{Opt_uid, "uid=%d"},
 	{Opt_gid, "gid=%d"},
 	{Opt_charset, "iocharset=%s"},
diff -puN fs/devpts/inode.c~fs-make-linux-kernel-parsers-match_table_t-const fs/devpts/inode.c
--- a/fs/devpts/inode.c~fs-make-linux-kernel-parsers-match_table_t-const
+++ a/fs/devpts/inode.c
@@ -48,7 +48,7 @@ enum {
 	Opt_err
 };
 
-static match_table_t tokens = {
+static const match_table_t tokens = {
 	{Opt_uid, "uid=%u"},
 	{Opt_gid, "gid=%u"},
 	{Opt_mode, "mode=%o"},
diff -puN fs/ecryptfs/main.c~fs-make-linux-kernel-parsers-match_table_t-const fs/ecryptfs/main.c
--- a/fs/ecryptfs/main.c~fs-make-linux-kernel-parsers-match_table_t-const
+++ a/fs/ecryptfs/main.c
@@ -212,7 +212,7 @@ enum { ecryptfs_opt_sig, ecryptfs_opt_ec
        ecryptfs_opt_passthrough, ecryptfs_opt_xattr_metadata,
        ecryptfs_opt_encrypted_view, ecryptfs_opt_err };
 
-static match_table_t tokens = {
+static const match_table_t tokens = {
 	{ecryptfs_opt_sig, "sig=%s"},
 	{ecryptfs_opt_ecryptfs_sig, "ecryptfs_sig=%s"},
 	{ecryptfs_opt_cipher, "cipher=%s"},
diff -puN fs/ext2/super.c~fs-make-linux-kernel-parsers-match_table_t-const fs/ext2/super.c
--- a/fs/ext2/super.c~fs-make-linux-kernel-parsers-match_table_t-const
+++ a/fs/ext2/super.c
@@ -402,7 +402,7 @@ enum {
 	Opt_usrquota, Opt_grpquota, Opt_reservation, Opt_noreservation
 };
 
-static match_table_t tokens = {
+static const match_table_t tokens = {
 	{Opt_bsd_df, "bsddf"},
 	{Opt_minix_df, "minixdf"},
 	{Opt_grpid, "grpid"},
diff -puN fs/ext3/super.c~fs-make-linux-kernel-parsers-match_table_t-const fs/ext3/super.c
--- a/fs/ext3/super.c~fs-make-linux-kernel-parsers-match_table_t-const
+++ a/fs/ext3/super.c
@@ -768,7 +768,7 @@ enum {
 	Opt_grpquota
 };
 
-static match_table_t tokens = {
+static const match_table_t tokens = {
 	{Opt_bsd_df, "bsddf"},
 	{Opt_minix_df, "minixdf"},
 	{Opt_grpid, "grpid"},
diff -puN fs/ext4/super.c~fs-make-linux-kernel-parsers-match_table_t-const fs/ext4/super.c
--- a/fs/ext4/super.c~fs-make-linux-kernel-parsers-match_table_t-const
+++ a/fs/ext4/super.c
@@ -916,7 +916,7 @@ enum {
 	Opt_mballoc, Opt_nomballoc, Opt_stripe, Opt_delalloc, Opt_nodelalloc,
 };
 
-static match_table_t tokens = {
+static const match_table_t tokens = {
 	{Opt_bsd_df, "bsddf"},
 	{Opt_minix_df, "minixdf"},
 	{Opt_grpid, "grpid"},
diff -puN fs/fat/inode.c~fs-make-linux-kernel-parsers-match_table_t-const fs/fat/inode.c
--- a/fs/fat/inode.c~fs-make-linux-kernel-parsers-match_table_t-const
+++ a/fs/fat/inode.c
@@ -843,7 +843,7 @@ enum {
 	Opt_obsolate, Opt_flush, Opt_tz_utc, Opt_err,
 };
 
-static match_table_t fat_tokens = {
+static const match_table_t fat_tokens = {
 	{Opt_check_r, "check=relaxed"},
 	{Opt_check_s, "check=strict"},
 	{Opt_check_n, "check=normal"},
@@ -878,14 +878,14 @@ static match_table_t fat_tokens = {
 	{Opt_tz_utc, "tz=UTC"},
 	{Opt_err, NULL},
 };
-static match_table_t msdos_tokens = {
+static const match_table_t msdos_tokens = {
 	{Opt_nodots, "nodots"},
 	{Opt_nodots, "dotsOK=no"},
 	{Opt_dots, "dots"},
 	{Opt_dots, "dotsOK=yes"},
 	{Opt_err, NULL}
 };
-static match_table_t vfat_tokens = {
+static const match_table_t vfat_tokens = {
 	{Opt_charset, "iocharset=%s"},
 	{Opt_shortname_lower, "shortname=lower"},
 	{Opt_shortname_win95, "shortname=win95"},
diff -puN fs/fuse/inode.c~fs-make-linux-kernel-parsers-match_table_t-const fs/fuse/inode.c
--- a/fs/fuse/inode.c~fs-make-linux-kernel-parsers-match_table_t-const
+++ a/fs/fuse/inode.c
@@ -354,7 +354,7 @@ enum {
 	OPT_ERR
 };
 
-static match_table_t tokens = {
+static const match_table_t tokens = {
 	{OPT_FD,			"fd=%u"},
 	{OPT_ROOTMODE,			"rootmode=%o"},
 	{OPT_USER_ID,			"user_id=%u"},
diff -puN fs/gfs2/mount.c~fs-make-linux-kernel-parsers-match_table_t-const fs/gfs2/mount.c
--- a/fs/gfs2/mount.c~fs-make-linux-kernel-parsers-match_table_t-const
+++ a/fs/gfs2/mount.c
@@ -46,7 +46,7 @@ enum {
 	Opt_err,
 };
 
-static match_table_t tokens = {
+static const match_table_t tokens = {
 	{Opt_lockproto, "lockproto=%s"},
 	{Opt_locktable, "locktable=%s"},
 	{Opt_hostdata, "hostdata=%s"},
diff -puN fs/hfs/super.c~fs-make-linux-kernel-parsers-match_table_t-const fs/hfs/super.c
--- a/fs/hfs/super.c~fs-make-linux-kernel-parsers-match_table_t-const
+++ a/fs/hfs/super.c
@@ -173,7 +173,7 @@ enum {
 	opt_err
 };
 
-static match_table_t tokens = {
+static const match_table_t tokens = {
 	{ opt_uid, "uid=%u" },
 	{ opt_gid, "gid=%u" },
 	{ opt_umask, "umask=%o" },
diff -puN fs/hfsplus/options.c~fs-make-linux-kernel-parsers-match_table_t-const fs/hfsplus/options.c
--- a/fs/hfsplus/options.c~fs-make-linux-kernel-parsers-match_table_t-const
+++ a/fs/hfsplus/options.c
@@ -25,7 +25,7 @@ enum {
 	opt_force, opt_err
 };
 
-static match_table_t tokens = {
+static const match_table_t tokens = {
 	{ opt_creator, "creator=%s" },
 	{ opt_type, "type=%s" },
 	{ opt_umask, "umask=%o" },
diff -puN fs/hpfs/super.c~fs-make-linux-kernel-parsers-match_table_t-const fs/hpfs/super.c
--- a/fs/hpfs/super.c~fs-make-linux-kernel-parsers-match_table_t-const
+++ a/fs/hpfs/super.c
@@ -215,7 +215,7 @@ enum {
 	Opt_timeshift, Opt_err,
 };
 
-static match_table_t tokens = {
+static const match_table_t tokens = {
 	{Opt_help, "help"},
 	{Opt_uid, "uid=%u"},
 	{Opt_gid, "gid=%u"},
diff -puN fs/hugetlbfs/inode.c~fs-make-linux-kernel-parsers-match_table_t-const fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~fs-make-linux-kernel-parsers-match_table_t-const
+++ a/fs/hugetlbfs/inode.c
@@ -57,7 +57,7 @@ enum {
 	Opt_err,
 };
 
-static match_table_t tokens = {
+static const match_table_t tokens = {
 	{Opt_size,	"size=%s"},
 	{Opt_nr_inodes,	"nr_inodes=%s"},
 	{Opt_mode,	"mode=%o"},
diff -puN fs/isofs/inode.c~fs-make-linux-kernel-parsers-match_table_t-const fs/isofs/inode.c
--- a/fs/isofs/inode.c~fs-make-linux-kernel-parsers-match_table_t-const
+++ a/fs/isofs/inode.c
@@ -310,7 +310,7 @@ enum {
 	Opt_nocompress, Opt_hide, Opt_showassoc, Opt_dmode,
 };
 
-static match_table_t tokens = {
+static const match_table_t tokens = {
 	{Opt_norock, "norock"},
 	{Opt_nojoliet, "nojoliet"},
 	{Opt_unhide, "unhide"},
diff -puN fs/jfs/super.c~fs-make-linux-kernel-parsers-match_table_t-const fs/jfs/super.c
--- a/fs/jfs/super.c~fs-make-linux-kernel-parsers-match_table_t-const
+++ a/fs/jfs/super.c
@@ -199,7 +199,7 @@ enum {
 	Opt_usrquota, Opt_grpquota, Opt_uid, Opt_gid, Opt_umask
 };
 
-static match_table_t tokens = {
+static const match_table_t tokens = {
 	{Opt_integrity, "integrity"},
 	{Opt_nointegrity, "nointegrity"},
 	{Opt_iocharset, "iocharset=%s"},
diff -puN fs/nfs/nfsroot.c~fs-make-linux-kernel-parsers-match_table_t-const fs/nfs/nfsroot.c
--- a/fs/nfs/nfsroot.c~fs-make-linux-kernel-parsers-match_table_t-const
+++ a/fs/nfs/nfsroot.c
@@ -127,7 +127,7 @@ enum {
 	Opt_err
 };
 
-static match_table_t __initdata tokens = {
+static match_table_t __initconst tokens = {
 	{Opt_port, "port=%u"},
 	{Opt_rsize, "rsize=%u"},
 	{Opt_wsize, "wsize=%u"},
diff -puN fs/nfs/super.c~fs-make-linux-kernel-parsers-match_table_t-const fs/nfs/super.c
--- a/fs/nfs/super.c~fs-make-linux-kernel-parsers-match_table_t-const
+++ a/fs/nfs/super.c
@@ -98,7 +98,7 @@ enum {
 	Opt_err
 };
 
-static match_table_t nfs_mount_option_tokens = {
+static const match_table_t nfs_mount_option_tokens = {
 	{ Opt_userspace, "bg" },
 	{ Opt_userspace, "fg" },
 	{ Opt_userspace, "retry=%s" },
@@ -163,7 +163,7 @@ enum {
 	Opt_xprt_err
 };
 
-static match_table_t nfs_xprt_protocol_tokens = {
+static const match_table_t nfs_xprt_protocol_tokens = {
 	{ Opt_xprt_udp, "udp" },
 	{ Opt_xprt_tcp, "tcp" },
 	{ Opt_xprt_rdma, "rdma" },
@@ -180,7 +180,7 @@ enum {
 	Opt_sec_err
 };
 
-static match_table_t nfs_secflavor_tokens = {
+static const match_table_t nfs_secflavor_tokens = {
 	{ Opt_sec_none, "none" },
 	{ Opt_sec_none, "null" },
 	{ Opt_sec_sys, "sys" },
diff -puN fs/ocfs2/super.c~fs-make-linux-kernel-parsers-match_table_t-const fs/ocfs2/super.c
--- a/fs/ocfs2/super.c~fs-make-linux-kernel-parsers-match_table_t-const
+++ a/fs/ocfs2/super.c
@@ -157,7 +157,7 @@ enum {
 	Opt_err,
 };
 
-static match_table_t tokens = {
+static const match_table_t tokens = {
 	{Opt_barrier, "barrier=%u"},
 	{Opt_err_panic, "errors=panic"},
 	{Opt_err_ro, "errors=remount-ro"},
diff -puN fs/omfs/inode.c~fs-make-linux-kernel-parsers-match_table_t-const fs/omfs/inode.c
--- a/fs/omfs/inode.c~fs-make-linux-kernel-parsers-match_table_t-const
+++ a/fs/omfs/inode.c
@@ -346,7 +346,7 @@ enum {
 	Opt_uid, Opt_gid, Opt_umask, Opt_dmask, Opt_fmask
 };
 
-static match_table_t tokens = {
+static const match_table_t tokens = {
 	{Opt_uid, "uid=%u"},
 	{Opt_gid, "gid=%u"},
 	{Opt_umask, "umask=%o"},
diff -puN fs/ubifs/super.c~fs-make-linux-kernel-parsers-match_table_t-const fs/ubifs/super.c
--- a/fs/ubifs/super.c~fs-make-linux-kernel-parsers-match_table_t-const
+++ a/fs/ubifs/super.c
@@ -842,7 +842,7 @@ enum {
 	Opt_err,
 };
 
-static match_table_t tokens = {
+static const match_table_t tokens = {
 	{Opt_fast_unmount, "fast_unmount"},
 	{Opt_norm_unmount, "norm_unmount"},
 	{Opt_err, NULL},
diff -puN fs/udf/super.c~fs-make-linux-kernel-parsers-match_table_t-const fs/udf/super.c
--- a/fs/udf/super.c~fs-make-linux-kernel-parsers-match_table_t-const
+++ a/fs/udf/super.c
@@ -369,7 +369,7 @@ enum {
 	Opt_err, Opt_uforget, Opt_uignore, Opt_gforget, Opt_gignore
 };
 
-static match_table_t tokens = {
+static const match_table_t tokens = {
 	{Opt_novrs,	"novrs"},
 	{Opt_nostrict,	"nostrict"},
 	{Opt_bs,	"bs=%u"},
diff -puN fs/ufs/super.c~fs-make-linux-kernel-parsers-match_table_t-const fs/ufs/super.c
--- a/fs/ufs/super.c~fs-make-linux-kernel-parsers-match_table_t-const
+++ a/fs/ufs/super.c
@@ -309,7 +309,7 @@ enum {
        Opt_err
 };
 
-static match_table_t tokens = {
+static const match_table_t tokens = {
 	{Opt_type_old, "ufstype=old"},
 	{Opt_type_sunx86, "ufstype=sunx86"},
 	{Opt_type_sun, "ufstype=sun"},
@@ -1233,7 +1233,7 @@ static int ufs_show_options(struct seq_f
 {
 	struct ufs_sb_info *sbi = UFS_SB(vfs->mnt_sb);
 	unsigned mval = sbi->s_mount_opt & UFS_MOUNT_UFSTYPE;
-	struct match_token *tp = tokens;
+	const struct match_token *tp = tokens;
 
 	while (tp->token != Opt_onerror_panic && tp->token != mval)
 		++tp;
diff -puN fs/xfs/linux-2.6/xfs_super.c~fs-make-linux-kernel-parsers-match_table_t-const fs/xfs/linux-2.6/xfs_super.c
--- a/fs/xfs/linux-2.6/xfs_super.c~fs-make-linux-kernel-parsers-match_table_t-const
+++ a/fs/xfs/linux-2.6/xfs_super.c
@@ -158,7 +158,7 @@ enum {
 	Opt_barrier, Opt_nobarrier, Opt_err
 };
 
-static match_table_t tokens = {
+static const match_table_t tokens = {
 	{Opt_barrier, "barrier"},
 	{Opt_nobarrier, "nobarrier"},
 	{Opt_err, NULL}
diff -puN include/linux/parser.h~fs-make-linux-kernel-parsers-match_table_t-const include/linux/parser.h
--- a/include/linux/parser.h~fs-make-linux-kernel-parsers-match_table_t-const
+++ a/include/linux/parser.h
@@ -25,7 +25,7 @@ typedef struct {
 	char *to;
 } substring_t;
 
-int match_token(char *, match_table_t table, substring_t args[]);
+int match_token(char *, const match_table_t table, substring_t args[]);
 int match_int(substring_t *, int *result);
 int match_octal(substring_t *, int *result);
 int match_hex(substring_t *, int *result);
diff -puN lib/parser.c~fs-make-linux-kernel-parsers-match_table_t-const lib/parser.c
--- a/lib/parser.c~fs-make-linux-kernel-parsers-match_table_t-const
+++ a/lib/parser.c
@@ -100,7 +100,7 @@ static int match_one(char *s, const char
  * format identifiers which will be taken into account when matching the
  * tokens, and whose locations will be returned in the @args array.
  */
-int match_token(char *s, match_table_t table, substring_t args[])
+int match_token(char *s, const match_table_t table, substring_t args[])
 {
 	const struct match_token *p;
 
diff -puN net/9p/client.c~fs-make-linux-kernel-parsers-match_table_t-const net/9p/client.c
--- a/net/9p/client.c~fs-make-linux-kernel-parsers-match_table_t-const
+++ a/net/9p/client.c
@@ -52,7 +52,7 @@ enum {
 	Opt_err,
 };
 
-static match_table_t tokens = {
+static const match_table_t tokens = {
 	{Opt_msize, "msize=%u"},
 	{Opt_legacy, "noextend"},
 	{Opt_trans, "trans=%s"},
diff -puN net/9p/trans_fd.c~fs-make-linux-kernel-parsers-match_table_t-const net/9p/trans_fd.c
--- a/net/9p/trans_fd.c~fs-make-linux-kernel-parsers-match_table_t-const
+++ a/net/9p/trans_fd.c
@@ -86,7 +86,7 @@ enum {
 	Opt_port, Opt_rfdno, Opt_wfdno, Opt_err,
 };
 
-static match_table_t tokens = {
+static const match_table_t tokens = {
 	{Opt_port, "port=%u"},
 	{Opt_rfdno, "rfdno=%u"},
 	{Opt_wfdno, "wfdno=%u"},
diff -puN security/selinux/hooks.c~fs-make-linux-kernel-parsers-match_table_t-const security/selinux/hooks.c
--- a/security/selinux/hooks.c~fs-make-linux-kernel-parsers-match_table_t-const
+++ a/security/selinux/hooks.c
@@ -354,7 +354,7 @@ enum {
 	Opt_rootcontext = 4,
 };
 
-static match_table_t tokens = {
+static const match_table_t tokens = {
 	{Opt_context, CONTEXT_STR "%s"},
 	{Opt_fscontext, FSCONTEXT_STR "%s"},
 	{Opt_defcontext, DEFCONTEXT_STR "%s"},
_

Patches currently in -mm which might be from swhiteho@redhat.com are

linux-next.patch
fs-make-linux-kernel-parsers-match_table_t-const.patch

