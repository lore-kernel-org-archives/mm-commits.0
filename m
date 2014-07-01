From: akpm@linux-foundation.org
Subject: +
 scripts-tagssh-include-compat_sys_-symbols-in-the-generated-tags.patch
 added to -mm tree
Date: Tue, 01 Jul 2014 14:57:39 -0700
Message-ID: <53b32ed3.7MEjT1JS9hmiJ0lN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pd0-f201.google.com ([209.85.192.201]:32900 "EHLO
	mail-pd0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951AbaGAV5k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jul 2014 17:57:40 -0400
Received: by mail-pd0-f201.google.com with SMTP id v10so1717740pde.2
        for <mm-commits@vger.kernel.org>; Tue, 01 Jul 2014 14:57:40 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: catalin.marinas@arm.com, mmarek@suse.cz, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/tags.sh: include compat_sys_* symbols in the generated tags
has been added to the -mm tree.  Its filename is
     scripts-tagssh-include-compat_sys_-symbols-in-the-generated-tags.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-tagssh-include-compat_sys_-symbols-in-the-generated-tags.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-tagssh-include-compat_sys_-symbols-in-the-generated-tags.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-page_alloc-fix-cma-area-initialisation-when-pageblock-max_order.patch
scripts-tagssh-include-compat_sys_-symbols-in-the-generated-tags.patch

