Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BAC4235045
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 02:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791338660; cv=none; b=i+9gaKjYNJwTbvB6nr5KOBocru06rmH+JG1gaqUGt/uWVzuGfz2Yh4NgiPTwtqpTYa/pCdbWa12i2kHXvLdYMwmgCYDuKQXhmHK7EyXSN3GyC1d6auK5ybmq+8By5fIfhpD4cEwGkm1W7gAXcxUk3vsOHP464LMCUHWRQSLIjGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791338660; c=relaxed/simple;
	bh=L+oWKgz1gL2nuypXI9ahOj1Zt09T4WsSDRZH746a/BQ=;
	h=Date:To:From:Subject:Message-Id; b=hk2awbOFIWE3aoZ242k5bQ0jJdw7vVmmh75sd76TgzaosOhw72fzQDH4M8D0Kfu0opTSXoE7Z8kLFuLFWMvQKwdTAefL9z7BObUrREoza1D4CYia8gBZ+9bnwwu2oCTNSUAzfkG4xPVOC2bAp71UHW/XQeIfdGDBzRfTgKzdXhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EMTgPfcu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EMTgPfcu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EC281F0089B;
	Wed,  7 Oct 2026 02:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791338659;
	bh=EJNQsT4UYxcbtHOJkXWtha+sOVvb0mSqE7yynkaPHqE=;
	h=Date:To:From:Subject;
	b=EMTgPfcuQT3PDkast85vW8O7PDaQ6KYlf4H5fDt6nrOzeR2orwv6PwfDrW8ABJxw6
	 edlbw/ebxtzasxYb6riHPqKDXJbNas9LLMHd7wieorUDwXRfSx7RCrVm0VgSJbLfzO
	 01pq9EMgY2F5zlK+vhb1Ddwb+wmdiGtzbKxpL6/0=
Date: Tue, 06 Oct 2026 19:04:18 -0700
To: mm-commits@vger.kernel.org,julia.lawall@inria.fr,jani.nikula@linux.intel.com,arnd@arndb.de,julianbraha@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-cleanup-fake-tristates-in-kconfig.patch removed from -mm tree
Message-Id: <20261007020419.0EC281F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib: cleanup "fake" tristates in Kconfig
has been removed from the -mm tree.  Its filename was
     lib-cleanup-fake-tristates-in-kconfig.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Julia Lawall <julia.lawall@inria.fr>
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


