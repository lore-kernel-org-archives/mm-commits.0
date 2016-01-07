From: akpm@linux-foundation.org
Subject: [merged] dmi_scan-uuid-fix-endianess-for-smbios-=-0x206.patch
 removed from -mm tree
Date: Thu, 07 Jan 2016 14:17:13 -0800
Message-ID: <568ee3e9.QoQP8Js8fSfI6StZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57198 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783AbcAGWRO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Jan 2016 17:17:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, fsimonce@redhat.com, jdelvare@suse.de, matt@codeblueprint.co.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: dmi_scan: uuid: fix endianess for smbios >= 0x206
has been removed from the -mm tree.  Its filename was
     dmi_scan-uuid-fix-endianess-for-smbios-=-0x206.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: dmi_scan: uuid: fix endianess for smbios >= 0x206

The dmi_ver wasn't updated correctly before the dmi_decode method run to
save the uuid.

That resulted in "dmidecode -s system-uuid" and
/sys/class/dmi/id/product_uuid disagreeing.  The latter was buggy and this
fixes it.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Reported-by: Federico Simoncelli <fsimonce@redhat.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Jean Delvare <jdelvare@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/dmi_scan.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/firmware/dmi_scan.c~dmi_scan-uuid-fix-endianess-for-smbios-=-0x206 drivers/firmware/dmi_scan.c
--- a/drivers/firmware/dmi_scan.c~dmi_scan-uuid-fix-endianess-for-smbios-=-0x206
+++ a/drivers/firmware/dmi_scan.c
@@ -521,6 +521,7 @@ static int __init dmi_present(const u8 *
 			dmi_ver = smbios_ver;
 		else
 			dmi_ver = (buf[14] & 0xF0) << 4 | (buf[14] & 0x0F);
+		dmi_ver <<= 8;
 		dmi_num = get_unaligned_le16(buf + 12);
 		dmi_len = get_unaligned_le16(buf + 6);
 		dmi_base = get_unaligned_le32(buf + 8);
@@ -528,15 +529,14 @@ static int __init dmi_present(const u8 *
 		if (dmi_walk_early(dmi_decode) == 0) {
 			if (smbios_ver) {
 				pr_info("SMBIOS %d.%d present.\n",
-				       dmi_ver >> 8, dmi_ver & 0xFF);
+					dmi_ver >> 16, (dmi_ver >> 8) & 0xFF);
 			} else {
 				smbios_entry_point_size = 15;
 				memcpy(smbios_entry_point, buf,
 				       smbios_entry_point_size);
 				pr_info("Legacy DMI %d.%d present.\n",
-				       dmi_ver >> 8, dmi_ver & 0xFF);
+					dmi_ver >> 16, (dmi_ver >> 8) & 0xFF);
 			}
-			dmi_ver <<= 8;
 			dmi_format_ids(dmi_ids_string, sizeof(dmi_ids_string));
 			printk(KERN_DEBUG "DMI: %s\n", dmi_ids_string);
 			return 0;
_

Patches currently in -mm which might be from aarcange@redhat.com are

ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit.patch
ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-3.patch

