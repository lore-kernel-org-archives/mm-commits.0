Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DDAC3CCA1E
	for <mm-commits@vger.kernel.org>; Wed,  4 Mar 2026 17:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772646323; cv=none; b=VUKFDoYpE8T34SLhjk+Oa2RQV1B+9NdScqcD4XNx7tbE9bju61WbCE2egv/Rwom6j3z0KTK+j3hgz4vpD1M0Ufcoc2YHeDbrjVM/aql08yhfAz0z1IREcY2h808XZTvhNmF9xGggVMl8Z0pXaW42UmJpqgR9eHmjkmto7DwxCCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772646323; c=relaxed/simple;
	bh=sXdUa81EhiPJoZ61WryDTDKbGHV4/fQDZBBau7dgGlU=;
	h=Date:To:From:Subject:Message-Id; b=ouNhwlPyqmq6Q4Uhn7KgLFJgpj49+OhEPt7foL+p+B7whjb3Idm8W+Q9cqm7ZbAzA4E+WJiair9BKnFUUuY3IMvUstvuGrKkRMLfkQwpdaFRX9Wimom7p2Wris0wyP0hBJTS3GwxWm7bSlSPxJsL+3TYmzYkY5h1RTP/AiqU51E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1kvKw/Z0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1kvKw/Z0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04479C2BC86;
	Wed,  4 Mar 2026 17:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772646323;
	bh=sXdUa81EhiPJoZ61WryDTDKbGHV4/fQDZBBau7dgGlU=;
	h=Date:To:From:Subject:From;
	b=1kvKw/Z06pPRpnnEqNHlOUuO4BeSNA9OzgUt8GlSyRDyuKJHVP6py6B/drFjbfpnP
	 U/fHdTMAk813JfsHguup9W3zBEV9DpcvXtW4yNYn6MFGzBxdCD7i6Os6ifdJSzc9BS
	 iRzCLfCp5Yz6urTzaQCwkEeMVEPW0+TtFPHSOzLc=
Date: Wed, 04 Mar 2026 09:45:22 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,jgg@nvidia.com,david@kernel.org,rdunlap@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-mmu_notifier-clean-up-mmu_notifierh-kernel-doc.patch removed from -mm tree
Message-Id: <20260304174523.04479C2BC86@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mmu_notifier: clean up mmu_notifier.h kernel-doc
has been removed from the -mm tree.  Its filename was
     mm-mmu_notifier-clean-up-mmu_notifierh-kernel-doc.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: mm/mmu_notifier: clean up mmu_notifier.h kernel-doc
Date: Sun, 1 Mar 2026 16:52:22 -0800

Eliminate kernel-doc warnings in mmu_notifier.h:
- add a missing struct short description
- use the correct format for function parameters
- add missing function return comment sections

Warning: include/linux/mmu_notifier.h:236 missing initial short
 description on line: * struct mmu_interval_notifier_ops
Warning: include/linux/mmu_notifier.h:325 function parameter 'interval_sub'
 not described in 'mmu_interval_set_seq'
Warning: include/linux/mmu_notifier.h:325 function parameter 'cur_seq'
 not described in 'mmu_interval_set_seq'
Warning: include/linux/mmu_notifier.h:346 function parameter 'interval_sub'
 not described in 'mmu_interval_read_retry'
Warning: include/linux/mmu_notifier.h:346 function parameter 'seq' not
 described in 'mmu_interval_read_retry'
Warning: include/linux/mmu_notifier.h:346 No description found for return
 value of 'mmu_interval_read_retry'
Warning: include/linux/mmu_notifier.h:370 function parameter 'interval_sub'
 not described in 'mmu_interval_check_retry'
Warning: include/linux/mmu_notifier.h:370 function parameter 'seq' not
 described in 'mmu_interval_check_retry'
Warning: include/linux/mmu_notifier.h:370 No description found for return
 value of 'mmu_interval_check_retry'

Link: https://lkml.kernel.org/r/20260302005222.3470783-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmu_notifier.h |   31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

--- a/include/linux/mmu_notifier.h~mm-mmu_notifier-clean-up-mmu_notifierh-kernel-doc
+++ a/include/linux/mmu_notifier.h
@@ -234,7 +234,7 @@ struct mmu_notifier {
 };
 
 /**
- * struct mmu_interval_notifier_ops
+ * struct mmu_interval_notifier_ops - callback for range notification
  * @invalidate: Upon return the caller must stop using any SPTEs within this
  *              range. This function can sleep. Return false only if sleeping
  *              was required but mmu_notifier_range_blockable(range) is false.
@@ -309,8 +309,8 @@ void mmu_interval_notifier_remove(struct
 
 /**
  * mmu_interval_set_seq - Save the invalidation sequence
- * @interval_sub - The subscription passed to invalidate
- * @cur_seq - The cur_seq passed to the invalidate() callback
+ * @interval_sub: The subscription passed to invalidate
+ * @cur_seq: The cur_seq passed to the invalidate() callback
  *
  * This must be called unconditionally from the invalidate callback of a
  * struct mmu_interval_notifier_ops under the same lock that is used to call
@@ -329,8 +329,8 @@ mmu_interval_set_seq(struct mmu_interval
 
 /**
  * mmu_interval_read_retry - End a read side critical section against a VA range
- * interval_sub: The subscription
- * seq: The return of the paired mmu_interval_read_begin()
+ * @interval_sub: The subscription
+ * @seq: The return of the paired mmu_interval_read_begin()
  *
  * This MUST be called under a user provided lock that is also held
  * unconditionally by op->invalidate() when it calls mmu_interval_set_seq().
@@ -338,7 +338,7 @@ mmu_interval_set_seq(struct mmu_interval
  * Each call should be paired with a single mmu_interval_read_begin() and
  * should be used to conclude the read side.
  *
- * Returns true if an invalidation collided with this critical section, and
+ * Returns: true if an invalidation collided with this critical section, and
  * the caller should retry.
  */
 static inline bool
@@ -350,20 +350,21 @@ mmu_interval_read_retry(struct mmu_inter
 
 /**
  * mmu_interval_check_retry - Test if a collision has occurred
- * interval_sub: The subscription
- * seq: The return of the matching mmu_interval_read_begin()
+ * @interval_sub: The subscription
+ * @seq: The return of the matching mmu_interval_read_begin()
  *
  * This can be used in the critical section between mmu_interval_read_begin()
- * and mmu_interval_read_retry().  A return of true indicates an invalidation
- * has collided with this critical region and a future
- * mmu_interval_read_retry() will return true.
- *
- * False is not reliable and only suggests a collision may not have
- * occurred. It can be called many times and does not have to hold the user
- * provided lock.
+ * and mmu_interval_read_retry().
  *
  * This call can be used as part of loops and other expensive operations to
  * expedite a retry.
+ * It can be called many times and does not have to hold the user
+ * provided lock.
+ *
+ * Returns: true indicates an invalidation has collided with this critical
+ * region and a future mmu_interval_read_retry() will return true.
+ * False is not reliable and only suggests a collision may not have
+ * occurred.
  */
 static inline bool
 mmu_interval_check_retry(struct mmu_interval_notifier *interval_sub,
_

Patches currently in -mm which might be from rdunlap@infradead.org are

build_bugh-correct-function-parameters-names-in-kernel-doc.patch

