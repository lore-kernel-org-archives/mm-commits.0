From: akpm@linux-foundation.org
Subject: - cpu-online-file-permission.patch removed from -mm tree
Date: Tue, 31 Jul 2007 16:56:22 -0700
Message-ID: <200707312356.l6VNuMgE029318@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43413 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763281AbXHAART (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 20:17:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: drepper@redhat.com, rusty@rustcorp.com.au, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     CPU online file permission
has been removed from the -mm tree.  Its filename was
     cpu-online-file-permission.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: CPU online file permission
From: Ulrich Drepper <drepper@redhat.com>

Is there a reason why the "online" file in the subdirectories for the CPUs
in /sys/devices/system isn't world-readable?  I cannot imagine it to be
security relevant especially now that a getcpu() syscall can be used to
determine what CPUa thread runs on.

The file is useful to correctly implement the sysconf() function to return
the number of online CPUs.  In the presence of hotplug we currently cannot
provide this information.  The patch below should to it.

Signed-off-by: Ulrich Drepper <drepper@redhat.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/cpu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/base/cpu.c~cpu-online-file-permission drivers/base/cpu.c
--- a/drivers/base/cpu.c~cpu-online-file-permission
+++ a/drivers/base/cpu.c
@@ -53,7 +53,7 @@ static ssize_t store_online(struct sys_d
 		ret = count;
 	return ret;
 }
-static SYSDEV_ATTR(online, 0600, show_online, store_online);
+static SYSDEV_ATTR(online, 0644, show_online, store_online);
 
 static void __devinit register_cpu_control(struct cpu *cpu)
 {
_

Patches currently in -mm which might be from drepper@redhat.com are

origin.patch
tiny-sched_getaffinity-cleanup.patch
