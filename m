Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3A9A41D214
	for <mm-commits@vger.kernel.org>; Tue,  4 Aug 2026 04:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785816318; cv=none; b=euyUL4mDotPkxrqxUAN5P5V2py/MVDHcPTTjXWu1y7vYFKjZYJ8kN+GEVodDL90oGJ4SUA7phyvKSVHZQBfP4nr6giZmCiRB2IC/F25+dKSpmuIYpVIPRDzdPtoyii8V1y7lNCShs9aa4pSSQfkQRfM7OGvAHyEJpB5RYme8l7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785816318; c=relaxed/simple;
	bh=ZjIJlzHwAIViL8c8fHY3WsbeIDFUDAWnFR5y7VprUCk=;
	h=Date:To:From:Subject:Message-Id; b=dSom9m8vxTrF+yv5JAq3n27PYxbkakp4KYScwfokeW13pOWiqQ7moQ4hEzTohM0LlPlfBAhygwddHL7FIn7DyhRa8IaxTHWkoFg6iiJbhgGyWigCAKHTEeWncITrpUT69MOoyfDdM6PVMb0Ym3O/C9gjI+yrFMyIRtJ9hkFbowQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vKMqESzQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vKMqESzQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A86F1F000E9;
	Tue,  4 Aug 2026 04:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785816317;
	bh=D9yM8W37ua6PsVwgaWMGijaZyZSN/OGKd8d8FGliJu4=;
	h=Date:To:From:Subject;
	b=vKMqESzQR4a7rwJ35W07r5Ag4ziiQZB0vFKoL+h4lFry72uVY2kfI6jwvPgGL+Iib
	 ZdnNylLIYAvlQBWQSLjhGP6smqYi9MdgOA3bXh2/SQAgo4oWVLAUSRmnrVFGjTc0Ut
	 eMt/s7jtY4fpL2skhbEa01tIxA/aj8GFUysLQyr8=
Date: Mon, 03 Aug 2026 21:05:17 -0700
To: mm-commits@vger.kernel.org,nathan@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] get_maintainerignore-add-nathan-chancellor.patch removed from -mm tree
Message-Id: <20260804040517.7A86F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: .get_maintainer.ignore: add Nathan Chancellor
has been removed from the -mm tree.  Its filename was
     get_maintainerignore-add-nathan-chancellor.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nathan Chancellor <nathan@kernel.org>
Subject: .get_maintainer.ignore: add Nathan Chancellor
Date: Tue, 07 Jul 2026 12:52:25 -0700

I do work all over the tree as part of ClangBuiltLinux and Kbuild, which
ultimately results in a lot of irrelevant CCs when submitters run
get_maintainer.pl with the default git fallback enabled.  Add myself to
.get_maintainer.ignore so I only get CC'd through explicitly maintained
files/patterns or a submitter intentionally adding me to the list.

Link: https://lore.kernel.org/20260707-add-nathan-to-get_maintainers-ignore-v1-1-810926e8eea3@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .get_maintainer.ignore |    1 +
 1 file changed, 1 insertion(+)

--- a/.get_maintainer.ignore~get_maintainerignore-add-nathan-chancellor
+++ a/.get_maintainer.ignore
@@ -5,4 +5,5 @@ Askar Safin <safinaskar@gmail.com>
 Christoph Hellwig <hch@lst.de>
 Jeff Kirsher <jeffrey.t.kirsher@intel.com>
 Marc Gonzalez <marc.w.gonzalez@free.fr>
+Nathan Chancellor <nathan@kernel.org>
 Ralf Baechle <ralf@linux-mips.org>
_

Patches currently in -mm which might be from nathan@kernel.org are


