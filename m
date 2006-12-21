From: akpm@osdl.org
Subject: - kref-refcnt-and-false-positives.patch removed from -mm tree
Date: Wed, 20 Dec 2006 16:36:45 -0800
Message-ID: <200612210036.kBL0aj3r011222@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:53339 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161112AbWLUAgx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Dec 2006 19:36:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: venkatesh.pallipadi@intel.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     kref refcnt and false positives
has been removed from the -mm tree.  Its filename was
     kref-refcnt-and-false-positives.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: kref refcnt and false positives
From: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

With WARN_ON addition to kobject_init()
[ http://kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.19/2.6.19-mm1/dont-use/broken-out/gregkh-driver-kobject-warn.patch ]

I started seeing following WARNING on CPU offline followed by online on my
x86_64 system.

WARNING at lib/kobject.c:172 kobject_init()

Call Trace:
 [<ffffffff8020ab45>] dump_trace+0xaa/0x3ef
 [<ffffffff8020aec4>] show_trace+0x3a/0x50
 [<ffffffff8020b0f6>] dump_stack+0x15/0x17
 [<ffffffff80350abc>] kobject_init+0x3f/0x8a
 [<ffffffff80350be1>] kobject_register+0x1a/0x3e
 [<ffffffff803bbd89>] sysdev_register+0x5b/0xf9
 [<ffffffff80211d0b>] mce_create_device+0x77/0xf4
 [<ffffffff80211dc2>] mce_cpu_callback+0x3a/0xe5
 [<ffffffff805632fd>] notifier_call_chain+0x26/0x3b
 [<ffffffff8023f6f3>] raw_notifier_call_chain+0x9/0xb
 [<ffffffff802519bf>] _cpu_up+0xb4/0xdc
 [<ffffffff80251a12>] cpu_up+0x2b/0x42
 [<ffffffff803bef00>] store_online+0x4a/0x72
 [<ffffffff803bb6ce>] sysdev_store+0x24/0x26
 [<ffffffff802baaa2>] sysfs_write_file+0xcf/0xfc
 [<ffffffff8027fc6f>] vfs_write+0xae/0x154
 [<ffffffff80280418>] sys_write+0x47/0x6f
 [<ffffffff8020963e>] system_call+0x7e/0x83
DWARF2 unwinder stuck at system_call+0x7e/0x83
Leftover inexact backtrace:

This is a false positive as mce.c is unregistering/registering sysfs
interfaces cleanly on hotplug.

kref_put() and conditional decrement of refcnt seems to be the root cause
for this and the patch below resolves the issue for me.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 lib/kref.c |    7 +------
 1 files changed, 1 insertion(+), 6 deletions(-)

diff -puN lib/kref.c~kref-refcnt-and-false-positives lib/kref.c
--- a/lib/kref.c~kref-refcnt-and-false-positives
+++ a/lib/kref.c
@@ -52,12 +52,7 @@ int kref_put(struct kref *kref, void (*r
 	WARN_ON(release == NULL);
 	WARN_ON(release == (void (*)(struct kref *))kfree);
 
-	/*
-	 * if current count is one, we are the last user and can release object
-	 * right now, avoiding an atomic operation on 'refcount'
-	 */
-	if ((atomic_read(&kref->refcount) == 1) ||
-	    (atomic_dec_and_test(&kref->refcount))) {
+	if (atomic_dec_and_test(&kref->refcount)) {
 		release(kref);
 		return 1;
 	}
_

Patches currently in -mm which might be from venkatesh.pallipadi@intel.com are

origin.patch
bug-fix-for-acpi-cpufreq-and-cpufreq_stats-oops-on-frequency-change-notification.patch

