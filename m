Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CB0831A81F
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 04:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769486754; cv=none; b=LUveMt7b8hPmoSMJK4xjzaO+Rj6iHhv6jXne7idXTi37VO1m5mhNdh/HqYzO9WzLlobWWfmd2qtFMxe61irjW34auFJB9Ytr4bkWyfC3LOJTDvtpOOybyCzmzWxTKfC5qxEojjNUS0XsqztKenOJORdvWvxPsDjvTbwc4k96Zk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769486754; c=relaxed/simple;
	bh=RHqu8W0aKytbpmWcpjI6IURNDt7KD+kuaNGB/T5EHTU=;
	h=Date:To:From:Subject:Message-Id; b=iWGMlzkJXmvaabDvO8dVAL9yEFhETbL00FdoDQZ+JKv1ZMZ8nW+TQTDA51tfsx8pEVekw41OFdoL6Jf8xRe2orc/uCF/dkF4hhvAN/AEUOSZ4JzvcNSEvJp6uO0c7VE84IQXyzsuZO4K82ZZgY0YWlBeKtc/ycwsuI9Qg7Fyrao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iLLbjN8B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iLLbjN8B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75677C116C6;
	Tue, 27 Jan 2026 04:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769486754;
	bh=RHqu8W0aKytbpmWcpjI6IURNDt7KD+kuaNGB/T5EHTU=;
	h=Date:To:From:Subject:From;
	b=iLLbjN8BpIwHO8HSutmrTyNLboiEgGYtAheHBUaKeMQZYbI2iRBoUN1R3zGfbQWIM
	 diajQqhyHixh+9EhBjqtfJTBJi+dkNL5/t7CyIN2olHXBsEf3JM+IjRAXVqXgelCc8
	 KF8+PrmUG/j+VlzSfUe0mLx7/W8800WlzX/ukw8o=
Date: Mon, 26 Jan 2026 20:05:53 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yury.norov@gmail.com,ying.huang@linux.alibaba.com,vbabka@suse.cz,tj@kernel.org,surenb@google.com,rppt@kernel.org,rakie.kim@sk.com,mkoutny@suse.com,mhocko@suse.com,matthew.brost@intel.com,lorenzo.stoakes@oracle.com,longman@redhat.com,linux@rasmusvillemoes.dk,liam.howlett@oracle.com,joshua.hahnjy@gmail.com,hannes@cmpxchg.org,gourry@gourry.net,david@kernel.org,byungchul@sk.com,apopple@nvidia.com,ynorov@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] nodemask-propagate-boolean-for-nodes_andnot.patch removed from -mm tree
Message-Id: <20260127040554.75677C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nodemask: propagate boolean for nodes_and{,not}
has been removed from the -mm tree.  Its filename was
     nodemask-propagate-boolean-for-nodes_andnot.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yury Norov <ynorov@nvidia.com>
Subject: nodemask: propagate boolean for nodes_and{,not}
Date: Wed, 14 Jan 2026 12:22:13 -0500

Patch series "nodemask: align nodes_and{,not} with underlying bitmap ops".

nodes_and{,not} are void despite that underlying bitmap_and(,not) return
boolean, true if the result bitmap is non-empty.  Align nodemask API, and
simplify client code.


This patch (of 3):

Bitmap functions bitmap_and{,not} return boolean depending on emptiness of
the result bitmap.  The corresponding nodemask helpers ignore the returned
value.

Propagate the underlying bitmaps result to nodemasks users, as it
simplifies user code.

Link: https://lkml.kernel.org/r/20260114172217.861204-1-ynorov@nvidia.com
Link: https://lkml.kernel.org/r/20260114172217.861204-2-ynorov@nvidia.com
Signed-off-by: Yury Norov <ynorov@nvidia.com>
Reviewed-by: Gregory Price <gourry@gourry.net>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Reviewed-by: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mathew Brost <matthew.brost@intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Waiman Long <longman@redhat.com>
Cc: Yury Norov (NVIDIA) <yury.norov@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/nodemask.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/include/linux/nodemask.h~nodemask-propagate-boolean-for-nodes_andnot
+++ a/include/linux/nodemask.h
@@ -157,10 +157,10 @@ static __always_inline bool __node_test_
 
 #define nodes_and(dst, src1, src2) \
 			__nodes_and(&(dst), &(src1), &(src2), MAX_NUMNODES)
-static __always_inline void __nodes_and(nodemask_t *dstp, const nodemask_t *src1p,
+static __always_inline bool __nodes_and(nodemask_t *dstp, const nodemask_t *src1p,
 					const nodemask_t *src2p, unsigned int nbits)
 {
-	bitmap_and(dstp->bits, src1p->bits, src2p->bits, nbits);
+	return bitmap_and(dstp->bits, src1p->bits, src2p->bits, nbits);
 }
 
 #define nodes_or(dst, src1, src2) \
@@ -181,10 +181,10 @@ static __always_inline void __nodes_xor(
 
 #define nodes_andnot(dst, src1, src2) \
 			__nodes_andnot(&(dst), &(src1), &(src2), MAX_NUMNODES)
-static __always_inline void __nodes_andnot(nodemask_t *dstp, const nodemask_t *src1p,
+static __always_inline bool __nodes_andnot(nodemask_t *dstp, const nodemask_t *src1p,
 					const nodemask_t *src2p, unsigned int nbits)
 {
-	bitmap_andnot(dstp->bits, src1p->bits, src2p->bits, nbits);
+	return bitmap_andnot(dstp->bits, src1p->bits, src2p->bits, nbits);
 }
 
 #define nodes_copy(dst, src) __nodes_copy(&(dst), &(src), MAX_NUMNODES)
_

Patches currently in -mm which might be from ynorov@nvidia.com are

kernelh-drop-stack_magic-macro.patch
moduleparam-include-required-headers-explicitly.patch
kernelh-move-verify_octal_permissions-to-sysfsh.patch
kernelh-include-linux-instruction_pointerh-explicitly.patch
tracing-move-tracing-declarations-from-kernelh-to-a-dedicated-header.patch

