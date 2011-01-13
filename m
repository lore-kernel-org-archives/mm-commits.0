From: akpm@linux-foundation.org
Subject: [merged] cgroups-remove-deprecated-subsystem-from-examples.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:08:26 -0800
Message-ID: <201101132011.p0DKB7FM030127@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60113 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933651Ab1AMULm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:11:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: twoerner@gmail.com, lizf@cn.fujitsu.com, menage@google.com, mm-commits@vger.kernel.org


The patch titled
     cgroups: remove deprecated subsystem from examples.
has been removed from the -mm tree.  Its filename was
     cgroups-remove-deprecated-subsystem-from-examples.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroups: remove deprecated subsystem from examples.
From: Trevor Woerner <twoerner@gmail.com>

The 'ns' cgroup is considered deprecated. Change the cgroup subsystem
used in the examples of the cgroup documentation from 'ns' to 'blkio'.

Signed-off-by: Trevor Woerner <twoerner@gmail.com>
Acked-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/cgroups.txt |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN Documentation/cgroups/cgroups.txt~cgroups-remove-deprecated-subsystem-from-examples Documentation/cgroups/cgroups.txt
--- a/Documentation/cgroups/cgroups.txt~cgroups-remove-deprecated-subsystem-from-examples
+++ a/Documentation/cgroups/cgroups.txt
@@ -355,13 +355,13 @@ subsystems, type:
 
 To change the set of subsystems bound to a mounted hierarchy, just
 remount with different options:
-# mount -o remount,cpuset,ns hier1 /dev/cgroup
+# mount -o remount,cpuset,blkio hier1 /dev/cgroup
 
-Now memory is removed from the hierarchy and ns is added.
+Now memory is removed from the hierarchy and blkio is added.
 
-Note this will add ns to the hierarchy but won't remove memory or
+Note this will add blkio to the hierarchy but won't remove memory or
 cpuset, because the new options are appended to the old ones:
-# mount -o remount,ns /dev/cgroup
+# mount -o remount,blkio /dev/cgroup
 
 To Specify a hierarchy's release_agent:
 # mount -t cgroup -o cpuset,release_agent="/sbin/cpuset_release_agent" \
_

Patches currently in -mm which might be from twoerner@gmail.com are

origin.patch

