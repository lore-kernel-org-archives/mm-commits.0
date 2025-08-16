Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BAF8222597
	for <mm-commits@vger.kernel.org>; Sat, 16 Aug 2025 07:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755328512; cv=none; b=QCnYtLFFMLMB7F7k7JcggEvv+BezF6hlEUeeQc1sM1Nmf2aTxzvCh7lr4mY/l4T0IbXDw7sK2z/aBPkFoZyQKrz9Y0WJHP75gaHH3yvTyygKs62F3sSdUeoN79pNH25gQFEm+2egs1wY84LVsdR4cXHRyuKgnEO9AC/4503GG7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755328512; c=relaxed/simple;
	bh=3+vjo/xfqHyohuvSWyIfDdCkH9bc+aLE/EPl08QTRvE=;
	h=Date:To:From:Subject:Message-Id; b=M76ef1qwimMUD5/6n5IG4iyFSb4c3MkhQ/rcNaUn+OPpFSWyQTuZIvhZd65lfRK23TWNAQVdU51xqkUSFV0kNkQoLJnNSdOUBQp3Z1uu2VbZXDEWDD8Al6C3+zQxInb+SBQZifIG+CBdo+hPLpgGMOcEy3fdFN7iXJOGdfJBhrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sSupynt/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sSupynt/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B47E3C4CEEF;
	Sat, 16 Aug 2025 07:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755328511;
	bh=3+vjo/xfqHyohuvSWyIfDdCkH9bc+aLE/EPl08QTRvE=;
	h=Date:To:From:Subject:From;
	b=sSupynt/+jDbIY8CXCSY2WhBGH/PTrr+jUD+6tnYCktgG+yjhh/KxGE/cacluomBW
	 qio9LBG7uwZfB+Qk9GI6mfy+c+If5o2QOMGk3ATxp4p/K6Fl4n3Ft74AhoSE/liTOy
	 NmXQkwNozyjDcg1CV8/9F6NFO/O4hHwhdhwUtVPw=
Date: Sat, 16 Aug 2025 00:15:11 -0700
To: mm-commits@vger.kernel.org,safinaskar@zohomail.com,rostedt@goodmis.org,pmladek@suse.com,paulmck@kernel.org,lance.yang@linux.dev,john.ogness@linutronix.de,corbet@lwn.net,feng.tang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-sys_info-handle-sys_info_mask==0-case.patch added to mm-nonmm-unstable branch
Message-Id: <20250816071511.B47E3C4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/sys_info: handle sys_info_mask==0 case
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-sys_info-handle-sys_info_mask==0-case.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-sys_info-handle-sys_info_mask==0-case.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Feng Tang <feng.tang@linux.alibaba.com>
Subject: lib/sys_info: handle sys_info_mask==0 case
Date: Fri, 15 Aug 2025 15:14:26 +0800

Patch series "follow up patches for panic_print's generalization".

Generalization of panic_print's dump function has been merged [1], and
this patchset is to address some remaining issues, like adding note of the
obsoletion of 'panic_print' cmdline parameter, refining the kernel
document for panic_print, and hardening some string management.


This patch (of 3):

It is a normal case that bitmask parameter is 0, so pre-initialize the
names[] to null string to cover this case.

Also remove the superfluous "+1" in names[sizeof(sys_info_avail) + 1],
which is needed for 'strlen()', but not for 'sizeof()'.

Link: https://lkml.kernel.org/r/20250815071428.98041-1-feng.tang@linux.alibaba.com
Link: https://lkml.kernel.org/r/20250815071428.98041-2-feng.tang@linux.alibaba.com
Link: https://lkml.kernel.org/r/20250703021004.42328-1-feng.tang@linux.alibaba.com [1]
Signed-off-by: Feng Tang <feng.tang@linux.alibaba.com>
Suggested-by: Petr Mladek <pmladek@suse.com>
Cc: John Ogness <john.ogness@linutronix.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Askar Safin <safinaskar@zohomail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/sys_info.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/lib/sys_info.c~lib-sys_info-handle-sys_info_mask==0-case
+++ a/lib/sys_info.c
@@ -55,7 +55,7 @@ int sysctl_sys_info_handler(const struct
 					  void *buffer, size_t *lenp,
 					  loff_t *ppos)
 {
-	char names[sizeof(sys_info_avail) + 1];
+	char names[sizeof(sys_info_avail)];
 	struct ctl_table table;
 	unsigned long *si_bits_global;
 
@@ -81,6 +81,9 @@ int sysctl_sys_info_handler(const struct
 		char *delim = "";
 		int i, len = 0;
 
+		/* *si_bits_glabl could be 0 */
+		names[0] = '\0';
+
 		for (i = 0; i < ARRAY_SIZE(si_names); i++) {
 			if (*si_bits_global & si_names[i].bit) {
 				len += scnprintf(names + len, sizeof(names) - len,
_

Patches currently in -mm which might be from feng.tang@linux.alibaba.com are

lib-sys_info-handle-sys_info_mask==0-case.patch
panic-refine-the-document-for-panic_print.patch
panic-add-note-that-panic_print-parameter-is-deprecated.patch

