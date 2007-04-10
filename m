From: akpm@linux-foundation.org
Subject: + add-spaces-on-either-side-of-case-operator.patch added to -mm tree
Date: Tue, 10 Apr 2007 15:04:58 -0700
Message-ID: <200704102204.l3AM4w4u018771@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48612 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965148AbXDJWFC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Apr 2007 18:05:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@mindspring.com, viro@zeniv.linux.org.uk


The patch titled
     audit: add spaces on either side of case "..." operator.
has been added to the -mm tree.  Its filename is
     add-spaces-on-either-side-of-case-operator.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: audit: add spaces on either side of case "..." operator.
From: "Robert P. J. Day" <rpjday@mindspring.com>

Following the programming advice laid down in the gcc manual, make
sure the case "..." operator has spaces on either side.

According to:

http://gcc.gnu.org/onlinedocs/gcc-4.1.2/gcc/Case-Ranges.html#Case-Ranges:

  "Be careful: Write spaces around the ..., for otherwise it may be
parsed wrong when you use it with integer values."

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/audit.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff -puN kernel/audit.c~add-spaces-on-either-side-of-case-operator kernel/audit.c
--- a/kernel/audit.c~add-spaces-on-either-side-of-case-operator
+++ a/kernel/audit.c
@@ -515,8 +515,8 @@ static int audit_netlink_ok(struct sk_bu
 			err = -EPERM;
 		break;
 	case AUDIT_USER:
-	case AUDIT_FIRST_USER_MSG...AUDIT_LAST_USER_MSG:
-	case AUDIT_FIRST_USER_MSG2...AUDIT_LAST_USER_MSG2:
+	case AUDIT_FIRST_USER_MSG ... AUDIT_LAST_USER_MSG:
+	case AUDIT_FIRST_USER_MSG2 ... AUDIT_LAST_USER_MSG2:
 		if (security_netlink_recv(skb, CAP_AUDIT_WRITE))
 			err = -EPERM;
 		break;
@@ -614,8 +614,8 @@ static int audit_receive_msg(struct sk_b
 							loginuid, sid);
 		break;
 	case AUDIT_USER:
-	case AUDIT_FIRST_USER_MSG...AUDIT_LAST_USER_MSG:
-	case AUDIT_FIRST_USER_MSG2...AUDIT_LAST_USER_MSG2:
+	case AUDIT_FIRST_USER_MSG ... AUDIT_LAST_USER_MSG:
+	case AUDIT_FIRST_USER_MSG2 ... AUDIT_LAST_USER_MSG2:
 		if (!audit_enabled && msg_type != AUDIT_USER_AVC)
 			return 0;
 
_

Patches currently in -mm which might be from rpjday@mindspring.com are

git-alsa.patch
remove-unused-header-file-arch-arm-mach-s3c2410-basth.patch
git-powerpc.patch
remove-unused-header-file-arch-ppc-syslib-cpc710h.patch
remove-unused-header-file-arch-powerpc-platforms-83xx-mpc834x_itxh.patch
git-drm.patch
git-input.patch
git-mtd.patch
git-netdev-all.patch
delete-unused-header-file-linux-sdla_frh.patch
delete-unused-header-file-linux-if_wanpipe_commonh.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
git-scsi-misc.patch
scsi-fix-obvious-typo-spin_lock_irqrestore-in-gdthc.patch
remove-unused-header-file-arch-m68k-atari-atasoundh.patch
remove-unused-header-file-drivers-serial-crisv10h.patch
cris-remove-code-related-to-pre-22-kernel.patch
remove-unused-header-file-arch-um-kernel-tt-include-mode_kern-tth.patch
reiserfs-correct-misspelled-reiserfs_proc_info-to.patch
kconfig-centralize-the-selection-of-semaphore-debugging.patch
rocket-remove-modversions-include.patch
remove-unused-header-file-drivers-message-i2o-i2o_lanh.patch
remove-unused-header-file-drivers-char-digih.patch
delete-unused-header-file-math-emu-extendedh.patch
delete-unused-header-file-linux-awe_voiceh.patch
add-spaces-on-either-side-of-case-operator.patch
some-grammatical-fixups-and-additions-to-atomich-kernel-doc.patch
remove-unused-header-file-drivers-video-riva-nv4refh.patch
