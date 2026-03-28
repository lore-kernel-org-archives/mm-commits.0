Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 101E41A9FA8
	for <mm-commits@vger.kernel.org>; Sat, 28 Mar 2026 04:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774671954; cv=none; b=bv0R1xU2w0aAT96JOY6tDP3i5nth2KROJvuEUIseMWhlWAok3p3+Zk3aVdVtP+6K3ZyaII4T1f/JZp+4oxOunDCr/ZQiIv/i7IlfOFqhXW2hN5GmfxVl0ndvZ4MUWIgiFbX4++aL+cMAzairXfR4J13kgHMTZOyeXu7+pP37wo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774671954; c=relaxed/simple;
	bh=8uKX9C8dDhggpY2bfG61syVwrA3YyCHv6VOkDtXVjFg=;
	h=Date:To:From:Subject:Message-Id; b=OXuMAiuFuetvqMl+hWvQG4OgT5xNlUUgTS2+iM7cwBg1JyS/SxaCeYbIg8mFIMn4CB8E18HypIOaO/vcnJbvwDu/Xj+XSlsOqa+Pvff1LwodxsQF6xkd9e9cgQfV1XcfIYYlBTm9hKF21qFTC9HtNhCjWbw3fo6M0gqHQ6UBF0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fCBAIPBe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fCBAIPBe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCAA7C4CEF7;
	Sat, 28 Mar 2026 04:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774671953;
	bh=8uKX9C8dDhggpY2bfG61syVwrA3YyCHv6VOkDtXVjFg=;
	h=Date:To:From:Subject:From;
	b=fCBAIPBevSMNdGIl6lo6IdXDoRhHlXizgTZztIi42krThHP9/DDSXhUMyC9EFe29W
	 9P+spDEnpVSRH8GtlQi2BCvO/rtWuBqJMjampXqAGAE/WUojlsOfIZoZc0PGk3NTWS
	 GxhNXBmmz3V0L6B9WtxuwOqyVVN05g1Zw60rc8BM=
Date: Fri, 27 Mar 2026 21:25:53 -0700
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,kuba@kernel.org,horms@kernel.org,hisamshar@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] credits-simplify-the-end-of-file-alphabetical-order-comment.patch removed from -mm tree
Message-Id: <20260328042553.DCAA7C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: CREDITS: simplify the end-of-file alphabetical order comment
has been removed from the -mm tree.  Its filename was
     credits-simplify-the-end-of-file-alphabetical-order-comment.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hisam Mehboob <hisamshar@gmail.com>
Subject: CREDITS: simplify the end-of-file alphabetical order comment
Date: Thu, 12 Mar 2026 06:17:42 +0500

The existing comment references specific individuals by name which becomes
outdated as new entries are added.  Simplify it to state the alphabetical
ordering rule clearly without depending on who happens to be the last
entry.

Link: https://lkml.kernel.org/r/20260312011741.846664-2-hisamshar@gmail.com
Signed-off-by: Hisam Mehboob <hisamshar@gmail.com>
Suggested-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Jakub Kacinski <kuba@kernel.org>
Cc: Simon Horman <horms@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 CREDITS |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/CREDITS~credits-simplify-the-end-of-file-alphabetical-order-comment
+++ a/CREDITS
@@ -4560,8 +4560,5 @@ D: MD driver
 D: EISA/sysfs subsystem
 S: France
 
-# Don't add your name here, unless you really _are_ after Marc
-# alphabetically. Leonard used to be very proud of being the
-# last entry, and he'll get positively pissed if he can't even
-# be second-to-last.  (and this file really _is_ supposed to be
-# in alphabetic order)
+# Don't add your name here unless you really are last alphabetically.
+# (This file is supposed to be kept in alphabetical order by last name.)
_

Patches currently in -mm which might be from hisamshar@gmail.com are


