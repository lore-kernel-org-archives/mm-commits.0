From: akpm@linux-foundation.org
Subject: + cgroups-implement-device-whitelist-doc.patch added to -mm tree
Date: Thu, 27 Mar 2008 12:38:08 -0700
Message-ID: <200803271938.m2RJc9VK018773@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35694 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757209AbYC0Tik (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 Mar 2008 15:38:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: serue@us.ibm.com, balbir@in.ibm.com, daniel@hozac.com, jmorris@namei.org, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com


The patch titled
     cgroups: devices: add Documentation/ file
has been added to the -mm tree.  Its filename is
     cgroups-implement-device-whitelist-doc.patch

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
Subject: cgroups: devices: add Documentation/ file
From: "Serge E. Hallyn" <serue@us.ibm.com>

Fill a Documentation/controllers/devices.txt file with a modified text from
the patch description.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Daniel Hokka Zakrisson <daniel@hozac.com>
Cc: James Morris <jmorris@namei.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Cc: Serge E. Hallyn <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/controllers/devices.txt |   48 ++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff -puN /dev/null Documentation/controllers/devices.txt
--- /dev/null
+++ a/Documentation/controllers/devices.txt
@@ -0,0 +1,48 @@
+Device Whitelist Controller
+
+1. Description:
+
+Implement a cgroup to track and enforce open and mknod restrictions
+on device files.  A device cgroup associates a device access
+whitelist with each cgroup.  A whitelist entry has 4 fields.
+'type' is a (all), c (char), or b (block).  'all' means it applies
+to all types and all major and minor numbers.  Major and minor are
+either an integer or * for all.  Access is a composition of r
+(read), w (write), and m (mknod).
+
+The root device cgroup starts with rwm to 'all'.  A child device
+cgroup gets a copy of the parent.  Administrators can then remove
+devices from the whitelist or add new entries.  A child cgroup can
+never receive a device access which is denied its parent.  However
+when a device access is removed from a parent it will not also be
+removed from the child(ren).
+
+2. User Interface
+
+An entry is added using devices.allow, and removed using
+devices.deny.  For instance
+
+	echo 'c 1:3 mr' > /cgroups/1/devices.allow
+
+allows cgroup 1 to read and mknod the device usually known as
+/dev/null.  Doing
+
+	echo a > /cgroups/1/devices.deny
+
+will remove the default 'a *:* mrw' entry.
+
+3. Security
+
+Any task can move itself between cgroups.  This clearly won't
+suffice, but we can decide the best way to adequately restrict
+movement as people get some experience with this.  We may just want
+to require CAP_SYS_ADMIN, which at least is a separate bit from
+CAP_MKNOD.  We may want to just refuse moving to a cgroup which
+isn't a descendent of the current one.  Or we may want to use
+CAP_MAC_ADMIN, since we really are trying to lock down root.
+
+CAP_SYS_ADMIN is needed to modify the whitelist or move another
+task to a new cgroup.  (Again we'll probably want to change that).
+
+A cgroup may not be granted more permissions than the cgroup's
+parent has.
_

Patches currently in -mm which might be from serue@us.ibm.com are

git-unionfs.patch
git-vfs.patch
capabilities-implement-per-process-securebits.patch
capabilities-implement-per-process-securebits-warning-fix.patch
capabilities-implement-per-process-securebits-fix.patch
root_plug-use-cap_task_prctl.patch
smack-use-cap_task_prctl.patch
cgroups-kernel-ns_cgroupc-should-include-linux-nsproxyh.patch
cgroups-implement-device-whitelist-v6.patch
cgroups-implement-device-whitelist-v6-checkpatch-fixes.patch
cgroups-implement-device-whitelist-v6-cleanups.patch
cgroups-implement-device-whitelist-doc.patch
signals-cleanup-security_task_kill-usage-implementation.patch
signals-check_kill_permission-check-session-under-tasklist_lock.patch
ipc-semaphores-code-factorisation.patch
ipc-shared-memory-introduce-shmctl_down.patch
ipc-message-queues-introduce-msgctl_down.patch
ipc-semaphores-move-the-rwmutex-handling-inside-semctl_down.patch
ipc-semaphores-remove-one-unused-parameter-from-semctl_down.patch
ipc-get-rid-of-the-use-_setbuf-structure.patch
ipc-introduce-ipc_update_perm.patch
ipc-consolidate-all-xxxctl_down-functions.patch
reiser4-replace-uid==0-check-with-capability.patch

