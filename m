From: akpm@linux-foundation.org
Subject: + scripts-checkpatchpl-add-warn-on-sizeof.patch added to -mm tree
Date: Tue, 27 Oct 2009 12:29:00 -0700
Message-ID: <200910271929.n9RJT0nx029322@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34028 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756628AbZJ0T3I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Oct 2009 15:29:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, apw@shadowen.org


The patch titled
     scripts/checkpatch.pl: add WARN on sizeof(&foo)
has been added to the -mm tree.  Its filename is
     scripts-checkpatchpl-add-warn-on-sizeof.patch

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
Subject: scripts/checkpatch.pl: add WARN on sizeof(&foo)
=46rom: Joe Perches <joe@perches.com>

sizeof(&foo) is frequently an error.  Warn on its use.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN scripts/checkpatch.pl~scripts-checkpatchpl-add-warn-on-sizeof=
 scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~scripts-checkpatchpl-add-warn-on-sizeof
+++ a/scripts/checkpatch.pl
@@ -2580,6 +2580,11 @@ sub process {
 			WARN("plain inline is preferred over $1\n" . $herecurr);
 		}
=20
+# check for sizeof(&)
+		if ($line =3D~ /\bsizeof\s*\(\s*\&/) {
+			WARN("sizeof(& should be avoided\n" . $herecurr);
+		}
+
 # check for new externs in .c files.
 		if ($realfile =3D~ /\.c$/ && defined $stat &&
 		    $stat =3D~ /^.\s*(?:extern\s+)?$Type\s+($Ident)(\s*)\(/s)
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
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
linux-next.patch
checkpatchpl-allow-80-char-lines-for-logging-functions-not-just-printk.=
patch
dynamic_debugh-kernelh-remove-kbuild_modname-from-dynamic_pr_debug.patc=
h
kernelh-remove-initialization-of-bool-in-printk_once.patch
lib-vsprintfc-add-%pu-to-print-uuid-guids.patch
fs-xfs-xfs_log_recoverc-use-%pu-to-print-uuids.patch
randomc-use-%pu-to-print-uuids.patch
drivers-firmware-dmi_scanc-use-%pub-to-print-uuids.patch
drivers-md-mdc-use-%pu-to-print-uuids.patch
fs-gfs2-sysc-use-%pub-to-print-uuids.patch
fs-ubifs-use-%pub-to-print-uuids.patch
efih-use-%pul-to-print-uuids.patch
drivers-media-video-uvc-use-%pul-to-print-uuids.patch
lib-unified-uuid-guid-definition.patch
gfs2-use-unified-uuid-guid-code.patch
scripts-checkpatchpl-add-warn-on-sizeof.patch
isicomc-use-pr_fmt-and-pr_level.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
