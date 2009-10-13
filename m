From: akpm@linux-foundation.org
Subject: + fs-xfs-xfs_log_recoverc-use-%pu-to-print-uuids.patch added to -mm tree
Date: Tue, 13 Oct 2009 14:50:14 -0700
Message-ID: <200910132150.n9DLoEVZ026454@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54577 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934302AbZJMVvC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Oct 2009 17:51:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, aelder@sgi.com, hch@lst.de


The patch titled
     fs/xfs/xfs_log_recover.c: use %pU to print UUIDs
has been added to the -mm tree.  Its filename is
     fs-xfs-xfs_log_recoverc-use-%pu-to-print-uuids.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: fs/xfs/xfs_log_recover.c: use %pU to print UUIDs
=46rom: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Alex Elder <aelder@sgi.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN fs/xfs/xfs_log_recover.c~fs-xfs-xfs_log_recoverc-use-%pu-to-p=
rint-uuids fs/xfs/xfs_log_recover.c
--- a/fs/xfs/xfs_log_recover.c~fs-xfs-xfs_log_recoverc-use-%pu-to-print=
-uuids
+++ a/fs/xfs/xfs_log_recover.c
@@ -225,16 +225,10 @@ xlog_header_check_dump(
 	xfs_mount_t		*mp,
 	xlog_rec_header_t	*head)
 {
-	int			b;
-
-	cmn_err(CE_DEBUG, "%s:  SB : uuid =3D ", __func__);
-	for (b =3D 0; b < 16; b++)
-		cmn_err(CE_DEBUG, "%02x", ((__uint8_t *)&mp->m_sb.sb_uuid)[b]);
-	cmn_err(CE_DEBUG, ", fmt =3D %d\n", XLOG_FMT);
-	cmn_err(CE_DEBUG, "    log : uuid =3D ");
-	for (b =3D 0; b < 16; b++)
-		cmn_err(CE_DEBUG, "%02x", ((__uint8_t *)&head->h_fs_uuid)[b]);
-	cmn_err(CE_DEBUG, ", fmt =3D %d\n", be32_to_cpu(head->h_fmt));
+	cmn_err(CE_DEBUG, "%s:  SB : uuid =3D %pU, fmt =3D %d\n",
+		__func__, &mp->m_sb.sb_uuid, XLOG_FMT);
+	cmn_err(CE_DEBUG, "    log : uuid =3D %pU, fmt =3D %d\n",
+		&head->h_fs_uuid, be32_to_cpu(head->h_fmt));
 }
 #else
 #define xlog_header_check_dump(mp, head)
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
maintainers-update-generic-uio-for-pci-devices.patch
maintainers-update-tracing-section.patch
maintainers-update-omap-tony-lindgren-email-name.patch
maintainers-change-atm-mailing-list-to-moderated.patch
maintainers-use-tab-not-spaces-after-field-types.patch
maintainers-update-kernel-janitors-after-mismerge.patch
maintainers-update-score-architecture-name-style-and-add-file-pattern.p=
atch
maintainers-simple-firmware-interface-update-email-style.patch
maintainers-winbond-cir-integrate-p-m-lines-fixup-david-h=E4rdemans-nam=
e.patch
maintainers-fix-up-peripheral-spelling.patch
maintainers-update-wolfson-microelectronics.patch
scripts-get_maintainerpl-add-patch-file-search-for-keywords.patch
maintainers-document-new-k-entry-type.patch
maintainers-add-open-firmware-flattened-device-tree-entry.patch
dynamic_debugh-kernelh-remove-kbuild_modname-from-dynamic_pr_debug.patc=
h
lib-vsprintfc-add-%pu-to-print-uuid-guids.patch
randomc-use-%pu-to-print-uuids.patch
drivers-firmware-dmi_scanc-use-%pub-to-print-uuids.patch
drivers-md-mdc-use-%pu-to-print-uuids.patch
drivers-media-video-uvc-use-%pul-to-print-uuids.patch
fs-gfs2-sysc-use-%pub-to-print-uuids.patch
fs-ubifs-use-%pub-to-print-uuids.patch
fs-xfs-xfs_log_recoverc-use-%pu-to-print-uuids.patch
efih-use-%pul-to-print-uuids.patch
isicomc-use-pr_fmt-and-pr_level.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
