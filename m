Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A36D91632C8
	for <mm-commits@vger.kernel.org>; Thu,  3 Apr 2025 21:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743716094; cv=none; b=UVlPbPM7jN9aP2o0/OeGDh1JZhWmA987vX6Q+oQxyoRCxqAea//xsIH7sBYd0jAaL/VS4hj1EFQSBrfgAJ9gy5W1576/y33Ede0BAbUWedD6sKCEByJ0y5cEqsD0dvv4O4FpO5JgxrAHjcdRPDBJrWDahu/K/I4rJEEtwa1KLlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743716094; c=relaxed/simple;
	bh=v8oCNDQ2pp+7bR3tfeYsnJjtf7qRToNSr7Trr/TTG3I=;
	h=Date:To:From:Subject:Message-Id; b=ne3Qeq+6wyNat9ht0oOFuQFZ+chKXhdVEMS5iJjKR/sd6IpVbedtoAwChuSczZOIuOMTBO68KK+i+cuFLvhAwDSoUTJ499BC4aL6bcVdI6hPQbOfhoUlVSXCEXbzNs5gwuPO13oj+JO5+RnxgSG9XlaYQuQiUMyeERdS+rtfmds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pM2i876s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pM2i876s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 101AFC4CEE3;
	Thu,  3 Apr 2025 21:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743716093;
	bh=v8oCNDQ2pp+7bR3tfeYsnJjtf7qRToNSr7Trr/TTG3I=;
	h=Date:To:From:Subject:From;
	b=pM2i876sbwEqI/ipuOf0ICdK9PPF+4dbUcoYij2XQhXKMJR5zfxhWYxcjrid11C2J
	 Vq81+bmBgFWPjIju93kIZnnR3QjFQL//ieFLyI7N6J0CKHKxmLES882wsUj7CtKmrm
	 9T6AHQljjfjfw6F/RjtxaGNV6nJevuXoHNpp82lQ=
Date: Thu, 03 Apr 2025 14:34:52 -0700
To: mm-commits@vger.kernel.org,tim.bird@sony.com,rostedt@goodmis.org,francesco@valla.it,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [withdrawn] init-mainc-log-initcall-level-when-initcall_debug-is-used-fix.patch removed from -mm tree
Message-Id: <20250403213453.101AFC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: init-mainc-log-initcall-level-when-initcall_debug-is-used-fix
has been removed from the -mm tree.  Its filename was
     init-mainc-log-initcall-level-when-initcall_debug-is-used-fix.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: init-mainc-log-initcall-level-when-initcall_debug-is-used-fix
Date: Wed Apr  2 07:54:29 PM PDT 2025

use pr_debug()

Cc: Francesco Valla <francesco@valla.it>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tim Bird <tim.bird@sony.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/init/main.c~init-mainc-log-initcall-level-when-initcall_debug-is-used-fix
+++ a/init/main.c
@@ -1217,7 +1217,7 @@ trace_initcall_finish_cb(void *data, ini
 static __init_or_module void
 trace_initcall_level_cb(void *data, const char *level)
 {
-	printk(KERN_DEBUG "entering initcall level: %s\n", level);
+	pr_debug("entering initcall level: %s\n", level);
 }
 
 static ktime_t initcall_calltime;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

radix-tree-add-missing-cleanuph-fix.patch

