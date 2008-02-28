From: akpm@linux-foundation.org
Subject: + cgroup-api-files-strip-all-trailing-whitespace-in-cgroup_write_u64.patch added to -mm tree
Date: Wed, 27 Feb 2008 17:02:55 -0800
Message-ID: <200802280102.m1S12t0G008150@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:44441 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763362AbYB1BDp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Feb 2008 20:03:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: menage@google.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, pj@sgi.com, xemul@openvz.org, yamamoto@valinux.co.jp


The patch titled
     CGroup API files: strip all trailing whitespace in cgroup_write_u64
has been added to the -mm tree.  Its filename is
     cgroup-api-files-strip-all-trailing-whitespace-in-cgroup_write_u64.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: CGroup API files: strip all trailing whitespace in cgroup_write_u64
From: Paul Menage <menage@google.com>

This removes the need for people to remember to pass the -n flag to echo when
writing values to cgroup control files.

Signed-off-by: Paul Menage <menage@google.com>
Cc: "Li Zefan" <lizf@cn.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Paul Jackson <pj@sgi.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "YAMAMOTO Takashi" <yamamoto@valinux.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN kernel/cgroup.c~cgroup-api-files-strip-all-trailing-whitespace-in-cgroup_write_u64 kernel/cgroup.c
--- a/kernel/cgroup.c~cgroup-api-files-strip-all-trailing-whitespace-in-cgroup_write_u64
+++ a/kernel/cgroup.c
@@ -1321,10 +1321,7 @@ static ssize_t cgroup_write_u64(struct c
 		return -EFAULT;
 
 	buffer[nbytes] = 0;     /* nul-terminate */
-
-	/* strip newline if necessary */
-	if (nbytes && (buffer[nbytes-1] == '\n'))
-		buffer[nbytes-1] = 0;
+	strstrip(buffer);
 	val = simple_strtoull(buffer, &end, 0);
 	if (*end)
 		return -EINVAL;
_

Patches currently in -mm which might be from menage@google.com are

cgroup-fix-default-notify_on_release-setting.patch
memory-resource-controller-use-strstrip-while-parsing-arguments.patch
memory-controller-rename-to-memory-resource-controller.patch
make-cgroup_enable_task_cg_lists-static.patch
cgroup-fix-sparse-warning-of-shadow-symbol-in-cgroupc.patch
cgroup-api-files-rename-read-write_uint-methods-to-read_write_u64.patch
cgroup-api-files-add-res_counter_read_u64.patch
cgroup-api-files-use-read_u64-in-memory-controller.patch
cgroup-api-files-strip-all-trailing-whitespace-in-cgroup_write_u64.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api.patch
cgroup-api-files-add-cgroup-map-data-type.patch
cgroup-api-files-use-cgroup-map-for-memcontrol-stats-file.patch
cgroup-api-files-drop-mem_cgroup_force_empty.patch
cgroup-api-files-move-releasable-to-cgroup_debug-subsystem.patch
cgroup-api-files-make-cgroup_debug-default-to-off.patch
add-a-refcount-check-in-dput.patch
