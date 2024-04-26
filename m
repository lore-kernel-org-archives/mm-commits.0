Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 589F3763F8
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104485; cv=none; b=AhSbxjkuKrYfOfRiyDIcbq3cXH9zvxbs4rELCv75kqAo2TEDSEnSzgrTn6bS7SENFoVZfXnsLS44cNQNB+To9q3S3szyMTVT5/Jv97WLdBgy+MwPXXow8hi4f3LAGD8rs1Ztyjxsu3Ao3aBN44VENAau0mKJ3z2ThZuuDevrypU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104485; c=relaxed/simple;
	bh=xU/YzxKttG2GW5D6u8LO5ksBRTkbUr6xWQVcOSsbxnY=;
	h=Date:To:From:Subject:Message-Id; b=BuRYPFUxF8oQVywpMtQdLV/jr3gegqx2YO6lLiZm3pYeGdWl5tSsuwFXrtouOb1JuzTHsJebuDQ8jlHGmqQ42F1TClwL3gC5590gWcZcZd2gQDDuPZOD6XCFrdUAeLhGlU0EjiZSG+O7IvycQl1qjHC+KB+jFDcJpaadgAZFzcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HkU7g964; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HkU7g964"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BC8EC116B1;
	Fri, 26 Apr 2024 04:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104485;
	bh=xU/YzxKttG2GW5D6u8LO5ksBRTkbUr6xWQVcOSsbxnY=;
	h=Date:To:From:Subject:From;
	b=HkU7g964aD+SNRDXgWGubbH0I3zLtWCxHbPL0qPIzQ6FKYpI2vhrhP/dWhYGB3wDA
	 dUyZRwL3bghyUGIUCLs7YUDSU8lToK3bYkffCxaHUrSeBw7drXeg8xChi5KkDj0zed
	 iGlBX9KXWpbhDYmWPB9Ro+GkLlXtGyGHKlQJw7Rw=
Date: Thu, 25 Apr 2024 21:08:04 -0700
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,robert.moore@intel.com,rafael.j.wysocki@intel.com,nicolas@fjasle.eu,nathan@kernel.org,ming.m.lin@intel.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,masahiroy@kernel.org,lenb@kernel.org,ldm@flatcap.org,justinstitt@google.com,axboe@kernel.dk,astarikovskiy@suse.de,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] block-partitions-ldm-convert-strncpy-to-strscpy.patch removed from -mm tree
Message-Id: <20240426040805.2BC8EC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: block/partitions/ldm: convert strncpy() to strscpy()
has been removed from the -mm tree.  Its filename was
     block-partitions-ldm-convert-strncpy-to-strscpy.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: block/partitions/ldm: convert strncpy() to strscpy()
Date: Tue, 9 Apr 2024 16:00:56 +0200

The strncpy() here can cause a non-terminated string, which older gcc
versions such as gcc-9 warn about:

In function 'ldm_parse_tocblock',
    inlined from 'ldm_validate_tocblocks' at block/partitions/ldm.c:386:7,
    inlined from 'ldm_partition' at block/partitions/ldm.c:1457:7:
block/partitions/ldm.c:134:2: error: 'strncpy' specified bound 16 equals destination size [-Werror=stringop-truncation]
  134 |  strncpy (toc->bitmap1_name, data + 0x24, sizeof (toc->bitmap1_name));
      |  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
block/partitions/ldm.c:145:2: error: 'strncpy' specified bound 16 equals destination size [-Werror=stringop-truncation]
  145 |  strncpy (toc->bitmap2_name, data + 0x46, sizeof (toc->bitmap2_name));
      |  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

New versions notice that the code is correct after all because of the
following termination, but replacing the strncpy() with strscpy_pad()
or strcpy() avoids the warning and simplifies the code at the same time.

Use the padding version here to keep the existing behavior, in case
the code relies on not including uninitialized data.

Link: https://lkml.kernel.org/r/20240409140059.3806717-4-arnd@kernel.org
Reviewed-by: Justin Stitt <justinstitt@google.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Alexey Starikovskiy <astarikovskiy@suse.de>
Cc: Bob Moore <robert.moore@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Len Brown <lenb@kernel.org>
Cc: Lin Ming <ming.m.lin@intel.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nicolas Schier <nicolas@fjasle.eu>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: "Richard Russon (FlatCap)" <ldm@flatcap.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/partitions/ldm.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/block/partitions/ldm.c~block-partitions-ldm-convert-strncpy-to-strscpy
+++ a/block/partitions/ldm.c
@@ -131,8 +131,7 @@ static bool ldm_parse_tocblock (const u8
 		ldm_crit ("Cannot find TOCBLOCK, database may be corrupt.");
 		return false;
 	}
-	strncpy (toc->bitmap1_name, data + 0x24, sizeof (toc->bitmap1_name));
-	toc->bitmap1_name[sizeof (toc->bitmap1_name) - 1] = 0;
+	strscpy_pad(toc->bitmap1_name, data + 0x24, sizeof(toc->bitmap1_name));
 	toc->bitmap1_start = get_unaligned_be64(data + 0x2E);
 	toc->bitmap1_size  = get_unaligned_be64(data + 0x36);
 
@@ -142,8 +141,7 @@ static bool ldm_parse_tocblock (const u8
 				TOC_BITMAP1, toc->bitmap1_name);
 		return false;
 	}
-	strncpy (toc->bitmap2_name, data + 0x46, sizeof (toc->bitmap2_name));
-	toc->bitmap2_name[sizeof (toc->bitmap2_name) - 1] = 0;
+	strscpy_pad(toc->bitmap2_name, data + 0x46, sizeof(toc->bitmap2_name));
 	toc->bitmap2_start = get_unaligned_be64(data + 0x50);
 	toc->bitmap2_size  = get_unaligned_be64(data + 0x58);
 	if (strncmp (toc->bitmap2_name, TOC_BITMAP2,
_

Patches currently in -mm which might be from arnd@arndb.de are

kbuild-turn-on-wextra-by-default.patch
kbuild-remove-redundant-extra-warning-flags.patch
kbuild-turn-on-wrestrict-by-default.patch
kbuild-enable-wformat-truncation-on-clang.patch
kbuild-enable-wcast-function-type-strict-unconditionally.patch

