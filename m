Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11AAA2747F
	for <mm-commits@vger.kernel.org>; Mon, 18 Mar 2024 20:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710794959; cv=none; b=az0fW4sEmuopQ6dTp4hA0aup79f/wvuIivCU2nycy52hj57eALPkfoRoaSPdZd0g4/tmGT4YfVM8zav37esTWLWFo0YNGrp/xPTKadXX5QPccp/rV6hGSYPFaX2kTt85s+mqT1MlG/uIgvgNsjWU7tYdYb/Swkb0mzqbXwvei8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710794959; c=relaxed/simple;
	bh=iUE40ZcJWBVAGVtYrPFnM80NRZnzhGKLsM8IoMWRyDM=;
	h=Date:To:From:Subject:Message-Id; b=pSQi7oOot1ACsN6JHArckKGjInTQXZm17Hlt1W26+2v96uD63Uof/i1Slb97/zHLKdLYj8BFNdNv27EMWm3d9KJw/mcDoCtGe3F9kBD4JSElPan2hqRKEcerHNRp/K4Ukqm2+ASVv+ViYdSjjdwPru7f+HRm+xUz6/Y5Z6Nm6eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Gwri5HPM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Gwri5HPM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA5EBC433C7;
	Mon, 18 Mar 2024 20:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1710794958;
	bh=iUE40ZcJWBVAGVtYrPFnM80NRZnzhGKLsM8IoMWRyDM=;
	h=Date:To:From:Subject:From;
	b=Gwri5HPMmFMU9RSUFZpqBxO9zNLtVpjVSVFG0+UugZOZZtzOWsZPpQg6Efc6BmizX
	 6JTh2KBwP0I6W+8tBVu5wfqbxVhl5j9idi5VbTLql8pGfYOUWK3rvp6y7XQyg9ROXw
	 C7stCd9Pc4hpGo3bsNgbGJB0M/8KNwGnqfIh71Mo=
Date: Mon, 18 Mar 2024 13:49:18 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,joey.gouly@arm.com,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-restore-settings-from-only-parent-process.patch added to mm-hotfixes-unstable branch
Message-Id: <20240318204918.AA5EBC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests: mm: restore settings from only parent process
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-mm-restore-settings-from-only-parent-process.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-restore-settings-from-only-parent-process.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
Subject: selftests: mm: restore settings from only parent process
Date: Thu, 14 Mar 2024 14:40:45 +0500

The atexit() is called from parent process as well as forked processes. 
Hence the child restores the settings at exit while the parent is still
executing.  Fix this by checking pid of atexit() calling process and only
restore THP number from parent process.

Link: https://lkml.kernel.org/r/20240314094045.157149-1-usama.anjum@collabora.com
Fixes: c23ea61726d5 ("selftests/mm: protection_keys: save/restore nr_hugepages settings")
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Tested-by: Joey Gouly <joey.gouly@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/protection_keys.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/protection_keys.c~selftests-mm-restore-settings-from-only-parent-process
+++ a/tools/testing/selftests/mm/protection_keys.c
@@ -1745,9 +1745,12 @@ void pkey_setup_shadow(void)
 	shadow_pkey_reg = __read_pkey_reg();
 }
 
+pid_t parent_pid;
+
 void restore_settings_atexit(void)
 {
-	cat_into_file(buf, "/proc/sys/vm/nr_hugepages");
+	if (parent_pid == getpid())
+		cat_into_file(buf, "/proc/sys/vm/nr_hugepages");
 }
 
 void save_settings(void)
@@ -1773,6 +1776,7 @@ void save_settings(void)
 		exit(__LINE__);
 	}
 
+	parent_pid = getpid();
 	atexit(restore_settings_atexit);
 	close(fd);
 }
_

Patches currently in -mm which might be from usama.anjum@collabora.com are

selftests-mm-restore-settings-from-only-parent-process.patch

