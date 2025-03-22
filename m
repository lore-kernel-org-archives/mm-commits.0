Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E1207081C
	for <mm-commits@vger.kernel.org>; Sat, 22 Mar 2025 05:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742620249; cv=none; b=Aoo3UIEGVgxkbOYmF0FRZnDDFtiZA28IVLAce6s3pCzjtX3KHYorStbJVTXBE6G4/2ZjyzNDweEm5fWxzZZhfw6EEul4zu6qfJisuSID3nc0YRzumdVrrFCk4LZsxCY1X6hG4qim14XrfzrvwsGIj5Qpa4hrMOtcjuw97dCL4Us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742620249; c=relaxed/simple;
	bh=FaPITBzuFpnbss1iQVrp2LC3YqPKAK1H/OuVp+1NF88=;
	h=Date:To:From:Subject:Message-Id; b=tzoB4fG1XKgdliklBIJajO7eKyWU3uEg+h2kZsDwqtuS9Fj1p80gA9jaPGgLzctamjYjeJwCRLfkn2XG1TJZ1iUwCIF80mmoPiuwMXHe70mT1+LFMMzBH9ZX7R13is/uiw/sVNSyAv4CI57T8haQLABWaJQjvunuEZuwy7Hv1Bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fkJBbEek; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fkJBbEek"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2797C4CEE7;
	Sat, 22 Mar 2025 05:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742620249;
	bh=FaPITBzuFpnbss1iQVrp2LC3YqPKAK1H/OuVp+1NF88=;
	h=Date:To:From:Subject:From;
	b=fkJBbEek7QG38L+1JauGo2tWEl9VsZ9imfaidwHk3//hUEtLqn7nhrC31w87Gq8TO
	 U4WXl3z9BGfWsQMJIWeYBd5zLeXSXPpL8T60HrCiiDqiuK5jXgRNfs9nkRv/CsM+ni
	 7+cs4jAnDfOt8oexpN7PjqU0B2lbXpay8PYZCO6s=
Date: Fri, 21 Mar 2025 22:10:48 -0700
To: mm-commits@vger.kernel.org,ilpo.jarvinen@linux.intel.com,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] resource-split-define_res_named_desc-out-of-define_res_named.patch removed from -mm tree
Message-Id: <20250322051048.F2797C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: resource: split DEFINE_RES_NAMED_DESC() out of DEFINE_RES_NAMED()
has been removed from the -mm tree.  Its filename was
     resource-split-define_res_named_desc-out-of-define_res_named.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


