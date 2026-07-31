Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A802A339388
	for <mm-commits@vger.kernel.org>; Fri, 31 Jul 2026 02:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785465825; cv=none; b=lKcXUrCk4lW1CMOQ67ahBQjqVgRuNs6Nf4Vz9N69RYx5ZM9t1hUMeah/pbEXUGNBTtdkQ1fjBu7lZ7Dx2VGROgdv/d3uQEEVBay0u5+YBj+WEKg/zo2rj0G76TnQGQf7L84W5DOhJzK5dqa0glVw0VK688MXUlAB1Xt0r6vvNFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785465825; c=relaxed/simple;
	bh=KVfaTk4+eshJRo54ZMkbvwtHo77Yb1KqNTVc2GLG4tA=;
	h=Date:To:From:Subject:Message-Id; b=YKcefGtlO437jD30gwDy53oJXi2/jQXgG1t08vl1fBF66uyzHEfrKpw9cvykouMvdfA2aB3CoyDOjvT4G3fbV0Vot7Qx9VDbS0R0wTfcImJWIsRALTe9AnfBZ+qWMPjmJ1yJRdgYg1HDynHuY6fHhCC2Yl80X1v845eud14V53I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OKvCW1WT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OKvCW1WT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D5171F00A3A;
	Fri, 31 Jul 2026 02:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785465824;
	bh=Qjv3ZCw5FpwstNBHfQTx1Y+oYXsTYyAg1I1qS/vvAfs=;
	h=Date:To:From:Subject;
	b=OKvCW1WTAqP37C1FfAftSB+yolliF0KS6FU1ro0rxHDN9Hz+Zn8M7C90UKimq0Mel
	 lZKLNkrMyMGbuNjaSJsY5kWl0K3+6+wF0ETqfExq9P2kUBynhmzhNo/8EH8C6JNCd1
	 eGM3eCJ3KjVpODllH4dwWGZpSoOeq9H44X5NR3yk=
Date: Thu, 30 Jul 2026 19:43:43 -0700
To: mm-commits@vger.kernel.org,senozhatsky@chromium.org,richardycc@google.com,minchan@kernel.org,corbet@lwn.net,rahularukonda2@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-abi-zram-fix-spelling-mistakes.patch removed from -mm tree
Message-Id: <20260731024344.4D5171F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: docs: ABI: zram: fix spelling mistakes
has been removed from the -mm tree.  Its filename was
     docs-abi-zram-fix-spelling-mistakes.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Arukonda Rahul <rahularukonda2@gmail.com>
Subject: docs: ABI: zram: fix spelling mistakes
Date: Tue, 7 Jul 2026 22:21:31 +0530

Fix spelling mistakes in the zram sysfs ABI documentation.

Link: https://lore.kernel.org/20260707165131.4408-1-rahularukonda2@gmail.com
Signed-off-by: Arukonda Rahul <rahularukonda2@gmail.com>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Richard Chang <richardycc@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-block-zram |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/Documentation/ABI/testing/sysfs-block-zram~docs-abi-zram-fix-spelling-mistakes
+++ a/Documentation/ABI/testing/sysfs-block-zram
@@ -152,15 +152,15 @@ Description:
 		compression algorithm parameters.
 
 What:		/sys/block/zram<id>/compressed_writeback
-Date:		Decemeber 2025
+Date:		December 2025
 Contact:	Richard Chang <richardycc@google.com>
 Description:
-		The compressed_writeback device atrribute toggles compressed
+		The compressed_writeback device attribute toggles compressed
 		writeback feature.
 
 What:		/sys/block/zram<id>/writeback_batch_size
 Date:		November 2025
 Contact:	Sergey Senozhatsky <senozhatsky@chromium.org>
 Description:
-		The writeback_batch_size device atrribute sets the maximum
+		The writeback_batch_size device attribute sets the maximum
 		number of in-flight writeback operations.
_

Patches currently in -mm which might be from rahularukonda2@gmail.com are


