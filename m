Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72AA23E4C6B
	for <mm-commits@vger.kernel.org>; Wed,  8 Jul 2026 21:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783547776; cv=none; b=mYO+IpV7C6J1uPpLF7nuZa7DLv3HjdYEKbdt4bbCFeZ5uWuJ/3DmSA9mjpamBkGMY/xt2gsgyR+c/TaKxjY6WnGoiWLRyoO/4OeZNhGaYu/w8HEZwUQbloa6zy8/64pOW2b1T7KQzVIxxQ3648UHn3Hsy5sZPctl2iN3qVEmYxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783547776; c=relaxed/simple;
	bh=dSiKM+kWJoWrMqXgyydQZgiBalS39bQE5XkzNbXM+zw=;
	h=Date:To:From:Subject:Message-Id; b=M/v8tqQ0NVJ2hT97A0w0dNvOh/geOyBL+A1tPt/3Q5JRrF5RooFsfeYLPzAxxt9L0xpygBxwQRTmcQF4As4qdxbhJXY5bJ0eQpHr8VHE+3Z8wjs7IqtnAkPIDiO/V/wW0mUJvPd204kuEvGsVkdo5Ef0o8Q9QWN6V2VS6DVfmRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EiJo3FyM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EiJo3FyM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB1C71F000E9;
	Wed,  8 Jul 2026 21:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783547774;
	bh=Ec6XoHjsatDwUXMkJTm7k3EcDzoPcSpOBd4usWtnONU=;
	h=Date:To:From:Subject;
	b=EiJo3FyM3pPzMWStP0II+6w2WDd25ZC5LO9LQbxF0vqnt/fT332NNS5XzQGY1GDcq
	 zw89tqVjVGrT+Xqt90oCBYxuarcW3GfUq8HZTPxHArKYA643p8ebBwE6cAI42a9NeB
	 93/AUftzTppATk5Q3fzDwDzOJNgsY7Rsy3TB5D+M=
Date: Wed, 08 Jul 2026 14:56:14 -0700
To: mm-commits@vger.kernel.org,pmladek@suse.com,feng.tang@linux.alibaba.com,include@grrlz.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] panic-make-force_cpu-redirect-work-from-an-nmi.patch removed from -mm tree
Message-Id: <20260708215614.CB1C71F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: panic: make force_cpu redirect work from an NMI
has been removed from the -mm tree.  Its filename was
     panic-make-force_cpu-redirect-work-from-an-nmi.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Bradley Morgan <include@grrlz.net>
Subject: panic: make force_cpu redirect work from an NMI
Date: Tue, 7 Jul 2026 20:59:21 +0000

nmi_panic sets panic_cpu first.  Bail only on a different owner, and hand
panic_cpu to the target after the IPI.

Found by sashiko [1].

Link: https://lore.kernel.org/20260707205921.15247-1-include@grrlz.net
Link: https://sashiko.dev/#/patchset/20260707183253.9793-1-include@grrlz.net [1]
Signed-off-by: Bradley Morgan <include@grrlz.net>
Cc: Feng Tang <feng.tang@linux.alibaba.com>
Cc: Petr Mladek <pmladek@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/kernel/panic.c~panic-make-force_cpu-redirect-work-from-an-nmi
+++ a/kernel/panic.c
@@ -396,8 +396,8 @@ static bool panic_try_force_cpu(const ch
 		return false;
 	}
 
-	/* Another panic already in progress */
-	if (panic_in_progress())
+	/* Bail only if a different CPU is already handling it. */
+	if (panic_in_progress() && atomic_read(&panic_cpu) != this_cpu)
 		return false;
 
 	/* Which CPU won the race? */
@@ -440,6 +440,9 @@ static bool panic_try_force_cpu(const ch
 		return false;
 	}
 
+	/* Hand panic_cpu to the target so it wins its own panic_try_start. */
+	atomic_set(&panic_cpu, panic_force_cpu);
+
 	/* IPI/NMI sent, this CPU should stop */
 	return true;
 }
_

Patches currently in -mm which might be from include@grrlz.net are

lib-string-fix-memchr_inv-for-large-ranges.patch
signal-avoid-shared-siginfo-namespace-rewrites.patch
panic-fix-va_list-reuse-in-panic_try_force_cpu.patch
reboot-use-lookup-tables-for-sysfs-mode-and-type-strings.patch
reboot-use-a-lookup-table-for-hw_protection_action-strings.patch
panic-stop-cpus-that-lose-the-panic_redirect_cpu-race.patch

