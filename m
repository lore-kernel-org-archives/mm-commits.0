From: akpm@linux-foundation.org
Subject: [merged] page-types-constify-read-only-arrays.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:50:07 -0800
Message-ID: <200912152150.nBFLo7SV014920@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52418 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758681AbZLOVuj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 16:50:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tt.rantala@gmail.com, fengguang.wu@intel.com, rdunlap@xenotime.net, mm-commits@vger.kernel.org


The patch titled
     page-types: constify read only arrays
has been removed from the -mm tree.  Its filename was
     page-types-constify-read-only-arrays.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: page-types: constify read only arrays
From: Tommi Rantala <tt.rantala@gmail.com>

Signed-off-by: Tommi Rantala <tt.rantala@gmail.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/page-types.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

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

origin.patch

