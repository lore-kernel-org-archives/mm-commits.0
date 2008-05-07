From: akpm@linux-foundation.org
Subject: + cgroup-use-read-lock-to-guard-find_existing_css_set.patch added to -mm tree
Date: Wed, 07 May 2008 16:25:59 -0700
Message-ID: <200805072325.m47NPxmM022363@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43857 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753405AbYEGX1e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 May 2008 19:27:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, balbir@linux.vnet.ibm.com, menage@google.com


The patch titled
     cgroup: use read lock to guard find_existing_css_set()
has been added to the -mm tree.  Its filename is
     cgroup-use-read-lock-to-guard-find_existing_css_set.patch

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
Subject: cgroup: use read lock to guard find_existing_css_set()
From: Li Zefan <lizf@cn.fujitsu.com>

The function does not modify anything (except the temporary css template), so
it's sufficient to hold read lock.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Paul Menage <menage@google.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/cgroup.c~cgroup-use-read-lock-to-guard-find_existing_css_set kernel/cgroup.c
--- a/kernel/cgroup.c~cgroup-use-read-lock-to-guard-find_existing_css_set
+++ a/kernel/cgroup.c
@@ -415,11 +415,11 @@ static struct css_set *find_css_set(
 
 	/* First see if we already have a cgroup group that matches
 	 * the desired set */
-	write_lock(&css_set_lock);
+	read_lock(&css_set_lock);
 	res = find_existing_css_set(oldcg, cgrp, template);
 	if (res)
 		get_css_set(res);
-	write_unlock(&css_set_lock);
+	read_unlock(&css_set_lock);
 
 	if (res)
 		return res;
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

fix-cpuset-sched_relax_domain_level-control-file.patch
cgroup-use-read-lock-to-guard-find_existing_css_set.patch

