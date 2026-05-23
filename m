Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 430A818BBAE
	for <mm-commits@vger.kernel.org>; Sat, 23 May 2026 02:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779503104; cv=none; b=OhaP8y4bO42o0Bbu1Hvi0bTH4jH641z0Da0ddaJYyiJ4jWDqSiyKOh1bA7hyCqnhhLPyC7O+V6tyCMz6aykLGYUq86bU2he6i5UMlgSMJRkZl4nx5hBYql3HfEnGWKB+XHbUQ3Fj/SO1Hj3L7waVzci6wLhvgIYlKA7q2xehvNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779503104; c=relaxed/simple;
	bh=IJNnnre0t39W11Rl+oZpi5GL7wfuNdeRVrEN0HWGL5w=;
	h=Date:To:From:Subject:Message-Id; b=Xm4b3EfYFBXODs6tiCTepgDHMtHMminJutWUQgjJfDOXpRMPmHBeAPmScraAh3hFD2mNyZVSAVQQYYJTAzE9tz7QprH1dTTtCuPpoW6kT9jOc7EraRI/tJm1oYIsmM4TAjnwFeY6mcR8hh40foIa7btj3RdOrXtdP19jIAO9WnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tFvLoiCo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tFvLoiCo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B3221F000E9;
	Sat, 23 May 2026 02:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779503103;
	bh=SjIgP4dPZo+iMjXMSsLoI74POU8TqkZWUq91P1txzIM=;
	h=Date:To:From:Subject;
	b=tFvLoiCopMQlSD0ryVds+fBQler8IDaKHTi4WtbkH+0oUG8J2keiQO4+nx6g9h1zG
	 LCBWrnugONxBp3df6bo5ZBmiF5YLBSlNjUUZcZXiGNihlwLgfCU1lrByzqds8wS/mN
	 uq99vaXbSbzkgrUQgwhebsmYvnxyH4YvQSWvEISc=
Date: Fri, 22 May 2026 19:25:02 -0700
To: mm-commits@vger.kernel.org,rafael@kernel.org,mika.westerberg@linux.intel.com,hansg@kernel.org,bhelgaas@google.com,andriy.shevchenko@linux.intel.com,sakunix@yahoo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + resource-downgrade-resource-sanity-check-warning-to-debug-level.patch added to mm-nonmm-unstable branch
Message-Id: <20260523022503.0B3221F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: resource: downgrade "resource sanity check" warning to debug level
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     resource-downgrade-resource-sanity-check-warning-to-debug-level.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/resource-downgrade-resource-sanity-check-warning-to-debug-level.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Manuel Quintero Fonseca <sakunix@yahoo.com>
Subject: resource: downgrade "resource sanity check" warning to debug level
Date: Fri, 22 May 2026 17:01:31 -0700

The "resource sanity check" warning currently triggers on certain systems,
causing unnecessary noise in the kernel logs for users.  This patch
downgrades the log level from pr_warn to pr_debug.

This change reduces log clutter while keeping the diagnostic information
available for debugging purposes if needed.

Link: https://lore.kernel.org/20260523000131.7086-1-sakunix@yahoo.com
Signed-off-by: Manuel Quintero Fonseca <sakunix@yahoo.com>
Cc: Andriy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Hans de Goede <hansg@kernel.org>
Cc: Mika Westeberg <mika.westerberg@linux.intel.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/resource.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/resource.c~resource-downgrade-resource-sanity-check-warning-to-debug-level
+++ a/kernel/resource.c
@@ -1859,7 +1859,7 @@ int iomem_map_sanity_check(resource_size
 		if (p->flags & IORESOURCE_BUSY)
 			continue;
 
-		pr_warn("resource sanity check: requesting [mem %pa-%pa], which spans more than %s %pR\n",
+		pr_debug("resource sanity check: requesting [mem %pa-%pa], which spans more than %s %pR\n",
 			&addr, &end, p->name, p);
 		err = -1;
 		break;
_

Patches currently in -mm which might be from sakunix@yahoo.com are

resource-downgrade-resource-sanity-check-warning-to-debug-level.patch

