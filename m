From: akpm@linux-foundation.org
Subject: [merged] cgroups-more-documentation-for-remount-and-release_agent.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:34:15 -0700
Message-ID: <200904061934.n36JYFQH011553@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57477 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757587AbZDFThF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:37:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, mm-commits@vger.kernel.org


The patch titled
     cgroups: more documentation for remount and release_agent
has been removed from the -mm tree.  Its filename was
     cgroups-more-documentation-for-remount-and-release_agent.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroups: more documentation for remount and release_agent
From: Li Zefan <lizf@cn.fujitsu.com>

This won't remove cpuacct from the mounted hierachy:
 # mount -t cgroup -o cpu,cpuacct xxx /mnt
 # mount -o remount,cpu /mnt

Because for this usage mount(8) will append the new options to the original
options.

And this will get you right:
 # mount [-t cgroup] -o remount,cpu xxx /mnt

Also document how to specify or change release_agent.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Reviewd-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/cgroups.txt |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff -puN Documentation/cgroups/cgroups.txt~cgroups-more-documentation-for-remount-and-release_agent Documentation/cgroups/cgroups.txt
--- a/Documentation/cgroups/cgroups.txt~cgroups-more-documentation-for-remount-and-release_agent
+++ a/Documentation/cgroups/cgroups.txt
@@ -333,12 +333,23 @@ The "xxx" is not interpreted by the cgro
 
 To mount a cgroup hierarchy with just the cpuset and numtasks
 subsystems, type:
-# mount -t cgroup -o cpuset,numtasks hier1 /dev/cgroup
+# mount -t cgroup -o cpuset,memory hier1 /dev/cgroup
 
 To change the set of subsystems bound to a mounted hierarchy, just
 remount with different options:
+# mount -o remount,cpuset,ns hier1 /dev/cgroup
 
-# mount -o remount,cpuset,ns  /dev/cgroup
+Now memory is removed from the hierarchy and ns is added.
+
+Note this will add ns to the hierarchy but won't remove memory or
+cpuset, because the new options are appended to the old ones:
+# mount -o remount,ns /dev/cgroup
+
+To Specify a hierarchy's release_agent:
+# mount -t cgroup -o cpuset,release_agent="/sbin/cpuset_release_agent" \
+  xxx /dev/cgroup
+
+Note that specifying 'release_agent' more than once will return failure.
 
 Note that changing the set of subsystems is currently only supported
 when the hierarchy consists of a single (root) cgroup. Supporting
@@ -349,6 +360,11 @@ Then under /dev/cgroup you can find a tr
 tree of the cgroups in the system. For instance, /dev/cgroup
 is the cgroup that holds the whole system.
 
+If you want to change the value of release_agent:
+# echo "/sbin/new_release_agent" > /dev/cgroup/release_agent
+
+It can also be changed via remount.
+
 If you want to create a new cgroup under /dev/cgroup:
 # cd /dev/cgroup
 # mkdir my_cgroup
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
linux-next.patch
cls_cgroup-remove-unneeded-cgroup_lock.patch

