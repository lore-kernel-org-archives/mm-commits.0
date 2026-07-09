Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 211B71A681B
	for <mm-commits@vger.kernel.org>; Thu,  9 Jul 2026 03:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783566784; cv=none; b=e6zhgq6Ls9iLWtvNrl5/pOVF4xO/rfq+jsxUISnlZ9W9AVclzop85S26lSYxWriIj30R2kCIacRg81tpHHyaVwlFWRgSbV+v0BUe2vNMkDv70C1a9eysKZsakgH7UdVKeDOwtkPpJAll3++hUYiZuMYHlFk4wWFhQ/qAl/J0s2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783566784; c=relaxed/simple;
	bh=FN5C6MuaakCKvZ6dGi1JwGujL2YYApuiXg8YBrtoUj8=;
	h=Date:To:From:Subject:Message-Id; b=ndFcDBOe7xziHVnmb3UqB7F0Yaan646sRDEeuOlNDQADwavkY7qp5jIms8INeYycZsrnAoWdw9UFUGQsHc9lyUdSCQM9h4AczHmnDk/qC4tdxv47nOK7+830yGeIR4V0BnZLdiJ5zY9pCbta2rhZar6ySBGE2OcGQNCQm8BD8zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=btzADoEq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="btzADoEq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B299E1F000E9;
	Thu,  9 Jul 2026 03:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783566782;
	bh=x5GOrjMMDVKNtrfRIvX7JuNAtcd7RgSRpbh3JGYuuxc=;
	h=Date:To:From:Subject;
	b=btzADoEqGQiOIcTA9ZdNZf3vak7z0qs01hfdDnt9JgmfiTVLsNfufy8W9UF8Ek8WH
	 rbRRNJ7rEqbKfeuTLQ9ZYqDNc/6lxuEpR8P5iFe/b8SxgKbp+ociWFuulkqfURQa/l
	 GmOd2J88K/PgdB+bk4DjYWkbUu0N/AKoznaWVthE=
Date: Wed, 08 Jul 2026 20:13:02 -0700
To: mm-commits@vger.kernel.org,pmladek@suse.com,feng.tang@linux.alibaba.com,include@grrlz.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] panic-stop-cpus-that-lose-the-panic_redirect_cpu-race.patch removed from -mm tree
Message-Id: <20260709031302.B299E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: panic: stop CPUs that lose the panic_redirect_cpu race
has been removed from the -mm tree.  Its filename was
     panic-stop-cpus-that-lose-the-panic_redirect_cpu-race.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Bradley Morgan <include@grrlz.net>
Subject: panic: stop CPUs that lose the panic_redirect_cpu race
Date: Tue, 7 Jul 2026 18:32:53 +0000

Loser of the redirect cmpxchg must stop, not fall through to
panic_try_start().

This issue was found by sashiko [1].

Link: https://lore.kernel.org/20260707183253.9793-1-include@grrlz.net
Link: https://sashiko.dev/#/patchset/20260705164123.18746-1-include%40grrlz.net [1]
Signed-off-by: Bradley Morgan <include@grrlz.net>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Feng Tang <feng.tang@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/kernel/panic.c~panic-stop-cpus-that-lose-the-panic_redirect_cpu-race
+++ a/kernel/panic.c
@@ -400,12 +400,9 @@ static bool panic_try_force_cpu(const ch
 	if (panic_in_progress())
 		return false;
 
-	/*
-	 * Only one CPU can do the redirect. Use atomic cmpxchg to ensure
-	 * we don't race with another CPU also trying to redirect.
-	 */
+	/* Which CPU won the race? */
 	if (!atomic_try_cmpxchg(&panic_redirect_cpu, &old_cpu, this_cpu))
-		return false;
+		return old_cpu != this_cpu;
 
 	/*
 	 * Use dynamically allocated buffer if available, otherwise
_

Patches currently in -mm which might be from include@grrlz.net are

lib-string-fix-memchr_inv-for-large-ranges.patch
signal-avoid-shared-siginfo-namespace-rewrites.patch
panic-fix-va_list-reuse-in-panic_try_force_cpu.patch
reboot-use-lookup-tables-for-sysfs-mode-and-type-strings.patch
reboot-use-a-lookup-table-for-hw_protection_action-strings.patch
panic-make-force_cpu-redirect-work-from-an-nmi.patch

