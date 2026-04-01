Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E056C2F1FD0
	for <mm-commits@vger.kernel.org>; Wed,  1 Apr 2026 21:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775077941; cv=none; b=qoqKFoew1sYk8/a8P+0rq12+s0VqqM5m8SbCm1f7KEhwYU4Z2l4rFRFMcvEj/JMYiIpmHD9pS8jqW4e83kbzcSBkC8VUSDQoW1eyxlMS2WskbPxp5JYBFQM7D9iXnty3Ym7znxUiEwlybw1c0eJpCLxqFOuN9TIGtQkKd2R7PAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775077941; c=relaxed/simple;
	bh=u7sQXRvZaj9ve7rQnZHZd9OCYMQS5FJ4Xsg72LEGnXc=;
	h=Date:To:From:Subject:Message-Id; b=QT3ibuTWQrO7kHU8KFgyMadqaf7loKRaqPCVyciIrYry2pWGwDMX6Zs06vaPl2ZLrmcKmy0hyIX4eu+/mu+nIdvdMfrwLoL64bwc2POf3PCJ0tBG/EQlFqNThMsi37mbX/twzpBRQT/B2qQ9ArsA+nwfkz0RjdCJWFqojaBWOUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bvhUxN6S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bvhUxN6S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9978EC4CEF7;
	Wed,  1 Apr 2026 21:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775077941;
	bh=u7sQXRvZaj9ve7rQnZHZd9OCYMQS5FJ4Xsg72LEGnXc=;
	h=Date:To:From:Subject:From;
	b=bvhUxN6S0Kg10POi7sCt4Kk4oP+W/wZ12e136cBW8a7L6IZNCUx1nUGcqtnsi4Bxa
	 R+JtFkNsHQCbENZy2zxEobHQZJCZnvfPIzNma/ZTf3UF4k3N2eBMp0G0m0jK1eEZX8
	 aArLr3fA/zLEmYxz7tEhe+XCbju5wM47iFQWcnBo=
Date: Wed, 01 Apr 2026 14:12:21 -0700
To: mm-commits@vger.kernel.org,swboyd@chromium.org,senozhatsky@chromium.org,rostedt@goodmis.org,pmladek@suse.com,john.ogness@linutronix.de,geert+renesas@glider.be,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-hexdump-print_hex_dump_bytes-calls-print_hex_dump_debug.patch added to mm-nonmm-unstable branch
Message-Id: <20260401211221.9978EC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/hexdump: print_hex_dump_bytes() calls print_hex_dump_debug()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-hexdump-print_hex_dump_bytes-calls-print_hex_dump_debug.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-hexdump-print_hex_dump_bytes-calls-print_hex_dump_debug.patch

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
From: Geert Uytterhoeven <geert+renesas@glider.be>
Subject: lib/hexdump: print_hex_dump_bytes() calls print_hex_dump_debug()
Date: Tue, 31 Mar 2026 17:21:43 +0200

print_hex_dump_bytes() claims to be a simple wrapper around
print_hex_dump(), but it actally calls print_hex_dump_debug(), which means
no output is printed if (dynamic) DEBUG is disabled.

Update the documentation to match the implementation.

Link: https://lkml.kernel.org/r/3d5c3069fd9102ecaf81d044b750cd613eb72a08.1774970392.git.geert+renesas@glider.be
Fixes: 091cb0994edd20d6 ("lib/hexdump: make print_hex_dump_bytes() a nop on !DEBUG builds")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Cc: John Ogness <john.ogness@linutronix.de>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Stephen Boyd <swboyd@chromium.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/printk.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/include/linux/printk.h~lib-hexdump-print_hex_dump_bytes-calls-print_hex_dump_debug
+++ a/include/linux/printk.h
@@ -802,7 +802,8 @@ static inline void print_hex_dump_debug(
 #endif
 
 /**
- * print_hex_dump_bytes - shorthand form of print_hex_dump() with default params
+ * print_hex_dump_bytes - shorthand form of print_hex_dump_debug() with default
+ *                        params
  * @prefix_str: string to prefix each line with;
  *  caller supplies trailing spaces for alignment if desired
  * @prefix_type: controls whether prefix of an offset, address, or none
@@ -810,7 +811,7 @@ static inline void print_hex_dump_debug(
  * @buf: data blob to dump
  * @len: number of bytes in the @buf
  *
- * Calls print_hex_dump(), with log level of KERN_DEBUG,
+ * Calls print_hex_dump_debug(), with log level of KERN_DEBUG,
  * rowsize of 16, groupsize of 1, and ASCII output included.
  */
 #define print_hex_dump_bytes(prefix_str, prefix_type, buf, len)	\
_

Patches currently in -mm which might be from geert+renesas@glider.be are

lib-hexdump-print_hex_dump_bytes-calls-print_hex_dump_debug.patch

