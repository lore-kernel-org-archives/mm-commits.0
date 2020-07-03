From: akpm@linux-foundation.org
Subject: + kcov-make-some-symbols-static.patch added to -mm tree
Date: Thu, 02 Jul 2020 21:31:53 -0700
Message-ID: <20200703043153.NtFA4vCju%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725764AbgGCEby (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Jul 2020 00:31:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andreyknvl@google.com, hulkci@huawei.com, mm-commits@vger.kernel.org, weiyongjun1@huawei.com


The patch titled
     Subject: kcov: make some symbols static
has been added to the -mm tree.  Its filename is
     kcov-make-some-symbols-static.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kcov-make-some-symbols-static.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kcov-make-some-symbols-static.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wei Yongjun <weiyongjun1@huawei.com>
Subject: kcov: make some symbols static

Fix sparse build warnings:

kernel/kcov.c:99:1: warning:
 symbol '__pcpu_scope_kcov_percpu_data' was not declared. Should it be static?
kernel/kcov.c:778:6: warning:
 symbol 'kcov_remote_softirq_start' was not declared. Should it be static?
kernel/kcov.c:795:6: warning:
 symbol 'kcov_remote_softirq_stop' was not declared. Should it be static?

Link: http://lkml.kernel.org/r/20200702115501.73077-1-weiyongjun1@huawei.com
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Reported-by: Hulk Robot <hulkci@huawei.com>
Reviewed-by: Andrey Konovalov <andreyknvl@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kcov.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/kernel/kcov.c~kcov-make-some-symbols-static
+++ a/kernel/kcov.c
@@ -96,7 +96,7 @@ struct kcov_percpu_data {
 	int			saved_sequence;
 };
 
-DEFINE_PER_CPU(struct kcov_percpu_data, kcov_percpu_data);
+static DEFINE_PER_CPU(struct kcov_percpu_data, kcov_percpu_data);
 
 /* Must be called with kcov_remote_lock locked. */
 static struct kcov_remote *kcov_remote_find(u64 handle)
@@ -775,7 +775,7 @@ static inline bool kcov_mode_enabled(uns
 	return (mode & ~KCOV_IN_CTXSW) != KCOV_MODE_DISABLED;
 }
 
-void kcov_remote_softirq_start(struct task_struct *t)
+static void kcov_remote_softirq_start(struct task_struct *t)
 {
 	struct kcov_percpu_data *data = this_cpu_ptr(&kcov_percpu_data);
 	unsigned int mode;
@@ -792,7 +792,7 @@ void kcov_remote_softirq_start(struct ta
 	}
 }
 
-void kcov_remote_softirq_stop(struct task_struct *t)
+static void kcov_remote_softirq_stop(struct task_struct *t)
 {
 	struct kcov_percpu_data *data = this_cpu_ptr(&kcov_percpu_data);
 
_

Patches currently in -mm which might be from weiyongjun1@huawei.com are

mm-slub-extend-slub_debug-syntax-for-multiple-blocks-fix.patch
bits-add-tests-of-genmask-fix-2.patch
kcov-make-some-symbols-static.patch
