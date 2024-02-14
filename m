Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D19660247
	for <mm-commits@vger.kernel.org>; Wed, 14 Feb 2024 16:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707927161; cv=none; b=q7+eFP2jeTOJSOYE05glrFDsyBnw27MFVhAIITHoMXcPea5GbyMC4fbxnR2IbXnAVKhyebRPyYcEtPXLZBjNe/v9jQimEC5deUGqXmAY+F2AXJHClyIQtU7Qts5Rs346+5aUPeEg8EoqpR+qjt7tejurLCFlWFbF8AIMYIIiP8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707927161; c=relaxed/simple;
	bh=/j1BEfBnvOKKsu8ZnWYYNJ8cdalKZKp+SZdFQ/0LhMc=;
	h=Date:To:From:Subject:Message-Id; b=ixzxkUZm+msIb3HSUecqgcVlQUDJIjN2i6ec2VmKUfVNS0MFi08EAbkbO3IOnpQzL4ckJMq8TJUJJWhttDqdsJ7h7EKpS41+XBPpV9zOskuXrZTq0AlpK4g8cSEToDKjXUzTA2wZriiuHs2Wsd/bbE9SUZkQzfqj11kcOdCivkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cMFYHVYd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cMFYHVYd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EEB3C433C7;
	Wed, 14 Feb 2024 16:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707927160;
	bh=/j1BEfBnvOKKsu8ZnWYYNJ8cdalKZKp+SZdFQ/0LhMc=;
	h=Date:To:From:Subject:From;
	b=cMFYHVYdcfAjYlm8kwHkUQC82/hDLorlkoAfTWnttTdU19GPbQaAHY6OT/hM5J96g
	 /HV0jjG75y1g5ZTydFVc7Wcb8lp+96IvbDhTlMig1gdMOynSQ93Gm7nYG2vUGtRyrk
	 JDU2vomRx5TI/1usP+4qAcugC+VMt8RgHUUpoP64=
Date: Wed, 14 Feb 2024 08:12:39 -0800
To: mm-commits@vger.kernel.org,mcgrof@kernel.org,jim.cromie@gmail.com,jbaron@akamai.com,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + dyndbg-replace-kstrdup-strchr-with-kstrdup_and_replace.patch added to mm-nonmm-unstable branch
Message-Id: <20240214161240.7EEB3C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: dyndbg: replace kstrdup() + strchr() with kstrdup_and_replace()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     dyndbg-replace-kstrdup-strchr-with-kstrdup_and_replace.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/dyndbg-replace-kstrdup-strchr-with-kstrdup_and_replace.patch

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
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: dyndbg: replace kstrdup() + strchr() with kstrdup_and_replace()
Date: Tue, 13 Feb 2024 18:27:41 +0200

Replace open coded functionalify of kstrdup_and_replace() with a call.

Link: https://lkml.kernel.org/r/20240213162741.3102810-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Cc: Jason Baron <jbaron@akamai.com>
Cc: Jim Cromie <jim.cromie@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/dynamic_debug.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/lib/dynamic_debug.c~dyndbg-replace-kstrdup-strchr-with-kstrdup_and_replace
+++ a/lib/dynamic_debug.c
@@ -640,10 +640,9 @@ static int param_set_dyndbg_classnames(c
 	int cls_id, totct = 0;
 	bool wanted;
 
-	cl_str = tmp = kstrdup(instr, GFP_KERNEL);
-	p = strchr(cl_str, '\n');
-	if (p)
-		*p = '\0';
+	cl_str = tmp = kstrdup_and_replace(instr, '\n', '\0', GFP_KERNEL);
+	if (!tmp)
+		return -ENOMEM;
 
 	/* start with previously set state-bits, then modify */
 	curr_bits = old_bits = *dcp->bits;
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

dyndbg-replace-kstrdup-strchr-with-kstrdup_and_replace.patch

