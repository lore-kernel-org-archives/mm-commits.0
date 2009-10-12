From: akpm@linux-foundation.org
Subject: + page-types-constify-read-only-arrays.patch added to -mm tree
Date: Mon, 12 Oct 2009 14:41:17 -0700
Message-ID: <200910122141.n9CLfI5k007381@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34483 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755547AbZJLVma (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Oct 2009 17:42:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tt.rantala@gmail.com, fengguang.wu@intel.com, rdunlap@xenotime.net


The patch titled
     page-types: constify read only arrays
has been added to the -mm tree.  Its filename is
     page-types-constify-read-only-arrays.patch

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
Subject: page-types: constify read only arrays
From: Tommi Rantala <tt.rantala@gmail.com>

Signed-off-by: Tommi Rantala <tt.rantala@gmail.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN Documentation/vm/page-types.c~page-types-constify-read-only-arrays Documentation/vm/page-types.c
--- a/Documentation/vm/page-types.c~page-types-constify-read-only-arrays
+++ a/Documentation/vm/page-types.c
@@ -100,7 +100,7 @@
 #define BIT(name)		(1ULL << KPF_##name)
 #define BITS_COMPOUND		(BIT(COMPOUND_HEAD) | BIT(COMPOUND_TAIL))
 
-static char *page_flag_names[] = {
+static const char *page_flag_names[] = {
 	[KPF_LOCKED]		= "L:locked",
 	[KPF_ERROR]		= "E:error",
 	[KPF_REFERENCED]	= "R:referenced",
@@ -173,7 +173,7 @@ static int		kpageflags_fd;
 static int		opt_hwpoison;
 static int		opt_unpoison;
 
-static char		*hwpoison_debug_fs = "/debug/hwpoison";
+static const char	hwpoison_debug_fs[] = "/debug/hwpoison";
 static int		hwpoison_inject_fd;
 static int		hwpoison_forget_fd;
 
@@ -885,7 +885,7 @@ static void parse_bits_mask(const char *
 }
 
 
-static struct option opts[] = {
+static const struct option opts[] = {
 	{ "raw"       , 0, NULL, 'r' },
 	{ "pid"       , 1, NULL, 'p' },
 	{ "file"      , 1, NULL, 'f' },
_

Patches currently in -mm which might be from tt.rantala@gmail.com are

page-types-constify-read-only-arrays.patch
page-types-trivial-typo-fixes.patch

