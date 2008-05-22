From: akpm@linux-foundation.org
Subject: + memrlimit-add-memrlimit-controller-documentation.patch added to -mm tree
Date: Wed, 21 May 2008 21:29:11 -0700
Message-ID: <200805220429.m4M4TBoi017019@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47409 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751361AbYEVEaB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 May 2008 00:30:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com, rientjes@google.com, skumar@linux.vnet.ibm.com, vgoyal@redhat.com, xemul@openvz.org, yamamoto@valinux.co.jp


The patch titled
     memrlimit: add memrlimit controller documentation
has been added to the -mm tree.  Its filename is
     memrlimit-add-memrlimit-controller-documentation.patch

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
Subject: memrlimit: add memrlimit controller documentation
From: Balbir Singh <balbir@linux.vnet.ibm.com>

The goal of this patch is to implement a virtual address space controller
using cgroups.  The documentation describes the controller, its goal and
usage in further detail.


This patch:

Documentation patch - describes the goals and usage of the memrlimit
controller.

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Sudhir Kumar <skumar@linux.vnet.ibm.com>
Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Cc: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Pavel Emelianov <xemul@openvz.org>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/controllers/memrlimit.txt |   29 ++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff -puN /dev/null Documentation/controllers/memrlimit.txt
--- /dev/null
+++ a/Documentation/controllers/memrlimit.txt
@@ -0,0 +1,29 @@
+This controller is enabled by the CONFIG_CGROUP_MEMRLIMIT_CTLR option. Prior
+to reading this documentation please read Documentation/cgroups.txt and
+Documentation/controllers/memory.txt. Several of the principles of this
+controller are similar to the memory resource controller.
+
+This controller framework is designed to be extensible to control any
+memory resource limit with little effort.
+
+This new controller, controls the address space expansion of the tasks
+belonging to a cgroup. Address space control is provided along the same lines as
+RLIMIT_AS control, which is available via getrlimit(2)/setrlimit(2).
+The interface for controlling address space is provided through
+"rlimit.limit_in_bytes". The file is similar to "limit_in_bytes" w.r.t. the user
+interface. Please see section 3 of the memory resource controller documentation
+for more details on how to use the user interface to get and set values.
+
+The "memrlimit.usage_in_bytes" file provides information about the total address
+space usage of the tasks in the cgroup, in bytes.
+
+Advantages of providing this feature
+
+1. Control over virtual address space allows for a cgroup to fail gracefully
+   i.e., via a malloc or mmap failure as compared to OOM kill when no
+   pages can be reclaimed.
+2. It provides better control over how many pages can be swapped out when
+   the cgroup goes over its limit. A badly setup cgroup can cause excessive
+   swapping. Providing control over the address space allocations ensures
+   that the system administrator has control over the total swapping that
+   can take place.
_

Patches currently in -mm which might be from balbir@linux.vnet.ibm.com are

linux-next.patch
cgroup-use-read-lock-to-guard-find_existing_css_set.patch
mark-res_counter_charge_locked-with-__must_check.patch
memcg-make-global-var-read_mostly.patch
memcg-avoid-unnecessary-initialization.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch

