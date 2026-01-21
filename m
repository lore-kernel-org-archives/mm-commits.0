Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F303831A7F6
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768967325; cv=none; b=ChaXeBIrkbC4FF5tuhLifmxvH/GoeXWdvnNvlnjNjIxJI76Fyp/cMKXDHg1ZOgw2sD2cIVSssjeE0qYvn1B3IJXjzUzlq2qb8jHHGYgnVetz1ykbSV29Fx7KaBu9++sdj8s+YEm7k0N9eRkwyapHQRd+kVMpubs2xciQkO2AYaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768967325; c=relaxed/simple;
	bh=pmrHdEYolHijJsPVXLNL25rOx68VySeISstDAMtGM4g=;
	h=Date:To:From:Subject:Message-Id; b=M0NjrKM0yoPxHzDSCWaX4cPi5FirkF7e0PNeenNIpNt/Q5mNphvL7Wt+sbs80c1PsJDwGQwEBOcdJoFKsoQRDJjZkLG/M+bNoj0UUZHXHhxkasffHQ7Hr2wjtEL4PNQg/yRU0uN54AwJ65zkwLKv18OeXcuIEhNuyBkUkvkKcjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uLCpgIEC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uLCpgIEC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EE6FC16AAE;
	Wed, 21 Jan 2026 03:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768967324;
	bh=pmrHdEYolHijJsPVXLNL25rOx68VySeISstDAMtGM4g=;
	h=Date:To:From:Subject:From;
	b=uLCpgIECB/QH2Q5TEJRTKOw7ktfissAaCjt5Bpbrp1RJL5jp5ut8JuS5Xi6xJzJna
	 R8xkgQZzKlswV35loo7e5rAsXbNRtu+CaQm1is/A+/j5LkdQRKpJxNBrTAadrZR4cq
	 oS+K8jqQ9YU0I0fNWnWXjrRJCtNSfHuASarNE/Sc=
Date: Tue, 20 Jan 2026 19:48:43 -0800
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,torvalds@linux-foundation.org,mhocko@suse.com,macro@orcam.me.uk,linux@rasmusvillemoes.dk,kees@kernel.org,jannh@google.com,glider@google.com,elver@google.com,dvyukov@google.com,chris.bazley.wg14@gmail.com,alx@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] mm-fix-benign-off-by-one-bugs.patch removed from -mm tree
Message-Id: <20260121034844.3EE6FC16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: fix benign off-by-one bugs
has been removed from the -mm tree.  Its filename was
     mm-fix-benign-off-by-one-bugs.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alejandro Colomar <alx@kernel.org>
Subject: mm: fix benign off-by-one bugs
Date: Thu, 11 Dec 2025 11:43:54 +0100

We were wasting a byte due to an off-by-one bug.  s[c]nprintf() doesn't
write more than $2 bytes including the null byte, so trying to pass
'size-1' there is wasting one byte.

Link: https://lkml.kernel.org/r/9c38dd009c17b0219889c7089d9bdde5aaf28a8e.1765449750.git.alx@kernel.org
Signed-off-by: Alejandro Colomar <alx@kernel.org>
Acked-by: Marco Elver <elver@google.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Christopher Bazley <chris.bazley.wg14@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Maciej W. Rozycki <macro@orcam.me.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kfence/kfence_test.c |    4 ++--
 mm/kmsan/kmsan_test.c   |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/mm/kfence/kfence_test.c~mm-fix-benign-off-by-one-bugs
+++ a/mm/kfence/kfence_test.c
@@ -110,7 +110,7 @@ static bool report_matches(const struct
 
 	/* Title */
 	cur = expect[0];
-	end = &expect[0][sizeof(expect[0]) - 1];
+	end = ARRAY_END(expect[0]);
 	switch (r->type) {
 	case KFENCE_ERROR_OOB:
 		cur += scnprintf(cur, end - cur, "BUG: KFENCE: out-of-bounds %s",
@@ -140,7 +140,7 @@ static bool report_matches(const struct
 
 	/* Access information */
 	cur = expect[1];
-	end = &expect[1][sizeof(expect[1]) - 1];
+	end = ARRAY_END(expect[1]);
 
 	switch (r->type) {
 	case KFENCE_ERROR_OOB:
--- a/mm/kmsan/kmsan_test.c~mm-fix-benign-off-by-one-bugs
+++ a/mm/kmsan/kmsan_test.c
@@ -105,7 +105,7 @@ static bool report_matches(const struct
 
 	/* Title */
 	cur = expected_header;
-	end = &expected_header[sizeof(expected_header) - 1];
+	end = ARRAY_END(expected_header);
 
 	cur += scnprintf(cur, end - cur, "BUG: KMSAN: %s", r->error_type);
 
_

Patches currently in -mm which might be from alx@kernel.org are


