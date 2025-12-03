Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4FE6482EB
	for <mm-commits@vger.kernel.org>; Wed,  3 Dec 2025 21:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764797693; cv=none; b=t6Z+nAgMPRgF/vJvVXIXbdcnyOWzvYsqnrnCMBy7jfXafAlp7kynVriPLyMkPQv9EHoFl/X8lT5pgLhlHQEFpCuZpeub+fuE/OlLOqxIQ3kz5/4UX5rSW02U/eA0A5sJ0HC0JVa4C1A6SMieYX+GJ8RL61W29VA2VVYaCuZQOi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764797693; c=relaxed/simple;
	bh=oXFwh7hHHa5oYGt1aQOmI2w3g61IsWWu/YHroWMjtZo=;
	h=Date:To:From:Subject:Message-Id; b=R/rNFm1oWyESMsn2RFTmjcxG0o/bQXXxjwfsXELjXEYQ5mGhsIurUWh2+ian/VQGh8/hzHzz35BTQ3kbLDl+R/9+syW5Bww6Lh3evDyVfEiHcqqqsIsP7UQRvlV55Has/iCjh6L1DDM7p2t6yF2Tk4XyBS41DCqcX96dQ1sN6lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=taA66VDm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="taA66VDm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B2BFC4CEF5;
	Wed,  3 Dec 2025 21:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764797693;
	bh=oXFwh7hHHa5oYGt1aQOmI2w3g61IsWWu/YHroWMjtZo=;
	h=Date:To:From:Subject:From;
	b=taA66VDmQCfgkY5GRxlsYZOy2pVJr52X/csys5ns5t1XQE6h2j3orUVvhUlZy8Sb3
	 KIV94QyINCnJKUmGGCbxCKKWwSoKbP0iM3c9b8Y+9sWgdOw56jy9VDTx64sO777j4H
	 Fm35meuhnkHXlKeEXFPva46+WQScz6sdX00KQmUc=
Date: Wed, 03 Dec 2025 13:34:52 -0800
To: mm-commits@vger.kernel.org,vireshk@kernel.org,sboyd@kernel.org,nm@ti.com,lukas.bulwahn@gmail.com,krzk@kernel.org,joe@perches.com,james.bottomley@HansenPartnership.com,geert@linux-m68k.org,dwaipayanray1@gmail.com,david.hunter.linux@gmail.com,dan.j.williams@intel.com,dan.carpenter@linaro.org,corbet@lwn.net,apw@canonical.com,allyheev@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + checkpatch-add-uninitialized-pointer-with-__free-attribute-check.patch added to mm-nonmm-unstable branch
Message-Id: <20251203213453.0B2BFC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: checkpatch: add uninitialized pointer with __free attribute check
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     checkpatch-add-uninitialized-pointer-with-__free-attribute-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/checkpatch-add-uninitialized-pointer-with-__free-attribute-check.patch

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
From: Ally Heev <allyheev@gmail.com>
Subject: checkpatch: add uninitialized pointer with __free attribute check
Date: Wed, 03 Dec 2025 20:58:49 +0530

Uinitialized pointers with __free attribute can cause undefined behavior
as the memory randomly assigned to the pointer is freed automatically when
the pointer goes out of scope.  add check in checkpatch to detect such
issues.

Link: https://lkml.kernel.org/r/20251203-aheev-checkpatch-uninitialized-free-v7-1-841e3b31d8f3@gmail.com
Signed-off-by: Ally Heev <allyheev@gmail.com>
Suggested-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/all/8a4c0b43-cf63-400d-b33d-d9c447b7e0b9@suswa.mountain/
Link: https://lore.kernel.org/all/58fd478f408a34b578ee8d949c5c4b4da4d4f41d.camel@HansenPartnership.com/
Acked-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>
Acked-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: David Hunter <david.hunter.linux@gmail.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: James Bottomley <james.bottomley@HansenPartnership.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Menon, Nishanth <nm@ti.com>
Cc: Stephen Boyd <sboyd@kernel.org>
Cc: Viresh Kumar <vireshk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/checkpatch.rst |   23 +++++++++++++++++++++++
 scripts/checkpatch.pl                  |    6 ++++++
 2 files changed, 29 insertions(+)

--- a/Documentation/dev-tools/checkpatch.rst~checkpatch-add-uninitialized-pointer-with-__free-attribute-check
+++ a/Documentation/dev-tools/checkpatch.rst
@@ -1009,6 +1009,29 @@ Functions and Variables
 
       return bar;
 
+  **UNINITIALIZED_PTR_WITH_FREE**
+    Pointers with __free attribute should be declared at the place of use
+    and initialized (see include/linux/cleanup.h). In this case
+    declarations at the top of the function rule can be relaxed. Not doing
+    so may lead to undefined behavior as the memory assigned (garbage,
+    in case not initialized) to the pointer is freed automatically when
+    the pointer goes out of scope.
+
+    Also see: https://lore.kernel.org/lkml/58fd478f408a34b578ee8d949c5c4b4da4d4f41d.camel@HansenPartnership.com/
+
+    Example::
+
+      type var __free(free_func);
+      ... // var not used, but, in future someone might add a return here
+      var = malloc(var_size);
+      ...
+
+    should be initialized as::
+
+      ...
+      type var __free(free_func) = malloc(var_size);
+      ...
+
 
 Permissions
 -----------
--- a/scripts/checkpatch.pl~checkpatch-add-uninitialized-pointer-with-__free-attribute-check
+++ a/scripts/checkpatch.pl
@@ -7732,6 +7732,12 @@ sub process {
 				ERROR("MISSING_SENTINEL", "missing sentinel in ID array\n" . "$here\n$stat\n");
 			}
 		}
+
+# check for uninitialized pointers with __free attribute
+		while ($line =~ /\*\s*($Ident)\s+__free\s*\(\s*$Ident\s*\)\s*[,;]/g) {
+			ERROR("UNINITIALIZED_PTR_WITH_FREE",
+			      "pointer '$1' with __free attribute should be initialized\n" . $herecurr);
+		}
 	}
 
 	# If we have no input at all, then there is nothing to report on
_

Patches currently in -mm which might be from allyheev@gmail.com are

checkpatch-add-uninitialized-pointer-with-__free-attribute-check.patch

