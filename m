Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ED5F1474DA
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 02:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752976906; cv=none; b=TUOb60IjN4FKZcI/oW+0HO7TpCa90+LEoEnBgwmZVfd/KlKMdwKD/yquELquLGqwxQrH4EUNv4GELuzZFAFi71b6IsiL0ZccUs1rDz3fvfHblPYycH0QJZNpFzcw1+huRlMIaqO9CT46+u+rc04ExJjMllAKsZmuyAMVaWER/WY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752976906; c=relaxed/simple;
	bh=xK1OGR4iofvbqgXhNFqJRNpdlF3d+e6zxB+0HyKbpvU=;
	h=Date:To:From:Subject:Message-Id; b=YDdTCXZ0B16+VvcbzKobVF/PuT5gtfChaYnC0hSEUDkriyh5gfwx2wBHzR1Hi3JT2DwPO+E4E1OJq7sZHDvVGrq+dId/Llyei7wc7fK52v7QdOCgUwts8mok8uGf3tfuijOM4+DsukR+OrkLCHvwt1WCRoM/Z/ZltqjeV+ZcBgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=canotNqL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="canotNqL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5406C4CEE3;
	Sun, 20 Jul 2025 02:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752976906;
	bh=xK1OGR4iofvbqgXhNFqJRNpdlF3d+e6zxB+0HyKbpvU=;
	h=Date:To:From:Subject:From;
	b=canotNqL9h9OFGb3u6+lQDPPyoJ6GV/1HF15exP/1KvwL7FEmy2VNqu3Myd7Z70NA
	 PaySr9uxR9cFMz03e2SaYXbW9fnKCLS3oya8tn5qlBaSbIxoxtop210Uq66e17RnB2
	 +Bn2WaOh6OuKgVCGtHywNS7ZTtovEofR0zjRQomA=
Date: Sat, 19 Jul 2025 19:01:45 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,ravis.opensrc@micron.com,corbet@lwn.net,bijantabatab@micron.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-design-document-vaddr-support-for-migrate_hotcold.patch removed from -mm tree
Message-Id: <20250720020145.E5406C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/mm/damon/design: document vaddr support for migrate_{hot,cold}
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-design-document-vaddr-support-for-migrate_hotcold.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Bijan Tabatabai <bijantabatab@micron.com>
Subject: Docs/mm/damon/design: document vaddr support for migrate_{hot,cold}
Date: Tue, 8 Jul 2025 19:59:40 -0500

Document that the migrate_{hot,cold} schemes can be used by the vaddr
operations set.

Link: https://lkml.kernel.org/r/20250709005952.17776-11-bijan311@gmail.com
Co-developed-by: Ravi Shankar Jonnalagadda <ravis.opensrc@micron.com>
Signed-off-by: Ravi Shankar Jonnalagadda <ravis.opensrc@micron.com>
Signed-off-by: Bijan Tabatabai <bijantabatab@micron.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-document-vaddr-support-for-migrate_hotcold
+++ a/Documentation/mm/damon/design.rst
@@ -452,9 +452,9 @@ that supports each action are as below.
  - ``lru_deprio``: Deprioritize the region on its LRU lists.
    Supported by ``paddr`` operations set.
  - ``migrate_hot``: Migrate the regions prioritizing warmer regions.
-   Supported by ``paddr`` operations set.
+   Supported by ``vaddr``, ``fvaddr`` and ``paddr`` operations set.
  - ``migrate_cold``: Migrate the regions prioritizing colder regions.
-   Supported by ``paddr`` operations set.
+   Supported by ``vaddr``, ``fvaddr`` and ``paddr`` operations set.
  - ``stat``: Do nothing but count the statistics.
    Supported by all operations sets.
 
_

Patches currently in -mm which might be from bijantabatab@micron.com are


