Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92F89353EE0
	for <mm-commits@vger.kernel.org>; Tue,  7 Apr 2026 21:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775597119; cv=none; b=CHMvymPGUE9uwlQjGQ+XKiHZhYVV+IVpHoPsQV9J7lbtF9dZBRBTpVkDs++3Zk+EYrKLwHL5nEpVsRJ1hGjWPvz+3ugUiGYDO7F77e8xECp3TzhrFM1S2cJE1HZ87sfyZauDalVKmaRfzH10aF/UL/jBhHuy1oUot2YzSpa892o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775597119; c=relaxed/simple;
	bh=+ZxjS7ucZ6NAhglYl5Gu/sxgLTZT3FxylalBTCJHvmg=;
	h=Date:To:From:Subject:Message-Id; b=CW4E43+Lcol1mUM5Ud5oAk7BXsh9h73G+3lA/h4KEx83/4o6XzvpbPAbT5ypSF2ziJhZstwpdAs0fqibRalI/iwpBOYdcmcRLFisuLyoK8t/Qrhk5KE6hFXCoFcGXfUcHATa/ewWi2CCGchTG+CtxLgMNSKPVvKwJBAxm7iLMlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nxm4an4R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nxm4an4R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 269A5C116C6;
	Tue,  7 Apr 2026 21:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775597119;
	bh=+ZxjS7ucZ6NAhglYl5Gu/sxgLTZT3FxylalBTCJHvmg=;
	h=Date:To:From:Subject:From;
	b=nxm4an4RN1ZhYvtHSCuaBUgDd2ZH2MHqLQph1ib0VdUl4hzWFB4xwbvxzXP56AU4q
	 h7zQ7eVcLRvA9RaeQW7lt5TId14xDkTldb2drw1reBcjOmmImh4T0TOf2Kb26AvWvm
	 mUKqjzVQmC0xxjd3scKUGUOb2tDhKBZoSBsCMOzI=
Date: Tue, 07 Apr 2026 14:25:18 -0700
To: mm-commits@vger.kernel.org,swboyd@chromium.org,senozhatsky@chromium.org,rostedt@goodmis.org,pmladek@suse.com,john.ogness@linutronix.de,geert+renesas@glider.be,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] lib-hexdump-print_hex_dump_bytes-calls-print_hex_dump_debug.patch removed from -mm tree
Message-Id: <20260407212519.269A5C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/hexdump: print_hex_dump_bytes() calls print_hex_dump_debug()
has been removed from the -mm tree.  Its filename was
     lib-hexdump-print_hex_dump_bytes-calls-print_hex_dump_debug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Geert Uytterhoeven <geert+renesas@glider.be>
Subject: lib/hexdump: print_hex_dump_bytes() calls print_hex_dump_debug()
Date: Tue, 31 Mar 2026 17:21:43 +0200

print_hex_dump_bytes() claims to be a simple wrapper around
print_hex_dump(), but it actally calls print_hex_dump_debug(), which means
no output is printed if (dynamic) DEBUG is disabled.

Update the documentation to match the implementation.

Link: https://lkml.kernel.org/r/3d5c3069fd9102ecaf81d044b750cd613eb72a08.1774970392.git.geert+renesas@glider.be
Fixes: 091cb0994edd ("lib/hexdump: make print_hex_dump_bytes() a nop on !DEBUG builds")
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


