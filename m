Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 904B0763F8
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104486; cv=none; b=I4NjwnHQnKWRVin+8GNrJ3DhD4LKS6vlKUR2wzX4lmC53vTB2Ai44CtfuImjbM97pJoPE6QLawa39UtzQQY/TUTfUlfKZ1bJMCZ1ZM6r9C0L3r2aFrsURdNPONPxgY1n9CcvkDpVbgKE9JPe0dwJy2vjsHOpizT7A/ZfHNkQpjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104486; c=relaxed/simple;
	bh=sXervUBmM/RwmYXn/kat7E6wWfjWZvld+1hHycjVDLA=;
	h=Date:To:From:Subject:Message-Id; b=Ji4MrMFqzpmu09N+OOCuU7pU39FHqsfl7bCEp8nXu1O6ZmzJhYjBw1y/LPpXpbJ/YSvL6b993XxHkX6dQWUYT++q58zfE0oeXmER0cW1kAQo2q89ohF+Fs3UzYy8iVfPlA3/W4k8Fe/Ls99AW6tsNQ3tX+yzPBc30LGsg02NM8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Q2qNwpXX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Q2qNwpXX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6450CC113CD;
	Fri, 26 Apr 2024 04:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104486;
	bh=sXervUBmM/RwmYXn/kat7E6wWfjWZvld+1hHycjVDLA=;
	h=Date:To:From:Subject:From;
	b=Q2qNwpXXXgwGBScdAgtsiBI0evXFjbRNy1zSlHUhRoSieQQ7rYVKSu7u5KIm/yfGV
	 wMV5wq2Nv3602+f6wHn7NSHXG9M9G0qg/OEZVFxVialVH0ATIHf8fhvEmgju3E6XdD
	 2TM2vzQdeImlI+cZTZe7kIvjXYThBx9x6cM6lKh8=
Date: Thu, 25 Apr 2024 21:08:05 -0700
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,robert.moore@intel.com,rafael.j.wysocki@intel.com,nicolas@fjasle.eu,nathan@kernel.org,ming.m.lin@intel.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,masahiroy@kernel.org,lenb@kernel.org,ldm@flatcap.org,justinstitt@google.com,axboe@kernel.dk,astarikovskiy@suse.de,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] blktrace-convert-strncpy-to-strscpy_pad.patch removed from -mm tree
Message-Id: <20240426040806.6450CC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: blktrace: convert strncpy() to strscpy_pad()
has been removed from the -mm tree.  Its filename was
     blktrace-convert-strncpy-to-strscpy_pad.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

kbuild-turn-on-wextra-by-default.patch
kbuild-remove-redundant-extra-warning-flags.patch
kbuild-turn-on-wrestrict-by-default.patch
kbuild-enable-wformat-truncation-on-clang.patch
kbuild-enable-wcast-function-type-strict-unconditionally.patch

