Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87BE0A50
	for <mm-commits@vger.kernel.org>; Mon,  7 Apr 2025 01:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743987944; cv=none; b=boEXLzk0vTywa0HFSYTQEUE1VRd8OAVjFcE52el9z4kNmHutV4iJdmsrPZEsIZECNg8n2l1sRBvN0uM/xytJSIohfzpG4iglCc8R9Pso5Nvxo3uJVSuotTFnsKtD9q9kzmhQ/DM4vHSv5a8rPFaFDFPbVL4GvN6wB1q1bjTyaeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743987944; c=relaxed/simple;
	bh=yPQRktqrIPiGqPAyIkHZiNZhPd0+DO4lIbOfSZhysY0=;
	h=Date:To:From:Subject:Message-Id; b=X8naAiEulNeoRHG/+oazKeaJZyqY52Okj5Rvc2WmkljdHiwrvFSO0VTxxyosU4vuIAt7AssOuHWwxo1pz/thv3E69eD3bEx8D42i8HCqEkTgCfkJBaAFoBmTmVmj6Tr7AZuQp+aGoX/Udocl+kDD/Us/rv/pWx2M4gTP5ch2QRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mMAPHQ6E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mMAPHQ6E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0892C4CEE3;
	Mon,  7 Apr 2025 01:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743987943;
	bh=yPQRktqrIPiGqPAyIkHZiNZhPd0+DO4lIbOfSZhysY0=;
	h=Date:To:From:Subject:From;
	b=mMAPHQ6EweZVkrG8HlsmdByYOdOrtDXflS0tWE3Q2iPJELyMY69oL6oQFbG2DUF7+
	 pHUct8vaHno4c+0MzliBhuHpXNNh0wTTbUTsNTYHTsEg6fkeIODLybkoKsj8TWNYyp
	 U+0zflNoev209rp8i/w0GfmKRzijj9z+zTMNwbbI=
Date: Sun, 06 Apr 2025 18:05:42 -0700
To: mm-commits@vger.kernel.org,viresh.kumar@linaro.org,rafael@kernel.org,lukas.bulwahn@gmail.com,louis.chauvet@bootlin.com,joe@perches.com,dwaipayanray1@gmail.com,apw@canonical.com,jim.cromie@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + checkpatch-dont-warn-about-unused-macro-arg-on-empty-body.patch added to mm-nonmm-unstable branch
Message-Id: <20250407010542.E0892C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: checkpatch: dont warn about unused macro arg on empty body
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     checkpatch-dont-warn-about-unused-macro-arg-on-empty-body.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/checkpatch-dont-warn-about-unused-macro-arg-on-empty-body.patch

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
Subject: checkpatch: dont warn about unused macro arg on empty body
Date: Tue, 25 Mar 2025 17:51:54 -0600

Patch series "2 checkpatch fixes, one pr_info_once".

2 small tweaks to checkpatch,
1 reducing several pages of powernow "not-relevant-here" log-msgs to a few lines


This patch (of 3):

We currently get:
  WARNING: Argument 'name' is not used in function-like macro
on:
  #define DRM_CLASSMAP_USE(name)  /* nothing here */

Following this advice is wrong here, and shouldn't be fixed by ignoring
args altogether; the macro should properly fail if invoked with 0 or 2+
args.

Link: https://lkml.kernel.org/r/20250325235156.663269-1-jim.cromie@gmail.com
Link: https://lkml.kernel.org/r/20250325235156.663269-2-jim.cromie@gmail.com
Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
Acked-by: Joe Perches <joe@perches.com>
Reviewed-by: Louis Chauvet <louis.chauvet@bootlin.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Joe Perches <joe@perches.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc:"Rafael J. Wysocki" <rafael@kernel.org>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/checkpatch.pl~checkpatch-dont-warn-about-unused-macro-arg-on-empty-body
+++ a/scripts/checkpatch.pl
@@ -6038,7 +6038,7 @@ sub process {
 				}
 
 # check if this is an unused argument
-				if ($define_stmt !~ /\b$arg\b/) {
+				if ($define_stmt !~ /\b$arg\b/ && $define_stmt) {
 					WARN("MACRO_ARG_UNUSED",
 					     "Argument '$arg' is not used in function-like macro\n" . "$herectx");
 				}
_

Patches currently in -mm which might be from jim.cromie@gmail.com are

checkpatch-dont-warn-about-unused-macro-arg-on-empty-body.patch
checkpatch-qualify-do-while-0-advice.patch
powernow-use-pr_info_once.patch

