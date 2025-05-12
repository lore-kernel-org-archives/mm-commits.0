Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 865DA2EB10
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011347; cv=none; b=ZwB8uw8rEr3YJpsxamHVkVkrmsOaOwKxs9Qzw42zTGPjb6rRziKJS3MpFf5H1A5X6g8mnVK5CKUZVKMlhYEwn4DmyPMXzsDw1qGimTpR2gMN0QMXwBvS8l76IS1CQB56M/2QS1/bgpg5HKKXXt2zgsvghHNZUW67VF7o1v0Eeyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011347; c=relaxed/simple;
	bh=yVgipgPNCAvfyYJiaj6Ywv3aZ1TVq6kpmCCQEqjmN0M=;
	h=Date:To:From:Subject:Message-Id; b=MpiIu9uyBAihK7dFCcy6rcS76B2LlbLCG+D7rWGA8CFiijT0h5r7XFY/Fufxfn7jeOhHrU1F8CRFWXlAd+xbK3XZCAlOT7LtiX7ENkIV8C0hZqLFcaDi3fFm41y1JBemNlTebDzs7uhj7972hNOAAfgw9g0sRry07uZHTVKN5uQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=124gpLqa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="124gpLqa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E96F3C4CEE4;
	Mon, 12 May 2025 00:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011347;
	bh=yVgipgPNCAvfyYJiaj6Ywv3aZ1TVq6kpmCCQEqjmN0M=;
	h=Date:To:From:Subject:From;
	b=124gpLqafjaWGo6L1ZRSyNgZ2e4q5u9oXGwqnwddcPo3VFyMA5pOHL2MGJb5vae2Q
	 vdHbbEoZfrx4tv4cQilF4NZOhuE1hKKupCp0tjsi28yW00WlRCLp2tE2y+QHG5D5Rm
	 jx4/IuZM2yUQOW/6g1Bnpz/+Iil0ikPZZ0hdAvcs=
Date: Sun, 11 May 2025 17:55:46 -0700
To: mm-commits@vger.kernel.org,viresh.kumar@linaro.org,lukas.bulwahn@gmail.com,louis.chauvet@bootlin.com,joe@perches.com,dwaipayanray1@gmail.com,apw@canonical.com,jim.cromie@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] checkpatch-qualify-do-while-0-advice.patch removed from -mm tree
Message-Id: <20250512005546.E96F3C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: checkpatch: qualify do-while-0 advice
has been removed from the -mm tree.  Its filename was
     checkpatch-qualify-do-while-0-advice.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jim Cromie <jim.cromie@gmail.com>
Subject: checkpatch: qualify do-while-0 advice
Date: Tue, 25 Mar 2025 17:51:55 -0600

Add a paragraph of advice qualifying the general do-while-0 advice, noting
3 possible misguidings.  reduce one ERROR to WARN, for the case I actually
encountered.

And add 'static_assert' to named exceptions, along with some additional
comments about named exceptions vs (detection of) declarative construction
primitives (union, struct, [], etc).

Link: https://lkml.kernel.org/r/20250325235156.663269-3-jim.cromie@gmail.com
Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Joe Perches <joe@perches.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Louis Chauvet <louis.chauvet@bootlin.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   33 +++++++++++++++++++++++++++------
 1 file changed, 27 insertions(+), 6 deletions(-)

--- a/scripts/checkpatch.pl~checkpatch-qualify-do-while-0-advice
+++ a/scripts/checkpatch.pl
@@ -151,6 +151,24 @@ EOM
 	exit($exitcode);
 }
 
+my $DO_WHILE_0_ADVICE = q{
+   do {} while (0) advice is over-stated in a few situations:
+
+   The more obvious case is macros, like MODULE_PARM_DESC, invoked at
+   file-scope, where C disallows code (it must be in functions).  See
+   $exceptions if you have one to add by name.
+
+   More troublesome is declarative macros used at top of new scope,
+   like DECLARE_PER_CPU.  These might just compile with a do-while-0
+   wrapper, but would be incorrect.  Most of these are handled by
+   detecting struct,union,etc declaration primitives in $exceptions.
+
+   Theres also macros called inside an if (block), which "return" an
+   expression.  These cannot do-while, and need a ({}) wrapper.
+
+   Enjoy this qualification while we work to improve our heuristics.
+};
+
 sub uniq {
 	my %seen;
 	return grep { !$seen{$_}++ } @_;
@@ -5883,9 +5901,9 @@ sub process {
 			}
 		}
 
-# multi-statement macros should be enclosed in a do while loop, grab the
-# first statement and ensure its the whole macro if its not enclosed
-# in a known good container
+# Usually multi-statement macros should be enclosed in a do {} while
+# (0) loop.  Grab the first statement and ensure its the whole macro
+# if its not enclosed in a known good container
 		if ($realfile !~ m@/vmlinux.lds.h$@ &&
 		    $line =~ /^.\s*\#\s*define\s*$Ident(\()?/) {
 			my $ln = $linenr;
@@ -5938,10 +5956,13 @@ sub process {
 
 			my $exceptions = qr{
 				$Declare|
+				# named exceptions
 				module_param_named|
 				MODULE_PARM_DESC|
 				DECLARE_PER_CPU|
 				DEFINE_PER_CPU|
+				static_assert|
+				# declaration primitives
 				__typeof__\(|
 				union|
 				struct|
@@ -5976,11 +5997,11 @@ sub process {
 					ERROR("MULTISTATEMENT_MACRO_USE_DO_WHILE",
 					      "Macros starting with if should be enclosed by a do - while loop to avoid possible if/else logic defects\n" . "$herectx");
 				} elsif ($dstat =~ /;/) {
-					ERROR("MULTISTATEMENT_MACRO_USE_DO_WHILE",
-					      "Macros with multiple statements should be enclosed in a do - while loop\n" . "$herectx");
+					WARN("MULTISTATEMENT_MACRO_USE_DO_WHILE",
+					      "Non-declarative macros with multiple statements should be enclosed in a do - while loop\n" . "$herectx\nBUT SEE:\n$DO_WHILE_0_ADVICE");
 				} else {
 					ERROR("COMPLEX_MACRO",
-					      "Macros with complex values should be enclosed in parentheses\n" . "$herectx");
+					      "Macros with complex values should be enclosed in parentheses\n" . "$herectx\nBUT SEE:\n$DO_WHILE_0_ADVICE");
 				}
 
 			}
_

Patches currently in -mm which might be from jim.cromie@gmail.com are


