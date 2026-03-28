Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C12391FA859
	for <mm-commits@vger.kernel.org>; Sat, 28 Mar 2026 04:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774671898; cv=none; b=kXPI60m1iMMcjizaKTja0dYcDhiWzdExxHhwtJVg6u/Oo5f0KxIBcuElVjtMIGpJrenYkJZRtWUMgYLtaUbWYv2I3zT5W7ZZTw0Rfh6nn5Kw7kxfLniK7bXu+Zwnsp7D/TSfOVZAS3X6Wgs8ckKzrQ4y/Ti1um01D8BAx+LJ9iM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774671898; c=relaxed/simple;
	bh=ME8C46YrdlG2LjqA+qjN0JEGRQgW40uWuz2bvdIH7v4=;
	h=Date:To:From:Subject:Message-Id; b=tot1BVLXNexj18iQOcKgEPlLPo8iAlgLqiaL+PQSJP8/jxX6n43+BH+mIm6eZKnCuhjUXpJ4tSt/6BevICtW98a2ec+eci3wvszRO48ujBTU3LQeZofl6i/lM0Mb84nGQdBDFzgUJLDxHgKBl8MIKgj8YLD1FOmjkZK35dmt/I0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WAu2atp/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WAu2atp/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99F25C4CEF7;
	Sat, 28 Mar 2026 04:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774671898;
	bh=ME8C46YrdlG2LjqA+qjN0JEGRQgW40uWuz2bvdIH7v4=;
	h=Date:To:From:Subject:From;
	b=WAu2atp/bsEZykOZYWTqCe3MVyZ2XqBCF7XxUMCnMPJdtT4Fcb1aIyv0yu6aONFNl
	 jDyxrLFhtGkMZ/AjRXFEqmzC/2UBGxe7n6N9QSrK5+Dg9T/8VAOnzazbzgY7qg0fnS
	 oXsXu9ei632T6Ub6ObtVISwbwd3cJqcSZ06pQpmQ=
Date: Fri, 27 Mar 2026 21:24:58 -0700
To: mm-commits@vger.kernel.org,objecting@objecting.org,akpm@linux-foundation.org,hlcj1234567@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-glob-add-missing-spdx-license-identifier.patch removed from -mm tree
Message-Id: <20260328042458.99F25C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib: glob: add missing SPDX-License-Identifier
has been removed from the -mm tree.  Its filename was
     lib-glob-add-missing-spdx-license-identifier.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Josh Law <hlcj1234567@gmail.com>
Subject: lib: glob: add missing SPDX-License-Identifier
Date: Sat, 28 Feb 2026 19:53:00 +0000

Add the missing dual MIT/GPL license identifier to glob.c.

Link: https://lkml.kernel.org/r/20260228195300.2468310-1-objecting@objecting.org
Signed-off-by: Josh Law <objecting@objecting.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/glob.c |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/glob.c~lib-glob-add-missing-spdx-license-identifier
+++ a/lib/glob.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: (GPL-2.0 OR MIT)
 #include <linux/module.h>
 #include <linux/glob.h>
 
_

Patches currently in -mm which might be from hlcj1234567@gmail.com are


