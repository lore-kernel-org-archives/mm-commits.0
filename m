Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795550456;
	b=zHKPUv02QNsk3C8Va9UlIJPdDHcY+w3wG9n/J53Paw6t5WCzWcAZhv3X4yxmA/yuvuci
	 JkrOvR/i9qpiklXCA6ksnETqYHeAXbGUARlMYeJnC0d+qiX4i+2gP4xpMRSzW9WrdqOjL
	 nK90bIJQizTIyFqnpl0GFPEwS6md21gYaJp9l3LFKKCnaVimMBXMfIbwxqVcqpPoyCwxt
	 ySmZMw1vQ+g1G/VCNrPuWD7TZ3B//YRFwQO32UFhCuNPohY0r3pHw+i4kWmYumJBirzWb
	 L05qGxrQIOix8td8dbiJBGvWNdUwW0NQ42Uvr7X+se1HCOP1QapXSok9fYZGCsnAMBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795550456;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=+ay/K/mNcr8k8IbNvcPD9RCEgCZhKv81HHLp59px39k=;
	b=2reP4XF+B7TXuylFEEHPbD1pxRc23V/qKyfJXOC4/F9cevKiM/N2j2wZowvD/u5qGHsA
	 siH0tCJF0TrbXm5nuBdPetnjV5IynGPSXYkwrpI/T+mE5x8U4aJax6OHfd+KzkCaLPhfj
	 ZHfZzb6TkCOmniqRpyKd8PHPwJqDpmw0aoXXpTcIPaQqj0QQaCCmhGHoxJwvJuhX6D13n
	 2GuEJyP9O+qNYk96vMaXYdjRBgNjbl27XLQ/fDlSXpdUA1YWcUgprcSRKJeL8oYtybmn1
	 VmtuiHYp1TxUxBDdDoCVOr7BQf073O0AsoYo0yJQ5q/42I5bmtjKFDYQI6BnrR9pP8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=PtaZ3gnM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5DF9606A31E
	for <mm-commits@vger.kernel.org>; Tue, 24 Nov 2026 20:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=PtaZ3gnM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5707C1F000C4;
	Tue, 24 Nov 2026 20:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795550455;
	bh=+ay/K/mNcr8k8IbNvcPD9RCEgCZhKv81HHLp59px39k=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=PtaZ3gnMEQnxobQp8U2DwSFZJtDfFf7DOkL8Vvej56/OippftAEZZRF+2aGRnj0oY
	 1Bhu6uPOKOyE8xt4Wf2MuScC2uxmpDLB19ONdGYuY4A+RAZT0bwQC0GSQz7AQW+mCT
	 pCEOmXxBetXstzxbgB991dffbXLzrwXs4uvTcHi4=
Date: Tue, 24 Nov 2026 12:00:54 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,
	sj@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,
	liam@infradead.org,david@kernel.org,aleszlucero@gmail.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261112-pagewalk-doc-v1-1-6cc5ce7148da@gmail.com>
References: <20261112-pagewalk-doc-v1-1-6cc5ce7148da@gmail.com>
Subject: [merged mm/core.git: for-next] mm-pagewalk-document-missing-struct-members.patch removed from -mm tree
Message-Id: <20261124200055.5707C1F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/pagewalk: document missing struct members
has been removed from the -mm tree.  Its filename was
     mm-pagewalk-document-missing-struct-members.patch

This patch was dropped because it was merged into mm/core.git: for-next

------------------------------------------------------
From: Oscar Alejandro Sánchez Lucero <aleszlucero@gmail.com>
Subject: mm/pagewalk: document missing struct members
Date: Thu, 12 Nov 2026 18:44:07 -0600

Add missing kernel-doc entries for @walk_lock in struct mm_walk_ops, and
for @ptep, @pudp, @pmdp, and @vma in struct folio_walk.  Also fix @pte,
@pud, and @pmd descriptions to state they hold entry values, not pointers.

Link: https://patch.msgid.link/20261112-pagewalk-doc-v1-1-6cc5ce7148da@gmail.com
Signed-off-by: Oscar Alejandro Sánchez Lucero <aleszlucero@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>

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

