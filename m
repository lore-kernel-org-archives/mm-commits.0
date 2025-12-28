Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8632A25392A
	for <mm-commits@vger.kernel.org>; Sun, 28 Dec 2025 19:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766949238; cv=none; b=IXRmp8BWxY7ckJS76ed4I+YF2kIEpVeJcSBan87RQ882fu1HvwORcnIkdGjP8V6sgwPNcR31PisdS31nSR/ouaZembusQeeMoi/InKis8yqOC2gHkAAWRN3QSjgAANr/24FU9Uicg6WXOWTUshDFaywXSm9PHXwPhNnIpLXDizo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766949238; c=relaxed/simple;
	bh=1WLO3DnXkJY2LB6L2BFC3jLPwLRDwi3Cyw9REgYKNFY=;
	h=Date:To:From:Subject:Message-Id; b=TyY+kTFT59D8cVxd40sj++yTPTWEScbua82kVeC3JwThKRiqpCrPmmYmcFj1D5A7237Qd0D315S0m6LRYWIalmO1AjGdDBcZY4ZYX4IlJzZMfkvGA13hQ2VqXlyXJay2oJnb7ErTeiBf2Qb+wC7L0GFnmw1XfBuXs/0llQZdjGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ByxJrgtU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ByxJrgtU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE813C4CEFB;
	Sun, 28 Dec 2025 19:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766949238;
	bh=1WLO3DnXkJY2LB6L2BFC3jLPwLRDwi3Cyw9REgYKNFY=;
	h=Date:To:From:Subject:From;
	b=ByxJrgtUYbgcox2ZpJQK+SWk++VjZ487o7OSYAQZt4IhAAL3G3PpuWOxZYLMJiSM4
	 /3E47mNfdIA9RF/1iaenb13lG4VVY/wMQ0r4SCIBOsGRvPPCllG/wLhNyyGbdb+R0z
	 WM6SxWjC4lB+MVG5fduIHY1C7Po6B/j/+KOCictc=
Date: Sun, 28 Dec 2025 11:13:57 -0800
To: mm-commits@vger.kernel.org,ilpo.jarvinen@linux.intel.com,bhelgaas@google.com,andriy.shevchenko@linux.intel.com,ansuelsmth@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + resource-provide-0args-define_res-variant-for-unset-resource-desc.patch added to mm-nonmm-unstable branch
Message-Id: <20251228191357.EE813C4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: resource: provide 0args DEFINE_RES variant for unset resource desc
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     resource-provide-0args-define_res-variant-for-unset-resource-desc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/resource-provide-0args-define_res-variant-for-unset-resource-desc.patch

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

resource-provide-0args-define_res-variant-for-unset-resource-desc.patch

