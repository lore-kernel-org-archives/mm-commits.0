Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F873215771
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188277; cv=none; b=DdT/BQpZxF/L/dIz8ucRrQpt8dQlNDopgLnZoG2mixQNV+KbjTyvCkf+L5WzgRh+aqmpByv1Xb3/3Aezk941Z3lu1K1NiRtComGMqvzyalTrtgPxojGO+zq3+pfw2HDEVnVG6dbwKBpi8zF4m+3Dx1GBXyX0EdZEI1WojHJY2hE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188277; c=relaxed/simple;
	bh=O9FCPWIlVxvLFBl9QtWbOoWD+5gjhniQuyLWPAoo3uY=;
	h=Date:To:From:Subject:Message-Id; b=dv15FevWcpG+IaDiRAUXFM5n16cPcfkkmVsSwHq5STywHkqfO7MnyVImb8aiKb9K7XAwZAl1LfP8onmeJKgnDYHipTUHnEd5dIsizf6F8w5Xm7Nl3Lgk6AHndP3yIz/pMCDYR5HZQ1HawU1Ytbxk5GkGLQ6Nx50IVfjMTKSdIBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=e68y8h4c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="e68y8h4c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3285AC4CEED;
	Mon, 17 Mar 2025 05:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188277;
	bh=O9FCPWIlVxvLFBl9QtWbOoWD+5gjhniQuyLWPAoo3uY=;
	h=Date:To:From:Subject:From;
	b=e68y8h4ce8OBvypm3yUF9bvkR14JyetFGYlQ4SyJML2/8UD/u0hAHGCo/vek0AdZQ
	 HnKJGOSJKLs/LzWm06WikJmaUmA0kTp6z2b8g+CuZnRsbZ2ZObXGwjdcfmxq+zrpXh
	 bPMlOZmT8IUiTR/0KzlrHVBwpl9+4tyupcOi6FPQ=
Date: Sun, 16 Mar 2025 22:11:16 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,hannes@cmpxchg.org,david@redhat.com,usamaarif642@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-abi-damon-document-damos-sysfs-files-to-set-the-min-max-folio_size.patch removed from -mm tree
Message-Id: <20250317051117.3285AC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/ABI/damon: document DAMOS sysfs files to set the min/max folio_size
has been removed from the -mm tree.  Its filename was
     docs-abi-damon-document-damos-sysfs-files-to-set-the-min-max-folio_size.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Usama Arif <usamaarif642@gmail.com>
Subject: Docs/ABI/damon: document DAMOS sysfs files to set the min/max folio_size
Date: Tue, 11 Feb 2025 12:43:42 +0000

This will be used to decide the min and max folio size to operate on for
pa_stat.

Link: https://lkml.kernel.org/r/20250211124437.278873-4-usamaarif642@gmail.com
Signed-off-by: Usama Arif <usamaarif642@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-kernel-mm-damon |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon~docs-abi-damon-document-damos-sysfs-files-to-set-the-min-max-folio_size
+++ a/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -345,6 +345,20 @@ Description:	If 'addr' is written to the
 		from this file sets or gets the end address of the address
 		range for the filter.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/filters/<F>/min
+Date:		Feb 2025
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	If 'hugepage_size' is written to the 'type' file, writing to
+		or reading from this file sets or gets the minimum size of the
+		hugepage for the filter.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/filters/<F>/max
+Date:		Feb 2025
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	If 'hugepage_size' is written to the 'type' file, writing to
+		or reading from this file sets or gets the maximum size of the
+		hugepage for the filter.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/filters/<F>/target_idx
 Date:		Dec 2022
 Contact:	SeongJae Park <sj@kernel.org>
_

Patches currently in -mm which might be from usamaarif642@gmail.com are


