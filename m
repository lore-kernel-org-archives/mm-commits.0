Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC7B1156F4E
	for <mm-commits@vger.kernel.org>; Tue,  9 Apr 2024 21:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712698568; cv=none; b=s7dPKkO6CHs2pE78/fljYmmwLUte/KpgYkaqNw4Ho1UFBjEpIpzhay8ksvk2MbYAKjntSKO3MsRwkCEX2BVvKWHnrCvMrTJ6M6AyYjEjGn5pBHGKP4oqH/shMuuPNi1P07DMD9dsqK9jA0TPI20v3SWSximsYFMfQlCPToWf43U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712698568; c=relaxed/simple;
	bh=+r5154RisZJUiH9A2bqMu7yaU72f2owXEngP1lEHK5Y=;
	h=Date:To:From:Subject:Message-Id; b=I8oofLFlhNyLKjpHJ9XTyv4mvZscyNon7cw7x6VZfh+WhDfcKmLhfdqvcuxECXWZfuHvs7yCnroBC2fMkXTFLqhTdBKhYHmtflJccCLw1w1VhnYiLXqZJXGD2TWeeFWpT9ootwMpiaD4ud/Uw8JgzX+pj08YFm9l1Dw1L8D8VGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Axj3g/rO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Axj3g/rO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46EFFC433C7;
	Tue,  9 Apr 2024 21:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712698567;
	bh=+r5154RisZJUiH9A2bqMu7yaU72f2owXEngP1lEHK5Y=;
	h=Date:To:From:Subject:From;
	b=Axj3g/rOp63lAHD5vM5soup4s0csE9DseM0KttliNENIWfuD3s2SMj9YD2ZTku0Xp
	 HuiJ4oWmTRcpHiMss9DcOkWqa85E/KeazoZDHFVDGLAmLN2Wy36eHlI4qIpEgFHAfT
	 0SEF6wVLZPPbt30aWTeZergPXrEmCfGBiw58uIYg=
Date: Tue, 09 Apr 2024 14:36:06 -0700
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,robert.moore@intel.com,rafael.j.wysocki@intel.com,nicolas@fjasle.eu,nathan@kernel.org,ming.m.lin@intel.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,masahiroy@kernel.org,lenb@kernel.org,ldm@flatcap.org,justinstitt@google.com,axboe@kernel.dk,astarikovskiy@suse.de,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + block-partitions-ldm-convert-strncpy-to-strscpy.patch added to mm-nonmm-unstable branch
Message-Id: <20240409213607.46EFFC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: block/partitions/ldm: convert strncpy() to strscpy()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     block-partitions-ldm-convert-strncpy-to-strscpy.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/block-partitions-ldm-convert-strncpy-to-strscpy.patch

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

fix-missing-vmalloch-includes-fix-5.patch
kcov-avoid-clang-out-of-range-warning.patch
test_hexdump-avoid-string-truncation-warning.patch
block-partitions-ldm-convert-strncpy-to-strscpy.patch
blktrace-convert-strncpy-to-strscpy_pad.patch

