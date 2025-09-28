Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25DBA216E1B
	for <mm-commits@vger.kernel.org>; Sun, 28 Sep 2025 18:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759084638; cv=none; b=stRMKhPGBfTvsl3GKPsT/TQ0iC8XOlUbb32rLzWDHkNDVD0L8v2TUcdLtnVSs6TNghA0jSZsJFePXjRpNR68rZFs7GOXTK1solDGc2tt+BNKl9Vl7sgy1btERgyS791jZYcv2Im/sl92tgHC6g947z2fCUSy0NU4nLZUqvZiiXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759084638; c=relaxed/simple;
	bh=iElNLh2P5JvondGMk5GL6EPSu/ECWLu2NQWDXLAfj08=;
	h=Date:To:From:Subject:Message-Id; b=UYz+p85bUvtbkKNYfoZQ0yjBrV7MSBcxHHVLA0mFPUtDrpXLDwy8GXYEL28tLLyn6Q8tcgDpwDYcp0uR0qveyqG1owk97qQPilfBzU/GTX8fyi24jtJAOZtk/KPzNZ/ZyTCmUO1/fejAWAzDCIJUp+3In+sOKFu9td7fxdr3nck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2Ig2RUmW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2Ig2RUmW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D28DC4CEF0;
	Sun, 28 Sep 2025 18:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759084636;
	bh=iElNLh2P5JvondGMk5GL6EPSu/ECWLu2NQWDXLAfj08=;
	h=Date:To:From:Subject:From;
	b=2Ig2RUmWvCbiI7zWF1i6gsEGQ1D39q/S+/zM5NVHgzi1+JYYKJs8DrHcLio8xOYha
	 BPaxuXnabA82nXWfFPFqvy/FcNDk9Y7mMRi85XYIEMCoaWZFLCzuYFKT5f+Ijz0++q
	 DwzMF/40nux5My7xa3e68AML4ywjTB3ZghbIom7s=
Date: Sun, 28 Sep 2025 11:37:16 -0700
To: mm-commits@vger.kernel.org,johannes.berg@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] panic-remove-config_panic_on_oops_value.patch removed from -mm tree
Message-Id: <20250928183716.9D28DC4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: panic: remove CONFIG_PANIC_ON_OOPS_VALUE
has been removed from the -mm tree.  Its filename was
     panic-remove-config_panic_on_oops_value.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Johannes Berg <johannes.berg@intel.com>
Subject: panic: remove CONFIG_PANIC_ON_OOPS_VALUE
Date: Wed, 24 Sep 2025 11:43:04 +0200

There's really no need for this since it's 0 or 1 when
CONFIG_PANIC_ON_OOPS is disabled/enabled, so just use IS_ENABLED()
instead.  The extra symbol goes back to the original code adding it in
commit 2a01bb3885c9 ("panic: Make panic_on_oops configurable").

Link: https://lkml.kernel.org/r/20250924094303.18521-2-johannes@sipsolutions.net
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c    |    2 +-
 lib/Kconfig.debug |    6 ------
 2 files changed, 1 insertion(+), 7 deletions(-)

--- a/kernel/panic.c~panic-remove-config_panic_on_oops_value
+++ a/kernel/panic.c
@@ -53,7 +53,7 @@ static unsigned int __read_mostly sysctl
 #define sysctl_oops_all_cpu_backtrace 0
 #endif /* CONFIG_SMP */
 
-int panic_on_oops = CONFIG_PANIC_ON_OOPS_VALUE;
+int panic_on_oops = IS_ENABLED(CONFIG_PANIC_ON_OOPS);
 static unsigned long tainted_mask =
 	IS_ENABLED(CONFIG_RANDSTRUCT) ? (1 << TAINT_RANDSTRUCT) : 0;
 static int pause_on_oops;
--- a/lib/Kconfig.debug~panic-remove-config_panic_on_oops_value
+++ a/lib/Kconfig.debug
@@ -1067,12 +1067,6 @@ config PANIC_ON_OOPS
 
 	  Say N if unsure.
 
-config PANIC_ON_OOPS_VALUE
-	int
-	range 0 1
-	default 0 if !PANIC_ON_OOPS
-	default 1 if PANIC_ON_OOPS
-
 config PANIC_TIMEOUT
 	int "panic timeout"
 	default 0
_

Patches currently in -mm which might be from johannes.berg@intel.com are


