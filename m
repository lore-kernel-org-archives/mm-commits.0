From: akpm@linux-foundation.org
Subject: + proc-add-cond_resched-to-proc-kpage-read-write-loop.patch added to -mm tree
Date: Tue, 21 Jul 2015 16:34:08 -0700
Message-ID: <55aed6f0.dPf5+LoPXX269OF8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44112 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933904AbbGUXeJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jul 2015 19:34:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, andreslc@google.com, corbet@lwn.net, gorcunov@openvz.org, gthelen@google.com, hannes@cmpxchg.org, mhocko@suse.cz, minchan@kernel.org, raghavendra.kt@linux.vnet.ibm.com, rientjes@google.com, walken@google.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: add cond_resched to /proc/kpage* read/write loop
has been added to the -mm tree.  Its filename is
     proc-add-cond_resched-to-proc-kpage-read-write-loop.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-add-cond_resched-to-proc-kpage-read-write-loop.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-add-cond_resched-to-proc-kpage-read-write-loop.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

 fs/proc/page.c |    8 ++++++++
 1 file changed, 8 insertions(+)

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
@@ -421,6 +427,7 @@ static ssize_t kpageidle_read(struct fil
 			idle_bitmap = 0;
 			out++;
 		}
+		cond_resched();
 	}
 
 	*ppos += (char __user *)out - buf;
@@ -467,6 +474,7 @@ static ssize_t kpageidle_write(struct fi
 				put_page(page);
 			}
 		}
+		cond_resched();
 	}
 
 	*ppos += (const char __user *)in - buf;
_

Patches currently in -mm which might be from vdavydov@parallels.com are

memcg-export-struct-mem_cgroup.patch
memcg-export-struct-mem_cgroup-fix.patch
memcg-export-struct-mem_cgroup-fix-2.patch
memcg-get-rid-of-mem_cgroup_root_css-for-config_memcg.patch
memcg-get-rid-of-extern-for-functions-in-memcontrolh.patch
memcg-restructure-mem_cgroup_can_attach.patch
memcg-tcp_kmem-check-for-cg_proto-in-sock_update_memcg.patch
memcg-add-page_cgroup_ino-helper.patch
hwpoison-use-page_cgroup_ino-for-filtering-by-memcg.patch
memcg-zap-try_get_mem_cgroup_from_page.patch
proc-add-kpagecgroup-file.patch
mmu-notifier-add-clear_young-callback.patch
proc-add-kpageidle-file.patch
proc-export-idle-flag-via-kpageflags.patch
proc-add-cond_resched-to-proc-kpage-read-write-loop.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
mm-swap-zswap-maybe_preload-refactoring.patch

