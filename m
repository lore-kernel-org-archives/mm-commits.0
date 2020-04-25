From: akpm@linux-foundation.org
Subject: [alternative-merged]
 mm-madvise-employ-mmget_still_valid-for-write-lock.patch removed from -mm
 tree
Date: Sat, 25 Apr 2020 15:58:03 -0700
Message-ID: <20200425225803.791VDzjAS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726232AbgDYW6F (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 25 Apr 2020 18:58:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexander.h.duyck@linux.intel.com, axboe@kernel.dk, bgeffon@google.com, christian@brauner.io, dancol@google.com, hannes@cmpxchg.org, jannh@google.com, joaodias@google.com, joel@joelfernandes.org, ktkhai@virtuozzo.com, linux-man@vger.kernel.org, mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org, oleksandr@redhat.com, shakeelb@google.com, sj38.park@gmail.com, sjpark@amazon.de, sonnyrao@google.com, sspatil@google.com, surenb@google.com, timmurray@google.com, vbabka@suse.cz


The patch titled
     Subject: mm/madvise: employ mmget_still_valid() for write lock
has been removed from the -mm tree.  Its filename was
     mm-madvise-employ-mmget_still_valid-for-write-lock.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Oleksandr Natalenko <oleksandr@redhat.com>
Subject: mm/madvise: employ mmget_still_valid() for write lock

Do the very same trick as we already do since 04f5866e41fb.  KSM hints
will require locking mmap_sem for write since they modify vm_flags, so for
remote KSM hinting this additional check is needed.

Link: http://lkml.kernel.org/r/20200302193630.68771-7-minchan@kernel.org
Signed-off-by: Oleksandr Natalenko <oleksandr@redhat.com>
Signed-off-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
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
Cc: SeongJae Park <sjpark@amazon.de>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Sonny Rao <sonnyrao@google.com>
Cc: Tim Murray <timmurray@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <linux-man@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/madvise.c~mm-madvise-employ-mmget_still_valid-for-write-lock
+++ a/mm/madvise.c
@@ -1124,6 +1124,8 @@ int do_madvise(struct task_struct *targe
 	if (write) {
 		if (down_write_killable(&mm->mmap_sem))
 			return -EINTR;
+		if (current->mm != mm && !mmget_still_valid(mm))
+			goto skip_mm;
 	} else {
 		down_read(&mm->mmap_sem);
 	}
@@ -1175,6 +1177,7 @@ int do_madvise(struct task_struct *targe
 	}
 out:
 	blk_finish_plug(&plug);
+skip_mm:
 	if (write)
 		up_write(&mm->mmap_sem);
 	else
_

Patches currently in -mm which might be from oleksandr@redhat.com are

mm-madvise-allow-ksm-hints-for-remote-api.patch
