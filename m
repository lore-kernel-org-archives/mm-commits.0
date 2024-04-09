Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBE78156F4E
	for <mm-commits@vger.kernel.org>; Tue,  9 Apr 2024 21:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712698565; cv=none; b=b8myD+2Mv0LcMQR+8ZLtBz2oGTUmXJVKHTt2FPWW5pXN18go1b+I8mXNmH5m9IUJeYsrhRrx7nNQ2iUlZUlrHx1x4VIqhTbI+z+vInBBY9QfDoZJOtKERGlNUg4qCQ3WfWbbEDabeRqDVPejD782YsS4P32okhftdz/MD8KpQGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712698565; c=relaxed/simple;
	bh=iDRcmQI+Ci6856fEieVHCfew7sBdYfLNJGXu56vcvE0=;
	h=Date:To:From:Subject:Message-Id; b=g3ZiiMhia6u7TxzPP8i7TJheLUZG0KNS8jAQVAVT2KK3zqRSI++Z57rAZW/UJ5uWngg0mEt0lAcn6zZrACsGS97H8AogZJ5sUDLHr6JMMNaJof6bH8709D0n0nSgOyudUdQSwOlfsyj/cihggBEEHR2LKbDGIizA+ELN/hx9Pz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UYQhAGAV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UYQhAGAV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51F58C433C7;
	Tue,  9 Apr 2024 21:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712698565;
	bh=iDRcmQI+Ci6856fEieVHCfew7sBdYfLNJGXu56vcvE0=;
	h=Date:To:From:Subject:From;
	b=UYQhAGAVwqzKXtoZ6BiE0tFieBKFgKTGZRIq5HmMZnLSIruIeeDaiay7OfYZF9bYk
	 J+v66lUGprvLN4oc+aWU2C7mRMeb87Xjm6DM4bjQvF3LIdZFTEg5bHunbOG5wNo2Vb
	 EXrsw4OXZozDvXQsVQMsaSA4bbI4D1xg8KjIMD+s=
Date: Tue, 09 Apr 2024 14:36:04 -0700
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,robert.moore@intel.com,rafael.j.wysocki@intel.com,nicolas@fjasle.eu,nathan@kernel.org,ming.m.lin@intel.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,masahiroy@kernel.org,lenb@kernel.org,ldm@flatcap.org,justinstitt@google.com,axboe@kernel.dk,astarikovskiy@suse.de,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + test_hexdump-avoid-string-truncation-warning.patch added to mm-nonmm-unstable branch
Message-Id: <20240409213605.51F58C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: test_hexdump: avoid string truncation warning
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     test_hexdump-avoid-string-truncation-warning.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/test_hexdump-avoid-string-truncation-warning.patch

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
Cc: Justin Stitt <justinstitt@google.com>
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

fix-missing-vmalloch-includes-fix-5.patch
kcov-avoid-clang-out-of-range-warning.patch
test_hexdump-avoid-string-truncation-warning.patch
block-partitions-ldm-convert-strncpy-to-strscpy.patch
blktrace-convert-strncpy-to-strscpy_pad.patch

