Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CCD7500960;
	Mon, 19 Jan 2026 20:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768854649; cv=none; b=VA6tKAsX1zAGHSmf6+AtOQBGpkwhCzL7pCSkCNrfLvR/+hUqTA2qydrtTm7I8gRv3LQuxy0AWfy9MKuJiqQnll+yBAmM9oZDRTzl5TkccDx0O9l+mOoJaYN/bC3h+38YAr1D4UlXT0chh+1bB+9+vO76fzYddLTiDYXLswOnetw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768854649; c=relaxed/simple;
	bh=mq4fxkF6fn9Xko0vW1kin/l5bm+A7FWlUtQGj52ewmI=;
	h=Date:To:From:Subject:Message-Id; b=epAwsJlqZb6XEP8/exxWsCytxasfAEOhZHCB+0+2ytPa8YMeETfNtkttcjPaxpJyxpcwmABpD0reGWkvkqBzrNPgCm40zlHlvUTT9cr+b95Ka3xePg/CzOzO9ynsTEgka4iyNh8wlqFI1h4AYtXEgdzyKvwsCGnoVbj0uj4Q6WQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GvA/pnFI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GvA/pnFI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDCC8C116C6;
	Mon, 19 Jan 2026 20:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768854648;
	bh=mq4fxkF6fn9Xko0vW1kin/l5bm+A7FWlUtQGj52ewmI=;
	h=Date:To:From:Subject:From;
	b=GvA/pnFIY4OU+dFCkjAatFzhz5ql+rqT5zJnKq8DmgaMXjKi+Ve1cWQQhiFM6eKcn
	 r5ehMstOlhuwndNuIxJct/SaXcd5tSH83ZOx1DZE562WpN6a5HpXvp+4L+8vkpEILI
	 LJjHRotMh+rOeo8cTPcw2JT564gVLrBHb87hTT+A=
Date: Mon, 19 Jan 2026 12:30:48 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,pmladek@suse.com,noren@nvidia.com,mbloch@nvidia.com,joel.granados@kernel.org,feng.tang@linux.alibaba.com,gal@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] panic-only-warn-about-deprecated-panic_print-on-write-access.patch removed from -mm tree
Message-Id: <20260119203048.CDCC8C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: panic: only warn about deprecated panic_print on write access
has been removed from the -mm tree.  Its filename was
     panic-only-warn-about-deprecated-panic_print-on-write-access.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Gal Pressman <gal@nvidia.com>
Subject: panic: only warn about deprecated panic_print on write access
Date: Tue, 6 Jan 2026 18:33:21 +0200

The panic_print_deprecated() warning is being triggered on both read and
write operations to the panic_print parameter.

This causes spurious warnings when users run 'sysctl -a' to list all
sysctl values, since that command reads /proc/sys/kernel/panic_print and
triggers the deprecation notice.

Modify the handlers to only emit the deprecation warning when the
parameter is actually being set:

 - sysctl_panic_print_handler(): check 'write' flag before warning.
 - panic_print_get(): remove the deprecation call entirely.

This way, users are only warned when they actively try to use the
deprecated parameter, not when passively querying system state.

Link: https://lkml.kernel.org/r/20260106163321.83586-1-gal@nvidia.com
Fixes: ee13240cd78b ("panic: add note that panic_print sysctl interface is deprecated")
Fixes: 2683df6539cb ("panic: add note that 'panic_print' parameter is deprecated")
Signed-off-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Nimrod Oren <noren@nvidia.com>
Cc: Feng Tang <feng.tang@linux.alibaba.com>
Cc: Joel Granados <joel.granados@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/panic.c~panic-only-warn-about-deprecated-panic_print-on-write-access
+++ a/kernel/panic.c
@@ -131,7 +131,8 @@ static int proc_taint(const struct ctl_t
 static int sysctl_panic_print_handler(const struct ctl_table *table, int write,
 			   void *buffer, size_t *lenp, loff_t *ppos)
 {
-	panic_print_deprecated();
+	if (write)
+		panic_print_deprecated();
 	return proc_doulongvec_minmax(table, write, buffer, lenp, ppos);
 }
 
@@ -1014,7 +1015,6 @@ static int panic_print_set(const char *v
 
 static int panic_print_get(char *val, const struct kernel_param *kp)
 {
-	panic_print_deprecated();
 	return  param_get_ulong(val, kp);
 }
 
_

Patches currently in -mm which might be from gal@nvidia.com are


