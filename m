Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76BE22F0C67
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768967368; cv=none; b=hk7Jx+TXksXnu/LZudG6vlxtwfqIhfSjlBdeK9DVdteJvFLeUM+QmAbj7yVGBGyjOAavlbM0boV80CU+ybNV3BAkbRTF9LH4PKxa/I5rUaDHlHXh1Nz88HjFESDFwu0B3eXOVUlwKG9oL5lauguzpEpyIprCR7mB1Y5tpqnEFQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768967368; c=relaxed/simple;
	bh=6tvpnhx3QL6WRW4oekH51hRAA0kT7NKX6LguY61/xeA=;
	h=Date:To:From:Subject:Message-Id; b=iejGrC0mUh8aPvtOWwvwOqOoix2p9/Z0zeQK/d73bqwXb6mksmStHoCetNOeilHKLPJu5TqDw0P7coJBXn/QGDXN3c2TBHvBj1iUOUl3plMlULwpCR86xKZbpVhRTwozPyHVSOWxgcUgtb9eD8NDR8qJg0D04sg2TndN1rT6G8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=L8r82Vr+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="L8r82Vr+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E155C16AAE;
	Wed, 21 Jan 2026 03:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768967367;
	bh=6tvpnhx3QL6WRW4oekH51hRAA0kT7NKX6LguY61/xeA=;
	h=Date:To:From:Subject:From;
	b=L8r82Vr+Dc8fdYKospgIpXrryK+3+6CKq9nSNcBX314xfNd81MsC2L5RIJdfMBGrk
	 g2l6YWTzkVg+OsR4/zVuw5acZwbRiltnCnJoBwKYjE0MZSMp2u+Ouk2TQGhjl3s4hw
	 Jg0M4x5umZtck2yCh7bujgbf7uqACgH7Ldt6WIR0=
Date: Tue, 20 Jan 2026 19:49:26 -0800
To: mm-commits@vger.kernel.org,ilpo.jarvinen@linux.intel.com,bhelgaas@google.com,andriy.shevchenko@linux.intel.com,ansuelsmth@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] resource-provide-0args-define_res-variant-for-unset-resource-desc.patch removed from -mm tree
Message-Id: <20260121034927.4E155C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: resource: provide 0args DEFINE_RES variant for unset resource desc
has been removed from the -mm tree.  Its filename was
     resource-provide-0args-define_res-variant-for-unset-resource-desc.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christian Marangi <ansuelsmth@gmail.com>
Subject: resource: provide 0args DEFINE_RES variant for unset resource desc
Date: Sat, 13 Dec 2025 12:53:09 +0100

Provide a variant of DEFINE_RES that takes 0 arguments to initialize an
"unset" resource descriptor.

This should be used for the improper case of

	struct resource res = {};

where DEFINE_RES() should be used.

With this new helper variant, it would result in:

	struct resource res = DEFINE_RES();

instead of having to define the full 3 arguments:

	struct resource res = DEFINE_RES(0, 0, IORESOURCE_UNSET);

DEFINE_RES() with no args, will set the flags to IORESOURCE_UNSET
signaling the resource descriptor is UNSET and doesn't reflect an actual
resource currently.

Link: https://lkml.kernel.org/r/20251213115314.16700-1-ansuelsmth@gmail.com
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Suggested-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ioport.h |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/include/linux/ioport.h~resource-provide-0args-define_res-variant-for-unset-resource-desc
+++ a/include/linux/ioport.h
@@ -10,6 +10,7 @@
 #define _LINUX_IOPORT_H
 
 #ifndef __ASSEMBLY__
+#include <linux/args.h>
 #include <linux/bits.h>
 #include <linux/compiler.h>
 #include <linux/minmax.h>
@@ -165,8 +166,12 @@ enum {
 
 #define DEFINE_RES_NAMED(_start, _size, _name, _flags)			\
 	DEFINE_RES_NAMED_DESC(_start, _size, _name, _flags, IORES_DESC_NONE)
-#define DEFINE_RES(_start, _size, _flags)				\
+#define __DEFINE_RES0()							\
+	DEFINE_RES_NAMED(0, 0, NULL, IORESOURCE_UNSET)
+#define __DEFINE_RES3(_start, _size, _flags)				\
 	DEFINE_RES_NAMED(_start, _size, NULL, _flags)
+#define DEFINE_RES(...)							\
+	CONCATENATE(__DEFINE_RES, COUNT_ARGS(__VA_ARGS__))(__VA_ARGS__)
 
 #define DEFINE_RES_IO_NAMED(_start, _size, _name)			\
 	DEFINE_RES_NAMED((_start), (_size), (_name), IORESOURCE_IO)
_

Patches currently in -mm which might be from ansuelsmth@gmail.com are


