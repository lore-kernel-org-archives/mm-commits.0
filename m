Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792560389;
	b=n+3HsdcRnmRzZ3iKN3/VY6Ol8y36hp63h5pUm0/KU8gXQiIJOxj6qHVIg23/oUTykKSW
	 mIR1U0DVVjQoVe0tgjq1xUMOPiy4wwID4dblmpLKmR2OIgLZjUVoibTSfRNivKoBfIn0y
	 0j/Zbx780tiZV+P48W8IxABIoF4dGipyHMhtsqPQNGOE1KT5SHHFSmQNA8cbwZyxJ+p8i
	 NYU35fD6AO0S63rnoZhAkRCq8/SGRQnjXxQxf+Dn72JOqxj+kW67Py8veLsx4lujkcqUK
	 BJt39pcJsBjGMxribh1ekKVXo8UHGw9KGlBNAEX3b9cOM4zIq4ixwXpplKrl4Xj8wTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792560389;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=wbloUxnFa9tlQ0gsksjg6/v8k3iA7heB5SiEBIrl2Ts=;
	b=LDCOR/V9UxjDZXHAoNzyv2EJrmQf34Uz2RI0dKgHtpXIC/YBOFyV+4aWR14QmT6YS+Re
	 Nx4/gWqks4GgDRSbbYPFHAn5QEsI4JZSS4eE2wWC9m5ZZzvYWjvlVfd6raq7SBbSswipN
	 b7Uk3uJlwkwHqRSx4dMl57piHmifOSjTXXFAJyQymoXzlJ2V7pwp1gcc+8wb5HtLFtpm3
	 RERIavbOobCdVkjS22ReLaY3N+bGizuVXx0DIwwqxuvjEnX94RSygv634nIzmCO1T21PR
	 y+LabFCHKURJxaZ3FxwsEMgm49dvxpsSQQ4ZHoJB6Ln2rUefcLiJDB3EURorfaWcCNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Ax7es1L2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24593606A319
	for <mm-commits@vger.kernel.org>; Wed, 21 Oct 2026 05:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Ax7es1L2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DAA81F000C9;
	Wed, 21 Oct 2026 05:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792560388;
	bh=wbloUxnFa9tlQ0gsksjg6/v8k3iA7heB5SiEBIrl2Ts=;
	h=Date:To:From:Subject;
	b=Ax7es1L2dNu1p0kgyvpbgrjrpK+GVK7iM363f6yujjeFSPkE6NcS5d8FQ4XnsmIUq
	 M7qMk8VYlpwmsUDIzXTPQZcdI9uQfzmyOVNb3Dv1PxPru+oU2uXoR2CuRP5rmhHa7O
	 m4kg/uFH3oxxAfYvgZ6OkUnQ/msb1I/Oi6kOriAQ=
Date: Tue, 20 Oct 2026 22:26:26 -0700
To: mm-commits@vger.kernel.org,lzsx618@gmail.com,armaan.sandhu0504@gmail.com,andriy.shevchenko@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] lib-cmdline-fix-get_options-count-and-overflow-with-large-ranges-fix.patch removed from -mm tree
Message-Id: <20261021052628.7DAA81F000C9@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: lib-cmdline-fix-get_options-count-and-overflow-with-large-ranges-fix
has been removed from the -mm tree.  Its filename was
     lib-cmdline-fix-get_options-count-and-overflow-with-large-ranges-fix.patch

This patch was dropped because it was folded into lib-cmdline-fix-get_options-count-and-overflow-with-large-ranges.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib-cmdline-fix-get_options-count-and-overflow-with-large-ranges-fix
Date: Wed Oct 7 05:06:09 PM PDT 2026

add additional test case from Leizhen

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: Armaan Sandhu <armaan.sandhu0504@gmail.com>
Cc: Leizhen Zhang <lzsx618@gmail.com>
---

 lib/tests/cmdline_kunit.c |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/tests/cmdline_kunit.c~lib-cmdline-fix-get_options-count-and-overflow-with-large-ranges-fix
+++ a/lib/tests/cmdline_kunit.c
@@ -151,6 +151,7 @@ static const struct {
 	{ "0-2147483647",  { 3, 0, 1, 2, },    0,          },
 	{ "-5-2147483647", { 3, -5, -4, -3, }, 0,          },
 	{ "2147483647--5", { 0, 2147483647, }, 0,          },
+	{ "1,0-2147483647", { 3, 1, 0, 1, },   1, },
 };
 
 static void cmdline_test_range_overflow(struct kunit *test)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-damon-core-introduce-damos_quota_goal-complement-fix.patch
fs-proc-task_mmu-pin-mm_users-in-do_pagemap_scan-fix.patch
lib-cmdline-fix-get_options-count-and-overflow-with-large-ranges.patch
fat-roll-back-the-new-entry-when-create-mkdir-fails-to-build-the-inode-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch
profile-account-for-partial-proc-profile-reads.patch
profile-simplify-proc-profile-read-layout.patch

