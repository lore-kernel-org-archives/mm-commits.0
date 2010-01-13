From: akpm@linux-foundation.org
Subject: + drivers-scsi-remove-uses-of-nipquad-use-%pi4.patch added to -mm tree
Date: Wed, 13 Jan 2010 12:54:27 -0800
Message-ID: <201001132054.o0DKsS8n027867@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57158 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755256Ab0AMUyo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Jan 2010 15:54:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, James.Bottomley@suse.de, anilgv@broadcom.com, michaelc@cs.wisc.edu


The patch titled
     drivers/scsi: remove uses of NIPQUAD, use %pI4
has been added to the -mm tree.  Its filename is
     drivers-scsi-remove-uses-of-nipquad-use-%pi4.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
scripts-get_maintainerpl-add-file-emails-find-embedded-email-addresses.patch
scripts-checkpatchpl-add-warn-on-sizeof.patch
checkpatchpl-allow-80-char-lines-for-logging-functions-not-just-printk.patch
drivers-scsi-remove-uses-of-nipquad-use-%pi4.patch
drivers-staging-pohmelfs-inodec-remove-uses-of-nipquad-use-%pi4.patch
net-rds-remove-uses-of-nipquad-use-%pi4.patch
net-sunrpc-remove-uses-of-nipquad-use-%pi4.patch
fs-ocfs2-cluster-tcpc-remove-use-of-nipquad-use-%pi4.patch
drivers-firmware-iscsi_ibftc-remove-nipquad_fmt-use-%pi4.patch

