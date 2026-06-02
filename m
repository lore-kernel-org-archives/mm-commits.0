Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D4E53C4552
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439133; cv=none; b=WAnNqzSnK9sbKore/mnEcSnUygQCTXhgxfgMk9akaFcQoUe1FrZvqzdS9lSaTP1w6GGqn8Goq/HelPm44p8sFvJtX171o+KgH8trO+fIQKlip/Gg9kJB8b1kwcseWY4hQVeklcL5WnPfxxZNFDYp/c6wPsSo3/3joXJeHwZNR48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439133; c=relaxed/simple;
	bh=hJkGTCF0Dm6J3oUbxPmwE1+yx/CDXcWaqIzXEzKaEx8=;
	h=Date:To:From:Subject:Message-Id; b=gNxbBuKHbYx5x5UJcE9bE1Uj5q2gdXVW5dGTyy7ctZ6luNXhYWo5gbZcHrfHBuSOCFcIiFt6DYY9nOpZe7tSkugKuogjnaifeu02nUMbQAlBn0Xaf4y6ZqvZeypa6IZHU067HRWZ55v3YfKAlYjDG/LYZmwAwvFlxZL7PdnWrNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OtYhiwX/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OtYhiwX/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6202D1F00893;
	Tue,  2 Jun 2026 22:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439132;
	bh=kG2fJSgUBwiO45s13TDwBV1mz6bZeHmnl5LW6Qp1mX0=;
	h=Date:To:From:Subject;
	b=OtYhiwX/y8iPPAC7Gcl0Zln1Z0gzNSMC4odw0QUTm/kWYq8Zsp9LVPJobfrTYd45P
	 knmU9jJzQQ92gh26hxJAmDhA7CcmnWpe06N+8xsuWsnAAUAcEPbzVhFR8vUSJxg+AY
	 B3Ykej54JN4m4RhfcruVlhTUCRE+DiQxcxl+ON9s=
Date: Tue, 02 Jun 2026 15:25:31 -0700
To: mm-commits@vger.kernel.org,zenghui.yu@linux.dev,vbabka@kernel.org,surenb@google.com,skhan@linuxfoundation.org,sj@kernel.org,rppt@kernel.org,niecheng1@uniontech.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,ssh1326@icloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-design-fix-three-typos.patch removed from -mm tree
Message-Id: <20260602222532.6202D1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/mm/damon/design: fix three typos
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-design-fix-three-typos.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sakurai Shun <ssh1326@icloud.com>
Subject: Docs/mm/damon/design: fix three typos
Date: Tue, 19 May 2026 18:21:00 -0700

L140: "unsinged" -> "unsigned"
L371: "sampleing" -> "sampling"
L387: "multipled" -> "multiplied"

Link: https://lore.kernel.org/20260520012104.93602-3-sj@kernel.org
Signed-off-by: Sakurai Shun <ssh1326@icloud.com>
Signed-off-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: niecheng <niecheng1@uniontech.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zenghui Yu <zenghui.yu@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-fix-three-typos
+++ a/Documentation/mm/damon/design.rst
@@ -147,7 +147,7 @@ as Idle page tracking does.
 Address Unit
 ------------
 
-DAMON core layer uses ``unsinged long`` type for monitoring target address
+DAMON core layer uses ``unsigned long`` type for monitoring target address
 ranges.  In some cases, the address space for a given operations set could be
 too large to be handled with the type.  ARM (32-bit) with large physical
 address extension is an example.  For such cases, a per-operations set
@@ -417,7 +417,7 @@ with theoretical maximum ``nr_accesses``
 ``aggregation interval / sampling interval``.
 
 The mechanism calculates the ratio of access events for ``aggrs`` aggregations,
-and increases or decrease the ``sampleing interval`` and ``aggregation
+and increases or decrease the ``sampling interval`` and ``aggregation
 interval`` in same ratio, if the observed access ratio is lower or higher than
 the target, respectively.  The ratio of the intervals change is decided in
 proportion to the distance between current samples ratio and the target ratio.
@@ -433,7 +433,7 @@ The tuning is turned off by default, and
 As a rule of thumbs and the Parreto principle, 4% access samples ratio target
 is recommended.  Note that Parreto principle (80/20 rule) has applied twice.
 That is, assumes 4% (20% of 20%) DAMON-observed access events ratio (source)
-to capture 64% (80% multipled by 80%) real access events (outcomes).
+to capture 64% (80% multiplied by 80%) real access events (outcomes).
 
 To know how user-space can use this feature via :ref:`DAMON sysfs interface
 <sysfs_interface>`, refer to :ref:`intervals_goal
_

Patches currently in -mm which might be from ssh1326@icloud.com are


