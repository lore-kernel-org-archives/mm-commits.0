From: akpm@linux-foundation.org
Subject: [merged] memory-hotplug-s390-set-phys_device.patch removed from -mm tree
Date: Fri, 19 Mar 2010 12:49:14 -0400
Message-ID: <201003191949.o2JJnv1G009017@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45154 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750911Ab0CSTuM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Mar 2010 15:50:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: heiko.carstens@de.ibm.com, gerald.schaefer@de.ibm.com, haveblue@us.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     memory hotplug/s390: set phys_device
has been removed from the -mm tree.  Its filename was
     memory-hotplug-s390-set-phys_device.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memory hotplug/s390: set phys_device
From: Heiko Carstens <heiko.carstens@de.ibm.com>

Implement arch specific arch_get_memory_phys_device function and
initialize phys_device for each memory section.  That way we finally can
tell which piece of memory belongs to which physical device.

This makes s390's /sys/devices/system/memory/memoryX/phys_device display
the correct thing?

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/s390/char/sclp_cmd.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN drivers/s390/char/sclp_cmd.c~memory-hotplug-s390-set-phys_device drivers/s390/char/sclp_cmd.c
--- a/drivers/s390/char/sclp_cmd.c~memory-hotplug-s390-set-phys_device
+++ a/drivers/s390/char/sclp_cmd.c
@@ -704,6 +704,13 @@ int sclp_chp_deconfigure(struct chp_id c
 	return do_chp_configure(SCLP_CMDW_DECONFIGURE_CHPATH | chpid.id << 8);
 }
 
+int arch_get_memory_phys_device(unsigned long start_pfn)
+{
+	if (!rzm)
+		return 0;
+	return PFN_PHYS(start_pfn) / rzm;
+}
+
 struct chp_info_sccb {
 	struct sccb_header header;
 	u8 recognized[SCLP_CHP_INFO_MASK_SIZE];
_

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are

origin.patch
linux-next.patch
vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos.patch
improve-sys_personality-for-compat-architectures.patch

