From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 152/166] kcov: fix potential use-after-free in
 kcov_remote_start
Date: Mon, 06 Apr 2020 20:12:08 -0700
Message-ID: <20200407031208.wsYgOelp4%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726591AbgDGDMJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 23:12:09 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andreyknvl@gmail.com, andreyknvl@google.com, elver@google.com, glider@google.com, gregkh@linuxfoundation.org, linux-mm@kvack.org, mm-commits@vger.kernel.org, stern@rowland.harvard.edu, torvalds@linux-foundation.org

From: Andrey Konovalov <andreyknvl@google.com>
Subject: kcov: fix potential use-after-free in kcov_remote_start

If vmalloc() fails in kcov_remote_start() we'll access remote->kcov
without holding kcov_remote_lock, so remote might potentially be freed at
that point.  Cache kcov pointer in a local variable.

Link: http://lkml.kernel.org/r/9d9134359725a965627b7e8f2652069f86f1d1fa.1585233617.git.andreyknvl@google.com
Link: http://lkml.kernel.org/r/de0d3d30ff90776a2a509cc34c7c1c7521bda125.1584655448.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Alexander Potapenko <glider@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Marco Elver <elver@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kcov.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/kernel/kcov.c~kcov-fix-potential-use-after-free-in-kcov_remote_start
+++ a/kernel/kcov.c
@@ -748,6 +748,7 @@ static const struct file_operations kcov
 void kcov_remote_start(u64 handle)
 {
 	struct kcov_remote *remote;
+	struct kcov *kcov;
 	void *area;
 	struct task_struct *t;
 	unsigned int size;
@@ -774,16 +775,17 @@ void kcov_remote_start(u64 handle)
 		spin_unlock(&kcov_remote_lock);
 		return;
 	}
+	kcov = remote->kcov;
 	/* Put in kcov_remote_stop(). */
-	kcov_get(remote->kcov);
-	t->kcov = remote->kcov;
+	kcov_get(kcov);
+	t->kcov = kcov;
 	/*
 	 * Read kcov fields before unlock to prevent races with
 	 * KCOV_DISABLE / kcov_remote_reset().
 	 */
-	size = remote->kcov->remote_size;
-	mode = remote->kcov->mode;
-	sequence = remote->kcov->sequence;
+	size = kcov->remote_size;
+	mode = kcov->mode;
+	sequence = kcov->sequence;
 	area = kcov_remote_area_get(size);
 	spin_unlock(&kcov_remote_lock);
 
@@ -791,7 +793,7 @@ void kcov_remote_start(u64 handle)
 		area = vmalloc(size * sizeof(unsigned long));
 		if (!area) {
 			t->kcov = NULL;
-			kcov_put(remote->kcov);
+			kcov_put(kcov);
 			return;
 		}
 	}
_
