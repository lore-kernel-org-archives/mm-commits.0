Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5013F218AA5
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742189585; cv=none; b=Ciq983LwWvBb2BCtTCTq5JuynJE5SXKXTBADSwufKkmECfIi9WpXP5rP8DAoG83AdQcu3Iu5D2Oet4hZaIkwDx8fchAwktWwNk3fa/U9IML1O1cBqgH2isOzsvnsQ6hlP9iEUGbGb0f2SmMV+9mqcVzWYYF0G8gTZC+aDmT13Y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742189585; c=relaxed/simple;
	bh=I5hqoqatu7SG8ltAaPFymHr8NZ70svZIdOL1X5XerL4=;
	h=Date:To:From:Subject:Message-Id; b=YnlvwHnZOU/BJ6PS3HTIqm9Qnlt84/KiqgcmKyvok+JpcCjB+mlH/gBF1XLQRNkiuSPN8aXKFYZ/WcUIf62yFrGDrq1HDW7OzuSKmhZ7/jPQqauj6tca1qBohRZr7bjSbA4xG9AlzOSJ7L12KL0AOq7nf7DFCo1IV+VQFYpF5QQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=o3MUUG5L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="o3MUUG5L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26F8DC4CEEC;
	Mon, 17 Mar 2025 05:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742189585;
	bh=I5hqoqatu7SG8ltAaPFymHr8NZ70svZIdOL1X5XerL4=;
	h=Date:To:From:Subject:From;
	b=o3MUUG5LDUrmFbXVZfhTT1IXfqYPYHrYP6UnbQvtslN+81Ko1YpKAtEliyDluSbGW
	 Lsawk1kCg/c1YMkeFCwRXkohM/pZQp9aP/Lp6ZnQQVxY0weBe3kR+HzwrmRnGPkTCi
	 XaLf5YwuLiDvfPYMVqjvUfbzm60+5SqP9jjw1Z/Y=
Date: Sun, 16 Mar 2025 22:33:04 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,song@kernel.org,thorsten.blum@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] watchdog-perf-optimize-bytes-copied-and-remove-manual-nul-termination.patch removed from -mm tree
Message-Id: <20250317053305.26F8DC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: watchdog/perf: optimize bytes copied and remove manual NUL-termination
has been removed from the -mm tree.  Its filename was
     watchdog-perf-optimize-bytes-copied-and-remove-manual-nul-termination.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Thorsten Blum <thorsten.blum@linux.dev>
Subject: watchdog/perf: optimize bytes copied and remove manual NUL-termination
Date: Thu, 13 Mar 2025 14:30:02 +0100

Currently, up to 23 bytes of the source string are copied to the
destination buffer (including the comma and anything after it), only to
then manually NUL-terminate the destination buffer again at index 'len'
(where the comma was found).

Fix this by calling strscpy() with 'len' instead of the destination buffer
size to copy only as many bytes from the source string as needed.

Change the length check to allow 'len' to be less than or equal to the
destination buffer size to fill the whole buffer if needed.

Remove the if-check for the return value of strscpy(), because calling
strscpy() with 'len' always truncates the source string at the comma as
expected and NUL-terminates the destination buffer at the corresponding
index instead.  Remove the manual NUL-termination.

No functional changes intended.

Link: https://lkml.kernel.org/r/20250313133004.36406-2-thorsten.blum@linux.dev
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Song Liu <song@kernel.org>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog_perf.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/kernel/watchdog_perf.c~watchdog-perf-optimize-bytes-copied-and-remove-manual-nul-termination
+++ a/kernel/watchdog_perf.c
@@ -294,12 +294,10 @@ void __init hardlockup_config_perf_event
 	} else {
 		unsigned int len = comma - str;
 
-		if (len >= sizeof(buf))
+		if (len > sizeof(buf))
 			return;
 
-		if (strscpy(buf, str, sizeof(buf)) < 0)
-			return;
-		buf[len] = 0;
+		strscpy(buf, str, len);
 		if (kstrtoull(buf, 16, &config))
 			return;
 	}
_

Patches currently in -mm which might be from thorsten.blum@linux.dev are


