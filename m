From: akpm@linux-foundation.org
Subject: - sparc-fix-build.patch removed from -mm tree
Date: Sun, 24 Feb 2008 16:44:31 -0800
Message-ID: <200802250044.m1P0iVRF006116@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:48682 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753214AbYBYAov (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 24 Feb 2008 19:44:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, bunk@kernel.org, davem@davemloft.net, reif@earthlink.net, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     sparc: fix build
has been removed from the -mm tree.  Its filename was
     sparc-fix-build.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sparc: fix build
From: David Rientjes <rientjes@google.com>

Fix build failure on sparc:

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

viro sayeth:

  I've run allmodconfig builds on a bunch of target, FWIW (essentially the
  same patch).  Note that these includes are recent addition caused by added
  inline function that had since then become a define.  So while I agree with
  your comments in general, in _this_ case it's pretty safe.

  Commit that had done it is 3062fc67dad01b1d2a15d58c709eff946389eca4 and
  switch to #define is 60c12b1202a60eabb1c61317e5d2678fcea9893f (BTW, that
  warranted mentioning in changelog of the latter).

Cc: Adrian Bunk <bunk@kernel.org>
Cc: Robert Reif <reif@earthlink.net>
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    3 ---
 1 file changed, 3 deletions(-)

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

make-cgroup_enable_task_cg_lists-static.patch
