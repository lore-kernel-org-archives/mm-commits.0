Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC4432C11E6
	for <mm-commits@vger.kernel.org>; Tue, 15 Sep 2026 02:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789437648; cv=none; b=lBRg+oob8v2T+BWXY2EDy9RoMQyMZJbcJVfuMLPP/lzef0vqYuAFg5F0+Aklz9/ZfIbADPlZIgvYhYcj8D2+H6d2yInGRf7O7nscIRkm56i2dPV1oTk8RYwn89Bh/23y78Gc/oWuqyXlXebPONrp0A17be9fqciHeR5Oksz5ppk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789437648; c=relaxed/simple;
	bh=ykx15YULMM+Yhk/298C7eltltRmW8AaM/IaDSrO0vgM=;
	h=Date:To:From:Subject:Message-Id; b=LX5nkBVUWAEElwjvLj/Z2SKp1sCcvfMBwTXpe0PO/MGsU4UpUhQiBCSTToBPVYwcuHLOsjPjL5/d1f9/yS74kzHC0amZCzf6tnHG3hKXE+TizthtJfKlg0ebmmRL9VP7t2wY7bGeaKPDE3KS4g3INh4H5BMp80MuQGHwl+SL44o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QHukKEhX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QHukKEhX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D1121F000FF;
	Tue, 15 Sep 2026 02:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789437646;
	bh=aUOqn56XtbK7Ag47ERzSTUWrHKiiRgsE/2lyxrz/w3I=;
	h=Date:To:From:Subject;
	b=QHukKEhXACSlEmlf7CtfsbYk++bULDFKNBH5gPqBzHj0zgwa17q8vI1ZtwJEpRZ8x
	 CTG5yAs2dHGXOTfuA8UIUzVW9ymWtin5eRCWaTW0Z595oo/HGzZSKIZ3ZcGTCR2ZMd
	 GBBP9Tq42f7LYaXqGlnWgzxgRSXAWAhwK3gOAsy0=
Date: Mon, 14 Sep 2026 19:00:45 -0700
To: mm-commits@vger.kernel.org,aethernet65535@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-damon-design-clarify-when-qt_exceeds-increases.patch added to mm-new branch
Message-Id: <20260915020046.4D1121F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/mm/damon/design: clarify when qt_exceeds increases
has been added to the -mm mm-new branch.  Its filename is
     docs-mm-damon-design-clarify-when-qt_exceeds-increases.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-design-clarify-when-qt_exceeds-increases.patch

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
From: Liew Rui Yan <aethernet65535@gmail.com>
Subject: Docs/mm/damon/design: clarify when qt_exceeds increases
Date: Mon, 14 Sep 2026 07:19:50 -0700

qt_exceeds counts how many times a scheme's quota has been exceeded.

When using the temporal auto-tuning algorithm, the effective size quota
becomes zero once the goal is [over-]achieved.  In this case, the quotas
are still set, so qt_exceeds keeps increasing once per quota reset
interval while the goal stays achieved.

Clarify this behavior in the design document.

Link: https://lore.kernel.org/20260914141952.91465-6-sj@kernel.org
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

 Documentation/mm/damon/design.rst |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-clarify-when-qt_exceeds-increases
+++ a/Documentation/mm/damon/design.rst
@@ -696,7 +696,9 @@ There are two such tuning algorithms tha
   fast as possible, using maximum allowed quota, but only for a temporal short
   time.  When the quota is under-achieved, this algorithm keeps tuning quota to
   a maximum allowed one.  Once the quota is [over]-achieved, this sets the
-  quota zero.  Useful for deterministic control required environments.
+  quota zero.  Useful for deterministic control required environments.  Note
+  that the zero quota is a valid quota, and therefore ``qt_exceeds`` :ref:`stat
+  <damon_design_damos_stat>` will keep increasing in this case.
 
 The goal can be specified with five parameters, namely ``target_metric``,
 ``target_value``, ``current_value``, ``nid`` and ``path``.  The auto-tuning
_

Patches currently in -mm which might be from aethernet65535@gmail.com are

mm-damon-core-allow-esz-to-be-set-to-zero.patch
mm-damon-core-fix-unconditionally-skip-last-region.patch
docs-mm-damon-design-accurate-semantics-of-nr_snapshots.patch
docs-mm-damon-design-difference-between-watermarks-and-nr_snapshots.patch
docs-mm-damon-design-fix-typo-of-max_nr_snapshots.patch
docs-mm-damon-design-clarify-when-qt_exceeds-increases.patch
docs-mm-damon-design-fix-typos-in-temporal-auto-tuning-algorithm-section.patch

