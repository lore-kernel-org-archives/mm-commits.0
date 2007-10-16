From: akpm@linux-foundation.org
Subject: - git-scsi-misc-include-fix.patch removed from -mm tree
Date: Tue, 16 Oct 2007 14:48:48 -0700
Message-ID: <200710162148.l9GLmm8Q019238@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56298 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966211AbXJPVs7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:48:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pj@sgi.com, James.Bottomley@steeleye.com, mm-commits@vger.kernel.org


The patch titled
     git scsi misc include fix
has been removed from the -mm tree.  Its filename was
     git-scsi-misc-include-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: git scsi misc include fix
From: Paul Jackson <pj@sgi.com>

The added line in scsi_eh.h:
	struct scatterlist sense_sgl;
fails to compile, with the error:
	field 'sense_sgl' has incomplete type
unless scatterlist.h happens to be included
somehow already ... which it isn't always.

So include scatterlist.h in scsi_eh.h directly.

Signed-off-by: Paul Jackson <pj@sgi.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/scsi/scsi_eh.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/scsi/scsi_eh.h~git-scsi-misc-include-fix include/scsi/scsi_eh.h
--- a/include/scsi/scsi_eh.h~git-scsi-misc-include-fix
+++ a/include/scsi/scsi_eh.h
@@ -4,6 +4,7 @@
 #include <linux/scatterlist.h>
 
 #include <scsi/scsi_cmnd.h>
+#include <linux/scatterlist.h>
 struct scsi_device;
 struct Scsi_Host;
 
_

Patches currently in -mm which might be from pj@sgi.com are

origin.patch
cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
task-containersv11-basic-task-container-framework.patch
task-containersv11-add-tasks-file-interface.patch
task-containersv11-add-fork-exit-hooks.patch
task-containersv11-add-container_clone-interface.patch
task-containersv11-add-procfs-interface.patch
task-containersv11-shared-container-subsystem-group-arrays.patch
task-containersv11-automatic-userspace-notification-of-idle-containers.patch
task-containersv11-automatic-userspace-notification-of-idle-containers-fix.patch
task-containersv11-make-cpusets-a-client-of-containers.patch
task-containersv11-example-cpu-accounting-subsystem.patch
task-containersv11-simple-task-container-debug-info-subsystem.patch
task-containers-enable-containers-by-default-in-some-configs.patch
whitespace-fixes-cpuset.patch
cpuset-sched_load_balance-flag.patch
cpuset-sched_load_balance-flag-fix.patch
cpusets-decrustify-cpuset-mask-update-code.patch
cpusets-decrustify-cpuset-mask-update-code-checkpatch-fixes.patch
control-groups-replace-cont-with-cgrp-and-other-misc.patch
hotplug-cpu-migrate-a-task-within-its-cpuset.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-fix.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-doc.patch
