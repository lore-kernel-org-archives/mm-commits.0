Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A088743DED9
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 04:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791865913; cv=none; b=sos3+/3djVacaw7rnPNZJVjN81t+Lh9Dyjn6vV8XQ0iG6scrli2ZmMngi9kiw7wB1zx2yYQ9g3JQt7d3ynRlLFsDfhoodU/P1CyRq0xCzkn8UsZEtr+9WBX7Lnl0A8J/u/2/gF+L2hrCZzfkwihBtp+uil0b6kfy/imO7pz4olQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791865913; c=relaxed/simple;
	bh=do2kElKNfWkDR8V7B3Mn9B7Xo9jPvHPLihd8iKGSmfw=;
	h=Date:To:From:Subject:Message-Id; b=i1UgR8hslplJFoIGRAT2MCzIlGbQaTX8Z8i+HlYixl+YAxe1OfHLGchWon2BT6pEbWiFVE/ueBjVUgFFDlI4Uyx0gQGRRIfEq73rZz+ALFeA9yqoB1lteC4zG+2/W53GZN8EzsTzf6OVeEWl56gUxzsqqZva3FR6+dCsILCqONQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TugmiMLR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TugmiMLR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A7E51F00898;
	Tue, 13 Oct 2026 04:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791865912;
	bh=fNdcQAVuS7A4n4x9qCrA3AoGjoOFCuVg92d1MNz/PYQ=;
	h=Date:To:From:Subject;
	b=TugmiMLRIHMLswNDrQzpPYPDAcP0HHPblJEmaflNFKsZ47STV4Mot9Fp6vaLjQRDc
	 UObEgM92bttPEyQl0CVWfRTP4hucOm9ubM0FIqwTjBEFWT20vZPWTK1n65P3DCWwkl
	 xbQTEKE1ohHANIwqWpFTkfuQKz3JKpMOq9Rwq66c=
Date: Mon, 12 Oct 2026 21:31:51 -0700
To: mm-commits@vger.kernel.org,zenghui.yu@linux.dev,vbabka@kernel.org,surenb@google.com,sj@kernel.org,shuah@kernel.org,rppt@kernel.org,rdunlap@infradead.org,mhocko@suse.com,ljs@kernel.org,lianux.mm@gmail.com,liam@infradead.org,kunwu.chan@gmail.com,eva.kurchatova@virtuozzo.com,david@kernel.org,davidgow@davidgow.net,corbet@lwn.net,brendan.higgins@linux.dev,aethernet65535@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-design-clarify-when-qt_exceeds-increases.patch removed from -mm tree
Message-Id: <20261013043152.3A7E51F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/mm/damon/design: clarify when qt_exceeds increases
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-design-clarify-when-qt_exceeds-increases.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-damon-tests-core-kunit-add-test-for-unconditionally-skipping-the-last-region.patch

