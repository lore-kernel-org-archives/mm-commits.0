Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9E7E128806
	for <mm-commits@vger.kernel.org>; Wed,  8 May 2024 17:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715189008; cv=none; b=BwIASeczjj0wzkcKbgQzBHJeZs9ZoaP/R7MU0gE8WG5ba9nKaRE02poq7Z23cxUwKPcuQqCRzjNxxyOfAHwLB/ul5+TIyzRmLIjtogVX4FRSqUzxLtDANAq9GGKrW4S24OqdOEHDa+JO2F8w4f+ahsesbFCzysM2j/SbAwUPb4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715189008; c=relaxed/simple;
	bh=DdEbrmV12mO9i+RsllKAzcDA3pXNQrL/G3gM96eJklE=;
	h=Date:To:From:Subject:Message-Id; b=rC6qCwNPx0021pKc4d5/sSp8oE2mj/Lqunm2oZGwVPLtDX9khjE6w6wK9i6v9tEvmkIDlPtw3stds2e09E2hQMwU3WZsxAbAZc7O+CBjFQO4OSFPM828gSyP7BVNSeuicK0nRs1jBoFZVq7L8V8zGGoFhA2CIfsngulIdpjQ4ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=e8ezvMNn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="e8ezvMNn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58035C113CC;
	Wed,  8 May 2024 17:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1715189008;
	bh=DdEbrmV12mO9i+RsllKAzcDA3pXNQrL/G3gM96eJklE=;
	h=Date:To:From:Subject:From;
	b=e8ezvMNndZeSdUXG/uUTIgMOWZAbCzG1x4ywO33JpS5Motw2IBnNh0ri2e4cp+N5d
	 /2waZGugWpYHJ8KZPeH/9SvYlytuwcDMmkH0cCC19cBWr90Hue2HOjeJ4jkn7ZwcIW
	 QPZiB8ujlCe1vLpqOseU/ejB0ZkJcc8dsVmIFk80=
Date: Wed, 08 May 2024 10:23:27 -0700
To: mm-commits@vger.kernel.org,nao.horiguchi@gmail.com,linmiaohe@huawei.com,jane.chu@oracle.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-memory-failure-send-sigbus-in-the-event-of-thp-split-fail-fix.patch removed from -mm tree
Message-Id: <20240508172328.58035C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-memory-failure-send-sigbus-in-the-event-of-thp-split-fail-fix
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-send-sigbus-in-the-event-of-thp-split-fail-fix.patch

This patch was dropped because it was folded into mm-memory-failure-send-sigbus-in-the-event-of-thp-split-fail.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memory-failure-send-sigbus-in-the-event-of-thp-split-fail-fix
Date: Thu May  2 04:07:39 PM PDT 2024

update for folio conversions

Cc: Jane Chu <jane.chu@oracle.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-send-sigbus-in-the-event-of-thp-split-fail-fix
+++ a/mm/memory-failure.c
@@ -2170,16 +2170,15 @@ out:
  * election for MCE early killed will be honored.
  */
 static int kill_procs_now(struct page *p, unsigned long pfn, int flags,
-			struct page *hpage)
+			struct folio *folio)
 {
-	struct folio *folio = page_folio(hpage);
 	LIST_HEAD(tokill);
 	int res = -EHWPOISON;
 
 	/* deal with user pages only */
 	if (PageReserved(p) || PageSlab(p) || PageTable(p) || PageOffline(p))
 		res = -EBUSY;
-	if (!(PageLRU(hpage) || PageHuge(p)))
+	if (!(folio_test_lru(folio) || PageHuge(p)))
 		res = -EBUSY;
 
 	if (res == -EHWPOISON) {
@@ -2324,7 +2323,7 @@ try_again:
 		if (try_to_split_thp_page(p) < 0) {
 			if (flags & MF_ACTION_REQUIRED) {
 				pr_err("%#lx: thp split failed\n", pfn);
-				res = kill_procs_now(p, pfn, flags, hpage);
+				res = kill_procs_now(p, pfn, flags, folio);
 				goto unlock_mutex;
 			}
 			res = action_result(pfn, MF_MSG_UNSPLIT_THP, MF_IGNORED);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memory-failure-send-sigbus-in-the-event-of-thp-split-fail.patch
__mod_memcg_lruvec_state-enhance-diagnostics.patch
__mod_memcg_lruvec_state-enhance-diagnostics-fix.patch

