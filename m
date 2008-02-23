From: akpm@linux-foundation.org
Subject: + memcgroup-fix-and-update-documentation.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:32:48 -0800
Message-ID: <200802230733.m1N7XblF018238@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:55647 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753940AbYBWH5V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 02:57:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     memcgroup: fix and update documentation
has been added to the -mm tree.  Its filename is
     memcgroup-fix-and-update-documentation.patch

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
Subject: memcgroup: fix and update documentation
From: Li Zefan <lizf@cn.fujitsu.com>

- remove trailing " Bytes"s in the demonstration
- remove section 4.4 (feature control_type has been removed)
- fix reference section

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/controllers/memory.txt |   24 +++++++++---------------
 1 file changed, 9 insertions(+), 15 deletions(-)

diff -puN Documentation/controllers/memory.txt~memcgroup-fix-and-update-documentation Documentation/controllers/memory.txt
--- a/Documentation/controllers/memory.txt~memcgroup-fix-and-update-documentation
+++ a/Documentation/controllers/memory.txt
@@ -170,14 +170,14 @@ NOTE: We can use a suffix (k, K, m, M, g
 mega or gigabytes.
 
 # cat /cgroups/0/memory.limit_in_bytes
-4194304 Bytes
+4194304
 
 NOTE: The interface has now changed to display the usage in bytes
 instead of pages
 
 We can check the usage:
 # cat /cgroups/0/memory.usage_in_bytes
-1216512 Bytes
+1216512
 
 A successful write to this file does not guarantee a successful set of
 this limit to the value written into the file.  This can be due to a
@@ -187,7 +187,7 @@ this file after a write to guarantee the
 
 # echo -n 1 > memory.limit_in_bytes
 # cat memory.limit_in_bytes
-4096 Bytes
+4096
 
 The memory.failcnt field gives the number of times that the cgroup limit was
 exceeded.
@@ -233,13 +233,6 @@ cgroup might have some charge associated
 tasks have migrated away from it. Such charges are automatically dropped at
 rmdir() if there are no tasks.
 
-4.4 Choosing what to account  -- Page Cache (unmapped) vs RSS (mapped)?
-
-The type of memory accounted by the cgroup can be limited to just
-mapped pages by writing "1" to memory.control_type field
-
-echo -n 1 > memory.control_type
-
 5. TODO
 
 1. Add support for accounting huge pages (as a separate controller)
@@ -262,18 +255,19 @@ References
 3. Emelianov, Pavel. Resource controllers based on process cgroups
    http://lkml.org/lkml/2007/3/6/198
 4. Emelianov, Pavel. RSS controller based on process cgroups (v2)
-   http://lkml.org/lkml/2007/4/9/74
+   http://lkml.org/lkml/2007/4/9/78
 5. Emelianov, Pavel. RSS controller based on process cgroups (v3)
    http://lkml.org/lkml/2007/5/30/244
 6. Menage, Paul. Control Groups v10, http://lwn.net/Articles/236032/
 7. Vaidyanathan, Srinivasan, Control Groups: Pagecache accounting and control
    subsystem (v3), http://lwn.net/Articles/235534/
-8. Singh, Balbir. RSS controller V2 test results (lmbench),
+8. Singh, Balbir. RSS controller v2 test results (lmbench),
    http://lkml.org/lkml/2007/5/17/232
-9. Singh, Balbir. RSS controller V2 AIM9 results
+9. Singh, Balbir. RSS controller v2 AIM9 results
    http://lkml.org/lkml/2007/5/18/1
-10. Singh, Balbir. Memory controller v6 results,
+10. Singh, Balbir. Memory controller v6 test results,
     http://lkml.org/lkml/2007/8/19/36
-11. Singh, Balbir. Memory controller v6, http://lkml.org/lkml/2007/8/17/69
+11. Singh, Balbir. Memory controller introduction (v6),
+    http://lkml.org/lkml/2007/8/17/69
 12. Corbet, Jonathan, Controlling memory use in cgroups,
     http://lwn.net/Articles/243795/
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

cgroup-fix-and-update-documentation.patch
cgroup-fix-comments.patch
cgroup-clean-up-cgrouph.patch
cgroup-fix-memory-leak-in-cgroup_get_sb.patch
cgroup-fix-subsys-bitops.patch
cgroup-remove-duplicate-code-in-find_css_set.patch
cgroup-remove-dead-code-in-cgroup_get_rootdir.patch
memcgroup-fix-and-update-documentation.patch
memcgroup-remove-a-useless-vm_bug_on.patch
memcgroup-return-negative-error-code-in-mem_cgroup_create.patch
