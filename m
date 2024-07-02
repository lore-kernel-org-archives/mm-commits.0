Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A2E83C38
	for <mm-commits@vger.kernel.org>; Tue,  2 Jul 2024 02:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719886008; cv=none; b=jvJgOuBWfV24VLq5OCEq5EeJn2NXeMygLXzgdL1SB39KyJaagMuBC8FLg3sk1rRgZpc4gN12dYyTeHVF5Cm+jjBBrQya2POt4PmMngbJdpenPkJxW2Ha6TZlAaGIyO90mN2+bMntTbUAV/pzcCjlCG1mZUHEwmNDV9AmHyUVoKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719886008; c=relaxed/simple;
	bh=T5XaQ9XWu6kASh6izaLxGGQ4wm3OQd6UmN7v295GtZI=;
	h=Date:To:From:Subject:Message-Id; b=mxBoaUQQai+UNz1jxt+N4GxZib3mO9vQKmOi4ipAOAFJqaY//AMjTR1k/TtqLl16PBqmbVXMw0/IWQyVWzDTnxIY9cV0ycFFwO+1h4vzXA6iP1ftyvMp8oi2DNN1GDE6ftSoKEYZ6sqc82nDSbpOxJORmDlIV5TrRpbIj5wT01A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QgMfLMwe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QgMfLMwe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECC2BC116B1;
	Tue,  2 Jul 2024 02:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719886008;
	bh=T5XaQ9XWu6kASh6izaLxGGQ4wm3OQd6UmN7v295GtZI=;
	h=Date:To:From:Subject:From;
	b=QgMfLMwe3YaV9JyTmNPVgsS6VmMgV1Wf85F5qg7Xap7x6BsZDstkqVG0teuD7muOU
	 C+jZdzrkblLKFjbPUhnt98/C3RzBW2Inj8TtmY6xcqWvDkeYlB7FSPiSeJ2YXmF6RX
	 8oVu05HWE+FKPanljQJSv4EhuoFyONz3a0V3ktvE=
Date: Mon, 01 Jul 2024 19:06:47 -0700
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-damon-design-remove-programmable-modules-section-in-favor-of-modules-section.patch added to mm-unstable branch
Message-Id: <20240702020647.ECC2BC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/mm/damon/design: remove 'Programmable Modules' section in favor of 'Modules' section
has been added to the -mm mm-unstable branch.  Its filename is
     docs-mm-damon-design-remove-programmable-modules-section-in-favor-of-modules-section.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-design-remove-programmable-modules-section-in-favor-of-modules-section.patch

This patch will later appear in the mm-unstable branch at
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
From: SeongJae Park <sj@kernel.org>
Subject: Docs/mm/damon/design: remove 'Programmable Modules' section in favor of 'Modules' section
Date: Mon, 1 Jul 2024 12:27:03 -0700

'Programmable Modules' section provides high level descriptions of the
DAMON API-based kernel modules layer.  But 'Modules' section, which is at
the end of the document, provides every detail about the layer including
that of 'Programmable Modules' section.

Since the brief summary of the layers at the beginning of the document has
a link to the 'Modules' section, browsing to the section is not that
difficult.  Remove 'Programmable Modules' section in favor of 'Modules'
section and reducing duplicates.

Link: https://lkml.kernel.org/r/20240701192706.51415-7-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |   10 ----------
 1 file changed, 10 deletions(-)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-remove-programmable-modules-section-in-favor-of-modules-section
+++ a/Documentation/mm/damon/design.rst
@@ -33,16 +33,6 @@ DAMON subsystem is configured with three
   layer.
 
 
-Programmable Modules
---------------------
-
-Core layer of DAMON is implemented as a framework, and exposes its application
-programming interface to all kernel space components such as subsystems and
-modules.  For common use cases of DAMON, DAMON subsystem provides kernel
-modules that built on top of the core layer using the API, which can be easily
-used by the user space end users.
-
-
 .. _damon_operations_set:
 
 Operations Set Layer
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-merge-regions-aggressively-when-max_nr_regions-is-unmet.patch
mm-damon-core-merge-regions-aggressively-when-max_nr_regions-is-unmet-fix.patch
mm-damon-core-merge-regions-aggressively-when-max_nr_regions-is-unmet-fix-2.patch
docs-mm-damon-design-fix-two-typos.patch
docs-mm-damon-design-clarify-regions-merging-operation.patch
docs-admin-guide-mm-damon-start-add-access-pattern-snapshot-example.patch
docs-mm-damon-design-add-links-from-overall-architecture-to-sections-of-details.patch
docs-mm-damon-design-move-configurable-operations-set-section-into-operations-set-layer-section.patch
docs-mm-damon-design-remove-programmable-modules-section-in-favor-of-modules-section.patch
docs-mm-damon-design-add-links-to-sections-of-damon-sysfs-interface-usage-doc.patch
docs-mm-damon-index-add-links-to-design.patch
docs-mm-damon-index-add-links-to-admin-guide-doc.patch

