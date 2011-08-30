From: akpm@linux-foundation.org
Subject: + scripts-tagssh-update-to-support-powerpc-_global-symbols.patch added to -mm tree
Date: Tue, 30 Aug 2011 14:23:59 -0700
Message-ID: <201108302123.p7ULNxso018154@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44531 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752619Ab1H3VYl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Aug 2011 17:24:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: imunsie@au1.ibm.com, benh@kernel.crashing.org, mmarek@suse.cz


The patch titled
     scripts/tags.sh: update to support powerpc _GLOBAL symbols
has been added to the -mm tree.  Its filename is
     scripts-tagssh-update-to-support-powerpc-_global-symbols.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scripts/tags.sh: update to support powerpc _GLOBAL symbols
From: Ian Munsie <imunsie@au1.ibm.com>

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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

scripts-tagssh-update-to-support-powerpc-_global-symbols.patch

