From: akpm@linux-foundation.org
Subject: + ieee1394_core-printk-format.patch added to -mm tree
Date: Tue, 03 Apr 2007 13:33:54 -0700
Message-ID: <200704032033.l33KXsbG002560@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42505 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945920AbXDCUeR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 3 Apr 2007 16:34:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, stefanr@s5r6.in-berlin.de


The patch titled
     ieee1394_core printk format
has been added to the -mm tree.  Its filename is
     ieee1394_core-printk-format.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ieee1394_core printk format
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix printk format string:
drivers/ieee1394/ieee1394_core.c:702: warning: format '%d' expects type 'int', but argument 2 has type 'size_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ieee1394/ieee1394_core.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/ieee1394/ieee1394_core.c~ieee1394_core-printk-format drivers/ieee1394/ieee1394_core.c
--- a/drivers/ieee1394/ieee1394_core.c~ieee1394_core-printk-format
+++ a/drivers/ieee1394/ieee1394_core.c
@@ -699,7 +699,7 @@ static size_t packet_size_to_data_size(s
 		ret = buffer_size;
 
 	if (unlikely(ret + header_size != packet_size))
-		HPSB_ERR("unexpected packet size %d (tcode %d), bug?",
+		HPSB_ERR("unexpected packet size %zd (tcode %d), bug?",
 			 packet_size, tcode);
 	return ret;
 }
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

git-acpi.patch
git-drm.patch
ieee1394_core-printk-format.patch
romfs-printk-format-warnings.patch
git-netdev-all.patch
git-scsi-misc.patch
git-unionfs.patch
git-ipwireless_cs.patch
scripts-kernel-doc-whitespace-cleanup.patch
reiserfs-proc-support-requires-proc_fs.patch
kprobes-fix-sparse-null-warning.patch
header-cleaning-dont-include-smp_lockh-when-not-used.patch
ext4-use-null-for-pointers.patch
some-grammatical-fixups-and-additions-to-atomich-kernel-doc.patch
profile-likely-unlikely-macros.patch
