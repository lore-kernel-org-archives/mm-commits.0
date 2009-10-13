From: akpm@linux-foundation.org
Subject: + randomc-use-%pu-to-print-uuids.patch added to -mm tree
Date: Tue, 13 Oct 2009 14:50:02 -0700
Message-ID: <200910132150.n9DLo2KY026049@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50411 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753383AbZJMVuu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Oct 2009 17:50:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, mpm@selenic.com


The patch titled
     random.c: use %pU to print UUIDs
has been added to the -mm tree.  Its filename is
     randomc-use-%pu-to-print-uuids.patch

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
Subject: random.c: use %pU to print UUIDs
=46rom: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Matt Mackall <mpm@selenic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/char/random.c~randomc-use-%pu-to-print-uuids drivers/=
char/random.c
--- a/drivers/char/random.c~randomc-use-%pu-to-print-uuids
+++ a/drivers/char/random.c
@@ -1245,12 +1245,8 @@ static int proc_do_uuid(ctl_table *table
 	if (uuid[8] =3D=3D 0)
 		generate_random_uuid(uuid);
=20
-	sprintf(buf, "%02x%02x%02x%02x-%02x%02x-%02x%02x-%02x%02x-"
-		"%02x%02x%02x%02x%02x%02x",
-		uuid[0],  uuid[1],  uuid[2],  uuid[3],
-		uuid[4],  uuid[5],  uuid[6],  uuid[7],
-		uuid[8],  uuid[9],  uuid[10], uuid[11],
-		uuid[12], uuid[13], uuid[14], uuid[15]);
+	sprintf(buf, "%pU", uuid);
+
 	fake_table.data =3D buf;
 	fake_table.maxlen =3D sizeof(buf);
=20
@@ -1350,7 +1346,7 @@ ctl_table random_table[] =3D {
=20
 /********************************************************************
  *
- * Random funtions for networking
+ * Random functions for networking
  *
  ********************************************************************/
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
