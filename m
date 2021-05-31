Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAF2FC47082
	for <mm-commits@archiver.kernel.org>; Mon, 31 May 2021 23:10:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D87561186
	for <mm-commits@archiver.kernel.org>; Mon, 31 May 2021 23:10:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232035AbhEaXLu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 31 May 2021 19:11:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:39816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231978AbhEaXLu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 31 May 2021 19:11:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1E89761186;
        Mon, 31 May 2021 23:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1622502608;
        bh=m9BcmOxcOYGKR8KQ1jwecd+Tse59bWkGqZCQPlh703o=;
        h=Date:From:To:Subject:From;
        b=w1JWuJer9fpCRf501uX2K+HcRXjNqSdjzw7GKOZru9nTUDjy/S0to3jW5D4xD+IBZ
         EO2DpY3GdO2F10q9wnz5wN5Z8waxIoPIBDJvR0r7HaMxxJblUP7H7eLh7xs3/7sEez
         8KyuhY38aVzzTC/8agXs8RfZfFX16kOZSDQsXUYw=
Date:   Mon, 31 May 2021 16:10:07 -0700
From:   akpm@linux-foundation.org
To:     1vier1@web.de, dbueso@suse.de, manfred@colorfullife.com,
        mm-commits@vger.kernel.org
Subject:  + ipc-utilc-use-binary-search-for-max_idx.patch added to
 -mm tree
Message-ID: <20210531231007.m66ztlDoO%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/util.c: use binary search for max_idx
has been added to the -mm tree.  Its filename is
     ipc-utilc-use-binary-search-for-max_idx.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ipc-utilc-use-binary-search-for-max_idx.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ipc-utilc-use-binary-search-for-max_idx.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Manfred Spraul <manfred@colorfullife.com>
Subject: ipc/util.c: use binary search for max_idx

If semctl(), msgctl() and shmctl() are called with IPC_INFO, SEM_INFO,
MSG_INFO or SHM_INFO, then the return value is the index of the highest
used index in the kernel's internal array recording information about all
SysV objects of the requested type for the current namespace.  (This
information can be used with repeated ..._STAT or ..._STAT_ANY operations
to obtain information about all SysV objects on the system.)

There is a cache for this value.  But when the cache needs up be updated,
then the highest used index is determined by looping over all possible
values.  With the introduction of IPCMNI_EXTEND_SHIFT, this could be a
loop over 16 million entries.  And due to /proc/sys/kernel/*next_id, the
index values do not need to be consecutive.

With <write 16000000 to msg_next_id>, msgget(), msgctl(,IPC_RMID) in a
loop, I have observed a performance increase of around factor 13000.

As there is no get_last() function for idr structures: Implement a
"get_last()" using a binary search.

As far as I see, ipc is the only user that needs get_last(), thus
implement it in ipc/util.c and not in a central location.

Link: https://lkml.kernel.org/r/20210425075208.11777-2-manfred@colorfullife.com
Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Acked-by: Davidlohr Bueso <dbueso@suse.de>
Cc: <1vier1@web.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/util.c |   44 +++++++++++++++++++++++++++++++++++++++-----
 ipc/util.h |    3 +++
 2 files changed, 42 insertions(+), 5 deletions(-)

--- a/ipc/util.c~ipc-utilc-use-binary-search-for-max_idx
+++ a/ipc/util.c
@@ -64,6 +64,7 @@
 #include <linux/memory.h>
 #include <linux/ipc_namespace.h>
 #include <linux/rhashtable.h>
+#include <linux/log2.h>
 
 #include <asm/unistd.h>
 
@@ -451,6 +452,41 @@ static void ipc_kht_remove(struct ipc_id
 }
 
 /**
+ * ipc_search_maxidx - search the highest assigned index
+ * @ids: ipc identifier set
+ * @limit: known upper limit for highest assigned index
+ *
+ * The function determines the highest assigned index in @ids. It is intended
+ * to be called when ids->max_idx needs to be updated.
+ * Updating ids->max_idx is necessary when the current highest index ipc
+ * object is deleted.
+ * If no ipc object is allocated, then -1 is returned.
+ *
+ * ipc_ids.rwsem needs to be owned by the caller.
+ */
+static int ipc_search_maxidx(struct ipc_ids *ids, int limit)
+{
+	int tmpidx;
+	int i;
+	int retval;
+
+	i = ilog2(limit+1);
+
+	retval = 0;
+	for (; i >= 0; i--) {
+		tmpidx = retval | (1<<i);
+		/*
+		 * "0" is a possible index value, thus search using
+		 * e.g. 15,7,3,1,0 instead of 16,8,4,2,1.
+		 */
+		tmpidx = tmpidx-1;
+		if (idr_get_next(&ids->ipcs_idr, &tmpidx))
+			retval |= (1<<i);
+	}
+	return retval - 1;
+}
+
+/**
  * ipc_rmid - remove an ipc identifier
  * @ids: ipc identifier set
  * @ipcp: ipc perm structure containing the identifier to remove
@@ -468,11 +504,9 @@ void ipc_rmid(struct ipc_ids *ids, struc
 	ipcp->deleted = true;
 
 	if (unlikely(idx == ids->max_idx)) {
-		do {
-			idx--;
-			if (idx == -1)
-				break;
-		} while (!idr_find(&ids->ipcs_idr, idx));
+		idx = ids->max_idx-1;
+		if (idx >= 0)
+			idx = ipc_search_maxidx(ids, idx);
 		ids->max_idx = idx;
 	}
 }
--- a/ipc/util.h~ipc-utilc-use-binary-search-for-max_idx
+++ a/ipc/util.h
@@ -145,6 +145,9 @@ int ipcperms(struct ipc_namespace *ns, s
  * ipc_get_maxidx - get the highest assigned index
  * @ids: ipc identifier set
  *
+ * The function returns the highest assinged index for @ids. The function
+ * doesn't scan the idr tree, it uses a cached value.
+ *
  * Called with ipc_ids.rwsem held for reading.
  */
 static inline int ipc_get_maxidx(struct ipc_ids *ids)
_

Patches currently in -mm which might be from manfred@colorfullife.com are

ipc-semc-use-read_once-write_once-for-use_global_lock.patch
ipc-utilc-use-binary-search-for-max_idx.patch

