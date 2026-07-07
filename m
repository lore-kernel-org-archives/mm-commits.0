Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E23493B27FE
	for <mm-commits@vger.kernel.org>; Tue,  7 Jul 2026 19:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783454247; cv=none; b=pr/m7VfyqRZwRZCmSVXWPdPfdtVxUUvaDHhjAva7yXExtcA4W5tRzrVRtAh+yidIU7feFMaQcCcmfHcD9lEqBNks3mAnmMod0XuunWRpO4okVC4C8z/ABBvDJs9vo3YGne7XNGHdZqmiIoRFnRsng6qGd4JyDf4CafNepb+MOvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783454247; c=relaxed/simple;
	bh=3RyfCQoeRAwc705w9TgCEFQFrLxPqjtInPJIh0vKeBc=;
	h=Date:To:From:Subject:Message-Id; b=PQudap4W0PGq3G7NZhdh+SZ5k4IeLXQV7ybsel4yjoF5egg2LxSw4XHOdHiA8d+KyT/p7cJSCCXLJr+T4AiyaKaklWCkjT8G55R5P69293ZcKyUglzSP5TBD9klJdizApkc8AMVo6zqReJ8DsQdgwPMEz+Aqzy9U4dGHakacqWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xpchjY1u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xpchjY1u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 759031F000E9;
	Tue,  7 Jul 2026 19:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783454245;
	bh=kmfBcuHZu2bUyLwU5WitkwGr/srIvWS0pbhmOW8sdlQ=;
	h=Date:To:From:Subject;
	b=xpchjY1uOLslZKCf2LTNynOD1L6EjCx19AzxnrxdLXWkHNLRqcIVs6otRREySvjof
	 gh9ayuGy7XDbJLu4HP1cWu++SwEugeJIsGEk28dQSCr/qR3msWFexa5zzO8NPGxyiC
	 vpD4ZeD5/6NQ05D2hTYqF1Db3FAC3zGr//2OEx7A=
Date: Tue, 07 Jul 2026 12:57:25 -0700
To: mm-commits@vger.kernel.org,kees@kernel.org,akpm@linux-foundation.org,include@grrlz.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + reboot-use-a-lookup-table-for-hw_protection_action-strings.patch added to mm-nonmm-unstable branch
Message-Id: <20260707195725.759031F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: reboot: use a lookup table for hw_protection_action strings
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     reboot-use-a-lookup-table-for-hw_protection_action-strings.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/reboot-use-a-lookup-table-for-hw_protection_action-strings.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Bradley Morgan <include@grrlz.net>
Subject: reboot: use a lookup table for hw_protection_action strings
Date: Tue, 7 Jul 2026 18:09:44 +0000

Replace the switch and if else chains with one table.

Link: https://lore.kernel.org/20260707180945.7781-1-include@grrlz.net
Signed-off-by: Bradley Morgan <include@grrlz.net>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Kees Cook <kees@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/reboot.c |   33 +++++++++++++++++++--------------
 1 file changed, 19 insertions(+), 14 deletions(-)

--- a/kernel/reboot.c~reboot-use-a-lookup-table-for-hw_protection_action-strings
+++ a/kernel/reboot.c
@@ -938,16 +938,18 @@ void orderly_reboot(void)
 }
 EXPORT_SYMBOL_GPL(orderly_reboot);
 
+/* DEFAULT is NULL: a sentinel, not a real action. */
+static const char *const hw_protection_action_strs[] = {
+	[HWPROT_ACT_SHUTDOWN] = "shutdown",
+	[HWPROT_ACT_REBOOT]   = "reboot",
+};
+
 static const char *hw_protection_action_str(enum hw_protection_action action)
 {
-	switch (action) {
-	case HWPROT_ACT_SHUTDOWN:
-		return "shutdown";
-	case HWPROT_ACT_REBOOT:
-		return "reboot";
-	default:
+	if (action >= ARRAY_SIZE(hw_protection_action_strs) ||
+	    !hw_protection_action_strs[action])
 		return "undefined";
-	}
+	return hw_protection_action_strs[action];
 }
 
 static enum hw_protection_action hw_failure_emergency_action;
@@ -1055,14 +1057,17 @@ EXPORT_SYMBOL_GPL(__hw_protection_trigge
 static bool hw_protection_action_parse(const char *str,
 				       enum hw_protection_action *action)
 {
-	if (sysfs_streq(str, "shutdown"))
-		*action = HWPROT_ACT_SHUTDOWN;
-	else if (sysfs_streq(str, "reboot"))
-		*action = HWPROT_ACT_REBOOT;
-	else
-		return false;
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(hw_protection_action_strs); i++) {
+		if (hw_protection_action_strs[i] &&
+		    sysfs_streq(str, hw_protection_action_strs[i])) {
+			*action = i;
+			return true;
+		}
+	}
 
-	return true;
+	return false;
 }
 
 static int __init hw_protection_setup(char *str)
_

Patches currently in -mm which might be from include@grrlz.net are

lib-string-fix-memchr_inv-for-large-ranges.patch
signal-avoid-shared-siginfo-namespace-rewrites.patch
panic-fix-va_list-reuse-in-panic_try_force_cpu.patch
reboot-use-lookup-tables-for-sysfs-mode-and-type-strings.patch
reboot-use-a-lookup-table-for-hw_protection_action-strings.patch

