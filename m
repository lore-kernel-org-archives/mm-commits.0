From: akpm@linux-foundation.org
Subject: [merged]
 mm-validate-device_hotplug-is-held-for-memory-hotplug.patch removed from
 -mm tree
Date: Mon, 27 Feb 2017 12:24:17 -0800
Message-ID: <58b48af1.9+viJueF3TJ1Rhrk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60400 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751530AbdB0UYo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2017 15:24:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, ben@decadent.org.uk, gregkh@linuxfoundation.org, logang@deltatee.com, m.mizuma@jp.fujitsu.com, mhocko@suse.com, toshi.kani@hpe.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: validate device_hotplug is held for memory hotplug
has been removed from the -mm tree.  Its filename was
     mm-validate-device_hotplug-is-held-for-memory-hotplug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: mm: validate device_hotplug is held for memory hotplug

mem_hotplug_begin() assumes that it can set mem_hotplug.active_writer and
run the hotplug process without racing another thread.  Validate this
assumption with a lockdep assertion.

Link: http://lkml.kernel.org/r/148693886229.16345.1770484669403334689.stgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reported-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Toshi Kani <toshi.kani@hpe.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/core.c    |    5 +++++
 include/linux/device.h |    1 +
 mm/memory_hotplug.c    |    2 ++
 3 files changed, 8 insertions(+)

diff -puN drivers/base/core.c~mm-validate-device_hotplug-is-held-for-memory-hotplug drivers/base/core.c
--- a/drivers/base/core.c~mm-validate-device_hotplug-is-held-for-memory-hotplug
+++ a/drivers/base/core.c
@@ -638,6 +638,11 @@ int lock_device_hotplug_sysfs(void)
 	return restart_syscall();
 }
 
+void assert_held_device_hotplug(void)
+{
+	lockdep_assert_held(&device_hotplug_lock);
+}
+
 #ifdef CONFIG_BLOCK
 static inline int device_is_not_partition(struct device *dev)
 {
diff -puN include/linux/device.h~mm-validate-device_hotplug-is-held-for-memory-hotplug include/linux/device.h
--- a/include/linux/device.h~mm-validate-device_hotplug-is-held-for-memory-hotplug
+++ a/include/linux/device.h
@@ -1139,6 +1139,7 @@ static inline bool device_supports_offli
 extern void lock_device_hotplug(void);
 extern void unlock_device_hotplug(void);
 extern int lock_device_hotplug_sysfs(void);
+void assert_held_device_hotplug(void);
 extern int device_offline(struct device *dev);
 extern int device_online(struct device *dev);
 extern void set_primary_fwnode(struct device *dev, struct fwnode_handle *fwnode);
diff -puN mm/memory_hotplug.c~mm-validate-device_hotplug-is-held-for-memory-hotplug mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-validate-device_hotplug-is-held-for-memory-hotplug
+++ a/mm/memory_hotplug.c
@@ -126,6 +126,8 @@ void put_online_mems(void)
 
 void mem_hotplug_begin(void)
 {
+	assert_held_device_hotplug();
+
 	mem_hotplug.active_writer = current;
 
 	memhp_lock_acquire();
_

Patches currently in -mm which might be from dan.j.williams@intel.com are


