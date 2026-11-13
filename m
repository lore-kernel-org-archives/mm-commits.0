Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794538106;
	b=U9XNrihs2vX4bObfXh72LtLbu/mwBqPiqi1oAhcNU64GRaxlmjRxfirAqvR9CY6rI5h4
	 mTZNLISE73vbkLVT6U9oGR4jPlS3OoZfH+nIa7MhMBJbSuGSwU5LYW+SmIwtPXgV3urjR
	 kuSa7f+nXl9gPIsZMSR6SzvWEsD5FKy6ncKrGrhszyPe3LBYyM78AewFEWNqW7mbD4aXK
	 ilaUvAi6csT5J04NCwuqs6vCIQJ+koqTkCDabbSeFAIlvPVc15kwPer5Qr0ymm+E/fV5c
	 POYEgBfYK32GwMNivDmE99vPZW5d7C1CzqZwzGBH+QlpXWYESRHItLaSsC4RQskYA4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794538106;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=I+dGkrjBPqL2FU3aleoPSPTED6sd0gsnAxrJjS9QbUE=;
	b=3fn/GqramtovD7eSismKxsI7tm5VKr72tnxV1xA0omkuliWNAORI8CTw1F65BmyTcWvG
	 MSKusi52PTvYc0eUvQhRkN7RXKYS7yml+dP2ECeDnxxlLQS79uXE6rkzbRQUf5InmvUaM
	 gxTqHtBIMvXZ52EvQPBDL4L410O5TQ/PVJSisgSkjhcAAzcG0aq+A1TNdlRTZ6mKSGdF7
	 L7mVvZYlS+/9I/Vc6FmodjUCiC48wIQvN/OzpuZE6SahfBqCjZ6hMslXSUcITY/PUbJct
	 0KY79T8YD+y1J6xWX4IIXKa0Y5kEbpZhsP8rckm9nKPoMYJJxXpr6XBPTSqDrQCBMTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=x7wru82R;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26663606A321
	for <mm-commits@vger.kernel.org>; Fri, 13 Nov 2026 02:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=x7wru82R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9295A1F000C5;
	Fri, 13 Nov 2026 02:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794538105;
	bh=I+dGkrjBPqL2FU3aleoPSPTED6sd0gsnAxrJjS9QbUE=;
	h=Date:To:From:Subject;
	b=x7wru82RjMSSx6r2aoVeLxzMzRu7W8H3DyaP8+zjO9t26EJlsWmVS2KJ9SZdrH6Pa
	 x1VeStjyfwjf09QxUH1L+ADhv3dVhM3KDN5lSpRW7gEKC/jD+ocKxtlq48+MQ02Ls0
	 kPel9H6AU4p7A9CJWwApxFAmNYQ1aSMPkdfwGAX0=
Date: Thu, 12 Nov 2026 18:48:25 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,
	rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,
	david@kernel.org,aleszlucero@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-pagewalk-document-missing-struct-members.patch added to mm-new branch
Message-Id: <20261113024825.9295A1F000C5@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/pagewalk: document missing struct members
has been added to the -mm mm-new branch.  Its filename is
     mm-pagewalk-document-missing-struct-members.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-pagewalk-document-missing-struct-members.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Oscar Alejandro Sánchez Lucero <aleszlucero@gmail.com>
Subject: mm/pagewalk: document missing struct members
Date: Thu, 12 Nov 2026 18:44:07 -0600

Add missing kernel-doc entries for @walk_lock in struct mm_walk_ops, and
for @ptep, @pudp, @pmdp, and @vma in struct folio_walk.  Also fix @pte,
@pud, and @pmd descriptions to state they hold entry values, not pointers.

Link: https://lore.kernel.org/20261112-pagewalk-doc-v1-1-6cc5ce7148da@gmail.com
Signed-off-by: Oscar Alejandro Sánchez Lucero <aleszlucero@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
---

 include/linux/pagewalk.h |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/include/linux/pagewalk.h~mm-pagewalk-document-missing-struct-members
+++ a/include/linux/pagewalk.h
@@ -63,6 +63,8 @@ enum page_walk_lock {
  *                      install. If allocations fail, the walk is aborted. This
  *                      operation is only available for userland memory. Not
  *                      usable for hugetlb ranges.
+ * @walk_lock:          locking requirement during the page walk (see
+ *                      enum page_walk_lock).
  *
  * p?d_entry callbacks are called even if those levels are folded on a
  * particular architecture/configuration.
@@ -161,10 +163,14 @@ enum folio_walk_level {
  * struct folio_walk - folio_walk_start() / folio_walk_end() data
  * @page:	exact folio page referenced (if applicable)
  * @level:	page table level identifying the entry type
- * @pte:	pointer to the page table entry (FW_LEVEL_PTE).
- * @pmd:	pointer to the page table entry (FW_LEVEL_PMD).
- * @pud:	pointer to the page table entry (FW_LEVEL_PUD).
- * @ptl:	pointer to the page table lock.
+ * @ptep:	pointer to the page table entry (FW_LEVEL_PTE).
+ * @pudp:	pointer to the page table entry (FW_LEVEL_PUD).
+ * @pmdp:	pointer to the page table entry (FW_LEVEL_PMD).
+ * @pte:	page table entry value (FW_LEVEL_PTE).
+ * @pud:	page table entry value (FW_LEVEL_PUD).
+ * @pmd:	page table entry value (FW_LEVEL_PMD).
+ * @vma:	pointer to the VMA (for internal use only).
+ * @ptl:	pointer to the page table lock (for internal use only).
  *
  * (see folio_walk_start() documentation for more details)
  */
_

Patches currently in -mm which might be from aleszlucero@gmail.com are

mm-page_reporting-document-order-parameter-in-page_reporting_notify_free.patch
mm-pagewalk-document-missing-struct-members.patch

