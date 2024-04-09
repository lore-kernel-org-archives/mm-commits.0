Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 700EF156F4E
	for <mm-commits@vger.kernel.org>; Tue,  9 Apr 2024 21:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712698569; cv=none; b=qOHT9A2wR6e3seb4kOqrlwoYeX28KPWAAN9Y0SNp7YRlQvKdRjqYp/5NHvZ1C9svXMpZd6IQf58QJLS2gF2otB71IaMsaBmVhe+sKkh7jqOKNQrlhRwZWy0xCXE9eFsIgTQuns0iam3OEwr+Gtu17MkzZXZLHplFhkHmvIpvpN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712698569; c=relaxed/simple;
	bh=R/VQTKkJRtIx+VT4eWdbHFjL7Bs06aVfUd4Wq7kwuL8=;
	h=Date:To:From:Subject:Message-Id; b=r4b5IGPRbGHX8L5R7OK4E+O4fN80trhNtpeR0Ec6Am2nJKyyN6Oxi79QvwEhZsiden9V9bP8wW59sqnP792C5jKhf7kxOyR1eOfUGTHTkjKTFHzWD+9cuPQaGRz6M9xK9ZrA+DYe5ExY2RKZnfRJ4QxByTG7/wfN6DvIkG5DjJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OmLV1NaG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OmLV1NaG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 428B3C433F1;
	Tue,  9 Apr 2024 21:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712698569;
	bh=R/VQTKkJRtIx+VT4eWdbHFjL7Bs06aVfUd4Wq7kwuL8=;
	h=Date:To:From:Subject:From;
	b=OmLV1NaGWAUBD/2fprAM342DwngnfigTA6Yq4Dl1Ij90rK8IByqkr/9s+3XXeMovP
	 r771IsNJROSDJNJEq8joHoiKHxwYdpKCP8lBCgzftcmEIbhwg9SkL1lZWwQKQk3uEK
	 YWXmkmQoXncNa09pI7ZomB/0iWI5mdvsgLTnTL0U=
Date: Tue, 09 Apr 2024 14:36:08 -0700
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,robert.moore@intel.com,rafael.j.wysocki@intel.com,nicolas@fjasle.eu,nathan@kernel.org,ming.m.lin@intel.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,masahiroy@kernel.org,lenb@kernel.org,ldm@flatcap.org,justinstitt@google.com,axboe@kernel.dk,astarikovskiy@suse.de,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + blktrace-convert-strncpy-to-strscpy_pad.patch added to mm-nonmm-unstable branch
Message-Id: <20240409213609.428B3C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: blktrace: convert strncpy() to strscpy_pad()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     blktrace-convert-strncpy-to-strscpy_pad.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/blktrace-convert-strncpy-to-strscpy_pad.patch

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
Subject: blktrace: convert strncpy() to strscpy_pad()
Date: Tue, 9 Apr 2024 16:00:57 +0200

gcc-9 warns about a possibly non-terminated string copy:

kernel/trace/blktrace.c: In function 'do_blk_trace_setup':
kernel/trace/blktrace.c:527:2: error: 'strncpy' specified bound 32 equals destination size [-Werror=stringop-truncation]

Newer versions are fine here because they see the following explicit
nul-termination. Using strscpy_pad() avoids the warning and
simplifies the code a little. The padding helps  give a clean
buffer to userspace.

Link: https://lkml.kernel.org/r/20240409140059.3806717-5-arnd@kernel.org
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
Cc: Justin Stitt <justinstitt@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/trace/blktrace.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/kernel/trace/blktrace.c~blktrace-convert-strncpy-to-strscpy_pad
+++ a/kernel/trace/blktrace.c
@@ -524,8 +524,7 @@ static int do_blk_trace_setup(struct req
 	if (!buts->buf_size || !buts->buf_nr)
 		return -EINVAL;
 
-	strncpy(buts->name, name, BLKTRACE_BDEV_SIZE);
-	buts->name[BLKTRACE_BDEV_SIZE - 1] = '\0';
+	strscpy_pad(buts->name, name, BLKTRACE_BDEV_SIZE);
 
 	/*
 	 * some device names have larger paths - convert the slashes
_

Patches currently in -mm which might be from arnd@arndb.de are

fix-missing-vmalloch-includes-fix-5.patch
kcov-avoid-clang-out-of-range-warning.patch
test_hexdump-avoid-string-truncation-warning.patch
block-partitions-ldm-convert-strncpy-to-strscpy.patch
blktrace-convert-strncpy-to-strscpy_pad.patch

