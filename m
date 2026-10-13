Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82B5647045E
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 04:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791865914; cv=none; b=qXOnKyCgCW/SsEKJjGZdSEpEj71s5QeRdfKaRCB0s6HR0QWLE8Ii17F011BaxskIsV/0q9nyDkYIeObLtFxtUD/ve7EQF68Q2aJizlBlK3NcJxB8xB4amJu11LX3CODQFkoFeEUkl7klXZpJzynRrN9RDCbQh/+eKIa2rdLsEuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791865914; c=relaxed/simple;
	bh=22LJWeH+7e7C6x67twn3XcQf6jEtAD2qpqaYnA01bKY=;
	h=Date:To:From:Subject:Message-Id; b=n2dF3JEyaEVudUMDxf97PqTWhtuxHLm/9++BsUppvmq/DzwrGq23TGZ34av50dQtz+04IxOOxwdXKPoH7mZhwBpgbiGg3QzkZEc7Q+wkBbZJRyB/ex9Pe9SsLMVBeYd4d99yMe/FadgnAiJd86F686fJZNFPG4QJN1uDzYVyMTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Wt+J1NY3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Wt+J1NY3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B5E01F000FF;
	Tue, 13 Oct 2026 04:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791865913;
	bh=VwnRZ5X4y15/PLB0V1Ff333pbryXcRBPqY+BIdTo+B0=;
	h=Date:To:From:Subject;
	b=Wt+J1NY3VrUG3J2W+8f+NtyyqpeqkQP08ZBHjuL3CEl80MjvXFbmjdcYHss0PNftC
	 YegFGNlQ3jvGXYdAw05OPhpiK1wF5XXUw1JKzXXyPilC0lBhizX0s8QRR/B0pkuBHy
	 Ah3wTgnuS/so7TU639vVTaA2crfvPX4Mb7fCsjAU=
Date: Mon, 12 Oct 2026 21:31:52 -0700
To: mm-commits@vger.kernel.org,zenghui.yu@linux.dev,vbabka@kernel.org,surenb@google.com,sj@kernel.org,shuah@kernel.org,rppt@kernel.org,rdunlap@infradead.org,mhocko@suse.com,ljs@kernel.org,lianux.mm@gmail.com,liam@infradead.org,kunwu.chan@gmail.com,eva.kurchatova@virtuozzo.com,david@kernel.org,davidgow@davidgow.net,corbet@lwn.net,brendan.higgins@linux.dev,aethernet65535@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-design-fix-typos-in-temporal-auto-tuning-algorithm-section.patch removed from -mm tree
Message-Id: <20261013043153.5B5E01F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/mm/damon/design: fix typos in temporal auto-tuning algorithm section
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-design-fix-typos-in-temporal-auto-tuning-algorithm-section.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Liew Rui Yan <aethernet65535@gmail.com>
Subject: Docs/mm/damon/design: fix typos in temporal auto-tuning algorithm section
Date: Mon, 14 Sep 2026 07:19:51 -0700

Correct incorrect references of "quota" to "goal" in the temporal
auto-tuning algorithm description and fix the square bracket formatting.

Link: https://lore.kernel.org/20260914141952.91465-7-sj@kernel.org
Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@davidgow.net>
Cc: David Hildenbrand <david@kernel.org>
Cc: Eva Kurchatova <eva.kurchatova@virtuozzo.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kunwu Chan <kunwu.chan@gmail.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lian Wang <lianux.mm@gmail.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
---

 Documentation/mm/damon/design.rst |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-fix-typos-in-temporal-auto-tuning-algorithm-section
+++ a/Documentation/mm/damon/design.rst
@@ -694,8 +694,8 @@ There are two such tuning algorithms tha
   This is the default selection.  If unsure, use this.
 - ``temporal``: More straightforward algorithm.  Tries to achieve the goal as
   fast as possible, using maximum allowed quota, but only for a temporal short
-  time.  When the quota is under-achieved, this algorithm keeps tuning quota to
-  a maximum allowed one.  Once the quota is [over]-achieved, this sets the
+  time.  When the goal is under-achieved, this algorithm keeps tuning quota to
+  a maximum allowed one.  Once the goal is [over-]achieved, this sets the
   quota zero.  Useful for deterministic control required environments.  Note
   that the zero quota is a valid quota, and therefore ``qt_exceeds`` :ref:`stat
   <damon_design_damos_stat>` will keep increasing in this case.
_

Patches currently in -mm which might be from aethernet65535@gmail.com are

mm-damon-tests-core-kunit-add-test-for-unconditionally-skipping-the-last-region.patch

