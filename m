Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B5B679DD4
	for <mm-commits@vger.kernel.org>; Tue, 12 Mar 2024 20:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710274185; cv=none; b=VqOHT6d++RVGSp+yLdJc2JNGDfTvZkIhtGWfvThEZeuszG7VEt4w2EBIR7iDQDPpEzpHOu1uyc/13BLg58cl/kQWjvv7IJ6jMB8FBQjQwvr5CfPt9hwNDMIiduOABgF+EZCLBb/mwSs11pejyOHskEJ3Ey4ttrAJNawNR+aXloM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710274185; c=relaxed/simple;
	bh=eD0zu6eOo3c5zXCRdGL1hLFWYO0kbjPbB4OYc0oWVdc=;
	h=Date:To:From:Subject:Message-Id; b=ahnVM9vXMBhhbtLFQ6EstoHMR1U05vf4QGwbvxcZF6oFMOmR71kN9SSKBU6GVxj8Y4MJVL9JssMiPULsBAH/Z597bp7Eo6A3nCSJbgaCcBaVwDUeJ6krVkr7f++9gv4NIWCTJXdCPJ7JcXv2w/v0aEuQsTXU8DWB7JINstoX15g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xGmnd8q8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xGmnd8q8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6458C433C7;
	Tue, 12 Mar 2024 20:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1710274184;
	bh=eD0zu6eOo3c5zXCRdGL1hLFWYO0kbjPbB4OYc0oWVdc=;
	h=Date:To:From:Subject:From;
	b=xGmnd8q8Yei1+/fqGnSNDQ8xl/MZqIBl3tOa6gcKkEHcDsTicwFHUkATrjQ1+46CE
	 W9lZnIYSrwA6bW5Wt/BxsuIAqXNoDHBBiFKcZcRUGyL8ny0J1TuLm1N8Jhoh4fbM0q
	 WV76zCrK3AmZgKV09+ZS9b/CYME0a0szcRS3fkEg=
Date: Tue, 12 Mar 2024 13:09:44 -0700
To: mm-commits@vger.kernel.org,biju.das.jz@bp.renesas.com,u.kleine-koenig@pengutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] mul_u64_u64_div_u64-increase-precision-by-conditionally-swapping-a-and-b.patch removed from -mm tree
Message-Id: <20240312200944.A6458C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mul_u64_u64_div_u64: increase precision by conditionally swapping a and b
has been removed from the -mm tree.  Its filename was
     mul_u64_u64_div_u64-increase-precision-by-conditionally-swapping-a-and-b.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Subject: mul_u64_u64_div_u64: increase precision by conditionally swapping a and b
Date: Sun, 3 Mar 2024 10:24:09 +0100

As indicated in the added comment, the algorithm works better if b is big.
As multiplication is commutative, a and b can be swapped.  Do this if a
is bigger than b.

Link: https://lkml.kernel.org/r/20240303092408.662449-2-u.kleine-koenig@pengutronix.de
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Tested-by: Biju Das <biju.das.jz@bp.renesas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/math/div64.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/lib/math/div64.c~mul_u64_u64_div_u64-increase-precision-by-conditionally-swapping-a-and-b
+++ a/lib/math/div64.c
@@ -22,6 +22,7 @@
 #include <linux/export.h>
 #include <linux/math.h>
 #include <linux/math64.h>
+#include <linux/minmax.h>
 #include <linux/log2.h>
 
 /* Not needed on 64bit architectures */
@@ -191,6 +192,20 @@ u64 mul_u64_u64_div_u64(u64 a, u64 b, u6
 	/* can a * b overflow ? */
 	if (ilog2(a) + ilog2(b) > 62) {
 		/*
+		 * Note that the algorithm after the if block below might lose
+		 * some precision and the result is more exact for b > a. So
+		 * exchange a and b if a is bigger than b.
+		 *
+		 * For example with a = 43980465100800, b = 100000000, c = 1000000000
+		 * the below calculation doesn't modify b at all because div == 0
+		 * and then shift becomes 45 + 26 - 62 = 9 and so the result
+		 * becomes 4398035251080. However with a and b swapped the exact
+		 * result is calculated (i.e. 4398046510080).
+		 */
+		if (a > b)
+			swap(a, b);
+
+		/*
 		 * (b * a) / c is equal to
 		 *
 		 *      (b / c) * a +
_

Patches currently in -mm which might be from u.kleine-koenig@pengutronix.de are

lib-build_oid_registry-dont-mention-the-full-path-of-the-script-in-output.patch

