From: akpm@linux-foundation.org
Subject: + memstick-init-sysfs-attributes.patch added to -mm tree
Date: Thu, 05 Aug 2010 15:37:09 -0700
Message-ID: <201008052237.o75Mb9mg009393@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33335 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932167Ab0HEWqc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Aug 2010 18:46:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: maximlevitsky@gmail.com, oakad@yahoo.com, stable@kernel.org


The patch titled
     memstick: init sysfs attributes
has been added to the -mm tree.  Its filename is
     memstick-init-sysfs-attributes.patch

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
Subject: memstick: init sysfs attributes
From: Maxim Levitsky <maximlevitsky@gmail.com>

Otherwise lockdep complains.

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Alex Dubov <oakad@yahoo.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/memstick/core/mspro_block.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/memstick/core/mspro_block.c~memstick-init-sysfs-attributes drivers/memstick/core/mspro_block.c
--- a/drivers/memstick/core/mspro_block.c~memstick-init-sysfs-attributes
+++ a/drivers/memstick/core/mspro_block.c
@@ -1048,6 +1048,7 @@ static int mspro_block_read_attributes(s
 			snprintf(s_attr->name, sizeof(s_attr->name),
 				 "attr_x%02x", attr->entries[cnt].id);
 
+		sysfs_attr_init(&s_attr->dev_attr.attr);
 		s_attr->dev_attr.attr.name = s_attr->name;
 		s_attr->dev_attr.attr.mode = S_IRUGO;
 		s_attr->dev_attr.show = mspro_block_attr_show(s_attr->id);
_

Patches currently in -mm which might be from maximlevitsky@gmail.com are

linux-next.patch
maintainers-update-ricoh-smartmedia-xd-driver-file-patterns.patch
mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume.patch
mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume-update-2.patch
mmc-make-sdhci-work-with-ricoh-mmc-controller.patch
mmc-add-ricoh-e822-pci-id.patch
memstick-init-sysfs-attributes.patch
memstick-fix-hangs-on-unexpected-device-removal-in-mspro_blk.patch

