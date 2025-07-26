Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 126F3220F3F
	for <mm-commits@vger.kernel.org>; Sat, 26 Jul 2025 22:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753567852; cv=none; b=T8Gat5Ck3lUv0m9wKffLTG8uM+JmujgHqdYwDHh5Oi/49vd4mw3y6DtlhniLKXkds6GV4+VQ2M0OToTgXVTX0Tkl6ZPZUG102VG2dbfoG8Oy+Zn3JRaSnoMJ0/cWvABZMMjPVOWGFfi3anU9ShGZGzpK17tVLgW86EPgNfNgUP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753567852; c=relaxed/simple;
	bh=IC/umwq6QFf6Mu3rBbjImWx6wdR1vXRuwv//C3mv9jM=;
	h=Date:To:From:Subject:Message-Id; b=nzlt5IZsNNKTslQD4bS9Q56SqTFp582UJ19eWXAoJn9SNTIb7V4MbGWgWWDXi3L1Hpw5rASpIRYm/zJi9zsm4U0O2Lq0DMO/j6enC2/sNJ/vf1O5emcW/sutmWGc1apWdnIFqazQ9R9j8Z4vm7kfFfc+OzoCRMS+6U3j8a77rA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rcxB+WYh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rcxB+WYh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBEAFC4CEED;
	Sat, 26 Jul 2025 22:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753567851;
	bh=IC/umwq6QFf6Mu3rBbjImWx6wdR1vXRuwv//C3mv9jM=;
	h=Date:To:From:Subject:From;
	b=rcxB+WYhjGWOyduZiRwHJ7cVh6lHcxbqT0mcSHx9cAQjwb/iOtZ4xOMRuWwzChl7G
	 IMx9wrVWK6eiqkInnxUt1q1/tQLwk/7XuczDUVlpaJcCefvcDg2cZPrlJ39p8TN90d
	 AnQU0JF2z+POjMpAxQlEDxvUH533ZX7BYPf9JB5g=
Date: Sat, 26 Jul 2025 15:10:51 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,rakie.kim@sk.com,matthew.brost@intel.com,lorenzo.stoakes@oracle.com,gourry@gourry.net,david@redhat.com,byungchul@sk.com,apopple@nvidia.com,joshua.hahnjy@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maintainers-add-missing-headers-to-mempory-policy-migration-section.patch removed from -mm tree
Message-Id: <20250726221051.DBEAFC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add missing headers to mempory policy & migration section
has been removed from the -mm tree.  Its filename was
     maintainers-add-missing-headers-to-mempory-policy-migration-section.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: MAINTAINERS: add missing headers to mempory policy & migration section
Date: Fri, 25 Jul 2025 10:56:15 -0700

These two files currently do not belong to any section.
The memory policy & migration section seems to be a good home for them!

Link: https://lkml.kernel.org/r/20250725175616.2397031-1-joshua.hahnjy@gmail.com
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mathew Brost <matthew.brost@intel.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 ++
 1 file changed, 2 insertions(+)

--- a/MAINTAINERS~maintainers-add-missing-headers-to-mempory-policy-migration-section
+++ a/MAINTAINERS
@@ -15849,7 +15849,9 @@ S:	Maintained
 W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
 F:	include/linux/mempolicy.h
+F:	include/uapi/linux/mempolicy.h
 F:	include/linux/migrate.h
+F:	include/linux/migrate_mode.h
 F:	mm/mempolicy.c
 F:	mm/migrate.c
 F:	mm/migrate_device.c
_

Patches currently in -mm which might be from joshua.hahnjy@gmail.com are


