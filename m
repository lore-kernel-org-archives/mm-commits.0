Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5B6A3EBF29
	for <mm-commits@vger.kernel.org>; Sun,  1 Feb 2026 00:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769904823; cv=none; b=ecD9jFrd77RCKsOPYiEyGR9KHupw85C9D4ValGKx+WZFS+E7SfgloE0iCeihysIPz1o4HP7UCBrKBj7ER23gcUnG2AQjWCMPjyKbfpdcAuWJuESx/MSZuvwGrjRGweZnNL42+LWQBnU6a7oBaIa4mf8sXT90uLGL5P5JAfOMfdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769904823; c=relaxed/simple;
	bh=Q9fonHscF+XjqKqyQj3YevUxInQv9gJNvDEA7WXzRlE=;
	h=Date:To:From:Subject:Message-Id; b=gzIlJ0a1U6vR2S7EFfuu7MuefGFpxenLTHbbF8z/+CCQgaShLCGbh+Gv8QPGI5sqTgAlq5tHaWKqrTBLgvpf5GtqKFJBXp/TqQIYqBqm6o5C5zpDBAyRXLpvZR8PoS8BevT8AYYQB2r+HHzPzz0Gx9a7bB9M/17eSrJn02OfI7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MLkfNn9d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MLkfNn9d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1087CC4CEF1;
	Sun,  1 Feb 2026 00:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769904823;
	bh=Q9fonHscF+XjqKqyQj3YevUxInQv9gJNvDEA7WXzRlE=;
	h=Date:To:From:Subject:From;
	b=MLkfNn9d7SsvQfE7TtSuJh/ZHC7k5VScVpcAMyIi8xR33WTgCp4+ItDup7yuxgTOe
	 KhsEaCMo9N48XzkL4IkzbBh5t7vOL3ShGSVmfeuiIK732s5erDSyDRxw4FZKCdyH36
	 viHf3LpkaJc72CwH1r7LDvSZN/RLun4ezZJDFvaw=
Date: Sat, 31 Jan 2026 16:13:42 -0800
To: mm-commits@vger.kernel.org,lkp@intel.com,pnina.feder@mobileye.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] panic-add-panic_force_cpu=-parameter-to-redirect-panic-to-a-specific-cpu-fix.patch removed from -mm tree
Message-Id: <20260201001343.1087CC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: panic: fix unused variable warning when SMP or CRASH_DUMP disabled
has been removed from the -mm tree.  Its filename was
     panic-add-panic_force_cpu=-parameter-to-redirect-panic-to-a-specific-cpu-fix.patch

This patch was dropped because it was folded into panic-add-panic_force_cpu=-parameter-to-redirect-panic-to-a-specific-cpu.patch

------------------------------------------------------
From: Pnina Feder <pnina.feder@mobileye.com>
Subject: panic: fix unused variable warning when SMP or CRASH_DUMP disabled
Date: Mon, 26 Jan 2026 14:26:18 +0200

Move panic_force_buf inside the #ifdef block to fix unused variable
warning when CONFIG_SMP or CONFIG_CRASH_DUMP is not enabled.

Link: https://lkml.kernel.org/r/20260126122618.2967950-1-pnina.feder@mobileye.com
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202601222042.OSZryOnl-lkp@intel.com/
Closes: https://lore.kernel.org/oe-kbuild-all/202601230908.0vB3SoHM-lkp@intel.com/
Closes: https://lore.kernel.org/oe-kbuild-all/202601231058.Q6hDGfoT-lkp@intel.com/
Signed-off-by: Pnina Feder <pnina.feder@mobileye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/panic.c~panic-add-panic_force_cpu=-parameter-to-redirect-panic-to-a-specific-cpu-fix
+++ a/kernel/panic.c
@@ -76,7 +76,6 @@ EXPORT_SYMBOL_GPL(panic_timeout);
 unsigned long panic_print;
 
 static int panic_force_cpu = -1;
-static char *panic_force_buf;
 
 ATOMIC_NOTIFIER_HEAD(panic_notifier_list);
 
@@ -307,6 +306,8 @@ atomic_t panic_cpu = ATOMIC_INIT(PANIC_C
 atomic_t panic_redirect_cpu = ATOMIC_INIT(PANIC_CPU_INVALID);
 
 #if defined(CONFIG_SMP) && defined(CONFIG_CRASH_DUMP)
+static char *panic_force_buf;
+
 static int __init panic_force_cpu_setup(char *str)
 {
 	int cpu;
_

Patches currently in -mm which might be from pnina.feder@mobileye.com are

panic-add-panic_force_cpu=-parameter-to-redirect-panic-to-a-specific-cpu.patch

