Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793324020;
	b=Wf+kYJ5d/Yq+1xarQ81AyXhgCt35YingNEb5pNKdGdz/Mj5NF33u9hdRLcTdOsCUekot
	 DSUJgCouWDRY1jyMtEmfX3BXoKSsVCf0oDadRxhnOOdZWcBLUpqeGVKHzLOHXL+bQMtIq
	 TVbHAlKwmkDRpizqfV+XUFQT24rpWUot2ZQ77Bdv4xyxy2grXDYAyxezhU7IrPZqK8G9D
	 6gbJyffJa8qW6ZOeeDhxmJumCH4oqIZWVLfTqJ8UmOa/JFvb7BKHyBSrGlM2MB5fpJ7U4
	 5a0IBcgc6dKcKHn3am5E9hkDjYo8tXhoZpBHjedq3wgNqTNOyVQYqxLZqcVb+NUZNWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793324020;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=/nI3MJdgFFcyJfkzW0mfMp6Ic5nDQt1dyOSLazaR3CY=;
	b=VeIXyHhjjw8l5pJ+Si2RmDv+ElnExdNVQ5az59W78Az2cCN/EuSVNKMIyoE38Y5g0JA6
	 Gu4jHb1phqr7FjkF1dBeHeubLtpEX64T/uvbidpItwN1i6Zj9ZF0SSScIgiOdfWxZGE33
	 nQsdeIVy5Ubnj6I6HtK31zPGb+MZYJjRRmDs1g1vJmqogaecViVFz244x6jd1dAwMBlnn
	 mRvdz0BNSfnKIzyZ20aUL8ThgjWhPg2XI+yHqTM/ZRuniFLwh3NjEtf9/C39aeCAFG2lb
	 5DJJFrU6EEQt/df4U+WXbfKE3giHF3ayVVOoNP6fkvW1O6eXDdqjilhttLiTpwcHe9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=qCoPaI5+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2F83606A31C
	for <mm-commits@vger.kernel.org>; Fri, 30 Oct 2026 01:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=qCoPaI5+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 371411F00919;
	Fri, 30 Oct 2026 01:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793324019;
	bh=/nI3MJdgFFcyJfkzW0mfMp6Ic5nDQt1dyOSLazaR3CY=;
	h=Date:To:From:Subject;
	b=qCoPaI5+j7muQMQDGNB1OZO/K2yoyvXYAFa+SObrenveCFL0zCDYeQzoY3dP6g3iv
	 y/PnoPddp/DZNErzVxifv3vZe/0MRlfhbEBlZDIJqY9vti0JaeIZz+KcDStJGvH8er
	 kdxnFkQSJY5xznsbtWENtu3XrcXulNRo/L3xnUMU=
Date: Thu, 29 Oct 2026 18:33:38 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,
	david@kernel.org,danielmaraboo@gmail.com,corbet@lwn.net,lienze@kylinos.cn,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-hugetlbpagerst-clarify-hugepages_total-in-hugetlbpagerst.patch added to mm-new branch
Message-Id: <20261030013339.371411F00919@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: docs: hugetlbpage.rst: clarify HugePages_Total in hugetlbpage.rst
has been added to the -mm mm-new branch.  Its filename is
     docs-hugetlbpagerst-clarify-hugepages_total-in-hugetlbpagerst.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-hugetlbpagerst-clarify-hugepages_total-in-hugetlbpagerst.patch

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
From: Enze Li <lienze@kylinos.cn>
Subject: docs: hugetlbpage.rst: clarify HugePages_Total in hugetlbpage.rst
Date: Mon, 26 Oct 2026 16:08:56 +0800

"the size of the pool of huge pages" confused me, since it sounds like a
size in bytes.  It's actually the number of huge pages of the default size
in the pool, surplus pages included.  Reword it and point to
/sys/kernel/mm/hugepages for the other huge page sizes.

Link: https://lore.kernel.org/20261026080856.76175-1-lienze@kylinos.cn
Signed-off-by: Enze Li <lienze@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Daniel Pereira <danielmaraboo@gmail.com>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Jonathan Corbet <corbet@lwn.net>
---

 Documentation/admin-guide/mm/hugetlbpage.rst |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/Documentation/admin-guide/mm/hugetlbpage.rst~docs-hugetlbpagerst-clarify-hugepages_total-in-hugetlbpagerst
+++ a/Documentation/admin-guide/mm/hugetlbpage.rst
@@ -43,7 +43,10 @@ The output of ``cat /proc/meminfo`` will
 where:
 
 HugePages_Total
-	is the size of the pool of huge pages.
+	is the number of huge pages of the default size in the pool,
+	both persistent and surplus.  Counts for the other huge page
+	sizes are available in ``/sys/kernel/mm/hugepages`` (described
+	below).
 HugePages_Free
 	is the number of huge pages in the pool that are not yet
         allocated.
_

Patches currently in -mm which might be from lienze@kylinos.cn are

docs-hugetlbpagerst-clarify-hugepages_total-in-hugetlbpagerst.patch

