From: akpm@linux-foundation.org
Subject: [merged] tools-vm-page-typesc-cleanups.patch removed from -mm tree
Date: Thu, 31 May 2012 12:14:54 -0700
Message-ID: <20120531191454.61C67A0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:46604 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932864Ab2EaTOz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:14:55 -0400
Received: by yenl3 with SMTP id l3so137882yen.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:14:54 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: drepper@akkadia.org, drepper@gmail.com, fengguang.wu@intel.com, kosaki.motohiro@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: tools/vm/page-types.c: cleanups
has been removed from the -mm tree.  Its filename was
     tools-vm-page-typesc-cleanups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Ulrich Drepper <drepper@akkadia.org>
Subject: tools/vm/page-types.c: cleanups

Compiling page-type.c with a recent compiler produces many warnings,
mostly related to signed/unsigned comparisons.  This patch cleans up most
of them.

One remaining warning is about an unused parameter.  The <compiler.h> file
doesn't define a __unused macro (or the like) yet.  This can be addressed
later.

Signed-off-by: Ulrich Drepper <drepper@gmail.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/vm/page-types.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff -puN tools/vm/page-types.c~tools-vm-page-typesc-cleanups tools/vm/page-types.c
--- a/tools/vm/page-types.c~tools-vm-page-typesc-cleanups
+++ a/tools/vm/page-types.c
@@ -300,7 +300,7 @@ static char *page_flag_name(uint64_t fla
 {
 	static char buf[65];
 	int present;
-	int i, j;
+	size_t i, j;
 
 	for (i = 0, j = 0; i < ARRAY_SIZE(page_flag_names); i++) {
 		present = (flags >> i) & 1;
@@ -318,7 +318,7 @@ static char *page_flag_name(uint64_t fla
 static char *page_flag_longname(uint64_t flags)
 {
 	static char buf[1024];
-	int i, n;
+	size_t i, n;
 
 	for (i = 0, n = 0; i < ARRAY_SIZE(page_flag_names); i++) {
 		if (!page_flag_names[i])
@@ -376,7 +376,7 @@ static void show_page(unsigned long voff
 
 static void show_summary(void)
 {
-	int i;
+	size_t i;
 
 	printf("             flags\tpage-count       MB"
 		"  symbolic-flags\t\t\tlong-symbolic-flags\n");
@@ -474,7 +474,7 @@ static int debugfs_valid_mountpoint(cons
 /* find the path to the mounted debugfs */
 static const char *debugfs_find_mountpoint(void)
 {
-	const char **ptr;
+	const char *const *ptr;
 	char type[100];
 	FILE *fp;
 
@@ -511,7 +511,7 @@ static const char *debugfs_find_mountpoi
 
 static void debugfs_mount(void)
 {
-	const char **ptr;
+	const char *const *ptr;
 
 	/* see if it's already mounted */
 	if (debugfs_find_mountpoint())
@@ -588,10 +588,10 @@ static int unpoison_page(unsigned long o
  * page frame walker
  */
 
-static int hash_slot(uint64_t flags)
+static size_t hash_slot(uint64_t flags)
 {
-	int k = HASH_KEY(flags);
-	int i;
+	size_t k = HASH_KEY(flags);
+	size_t i;
 
 	/* Explicitly reserve slot 0 for flags 0: the following logic
 	 * cannot distinguish an unoccupied slot from slot (flags==0).
@@ -644,7 +644,7 @@ static void walk_pfn(unsigned long voffs
 {
 	uint64_t buf[KPAGEFLAGS_BATCH];
 	unsigned long batch;
-	long pages;
+	unsigned long pages;
 	unsigned long i;
 
 	while (count) {
@@ -753,7 +753,7 @@ static const char *page_flag_type(uint64
 
 static void usage(void)
 {
-	int i, j;
+	size_t i, j;
 
 	printf(
 "page-types [options]\n"
@@ -912,7 +912,7 @@ static void add_bits_filter(uint64_t mas
 
 static uint64_t parse_flag_name(const char *str, int len)
 {
-	int i;
+	size_t i;
 
 	if (!*str || !len)
 		return 0;
_

Patches currently in -mm which might be from drepper@akkadia.org are

origin.patch

