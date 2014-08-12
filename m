From: akpm@linux-foundation.org
Subject: [merged]
 scripts-tagssh-include-compat_sys_-symbols-in-the-generated-tags.patch
 removed from -mm tree
Date: Tue, 12 Aug 2014 12:41:44 -0700
Message-ID: <53ea6df8.IK8r58+ADFOq/5a9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:42542 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755080AbaHLTlp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:41:45 -0400
Received: by mail-yh0-f74.google.com with SMTP id 29so1307897yhl.1
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:41:44 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: catalin.marinas@arm.com, mmarek@suse.cz, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/tags.sh: include compat_sys_* symbols in the generated tags
has been removed from the -mm tree.  Its filename was
     scripts-tagssh-include-compat_sys_-symbols-in-the-generated-tags.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Catalin Marinas <catalin.marinas@arm.com>
Subject: scripts/tags.sh: include compat_sys_* symbols in the generated tags

Since the kernel now has a COMPAT_SYSCALL infrastructure via commit
468366138850f ("COMPAT_SYSCALL_DEFINE: infrastructure"), add the
corresponding regex for generating compat_sys_* symbols in the tags files
(similar to sys_*).

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/tags.sh |    2 ++
 1 file changed, 2 insertions(+)

diff -puN scripts/tags.sh~scripts-tagssh-include-compat_sys_-symbols-in-the-generated-tags scripts/tags.sh
--- a/scripts/tags.sh~scripts-tagssh-include-compat_sys_-symbols-in-the-generated-tags
+++ a/scripts/tags.sh
@@ -168,6 +168,7 @@ exuberant()
 	--extra=+f --c-kinds=+px                                \
 	--regex-asm='/^(ENTRY|_GLOBAL)\(([^)]*)\).*/\2/'        \
 	--regex-c='/^SYSCALL_DEFINE[[:digit:]]?\(([^,)]*).*/sys_\1/' \
+	--regex-c='/^COMPAT_SYSCALL_DEFINE[[:digit:]]?\(([^,)]*).*/compat_sys_\1/' \
 	--regex-c++='/^TRACE_EVENT\(([^,)]*).*/trace_\1/'		\
 	--regex-c++='/^DEFINE_EVENT\([^,)]*, *([^,)]*).*/trace_\1/'	\
 	--regex-c++='/PAGEFLAG\(([^,)]*).*/Page\1/'			\
@@ -231,6 +232,7 @@ emacs()
 	all_target_sources | xargs $1 -a                        \
 	--regex='/^\(ENTRY\|_GLOBAL\)(\([^)]*\)).*/\2/'         \
 	--regex='/^SYSCALL_DEFINE[0-9]?(\([^,)]*\).*/sys_\1/'   \
+	--regex='/^COMPAT_SYSCALL_DEFINE[0-9]?(\([^,)]*\).*/compat_sys_\1/' \
 	--regex='/^TRACE_EVENT(\([^,)]*\).*/trace_\1/'		\
 	--regex='/^DEFINE_EVENT([^,)]*, *\([^,)]*\).*/trace_\1/' \
 	--regex='/PAGEFLAG(\([^,)]*\).*/Page\1/'			\
_

Patches currently in -mm which might be from catalin.marinas@arm.com are

origin.patch

