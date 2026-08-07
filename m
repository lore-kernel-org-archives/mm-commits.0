Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C585E3B05A6
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 02:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068035; cv=none; b=Bpf/7/2foE+2ii4UopMtekuFz2R/1vyAaThJ8iJsXvBmZcDvoYKMQQnLKuisAFKkW5nCl44kdbTr5kE5p3KPmyJDYt4UEnk4e8hBprkNXoUbivzoWb9cGzS0gosGKFj0m/TPyJ5ZBXjTu0qXxWO5M59KqCxT/mzWGtG1xvI9kfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068035; c=relaxed/simple;
	bh=+mXQR0/2mnvTBMxfcISOTVuL1i19DUp0TiuPJ5Y3/wE=;
	h=Date:To:From:Subject:Message-Id; b=IsrK8VPMwI9w8VzrcMUTwDW4tJDWHaIwmDVLz4cPhrgUrRDX0bCDcwqDKfkoYks90w1VlXuHnbVMP+rveckOEOhkgmotck801+ipsDYgxijrE6QW4+ml9uAUXv93aRUaHsAP04qnzwfyW+P+9SEpn9gfIOda73jPKueePelISTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=N8scKDQu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="N8scKDQu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB2A31F00A3E;
	Fri,  7 Aug 2026 02:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068025;
	bh=HXjyVTAO8hK3iWJoPi/V2j/qLDB59IQKQzsYj4p1sDs=;
	h=Date:To:From:Subject;
	b=N8scKDQugTXzlPa9ucF83MbO/CPrwFH49C7vAr6qTwRE+4rhVkRdy3ftgnaaHCY6J
	 O9iK080HJBzQxRbrAzu16GWSvlqb7ezqRowsgQLwzvJ4Em/ROrwujeNv5vPKnZzHAe
	 OhqO9bNcMamkujOHgO0IgwvvYSBPPgT8GJociLi8=
Date: Thu, 06 Aug 2026 19:00:24 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,sj@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,husong@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-abi-damon-fix-typos.patch removed from -mm tree
Message-Id: <20260807020024.DB2A31F00A3E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/ABI/damon: fix typos
has been removed from the -mm tree.  Its filename was
     docs-abi-damon-fix-typos.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Song Hu <husong@kylinos.cn>
Subject: Docs/ABI/damon: fix typos
Date: Tue, 14 Jul 2026 07:01:14 -0700

Fix two typos in the DAMON sysfs ABI document:

  - "WDate:" -> "Date:" on the nr_regions/min entry
  - "manimum" -> "minimum" in the nr_accesses/min description

Link: https://lore.kernel.org/20260714140117.94147-3-sj@kernel.org
Signed-off-by: Song Hu <husong@kylinos.cn>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-kernel-mm-damon |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon~docs-abi-damon-fix-typos
+++ a/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -144,7 +144,7 @@ Description:	Writing a value to this fil
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/nr_regions/min
 
-WDate:		Mar 2022
+Date:		Mar 2022
 Contact:	SJ Park <sj@kernel.org>
 Description:	Writing a value to this file sets the minimum number of
 		monitoring regions of the DAMON context as the value.  Reading
@@ -287,7 +287,7 @@ Description:	Writing to and reading from
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/access_pattern/nr_accesses/min
 Date:		Mar 2022
 Contact:	SJ Park <sj@kernel.org>
-Description:	Writing to and reading from this file sets and gets the manimum
+Description:	Writing to and reading from this file sets and gets the minimum
 		'nr_accesses' of the scheme's target regions.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/access_pattern/nr_accesses/max
_

Patches currently in -mm which might be from husong@kylinos.cn are


