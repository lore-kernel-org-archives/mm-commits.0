Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DA3342A8B
	for <mm-commits@vger.kernel.org>; Wed, 30 Oct 2024 01:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730251768; cv=none; b=p8pTn+QIeB3ZnKAR6wTspfoB7foT5UyErGuQnCBw3LMARk2i1e0XJ9HmE7Rve/bKyRVUDYD9GV8ZvBsmXtL7JDnIqO4N39nYZDhO3EF2dZOLXfl3t5mIRR0rhsj5v0EuixnE1IecwHM3YFWq2Axz1iFddFfreDo3Z4uC4fyPKuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730251768; c=relaxed/simple;
	bh=NIeAbjh6CQ77F9azQatRaqj2lY2CH8kLj9pvkxNbWC4=;
	h=Date:To:From:Subject:Message-Id; b=QQEyCuZL3z0eIWCUyatKqktiEalzqITFwvP5yInzTURPIs0rEH8Ho0YyJ9+ZE35hoh5Wczwnf2DsOyymY9HiqwnWsZcLbjgtY/hCiQdYZ337vdph4p9hC8y9SHeIFg37PsEf3xdXTU4ogzDCiau50eYrc70E70Lr2o5KYdI2j0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=G2+oraYS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="G2+oraYS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 932D2C4CECD;
	Wed, 30 Oct 2024 01:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730251765;
	bh=NIeAbjh6CQ77F9azQatRaqj2lY2CH8kLj9pvkxNbWC4=;
	h=Date:To:From:Subject:From;
	b=G2+oraYSgZ9fZlTiVu0Jv1hW/eYyboFThUK1S4GgP4Z7ZE0iUnwpKWdsIOy6xTNbs
	 ZZuWmTxOvp0i4cpcO1AIFQNI0ild7sa7fk/3JmVBMXQ0RMRpsZbS9nEZsUaY/G0uLd
	 O6TYMsyTJz5EybmrqkVbs9FPwJpPdLe2J/UQEdx0=
Date: Tue, 29 Oct 2024 18:29:25 -0700
To: mm-commits@vger.kernel.org,yanzhen@vivo.com,yang.lee@linux.alibaba.com,rppt@kernel.org,osalvador@suse.de,mtodorovac69@gmail.com,jakobkoschel@gmail.com,h.j.bos@vu.nl,hbathini@linux.ibm.com,david@redhat.com,c.giuffrida@vu.nl,bjohannesmeyer@gmail.com,bhe@redhat.com,agordeev@linux.ibm.com,adobriyan@gmail.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-proc-kcorec-fix-coccinelle-reported-error-instances-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20241030012925.932D2C4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs-proc-kcorec-fix-coccinelle-reported-error-instances-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fs-proc-kcorec-fix-coccinelle-reported-error-instances-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-proc-kcorec-fix-coccinelle-reported-error-instances-fix.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs-proc-kcorec-fix-coccinelle-reported-error-instances-fix
Date: Tue Oct 29 06:25:57 PM PDT 2024

s/tmp/pos/

Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: "Bos, H.J." <h.j.bos@vu.nl>
Cc: "Brian Johannesmeyer" <bjohannesmeyer@gmail.com>
Cc: Cristiano Giuffrida <c.giuffrida@vu.nl>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hari Bathini <hbathini@linux.ibm.com>
Cc: Jakob Koschel <jakobkoschel@gmail.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Mirsad Todorovac <mtodorovac69@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Yang Li <yang.lee@linux.alibaba.com>
Cc: Yan Zhen <yanzhen@vivo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/kcore.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/fs/proc/kcore.c~fs-proc-kcorec-fix-coccinelle-reported-error-instances-fix
+++ a/fs/proc/kcore.c
@@ -493,13 +493,13 @@ static ssize_t read_kcore_iter(struct ki
 		 * the previous entry, search for a matching entry.
 		 */
 		if (!m || start < m->addr || start >= m->addr + m->size) {
-			struct kcore_list *tmp;
+			struct kcore_list *pos;
 
 			m = NULL;
-			list_for_each_entry(tmp, &kclist_head, list) {
-				if (start >= tmp->addr &&
-				    start < tmp->addr + tmp->size) {
-					m = tmp;
+			list_for_each_entry(pos, &kclist_head, list) {
+				if (start >= pos->addr &&
+				    start < pos->addr + pos->size) {
+					m = pos;
 					break;
 				}
 			}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-keep-track-of-free-highatomic-fix.patch
mm-consolidate-common-checks-in-hugetlb_get_unmapped_area-fix.patch
mm-memoryc-remove-stray-newline-at-top-of-file.patch
bootmem-stop-using-page-index-fix.patch
mm-kasan-kmsan-copy_from-to_kernel_nofault-fix.patch
tools-mm-free-the-allocated-memory-fix.patch
memcg-v1-no-need-for-memcg-locking-for-mglru-fix.patch
mm-vma-the-pgoff-is-correct-if-can_merge_right-fix.patch
memcg-workingset-remove-folio_memcg_rcu-usage-fix.patch
fs-proc-kcorec-fix-coccinelle-reported-error-instances-fix.patch

