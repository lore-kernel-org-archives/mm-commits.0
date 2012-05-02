From: akpm@linux-foundation.org
Subject: + tools-vm-page-typesc-cleanups.patch added to -mm tree
Date: Wed, 02 May 2012 12:11:51 -0700
Message-ID: <20120502191154.23A52A0423@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:37793 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755587Ab2EBTL4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 May 2012 15:11:56 -0400
Received: by vbnl22 with SMTP id l22so104534vbn.1
        for <mm-commits@vger.kernel.org>; Wed, 02 May 2012 12:11:55 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: drepper@akkadia.org, drepper@gmail.com, kosaki.motohiro@jp.fujitsu.com


The patch titled
     Subject: tools/vm/page-types.c: cleanups
has been added to the -mm tree.  Its filename is
     tools-vm-page-typesc-cleanups.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/vm/page-types.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff -puN tools/vm/page-types.c~tools-vm-page-typesc-cleanups tools/vm/page-types.c
--- a/tools/vm/page-types.c~tools-vm-page-typesc-cleanups
+++ a/tools/vm/page-types.c
@@ -326,7 +326,7 @@ static char *page_flag_name(uint64_t fla
 {
 	static char buf[65];
 	int present;
-	int i, j;
+	size_t i, j;
 
 	for (i = 0, j = 0; i < ARRAY_SIZE(page_flag_names); i++) {
 		present = (flags >> i) & 1;
@@ -344,7 +344,7 @@ static char *page_flag_name(uint64_t fla
 static char *page_flag_longname(uint64_t flags)
 {
 	static char buf[1024];
-	int i, n;
+	size_t i, n;
 
 	for (i = 0, n = 0; i < ARRAY_SIZE(page_flag_names); i++) {
 		if (!page_flag_names[i])
@@ -402,7 +402,7 @@ static void show_page(unsigned long voff
 
 static void show_summary(void)
 {
-	int i;
+	size_t i;
 
 	printf("             flags\tpage-count       MB"
 		"  symbolic-flags\t\t\tlong-symbolic-flags\n");
@@ -500,7 +500,7 @@ static int debugfs_valid_mountpoint(cons
 /* find the path to the mounted debugfs */
 static const char *debugfs_find_mountpoint(void)
 {
-	const char **ptr;
+	const char *const *ptr;
 	char type[100];
 	FILE *fp;
 
@@ -537,7 +537,7 @@ static const char *debugfs_find_mountpoi
 
 static void debugfs_mount(void)
 {
-	const char **ptr;
+	const char *const *ptr;
 
 	/* see if it's already mounted */
 	if (debugfs_find_mountpoint())
@@ -614,10 +614,10 @@ static int unpoison_page(unsigned long o
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
@@ -670,7 +670,7 @@ static void walk_pfn(unsigned long voffs
 {
 	uint64_t buf[KPAGEFLAGS_BATCH];
 	unsigned long batch;
-	long pages;
+	unsigned long pages;
 	unsigned long i;
 
 	while (count) {
@@ -779,7 +779,7 @@ static const char *page_flag_type(uint64
 
 static void usage(void)
 {
-	int i, j;
+	size_t i, j;
 
 	printf(
 "page-types [options]\n"
@@ -938,7 +938,7 @@ static void add_bits_filter(uint64_t mas
 
 static uint64_t parse_flag_name(const char *str, int len)
 {
-	int i;
+	size_t i;
 
 	if (!*str || !len)
 		return 0;
_
Subject: Subject: tools/vm/page-types.c: cleanups

Patches currently in -mm which might be from drepper@akkadia.org are

tools-vm-page-typesc-cleanups.patch

