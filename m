From: akpm@linux-foundation.org
Subject: [merged] kdump-add-missing-ram-resource-in-crash_shrink_memory.patch removed from -mm tree
Date: Fri, 13 Jan 2012 12:36:19 -0800
Message-ID: <20120113203619.C527610004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:57534 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932798Ab2AMUgU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 15:36:20 -0500
Received: by ggnk3 with SMTP id k3so355913ggn.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 12:36:20 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: holzheu@linux.vnet.ibm.com, ebiederm@xmission.com, heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kdump: add missing RAM resource in crash_shrink_memory()
has been removed from the -mm tree.  Its filename was
     kdump-add-missing-ram-resource-in-crash_shrink_memory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Subject: kdump: add missing RAM resource in crash_shrink_memory()

When shrinking crashkernel memory using /sys/kernel/kexec_crash_size for
the newly added memory no RAM resource is created at the moment.

Example:

$ cat /proc/iomem
00000000-bfffffff : System RAM
  00000000-005b7ac3 : Kernel code
  005b7ac4-009743bf : Kernel data
  009bb000-00a85c33 : Kernel bss
c0000000-cfffffff : Crash kernel
d0000000-ffffffff : System RAM

$ echo 0 > /sys/kernel/kexec_crash_size
$ cat /proc/iomem
00000000-bfffffff : System RAM
  00000000-005b7ac3 : Kernel code
  005b7ac4-009743bf : Kernel data
  009bb000-00a85c33 : Kernel bss
                                 <<-- here is System RAM missing
d0000000-ffffffff : System RAM

One result of this bug is that the memory chunk can never be set offline
using memory hotplug.  With this patch I insert a new "System RAM"
resource for the released memory.  Then the upper example looks like the
following:

$ echo 0 > /sys/kernel/kexec_crash_size
$ cat /proc/iomem
00000000-bfffffff : System RAM
  00000000-005b7ac3 : Kernel code
  005b7ac4-009743bf : Kernel data
  009bb000-00a85c33 : Kernel bss
c0000000-cfffffff : System RAM   <<-- new rescoure
d0000000-ffffffff : System RAM

And now I can set chunk c0000000-cfffffff offline.

Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff -puN kernel/kexec.c~kdump-add-missing-ram-resource-in-crash_shrink_memory kernel/kexec.c
--- a/kernel/kexec.c~kdump-add-missing-ram-resource-in-crash_shrink_memory
+++ a/kernel/kexec.c
@@ -1129,6 +1129,7 @@ int crash_shrink_memory(unsigned long ne
 {
 	int ret = 0;
 	unsigned long start, end;
+	struct resource *ram_res;
 
 	mutex_lock(&kexec_mutex);
 
@@ -1146,6 +1147,12 @@ int crash_shrink_memory(unsigned long ne
 		goto unlock;
 	}
 
+	ram_res = kzalloc(sizeof(*ram_res), GFP_KERNEL);
+	if (!ram_res) {
+		ret = -ENOMEM;
+		goto unlock;
+	}
+
 	start = roundup(start, KEXEC_CRASH_MEM_ALIGN);
 	end = roundup(start + new_size, KEXEC_CRASH_MEM_ALIGN);
 
@@ -1154,7 +1161,15 @@ int crash_shrink_memory(unsigned long ne
 
 	if ((start == end) && (crashk_res.parent != NULL))
 		release_resource(&crashk_res);
+
+	ram_res->start = end;
+	ram_res->end = crashk_res.end;
+	ram_res->flags = IORESOURCE_BUSY | IORESOURCE_MEM;
+	ram_res->name = "System RAM";
+
 	crashk_res.end = end - 1;
+
+	insert_resource(&iomem_resource, ram_res);
 	crash_unmap_reserved_pages();
 
 unlock:
_

Patches currently in -mm which might be from holzheu@linux.vnet.ibm.com are

origin.patch

