From: akpm@linux-foundation.org
Subject: - cgroup-api-files-strip-all-trailing-whitespace-in-cgroup_write_u64.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:42:17 -0700
Message-ID: <200804300542.m3U5gHJw029132@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51014 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757076AbYD3Fnc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:43:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: menage@google.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, pj@sgi.com, xemul@openvz.org, yamamoto@valinux.co.jp, mm-commits@vger.kernel.org


The patch titled
     CGroup API files: strip all trailing whitespace in cgroup_write_u64
has been removed from the -mm tree.  Its filename was
     cgroup-api-files-strip-all-trailing-whitespace-in-cgroup_write_u64.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: CGroup API files: strip all trailing whitespace in cgroup_write_u64
From: Paul Menage <menage@google.com>

This removes the need for people to remember to pass the -n flag to echo when
writing values to cgroup control files.

Signed-off-by: Paul Menage <menage@google.com>
Cc: "Li Zefan" <lizf@cn.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Paul Jackson <pj@sgi.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "YAMAMOTO Takashi" <yamamoto@valinux.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN kernel/cgroup.c~cgroup-api-files-strip-all-trailing-whitespace-in-cgroup_write_u64 kernel/cgroup.c
--- a/kernel/cgroup.c~cgroup-api-files-strip-all-trailing-whitespace-in-cgroup_write_u64
+++ a/kernel/cgroup.c
@@ -1329,10 +1329,7 @@ static ssize_t cgroup_write_u64(struct c
 		return -EFAULT;
 
 	buffer[nbytes] = 0;     /* nul-terminate */
