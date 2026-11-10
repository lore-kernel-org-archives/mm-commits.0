Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794272539;
	b=UenVcQKuXtyUEg0oVTmCtRyoqKdcKxQT9ziWysdwT7VCmkggqyc/ftZrOxChDPtHpgV7
	 55n0125fNDJ4/xlBzzNEwQa0msFjul12xisxeQ/udU7ZanXSbxO4sKzuufr92hyetiL2K
	 Yq7Cu5oThoMS5IKG1EzQRSy8+wfgcFmyBSvI+GUqqRQE9uNOMxra2upxK9ik7lsm+1cCd
	 J4VSKAnQjj//QtWbeTQAP9e2/h1Lxd1hQNAaJ0HjigbIBPzoyf+Brb45gAcAVrLGh7sYT
	 bXt8wScXTHnuAW+f7LSgDPt0YbSqsIILq8HTRx5edcVIHy8eZrWvQmT3hzmQM+MizCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794272539;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=20hEICLil4kCUjTHTP5j0xVG6xrZnV5pk0kULcwM08M=;
	b=LlIWOuGBO2+PgnXuqaVGaZPx/LCPZgne5wA6xTJ3Tus6NeAqeGvD+KBwsIWsnZnkflzk
	 Qfgvoc6waAg2vdDMVjoslEAEO2x7E6rVOJny1Yyq3YROh93khNqAtY7oJ6bRtWUCbelkZ
	 F5ofbjlWGJlvjSzlvrXlv2P5P9OgcN8EcxsRXK7WgwB5tm4A81Fwz6g/VcetZ7PtvN1bS
	 FDg+nS9Xfyjsmmh2r40h7uZ45JE2TWPMti2agTHR2CYMnE9OOt61hXFbzkq9IBuQqofkp
	 YuMeMCIK/16ydLbbEhRkLzcOhCP3vZTkCmVI9Tuz81/1wyZUg5v0+qbySKpF7PPgCEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=M53apsbw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84654606A32A;
	Tue, 10 Nov 2026 01:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=M53apsbw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D8AE1F0089F;
	Tue, 10 Nov 2026 01:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794272539;
	bh=20hEICLil4kCUjTHTP5j0xVG6xrZnV5pk0kULcwM08M=;
	h=Date:To:From:Subject;
	b=M53apsbwRQ1KxcaxC6OLKxtLt+9QCDxH2uz0DmtHag8ss9TSm7Y+nUUlaw8dG8gKU
	 KCeYRih8r9QDDeOQIqaTfVjGV1oCEBCvJ8quRadGACIuFJP+8fI4iO9T1QwocIxBPD
	 FZkbulQQT0kss14K1KUeeTRBNfx/wNphLUOCuMXk=
Date: Mon, 09 Nov 2026 17:02:18 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,
	gkwang@linx-info.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-stat-avoid-overflow-in-estimated_memory_bandwidth-calculation.patch added to mm-hotfixes-unstable branch
Message-Id: <20261110010219.1D8AE1F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/damon/stat: avoid overflow in estimated_memory_bandwidth calculation
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-stat-avoid-overflow-in-estimated_memory_bandwidth-calculation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-stat-avoid-overflow-in-estimated_memory_bandwidth-calculation.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Wang Guangke <gkwang@linx-info.com>
Subject: mm/damon/stat: avoid overflow in estimated_memory_bandwidth calculation
Date: Mon,  9 Nov 2026 16:48:14 -0800

estimated_memory_bandwidth is calculated by access_bytes * USEC_PER_MSEC *
MSEC_PER_SEC (= USEC_PER_SEC) / aggr_interval, and users read it via
/sys/module/damon_stat/parameters/estimated_memory_bandwidth.

On 32-bit systems, access_bytes * USEC_PER_SEC overflows unsigned long
once access_bytes exceeds about 4294 (U32_MAX / USEC_PER_SEC), so users
get a wrong value.

Fix it by doing the calculation in 64-bit and splitting the division into
quotient and remainder.

The issue was reproduced on a 32-bit system (qemu-system-i386): the
parameter estimated_memory_bandwidth reported 362 instead of the expected
1926150; with the fix, the value matches the expectation.

Link: https://lore.kernel.org/20261110004816.100066-1-sj@kernel.org
Fixes: fabdd1e911da ("mm/damon/stat: calculate and expose estimated memory bandwidth")
Signed-off-by: Wang Guangke <gkwang@linx-info.com>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>
---

 mm/damon/stat.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/mm/damon/stat.c~mm-damon-stat-avoid-overflow-in-estimated_memory_bandwidth-calculation
+++ a/mm/damon/stat.c
@@ -32,8 +32,8 @@ static bool enabled __read_mostly = IS_E
 module_param_cb(enabled, &enabled_param_ops, NULL, 0600);
 MODULE_PARM_DESC(enabled, "Enable of disable DAMON_STAT");
 
-static unsigned long estimated_memory_bandwidth __read_mostly;
-module_param(estimated_memory_bandwidth, ulong, 0400);
+static u64 estimated_memory_bandwidth __read_mostly;
+module_param(estimated_memory_bandwidth, ullong, 0400);
 MODULE_PARM_DESC(estimated_memory_bandwidth,
 		"Estimated memory bandwidth usage in bytes per second");
 
@@ -55,15 +55,18 @@ static void damon_stat_set_estimated_mem
 {
 	struct damon_target *t;
 	struct damon_region *r;
-	unsigned long access_bytes = 0;
+	u64 access_bytes = 0;
+	u64 remainder, bytes_per_us;
 
 	damon_for_each_target(t, c) {
 		damon_for_each_region(r, t)
-			access_bytes += (r->ar.end - r->ar.start) *
+			access_bytes += (u64)(r->ar.end - r->ar.start) *
 				r->nr_accesses;
 	}
-	estimated_memory_bandwidth = access_bytes * USEC_PER_MSEC *
-		MSEC_PER_SEC / c->attrs.aggr_interval;
+	bytes_per_us = div64_u64_rem(access_bytes,
+			c->attrs.aggr_interval, &remainder);
+	estimated_memory_bandwidth = bytes_per_us * USEC_PER_SEC +
+		div64_u64(remainder * USEC_PER_SEC, c->attrs.aggr_interval);
 }
 
 static int damon_stat_idletime(const struct damon_region *r)
_

Patches currently in -mm which might be from gkwang@linx-info.com are

mm-damon-stat-avoid-overflow-in-estimated_memory_bandwidth-calculation.patch

