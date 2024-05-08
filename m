Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FB5A12AAE0
	for <mm-commits@vger.kernel.org>; Wed,  8 May 2024 17:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715189048; cv=none; b=YXk/U5XucBZQTx4Em7QjIrKN3Cei4LmqiiI6c2jJr6xUZsJdzjV1239mO0SCGlUno+OXrpPBQ8U6LFjm8ygEnIJFRlo28TI0JZKZg8TqX8LPyrutKyTCQtOHc4GQn1r/KBCOjuh+85dKlROiQiFFPdxeMT9f8ftKiBv5he0G28s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715189048; c=relaxed/simple;
	bh=pRnqZWZ0kK8SWI3A9aneSac05/z2gA5ZoM40+Qnn5mQ=;
	h=Date:To:From:Subject:Message-Id; b=IeKS2lb/NYteOqCKvnpjCiYC3a+pZSji1sr/x4OlmYnVXxAWHNGHnUBATCyOS7Xfj+380zb8Rp1cbhmWqQc+UFmDcTrl1tXkt2M4RpbjlVRa2ffzGf/m5wDQFZmXi8UouoXRNBDTI5tnazYjycs0/nwOZgwvDzQy6oR2co0lc/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RJWobUNV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RJWobUNV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9694C32781;
	Wed,  8 May 2024 17:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1715189048;
	bh=pRnqZWZ0kK8SWI3A9aneSac05/z2gA5ZoM40+Qnn5mQ=;
	h=Date:To:From:Subject:From;
	b=RJWobUNVFwygzKFK5xq7i0ytyfGkzy54CkMMHEOhdDr1nTLOIWsrC2VxhjimxE3eD
	 uJOwy6QUx2WSrz/pTb/uoDkIGlTEdsHzaIQZiwMAcVQT8ZgBvGChmVpxJsxz39/yEE
	 9J6dathJQ7hhrp7f+2BVP9h4fsXK2erGyS4Qrvqg=
Date: Wed, 08 May 2024 10:24:07 -0700
To: mm-commits@vger.kernel.org,nao.horiguchi@gmail.com,linmiaohe@huawei.com,jane.chu@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-memory-failure-send-sigbus-in-the-event-of-thp-split-fail.patch removed from -mm tree
Message-Id: <20240508172407.E9694C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory-failure: send SIGBUS in the event of thp split fail
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-send-sigbus-in-the-event-of-thp-split-fail.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Jane Chu <jane.chu@oracle.com>
Subject: mm/memory-failure: send SIGBUS in the event of thp split fail
Date: Wed, 1 May 2024 17:24:58 -0600

When handle hwpoison in a GUP longterm pin'ed thp page,
try_to_split_thp_page() will fail.  And at this point, there is little
else the kernel could do except sending a SIGBUS to the user process, thus
give it a chance to recover.

[akpm@linux-foundation.org: update for folio conversions]
Link: https://lkml.kernel.org/r/20240501232458.3919593-4-jane.chu@oracle.com
Signed-off-by: Jane Chu <jane.chu@oracle.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

--- a/mm/memory-failure.c~mm-memory-failure-send-sigbus-in-the-event-of-thp-split-fail
+++ a/mm/memory-failure.c
@@ -2162,6 +2162,36 @@ out:
 	return rc;
 }
 
+/*
+ * The calling condition is as such: thp split failed, page might have
+ * been GUP longterm pinned, not much can be done for recovery.
+ * But a SIGBUS should be delivered with vaddr provided so that the user
+ * application has a chance to recover. Also, application processes'
+ * election for MCE early killed will be honored.
+ */
+static int kill_procs_now(struct page *p, unsigned long pfn, int flags,
+			struct folio *folio)
+{
+	LIST_HEAD(tokill);
+	int res = -EHWPOISON;
+
+	/* deal with user pages only */
+	if (PageReserved(p) || PageSlab(p) || PageTable(p) || PageOffline(p))
+		res = -EBUSY;
+	if (!(folio_test_lru(folio) || PageHuge(p)))
+		res = -EBUSY;
+
+	if (res == -EHWPOISON) {
+		collect_procs(folio, p, &tokill, flags & MF_ACTION_REQUIRED);
+		kill_procs(&tokill, true, pfn, flags);
+	}
+
+	if (flags & MF_COUNT_INCREASED)
+		put_page(p);
+
+	return res;
+}
+
 /**
  * memory_failure - Handle memory failure of a page.
  * @pfn: Page Number of the corrupted page
@@ -2291,6 +2321,11 @@ try_again:
 		 */
 		folio_set_has_hwpoisoned(folio);
 		if (try_to_split_thp_page(p) < 0) {
+			if (flags & MF_ACTION_REQUIRED) {
+				pr_err("%#lx: thp split failed\n", pfn);
+				res = kill_procs_now(p, pfn, flags, folio);
+				goto unlock_mutex;
+			}
 			res = action_result(pfn, MF_MSG_UNSPLIT_THP, MF_IGNORED);
 			goto unlock_mutex;
 		}
_

Patches currently in -mm which might be from jane.chu@oracle.com are


