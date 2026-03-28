Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A9DC337BB0
	for <mm-commits@vger.kernel.org>; Sat, 28 Mar 2026 04:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774671968; cv=none; b=tXQqLQE9PuMvjqMeQTwKwXCz8uxdjy5vh4LsR+yxzjIQ4uVwdoUMsmRYmvqOpnp0W/JVrztdhve/TzX515IQFVlMFYc4KfEw5nNR2C7bed2evXRN4nq0eIVxtMMIVzWobwSbsu+7GhnFVqsHWV3nBXnxUw9yQ1rztVWwcWvBWpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774671968; c=relaxed/simple;
	bh=syP4tyZu65pABLWNlOaWqzdzr06+dqCg2C+7PrrVF2g=;
	h=Date:To:From:Subject:Message-Id; b=jun8HWm0vQB/rAB2PQg97VcHCZiFSZ1+qh9/cgatlFnCQhG5tNs9DjkIJuvdQtUP09+bVK0h5OOC6PR0T3VFTlEJAT8QyGRDwMC3s+WmCYg4YnqR6mW9FgeXVlObVpnwSr+wuKq86MBQNnQrnj1dBtgP7QrBTRBECZPBcguAUCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Zzi1tv0h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Zzi1tv0h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCCC2C4CEF7;
	Sat, 28 Mar 2026 04:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774671967;
	bh=syP4tyZu65pABLWNlOaWqzdzr06+dqCg2C+7PrrVF2g=;
	h=Date:To:From:Subject:From;
	b=Zzi1tv0hx5c7jXeXUir7k64dVdRsUSusqnZabyj5PLVgAveI5+o5cVlCfcxrokSO3
	 eKbqhpYQZFWjX8rCZCPFeCcttKXxRpM2Fm6Pm4ub1jr2Ecxzb2LmiiWYKgEDx1AZR3
	 syZ5tT0t5l5Y5P4Ewp4B4eLPm19y94wc0LuBYrgw=
Date: Fri, 27 Mar 2026 21:26:07 -0700
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,derkling@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] scripts-decodecode-return-0-on-success.patch removed from -mm tree
Message-Id: <20260328042607.CCCC2C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: scripts/decodecode: return 0 on success
has been removed from the -mm tree.  Its filename was
     scripts-decodecode-return-0-on-success.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Patrick Bellasi <derkling@google.com>
Subject: scripts/decodecode: return 0 on success
Date: Wed, 18 Mar 2026 15:05:45 +0000

The decodecode script always returns an exit code of 1, regardless of
whether the operation was successful or not.  This is because the
"cleanup" function, which is registered to run on any script exit via
"trap cleanup EXIT", contains an unconditional "exit 1".

Remove the "exit 1" from the "cleanup" function so that it only performs
the necessary file cleanup without forcing a non-zero exit status.

Do that to ensure successful script executions now exit with code 0. 
Exits due to errors are all handled by the "die()" function and will still
correctly exit with code 1.

Link: https://lkml.kernel.org/r/20260318150545.2809311-1-derkling@google.com
Signed-off-by: Patrick Bellasi <derkling@google.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/decodecode |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/scripts/decodecode~scripts-decodecode-return-0-on-success
+++ a/scripts/decodecode
@@ -12,7 +12,6 @@ faultlinenum=1
 
 cleanup() {
 	rm -f $T $T.s $T.o $T.oo $T.aa $T.dis
-	exit 1
 }
 
 die() {
@@ -49,7 +48,7 @@ done
 
 if [ -z "$code" ]; then
 	rm $T
-	exit
+	die "Code line not found"
 fi
 
 echo $code
_

Patches currently in -mm which might be from derkling@google.com are


