From: akpm@linux-foundation.org
Subject: - devices-cgroup-allow-mkfifo.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:47:55 -0800
Message-ID: <200901082247.n08MltHZ027333@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39413 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759624AbZAHWst (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:48:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: serue@us.ibm.com, dlezcano@fr.ibm.com, jmorris@namei.org, kosaki.motohiro@jp.fujitsu.com, laijs@cn.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com, stable@kernel.org, xemul@openvz


The patch titled
     devices cgroup: allow mkfifo
has been removed from the -mm tree.  Its filename was
     devices-cgroup-allow-mkfifo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: devices cgroup: allow mkfifo
From: "Serge E. Hallyn" <serue@us.ibm.com>

The devcgroup_inode_permission() hook in the devices whitelist cgroup has
always bypassed access checks on fifos.  But the mknod hook did not.  The
devices whitelist is only about block and char devices, and fifos can't
even be added to the whitelist, so fifos can't be created at all except by
tasks which have 'a' in their whitelist (meaning they have access to all
devices).

Fix the behavior by bypassing access checks to mkfifo.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Paul Menage <menage@google.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: James Morris <jmorris@namei.org>
Reported-by: Daniel Lezcano <dlezcano@fr.ibm.com>
Cc: <stable@kernel.org>		[2.6.27.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/device_cgroup.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN security/device_cgroup.c~devices-cgroup-allow-mkfifo security/device_cgroup.c
--- a/security/device_cgroup.c~devices-cgroup-allow-mkfifo
+++ a/security/device_cgroup.c
@@ -513,6 +513,9 @@ int devcgroup_inode_mknod(int mode, dev_
 	struct dev_cgroup *dev_cgroup;
 	struct dev_whitelist_item *wh;
 
+	if (!S_ISBLK(mode) && !S_ISCHR(mode))
+		return 0;
+
 	rcu_read_lock();
 
 	dev_cgroup = task_devcgroup(current);
_

Patches currently in -mm which might be from serue@us.ibm.com are

origin.patch
reiser4.patch

