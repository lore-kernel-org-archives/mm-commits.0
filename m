Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F3ED1632E7
	for <mm-commits@vger.kernel.org>; Mon,  6 Jul 2026 01:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783299732; cv=none; b=Q8yeLObqe7Ga+vkp0e7Mlmig9FZkRMI9kOQSjvg9JQygspPZMypFu+UBL8PVbE5516XXGBhpCLs98fW33Wl+nL2Je5QHtykajt5cPSF3uBUnGp9a9aEJ4FRs062mycq0DU/HJdllHqQUJ4TXLQmIvi+x2ytDQx2npF8strhMAGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783299732; c=relaxed/simple;
	bh=CSYyBB/wM9190MDXR8yuXCe4vWCg6s9AZfpMpdoCCgs=;
	h=Date:To:From:Subject:Message-Id; b=AFIma1cwcxOTJQryBNgDYTZ+rh9vBjWybGUGC33OOoP/jEtxTswMGgu4HzBkqrHTSBio3llhCjWXOeKCvtcjs0rpHJ8ReS8tbZt1pd+a3GkS7pbT0Yq8k4x9lQsp8a/5jXw/JcXMjI/edHsvw7BcK57HQaw3CN3n8Afq4urdIgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=w1qIoisn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="w1qIoisn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F6DC1F000E9;
	Mon,  6 Jul 2026 01:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783299730;
	bh=v0tHVoPD98n8riIx4OCos+ykmRbFbwZw7F4GiofqekY=;
	h=Date:To:From:Subject;
	b=w1qIoisn3K4kb0f7s1QgNMeN8XVUKHKMy96UxgDT0x5bHVrGfkV81we5bFQpUkaBV
	 /k4QpikDqbpPipqVODlhUMSp4BxtFo4gKv24sWCz8WdDKri5FS3+3DXf6tzHSEwpxx
	 SjFOa6ALRnwjnRhNLaclPkEQOdPC1XZfLUSz1yNI=
Date: Sun, 05 Jul 2026 18:02:10 -0700
To: mm-commits@vger.kernel.org,liam@infradead.org,git@tazy.dev,imnotamilkglass@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-maple_tree-add-missing-spaces-after-switch-keyword.patch added to mm-new branch
Message-Id: <20260706010210.9F6DC1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/maple_tree: add missing spaces after switch keyword
has been added to the -mm mm-new branch.  Its filename is
     lib-maple_tree-add-missing-spaces-after-switch-keyword.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-maple_tree-add-missing-spaces-after-switch-keyword.patch

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
From: Watson Wheeler <imnotamilkglass@gmail.com>
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
@@ -6580,7 +6580,7 @@ static void mt_dump_range(unsigned long
 {
 	static const char spaces[] = "                                ";
 
-	switch(format) {
+	switch (format) {
 	case mt_dump_hex:
 		if (min == max)
 			pr_info("%.*s%lx: ", depth * 2, spaces, min);
@@ -6622,7 +6622,7 @@ static void mt_dump_range64(const struct
 
 	pr_cont(" contents: ");
 	for (i = 0; i < MAPLE_RANGE64_SLOTS - 1; i++) {
-		switch(format) {
+		switch (format) {
 		case mt_dump_hex:
 			pr_cont(PTR_FMT " %lX ", node->slot[i], node->pivot[i]);
 			break;
@@ -6650,7 +6650,7 @@ static void mt_dump_range64(const struct
 		if (last == max)
 			break;
 		if (last > max) {
-			switch(format) {
+			switch (format) {
 			case mt_dump_hex:
 				pr_err("node " PTR_FMT " last (%lx) > max (%lx) at pivot %d!\n",
 					node, last, max, i);
@@ -6709,7 +6709,7 @@ static void mt_dump_arange64(const struc
 		if (last == max)
 			break;
 		if (last > max) {
-			switch(format) {
+			switch (format) {
 			case mt_dump_hex:
 				pr_err("node " PTR_FMT " last (%lx) > max (%lx) at pivot %d!\n",
 					node, last, max, i);
_

Patches currently in -mm which might be from imnotamilkglass@gmail.com are

lib-maple_tree-add-missing-spaces-after-switch-keyword.patch

