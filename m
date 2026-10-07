Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6508A3546FC;
	Wed,  7 Oct 2026 02:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791338719; cv=none; b=NA/lNIDQwRX4rRP5gY8snMWsImzs+SOC7x+jFmsexZHzSJVaEMdyuXf8apPp6IugxrRVfG6fjaCczGfD1ZpHYHCyj07OwDHjssqeW9LXRi+NMBL3t/Kp4A4ZQ6923dz9vZ4L7F+RVZoD8tzVM/3TCkkx1xsCeRAHIDnkn1/9e70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791338719; c=relaxed/simple;
	bh=hxfeLyZ50twsvZadKZOFGRqWxUtztmIDMwwXBrutpw4=;
	h=Date:To:From:Subject:Message-Id; b=khsTOIPtDXspdX5k0pE8SwHjCx11zq6WUgdWNIaxToRBgSTlN/OGGc0Y4RIwrzDkspqzUD+0CXnFVGijMTVCQ1i8pkj6HIOcIAirx+4QQEAEocnq9fsx9WW3kS/eKmKkvPZeBkEE81BeKbUhB6kv8WUo23jHIqLJZ5BLOiVx9Cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xl4ABWpM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xl4ABWpM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 391CD1F0089C;
	Wed,  7 Oct 2026 02:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791338718;
	bh=Ob+Dxn411LSJSUJTtqjuj0LFq6+hoSdoNVwpOHhm/bc=;
	h=Date:To:From:Subject;
	b=xl4ABWpMYlCmC/QFLobfEvOmPsZ7V/DwO3AnHRpH7knPfLI+VgmCL0O5lm7Y0i0lu
	 lmu6ZpXu1GOxE/cqYSaGgPrPDiagPa1xA1pOISTOKQ+nOC6NZHdeb1Ncu09GvBbmC/
	 ROF02M2FZaUOkhiBlsxo1H1WR8qHDZioNjq4MTYA=
Date: Tue, 06 Oct 2026 19:05:17 -0700
To: mm-commits@vger.kernel.org,wim@linux-watchdog.org,wangjinchao600@gmail.com,stable@vger.kernel.org,sashiko-bot@kernel.org,pmladek@suse.com,linux@roeck-us.net,brads@mainlining.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] panic-fix-va_list-reuse-in-panic_try_force_cpu.patch removed from -mm tree
Message-Id: <20261007020518.391CD1F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: panic: fix va_list reuse in panic_try_force_cpu()
has been removed from the -mm tree.  Its filename was
     panic-fix-va_list-reuse-in-panic_try_force_cpu.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Bradley Morgan <brads@mainlining.org>
Subject: panic: fix va_list reuse in panic_try_force_cpu()
Date: Wed, 16 Sep 2026 18:29:54 +0000

vsnprintf() consumes the caller's va_list.  When the redirect fails,
vpanic() reuses it for the panic message, which is undefined behavior. 
Use va_copy().

Link: https://lore.kernel.org/20260916182957.7788-4-brads@mainlining.org
Fixes: 2e171ab29f91 ("panic: add panic_force_cpu= parameter to redirect panic to a specific CPU")
Signed-off-by: Bradley Morgan <brads@mainlining.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Cc: Guenetr Roeck <linux@roeck-us.net>
Cc: Sashiko <sashiko-bot@kernel.org>
Cc: Wang Jinchao <wangjinchao600@gmail.com>
Cc: Wim Van Sebroeck <wim@linux-watchdog.org>
Cc: <stable@vger.kernel.org>
---

 kernel/panic.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/kernel/panic.c~panic-fix-va_list-reuse-in-panic_try_force_cpu
+++ a/kernel/panic.c
@@ -417,7 +417,12 @@ static bool panic_try_force_cpu(const ch
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

Patches currently in -mm which might be from brads@mainlining.org are

watchdog-perf-one-digit-too-short-in-the-raw-event-config-copy.patch

