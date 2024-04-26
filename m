Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20F93763F8
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104484; cv=none; b=XokZ7yGpXx51/gb8KurWIAmwzvwH4HrqfbnTyqZFSSTQcOhkViuquIDUbBHhcoY94gmlj7jz18KnjXM2npNwTNP/hmP/PyzwmuVn//bi7n3fBFpwyPBBrrqXjKfu4CnRMBvtROo4N3AWiO1kGbhHuFLa5wdl2WgLcyFcGKIYA5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104484; c=relaxed/simple;
	bh=z+Oak+NoawaaVDNNYf9JBlqebFGUgvRZ/UdZcnIi69Q=;
	h=Date:To:From:Subject:Message-Id; b=iN3bhE04gSCtadzTwxl/i35LlkeF1hhida/PgJNUEJXoUXjFK0TYXME9ClWfhah5wN7w3qMjbWCywoOoIW7tV07o2ZT6yT7cfbyofT9qaXEduTg6XUosiqAK0WXo7bokgEpU5yUeVPo/GT6BK9ZW+v86wQ/L0zc2D/LEchP1hdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pxCcS1oO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pxCcS1oO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7B28C113CD;
	Fri, 26 Apr 2024 04:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104484;
	bh=z+Oak+NoawaaVDNNYf9JBlqebFGUgvRZ/UdZcnIi69Q=;
	h=Date:To:From:Subject:From;
	b=pxCcS1oO9FbivIQYp7CR3ZrhE3e0rUEhdorDz7EweIpmW6p81LVl44lpTxavMeNfO
	 kCMP0NT663+34/2MJF3yDCvQ9zI7ED6OwpO2xGYWw10PtlM/shT3vhGqMr6A1JTSdq
	 yEjGFDHxMYfM0/DKLmAR3E7pb0hoy8C82Iwt8rTY=
Date: Thu, 25 Apr 2024 21:08:03 -0700
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,robert.moore@intel.com,rafael.j.wysocki@intel.com,nicolas@fjasle.eu,nathan@kernel.org,ming.m.lin@intel.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,masahiroy@kernel.org,lenb@kernel.org,ldm@flatcap.org,justinstitt@google.com,axboe@kernel.dk,astarikovskiy@suse.de,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] test_hexdump-avoid-string-truncation-warning.patch removed from -mm tree
Message-Id: <20240426040803.E7B28C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: test_hexdump: avoid string truncation warning
has been removed from the -mm tree.  Its filename was
     test_hexdump-avoid-string-truncation-warning.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: test_hexdump: avoid string truncation warning
Date: Tue, 9 Apr 2024 16:00:54 +0200

gcc can warn when a string is too long to fit into the strncpy()
destination buffer, as it is here depending on the function arguments:

    inlined from 'test_hexdump_prepare_test.constprop' at /home/arnd/arm-soc/lib/test_hexdump.c:116:3:
include/linux/fortify-string.h:108:33: error: '__builtin_strncpy' output truncated copying between 0 and 32 bytes from a string of length 32 [-Werror=stringop-truncation]
  108 | #define __underlying_strncpy    __builtin_strncpy
      |                                 ^
include/linux/fortify-string.h:187:16: note: in expansion of macro '__underlying_strncpy'
  187 |         return __underlying_strncpy(p, q, size);
      |                ^~~~~~~~~~~~~~~~~~~~

The intention here is to copy exactly 'l' bytes without any padding or
NUL-termination, so the most logical change is to use memcpy(), just as
a previous change adapted the other output from strncpy() to memcpy().

Link: https://lkml.kernel.org/r/20240409140059.3806717-2-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Justin Stitt <justinstitt@google.com>
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

 lib/test_hexdump.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/test_hexdump.c~test_hexdump-avoid-string-truncation-warning
+++ a/lib/test_hexdump.c
@@ -113,7 +113,7 @@ static void __init test_hexdump_prepare_
 			*p++ = ' ';
 		} while (p < test + rs * 2 + rs / gs + 1);
 
-		strncpy(p, data_a, l);
+		memcpy(p, data_a, l);
 		p += l;
 	}
 
_

Patches currently in -mm which might be from arnd@arndb.de are

kbuild-turn-on-wextra-by-default.patch
kbuild-remove-redundant-extra-warning-flags.patch
kbuild-turn-on-wrestrict-by-default.patch
kbuild-enable-wformat-truncation-on-clang.patch
kbuild-enable-wcast-function-type-strict-unconditionally.patch

