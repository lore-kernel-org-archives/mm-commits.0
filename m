From: akpm@linux-foundation.org
Subject: - lib-allow-memparse-to-accept-a-null-and-ignorable-second-parm.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:54:22 -0700
Message-ID: <200807252254.m6PMsMmT002808@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58597 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752205AbYGYWyZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 18:54:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@crashcourse.ca, mm-commits@vger.kernel.org


The patch titled
     lib: allow memparse() to accept a NULL and ignorable second parm
has been removed from the -mm tree.  Its filename was
     lib-allow-memparse-to-accept-a-null-and-ignorable-second-parm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lib: allow memparse() to accept a NULL and ignorable second parm
From: "Robert P. J. Day" <rpjday@crashcourse.ca>

Extend memparse() to allow the caller to use a NULL second parameter, which
would represent no interest in returning the address of the end of the parsed
string.

In numerous cases, callers invoke memparse() to parse a possibly-suffixed
string (such as "64K" or "2G" or whatever) and define a character pointer to
accept the end pointer being returned by memparse() even though they have no
interest in it and promptly throw it away.

This (backward-compatible) enhancement allows callers to use NULL in the cases
where they just don't care about getting back that end pointer.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/cmdline.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff -puN lib/cmdline.c~lib-allow-memparse-to-accept-a-null-and-ignorable-second-parm lib/cmdline.c
--- a/lib/cmdline.c~lib-allow-memparse-to-accept-a-null-and-ignorable-second-parm
+++ a/lib/cmdline.c
@@ -116,7 +116,7 @@ char *get_options(const char *str, int n
 /**
  *	memparse - parse a string with mem suffixes into a number
  *	@ptr: Where parse begins
- *	@retptr: (output) Pointer to next char after parse completes
+ *	@retptr: (output) Optional pointer to next char after parse completes
  *
  *	Parses a string into a number.  The number stored at @ptr is
  *	potentially suffixed with %K (for kilobytes, or 1024 bytes),
@@ -126,11 +126,13 @@ char *get_options(const char *str, int n
  *	megabyte, or one gigabyte, respectively.
  */
 
-unsigned long long memparse (char *ptr, char **retptr)
+unsigned long long memparse(char *ptr, char **retptr)
 {
-	unsigned long long ret = simple_strtoull (ptr, retptr, 0);
+	char *endptr;	/* local pointer to end of parsed string */
 
-	switch (**retptr) {
+	unsigned long long ret = simple_strtoull(ptr, &endptr, 0);
+
+	switch (*endptr) {
 	case 'G':
 	case 'g':
 		ret <<= 10;
@@ -140,10 +142,14 @@ unsigned long long memparse (char *ptr, 
 	case 'K':
 	case 'k':
 		ret <<= 10;
-		(*retptr)++;
+		endptr++;
 	default:
 		break;
 	}
+
+	if (retptr)
+		*retptr = endptr;
+
 	return ret;
 }
 
_

Patches currently in -mm which might be from rpjday@crashcourse.ca are

origin.patch
linux-next.patch
kbuild-remove-final-references-to-deprecated-unreferenced-topdir.patch
m32r-remove-the-unused-nohighmem-option.patch
xtensa-warn-about-including-asm-rwsemh-directly.patch
xtensa-use-newer-__spin_lock_unlocked-macro.patch

