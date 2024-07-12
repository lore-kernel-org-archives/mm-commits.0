Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C08F12FB2F
	for <mm-commits@vger.kernel.org>; Fri, 12 Jul 2024 23:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720827621; cv=none; b=EFyPPCqT0QVMzNbtdiIN4AcUAW6WcmdJRk6CqUdKD+4BF7+IWLkKExRayE/NxYKAIVQpTsuDCrEIyUYLhEGWd7SBL9z7xXEC2Ilkvi7bIhpChTrCog+60AbvppBT9ZcNEbJSm7LCreaUAGA4abTv7jqvDuX3h9y+VJ/36/mvZaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720827621; c=relaxed/simple;
	bh=q7TUsl7OTjUAKjtRAEZXFPrz4BJykWze3k9U0N3gtVU=;
	h=Date:To:From:Subject:Message-Id; b=dlOlZTf4t6O4A70HXrc9btP/2cbmV7iBFUBD5VD9ielhY8pOibgu+yieL29Api8BRATuRZV2fn2WFUfRiznO12xfeIm6HXyURk3LzXufwrFSEOVN0wcBkW0otJ7d/+DVZH77DoDpH7koWYHc/fMaTjVq8HaY97xv1L0lKQTTbQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=soN3dKkI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="soN3dKkI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0F26C32782;
	Fri, 12 Jul 2024 23:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720827620;
	bh=q7TUsl7OTjUAKjtRAEZXFPrz4BJykWze3k9U0N3gtVU=;
	h=Date:To:From:Subject:From;
	b=soN3dKkIyiPD3JNIWygaZ1VsESMlwg0tPJmB8K318bgPqgM/N8aFP8GJvQmtF36r1
	 BVi4oevy0sbw+LNumMrxqZ9Rpwpp4xsyU/aR6WaM+LG/vTnPQwauIriXBgc7X70BZg
	 G5rt2vzpb9y4mBtOAaO5RCSDx/+FBS24g14rToWk=
Date: Fri, 12 Jul 2024 16:40:20 -0700
To: mm-commits@vger.kernel.org,thorsten.blum@toblux.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-bchc-use-swap-to-improve-code.patch removed from -mm tree
Message-Id: <20240712234020.D0F26C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/bch.c: use swap() to improve code
has been removed from the -mm tree.  Its filename was
     lib-bchc-use-swap-to-improve-code.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

bootconfig-remove-duplicate-included-header-file-linux-bootconfigh.patch

