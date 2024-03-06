Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CD9418B1B
	for <mm-commits@vger.kernel.org>; Wed,  6 Mar 2024 21:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709759292; cv=none; b=PpnZlUjj3qh3hffH6qXcSZjC535ZjY+zyPFZXdLIJtF8Pqg167Je30ZfQxThGUg6Frkzq6d2airHe5Ckv43Q6fa0LMZp8vnlOWs27LjMJVR5j4ffz1kDQJKyRpBXGZtRlABHhYWyv4M7A/HeS6gSNnoheyCwm6AeCOA4CtI/huM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709759292; c=relaxed/simple;
	bh=tkCwRqE9WM7Jw91uWFXekwuB/2g2i/dh2gc/RBOtqTg=;
	h=Date:To:From:Subject:Message-Id; b=RuDhG7cRiEP2uNaTMX/6Hy+OC8zn0WqOH3152/huD5cWRspr02VBMUmFATdxjdVtK9obRQekG6rJ1+CruApuGogDwWXJ8eeUybcO4Rpp9uhluR/5ofMqmbv/b6PaRbVRxOzMI2usRBKzV6K7cVDkREfTqtlMLnfBxZLRcKsqWwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0cBJgzwF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0cBJgzwF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C648CC433F1;
	Wed,  6 Mar 2024 21:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709759290;
	bh=tkCwRqE9WM7Jw91uWFXekwuB/2g2i/dh2gc/RBOtqTg=;
	h=Date:To:From:Subject:From;
	b=0cBJgzwFZ4pVRGCdw6MatgWW2dZondlRNYX/o6tgwETLYREMwoYPLixfs5SCiqjv+
	 8XycJrnF0Gq1zDtDg0zk4KxarRLKQGb9lkI7M5eh4Y5lW8BO3Qc1vdS1nQ1yKgxiI+
	 tus4/GUCSj8YxpQN0k1N3v1ZLqIWvrNYQ6GWp31A=
Date: Wed, 06 Mar 2024 13:08:10 -0800
To: mm-commits@vger.kernel.org,mcgrof@kernel.org,jim.cromie@gmail.com,jbaron@akamai.com,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] dyndbg-replace-kstrdup-strchr-with-kstrdup_and_replace.patch removed from -mm tree
Message-Id: <20240306210810.C648CC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: dyndbg: replace kstrdup() + strchr() with kstrdup_and_replace()
has been removed from the -mm tree.  Its filename was
     dyndbg-replace-kstrdup-strchr-with-kstrdup_and_replace.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


