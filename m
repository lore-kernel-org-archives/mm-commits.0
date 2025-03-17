Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 760D61E52D
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 18:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742237918; cv=none; b=Ui2UGutY9rjitvDnJL6CZ551Y8lEXXLa/7xnIJCAOKoyQKUdlOgQxhdakVUj6UtJIxUprSduL9x0KfxcXLYw70MBGdBPUneH5n6vkuLsu2A4/Ka2ZBywdST3gRIQO0pyKNjb3oeyNyS4+EUPSQI9wW4I/+M8sr0hCIfecTN8Y8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742237918; c=relaxed/simple;
	bh=aBUD3FENOb4tW+IspPBMCsm/PewPZrDv/fXRKhXf9Gw=;
	h=Date:To:From:Subject:Message-Id; b=kBDvZl5y73VsyS5FSDY2tDcN41nV6o8d+BV0OfkTVjSKDOiiVfB/ikZVbNGWtSm6ZZylzOFxzs29anAbOUmZRfYN2WdedIAY5JTLoHwbYQUqPiUYLYFvSt4VjX7Hyaiz1Jid4j82Ywo5z7qF4JAw1oqG1DLszfSYDrqo5TOCqm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lviHIwtN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lviHIwtN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDD6CC4CEE3;
	Mon, 17 Mar 2025 18:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742237917;
	bh=aBUD3FENOb4tW+IspPBMCsm/PewPZrDv/fXRKhXf9Gw=;
	h=Date:To:From:Subject:From;
	b=lviHIwtNf8Hx21NFi+i0gSw8OBO31fra5qXCjgkjMT5ZSObobtS2z0FdPpYc8peop
	 xkCaE0iP2NP8HVxm6/ZWiwTqmzpBYn3Pj2/vRYkAN3uUvuuqUjW4f3e87BET4hIxav
	 QPpN8yQeC2dLjzFBt0Y1wjEiD0idmBLQXOcx1E7g=
Date: Mon, 17 Mar 2025 11:58:37 -0700
To: mm-commits@vger.kernel.org,ilpo.jarvinen@linux.intel.com,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + resource-split-define_res_named_desc-out-of-define_res_named.patch added to mm-nonmm-unstable branch
Message-Id: <20250317185837.CDD6CC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: resource: split DEFINE_RES_NAMED_DESC() out of DEFINE_RES_NAMED()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     resource-split-define_res_named_desc-out-of-define_res_named.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/resource-split-define_res_named_desc-out-of-define_res_named.patch

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
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: resource: split DEFINE_RES_NAMED_DESC() out of DEFINE_RES_NAMED()
Date: Mon, 17 Mar 2025 20:11:10 +0200

Patch series "resource: Split and use DEFINE_RES*() macros", v2.

Replace open coded variants of DEFINE_RES*() macros.

Note, there are many more possibilities over the kernel and even in
reources.c, however the latter contains not so trivial leftovers.  That's
why the examples cover only straightforward conversions.


This patch (of 4):

In some cases it would be useful to supply predefined descriptor of the
resource.  For this, introduce DEFINE_RES_NAMED_DESC() macro.

While at it, provide DEFINE_RES() that takes only start, size,
and flags.

Link: https://lkml.kernel.org/r/20250317181412.1560630-1-andriy.shevchenko@linux.intel.com
Link: https://lkml.kernel.org/r/20250317181412.1560630-2-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ioport.h |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/include/linux/ioport.h~resource-split-define_res_named_desc-out-of-define_res_named
+++ a/include/linux/ioport.h
@@ -154,15 +154,20 @@ enum {
 };
 
 /* helpers to define resources */
-#define DEFINE_RES_NAMED(_start, _size, _name, _flags)			\
+#define DEFINE_RES_NAMED_DESC(_start, _size, _name, _flags, _desc)	\
 (struct resource) {							\
 		.start = (_start),					\
 		.end = (_start) + (_size) - 1,				\
 		.name = (_name),					\
 		.flags = (_flags),					\
-		.desc = IORES_DESC_NONE,				\
+		.desc = (_desc),					\
 	}
 
+#define DEFINE_RES_NAMED(_start, _size, _name, _flags)			\
+	DEFINE_RES_NAMED_DESC(_start, _size, _name, _flags, IORES_DESC_NONE)
+#define DEFINE_RES(_start, _size, _flags)				\
+	DEFINE_RES_NAMED(_start, _size, NULL, _flags)
+
 #define DEFINE_RES_IO_NAMED(_start, _size, _name)			\
 	DEFINE_RES_NAMED((_start), (_size), (_name), IORESOURCE_IO)
 #define DEFINE_RES_IO(_start, _size)					\
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

resource-split-define_res_named_desc-out-of-define_res_named.patch
resource-replace-open-coded-variant-of-define_res_named_desc.patch
resource-replace-open-coded-variants-of-define_res__named.patch
resource-replace-open-coded-variant-of-define_res.patch

