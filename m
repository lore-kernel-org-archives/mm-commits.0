Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C71102F6911
	for <mm-commits@vger.kernel.org>; Tue,  9 Jun 2026 01:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780968154; cv=none; b=kFWEwciK/GOUyJV5qrVDKZ1BZ6lcrPU1OAiKysX2t0QZ9TuL116+rzeiz1m1WLEcNPREtDZo1eU75vJmopKYQMrWmR31gdMRfo3drwCK6GLF1dr2rMr9Cz6qeQ/Rnrtbv8JkGtmG7/SIxYr0b5ki/C7ikMFRcouPLfXvB1w189Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780968154; c=relaxed/simple;
	bh=mPZ8fhSssWqPXt8a5nPRLYj8cgmECxdpGvIR7iDnovA=;
	h=Date:To:From:Subject:Message-Id; b=p486Ea14A5gHG4ZF+1jK6w4xgGY3hd9NHoZRZbWm5WNjhWTJnOByXEKRjbZ/whuo65SJUis9EGlUx+Y52xsDf+4OXrMUaZGAFKcU0tcuGHwXAN6WAXU72gZuXx0EyywbjsMHrnIJW/a/C77FiY3WA2Vlzr6MUhH7Cjju4o2zmPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=A/Wv8o7m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="A/Wv8o7m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B3041F00898;
	Tue,  9 Jun 2026 01:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780968153;
	bh=quGMGOnokRfeVeGgpNhSBi+xGp9eyuimvVoEuyzNjbo=;
	h=Date:To:From:Subject;
	b=A/Wv8o7m0HFkQk/tFgMqzTCGviwjT3eAKX+x248Gr5/Q/hXsm88WLKwUOkGGmopXS
	 SulZdPMiQHxapnkjBYTCrKVd84zRIBcI4GLqZXHiNQMzDvaN5g8J9vJSb4Ef+eMbL8
	 s2xX9jabhLyHZ2AQidp9rQZ1NX2Rfr6Co7DM2QW0=
Date: Mon, 08 Jun 2026 18:22:33 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maintainers-add-testing-abi-documents-for-mm.patch removed from -mm tree
Message-Id: <20260609012233.9B3041F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add testing ABI documents for mm
has been removed from the -mm tree.  Its filename was
     maintainers-add-testing-abi-documents-for-mm.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: MAINTAINERS: add testing ABI documents for mm
Date: Mon, 1 Jun 2026 16:55:04 -0700

A few mm subsystem entries in MAINTAINERS are missing their testing ABI
documents.  Add those.

Link: https://lore.kernel.org/20260601235506.85123-1-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/MAINTAINERS~maintainers-add-testing-abi-documents-for-mm
+++ a/MAINTAINERS
@@ -16854,6 +16854,7 @@ L:	linux-mm@kvack.org
 S:	Maintained
 W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+F:	Documentation/ABI/testing/sysfs-kernel-mm-ksm
 F:	Documentation/admin-guide/mm/ksm.rst
 F:	Documentation/mm/ksm.rst
 F:	include/linux/ksm.h
@@ -16876,6 +16877,8 @@ L:	linux-mm@kvack.org
 S:	Maintained
 W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+F:	Documentation/ABI/testing/sysfs-kernel-mm-mempolicy
+F:	Documentation/ABI/testing/sysfs-kernel-mm-mempolicy-weighted-interleave
 F:	include/linux/mempolicy.h
 F:	include/uapi/linux/mempolicy.h
 F:	include/linux/migrate.h
@@ -16918,6 +16921,10 @@ L:	linux-mm@kvack.org
 S:	Maintained
 W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+F:	Documentation/ABI/testing/sysfs-kernel-mm
+F:	Documentation/ABI/testing/sysfs-kernel-mm-cma
+F:	Documentation/ABI/testing/sysfs-kernel-mm-memory-tiers
+F:	Documentation/ABI/testing/sysfs-kernel-mm-numa
 F:	Documentation/admin-guide/mm/
 F:	Documentation/mm/
 F:	include/linux/cma.h
@@ -17041,6 +17048,7 @@ R:	Barry Song <baohua@kernel.org>
 R:	Youngjun Park <youngjun.park@lge.com>
 L:	linux-mm@kvack.org
 S:	Maintained
+F:	Documentation/ABI/testing/sysfs-kernel-mm-swap
 F:	Documentation/mm/swap-table.rst
 F:	include/linux/swap.h
 F:	include/linux/swapfile.h
@@ -17068,6 +17076,7 @@ L:	linux-mm@kvack.org
 S:	Maintained
 W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+F:	Documentation/ABI/testing/sysfs-kernel-mm-transparent-hugepage
 F:	Documentation/admin-guide/mm/transhuge.rst
 F:	include/linux/huge_mm.h
 F:	include/linux/khugepaged.h
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-always-put-unsuccessfully-committed-target-pids.patch

