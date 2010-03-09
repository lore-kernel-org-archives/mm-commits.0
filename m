From: akpm@linux-foundation.org
Subject: + memory-hotplug-s390-set-phys_device.patch added to -mm tree
Date: Tue, 09 Mar 2010 15:27:44 -0800
Message-ID: <201003092327.o29NRil9011616@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37610 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754679Ab0CIX2j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 18:28:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: heiko.carstens@de.ibm.com, gerald.schaefer@de.ibm.com, haveblue@us.ibm.com, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     memory hotplug/s390: set phys_device
has been added to the -mm tree.  Its filename is
     memory-hotplug-s390-set-phys_device.patch

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

add-generic-sys_old_select.patch
add-generic-sys_old_mmap.patch
add-generic-sys_ipc-wrapper.patch
add-generic-sys_ipc-wrapper-fix.patch
improve-sys_newuname-for-compat-architectures.patch
add-generic-sys_olduname.patch
linux-next.patch
memory-hotplug-allow-setting-of-phys_device.patch
memory-hotplug-s390-set-phys_device.patch
vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos.patch
improve-sys_personality-for-compat-architectures.patch

