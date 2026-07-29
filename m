Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAC9F1F7916
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 04:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785298537; cv=none; b=snRKoGa+98m7ojMKvXb7EGyRV9G3RRudxioDozccFRFJxmBLiqKsZKdCgCKfsi1HwGg51vHHcfttSL8sXiVjgR/Q2ulaJTkmloESsbJux90OAwMiiz0bc+MbZAYAhJH/BTDBqC33s2AHr1ToFAHhlTZXz7niyOJgpyLzqRD40Wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785298537; c=relaxed/simple;
	bh=AYJzKRYPYONm6m5sZaJNWCiBUpDSzJHolbhYx9n4i60=;
	h=Date:To:From:Subject:Message-Id; b=rVthwMqnUgJfG1vxdFp0kjTFcdltWECu0SSYcUlz5AKumN1ybNaOQEh4jm6krqDX2qCAPY/dFr53jL/LmYi+hq4b82ltTQ1ZIUNDSJDRs6cxkFo7QHp+Q9991UK+m7Zg/+uRtj6lqDKVTXNNVBv7S9+q8INzP45Zs0Fz1+RHvKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qIm8xPh6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qIm8xPh6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCE451F00A3A;
	Wed, 29 Jul 2026 04:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785298535;
	bh=UOWm/3vBu53GBkoLUlo+bDezYlEKW1YngEXonvDWrhs=;
	h=Date:To:From:Subject;
	b=qIm8xPh6kvaaQ+j1zZoPy/r33jDtqFK2ewExJsGaeFHwGXvPu2/6O3UYeZ6DrUjcG
	 F0ZtorxGP29CxB7/Ltb5HoUFjuMl8psqGC1uzIkLN0N22de4zdd/FxPC7WKNpmWg+G
	 MEzVvIRCdKVFH7rwfYcTO3sw73zxg6gYr80GO6Wk=
Date: Tue, 28 Jul 2026 21:15:35 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,niecheng1@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-_damon_sysfspy-fix-memcg_path-assignment.patch removed from -mm tree
Message-Id: <20260729041535.BCE451F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon/_damon_sysfs.py: fix memcg_path assignment
has been removed from the -mm tree.  Its filename was
     selftests-damon-_damon_sysfspy-fix-memcg_path-assignment.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Cheng Nie <niecheng1@uniontech.com>
Subject: selftests/damon/_damon_sysfs.py: fix memcg_path assignment
Date: Mon, 29 Jun 2026 07:48:10 -0700

Patch series "selftests/damon: fix memcg_path staging handling", v5.

Fix a bug in _damon_sysfs.py for damos_filter memcg_path setup, and add
a test case of it in sysfs.py.


This patch (of 2):

DamosFilter stores memcg_path for sysfs staging, but the constructor
assigns it with a trailing comma and therefore turns it into a tuple.

Fix the assignment so memcg_path is stored as the intended string.  This
makes memcg filter staging and follow-up validation use the written path
correctly.

Link: https://lore.kernel.org/20260629144812.134159-1-sj@kernel.org
Link: https://lore.kernel.org/464AE12D4BC6B6F4+20260601090519.240482-1-niecheng1@uniontech.com
Link: https://lore.kernel.org/20260629144812.134159-2-sj@kernel.org
Signed-off-by: Cheng Nie <niecheng1@uniontech.com>
Signed-off-by: SJ Park <sj@kernel.org>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/_damon_sysfs.py |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/damon/_damon_sysfs.py~selftests-damon-_damon_sysfspy-fix-memcg_path-assignment
+++ a/tools/testing/selftests/damon/_damon_sysfs.py
@@ -271,7 +271,7 @@ class DamosFilter:
         self.type_ = type_
         self.matching = matching
         self.allow = allow
-        self.memcg_path = memcg_path,
+        self.memcg_path = memcg_path
         self.addr_start = addr_start
         self.addr_end = addr_end
         self.target_idx = target_idx
_

Patches currently in -mm which might be from niecheng1@uniontech.com are


