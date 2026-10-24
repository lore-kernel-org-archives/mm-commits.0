Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832321;
	b=QOssXnlZbTltistQ9LD0CZTmy02SkvLAuYAQbstasJ12zYwQs96xi1VD8jEnsjZIYZJb
	 kOlFFBIwCe4NyYgdUFyH/5KXyddx277B3fpQIR2Tb0tvCI4aGeLRgutm8PFccYTC/DlWd
	 TyZmyZQEWt/eWL4FCc0/9Y9enXFzkUZQCvQ1Gao6TLnWCsApNZORVyfaomnJZhQSFantU
	 3ySq579jgZ0MY2yjwyLcpqnsQowl5YGy8CSsn/dfEB5CmZ7i78FEl3IjHKVR315K7STl5
	 SrNoNL/DLRqAjSH9EP9XmhmXL5/Abtl6JdY1gxbafisGVo59aIy0IwAcAmJSqmEBCHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832321;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=F4Sqe90KnH/C/7qklocGJMNU0QVQCloS6uIui5FIm0w=;
	b=1AXWcQ34cROb/kPAs/oFWnAMKnDMPO3mkh27QbXcr9NXguMgE2hWITrPULguEFCsayLq
	 r1Oe9y496roR6+DPem9HmYS5E0FbOLp88TjuRj/AO1Ws69cwHeJdJ8Dh3z/4rTu77qX7e
	 ZEh3ElZPjtl5lOkEZ3Zdk+eLJqtuBhqpwY17jwT/vZPJ7QOxoRQQf1L5QuEjQxm0aqwO1
	 k2MbdO2JnQC0Y3lq0kNWf+2uF4UZrdCPI9ruj6n4ziOscQfoufly1DSFzaRNVls82QPRp
	 AgTyCujXt5mAXpl1tMIDzFttCIIVbclGbo0V5QX1gXeI71nQYBJ4yZDL4a50fIs/V9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=NqISGbhC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D41B4606A31B
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 08:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=NqISGbhC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D49A1F01828;
	Sat, 24 Oct 2026 08:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832320;
	bh=F4Sqe90KnH/C/7qklocGJMNU0QVQCloS6uIui5FIm0w=;
	h=Date:To:From:Subject;
	b=NqISGbhCQzFFCvGEuVmbzq9lgtdd8LwnN5QeJElbox4bifk2XRGZi/reZP1J67lYp
	 DKMb8eke0i3hl6B1MzCoh148bOxbe2HkbzuCMl4y9fuuZ7MK1mN7MUx08EUOSr+meq
	 4yJXsUt8x+ujOExWKSgWI9q8JA4awY/dLwHBVw50=
Date: Sat, 24 Oct 2026 01:58:40 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,skhan@linuxfoundation.org,rppt@kernel.org,rdunlap@infradead.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-design-document-damos-quota-goal-complement-flag.patch removed from -mm tree
Message-Id: <20261024085840.9D49A1F01828@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: Docs/mm/damon/design: document damos quota goal complement flag
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-design-document-damos-quota-goal-complement-flag.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: Docs/mm/damon/design: document damos quota goal complement flag
Date: Tue, 29 Sep 2026 01:01:09 -0700

Update DAMON design document for the newly added damos quota goal metric
value complement flag.

Link: https://lore.kernel.org/20260929080113.41708-7-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 Documentation/mm/damon/design.rst |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-document-damos-quota-goal-complement-flag
+++ a/Documentation/mm/damon/design.rst
@@ -702,10 +702,10 @@ There are two such tuning algorithms tha
   that the zero quota is a valid quota, and therefore ``qt_exceeds`` :ref:`stat
   <damon_design_damos_stat>` will keep increasing in this case.
 
-The goal can be specified with five parameters, namely ``target_metric``,
-``target_value``, ``current_value``, ``nid`` and ``path``.  The auto-tuning
-mechanism tries to make ``current_value`` of ``target_metric`` be same to
-``target_value``.
+The goal can be specified with six parameters, namely ``target_metric``,
+``complement``, ``target_value``, ``current_value``, ``nid`` and ``path``.  The
+auto-tuning mechanism tries to make ``current_value`` of ``complement``-ed
+``target_metric`` be same to ``target_value``.
 
 - ``user_input``: User-provided value.  Users could use any metric that they
   has interest in for the value.  Use space main workload's latency or
@@ -733,6 +733,13 @@ mechanism tries to make ``current_value`
 - ``hugepage_mem_bp``: Total huge page to total used memory ratio in bp
   (1/10,000).
 
+``complement`` is a boolean parameter that determines whether to use
+complemented value of the target metric.  For example, if ``complement`` is set
+and target metric is ``active_mem_bp``, it is effectively same to
+``inactive_mem_bp``.  ``complement`` is no-op when the target metric type is
+``user_input``.  For the metric type, the user should be able to emit
+complemented metric values on their own.
+
 ``nid`` is optionally required for ``node_mem_used_bp``, ``node_mem_free_bp``,
 ``node_memcg_used_bp``, ``node_memcg_free_bp`` and ``node_eligible_mem_bp`` to
 point the specific NUMA node.
_

Patches currently in -mm which might be from sj@kernel.org are


