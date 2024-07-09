Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67125187842
	for <mm-commits@vger.kernel.org>; Tue,  9 Jul 2024 21:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720562061; cv=none; b=lHn1SmTwvRjLFTKcxh0B1QrvwNb8Dt/ZFoKQk0HR+M6zJNWeXzDjP1Nu1F5n1TZShQXBjVHkUf/Uu8rQ6mOiVyBdVt6RNqjbDyhHnn9RII4rBN0I3beeYQjcemo/2GarfAku5mXqRL6sRZt+MgR38p2O0Z1Tl64tn+VDbcIfYfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720562061; c=relaxed/simple;
	bh=3BGTFJor1iecsQkunaBGcW3MBE4Ab4Ja+PEIIjzvE+c=;
	h=Date:To:From:Subject:Message-Id; b=CQGLFti68LJW+z2q6cf/EFUGNfVkWU8P+5Wkp2ycAjGPCmdjKKJYQE+Xn2OAUTz7pjUNSooeoIXv2i6DxdYr5I+FxCTuYS3hw4Uug9kmpmj1XLoXhSJYlJAWBxEKlFjbJbn6czyuhn7s9gryrjTI/hzFqLaXCVLgNknz+i416AQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NGoS2Hty; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NGoS2Hty"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5745C3277B;
	Tue,  9 Jul 2024 21:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720562060;
	bh=3BGTFJor1iecsQkunaBGcW3MBE4Ab4Ja+PEIIjzvE+c=;
	h=Date:To:From:Subject:From;
	b=NGoS2Hty4tLE2dmplnx4MTpvQLcE3QwsiHdN1sWkJvaAkKPuwBue9yYSJaY9/VfxC
	 nAajMT0Q7mNM456aNhahOOfvGw3wA3h1PTeP9v/d91L+M1WsPFUNjWQyhibFUZCnfv
	 GVorXk30T4b42caCc7469LjCik/6FvlFqJtBMNUg=
Date: Tue, 09 Jul 2024 14:54:20 -0700
To: mm-commits@vger.kernel.org,thorsten.blum@toblux.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-bchc-use-swap-to-improve-code.patch added to mm-nonmm-unstable branch
Message-Id: <20240709215420.D5745C3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/bch.c: use swap() to improve code
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-bchc-use-swap-to-improve-code.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-bchc-use-swap-to-improve-code.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Thorsten Blum <thorsten.blum@toblux.com>
Subject: lib/bch.c: use swap() to improve code
Date: Tue, 9 Jul 2024 00:40:24 +0200

Use the swap() macro to simplify the functions solve_linear_system() and
gf_poly_gcd() and improve their readability.  Remove the local variable
tmp.

Fixes the following three Coccinelle/coccicheck warnings reported by
swap.cocci:

  WARNING opportunity for swap()
  WARNING opportunity for swap()
  WARNING opportunity for swap()

Compile-tested only.

Link: https://lkml.kernel.org/r/20240708224023.9312-2-thorsten.blum@toblux.com
Signed-off-by: Thorsten Blum <thorsten.blum@toblux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bch.c |   20 +++++---------------
 1 file changed, 5 insertions(+), 15 deletions(-)

--- a/lib/bch.c~lib-bchc-use-swap-to-improve-code
+++ a/lib/bch.c
@@ -479,11 +479,8 @@ static int solve_linear_system(struct bc
 		/* find suitable row for elimination */
 		for (r = p; r < m; r++) {
 			if (rows[r] & mask) {
-				if (r != p) {
-					tmp = rows[r];
-					rows[r] = rows[p];
-					rows[p] = tmp;
-				}
+				if (r != p)
+					swap(rows[r], rows[p]);
 				rem = r+1;
 				break;
 			}
@@ -799,21 +796,14 @@ static void gf_poly_div(struct bch_contr
 static struct gf_poly *gf_poly_gcd(struct bch_control *bch, struct gf_poly *a,
 				   struct gf_poly *b)
 {
-	struct gf_poly *tmp;
-
 	dbg("gcd(%s,%s)=", gf_poly_str(a), gf_poly_str(b));
 
-	if (a->deg < b->deg) {
-		tmp = b;
-		b = a;
-		a = tmp;
-	}
+	if (a->deg < b->deg)
+		swap(a, b);
 
 	while (b->deg > 0) {
 		gf_poly_mod(bch, a, b, NULL);
-		tmp = b;
-		b = a;
-		a = tmp;
+		swap(a, b);
 	}
 
 	dbg("%s\n", gf_poly_str(a));
_

Patches currently in -mm which might be from thorsten.blum@toblux.com are

lib-bchc-use-swap-to-improve-code.patch

