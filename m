Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31410439909
	for <mm-commits@vger.kernel.org>; Sat, 29 Aug 2026 23:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788047047; cv=none; b=qFa9k7LMfEcdYLOha21TxkoQPEO6f/iz70mzxsekSxKFLRgVhdI8fhbDz6GbrlizqRtPXA5pypiOc9LctbN78z3pPi6o6AazC3wXpFlF0VW3yRBlQVd3p/zC3GogIOqLwR7XqadKqCFZ5Hm0UBC2pi59yJjFI6otZL75jsAzVXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788047047; c=relaxed/simple;
	bh=fHC2cGdgGOVRNA0b/a2X6A24AZXn13P+3npDYAb35Iw=;
	h=Date:To:From:Subject:Message-Id; b=MB81mo1pHXO70WHccC7ihvogmgVNS0KKitosDOvDbwvZFJv/icykVexhTaDG8Nv0LfNb1dpKGvdQnWhpu+WNMc/S6vrTfXApGHR1lWELG2wzwFrqOtiiQxhwDKVN35owdnAtSay/YN3p2g6LEe+vGQH+uYA+avvk3UkT8Bf54BU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZNTAroX0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZNTAroX0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 865E41F000E9;
	Sat, 29 Aug 2026 23:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788047045;
	bh=3cprdfKOeAzrWEgJmQO+H329i7GPCBLVi2HLLrLEImU=;
	h=Date:To:From:Subject;
	b=ZNTAroX0n7C3oXu6pR0pUi2Jwoc8lYgg/7sxhTxeBS2NttlY7vnkLOfuFRkfQSsnd
	 +ZvBwlBQYDD50BOCdMPHirMVBBcsj28GhdzynOCEwbufEybYgMCNNorUhwSq86XIDJ
	 V9Y3Fhz79xq0NBY6zImyJWlZkJE3h3VbBrEx3FBY=
Date: Sat, 29 Aug 2026 16:44:05 -0700
To: mm-commits@vger.kernel.org,julia.lawall@inria.fr,jani.nikula@linux.intel.com,arnd@arndb.de,julianbraha@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-cleanup-fake-tristates-in-kconfig.patch added to mm-nonmm-unstable branch
Message-Id: <20260829234405.865E41F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib: cleanup "fake" tristates in Kconfig
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-cleanup-fake-tristates-in-kconfig.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-cleanup-fake-tristates-in-kconfig.patch

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
From: Julian Braha <julianbraha@gmail.com>
Subject: lib: cleanup "fake" tristates in Kconfig
Date: Mon, 17 Aug 2026 22:03:11 +0100

These 7 DECOMPRESS_ options (e.g.  DECOMPRESS_GZIP) currently have the
tristate type, but can never be set to M.  Their only valid values are Y
and N, making them effectively booleans.

Let's make their types more accurate by changing them to 'bool'.  Note
that this is only a code cleanup, there is no functional change.

These bistates were found by kconfirm, a static analysis tool for Kconfig.

Link: https://lore.kernel.org/20260817210311.2142999-1-julianbraha@gmail.com
Signed-off-by: Julian Braha <julianbraha@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Julia Lawall <julia.lawall@inria.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/lib/Kconfig~lib-cleanup-fake-tristates-in-kconfig
+++ a/lib/Kconfig
@@ -219,29 +219,29 @@ source "lib/xz/Kconfig"
 #
 config DECOMPRESS_GZIP
 	select ZLIB_INFLATE
-	tristate
+	bool
 
 config DECOMPRESS_BZIP2
-	tristate
+	bool
 
 config DECOMPRESS_LZMA
-	tristate
+	bool
 
 config DECOMPRESS_XZ
 	select XZ_DEC
-	tristate
+	bool
 
 config DECOMPRESS_LZO
 	select LZO_DECOMPRESS
-	tristate
+	bool
 
 config DECOMPRESS_LZ4
 	select LZ4_DECOMPRESS
-	tristate
+	bool
 
 config DECOMPRESS_ZSTD
 	select ZSTD_DECOMPRESS
-	tristate
+	bool
 
 #
 # Generic allocator support is selected if needed
_

Patches currently in -mm which might be from julianbraha@gmail.com are

lib-cleanup-fake-tristates-in-kconfig.patch

