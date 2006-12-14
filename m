From: akpm@osdl.org
Subject: + config_vm_event_counter-comment-decrustify.patch added to -mm tree
Date: Wed, 13 Dec 2006 16:17:01 -0800
Message-ID: <200612140017.kBE0H1u6025802@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:60861 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751828AbWLNARE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 19:17:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pj@sgi.com, clameter@sgi.com


The patch titled
     CONFIG_VM_EVENT_COUNTER comment decrustify
has been added to the -mm tree.  Its filename is
     config_vm_event_counter-comment-decrustify.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: CONFIG_VM_EVENT_COUNTER comment decrustify
From: Paul Jackson <pj@sgi.com>

The VM event counters, enabled by CONFIG_VM_EVENT_COUNTERS, which provides
VM event counters in /proc/vmstat, has become more essential to
non-EMBEDDED kernel configurations than they were in the past.  Comments in
the code and the Kconfig configuration explanation were stale, downplaying
their role excessively.

Refresh those comments to correctly reflect the current role of VM event
counters.

Signed-off-by: Paul Jackson <pj@sgi.com>
Acked-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/vmstat.h |    5 +++--
 init/Kconfig           |    8 ++++----
 2 files changed, 7 insertions(+), 6 deletions(-)

diff -puN include/linux/vmstat.h~config_vm_event_counter-comment-decrustify include/linux/vmstat.h
--- a/include/linux/vmstat.h~config_vm_event_counter-comment-decrustify
+++ a/include/linux/vmstat.h
@@ -45,8 +45,9 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 /*
  * Light weight per cpu counter implementation.
  *
- * Counters should only be incremented and no critical kernel component
- * should rely on the counter values.
+ * Counters should only be incremented.  You need to set EMBEDDED
+ * to disable VM_EVENT_COUNTERS.  Things like procps (vmstat,
+ * top, etc) use /proc/vmstat and depend on these counters.
  *
  * Counters are handled completely inline. On many platforms the code
  * generated will simply be the increment of a global address.
diff -puN init/Kconfig~config_vm_event_counter-comment-decrustify init/Kconfig
--- a/init/Kconfig~config_vm_event_counter-comment-decrustify
+++ a/init/Kconfig
@@ -483,10 +483,10 @@ config VM_EVENT_COUNTERS
 	default y
 	bool "Enable VM event counters for /proc/vmstat" if EMBEDDED
 	help
-	  VM event counters are only needed to for event counts to be
-	  shown. They have no function for the kernel itself. This
-	  option allows the disabling of the VM event counters.
-	  /proc/vmstat will only show page counts.
+	  VM event counters are needed for event counts to be shown.
+	  This option allows the disabling of the VM event counters
+	  on EMBEDDED systems.  /proc/vmstat will only show page counts
+	  if VM event counters are disabled.
 
 endmenu		# General setup
 
_

Patches currently in -mm which might be from pj@sgi.com are

origin.patch
cpuset-rework-cpuset_zone_allowed-api.patch
config_vm_event_counter-comment-decrustify.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch

