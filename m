Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E05E70830
	for <mm-commits@vger.kernel.org>; Thu,  9 Oct 2025 21:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760044285; cv=none; b=lCwFpkhSin7r8l02aVwN2wvy71Fn1Qglr6t/1vSEVKe0rjN6vctCAfrOYLPDb/9CrmOq/K68p2JdrfFQFQ6/bE+on+lhX5KDMYCkOYRLY6aKV/lMkOr+w3GtY3O6I3paAO/b+DaunO6j+y6Q49JLvETDNCieOdVomM/s5KXvzAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760044285; c=relaxed/simple;
	bh=RuMuR6p4cFT1BJaprJtTnVJaW/vH9Jf0cc3bNJV8Yxw=;
	h=Date:To:From:Subject:Message-Id; b=l2CVTmoQgFyGnSqMrWIcvkWdxXzIeWJQ8T3x9fOQqeQca7zQGZVVNcl+BCQ1s16JGNhAzhU0G4Rt/b5wW71YpQOoNinXcuiC7ffEyejgriVa3lfE6BS9eiM+ExZzaEpWKalggevVbK8/R1qlVqPZKB1p8uWGeq8hRvSmdzdsyF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cz1zEnsy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cz1zEnsy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADC90C4CEE7;
	Thu,  9 Oct 2025 21:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760044284;
	bh=RuMuR6p4cFT1BJaprJtTnVJaW/vH9Jf0cc3bNJV8Yxw=;
	h=Date:To:From:Subject:From;
	b=cz1zEnsySqM8fIJ6wm7gSvcnH66xHEUDc2nigRpOs1nIK4VvPoamglqbmGsvkWQzt
	 Yay5dLymo2oDBxlMTMGZs3xNo0f1aqanQjSeJBCodF5TMt7v+tIyveDSw7jiMBByZd
	 yQnYoGIT2AQD+tGf3IFDOcP9GtkD+jRaGhWg9PJ8=
Date: Thu, 09 Oct 2025 14:11:24 -0700
To: mm-commits@vger.kernel.org,lukas.bulwahn@gmail.com,joe@perches.com,dwaipayanray1@gmail.com,corbet@lwn.net,apw@canonical.com,work@onurozkan.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + checkpatch-detect-unhandled-placeholders-in-cover-letters.patch added to mm-nonmm-unstable branch
Message-Id: <20251009211124.ADC90C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: checkpatch: detect unhandled placeholders in cover letters
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     checkpatch-detect-unhandled-placeholders-in-cover-letters.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/checkpatch-detect-unhandled-placeholders-in-cover-letters.patch

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
From: Onur Özkan <work@onurozkan.dev>
Subject: checkpatch: detect unhandled placeholders in cover letters
Date: Wed, 17 Sep 2025 20:37:24 +0300

Add a new check PLACEHOLDER_USE to detect unhandled placeholders.  This
prevents sending patch series with incomplete patches (mostly in cover
letters) containing auto generated subject or blurb lines.

These placeholders can be seen on mailing lists.  With this change,
checkpatch will emit an error when such text is found.

Link: https://lkml.kernel.org/r/20250917173725.22547-2-work@onurozkan.dev
Signed-off-by: Onur Özkan <work@onurozkan.dev>
Acked-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/scripts/checkpatch.pl~checkpatch-detect-unhandled-placeholders-in-cover-letters
+++ a/scripts/checkpatch.pl
@@ -3345,6 +3345,13 @@ sub process {
 			}
 		}
 
+# Check for auto-generated unhandled placeholder text (mostly for cover letters)
+		if (($in_commit_log || $in_header_lines) &&
+		    $rawline =~ /(?:SUBJECT|BLURB) HERE/) {
+			ERROR("PLACEHOLDER_USE",
+			      "Placeholder text detected\n" . $herecurr);
+		}
+
 # Check for git id commit length and improperly formed commit descriptions
 # A correctly formed commit description is:
 #    commit <SHA-1 hash length 12+ chars> ("Complete commit subject")
_

Patches currently in -mm which might be from work@onurozkan.dev are

checkpatch-detect-unhandled-placeholders-in-cover-letters.patch
checkpatch-document-new-check-placeholder_use.patch

