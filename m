From: akpm@linux-foundation.org
Subject: [merged] drivers-scsi-remove-uses-of-nipquad-use-%pi4.patch removed from -mm tree
Date: Thu, 18 Feb 2010 12:46:02 -0800
Message-ID: <201002182046.o1IKk2HV002782@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50018 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755850Ab0BRUrD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Feb 2010 15:47:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, James.Bottomley@suse.de, anilgv@broadcom.com, michaelc@cs.wisc.edu, mm-commits@vger.kernel.org


The patch titled
     drivers/scsi: remove uses of NIPQUAD, use %pI4
has been removed from the -mm tree.  Its filename was
     drivers-scsi-remove-uses-of-nipquad-use-%pi4.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/scsi: remove uses of NIPQUAD, use %pI4
From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Cc: James E.J. Bottomley <James.Bottomley@suse.de>
Cc: Anil Veerabhadrappa <anilgv@broadcom.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/bnx2i/bnx2i_iscsi.c     |    4 ++--
 drivers/scsi/cxgb3i/cxgb3i_iscsi.c   |    5 ++---
 drivers/scsi/cxgb3i/cxgb3i_offload.c |    7 ++++---
 3 files changed, 8 insertions(+), 8 deletions(-)

diff -puN drivers/scsi/bnx2i/bnx2i_iscsi.c~drivers-scsi-remove-uses-of-nipquad-use-%pi4 drivers/scsi/bnx2i/bnx2i_iscsi.c
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c~drivers-scsi-remove-uses-of-nipquad-use-%pi4
+++ a/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -1426,8 +1426,8 @@ static int bnx2i_conn_get_param(struct i
 		break;
 	case ISCSI_PARAM_CONN_ADDRESS:
 		if (bnx2i_conn->ep)
-			len = sprintf(buf, NIPQUAD_FMT "\n",
-				      NIPQUAD(bnx2i_conn->ep->cm_sk->dst_ip));
+			len = sprintf(buf, "%pI4\n",
+				      &bnx2i_conn->ep->cm_sk->dst_ip);
 		break;
 	default:
 		return iscsi_conn_get_param(cls_conn, param, buf);
diff -puN drivers/scsi/cxgb3i/cxgb3i_iscsi.c~drivers-scsi-remove-uses-of-nipquad-use-%pi4 drivers/scsi/cxgb3i/cxgb3i_iscsi.c
--- a/drivers/scsi/cxgb3i/cxgb3i_iscsi.c~drivers-scsi-remove-uses-of-nipquad-use-%pi4
+++ a/drivers/scsi/cxgb3i/cxgb3i_iscsi.c
@@ -591,8 +591,7 @@ static int cxgb3i_conn_bind(struct iscsi
 	cxgb3i_conn_max_recv_dlength(conn);
 
 	spin_lock_bh(&conn->session->lock);
-	sprintf(conn->portal_address, NIPQUAD_FMT,
-		NIPQUAD(c3cn->daddr.sin_addr.s_addr));
+	sprintf(conn->portal_address, "%pI4", &c3cn->daddr.sin_addr.s_addr);
 	conn->portal_port = ntohs(c3cn->daddr.sin_port);
 	spin_unlock_bh(&conn->session->lock);
 
@@ -753,7 +752,7 @@ static int cxgb3i_host_get_param(struct 
 		__be32 addr;
 
 		addr = cxgb3i_get_private_ipv4addr(hba->ndev);
-		len = sprintf(buf, NIPQUAD_FMT, NIPQUAD(addr));
+		len = sprintf(buf, "%pI4", &addr);
 		break;
 	}
 	default:
diff -puN drivers/scsi/cxgb3i/cxgb3i_offload.c~drivers-scsi-remove-uses-of-nipquad-use-%pi4 drivers/scsi/cxgb3i/cxgb3i_offload.c
--- a/drivers/scsi/cxgb3i/cxgb3i_offload.c~drivers-scsi-remove-uses-of-nipquad-use-%pi4
+++ a/drivers/scsi/cxgb3i/cxgb3i_offload.c
@@ -1675,10 +1675,11 @@ int cxgb3i_c3cn_connect(struct net_devic
 	} else
 		c3cn->saddr.sin_addr.s_addr = sipv4;
 
-	c3cn_conn_debug("c3cn 0x%p, %u.%u.%u.%u,%u-%u.%u.%u.%u,%u SYN_SENT.\n",
-			c3cn, NIPQUAD(c3cn->saddr.sin_addr.s_addr),
+	c3cn_conn_debug("c3cn 0x%p, %pI4,%u-%pI4,%u SYN_SENT.\n",
+			c3cn,
+			&c3cn->saddr.sin_addr.s_addr,
 			ntohs(c3cn->saddr.sin_port),
-			NIPQUAD(c3cn->daddr.sin_addr.s_addr),
+			&c3cn->daddr.sin_addr.s_addr,
 			ntohs(c3cn->daddr.sin_port));
 
 	c3cn_set_state(c3cn, C3CN_STATE_CONNECTING);
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
drivers-gpu-drm-i915-intel_biosc-fix-continuation-line-formats.patch
net-sunrpc-remove-uses-of-nipquad-use-%pi4.patch
fs-ocfs2-cluster-tcpc-remove-use-of-nipquad-use-%pi4.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-firmware-iscsi_ibftc-remove-nipquad_fmt-use-%pi4.patch
drivers-scsi-qla2xxx-qla_osc-fix-continuation-line-formats.patch
drivers-staging-fix-continuation-line-formats.patch
drivers-block-floppyc-convert-some-include-asm-to-include-linux.patch
drivers-block-floppyc-define-space-and-column-neatening.patch
drivers-block-floppyc-use-pr_level.patch
drivers-block-floppyc-remove-unnecessary-braces.patch
drivers-block-floppyc-remove-used-once-check_ready-macro.patch
drivers-block-floppyc-hoist-assigns-from-ifs-neatening.patch
drivers-block-floppyc-remove-last_out-macro.patch
drivers-block-floppyc-comment-neatening-and-remove-naked.patch
drivers-block-floppyc-remove-clearstruct-macro-use-memset.patch
drivers-block-floppyc-indent-a-comment.patch
drivers-block-floppyc-remove-in-out-macros-indent-switch-case.patch
drivers-block-floppyc-remove-a-few-spaces-from-function-casts.patch
drivers-block-floppyc-remove-macro-lock_fdc.patch
drivers-block-floppyc-add-debug_dcl-macro.patch
drivers-block-floppyc-remove-clearf-setf-and-testf-macros.patch
drivers-block-floppyc-remove-most-uses-of-call-and-ecall-macros.patch
drivers-block-floppyc-remove-copyin-copyout-and-ecall-macros.patch
drivers-block-floppyc-remove-macros-call-wait-and-iwait.patch
drivers-block-floppyc-convert-int-1-0-to-bool-true-false.patch
drivers-block-floppyc-move-leading-and-to-preceding-line.patch
drivers-block-floppyc-remove-define-device_name-floppy.patch
drivers-block-floppyc-convert-int-initialising-to-bool-initialized.patch
drivers-block-floppyc-add-function-is_ready_state.patch
drivers-block-floppyc-remove-unnecessary-return-and-braces.patch
drivers-block-floppyc-remove-repeat-macro.patch
drivers-block-floppyc-unclutter-redo_fd_request-logic.patch
drivers-block-floppyc-remove-unnecessary-argument-from-reschedule_timeout.patch
drivers-block-floppyc-remove-define-floppy_sanity_check.patch
drivers-block-floppyc-dprint-neatening.patch
drivers-block-floppyc-use-__func__-where-appropriate.patch
drivers-block-floppyc-use-%pf-in-logging-messages.patch
drivers-block-floppyc-remove-some-unnecessary-casting.patch
drivers-block-floppyc-convert-raw_cmd_copyin-from-while1-to-label-goto.patch
drivers-block-floppyc-add-__func__-to-debugt.patch
drivers-block-floppyc-remove-obfuscating-code2size-macro.patch
drivers-block-floppyc-remove-misleading-used-once-fd_ioctl_allowed-macro.patch
drivers-block-floppyc-remove-unnecessary-casting-in-fd_ioctl.patch
scripts-get_maintainerpl-add-file-emails-find-embedded-email-addresses.patch
scripts-get_maintainerpl-add-file-emails-find-embedded-email-addresses-v2.patch
scripts-get_maintainerpl-add-sections-print-entire-matched-subsystem.patch
scripts-get_maintainerpl-change-sections-to-print-in-the-same-style-as-maintainers.patch
scripts-get_maintainerpl-add-ability-to-read-from-stdin.patch
maintainers-remove-amd-geode-f-arch-x86-kernel-geode_32c.patch
maintainers-remove-hayes-esp-serial-driver.patch
maintainers-update-performance-events-f-patterns.patch
maintainers-starmode-radio-ip-strip-moved-to-staging.patch
maintainers-wavelan-moved-to-staging.patch
maintainers-document-and-add-q-patchwork-queue-entries.patch
lib-stringc-simplify-stricmp.patch
lib-stringc-simplify-strnstr.patch
scripts-checkpatchpl-add-warn-on-sizeof.patch
checkpatchpl-allow-80-char-lines-for-logging-functions-not-just-printk.patch
checkpatch-warn-on-unnecessary-spaces-before-quoted-newlines.patch
drivers-hwmon-vt8231c-fix-continuation-line-formats.patch
drivers-video-via-fix-continuation-line-formats.patch

