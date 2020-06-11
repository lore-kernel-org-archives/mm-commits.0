From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated]
 mm-madvise-allow-ksm-hints-for-remote-api.patch removed from -mm tree
Date: Wed, 10 Jun 2020 22:26:16 -0700
Message-ID: <20200611052616.EK9KeDxsR%akpm@linux-foundation.org>
References: <20200610184053.3fa7368ab80e23bfd44de71f@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726445AbgFKF0S (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 11 Jun 2020 01:26:18 -0400
In-Reply-To: <20200610184053.3fa7368ab80e23bfd44de71f@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexander.h.duyck@linux.intel.com, axboe@kernel.dk, bgeffon@google.com, christian.brauner@ubuntu.com, christian@brauner.io, dancol@google.com, hannes@cmpxchg.org, jannh@google.com, joaodias@google.com, joel@joelfernandes.org, ktkhai@virtuozzo.com, linux-man@vger.kernel.org, mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org, oleksandr@redhat.com, shakeelb@google.com, sj38.park@gmail.com, sjpark@amazon.de, sonnyrao@google.com, sspatil@google.com, surenb@google.com, timmurray@google.com, vbabka@suse.cz


The patch titled
     Subject: mm/madvise: allow KSM hints for remote API
has been removed from the -mm tree.  Its filename was
     mm-madvise-allow-ksm-hints-for-remote-api.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Oleksandr Natalenko <oleksandr@redhat.com>
Subject: mm/madvise: allow KSM hints for remote API

It all began with the fact that KSM works only on memory that is marked by
madvise().  And the only way to get around that is to either:

  * use LD_PRELOAD; or
  * patch the kernel with something like UKSM or PKSM.

(i skip ptrace can of worms here intentionally)

To overcome this restriction, lets employ a new remote madvise API.  This
can be used by some small userspace helper daemon that will do auto-KSM
job for us.

I think of two major consumers of remote KSM hints:

  * hosts, that run containers, especially similar ones and especially in
    a trusted environment, sharing the same runtime like Node.js;

  * heavy applications, that can be run in multiple instances, not
    limited to opensource ones like Firefox, but also those that cannot be
    modified since they are binary-only and, maybe, statically linked.

Speaking of statistics, more numbers can be found in the very first
submission, that is related to this one [1].  For my current setup with
two Firefox instances I get 100 to 200 MiB saved for the second instance
depending on the amount of tabs.

1 FF instance with 15 tabs:

   $ echo "$(cat /sys/kernel/mm/ksm/pages_sharing) * 4 / 1024" | bc
   410

2 FF instances, second one has 12 tabs (all the tabs are different):

   $ echo "$(cat /sys/kernel/mm/ksm/pages_sharing) * 4 / 1024" | bc
   592

At the very moment I do not have specific numbers for containerised
workload, but those should be comparable in case the containers share
similar/same runtime.

[1] https://lore.kernel.org/patchwork/patch/1012142/

Link: http://lkml.kernel.org/r/20200302193630.68771-8-minchan@kernel.org
Signed-off-by: Oleksandr Natalenko <oleksandr@redhat.com>
Signed-off-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: SeongJae Park <sjpark@amazon.de>
Cc: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Christian Brauner <christian@brauner.io>
Cc: Daniel Colascione <dancol@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: John Dias <joaodias@google.com>
Cc: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Sandeep Patil <sspatil@google.com>
Cc: SeongJae Park <sj38.park@gmail.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Sonny Rao <sonnyrao@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Tim Murray <timmurray@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: <linux-man@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/madvise.c~mm-madvise-allow-ksm-hints-for-remote-api
+++ a/mm/madvise.c
@@ -1014,6 +1014,10 @@ process_madvise_behavior_valid(int behav
 	switch (behavior) {
 	case MADV_COLD:
 	case MADV_PAGEOUT:
+#ifdef CONFIG_KSM
+	case MADV_MERGEABLE:
+	case MADV_UNMERGEABLE:
+#endif
 		return true;
 	default:
 		return false;
_

Patches currently in -mm which might be from oleksandr@redhat.com are
