Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9B9B33F6
	for <mm-commits@vger.kernel.org>; Thu, 21 Aug 2025 00:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755736430; cv=none; b=SNIE+T4NY7/7JmMPZCwBmbBBF+h+x7HtpBO34PtHskVHUQjrRUtdOZfyg0EcXzTXC91aOk4zj4n82DZnyeCuA2onH5QYi2xBhIkQ2Ita+8KH5cJjpmYzKePkd2wqEuJDlC7QHIR0S4rIcPDoi1aiCocwtpKFahcFurojxU8PkzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755736430; c=relaxed/simple;
	bh=Fm8vsQma20Q9vJtAPhKaxtGW2hTFfSgv58fGWFBObu8=;
	h=Date:To:From:Subject:Message-Id; b=mqs02swb/fNxGDF3k5N4AD/PIHc8/NmPZSA/uOikcvc/cViH8dYES6zSTB2EI6OWBmJzdVwXb4JYf8qYbGCaGXEULxc6i8F3924B0YNqEEg/nXULpf47ljheqLCX7gyYewSFJxzQ3oLNrbocg63bKvrkmtHZawjvDtkrQDASStI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zPNad22M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zPNad22M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3396EC4CEE7;
	Thu, 21 Aug 2025 00:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755736430;
	bh=Fm8vsQma20Q9vJtAPhKaxtGW2hTFfSgv58fGWFBObu8=;
	h=Date:To:From:Subject:From;
	b=zPNad22MtKvYgjarBmzhN5dsEH1LpcqavDkQvzE6oci2JUSoIlf9oZTIUdhD/odOH
	 xFpNStThPAmTEHPQztaid057WIGtrRfzP8xOxVGRsnQGak50BmeW7RenFSAuW1+nhf
	 pu8qggOcKbLKmgGhWRAPbkn5otRaZnmiLLTBLbKM=
Date: Wed, 20 Aug 2025 17:33:49 -0700
To: mm-commits@vger.kernel.org,pmladek@suse.com,lkp@intel.com,lance.yang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] panic-add-note-that-panic_print-parameter-is-deprecated-fix-fix.patch removed from -mm tree
Message-Id: <20250821003350.3396EC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fixup: panic: clean up message about deprecated 'panic_print' parameter
has been removed from the -mm tree.  Its filename was
     panic-add-note-that-panic_print-parameter-is-deprecated-fix-fix.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Lance Yang <lance.yang@linux.dev>
Subject: fixup: panic: clean up message about deprecated 'panic_print' parameter
Date: Wed, 20 Aug 2025 11:25:31 +0200

fix build

Link: https://lkml.kernel.org/r/aKWWcPOf9qPIoCe4@pathway.suse.cz
Signed-off-by: Lance Yang <lance.yang@linux.dev>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202508200907.PsZ3geub-lkp@intel.com/
Reviewed-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/kernel/panic.c~panic-add-note-that-panic_print-parameter-is-deprecated-fix-fix
+++ a/kernel/panic.c
@@ -77,6 +77,11 @@ ATOMIC_NOTIFIER_HEAD(panic_notifier_list
 
 EXPORT_SYMBOL(panic_notifier_list);
 
+static void panic_print_deprecated(void)
+{
+	pr_info_once("Kernel: The 'panic_print' parameter is now deprecated. Please use 'panic_sys_info' and 'panic_console_replay' instead.\n");
+}
+
 #ifdef CONFIG_SYSCTL
 
 /*
@@ -122,11 +127,6 @@ static int proc_taint(const struct ctl_t
 	return err;
 }
 
-static void panic_print_deprecated(void)
-{
-	pr_info_once("Kernel: The 'panic_print' parameter is now deprecated. Please use 'panic_sys_info' and 'panic_console_replay' instead.\n");
-}
-
 static int sysctl_panic_print_handler(const struct ctl_table *table, int write,
 			   void *buffer, size_t *lenp, loff_t *ppos)
 {
_

Patches currently in -mm which might be from lance.yang@linux.dev are


