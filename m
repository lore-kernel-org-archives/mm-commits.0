From: akpm@google.com
Subject: [merged] scripts-tagssh-update-to-support-powerpc-_global-symbols.patch removed from -mm tree
Date: Fri, 23 Sep 2011 13:12:06 -0700
Message-ID: <201109232012.p8NKC6MN016621@hpaq2.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:4515 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973Ab1IWUNE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 23 Sep 2011 16:13:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: imunsie@au1.ibm.com, benh@kernel.crashing.org, mmarek@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/tags.sh: update to support powerpc _GLOBAL symbols
has been removed from the -mm tree.  Its filename was
     scripts-tagssh-update-to-support-powerpc-_global-symbols.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Ian Munsie <imunsie@au1.ibm.com>
Subject: scripts/tags.sh: update to support powerpc _GLOBAL symbols

On PowerPC we use _GLOBAL throughout the assembly to define symbols, but
currently these symbols are missing from the tags generated with
ARCH=powerpc make tags.  This patch modifies the tags.sh script to
recognise _GLOBAL(.*) so that these symbols will be in the tags.

This is almost (but not quite) PowerPC specific and this change should
not affect anyone else:

$ git grep -E '^_GLOBAL\(([^)]*)\).*' |sed 's/^\([^/]*\/[^/]*\)\/.*$/\1/'|uniq -c
    627 arch/powerpc
      2 arch/um

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 scripts/tags.sh |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN scripts/tags.sh~scripts-tagssh-update-to-support-powerpc-_global-symbols scripts/tags.sh
--- a/scripts/tags.sh~scripts-tagssh-update-to-support-powerpc-_global-symbols
+++ a/scripts/tags.sh
@@ -129,7 +129,7 @@ exuberant()
 	-I EXPORT_SYMBOL,EXPORT_SYMBOL_GPL                      \
 	-I DEFINE_TRACE,EXPORT_TRACEPOINT_SYMBOL,EXPORT_TRACEPOINT_SYMBOL_GPL \
 	--extra=+f --c-kinds=+px                                \
-	--regex-asm='/^ENTRY\(([^)]*)\).*/\1/'                  \
+	--regex-asm='/^(ENTRY|_GLOBAL)\(([^)]*)\).*/\2/'        \
 	--regex-c='/^SYSCALL_DEFINE[[:digit:]]?\(([^,)]*).*/sys_\1/' \
 	--regex-c++='/^TRACE_EVENT\(([^,)]*).*/trace_\1/'		\
 	--regex-c++='/^DEFINE_EVENT\([^,)]*, *([^,)]*).*/trace_\1/'
@@ -151,7 +151,7 @@ exuberant()
 emacs()
 {
 	all_sources | xargs $1 -a                               \
-	--regex='/^ENTRY(\([^)]*\)).*/\1/'                      \
+	--regex='/^(ENTRY|_GLOBAL)(\([^)]*\)).*/\2/'            \
 	--regex='/^SYSCALL_DEFINE[0-9]?(\([^,)]*\).*/sys_\1/'   \
 	--regex='/^TRACE_EVENT(\([^,)]*\).*/trace_\1/'		\
 	--regex='/^DEFINE_EVENT([^,)]*, *\([^,)]*\).*/trace_\1/'
_

Patches currently in -mm which might be from imunsie@au1.ibm.com are

linux-next.patch

