Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F237153565;
	Sat,  1 Feb 2025 11:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738410844; cv=none; b=gyw9AYn219xk0lZNy4O2X2ELJTtRETNwzQE4KOBkxQvU145u3HYlV6s48rTHeUoyM8dZnlMaqcYulEg132rNsslI3O6KM3B0n34siTURXi4hPq9qUtFFf65Vy6LorQJTLs0oFR83fEX9LF1afN5fjTdtXFMzvxXhKg8qruwUwS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738410844; c=relaxed/simple;
	bh=98BZOki32toT1tf6uxmK12RprrZPSDsrvPQxRW7Zorg=;
	h=Date:To:From:Subject:Message-Id; b=NVGxaLklL9Pu6Vf3aNDXhRgLFgQaHg/MDrdbpofkm/q8DRqqyoCMYB3A2RYG0phMPWQxM9IcD7xci7NgXp1XxUK65LOpeDdWbXZMSeDes8aMLQNUPpcMJpVcPD/TxtHkubwdrA7krLQ1Vf9HZHcEO7ZbqB41zFZqJGOFDn4GD74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ztFpVMJM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ztFpVMJM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC910C4CED3;
	Sat,  1 Feb 2025 11:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738410843;
	bh=98BZOki32toT1tf6uxmK12RprrZPSDsrvPQxRW7Zorg=;
	h=Date:To:From:Subject:From;
	b=ztFpVMJMQSvjMwP6RJ9TC4ktmsCVKSOjnxEBaX1y8xerAZV72Gy0sfkQ/T0vaEqRn
	 O6LoI0kTU+5s8mgTiJoaXPuXjJgoyZSlqjiNbjsNUL+kILguUg8cwo4Rlb6WsL1ci+
	 jly3We4zaBQB2vTWKsmr2HGrFFtQ9wdt9LIZm+dg=
Date: Sat, 01 Feb 2025 03:54:03 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,kbingham@kernel.org,baohua@kernel.org,jan.kiszka@siemens.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] scripts-gdb-fix-aarch64-userspace-detection-in-get_current_task.patch removed from -mm tree
Message-Id: <20250201115403.BC910C4CED3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: scripts/gdb: fix aarch64 userspace detection in get_current_task
has been removed from the -mm tree.  Its filename was
     scripts-gdb-fix-aarch64-userspace-detection-in-get_current_task.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jan Kiszka <jan.kiszka@siemens.com>
Subject: scripts/gdb: fix aarch64 userspace detection in get_current_task
Date: Fri, 10 Jan 2025 11:36:33 +0100

At least recent gdb releases (seen with 14.2) return SP_EL0 as signed long
which lets the right-shift always return 0.

Link: https://lkml.kernel.org/r/dcd2fabc-9131-4b48-8419-6444e2d67454@siemens.com
Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/cpus.py |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/gdb/linux/cpus.py~scripts-gdb-fix-aarch64-userspace-detection-in-get_current_task
+++ a/scripts/gdb/linux/cpus.py
@@ -167,7 +167,7 @@ def get_current_task(cpu):
             var_ptr = gdb.parse_and_eval("&pcpu_hot.current_task")
             return per_cpu(var_ptr, cpu).dereference()
     elif utils.is_target_arch("aarch64"):
-        current_task_addr = gdb.parse_and_eval("$SP_EL0")
+        current_task_addr = gdb.parse_and_eval("(unsigned long)$SP_EL0")
         if (current_task_addr >> 63) != 0:
             current_task = current_task_addr.cast(task_ptr_type)
             return current_task.dereference()
_

Patches currently in -mm which might be from jan.kiszka@siemens.com are


