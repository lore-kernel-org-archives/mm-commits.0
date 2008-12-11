From: akpm@linux-foundation.org
Subject: + devices-cgroup-allow-mkfifo.patch added to -mm tree
Date: Thu, 11 Dec 2008 14:08:44 -0800
Message-ID: <200812112208.mBBM8iZ3025739@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52712 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755349AbYLKWKH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Dec 2008 17:10:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: serue@us.ibm.com, jmorris@namei.org, kosaki.motohiro@jp.fujitsu.com, laijs@cn.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com, xemul@openvz.org


The patch titled
     devices cgroup: allow mkfifo
has been added to the -mm tree.  Its filename is
     devices-cgroup-allow-mkfifo.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

linux-next.patch
devices-cgroup-allow-mkfifo.patch
reiser4.patch

