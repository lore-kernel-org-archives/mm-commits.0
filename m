Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	URIBL_RED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11494C433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:55:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CCA1A61424
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:55:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbhEHW4S (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:56:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:45328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229549AbhEHW4R (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:56:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D6AA60E0B;
        Sat,  8 May 2021 22:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514515;
        bh=rbvTLDNw/aYpQ2+pjJgsuW5b7orqH3IKdApLc651iRo=;
        h=Date:From:To:Subject:From;
        b=bDG9YmCNYvJjNrQQKTAuxsbkeiCmp53F3C5PJqmipxd2Q4Tdzv36PAGjzVLMQAAlx
         D5VaCvi9vBE1nkiCU8qQtwl17urYdrShBIlkvolSPfbQMvtaDZ5y5XDMwQWLb6vC2i
         lwjhnYgpmF4yWkdeQfZLMz0HL8OgK0kbwJceC1JU=
Date:   Sat, 08 May 2021 15:55:15 -0700
From:   akpm@linux-foundation.org
To:     geert@linux-m68k.org, masahiroy@kernel.org,
        mm-commits@vger.kernel.org, ojeda@kernel.org
Subject:  [merged] treewide-remove-editor-modelines-and-cruft.patch
 removed from -mm tree
Message-ID: <20210508225515.tUxfGAWtr%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: treewide: remove editor modelines and cruft
has been removed from the -mm tree.  Its filename was
     treewide-remove-editor-modelines-and-cruft.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Masahiro Yamada <masahiroy@kernel.org>
Subject: treewide: remove editor modelines and cruft

The section "19) Editor modelines and other cruft" in
Documentation/process/coding-style.rst clearly says, "Do not include any
of these in source files."

I recently receive a patch to explicitly add a new one.

Let's do treewide cleanups, otherwise some people follow the existing code
and attempt to upstream their favoriate editor setups.

It is even nicer if scripts/checkpatch.pl can check it.

If we like to impose coding style in an editor-independent manner, I think
editorconfig (patch [1]) is a saner solution.

[1] https://lore.kernel.org/lkml/20200703073143.423557-1-danny@kdrag0n.dev/

Link: https://lkml.kernel.org/r/20210324054457.1477489-1-masahiroy@kernel.org
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reviewed-by: Miguel Ojeda <ojeda@kernel.org>	[auxdisplay]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/atari/time.c                                 |    7 ---
 arch/parisc/include/asm/pdc_chassis.h                  |    1 
 arch/um/drivers/cow.h                                  |    7 ---
 drivers/auxdisplay/panel.c                             |    7 ---
 drivers/gpu/drm/qxl/qxl_drv.c                          |    1 
 drivers/media/usb/pwc/pwc-uncompress.c                 |    3 -
 drivers/net/ethernet/adaptec/starfire.c                |    8 ----
 drivers/net/ethernet/amd/atarilance.c                  |    8 ----
 drivers/net/ethernet/amd/pcnet32.c                     |    7 ---
 drivers/net/wireless/intersil/orinoco/orinoco_nortel.c |    8 ----
 drivers/net/wireless/intersil/orinoco/orinoco_pci.c    |    8 ----
 drivers/net/wireless/intersil/orinoco/orinoco_plx.c    |    8 ----
 drivers/net/wireless/intersil/orinoco/orinoco_tmd.c    |    8 ----
 drivers/parport/parport_ip32.c                         |   12 ------
 drivers/platform/x86/dell/dell_rbu.c                   |    3 -
 drivers/scsi/53c700.c                                  |    1 
 drivers/scsi/53c700.h                                  |    1 
 drivers/scsi/ch.c                                      |    6 ---
 drivers/scsi/ips.c                                     |   20 ----------
 drivers/scsi/ips.h                                     |   20 ----------
 drivers/scsi/lasi700.c                                 |    1 
 drivers/scsi/megaraid/mbox_defs.h                      |    2 -
 drivers/scsi/megaraid/mega_common.h                    |    2 -
 drivers/scsi/megaraid/megaraid_mbox.c                  |    2 -
 drivers/scsi/megaraid/megaraid_mbox.h                  |    2 -
 drivers/scsi/qla1280.c                                 |   12 ------
 drivers/scsi/sni_53c710.c                              |    1 
 drivers/video/fbdev/matrox/matroxfb_base.c             |    9 ----
 drivers/video/fbdev/vga16fb.c                          |   10 -----
 fs/configfs/configfs_internal.h                        |    4 --
 fs/configfs/dir.c                                      |    4 --
 fs/configfs/file.c                                     |    4 --
 fs/configfs/inode.c                                    |    4 --
 fs/configfs/item.c                                     |    4 --
 fs/configfs/mount.c                                    |    4 --
 fs/configfs/symlink.c                                  |    4 --
 fs/nfs/dir.c                                           |    7 ---
 fs/nfs/nfs4proc.c                                      |    6 ---
 fs/nfs/nfs4renewd.c                                    |    6 ---
 fs/nfs/nfs4state.c                                     |    6 ---
 fs/nfs/nfs4xdr.c                                       |    6 ---
 fs/nfsd/nfs4proc.c                                     |    6 ---
 fs/nfsd/nfs4xdr.c                                      |    6 ---
 fs/nfsd/xdr4.h                                         |    6 ---
 fs/ocfs2/acl.c                                         |    4 --
 fs/ocfs2/acl.h                                         |    4 --
 fs/ocfs2/alloc.c                                       |    4 --
 fs/ocfs2/alloc.h                                       |    4 --
 fs/ocfs2/aops.c                                        |    4 --
 fs/ocfs2/aops.h                                        |    4 --
 fs/ocfs2/blockcheck.c                                  |    4 --
 fs/ocfs2/blockcheck.h                                  |    4 --
 fs/ocfs2/buffer_head_io.c                              |    4 --
 fs/ocfs2/buffer_head_io.h                              |    4 --
 fs/ocfs2/cluster/heartbeat.c                           |    4 --
 fs/ocfs2/cluster/heartbeat.h                           |    4 --
 fs/ocfs2/cluster/masklog.c                             |    4 --
 fs/ocfs2/cluster/masklog.h                             |    4 --
 fs/ocfs2/cluster/netdebug.c                            |    4 --
 fs/ocfs2/cluster/nodemanager.c                         |    4 --
 fs/ocfs2/cluster/nodemanager.h                         |    4 --
 fs/ocfs2/cluster/ocfs2_heartbeat.h                     |    4 --
 fs/ocfs2/cluster/ocfs2_nodemanager.h                   |    4 --
 fs/ocfs2/cluster/quorum.c                              |    4 --
 fs/ocfs2/cluster/quorum.h                              |    4 --
 fs/ocfs2/cluster/sys.c                                 |    4 --
 fs/ocfs2/cluster/sys.h                                 |    4 --
 fs/ocfs2/cluster/tcp.c                                 |    4 --
 fs/ocfs2/cluster/tcp.h                                 |    4 --
 fs/ocfs2/cluster/tcp_internal.h                        |    4 --
 fs/ocfs2/dcache.c                                      |    4 --
 fs/ocfs2/dcache.h                                      |    4 --
 fs/ocfs2/dir.c                                         |    4 --
 fs/ocfs2/dir.h                                         |    4 --
 fs/ocfs2/dlm/dlmapi.h                                  |    4 --
 fs/ocfs2/dlm/dlmast.c                                  |    4 --
 fs/ocfs2/dlm/dlmcommon.h                               |    4 --
 fs/ocfs2/dlm/dlmconvert.c                              |    4 --
 fs/ocfs2/dlm/dlmconvert.h                              |    4 --
 fs/ocfs2/dlm/dlmdebug.c                                |    4 --
 fs/ocfs2/dlm/dlmdebug.h                                |    4 --
 fs/ocfs2/dlm/dlmdomain.c                               |    4 --
 fs/ocfs2/dlm/dlmdomain.h                               |    4 --
 fs/ocfs2/dlm/dlmlock.c                                 |    4 --
 fs/ocfs2/dlm/dlmmaster.c                               |    4 --
 fs/ocfs2/dlm/dlmrecovery.c                             |    4 --
 fs/ocfs2/dlm/dlmthread.c                               |    4 --
 fs/ocfs2/dlm/dlmunlock.c                               |    4 --
 fs/ocfs2/dlmfs/dlmfs.c                                 |    4 --
 fs/ocfs2/dlmfs/userdlm.c                               |    4 --
 fs/ocfs2/dlmfs/userdlm.h                               |    4 --
 fs/ocfs2/dlmglue.c                                     |    4 --
 fs/ocfs2/dlmglue.h                                     |    4 --
 fs/ocfs2/export.c                                      |    4 --
 fs/ocfs2/export.h                                      |    4 --
 fs/ocfs2/extent_map.c                                  |    4 --
 fs/ocfs2/extent_map.h                                  |    4 --
 fs/ocfs2/file.c                                        |    4 --
 fs/ocfs2/file.h                                        |    4 --
 fs/ocfs2/filecheck.c                                   |    4 --
 fs/ocfs2/filecheck.h                                   |    4 --
 fs/ocfs2/heartbeat.c                                   |    4 --
 fs/ocfs2/heartbeat.h                                   |    4 --
 fs/ocfs2/inode.c                                       |    4 --
 fs/ocfs2/inode.h                                       |    4 --
 fs/ocfs2/journal.c                                     |    4 --
 fs/ocfs2/journal.h                                     |    4 --
 fs/ocfs2/localalloc.c                                  |    4 --
 fs/ocfs2/localalloc.h                                  |    4 --
 fs/ocfs2/locks.c                                       |    4 --
 fs/ocfs2/locks.h                                       |    4 --
 fs/ocfs2/mmap.c                                        |    4 --
 fs/ocfs2/move_extents.c                                |    4 --
 fs/ocfs2/move_extents.h                                |    4 --
 fs/ocfs2/namei.c                                       |    4 --
 fs/ocfs2/namei.h                                       |    4 --
 fs/ocfs2/ocfs1_fs_compat.h                             |    4 --
 fs/ocfs2/ocfs2.h                                       |    4 --
 fs/ocfs2/ocfs2_fs.h                                    |    4 --
 fs/ocfs2/ocfs2_ioctl.h                                 |    4 --
 fs/ocfs2/ocfs2_lockid.h                                |    4 --
 fs/ocfs2/ocfs2_lockingver.h                            |    4 --
 fs/ocfs2/refcounttree.c                                |    4 --
 fs/ocfs2/refcounttree.h                                |    4 --
 fs/ocfs2/reservations.c                                |    4 --
 fs/ocfs2/reservations.h                                |    4 --
 fs/ocfs2/resize.c                                      |    4 --
 fs/ocfs2/resize.h                                      |    4 --
 fs/ocfs2/slot_map.c                                    |    4 --
 fs/ocfs2/slot_map.h                                    |    4 --
 fs/ocfs2/stack_o2cb.c                                  |    4 --
 fs/ocfs2/stack_user.c                                  |    4 --
 fs/ocfs2/stackglue.c                                   |    4 --
 fs/ocfs2/stackglue.h                                   |    4 --
 fs/ocfs2/suballoc.c                                    |    4 --
 fs/ocfs2/suballoc.h                                    |    4 --
 fs/ocfs2/super.c                                       |    4 --
 fs/ocfs2/super.h                                       |    4 --
 fs/ocfs2/symlink.c                                     |    4 --
 fs/ocfs2/symlink.h                                     |    4 --
 fs/ocfs2/sysfile.c                                     |    4 --
 fs/ocfs2/sysfile.h                                     |    4 --
 fs/ocfs2/uptodate.c                                    |    4 --
 fs/ocfs2/uptodate.h                                    |    4 --
 fs/ocfs2/xattr.c                                       |    4 --
 fs/ocfs2/xattr.h                                       |    4 --
 fs/reiserfs/procfs.c                                   |   10 -----
 include/linux/configfs.h                               |    4 --
 include/linux/genl_magic_func.h                        |    1 
 include/linux/genl_magic_struct.h                      |    1 
 include/uapi/linux/if_bonding.h                        |   11 -----
 include/uapi/linux/nfs4.h                              |    6 ---
 include/xen/interface/elfnote.h                        |   10 -----
 include/xen/interface/hvm/hvm_vcpu.h                   |   10 -----
 include/xen/interface/io/xenbus.h                      |   10 -----
 samples/configfs/configfs_sample.c                     |    2 -
 tools/usb/hcd-tests.sh                                 |    2 -
 157 files changed, 110 insertions(+), 627 deletions(-)

--- a/arch/m68k/atari/time.c~treewide-remove-editor-modelines-and-cruft
+++ a/arch/m68k/atari/time.c
@@ -317,10 +317,3 @@ int atari_tt_hwclk( int op, struct rtc_t
 
     return( 0 );
 }
-
-/*
- * Local variables:
- *  c-indent-level: 4
- *  tab-width: 8
- * End:
- */
--- a/arch/parisc/include/asm/pdc_chassis.h~treewide-remove-editor-modelines-and-cruft
+++ a/arch/parisc/include/asm/pdc_chassis.h
@@ -365,4 +365,3 @@ void parisc_pdc_chassis_init(void);
 					 PDC_CHASSIS_EOM_SET		)
 
 #endif /* _PARISC_PDC_CHASSIS_H */
-/* vim: set ts=8 */
--- a/arch/um/drivers/cow.h~treewide-remove-editor-modelines-and-cruft
+++ a/arch/um/drivers/cow.h
@@ -24,10 +24,3 @@ extern void cow_sizes(int version, __u64
 		      int *data_offset_out);
 
 #endif
-
-/*
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
--- a/drivers/auxdisplay/panel.c~treewide-remove-editor-modelines-and-cruft
+++ a/drivers/auxdisplay/panel.c
@@ -1737,10 +1737,3 @@ module_init(panel_init_module);
 module_exit(panel_cleanup_module);
 MODULE_AUTHOR("Willy Tarreau");
 MODULE_LICENSE("GPL");
-
-/*
- * Local variables:
- *  c-indent-level: 4
- *  tab-width: 8
- * End:
- */
--- a/drivers/gpu/drm/qxl/qxl_drv.c~treewide-remove-editor-modelines-and-cruft
+++ a/drivers/gpu/drm/qxl/qxl_drv.c
@@ -1,4 +1,3 @@
-/* vim: set ts=8 sw=8 tw=78 ai noexpandtab */
 /* qxl_drv.c -- QXL driver -*- linux-c -*-
  *
  * Copyright 2011 Red Hat, Inc.
--- a/drivers/media/usb/pwc/pwc-uncompress.c~treewide-remove-editor-modelines-and-cruft
+++ a/drivers/media/usb/pwc/pwc-uncompress.c
@@ -9,9 +9,6 @@
    Please send bug reports and support requests to <luc@saillard.org>.
    The decompression routines have been implemented by reverse-engineering the
    Nemosoft binary pwcx module. Caveat emptor.
-
-
-   vim: set ts=8:
 */
 
 #include <asm/current.h>
--- a/drivers/net/ethernet/adaptec/starfire.c~treewide-remove-editor-modelines-and-cruft
+++ a/drivers/net/ethernet/adaptec/starfire.c
@@ -2070,11 +2070,3 @@ static void __exit starfire_cleanup (voi
 
 module_init(starfire_init);
 module_exit(starfire_cleanup);
-
-
-/*
- * Local variables:
- *  c-basic-offset: 8
- *  tab-width: 8
- * End:
- */
--- a/drivers/net/ethernet/amd/atarilance.c~treewide-remove-editor-modelines-and-cruft
+++ a/drivers/net/ethernet/amd/atarilance.c
@@ -1156,11 +1156,3 @@ static void __exit atarilance_module_exi
 module_init(atarilance_module_init);
 module_exit(atarilance_module_exit);
 #endif /* MODULE */
-
-
-/*
- * Local variables:
- *  c-indent-level: 4
- *  tab-width: 4
- * End:
- */
--- a/drivers/net/ethernet/amd/pcnet32.c~treewide-remove-editor-modelines-and-cruft
+++ a/drivers/net/ethernet/amd/pcnet32.c
@@ -3029,10 +3029,3 @@ static void __exit pcnet32_cleanup_modul
 
 module_init(pcnet32_init_module);
 module_exit(pcnet32_cleanup_module);
-
-/*
- * Local variables:
- *  c-indent-level: 4
- *  tab-width: 8
- * End:
- */
--- a/drivers/net/wireless/intersil/orinoco/orinoco_nortel.c~treewide-remove-editor-modelines-and-cruft
+++ a/drivers/net/wireless/intersil/orinoco/orinoco_nortel.c
@@ -312,11 +312,3 @@ static void __exit orinoco_nortel_exit(v
 
 module_init(orinoco_nortel_init);
 module_exit(orinoco_nortel_exit);
-
-/*
- * Local variables:
- *  c-indent-level: 8
- *  c-basic-offset: 8
- *  tab-width: 8
- * End:
- */
--- a/drivers/net/wireless/intersil/orinoco/orinoco_pci.c~treewide-remove-editor-modelines-and-cruft
+++ a/drivers/net/wireless/intersil/orinoco/orinoco_pci.c
@@ -255,11 +255,3 @@ static void __exit orinoco_pci_exit(void
 
 module_init(orinoco_pci_init);
 module_exit(orinoco_pci_exit);
-
-/*
- * Local variables:
- *  c-indent-level: 8
- *  c-basic-offset: 8
- *  tab-width: 8
- * End:
- */
--- a/drivers/net/wireless/intersil/orinoco/orinoco_plx.c~treewide-remove-editor-modelines-and-cruft
+++ a/drivers/net/wireless/intersil/orinoco/orinoco_plx.c
@@ -360,11 +360,3 @@ static void __exit orinoco_plx_exit(void
 
 module_init(orinoco_plx_init);
 module_exit(orinoco_plx_exit);
-
-/*
- * Local variables:
- *  c-indent-level: 8
- *  c-basic-offset: 8
- *  tab-width: 8
- * End:
- */
--- a/drivers/net/wireless/intersil/orinoco/orinoco_tmd.c~treewide-remove-editor-modelines-and-cruft
+++ a/drivers/net/wireless/intersil/orinoco/orinoco_tmd.c
@@ -235,11 +235,3 @@ static void __exit orinoco_tmd_exit(void
 
 module_init(orinoco_tmd_init);
 module_exit(orinoco_tmd_exit);
-
-/*
- * Local variables:
- *  c-indent-level: 8
- *  c-basic-offset: 8
- *  tab-width: 8
- * End:
- */
--- a/drivers/parport/parport_ip32.c~treewide-remove-editor-modelines-and-cruft
+++ a/drivers/parport/parport_ip32.c
@@ -2224,15 +2224,3 @@ MODULE_PARM_DESC(features,
 		 ", bit 2: hardware SPP mode"
 		 ", bit 3: hardware EPP mode"
 		 ", bit 4: hardware ECP mode");
-
-/*--- Inform (X)Emacs about preferred coding style ---------------------*/
-/*
- * Local Variables:
- * mode: c
- * c-file-style: "linux"
- * indent-tabs-mode: t
- * tab-width: 8
- * fill-column: 78
- * ispell-local-dictionary: "american"
- * End:
- */
--- a/drivers/platform/x86/dell/dell_rbu.c~treewide-remove-editor-modelines-and-cruft
+++ a/drivers/platform/x86/dell/dell_rbu.c
@@ -675,6 +675,3 @@ static __exit void dcdrbu_exit(void)
 
 module_exit(dcdrbu_exit);
 module_init(dcdrbu_init);
-
-/* vim:noet:ts=8:sw=8
-*/
--- a/drivers/scsi/53c700.c~treewide-remove-editor-modelines-and-cruft
+++ a/drivers/scsi/53c700.c
@@ -1,5 +1,4 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
-/* -*- mode: c; c-basic-offset: 8 -*- */
 
 /* NCR (or Symbios) 53c700 and 53c700-66 Driver
  *
--- a/drivers/scsi/53c700.h~treewide-remove-editor-modelines-and-cruft
+++ a/drivers/scsi/53c700.h
@@ -1,5 +1,4 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/* -*- mode: c; c-basic-offset: 8 -*- */
 
 /* Driver for 53c700 and 53c700-66 chips from NCR and Symbios
  *
--- a/drivers/scsi/ch.c~treewide-remove-editor-modelines-and-cruft
+++ a/drivers/scsi/ch.c
@@ -1058,9 +1058,3 @@ static void __exit exit_ch_module(void)
 
 module_init(init_ch_module);
 module_exit(exit_ch_module);
-
-/*
- * Local variables:
- * c-basic-offset: 8
- * End:
- */
--- a/drivers/scsi/ips.c~treewide-remove-editor-modelines-and-cruft
+++ a/drivers/scsi/ips.c
@@ -7099,23 +7099,3 @@ ips_init_phase2(int index)
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("IBM ServeRAID Adapter Driver " IPS_VER_STRING);
 MODULE_VERSION(IPS_VER_STRING);
-
-
-/*
- * Overrides for Emacs so that we almost follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-indent-level: 2
- * c-brace-imaginary-offset: 0
- * c-brace-offset: -2
- * c-argdecl-indent: 2
- * c-label-offset: -2
- * c-continued-statement-offset: 2
- * c-continued-brace-offset: 0
- * indent-tabs-mode: nil
- * tab-width: 8
- * End:
- */
--- a/drivers/scsi/ips.h~treewide-remove-editor-modelines-and-cruft
+++ a/drivers/scsi/ips.h
@@ -1211,23 +1211,3 @@ typedef struct {
       IPS_COMPAT_TAMPA, \
       IPS_COMPAT_KEYWEST \
    }
-
-
-/*
- * Overrides for Emacs so that we almost follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-indent-level: 2
- * c-brace-imaginary-offset: 0
- * c-brace-offset: -2
- * c-argdecl-indent: 2
- * c-label-offset: -2
- * c-continued-statement-offset: 2
- * c-continued-brace-offset: 0
- * indent-tabs-mode: nil
- * tab-width: 8
- * End:
- */
--- a/drivers/scsi/lasi700.c~treewide-remove-editor-modelines-and-cruft
+++ a/drivers/scsi/lasi700.c
@@ -1,5 +1,4 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
-/* -*- mode: c; c-basic-offset: 8 -*- */
 
 /* PARISC LASI driver for the 53c700 chip
  *
--- a/drivers/scsi/megaraid/mbox_defs.h~treewide-remove-editor-modelines-and-cruft
+++ a/drivers/scsi/megaraid/mbox_defs.h
@@ -781,5 +781,3 @@ typedef struct {
 } __attribute__ ((packed)) mbox_sgl32;
 
 #endif		// _MRAID_MBOX_DEFS_H_
-
-/* vim: set ts=8 sw=8 tw=78: */
--- a/drivers/scsi/megaraid/mega_common.h~treewide-remove-editor-modelines-and-cruft
+++ a/drivers/scsi/megaraid/mega_common.h
@@ -282,5 +282,3 @@ struct mraid_pci_blk {
 };
 
 #endif // _MEGA_COMMON_H_
-
-// vim: set ts=8 sw=8 tw=78:
--- a/drivers/scsi/megaraid/megaraid_mbox.c~treewide-remove-editor-modelines-and-cruft
+++ a/drivers/scsi/megaraid/megaraid_mbox.c
@@ -4068,5 +4068,3 @@ megaraid_sysfs_show_ldnum(struct device
  */
 module_init(megaraid_init);
 module_exit(megaraid_exit);
-
-/* vim: set ts=8 sw=8 tw=78 ai si: */
--- a/drivers/scsi/megaraid/megaraid_mbox.h~treewide-remove-editor-modelines-and-cruft
+++ a/drivers/scsi/megaraid/megaraid_mbox.h
@@ -230,5 +230,3 @@ typedef struct {
 #define WROUTDOOR(rdev, value)	writel(value, (rdev)->baseaddr + 0x2C)
 
 #endif // _MEGARAID_H_
-
-// vim: set ts=8 sw=8 tw=78:
--- a/drivers/scsi/qla1280.c~treewide-remove-editor-modelines-and-cruft
+++ a/drivers/scsi/qla1280.c
@@ -4403,15 +4403,3 @@ MODULE_FIRMWARE("qlogic/1040.bin");
 MODULE_FIRMWARE("qlogic/1280.bin");
 MODULE_FIRMWARE("qlogic/12160.bin");
 MODULE_VERSION(QLA1280_VERSION);
-
-/*
- * Overrides for Emacs so that we almost follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-basic-offset: 8
- * tab-width: 8
- * End:
- */
--- a/drivers/scsi/sni_53c710.c~treewide-remove-editor-modelines-and-cruft
+++ a/drivers/scsi/sni_53c710.c
@@ -1,5 +1,4 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
-/* -*- mode: c; c-basic-offset: 8 -*- */
 
 /* SNI RM driver
  *
--- a/drivers/video/fbdev/matrox/matroxfb_base.c~treewide-remove-editor-modelines-and-cruft
+++ a/drivers/video/fbdev/matrox/matroxfb_base.c
@@ -2608,12 +2608,3 @@ EXPORT_SYMBOL(matroxfb_register_driver);
 EXPORT_SYMBOL(matroxfb_unregister_driver);
 EXPORT_SYMBOL(matroxfb_wait_for_sync);
 EXPORT_SYMBOL(matroxfb_enable_irq);
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-basic-offset: 8
- * End:
- */
-
--- a/drivers/video/fbdev/vga16fb.c~treewide-remove-editor-modelines-and-cruft
+++ a/drivers/video/fbdev/vga16fb.c
@@ -1451,13 +1451,3 @@ MODULE_DESCRIPTION("Legacy VGA framebuff
 MODULE_LICENSE("GPL");
 module_init(vga16fb_init);
 module_exit(vga16fb_exit);
-
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-basic-offset: 8
- * End:
- */
-
--- a/fs/configfs/configfs_internal.h~treewide-remove-editor-modelines-and-cruft
+++ a/fs/configfs/configfs_internal.h
@@ -1,7 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
-/* -*- mode: c; c-basic-offset:8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * configfs_internal.h - Internal stuff for configfs
  *
  * Based on sysfs:
--- a/fs/configfs/dir.c~treewide-remove-editor-modelines-and-cruft
+++ a/fs/configfs/dir.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * dir.c - Operations for configfs directories.
  *
  * Based on sysfs:
--- a/fs/configfs/file.c~treewide-remove-editor-modelines-and-cruft
+++ a/fs/configfs/file.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * file.c - operations for regular (text) files.
  *
  * Based on sysfs:
--- a/fs/configfs/inode.c~treewide-remove-editor-modelines-and-cruft
+++ a/fs/configfs/inode.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * inode.c - basic inode and dentry operations.
  *
  * Based on sysfs:
--- a/fs/configfs/item.c~treewide-remove-editor-modelines-and-cruft
+++ a/fs/configfs/item.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * item.c - library routines for handling generic config items
  *
  * Based on kobject:
--- a/fs/configfs/mount.c~treewide-remove-editor-modelines-and-cruft
+++ a/fs/configfs/mount.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * mount.c - operations for initializing and mounting configfs.
  *
  * Based on sysfs:
--- a/fs/configfs/symlink.c~treewide-remove-editor-modelines-and-cruft
+++ a/fs/configfs/symlink.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * symlink.c - operations for configfs symlinks.
  *
  * Based on sysfs:
--- a/fs/nfs/dir.c~treewide-remove-editor-modelines-and-cruft
+++ a/fs/nfs/dir.c
@@ -3004,10 +3004,3 @@ out_notsup:
 	goto out;
 }
 EXPORT_SYMBOL_GPL(nfs_permission);
-
-/*
- * Local variables:
- *  version-control: t
- *  kept-new-versions: 5
- * End:
- */
--- a/fs/nfsd/nfs4proc.c~treewide-remove-editor-modelines-and-cruft
+++ a/fs/nfsd/nfs4proc.c
@@ -3317,9 +3317,3 @@ const struct svc_version nfsd_version4 =
 	.vs_rpcb_optnl		= true,
 	.vs_need_cong_ctrl	= true,
 };
-
-/*
- * Local variables:
- *  c-basic-offset: 8
- * End:
- */
--- a/fs/nfsd/nfs4xdr.c~treewide-remove-editor-modelines-and-cruft
+++ a/fs/nfsd/nfs4xdr.c
@@ -5448,9 +5448,3 @@ nfs4svc_encode_compoundres(struct svc_rq
 	nfsd4_sequence_done(resp);
 	return 1;
 }
-
-/*
- * Local variables:
- *  c-basic-offset: 8
- * End:
- */
--- a/fs/nfsd/xdr4.h~treewide-remove-editor-modelines-and-cruft
+++ a/fs/nfsd/xdr4.h
@@ -866,9 +866,3 @@ struct nfsd4_operation {
 
 
 #endif
-
-/*
- * Local variables:
- *  c-basic-offset: 8
- * End:
- */
--- a/fs/nfs/nfs4proc.c~treewide-remove-editor-modelines-and-cruft
+++ a/fs/nfs/nfs4proc.c
@@ -10427,9 +10427,3 @@ const struct xattr_handler *nfs4_xattr_h
 #endif
 	NULL
 };
-
-/*
- * Local variables:
- *  c-basic-offset: 8
- * End:
- */
--- a/fs/nfs/nfs4renewd.c~treewide-remove-editor-modelines-and-cruft
+++ a/fs/nfs/nfs4renewd.c
@@ -149,9 +149,3 @@ void nfs4_set_lease_period(struct nfs_cl
 	/* Cap maximum reconnect timeout at 1/2 lease period */
 	rpc_set_connect_timeout(clp->cl_rpcclient, lease, lease >> 1);
 }
-
-/*
- * Local variables:
- *   c-basic-offset: 8
- * End:
- */
--- a/fs/nfs/nfs4state.c~treewide-remove-editor-modelines-and-cruft
+++ a/fs/nfs/nfs4state.c
@@ -2695,9 +2695,3 @@ static int nfs4_run_state_manager(void *
 	module_put_and_exit(0);
 	return 0;
 }
-
-/*
- * Local variables:
- *  c-basic-offset: 8
- * End:
- */
--- a/fs/nfs/nfs4xdr.c~treewide-remove-editor-modelines-and-cruft
+++ a/fs/nfs/nfs4xdr.c
@@ -7629,9 +7629,3 @@ const struct rpc_version nfs_version4 =
 	.procs			= nfs4_procedures,
 	.counts			= nfs_version4_counts,
 };
-
-/*
- * Local variables:
- *  c-basic-offset: 8
- * End:
- */
--- a/fs/ocfs2/acl.c~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/acl.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * acl.c
  *
  * Copyright (C) 2004, 2008 Oracle.  All rights reserved.
--- a/fs/ocfs2/acl.h~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/acl.h
@@ -1,7 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * acl.h
  *
  * Copyright (C) 2004, 2008 Oracle.  All rights reserved.
--- a/fs/ocfs2/alloc.c~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/alloc.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * alloc.c
  *
  * Extent allocs and frees
--- a/fs/ocfs2/alloc.h~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/alloc.h
@@ -1,7 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * alloc.h
  *
  * Function prototypes
--- a/fs/ocfs2/aops.c~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/aops.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * Copyright (C) 2002, 2004 Oracle.  All rights reserved.
  */
 
--- a/fs/ocfs2/aops.h~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/aops.h
@@ -1,7 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * Copyright (C) 2002, 2004, 2005 Oracle.  All rights reserved.
  */
 
--- a/fs/ocfs2/blockcheck.c~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/blockcheck.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * blockcheck.c
  *
  * Checksum and ECC codes for the OCFS2 userspace library.
--- a/fs/ocfs2/blockcheck.h~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/blockcheck.h
@@ -1,7 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * blockcheck.h
  *
  * Checksum and ECC codes for the OCFS2 userspace library.
--- a/fs/ocfs2/buffer_head_io.c~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/buffer_head_io.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * io.c
  *
  * Buffer cache handling
--- a/fs/ocfs2/buffer_head_io.h~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/buffer_head_io.h
@@ -1,7 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * ocfs2_buffer_head.h
  *
  * Buffer cache handling functions defined
--- a/fs/ocfs2/cluster/heartbeat.c~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/cluster/heartbeat.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * Copyright (C) 2004, 2005 Oracle.  All rights reserved.
  */
 
--- a/fs/ocfs2/cluster/heartbeat.h~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/cluster/heartbeat.h
@@ -1,7 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * heartbeat.h
  *
  * Function prototypes
--- a/fs/ocfs2/cluster/masklog.c~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/cluster/masklog.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * Copyright (C) 2004, 2005 Oracle.  All rights reserved.
  */
 
--- a/fs/ocfs2/cluster/masklog.h~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/cluster/masklog.h
@@ -1,7 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * Copyright (C) 2005 Oracle.  All rights reserved.
  */
 
--- a/fs/ocfs2/cluster/netdebug.c~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/cluster/netdebug.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * netdebug.c
  *
  * debug functionality for o2net
--- a/fs/ocfs2/cluster/nodemanager.c~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/cluster/nodemanager.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * Copyright (C) 2004, 2005 Oracle.  All rights reserved.
  */
 
--- a/fs/ocfs2/cluster/nodemanager.h~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/cluster/nodemanager.h
@@ -1,7 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * nodemanager.h
  *
  * Function prototypes
--- a/fs/ocfs2/cluster/ocfs2_heartbeat.h~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/cluster/ocfs2_heartbeat.h
@@ -1,7 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * ocfs2_heartbeat.h
  *
  * On-disk structures for ocfs2_heartbeat
--- a/fs/ocfs2/cluster/ocfs2_nodemanager.h~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/cluster/ocfs2_nodemanager.h
@@ -1,7 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * ocfs2_nodemanager.h
  *
  * Header describing the interface between userspace and the kernel
--- a/fs/ocfs2/cluster/quorum.c~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/cluster/quorum.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
-/* -*- mode: c; c-basic-offset: 8; -*-
- *
- * vim: noexpandtab sw=8 ts=8 sts=0:
+/*
  *
  * Copyright (C) 2005 Oracle.  All rights reserved.
  */
--- a/fs/ocfs2/cluster/quorum.h~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/cluster/quorum.h
@@ -1,7 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * Copyright (C) 2005 Oracle.  All rights reserved.
  */
 
--- a/fs/ocfs2/cluster/sys.c~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/cluster/sys.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * sys.c
  *
  * OCFS2 cluster sysfs interface
--- a/fs/ocfs2/cluster/sys.h~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/cluster/sys.h
@@ -1,7 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * sys.h
  *
  * Function prototypes for o2cb sysfs interface
--- a/fs/ocfs2/cluster/tcp.c~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/cluster/tcp.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
-/* -*- mode: c; c-basic-offset: 8; -*-
- *
- * vim: noexpandtab sw=8 ts=8 sts=0:
+/*
  *
  * Copyright (C) 2004 Oracle.  All rights reserved.
  *
--- a/fs/ocfs2/cluster/tcp.h~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/cluster/tcp.h
@@ -1,7 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * tcp.h
  *
  * Function prototypes
--- a/fs/ocfs2/cluster/tcp_internal.h~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/cluster/tcp_internal.h
@@ -1,7 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * Copyright (C) 2005 Oracle.  All rights reserved.
  */
 
--- a/fs/ocfs2/dcache.c~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/dcache.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * dcache.c
  *
  * dentry cache handling code
--- a/fs/ocfs2/dcache.h~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/dcache.h
@@ -1,7 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * dcache.h
  *
  * Function prototypes
--- a/fs/ocfs2/dir.c~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/dir.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * dir.c
  *
  * Creates, reads, walks and deletes directory-nodes
--- a/fs/ocfs2/dir.h~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/dir.h
@@ -1,7 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * dir.h
  *
  * Function prototypes
--- a/fs/ocfs2/dlm/dlmapi.h~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/dlm/dlmapi.h
@@ -1,7 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * dlmapi.h
  *
  * externally exported dlm interfaces
--- a/fs/ocfs2/dlm/dlmast.c~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/dlm/dlmast.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * dlmast.c
  *
  * AST and BAST functionality for local and remote nodes
--- a/fs/ocfs2/dlm/dlmcommon.h~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/dlm/dlmcommon.h
@@ -1,7 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * dlmcommon.h
  *
  * Copyright (C) 2004 Oracle.  All rights reserved.
--- a/fs/ocfs2/dlm/dlmconvert.c~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/dlm/dlmconvert.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * dlmconvert.c
  *
  * underlying calls for lock conversion
--- a/fs/ocfs2/dlm/dlmconvert.h~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/dlm/dlmconvert.h
@@ -1,7 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * dlmconvert.h
  *
  * Copyright (C) 2004 Oracle.  All rights reserved.
--- a/fs/ocfs2/dlm/dlmdebug.c~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/dlm/dlmdebug.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * dlmdebug.c
  *
  * debug functionality for the dlm
--- a/fs/ocfs2/dlm/dlmdebug.h~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/dlm/dlmdebug.h
@@ -1,7 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * dlmdebug.h
  *
  * Copyright (C) 2008 Oracle.  All rights reserved.
--- a/fs/ocfs2/dlm/dlmdomain.c~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/dlm/dlmdomain.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * dlmdomain.c
  *
  * defines domain join / leave apis
--- a/fs/ocfs2/dlm/dlmdomain.h~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/dlm/dlmdomain.h
@@ -1,7 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * dlmdomain.h
  *
  * Copyright (C) 2004 Oracle.  All rights reserved.
--- a/fs/ocfs2/dlm/dlmlock.c~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/dlm/dlmlock.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * dlmlock.c
  *
  * underlying calls for lock creation
--- a/fs/ocfs2/dlm/dlmmaster.c~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/dlm/dlmmaster.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * dlmmod.c
  *
  * standalone DLM module
--- a/fs/ocfs2/dlm/dlmrecovery.c~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/dlm/dlmrecovery.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * dlmrecovery.c
  *
  * recovery stuff
--- a/fs/ocfs2/dlm/dlmthread.c~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/dlm/dlmthread.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * dlmthread.c
  *
  * standalone DLM module
--- a/fs/ocfs2/dlm/dlmunlock.c~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/dlm/dlmunlock.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * dlmunlock.c
  *
  * underlying calls for unlocking locks
--- a/fs/ocfs2/dlmfs/dlmfs.c~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/dlmfs/dlmfs.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * dlmfs.c
  *
  * Code which implements the kernel side of a minimal userspace
--- a/fs/ocfs2/dlmfs/userdlm.c~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/dlmfs/userdlm.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * userdlm.c
  *
  * Code which implements the kernel side of a minimal userspace
--- a/fs/ocfs2/dlmfs/userdlm.h~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/dlmfs/userdlm.h
@@ -1,7 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * userdlm.h
  *
  * Userspace dlm defines
--- a/fs/ocfs2/dlmglue.c~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/dlmglue.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * dlmglue.c
  *
  * Code which implements an OCFS2 specific interface to our DLM.
--- a/fs/ocfs2/dlmglue.h~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/dlmglue.h
@@ -1,7 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * dlmglue.h
  *
  * description here
--- a/fs/ocfs2/export.c~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/export.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * export.c
  *
  * Functions to facilitate NFS exporting
--- a/fs/ocfs2/export.h~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/export.h
@@ -1,7 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * export.h
  *
  * Function prototypes
--- a/fs/ocfs2/extent_map.c~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/extent_map.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * extent_map.c
  *
  * Block/Cluster mapping functions
--- a/fs/ocfs2/extent_map.h~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/extent_map.h
@@ -1,7 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * extent_map.h
  *
  * In-memory file extent mappings for OCFS2.
--- a/fs/ocfs2/file.c~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/file.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * file.c
  *
  * File open, close, extend, truncate
--- a/fs/ocfs2/filecheck.c~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/filecheck.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * filecheck.c
  *
  * Code which implements online file check.
--- a/fs/ocfs2/filecheck.h~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/filecheck.h
@@ -1,7 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * filecheck.h
  *
  * Online file check.
--- a/fs/ocfs2/file.h~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/file.h
@@ -1,7 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * file.h
  *
  * Function prototypes
--- a/fs/ocfs2/heartbeat.c~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/heartbeat.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * heartbeat.c
  *
  * Register ourselves with the heartbaet service, keep our node maps
--- a/fs/ocfs2/heartbeat.h~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/heartbeat.h
@@ -1,7 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * heartbeat.h
  *
  * Function prototypes
--- a/fs/ocfs2/inode.c~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/inode.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * inode.c
  *
  * vfs' aops, fops, dops and iops
--- a/fs/ocfs2/inode.h~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/inode.h
@@ -1,7 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * inode.h
  *
  * Function prototypes
--- a/fs/ocfs2/journal.c~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/journal.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * journal.c
  *
  * Defines functions of journalling api
--- a/fs/ocfs2/journal.h~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/journal.h
@@ -1,7 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * journal.h
  *
  * Defines journalling api and structures.
--- a/fs/ocfs2/localalloc.c~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/localalloc.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * localalloc.c
  *
  * Node local data allocation
--- a/fs/ocfs2/localalloc.h~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/localalloc.h
@@ -1,7 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * localalloc.h
  *
  * Function prototypes
--- a/fs/ocfs2/locks.c~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/locks.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * locks.c
  *
  * Userspace file locking support
--- a/fs/ocfs2/locks.h~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/locks.h
@@ -1,7 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * locks.h
  *
  * Function prototypes for Userspace file locking support
--- a/fs/ocfs2/mmap.c~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/mmap.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * mmap.c
  *
  * Code to deal with the mess that is clustered mmap.
--- a/fs/ocfs2/move_extents.c~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/move_extents.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * move_extents.c
  *
  * Copyright (C) 2011 Oracle.  All rights reserved.
--- a/fs/ocfs2/move_extents.h~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/move_extents.h
@@ -1,7 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * move_extents.h
  *
  * Copyright (C) 2011 Oracle.  All rights reserved.
--- a/fs/ocfs2/namei.c~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/namei.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * namei.c
  *
  * Create and rename file, directory, symlinks
--- a/fs/ocfs2/namei.h~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/namei.h
@@ -1,7 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * namei.h
  *
  * Function prototypes
--- a/fs/ocfs2/ocfs1_fs_compat.h~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/ocfs1_fs_compat.h
@@ -1,7 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * ocfs1_fs_compat.h
  *
  * OCFS1 volume header definitions.  OCFS2 creates valid but unmountable
--- a/fs/ocfs2/ocfs2_fs.h~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/ocfs2_fs.h
@@ -1,7 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * ocfs2_fs.h
  *
  * On-disk structures for OCFS2.
--- a/fs/ocfs2/ocfs2.h~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/ocfs2.h
@@ -1,7 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * ocfs2.h
  *
  * Defines macros and structures used in OCFS2
--- a/fs/ocfs2/ocfs2_ioctl.h~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/ocfs2_ioctl.h
@@ -1,7 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * ocfs2_ioctl.h
  *
  * Defines OCFS2 ioctls.
--- a/fs/ocfs2/ocfs2_lockid.h~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/ocfs2_lockid.h
@@ -1,7 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * ocfs2_lockid.h
  *
  * Defines OCFS2 lockid bits.
--- a/fs/ocfs2/ocfs2_lockingver.h~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/ocfs2_lockingver.h
@@ -1,7 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * ocfs2_lockingver.h
  *
  * Defines OCFS2 Locking version values.
--- a/fs/ocfs2/refcounttree.c~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/refcounttree.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * refcounttree.c
  *
  * Copyright (C) 2009 Oracle.  All rights reserved.
--- a/fs/ocfs2/refcounttree.h~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/refcounttree.h
@@ -1,7 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * refcounttree.h
  *
  * Copyright (C) 2009 Oracle.  All rights reserved.
--- a/fs/ocfs2/reservations.c~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/reservations.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * reservations.c
  *
  * Allocation reservations implementation
--- a/fs/ocfs2/reservations.h~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/reservations.h
@@ -1,7 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * reservations.h
  *
  * Allocation reservations function prototypes and structures.
--- a/fs/ocfs2/resize.c~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/resize.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * resize.c
  *
  * volume resize.
--- a/fs/ocfs2/resize.h~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/resize.h
@@ -1,7 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * resize.h
  *
  * Function prototypes
--- a/fs/ocfs2/slot_map.c~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/slot_map.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * slot_map.c
  *
  * Copyright (C) 2002, 2004 Oracle.  All rights reserved.
--- a/fs/ocfs2/slot_map.h~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/slot_map.h
@@ -1,7 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * slotmap.h
  *
  * description here
--- a/fs/ocfs2/stackglue.c~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/stackglue.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * stackglue.c
  *
  * Code which implements an OCFS2 specific interface to underlying
--- a/fs/ocfs2/stackglue.h~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/stackglue.h
@@ -1,7 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * stackglue.h
  *
  * Glue to the underlying cluster stack.
--- a/fs/ocfs2/stack_o2cb.c~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/stack_o2cb.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * stack_o2cb.c
  *
  * Code which interfaces ocfs2 with the o2cb stack.
--- a/fs/ocfs2/stack_user.c~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/stack_user.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * stack_user.c
  *
  * Code which interfaces ocfs2 with fs/dlm and a userspace stack.
--- a/fs/ocfs2/suballoc.c~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/suballoc.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * suballoc.c
  *
  * metadata alloc and free
--- a/fs/ocfs2/suballoc.h~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/suballoc.h
@@ -1,7 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * suballoc.h
  *
  * Defines sub allocator api
--- a/fs/ocfs2/super.c~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/super.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * super.c
  *
  * load/unload driver, mount/dismount volumes
--- a/fs/ocfs2/super.h~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/super.h
@@ -1,7 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * super.h
  *
  * Function prototypes
--- a/fs/ocfs2/symlink.c~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/symlink.c
@@ -1,6 +1,4 @@
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  *  linux/cluster/ssi/cfs/symlink.c
  *
  *	This program is free software; you can redistribute it and/or
--- a/fs/ocfs2/symlink.h~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/symlink.h
@@ -1,7 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * symlink.h
  *
  * Function prototypes
--- a/fs/ocfs2/sysfile.c~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/sysfile.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * sysfile.c
  *
  * Initialize, read, write, etc. system files.
--- a/fs/ocfs2/sysfile.h~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/sysfile.h
@@ -1,7 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * sysfile.h
  *
  * Function prototypes
--- a/fs/ocfs2/uptodate.c~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/uptodate.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * uptodate.c
  *
  * Tracking the up-to-date-ness of a local buffer_head with respect to
--- a/fs/ocfs2/uptodate.h~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/uptodate.h
@@ -1,7 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * uptodate.h
  *
  * Cluster uptodate tracking
--- a/fs/ocfs2/xattr.c~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/xattr.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * xattr.c
  *
  * Copyright (C) 2004, 2008 Oracle.  All rights reserved.
--- a/fs/ocfs2/xattr.h~treewide-remove-editor-modelines-and-cruft
+++ a/fs/ocfs2/xattr.h
@@ -1,7 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * xattr.h
  *
  * Copyright (C) 2004, 2008 Oracle.  All rights reserved.
--- a/fs/reiserfs/procfs.c~treewide-remove-editor-modelines-and-cruft
+++ a/fs/reiserfs/procfs.c
@@ -488,13 +488,3 @@ int reiserfs_proc_info_global_done(void)
  * (available at http://www.namesys.com/legalese.html)
  *
  */
-
-/*
- * Make Linus happy.
- * Local variables:
- * c-indentation-style: "K&R"
- * mode-name: "LC"
- * c-basic-offset: 8
- * tab-width: 8
- * End:
- */
--- a/include/linux/configfs.h~treewide-remove-editor-modelines-and-cruft
+++ a/include/linux/configfs.h
@@ -1,7 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
+/*
  * configfs.h - definitions for the device driver filesystem
  *
  * Based on sysfs:
--- a/include/linux/genl_magic_func.h~treewide-remove-editor-modelines-and-cruft
+++ a/include/linux/genl_magic_func.h
@@ -404,4 +404,3 @@ s_fields								\
 
 /* }}}1 */
 #endif /* GENL_MAGIC_FUNC_H */
-/* vim: set foldmethod=marker foldlevel=1 nofoldenable : */
--- a/include/linux/genl_magic_struct.h~treewide-remove-editor-modelines-and-cruft
+++ a/include/linux/genl_magic_struct.h
@@ -283,4 +283,3 @@ enum {									\
 
 /* }}}1 */
 #endif /* GENL_MAGIC_STRUCT_H */
-/* vim: set foldmethod=marker nofoldenable : */
--- a/include/uapi/linux/if_bonding.h~treewide-remove-editor-modelines-and-cruft
+++ a/include/uapi/linux/if_bonding.h
@@ -153,14 +153,3 @@ enum {
 #define BOND_3AD_STAT_MAX (__BOND_3AD_STAT_MAX - 1)
 
 #endif /* _LINUX_IF_BONDING_H */
-
-/*
- * Local variables:
- *  version-control: t
- *  kept-new-versions: 5
- *  c-indent-level: 8
- *  c-basic-offset: 8
- *  tab-width: 8
- * End:
- */
-
--- a/include/uapi/linux/nfs4.h~treewide-remove-editor-modelines-and-cruft
+++ a/include/uapi/linux/nfs4.h
@@ -178,9 +178,3 @@
 #define NFS4_MAX_BACK_CHANNEL_OPS 2
 
 #endif /* _UAPI_LINUX_NFS4_H */
-
-/*
- * Local variables:
- *  c-basic-offset: 8
- * End:
- */
--- a/include/xen/interface/elfnote.h~treewide-remove-editor-modelines-and-cruft
+++ a/include/xen/interface/elfnote.h
@@ -208,13 +208,3 @@
 #define XEN_ELFNOTE_MAX XEN_ELFNOTE_PHYS32_ENTRY
 
 #endif /* __XEN_PUBLIC_ELFNOTE_H__ */
-
-/*
- * Local variables:
- * mode: C
- * c-set-style: "BSD"
- * c-basic-offset: 4
- * tab-width: 4
- * indent-tabs-mode: nil
- * End:
- */
--- a/include/xen/interface/hvm/hvm_vcpu.h~treewide-remove-editor-modelines-and-cruft
+++ a/include/xen/interface/hvm/hvm_vcpu.h
@@ -131,13 +131,3 @@ struct vcpu_hvm_context {
 typedef struct vcpu_hvm_context vcpu_hvm_context_t;
 
 #endif /* __XEN_PUBLIC_HVM_HVM_VCPU_H__ */
-
-/*
- * Local variables:
- * mode: C
- * c-file-style: "BSD"
- * c-basic-offset: 4
- * tab-width: 4
- * indent-tabs-mode: nil
- * End:
- */
--- a/include/xen/interface/io/xenbus.h~treewide-remove-editor-modelines-and-cruft
+++ a/include/xen/interface/io/xenbus.h
@@ -39,13 +39,3 @@ enum xenbus_state
 };
 
 #endif /* _XEN_PUBLIC_IO_XENBUS_H */
-
-/*
- * Local variables:
- *  c-file-style: "linux"
- *  indent-tabs-mode: t
- *  c-indent-level: 8
- *  c-basic-offset: 8
- *  tab-width: 8
- * End:
- */
--- a/samples/configfs/configfs_sample.c~treewide-remove-editor-modelines-and-cruft
+++ a/samples/configfs/configfs_sample.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
- * vim: noexpandtab ts=8 sts=0 sw=8:
- *
  * configfs_example_macros.c - This file is a demonstration module
  *      containing a number of configfs subsystems.  It uses the helper
  *      macros defined by configfs.h
--- a/tools/usb/hcd-tests.sh~treewide-remove-editor-modelines-and-cruft
+++ a/tools/usb/hcd-tests.sh
@@ -272,5 +272,3 @@ do
 	echo ''
     done
 done
-
-# vim: sw=4
_

Patches currently in -mm which might be from masahiroy@kernel.org are


