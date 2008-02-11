From: akpm@linux-foundation.org
Subject: + sparc-fix-build.patch added to -mm tree
Date: Mon, 11 Feb 2008 14:51:04 -0800
Message-ID: <200802112251.m1BMp5UZ005137@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35268 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753096AbYBKWwT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Feb 2008 17:52:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, bunk@kernel.org, davem@davemloft.net, reif@earthlink.net


The patch titled
     sparc: fix build
has been added to the -mm tree.  Its filename is
     sparc-fix-build.patch

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
Subject: sparc: fix build
From: David Rientjes <rientjes@google.com>

Fix build failures on sparc:

	In file included from include/linux/mm.h:39,
	                from include/linux/memcontrol.h:24,
	                from include/linux/swap.h:8,
	                from include/linux/suspend.h:7,
	                from init/do_mounts.c:6:
	include/asm/pgtable.h:344: warning: parameter names (without
		types) in function declaration
	include/asm/pgtable.h:345: warning: parameter names (without
		types) in function declaration
	include/asm/pgtable.h:346: error: expected '=', ',', ';', 'asm' or
		'__attribute__' before '___f___swp_entry'

and

	arch/sparc/kernel/led.c: In function 'led_blink':
	arch/sparc/kernel/led.c:35: error: invalid use of undefined type
		'struct timer_list'
	arch/sparc/kernel/led.c:35: error: 'jiffies' undeclared (first use
		in this function)
	arch/sparc/kernel/led.c:35: error: (Each undeclared identifier is
		reported only once
	arch/sparc/kernel/led.c:35: error: for each function it appears
		in.)
	arch/sparc/kernel/led.c:36: error: 'avenrun' undeclared (first use
		in this function)
	arch/sparc/kernel/led.c:36: error: 'FSHIFT' undeclared (first use
		in this function)
	arch/sparc/kernel/led.c:36: error: 'HZ' undeclared (first use in
		this function)
	arch/sparc/kernel/led.c:37: error: invalid use of undefined type
		'struct timer_list'
	arch/sparc/kernel/led.c:39: error: invalid use of undefined type
		'struct timer_list'
	arch/sparc/kernel/led.c:40: error: invalid use of undefined type
		'struct timer_list'
	arch/sparc/kernel/led.c:42: error: implicit declaration of
		function 'add_timer'
	arch/sparc/kernel/led.c: In function 'led_write_proc':
	arch/sparc/kernel/led.c:70: error: implicit declaration of
		function 'copy_from_user'
	arch/sparc/kernel/led.c:84: error: implicit declaration of
		function 'del_timer_sync'
	arch/sparc/kernel/led.c: In function 'led_init':
	arch/sparc/kernel/led.c:109: error: implicit declaration of
		function 'init_timer'
	arch/sparc/kernel/led.c:110: error: invalid use of undefined type
		'struct timer_list'

Cc: Adrian Bunk <bunk@kernel.org>
Cc: Robert Reif <reif@earthlink.net>
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/kernel/led.c    |    3 ++-
 include/linux/memcontrol.h |    3 ---
 2 files changed, 2 insertions(+), 4 deletions(-)

diff -puN arch/sparc/kernel/led.c~sparc-fix-build arch/sparc/kernel/led.c
--- a/arch/sparc/kernel/led.c~sparc-fix-build
+++ a/arch/sparc/kernel/led.c
@@ -1,8 +1,9 @@
-#include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/proc_fs.h>
 #include <linux/string.h>
+#include <linux/sched.h>
+#include <linux/uaccess.h>
 
 #include <asm/auxio.h>
 
diff -puN include/linux/memcontrol.h~sparc-fix-build include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~sparc-fix-build
+++ a/include/linux/memcontrol.h
@@ -20,9 +20,6 @@
 #ifndef _LINUX_MEMCONTROL_H
 #define _LINUX_MEMCONTROL_H
 
-#include <linux/rcupdate.h>
-#include <linux/mm.h>
-
 struct mem_cgroup;
 struct page_cgroup;
 struct page;
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
memcontrol-add-vm_match_cgroup.patch
sparc-fix-build.patch
mempolicy-silently-restrict-nodemask-to-allowed-nodes-v3.patch
