From: akpm@linux-foundation.org
Subject: + dccp-fix-memory-leak-and-clean-up-style-dccp_feat_empty_confirm.patch added to -mm tree
Date: Sat, 28 Jul 2007 23:45:23 -0700
Message-ID: <200707290645.l6T6jNHF012223@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34381 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759719AbXG2Gps (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Jul 2007 02:45:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jesper.juhl@gmail.com, ian.mcdonald@jandi.co.nz


The patch titled
     dccp: fix memory leak and clean up style - dccp_feat_empty_confirm()
has been added to the -mm tree.  Its filename is
     dccp-fix-memory-leak-and-clean-up-style-dccp_feat_empty_confirm.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: dccp: fix memory leak and clean up style - dccp_feat_empty_confirm()
From: Jesper Juhl <jesper.juhl@gmail.com>

There's a memory leak in net/dccp/feat.c::dccp_feat_empty_confirm().  If we
hit the 'default:' case of the 'switch' statement, then we return without
freeing 'opt', thus leaking 'struct dccp_opt_pend' bytes.

The leak is fixed easily enough by adding a kfree(opt); before the return
statement.

The patch also changes the layout of the 'switch' to be more in line with
CodingStyle.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Acked-by: Ian McDonald <ian.mcdonald@jandi.co.nz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/dccp/feat.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff -puN net/dccp/feat.c~dccp-fix-memory-leak-and-clean-up-style-dccp_feat_empty_confirm net/dccp/feat.c
--- a/net/dccp/feat.c~dccp-fix-memory-leak-and-clean-up-style-dccp_feat_empty_confirm
+++ a/net/dccp/feat.c
@@ -327,10 +327,16 @@ static void dccp_feat_empty_confirm(stru
 	}
 
 	switch (type) {
-	case DCCPO_CHANGE_L: opt->dccpop_type = DCCPO_CONFIRM_R; break;
-	case DCCPO_CHANGE_R: opt->dccpop_type = DCCPO_CONFIRM_L; break;
-	default:	     DCCP_WARN("invalid type %d\n", type); return;
-
+	case DCCPO_CHANGE_L:
+		opt->dccpop_type = DCCPO_CONFIRM_R;
+		break;
+	case DCCPO_CHANGE_R:
+		opt->dccpop_type = DCCPO_CONFIRM_L;
+		break;
+	default:
+		DCCP_WARN("invalid type %d\n", type);
+		kfree(opt);
+		return;
 	}
 	opt->dccpop_feat = feature;
 	opt->dccpop_val	 = NULL;
_

Patches currently in -mm which might be from jesper.juhl@gmail.com are

origin.patch
various-doc-kernel-parameters-fixes.patch
git-alsa.patch
fix-use-after-free--double-free-bug-in-amd_create_gatt_pages--amd_free_gatt_pages.patch
git-dvb.patch
git-hwmon.patch
git-gfs2-nmw.patch
hid-fix-a-null-pointer-dereference-when-we-fail-to-allocate-memory.patch
clean-up-duplicate-includes-in-drivers-input.patch
git-mtd.patch
clean-up-duplicate-includes-in-drivers-net.patch
clean-up-duplicate-includes-in-drivers-atm.patch
clean-up-duplicate-includes-in-net-atm.patch
clean-up-duplicate-includes-in-net-ipv4.patch
clean-up-duplicate-includes-in-net-ipv6.patch
clean-up-duplicate-includes-in-net-sched.patch
clean-up-duplicate-includes-in-net-sunrpc.patch
clean-up-duplicate-includes-in-net-tipc.patch
clean-up-duplicate-includes-in-net-xfrm.patch
dccp-fix-memory-leak-and-clean-up-style-dccp_feat_empty_confirm.patch
clean-up-duplicate-includes-in-include-linux-nfs_fsh.patch
clean-up-duplicate-includes-in-fs-ntfs.patch
git-scsi-rc-fixes.patch
clean-up-duplicate-includes-in-drivers-scsi.patch
clean-up-duplicate-includes-in-drivers-block.patch
clean-up-duplicate-includes-in-drivers-usb.patch
clean-up-duplicate-includes-in-arch-i386-xen.patch
clean-up-duplicate-includes-in-include-linux-memory_hotplugh.patch
clean-up-duplicate-includes-in-mm.patch
ipmi-fix-mem-leak-in-try_init_dmi.patch
fix-a-use-after-free-bug-in-kernel-userspace-relay-file-support.patch
clean-up-duplicate-includes-in-drivers-char.patch
clean-up-duplicate-includes-in-drivers-w1.patch
clean-up-duplicate-includes-in-fs.patch
clean-up-duplicate-includes-in-fs-ecryptfs.patch
clean-up-duplicate-includes-in-kernel.patch
cciss-fix-memory-leak.patch
clean-up-duplicate-includes-in-drivers-spi.patch
floppy-do-a-very-minimal-style-cleanup-of-the-floppy-driver.patch
floppy-remove-dead-commented-out-code-from-floppy-driver.patch
floppy-remove-register-keyword-use-from-floppy-driver.patch
clean-up-duplicate-includes-in-documentation.patch
