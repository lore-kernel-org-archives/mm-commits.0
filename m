Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0698210FB
	for <mm-commits@vger.kernel.org>; Tue, 12 Dec 2023 18:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="n2V3tyPi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57801C433C7;
	Tue, 12 Dec 2023 18:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702407255;
	bh=67auzDNFn3MnFlsT+eH+x5LXqd4MN89kVeseyGq7q84=;
	h=Date:To:From:Subject:From;
	b=n2V3tyPigbIOfcgW4L725LwKMdRQcZm9xdpe4G34F9jsPlZNWpP/En9uEhQyb14pL
	 KLp70dm03q1y0ccTj6SGTAS4YM/D2q9R80K845gx8h9CHfI8YzFPNk39DWLcxXAxQX
	 HDK9Xexq2Xeaa2/yhtL8e6ptG0F21c9JE2malR6Q=
Date: Tue, 12 Dec 2023 10:54:14 -0800
To: mm-commits@vger.kernel.org,longman@redhat.com,catalin.marinas@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] kmemleak-avoid-rcu-stalls-when-freeing-metadata-for-per-cpu-pointers-v2.patch removed from -mm tree
Message-Id: <20231212185415.57801C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kmemleak-avoid-rcu-stalls-when-freeing-metadata-for-per-cpu-pointers-v2
has been removed from the -mm tree.  Its filename was
     kmemleak-avoid-rcu-stalls-when-freeing-metadata-for-per-cpu-pointers-v2.patch

This patch was dropped because it was folded into kmemleak-avoid-rcu-stalls-when-freeing-metadata-for-per-cpu-pointers.patch

------------------------------------------------------
From: Catalin Marinas <catalin.marinas@arm.com>
Subject: kmemleak-avoid-rcu-stalls-when-freeing-metadata-for-per-cpu-pointers-v2
Date: Wed, 6 Dec 2023 11:44:14 +0000

update the comment to include the *_percpu() callbacks, not just the *_phys()

Link: https://lkml.kernel.org/r/20231206114414.2085824-1-catalin.marinas@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Reported-by: Waiman Long <longman@redhat.com>
Reviewed-by: Waiman Long <longman@redhat.com>
Link: https://lore.kernel.org/r/20231127194153.289626-1-longman@redhat.com
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/kmemleak.c~kmemleak-avoid-rcu-stalls-when-freeing-metadata-for-per-cpu-pointers-v2
+++ a/mm/kmemleak.c
@@ -21,8 +21,8 @@
  *   red black trees used to look-up metadata based on a pointer to the
  *   corresponding memory block. The kmemleak_object structures are added to
  *   the object_list and the object tree root in the create_object() function
- *   called from the kmemleak_alloc() (or kmemleak_alloc_phys()) callback and
- *   removed in delete_object() called from the kmemleak_free() callback
+ *   called from the kmemleak_alloc{,_phys,_percpu}() callback and removed in
+ *   delete_object() called from the kmemleak_free{,_phys,_percpu}() callback
  * - kmemleak_object.lock (raw_spinlock_t): protects a kmemleak_object.
  *   Accesses to the metadata (e.g. count) are protected by this lock. Note
  *   that some members of this structure may be protected by other means
_

Patches currently in -mm which might be from catalin.marinas@arm.com are

kmemleak-avoid-rcu-stalls-when-freeing-metadata-for-per-cpu-pointers.patch

