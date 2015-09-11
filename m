From: akpm@linux-foundation.org
Subject: [merged]
 proc-add-cond_resched-to-proc-kpage-read-write-loop.patch removed from -mm
 tree
Date: Fri, 11 Sep 2015 11:11:28 -0700
Message-ID: <55f31950.Pj6VRxiS33RYbdv4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53665 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbbIKSL3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Sep 2015 14:11:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, andreslc@google.com, corbet@lwn.net, gorcunov@openvz.org, gthelen@google.com, hannes@cmpxchg.org, mhocko@suse.cz, minchan@kernel.org, raghavendra.kt@linux.vnet.ibm.com, rientjes@google.com, walken@google.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: add cond_resched to /proc/kpage* read/write loop
has been removed from the -mm tree.  Its filename was
     proc-add-cond_resched-to-proc-kpage-read-write-loop.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: proc: add cond_resched to /proc/kpage* read/write loop

Reading/writing a /proc/kpage* file may take long on machines with a lot
of RAM installed.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Suggested-by: Andres Lagar-Cavilla <andreslc@google.com>
Reviewed-by: Andres Lagar-Cavilla <andreslc@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Greg Thelen <gthelen@google.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/page.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN fs/proc/page.c~proc-add-cond_resched-to-proc-kpage-read-write-loop fs/proc/page.c
--- a/fs/proc/page.c~proc-add-cond_resched-to-proc-kpage-read-write-loop
+++ a/fs/proc/page.c
@@ -58,6 +58,8 @@ static ssize_t kpagecount_read(struct fi
 		pfn++;
 		out++;
 		count -= KPMSIZE;
+
+		cond_resched();
 	}
 
 	*ppos += (char __user *)out - buf;
@@ -219,6 +221,8 @@ static ssize_t kpageflags_read(struct fi
 		pfn++;
 		out++;
 		count -= KPMSIZE;
+
+		cond_resched();
 	}
 
 	*ppos += (char __user *)out - buf;
@@ -267,6 +271,8 @@ static ssize_t kpagecgroup_read(struct f
 		pfn++;
 		out++;
 		count -= KPMSIZE;
+
+		cond_resched();
 	}
 
 	*ppos += (char __user *)out - buf;
_

Patches currently in -mm which might be from vdavydov@parallels.com are


