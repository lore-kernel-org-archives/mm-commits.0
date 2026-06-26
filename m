Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 741FA3DB62F;
	Fri, 26 Jun 2026 16:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782492650; cv=none; b=Wp1DoVu1kkeubmbW8kiz6FXmGww75ovX9/wxSphOurjGBa4XYqy2JzbSC/UGQeNUKJNvzYyszIVxY6mIBmVqKgO+RhZY3wyxmMAUgtjv+uaVuZ3etTOBmrTW6nUcz0gxlIMX2z6Fu33V1WIk40tOXhwXsCWRcH+nfjOMTez/pWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782492650; c=relaxed/simple;
	bh=Zu+Ko0ksgxTt/9Qecq3HRBVRvTLWID+eHA4qqOifSVA=;
	h=Date:To:From:Subject:Message-Id; b=HkXWk5H4tX4CE0a4Rg5GcKPVBiqnfN4t6iZLpXOX1dJ/AoXh4ZK+0AXH6uCO6gqipU7KLMJrHHWOyN7RUeZZxKHm8Ekbrt32VF6aJB+CrwsTMTRuKoc0yGHydakZFTe21BEdgu///CL2mUUTz8Ob5+qUNjA/1eeccHvKqIfUJeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bYW2c3v9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bYW2c3v9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DB611F000E9;
	Fri, 26 Jun 2026 16:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782492643;
	bh=q+vO4NWNkVOuXNXsWxVR2ZkS9bl0odpcrBbAClMZG5c=;
	h=Date:To:From:Subject;
	b=bYW2c3v9LpfYKIdJPhr+s4xWKckowZfKFTNXxQHCEB9sn0f726R75ab92Jm6E8Qf8
	 3erHYDSSODWHVwARUVzeV9NFTqB+zHGfPuYsnT7eb5GIfOZF/7QVnT7p2BGOIT24lW
	 oSAdAbLFcDSykRu996nfJImXf2meM+0ec63xNtiA=
Date: Fri, 26 Jun 2026 09:50:43 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,pmladek@suse.com,npiggin@gmail.com,mpe@ellerman.id.au,maddy@linux.ibm.com,dianders@chromium.org,include@grrlz.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] sys_info-add-helper-for-callers-that-print-some-sys_info-on-their-own.patch removed from -mm tree
Message-Id: <20260626165043.8DB611F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: sys_info: add helper for callers that print some sys_info on their own
has been removed from the -mm tree.  Its filename was
     sys_info-add-helper-for-callers-that-print-some-sys_info-on-their-own.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Bradley Morgan <include@grrlz.net>
Subject: sys_info: add helper for callers that print some sys_info on their own
Date: Thu, 25 Jun 2026 15:25:55 +0000

Patch series "sys_info: prevent duplicate backtraces", v3.

Some callers handle SYS_INFO_ALL_BT themselves before calling sys_info().
When they strip that bit, an all_bt-only mask becomes zero and sys_info(0)
falls back to kernel_si_mask, potentially duplicating output.

This series adds sys_info_with_filter() to filter specific bits without
triggering the kernel_si_mask fallback.


This patch (of 4):

Some callers print some sys_info on their own before calling sys_info().

Add a helper which would allow to prevent a duplicated output.

It is a bit tricky because kernel_si_mask should be used only when the
call-specific si_mask is empty.  But the duplicated output must be
prevented there as well.

Link: https://lore.kernel.org/20260625152558.7450-1-include@grrlz.net
Link: https://lore.kernel.org/20260625152558.7450-2-include@grrlz.net
Fixes: a9af76a78760 ("watchdog: add sys_info sysctls to dump sys info on system lockup")
Signed-off-by: Bradley Morgan <include@grrlz.net>
Suggested-by: Petr Mladek <pmladek@suse.com>
Cc: Doug Anderson <dianders@chromium.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sys_info.h |    1 +
 lib/sys_info.c           |   20 ++++++++++++++++++--
 2 files changed, 19 insertions(+), 2 deletions(-)

--- a/include/linux/sys_info.h~sys_info-add-helper-for-callers-that-print-some-sys_info-on-their-own
+++ a/include/linux/sys_info.h
@@ -18,6 +18,7 @@
 #define SYS_INFO_BLOCKED_TASKS		0x00000080
 
 void sys_info(unsigned long si_mask);
+void sys_info_with_filter(unsigned long si_mask, unsigned long si_ignore_mask);
 unsigned long sys_info_parse_param(char *str);
 
 #ifdef CONFIG_SYSCTL
--- a/lib/sys_info.c~sys_info-add-helper-for-callers-that-print-some-sys_info-on-their-own
+++ a/lib/sys_info.c
@@ -136,8 +136,10 @@ static int __init sys_info_sysctl_init(v
 subsys_initcall(sys_info_sysctl_init);
 #endif
 
-static void __sys_info(unsigned long si_mask)
+static void __sys_info(unsigned long si_mask, unsigned long si_ignore_mask)
 {
+	si_mask &= ~si_ignore_mask;
+
 	if (si_mask & SYS_INFO_TASKS)
 		show_state();
 
@@ -160,7 +162,21 @@ static void __sys_info(unsigned long si_
 		show_state_filter(TASK_UNINTERRUPTIBLE);
 }
 
+void sys_info_with_filter(unsigned long si_mask, unsigned long si_ignore_mask)
+{
+	unsigned long dump_mask = si_mask & ~si_ignore_mask;
+
+	/*
+	 * Do not fall back to kernel_si_mask when the caller context
+	 * required only the ignored information.
+	 */
+	if (si_mask && !dump_mask)
+		return;
+
+	__sys_info(dump_mask ? : kernel_si_mask, si_ignore_mask);
+}
+
 void sys_info(unsigned long si_mask)
 {
-	__sys_info(si_mask ? : kernel_si_mask);
+	sys_info_with_filter(si_mask, 0);
 }
_

Patches currently in -mm which might be from include@grrlz.net are

watchdog-use-sys_info_with_filter-to-avoid-duplicate-backtraces.patch
powerpc-watchdog-use-sys_info_with_filter-to-avoid-duplicate-backtraces.patch
panic-use-sys_info_with_filter-to-avoid-duplicate-backtraces.patch
lib-string-fix-memchr_inv-for-large-ranges.patch

