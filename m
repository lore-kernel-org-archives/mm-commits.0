From: akpm@linux-foundation.org
Subject: + efih-use-%pul-to-print-uuids.patch added to -mm tree
Date: Tue, 13 Oct 2009 14:50:27 -0700
Message-ID: <200910132150.n9DLoRuN027003@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35156 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934346AbZJMVwE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Oct 2009 17:52:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, jgarzik@redhat.com, tj@kernel.org


The patch titled
     efi.h: use %pUl to print UUIDs
has been added to the -mm tree.  Its filename is
     efih-use-%pul-to-print-uuids.patch

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
Subject: efi.h: use %pUl to print UUIDs
=46rom: Joe Perches <joe@perches.com>

Shrinks vmlinux

without:
$ size vmlinux
   text    data     bss     dec     hex filename
6975863  679652 1359668 9015183  898f8f vmlinux

with:
$ size vmlinux
   text    data     bss     dec     hex filename
6975639 679652 1359668 9014959 898eaf vmlinux

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Jeff Garzik <jgarzik@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN include/linux/efi.h~efih-use-%pul-to-print-uuids include/linu=
x/efi.h
--- a/include/linux/efi.h~efih-use-%pul-to-print-uuids
+++ a/include/linux/efi.h
@@ -280,11 +280,7 @@ efi_guidcmp (efi_guid_t left, efi_guid_t
 static inline char *
 efi_guid_unparse(efi_guid_t *guid, char *out)
 {
-	sprintf(out, "%02x%02x%02x%02x-%02x%02x-%02x%02x-%02x%02x-%02x%02x%02=
x%02x%02x%02x",
-		guid->b[3], guid->b[2], guid->b[1], guid->b[0],
-		guid->b[5], guid->b[4], guid->b[7], guid->b[6],
-		guid->b[8], guid->b[9], guid->b[10], guid->b[11],
-		guid->b[12], guid->b[13], guid->b[14], guid->b[15]);
+	sprintf(out, "%pUl", guid->b);
         return out;
 }
=20
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
