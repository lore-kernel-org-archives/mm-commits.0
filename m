From: akpm@linux-foundation.org
Subject: + task-containersv11-basic-task-container-framework-fix.patch added to -mm tree
Date: Sun, 29 Jul 2007 22:55:56 -0700
Message-ID: <200707300555.l6U5tuNB028338@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48484 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753252AbXG3F4I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jul 2007 01:56:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: menage@google.com, akpm@linux-foundation.org


The patch titled
     task-containersv11-basic-task-container-framework-fix
has been added to the -mm tree.  Its filename is
     task-containersv11-basic-task-container-framework-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: task-containersv11-basic-task-container-framework-fix
From: "Paul Menage" <menage@google.com>

On 7/28/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> >  [<c0154ad2>] proc_cpuset_show+0x5e/0xb9
> >  [<c01976b1>] seq_read+0xef/0x266
> >  [<c0181398>] vfs_read+0x8e/0x117
> >  [<c01817c9>] sys_read+0x3d/0x61
> >  [<c010401e>] sysenter_past_esp+0x5f/0x99
> >  =======================
> > INFO: lockdep is turned off.
> > Code: 00 89 d8 83 c4 0c 5b 5e 5f 5d c3 55 89 e5 57 56 53 83 ec 08 89
> > 45 f0 89 55 ec 89 d3 01 cb 8d 43 ff c6 43 ff 00 8b 55 f0 8b 72 1c <8b>
> > 56 3c 29 d0 3b 45 ec 72 45 89 d1 c1 e9 02 8b 76 40 89 c7 f3
> > EIP: [<c01536a7>] container_path+0x20/0x7b SS:ESP 0068:c5ccff00
>

Oops, this is a case of trying to read /proc/self/cpuset when cpusets
are completely unmounted. It works fine when cpusets is mounted as
part of any hierarchy, or part of an active but unmounted hierarchy.
Attached patch fixes it, and should be rolled in to the first patch of
the series. (basic framework patch).


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/container.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN kernel/container.c~task-containersv11-basic-task-container-framework-fix kernel/container.c
--- a/kernel/container.c~task-containersv11-basic-task-container-framework-fix
+++ a/kernel/container.c
@@ -683,6 +683,15 @@ int container_path(const struct containe
 {
 	char *start;
 
+	if (cont == dummytop) {
+		/*
+		 * Inactive subsystems have no dentry for their root
+		 * container
+		 */
+		strcpy(buf, "/");
+		return 0;
+	}
+
 	start = buf + buflen;
 
 	*--start = '\0';
_

Patches currently in -mm which might be from menage@google.com are

cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
task-containersv11-basic-task-container-framework.patch
task-containersv11-basic-task-container-framework-fix.patch
task-containersv11-add-tasks-file-interface.patch
task-containersv11-add-fork-exit-hooks.patch
task-containersv11-add-container_clone-interface.patch
task-containersv11-add-procfs-interface.patch
task-containersv11-shared-container-subsystem-group-arrays.patch
task-containersv11-automatic-userspace-notification-of-idle-containers.patch
task-containersv11-make-cpusets-a-client-of-containers.patch
task-containersv11-example-cpu-accounting-subsystem.patch
task-containersv11-simple-task-container-debug-info-subsystem.patch
add-containerstats-v3.patch
add-containerstats-v3-fix.patch
update-getdelays-to-become-containerstats-aware.patch
containers-implement-namespace-tracking-subsystem.patch
containers-implement-namespace-tracking-subsystem-fix-order-of-container-subsystems-in-init-kconfig.patch
