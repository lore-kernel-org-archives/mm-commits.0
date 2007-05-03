From: akpm@linux-foundation.org
Subject: - afs-make-the-match_-functions-take-const-options.patch removed from -mm tree
Date: Thu, 03 May 2007 12:31:48 -0700
Message-ID: <200705031931.l43JVmtB018292@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56181 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767889AbXECTd5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 May 2007 15:33:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     AFS: Make the match_*() functions take const options
has been removed from the -mm tree.  Its filename was
     afs-make-the-match_-functions-take-const-options.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: AFS: Make the match_*() functions take const options
From: David Howells <dhowells@redhat.com>

Make the match_*() functions take a const pointer to the options table and
make strings pointers in the options table const too.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/parser.h |    8 ++++----
 lib/parser.c           |   10 +++++-----
 2 files changed, 9 insertions(+), 9 deletions(-)

diff -puN include/linux/parser.h~afs-make-the-match_-functions-take-const-options include/linux/parser.h
--- a/include/linux/parser.h~afs-make-the-match_-functions-take-const-options
+++ a/include/linux/parser.h
@@ -11,10 +11,10 @@
 /* associates an integer enumerator with a pattern string. */
 struct match_token {
 	int token;
-	char *pattern;
+	const char *pattern;
 };
 
-typedef struct match_token match_table_t[];
+typedef const struct match_token match_table_t[];
 
 /* Maximum number of arguments that match_token will find in a pattern */
 enum {MAX_OPT_ARGS = 3};
@@ -29,5 +29,5 @@ int match_token(char *, match_table_t ta
 int match_int(substring_t *, int *result);
 int match_octal(substring_t *, int *result);
 int match_hex(substring_t *, int *result);
-void match_strcpy(char *, substring_t *);
-char *match_strdup(substring_t *);
+void match_strcpy(char *, const substring_t *);
+char *match_strdup(const substring_t *);
diff -puN lib/parser.c~afs-make-the-match_-functions-take-const-options lib/parser.c
--- a/lib/parser.c~afs-make-the-match_-functions-take-const-options
+++ a/lib/parser.c
@@ -22,7 +22,7 @@
  * match extremely simple token=arg style patterns. If the pattern is found,
  * the location(s) of the arguments will be returned in the @args array.
  */
-static int match_one(char *s, char *p, substring_t args[])
+static int match_one(char *s, const char *p, substring_t args[])
 {
 	char *meta;
 	int argc = 0;
@@ -43,7 +43,7 @@ static int match_one(char *s, char *p, s
 		p = meta + 1;
 
 		if (isdigit(*p))
-			len = simple_strtoul(p, &p, 10);
+			len = simple_strtoul(p, (char **) &p, 10);
 		else if (*p == '%') {
 			if (*s++ != '%')
 				return 0;
@@ -102,7 +102,7 @@ static int match_one(char *s, char *p, s
  */
 int match_token(char *s, match_table_t table, substring_t args[])
 {
-	struct match_token *p;
+	const struct match_token *p;
 
 	for (p = table; !match_one(s, p->pattern, args) ; p++)
 		;
@@ -190,7 +190,7 @@ int match_hex(substring_t *s, int *resul
  * &substring_t @s to the c-style string @to. Caller guarantees that @to is
  * large enough to hold the characters of @s.
  */
-void match_strcpy(char *to, substring_t *s)
+void match_strcpy(char *to, const substring_t *s)
 {
 	memcpy(to, s->from, s->to - s->from);
 	to[s->to - s->from] = '\0';
@@ -204,7 +204,7 @@ void match_strcpy(char *to, substring_t 
  * the &substring_t @s. The caller is responsible for freeing the returned
  * string with kfree().
  */
-char *match_strdup(substring_t *s)
+char *match_strdup(const substring_t *s)
 {
 	char *p = kmalloc(s->to - s->from + 1, GFP_KERNEL);
 	if (p)
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
get_unmapped_area-handles-map_fixed-on-powerpc.patch
get_unmapped_area-handles-map_fixed-on-frv.patch
get_unmapped_area-handles-map_fixed-in-hugetlbfs.patch
get_unmapped_area-handles-map_fixed-in-generic-code.patch
get_unmapped_area-doesnt-need-hugetlbfs-hacks-anymore.patch
m68k-export-csum_partial_copy_from_user.patch
nommu-present-backing-device-capabilities-for-mtd.patch
nommu-add-support-for-direct-mapping-through-mtdconcat.patch
nommu-generalise-the-handling-of-mtd-specific-superblocks.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
romfs-printk-format-warnings.patch
git-net.patch
use-slab_panic-flag-cleanup.patch
use-symbolic-constants-in-generic-lseek-code.patch
use-use-seek_max-to-validate-user-lseek-arguments.patch
kconfig-centralize-the-selection-of-semaphore-debugging.patch
aio-use-flush_work.patch
kblockd-use-flush_work.patch
relayfs-use-flush_keventd_work.patch
tg3-use-flush_keventd_work.patch
e1000-use-flush_keventd_work.patch
libata-use-flush_work.patch
phy-use-flush_work.patch
workqueue-kill-noautorel-works.patch
revoke-core-code-revoke-no-revoke-for-nommu.patch
mutex-subsystem-synchro-test-module.patch
