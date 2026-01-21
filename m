Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16670339B37
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768966409; cv=none; b=H3lmVCFkAqKpUx2bW8l/mhpxs1pY+Ctkwoa83DoJN9AECY3B/xdpAhPgGIdGcEj6cc2cCBc6XVXeJJSJvQy3hg04mIO+bgsNlXxb3File/GZUXjJyEkkjEqm9owbTrewFkHlFtvkmZRTKXYuwPFz+IElQgj4PVWcLFDjvHSFDYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768966409; c=relaxed/simple;
	bh=xnLX2seiCUbZfcqk/WXMZ4eqRunxpoWZOPbf51GVpY4=;
	h=Date:To:From:Subject:Message-Id; b=JYNCHkQFSfS0EI1lpLcf8DR+OcP92AhG5FPgw3dmVl9Xb9eyfJQLNXspcpZxahmYSDxI1pQE6hnMKAUhGDWyIYcrG2PcxVoKVndXtzQ3D03U9K/slcDbgsVOy+n98xTcabtfFmLSx4yubi66RgmWQpAM8M7+UK0nTpEQVxvlb4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=q9ehF2K7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="q9ehF2K7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95850C16AAE;
	Wed, 21 Jan 2026 03:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768966408;
	bh=xnLX2seiCUbZfcqk/WXMZ4eqRunxpoWZOPbf51GVpY4=;
	h=Date:To:From:Subject:From;
	b=q9ehF2K7n1Ue1uy6gJiu1rXMKH8o1vLYWdtoABEPnWtbxTQtjXUVs86Ivhhn08kb6
	 jSqS9HsnYfN/6FtGOREyWa4HtzO6SDq3o98rX1K4+47dtREVbcd/yrSUarNOpfCWaz
	 3jiIhxWFpugN4j372eGZwOPLIqpq0HQ9WKx4xab4=
Date: Tue, 20 Jan 2026 19:33:28 -0800
To: mm-commits@vger.kernel.org,sakamo.ryota@gmail.com,geert@linux-m68k.org,davidgow@google.com,brendan.higgins@linux.dev,andriy.shevchenko@linux.intel.com,lukas.bulwahn@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] lib-tests-convert-test_uuid-module-to-kunit-fix.patch removed from -mm tree
Message-Id: <20260121033328.95850C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: adjust file entry in UUID HELPERS
has been removed from the -mm tree.  Its filename was
     lib-tests-convert-test_uuid-module-to-kunit-fix.patch

This patch was dropped because it was folded into lib-tests-convert-test_uuid-module-to-kunit.patch

------------------------------------------------------
From: Lukas Bulwahn <lukas.bulwahn@redhat.com>
Subject: MAINTAINERS: adjust file entry in UUID HELPERS
Date: Wed, 17 Dec 2025 06:39:07 +0100

Commit e61d3add3e7f ("lib/tests: convert test_uuid module to KUnit") moves
lib/test_uuid.c to lib/tests/uuid_kunit.c, but misses to adjust the file
entry in the MAINTAINERS section UUID HELPERS.

Adjust the file entry in that section after this file movement.

Link: https://lkml.kernel.org/r/20251217053907.2778515-1-lukas.bulwahn@redhat.com
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@redhat.com>
Acked-by: David Gow <davidgow@google.com>
Acked-by: Ryota Sakamoto <sakamo.ryota@gmail.com>
Cc: Andriy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/MAINTAINERS~lib-tests-convert-test_uuid-module-to-kunit-fix
+++ a/MAINTAINERS
@@ -27256,7 +27256,7 @@ R:	Andy Shevchenko <andriy.shevchenko@li
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	include/linux/uuid.h
-F:	lib/test_uuid.c
+F:	lib/tests/uuid_kunit.c
 F:	lib/uuid.c
 
 UV SYSFS DRIVER
_

Patches currently in -mm which might be from lukas.bulwahn@redhat.com are

lib-tests-convert-test_uuid-module-to-kunit.patch
kho-abi-add-memblock-abi-header-fix.patch

