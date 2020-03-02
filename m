From: akpm@linux-foundation.org
Subject: +
 mm-madvise-employ-mmget_still_valid-for-write-lock.patch added to -mm tree
Date: Mon, 02 Mar 2020 13:16:47 -0800
Message-ID: <20200302211647.rLk1ODylX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726846AbgCBVQv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 2 Mar 2020 16:16:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexander.h.duyck@linux.intel.com, axboe@kernel.dk, bgeffon@google.com, christian@brauner.io, dancol@google.com, hannes@cmpxchg.org, jannh@google.com, joaodias@google.com, joel@joelfernandes.org, ktkhai@virtuozzo.com, linux-man@vger.kernel.org, mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org, oleksandr@redhat.com, shakeelb@google.com, sj38.park@gmail.com, sjpark@amazon.de, sonnyrao@google.com, sspatil@google.com, surenb@google.com, timmurray@google.com


The patch titled
     Subject: mm/madvise: employ mmget_still_valid() for write lock
has been added to the -mm tree.  Its filename is
     mm-madvise-employ-mmget_still_valid-for-write-lock.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-madvise-employ-mmget_still_valid-for-write-lock.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-madvise-employ-mmget_still_valid-for-write-lock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: <linux-man@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/madvise.c~mm-madvise-employ-mmget_still_valid-for-write-lock
+++ a/mm/madvise.c
@@ -1118,6 +1118,8 @@ int do_madvise(struct task_struct *targe
 	if (write) {
 		if (down_write_killable(&mm->mmap_sem))
 			return -EINTR;
+		if (current->mm != mm && !mmget_still_valid(mm))
+			goto skip_mm;
 	} else {
 		down_read(&mm->mmap_sem);
 	}
@@ -1169,6 +1171,7 @@ int do_madvise(struct task_struct *targe
 	}
 out:
 	blk_finish_plug(&plug);
+skip_mm:
 	if (write)
 		up_write(&mm->mmap_sem);
 	else
_

Patches currently in -mm which might be from oleksandr@redhat.com are

mm-madvise-employ-mmget_still_valid-for-write-lock.patch
mm-madvise-allow-ksm-hints-for-remote-api.patch
