From: akpm@linux-foundation.org
Subject: + cgroups-remove-deprecated-subsystem-from-examples.patch added to -mm tree
Date: Wed, 15 Dec 2010 14:33:09 -0800
Message-ID: <201012152233.oBFMX961009889@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41654 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751718Ab0LOWdR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Dec 2010 17:33:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: twoerner@gmail.com, lizf@cn.fujitsu.com, menage@google.com


The patch titled
     cgroups: remove deprecated subsystem from examples.
has been added to the -mm tree.  Its filename is
     cgroups-remove-deprecated-subsystem-from-examples.patch

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

cgroups-remove-deprecated-subsystem-from-examples.patch

