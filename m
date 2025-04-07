Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0227817BA3
	for <mm-commits@vger.kernel.org>; Mon,  7 Apr 2025 01:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743987945; cv=none; b=B29odCd2dZgxMFOxbAUi06zJlWANFYMNZfsUTNU2pEF0kEsw9oesVXAfV2DidNSkQAiNdMVaFoZ5hrKeksDGaPZPIIfLMj+k3Feev8pHBYLlVFWypAUHLScIzDAkTgdFyyECTN9wqdL4mKeGGkWP8vAEoqgYdd+8nkD65RxXtII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743987945; c=relaxed/simple;
	bh=Ld6SwHJRIlpgRTZAg8EmxzXOHGQfR1MGbaBbgjAz29k=;
	h=Date:To:From:Subject:Message-Id; b=dC2fwsQ5nDWGrfnzEJqzvC6Cwbo5Sw8/Gvv0qOelftMV9M7w9CchhasM05LJaOobOAu+9yOnkWWyFYk7Q0ykFb8Pu9S3pUjMZp0QNUu8im8OSBHxrU7OlcWvYc5W5F4KlKRjrJhGxGd6Z1gTuTERHypb+JLvPLdIfnWmvmwzflU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kMHorsu0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kMHorsu0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1930C4CEE3;
	Mon,  7 Apr 2025 01:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743987944;
	bh=Ld6SwHJRIlpgRTZAg8EmxzXOHGQfR1MGbaBbgjAz29k=;
	h=Date:To:From:Subject:From;
	b=kMHorsu0JZjzWNNAEe6PFhHQ4IWwEHbR+D32C32SA12f+Ps7BqCYxJYgxvkgp2XWI
	 YceHxAXXj1LPqP9fSGj0uvK5EXrQ5AV2J69Tdz+bo0dmOReiCSByabhku8Uiq40rWW
	 O/AkvjrZmEbqnvub2GWPT8OXLhvQXY6hcNvWiG4c=
Date: Sun, 06 Apr 2025 18:05:44 -0700
To: mm-commits@vger.kernel.org,viresh.kumar@linaro.org,lukas.bulwahn@gmail.com,louis.chauvet@bootlin.com,joe@perches.com,dwaipayanray1@gmail.com,apw@canonical.com,jim.cromie@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + checkpatch-qualify-do-while-0-advice.patch added to mm-nonmm-unstable branch
Message-Id: <20250407010544.C1930C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: checkpatch: qualify do-while-0 advice
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     checkpatch-qualify-do-while-0-advice.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/checkpatch-qualify-do-while-0-advice.patch

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
@@ -5897,9 +5915,9 @@ sub process {
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
@@ -5952,10 +5970,13 @@ sub process {
 
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
@@ -5990,11 +6011,11 @@ sub process {
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

checkpatch-dont-warn-about-unused-macro-arg-on-empty-body.patch
checkpatch-qualify-do-while-0-advice.patch
powernow-use-pr_info_once.patch

