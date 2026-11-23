Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795454928;
	b=VlXVFlgK1Z1c7L4ZTcoYNQl2yR8Fab4fOz2AZTXV5IP8o37KGpDLGn35sCY8QTO82aIZ
	 gNZ0bh2VmajsjltmmGxINILvnwmNrnE6HD60uCIDxJDlkRodHY7ps5FWJyQ/NoAPvo2Ar
	 rUIF5TMyhESvKyKPPVB6+I7lI2dKmgpc14zj9CR7PXOTmRR5ehgv0p8smCZDwKf61o8l8
	 MzoiKdYccK2n0I2s1bhSr9dF6QAUXJDi0qlzDp0RSlHSfKn4OOkS93kLm/+LTRVSDL3lc
	 n3R4CuY/tJxc9ITVQCQE83gaNz/f9obXAAIhSQium2g/SICVb6YkrZbwjMA+CDTZmFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795454928;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=IrR0HlxFsCto+wJ3w7aNmoMzlGCpbsiTb1dCK8PTWwU=;
	b=OIzl1FLIzkPT9mPOBzWo5POLrdxLQg+GaqRkwpsMMt8TAvc1edH6lZPG9xk2bbAQEm/0
	 FxrM03fAT83G0orVLpoRnzr1LKaDgvW4wOnuIn2ycOLdFEin3/O3A0+nu+377Wd8yWlQv
	 CGCM+9ffsz7mgY1CzInQqQ4PfaUtCqeqbV3PQdWUYthxLFKsTTGNQKc/48ZoRiB/7Vfgv
	 Dl7upGolRi5XK2ND+fkZHrIKRhSgzlqpNh/s+q1gANEJTu96SRa7xe63K+XJOidU+t/m4
	 aJ9JvacR8b83El0W4ciqkJfgIwIWLORYv7JgzIfdE45xjYdQ7NYeZGuqv/uyL6xzWhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=RFIccBbU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E473606A31F
	for <mm-commits@vger.kernel.org>; Mon, 23 Nov 2026 17:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=RFIccBbU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B422C1F000C4;
	Mon, 23 Nov 2026 17:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795454927;
	bh=IrR0HlxFsCto+wJ3w7aNmoMzlGCpbsiTb1dCK8PTWwU=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=RFIccBbUz+T8Fy40C8MV6R5GtunJ77j7xMBvRRJwie78TnzdjtxzFBk5ielXJjBh8
	 N6+rdPpab8djQOmLCAP4hLs51GTacN+xtJIgm9F7C22hkLvhSFLwlPTCogbIelIVE9
	 GajUJ6d2BSYW+Hr8L12IV1ton4vSGAvKhviMRRqA=
Date: Mon, 23 Nov 2026 09:28:47 -0800
To: mm-commits@vger.kernel.org,skhan@linuxfoundation.org,sj@kernel.org,
	rdunlap@infradead.org,corbet@lwn.net,mattathias.pinchover@uber.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261123151309.82675-5-sj@kernel.org>
References: <20261123151309.82675-5-sj@kernel.org>
Subject: + docs-mm-damon-design-update-for-sz_ops_filter_passed_last.patch added to mm-new branch
Message-Id: <20261123172847.B422C1F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: Docs/mm/damon/design: update for sz_ops_filter_passed_last
has been added to the -mm mm-new branch.  Its filename is
     docs-mm-damon-design-update-for-sz_ops_filter_passed_last.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-design-update-for-sz_ops_filter_passed_last.patch

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
From: Mattathias Pinchover <mattathias.pinchover@uber.com>
Subject: Docs/mm/damon/design: update for sz_ops_filter_passed_last
Date: Mon, 23 Nov 2026 07:13:05 -0800

Update DAMON design document for the newly added DAMOS stat,
sz_ops_filter_passed_last.

Link: https://patch.msgid.link/20261123151309.82675-5-sj@kernel.org
Signed-off-by: Mattathias Pinchover <mattathias.pinchover@uber.com>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>

 Documentation/mm/damon/design.rst |    2 ++
 1 file changed, 2 insertions(+)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-update-for-sz_ops_filter_passed_last
+++ a/Documentation/mm/damon/design.rst
@@ -876,6 +876,8 @@ scheme's execution.
 - ``sz_tried``: Total size of regions that the scheme is tried to be applied.
 - ``sz_ops_filter_passed``: Total bytes that passed operations set
   layer-handled DAMOS filters.
+- ``sz_ops_filter_passed_last``: Bytes that passed operations set
+  layer-handled DAMOS filters in the last ``apply_interval``.
 - ``nr_applied``: Total number of regions that the scheme is applied.
 - ``sz_applied``: Total size of regions that the scheme is applied.
 - ``qt_exceeds``: Total number of times the quota of the scheme has exceeded.
_

Patches currently in -mm which might be from mattathias.pinchover@uber.com are

mm-damon-core-introduce-sz_ops_filter_passed_last-stat.patch
mm-damon-sysfs-schemes-add-sz_ops_filter_passed_last-file.patch
mm-damon-tests-core-kunit-test-sz_ops_filter_passed_last.patch
docs-mm-damon-design-update-for-sz_ops_filter_passed_last.patch
docs-admin-guide-mm-damon-usage-update-for-sz_ops_filter_passed_last.patch
docs-abi-damon-update-for-sz_ops_filter_passed_last.patch

