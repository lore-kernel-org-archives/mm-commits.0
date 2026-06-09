Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BBF6302149;
	Tue,  9 Jun 2026 01:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780968161; cv=none; b=XZrlIfOJYtguajWgIKlvvkHh91eBzgGtiRrp/+H1UTf9rrtUoyrs/OKvoiyWMOM6gXipcoosleLpFPuqNQ0h2BJSOzanokwEQHgZpgYebmuYJcNXhyaRoNK9O++q8iuwuKmHsKEh64jeWJqKijiL1SOfDjzqr9cOCeQ18lJjhsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780968161; c=relaxed/simple;
	bh=AWiOKdSj72+PAwlsJ9BKqQsbbIEjHljQGiERb+q841Q=;
	h=Date:To:From:Subject:Message-Id; b=Ged7rcAv30ubKzQQtnJIO4HR+QNUcPBJdPVTXWZXKM1SZ8DcEPFs0XHmbkXWpRI5r2JsO7Pockgmn/b9H0m2y1feFqLdiWcsbzTADCIociN6+jpjV6O/rVuqJMQ20WFlpXTMxGsAZT5ccVGpWvEUPX8/yGOgYiHK8Nk00yFu1Dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=a53NEWN2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="a53NEWN2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC5FB1F00893;
	Tue,  9 Jun 2026 01:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780968159;
	bh=IQA9wbwxJsBE1ih9KMGF9DbkXuIw4ptNuJdWl4LUHUU=;
	h=Date:To:From:Subject;
	b=a53NEWN2iTkw/ifTNUtdjIue+lT42Bn3V28SKUX0pNjalv/v9uu5ntGwVIF3DbSEY
	 NvFuf+XOOv+s6zTyq4IeL7C8B1PExJZML7SNwrVsPrCYQGb9WWP+SZyc5XNHFVJt0P
	 4DbpyAZgLCLV381iKc8s474AWXW3As8kS4ATHtV8=
Date: Mon, 08 Jun 2026 18:22:39 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,sashiko-bot@kernel.org,rppt@kernel.org,peterx@redhat.com,mhocko@suse.com,ljs@kernel.org,david@kernel.org,balbirs@nvidia.com,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] userfaultfd-gate-must_wait-writability-check-on-pte_present.patch removed from -mm tree
Message-Id: <20260609012239.CC5FB1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: userfaultfd: gate must_wait writability check on pte_present()
has been removed from the -mm tree.  Its filename was
     userfaultfd-gate-must_wait-writability-check-on-pte_present.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: userfaultfd: gate must_wait writability check on pte_present()
Date: Fri, 29 May 2026 18:23:29 +0100

userfaultfd_must_wait() and userfaultfd_huge_must_wait() read the PTE
without taking the page table lock and then apply pte_write() /
huge_pte_write() to it.  Those accessors decode bits from the present
encoding only; on a swap or migration entry they read the offset bits that
happen to share the same position and return an undefined result.

The intent of the check is "is this fault still WP-blocked?".  A
non-marker swap entry means the page is in transit -- the userfault
context the original fault delivered against is no longer the same, and
the swap-in or migration completion path will re-deliver a fresh fault if
userspace still needs to handle it.  Worst case under the current code the
garbage write bit says "wait", and the thread stays asleep until a
UFFDIO_WAKE that may never arrive.

Gate the writability check on pte_present() so the lockless re-check only
inspects present-PTE bits when the entry is actually present.  The
non-present, non-marker case returns "don't wait" and lets the fault path
retry.

Link: https://lore.kernel.org/20260529172331.356655-6-kas@kernel.org
Fixes: 369cd2121be4 ("userfaultfd: hugetlbfs: userfaultfd_huge_must_wait for hugepmd ranges")
Fixes: 63b2d4174c4a ("userfaultfd: wp: add the writeprotect API to userfaultfd ioctl")
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Reported-by: Sashiko AI review <sashiko-bot@kernel.org>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/mm/userfaultfd.c~userfaultfd-gate-must_wait-writability-check-on-pte_present
+++ a/mm/userfaultfd.c
@@ -2543,6 +2543,15 @@ static inline bool userfaultfd_huge_must
 	if (pte_is_uffd_marker(pte))
 		return true;
 	/*
+	 * Concurrent migration may have replaced the present PTE with a
+	 * non-marker swap entry between fault delivery and this lockless
+	 * re-check. huge_pte_write() on a swap entry decodes random offset
+	 * bits, so gate it on pte_present(). The migration completion path
+	 * will re-deliver the fault if it still needs userspace.
+	 */
+	if (!pte_present(pte))
+		return false;
+	/*
 	 * If VMA has UFFD WP faults enabled and WP fault, wait for userspace to
 	 * resolve the fault.
 	 */
@@ -2629,6 +2638,17 @@ again:
 	if (pte_is_uffd_marker(ptent))
 		goto out;
 	/*
+	 * Concurrent swap-out / migration may have replaced the present PTE
+	 * with a non-marker swap entry between fault delivery and this
+	 * lockless re-check. pte_write() on a swap entry decodes random
+	 * offset bits, so gate it on pte_present(). The page-in path will
+	 * re-deliver the fault if it still needs userspace.
+	 */
+	if (!pte_present(ptent)) {
+		ret = false;
+		goto out;
+	}
+	/*
 	 * If VMA has UFFD WP faults enabled and WP fault, wait for userspace to
 	 * resolve the fault.
 	 */
_

Patches currently in -mm which might be from kas@kernel.org are


