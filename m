From: akpm@linux-foundation.org
Subject: + fs-ubifs-use-%pub-to-print-uuids.patch added to -mm tree
Date: Tue, 13 Oct 2009 14:50:12 -0700
Message-ID: <200910132150.n9DLoC7p026413@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37106 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934313AbZJMVvC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Oct 2009 17:51:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, adrian.hunter@nokia.com, dedekind@infradead.org


The patch titled
     fs/ubifs: use %pUB to print UUIDs
has been added to the -mm tree.  Its filename is
     fs-ubifs-use-%pub-to-print-uuids.patch

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
Subject: fs/ubifs: use %pUB to print UUIDs
=46rom: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Artem Bityutskiy <dedekind@infradead.org>
Cc: Adrian Hunter <adrian.hunter@nokia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN fs/ubifs/debug.c~fs-ubifs-use-%pub-to-print-uuids fs/ubifs/de=
bug.c
--- a/fs/ubifs/debug.c~fs-ubifs-use-%pub-to-print-uuids
+++ a/fs/ubifs/debug.c
@@ -350,13 +350,8 @@ void dbg_dump_node(const struct ubifs_in
 		       le32_to_cpu(sup->fmt_version));
 		printk(KERN_DEBUG "\ttime_gran      %u\n",
 		       le32_to_cpu(sup->time_gran));
-		printk(KERN_DEBUG "\tUUID           %02X%02X%02X%02X-%02X%02X"
-		       "-%02X%02X-%02X%02X-%02X%02X%02X%02X%02X%02X\n",
-		       sup->uuid[0], sup->uuid[1], sup->uuid[2], sup->uuid[3],
-		       sup->uuid[4], sup->uuid[5], sup->uuid[6], sup->uuid[7],
-		       sup->uuid[8], sup->uuid[9], sup->uuid[10], sup->uuid[11],
-		       sup->uuid[12], sup->uuid[13], sup->uuid[14],
-		       sup->uuid[15]);
+		printk(KERN_DEBUG "\tUUID           %pUB\n",
+		       sup->uuid);
 		break;
 	}
 	case UBIFS_MST_NODE:
diff -puN fs/ubifs/super.c~fs-ubifs-use-%pub-to-print-uuids fs/ubifs/su=
per.c
--- a/fs/ubifs/super.c~fs-ubifs-use-%pub-to-print-uuids
+++ a/fs/ubifs/super.c
@@ -1393,12 +1393,7 @@ static int mount_ubifs(struct ubifs_info
 		c->leb_size, c->leb_size >> 10);
 	dbg_msg("data journal heads:  %d",
 		c->jhead_cnt - NONDATA_JHEADS_CNT);
-	dbg_msg("UUID:                %02X%02X%02X%02X-%02X%02X"
-	       "-%02X%02X-%02X%02X-%02X%02X%02X%02X%02X%02X",
-	       c->uuid[0], c->uuid[1], c->uuid[2], c->uuid[3],
-	       c->uuid[4], c->uuid[5], c->uuid[6], c->uuid[7],
-	       c->uuid[8], c->uuid[9], c->uuid[10], c->uuid[11],
-	       c->uuid[12], c->uuid[13], c->uuid[14], c->uuid[15]);
+	dbg_msg("UUID:                %pUB", c->uuid);
 	dbg_msg("big_lpt              %d", c->big_lpt);
 	dbg_msg("log LEBs:            %d (%d - %d)",
 		c->log_lebs, UBIFS_LOG_LNUM, c->log_last);
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
