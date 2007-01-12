From: akpm@osdl.org
Subject: + git-acpi-early-acpi-lockup.patch added to -mm tree
Date: Fri, 12 Jan 2007 12:47:41 -0800
Message-ID: <200701122047.l0CKlfDt028477@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60640 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030311AbXALUs5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Jan 2007 15:48:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: deweerdt@free.fr, lenb@kernel.org


The patch titled
     git-acpi: Early ACPI lockup
has been added to the -mm tree.  Its filename is
     git-acpi-early-acpi-lockup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: git-acpi: Early ACPI lockup
From: Frederik Deweerdt <deweerdt@free.fr>

The git-acpi.patch replaces earlier "if(!handler) return -EINVAL" by
"BUG_ON(!handler)". This locks my machine early at boot with a message
along the lines of (It's hand copied):
Int 6: cr2: 00000000 eip: c0570e05 flags: 00010046 cs: 60
stack: c054ffac c011db2b c04936d0 c054ff68 c054ffc0 c054fff4 c057da2c

Reverting the change as follows, allows booting:

Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/acpi/tables.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/acpi/tables.c~git-acpi-early-acpi-lockup drivers/acpi/tables.c
--- a/drivers/acpi/tables.c~git-acpi-early-acpi-lockup
+++ a/drivers/acpi/tables.c
@@ -415,7 +415,9 @@ int __init acpi_table_parse(enum acpi_ta
 	unsigned int index;
 	unsigned int count = 0;
 
-	BUG_ON(!handler);
+	if (!handler)
+		return -EINVAL;
+	/*BUG_ON(!handler);*/
 
 	for (i = 0; i < sdt_count; i++) {
 		if (sdt_entry[i].id != id)
_

Patches currently in -mm which might be from deweerdt@free.fr are

git-acpi-early-acpi-lockup.patch
fix2-gregkh-driver-driver-core-fix-race-in-sysfs-between-sysfs_remove_file-and-read-write.patch
disable-init-initramfsc-updated-fix.patch
user-ns-prepare-copy_tree-copy_mnt-and-their-callers-to-handle-errs-fix.patch
user-ns-implement-user-ns-unshare.patch
reiser4-sb_sync_inodes-fix.patch
