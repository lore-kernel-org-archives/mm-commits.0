Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45A9E184
	for <mm-commits@vger.kernel.org>; Tue, 14 Jul 2026 00:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783988427; cv=none; b=VIb/V/Eo4u7Wq6YjWZG3GgNyFaMogAuRjDepP5Fqx2zA8EacXvggmv3fFDRl4zszHLSlDppqaXfm5ZsbpKgFNj/0WaVEfxu1qwduLQEbqbmB7mfZbDT0vwTD8kxU7RMQQ2x+pUagT7Gt+Ne+Fcphx+nLsbRtUdqv0Im52sIbZgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783988427; c=relaxed/simple;
	bh=TVE6ReFJIVbNWJpj526EZplKdGWZ68qgikkpSQE7FEA=;
	h=Date:To:From:Subject:Message-Id; b=t1UYVWTktZjaDtBKH9ZB4ZI9HUGVO5D+bFHvsOMXqzNKq+LAgT1Iq9va2oYKmLR17aT5wo1tO/JDYgAG7AmjDuPKLKxWPfoIPQGa/hObdVOQT6dHOmhI7ZsvXkX6z1yT+JPMvGFFPU4RUpHdKq6uDQxUUJUnR0EKHwUAS0hBzWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TdhS/iMr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TdhS/iMr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACCEE1F000E9;
	Tue, 14 Jul 2026 00:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783988425;
	bh=gE3Y8rFmJAYRAK/OX1rTHNdNrHFOKRXnjohDBu0LN1M=;
	h=Date:To:From:Subject;
	b=TdhS/iMrjQ9ImG8AkEwoucNZoQqpiVP+KMYfg/ICMRcRbY4kgG8/i/XcJP9fqx4Qy
	 eHM5vMhJ8perzJGrZYzS7quvxqYfVV4Zx/AjvNNHlgXAD8qoeFMbwVsn1ja/6s6+OJ
	 5GeKFSWcd8YfCN6lwK9WiY/jQq4jKZf0/lyFng/g=
Date: Mon, 13 Jul 2026 17:20:25 -0700
To: mm-commits@vger.kernel.org,wangjinchao600@gmail.com,pmladek@suse.com,include@grrlz.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] panic-fix-va_list-reuse-in-panic_try_force_cpu.patch removed from -mm tree
Message-Id: <20260714002025.ACCEE1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: panic: fix va_list reuse in panic_try_force_cpu()
has been removed from the -mm tree.  Its filename was
     panic-fix-va_list-reuse-in-panic_try_force_cpu.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Bradley Morgan <include@grrlz.net>
Subject: panic: fix va_list reuse in panic_try_force_cpu()
Date: Sun, 5 Jul 2026 16:41:23 +0000

vsnprintf() consumes the caller's va_list. When the redirect fails,
vpanic() reuses it for the panic message, which is undefined
behavior. Use va_copy().

Link: https://lore.kernel.org/20260705164123.18746-1-include@grrlz.net
Signed-off-by: Bradley Morgan <include@grrlz.net>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Cc: Wang Jinchao <wangjinchao600@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/kernel/panic.c~panic-fix-va_list-reuse-in-panic_try_force_cpu
+++ a/kernel/panic.c
@@ -412,7 +412,12 @@ static bool panic_try_force_cpu(const ch
 	 * fall back to static message for early boot panics or allocation failure.
 	 */
 	if (panic_force_buf) {
-		vsnprintf(panic_force_buf, PANIC_MSG_BUFSZ, fmt, args);
+		va_list ap;
+
+		/* Do not consume args, the caller reuses it if we fail */
+		va_copy(ap, args);
+		vsnprintf(panic_force_buf, PANIC_MSG_BUFSZ, fmt, ap);
+		va_end(ap);
 		msg = panic_force_buf;
 	} else {
 		msg = "Redirected panic (buffer unavailable)";
_

Patches currently in -mm which might be from include@grrlz.net are

lib-string-fix-memchr_inv-for-large-ranges.patch
signal-avoid-shared-siginfo-namespace-rewrites.patch
reboot-use-lookup-tables-for-sysfs-mode-and-type-strings.patch
reboot-use-a-lookup-table-for-hw_protection_action-strings.patch

