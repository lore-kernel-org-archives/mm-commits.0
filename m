Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10783139CFC
	for <mm-commits@vger.kernel.org>; Sat,  6 Jul 2024 18:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720292051; cv=none; b=k5MW54aZr9Bmys6rC6AvdhW4ur3xR+6yCZtzmov4FJse9AaNdBU/BfT6EUx1FHKJAoLMcPh0qBm+Br7/Nq+I10X7g+X2UQF4fGo98iGVv9cqWY8fDdBzzd+itWEeDu2Fxq/qbB1PALdoUrd7qRwAi/QzYkdMHOXKnObwN1OAxvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720292051; c=relaxed/simple;
	bh=8yYQuyPebqjB5L1ruY6RgGtlRSPnzlnfvHMmZLaeKtE=;
	h=Date:To:From:Subject:Message-Id; b=jsr5RgvoXdCzec/HiKRWN/7UQdoKzRhijM329b+iFO+zIN8eSp+fG1FX0JnHXODMqo4DWcu3IHd8Mo2UbcbxFMHqUblEpwsmTwdmZoxvDOnxIC1p7CUxgARykuNZ0d0Vg0jXkyc/OX1gUaEZwQpRkhg3YaANEgygKStAgQveF3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FmBAX4r/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FmBAX4r/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8A01C32781;
	Sat,  6 Jul 2024 18:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720292050;
	bh=8yYQuyPebqjB5L1ruY6RgGtlRSPnzlnfvHMmZLaeKtE=;
	h=Date:To:From:Subject:From;
	b=FmBAX4r/+UTrMs1yz0RXh5eSXI9MJPlnA1UMKn12rghAvzHrx5QTtcDGu3oCWx6za
	 bfHbPlaew5cWPEKPjhfm5a5WL4KgWSxOrbZjZ38Gd4tYA74VWAc+o2X8rWb61kKNF7
	 xUxGBRJ7WEga3PCz5MceMa2LTX08if5oqM7ZN2jE=
Date: Sat, 06 Jul 2024 11:54:10 -0700
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-design-remove-programmable-modules-section-in-favor-of-modules-section.patch removed from -mm tree
Message-Id: <20240706185410.D8A01C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/mm/damon/design: remove 'Programmable Modules' section in favor of 'Modules' section
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-design-remove-programmable-modules-section-in-favor-of-modules-section.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


