Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C6465474E
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896567; cv=none; b=sPHVDCsiIiJenS2d/0Ksc/w2CFi3IL8/5B1elHlGI9heu81s4CxMOrPhEDrTFN51MhXNNtOhSI+IVMelbuANCZU4AbUbcYKHykVNMxKd6OnCSz/y2RLnNdMroEJY07SDnaNisOO8JZUc7kU1TqL1GNA4JHOwbbeqWxz0ZHZwwls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896567; c=relaxed/simple;
	bh=57u/jOa1/Ar34pko5XyED0VEX9C+PCZ8Ju1gPxJUAoI=;
	h=Date:To:From:Subject:Message-Id; b=mA+gDaABE4YfTABT8pqsKTsUzV1pLnMLRF+hMceoHgQvGNfEXn/E0tMMpU0ZHJFj6IXkfxHMrHpMhyy+pGnXkFfjzfLdOezdGKpOtYKXUSHoVAZVaJZmJIx18Y+y+PB6d4q0iDJFXwMucYB5a9O2SKxB/O4MWyGoBX22oeROTVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Dz0rCtf2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Dz0rCtf2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9BCA1F000E9;
	Wed,  5 Aug 2026 02:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896565;
	bh=lqsxZfHIOWDE5IbUQ/vJLjbEfLCwUQWEA8NwXPdFkz0=;
	h=Date:To:From:Subject;
	b=Dz0rCtf2v6eNWHhl7lic6p8J3TRAQPyVwOtLgTppfB+8S7F+vmi5dt9xOQIUy4jTt
	 Wa6NUOV98TZzPb0xzD5iPyxjLa+IlGLKsHWHZDF6+LbaaBDbS+3tHIcwcTZ1CgtzMV
	 NQP9VWOYQ5ciLQpqvKANU7vwXEbmvujj5nzfjOA8=
Date: Tue, 04 Aug 2026 19:22:45 -0700
To: mm-commits@vger.kernel.org,liam@infradead.org,git@tazy.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] lib-maple_tree-add-missing-spaces-after-switch-keyword.patch removed from -mm tree
Message-Id: <20260805022245.C9BCA1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/maple_tree: add missing spaces after switch keyword
has been removed from the -mm tree.  Its filename was
     lib-maple_tree-add-missing-spaces-after-switch-keyword.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Watson Wheeler <git@tazy.dev>
Subject: lib/maple_tree: add missing spaces after switch keyword
Date: Tue, 23 Jun 2026 16:17:12 +1000

Add the required space before the opening parenthesis in switch statements
to conform to kernel coding style.

Link: https://lore.kernel.org/20260623061730.2024-1-git@tazy.dev
Signed-off-by: Watson Wheeler <git@tazy.dev>
Reviewed-by: Liam Howlett <liam@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/lib/maple_tree.c~lib-maple_tree-add-missing-spaces-after-switch-keyword
+++ a/lib/maple_tree.c
@@ -6447,7 +6447,7 @@ static void mt_dump_range(unsigned long
 {
 	static const char spaces[] = "                                ";
 
-	switch(format) {
+	switch (format) {
 	case mt_dump_hex:
 		if (min == max)
 			pr_info("%.*s%lx: ", depth * 2, spaces, min);
@@ -6489,7 +6489,7 @@ static void mt_dump_range64(const struct
 
 	pr_cont(" contents: ");
 	for (i = 0; i < MAPLE_RANGE64_SLOTS - 1; i++) {
-		switch(format) {
+		switch (format) {
 		case mt_dump_hex:
 			pr_cont(PTR_FMT " %lX ", node->slot[i], node->pivot[i]);
 			break;
@@ -6517,7 +6517,7 @@ static void mt_dump_range64(const struct
 		if (last == max)
 			break;
 		if (last > max) {
-			switch(format) {
+			switch (format) {
 			case mt_dump_hex:
 				pr_err("node " PTR_FMT " last (%lx) > max (%lx) at pivot %d!\n",
 					node, last, max, i);
@@ -6576,7 +6576,7 @@ static void mt_dump_arange64(const struc
 		if (last == max)
 			break;
 		if (last > max) {
-			switch(format) {
+			switch (format) {
 			case mt_dump_hex:
 				pr_err("node " PTR_FMT " last (%lx) > max (%lx) at pivot %d!\n",
 					node, last, max, i);
_

Patches currently in -mm which might be from git@tazy.dev are


