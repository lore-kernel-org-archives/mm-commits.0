Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793934525;
	b=wbAM5WFAyMHqc8bpfyNrkir8tW6dmRklcbItiR/yA0AtJF9WzJ9J4lbWjEwy+W3YuubT
	 C4P5oHYFU/wcZ+JJu5lvWJC926bWBy08vftvjUT6vOGI+UOqyMgmgp/ZOqhZ7BbZrLxK4
	 /tqwXgKlFJVsYwyt/JbEvMJOkln9nDQYvrYZ9HHRHrxJeVSbkBJU7q/kklZ/LxFFX2RhI
	 b/xlVmjBqqYrzobi9+uBkDtJJgVP0AiJeWw+WYJ/mDlNyzlPlSqSwYCxUkEzQ+rICKNBm
	 oHkxaeU4nmpwTcFQHIWofhlHrWj3u5pkBKKLzdRBAVwqdIWs6nsre5Vc/P8guFP27Dg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793934525;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=Lz3ngFqYgtaUPnciTPZBOcamqMr+2pwfRmASZcBMEik=;
	b=iydUU5KStJ51VzK8KVGiur95ckCIgcBXjGL0Cr1XZZ4goG8Lm24oJoEmmz8lTLUtdcpq
	 t9K1WslAjvS0tosAzg4PEk7qs0giFhmg8twPKz5yIBrh2ORjhDtmNaZIuBmT7JIaIbyMp
	 9tVMXobRnq8zstjygisvk+h9hPjMAGOmsKOV5bCADqjlL2iuN7j+m2P500PBH+tHLcRJK
	 tqQaLrqVJ9qTCpQgnKU3PHbeiQ0zCXpMLOQYaA23O6m+PsGsqBIM1YGSx2L24xM/4dn2Y
	 tomLKFGcs1nKzjv7lAmukAM1C1vXQqUMDSvC336W9haZ528E9Es8QIGs25xKIIQnV2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=xpyWvcz3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B754F606A326
	for <mm-commits@vger.kernel.org>; Fri,  6 Nov 2026 03:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=xpyWvcz3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DE971F0089F;
	Fri,  6 Nov 2026 03:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793934524;
	bh=Lz3ngFqYgtaUPnciTPZBOcamqMr+2pwfRmASZcBMEik=;
	h=Date:To:From:Subject;
	b=xpyWvcz3WgWOf0uODhJXb/2rglMBy9IbfKbWpV+swqJtb0aXaAs2vBbajCaOYbJJe
	 zoorvaBJmJ+kpc3njpP1OGI+m7geeS0l0ZgcFTj8YhNYTdOQJiZOUdRa8yZjNXEqia
	 hA7P0cPoyIm2Fx2DXJ6AI7Mlq9c9PokWlaaPQyW0=
Date: Thu, 05 Nov 2026 19:08:43 -0800
To: mm-commits@vger.kernel.org,skhan@linuxfoundation.org,
	rdunlap@infradead.org,jm5905938@gmail.com,corbet@lwn.net,sj@kernel.org,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-damon-design-update-for-age_ms-damos-core-filter-type.patch added to mm-new branch
Message-Id: <20261106030844.4DE971F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: Docs/mm/damon/design: update for age_ms damos core filter type
has been added to the -mm mm-new branch.  Its filename is
     docs-mm-damon-design-update-for-age_ms-damos-core-filter-type.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-design-update-for-age_ms-damos-core-filter-type.patch

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
From: SJ Park <sj@kernel.org>
Subject: Docs/mm/damon/design: update for age_ms damos core filter type
Date: Thu, 05 Nov 2026 18:05:57 -0800

Update DAMON design document for the newly added age_ms DAMOS core
filter type.

Link: https://lore.kernel.org/20261106020559.98352-4-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Aveline Noir <jm5905938@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>
---

 Documentation/mm/damon/design.rst |    3 +++
 1 file changed, 3 insertions(+)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-update-for-age_ms-damos-core-filter-type
+++ a/Documentation/mm/damon/design.rst
@@ -838,6 +838,9 @@ Below ``type`` of filters are currently
     - probe_hits_wsum
         - Matches to monitoring regions having a given range of :ref:`probe
           hits weighted sum <damon_design_attrs_only_monitoring>` value.
+    - age_ms
+        - Matces to monitoring regions having a given range of :ref:`age
+          <damon_design_age_tracking>` value in milliseconds.
 - Operations layer handled, supported by only ``paddr`` operations set.
     - anon
         - Applied to pages that contain data that are not stored in files.
_

Patches currently in -mm which might be from sj@kernel.org are

selftests-damon-sysfs_memcg_path_leak-define-ksft_skip.patch
mm-damon-core-copy-only-installed-probe-in-damon_split_region_at.patch
mm-damon-core-add-damos_filter_type_age_ms.patch
mm-damon-sysfs-schemes-support-damos_filter_type_age_ms.patch
docs-mm-damon-design-update-for-age_ms-damos-core-filter-type.patch
docs-admin-guide-mm-damon-usage-update-for-age_ms-damos-core-filter.patch

