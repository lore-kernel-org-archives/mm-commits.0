From: akpm@linux-foundation.org
Subject: + kconfig-fix-warnings-in-fgets-fwrite-usage.patch added to -mm tree
Date: Thu, 12 Aug 2010 13:36:52 -0700
Message-ID: <201008122036.o7CKaqqZ011399@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35191 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755164Ab0HLUhc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Aug 2010 16:37:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, mmarek@suse.cz


The patch titled
     kconfig: fix warnings in fgets/fwrite usage
has been added to the -mm tree.  Its filename is
     kconfig-fix-warnings-in-fgets-fwrite-usage.patch

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
Subject: kconfig: fix warnings in fgets/fwrite usage
From: Mike Frysinger <vapier@gentoo.org>

Add some helper functions that abort on failure, and change the fwrite and
fget calls to use those.  This should kill off all the ugly gcc warnings
that some distros emit about ignoring return values due to usage of
warn_unused_result attributes.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kconfig/conf.c     |    4 ++--
 scripts/kconfig/confdata.c |    2 +-
 scripts/kconfig/expr.c     |    2 +-
 scripts/kconfig/lkc.h      |   24 ++++++++++++++++++++++++
 4 files changed, 28 insertions(+), 4 deletions(-)

diff -puN scripts/kconfig/conf.c~kconfig-fix-warnings-in-fgets-fwrite-usage scripts/kconfig/conf.c
--- a/scripts/kconfig/conf.c~kconfig-fix-warnings-in-fgets-fwrite-usage
+++ a/scripts/kconfig/conf.c
@@ -108,7 +108,7 @@ static int conf_askvalue(struct symbol *
 		check_stdin();
 	case oldaskconfig:
 		fflush(stdout);
-		fgets(line, 128, stdin);
+		xfgets(line, 128, stdin);
 		return 1;
 	default:
 		break;
@@ -306,7 +306,7 @@ static int conf_choice(struct menu *menu
 			check_stdin();
 		case oldaskconfig:
 			fflush(stdout);
-			fgets(line, 128, stdin);
+			xfgets(line, 128, stdin);
 			strip(line);
 			if (line[0] == '?') {
 				print_help(menu);
diff -puN scripts/kconfig/confdata.c~kconfig-fix-warnings-in-fgets-fwrite-usage scripts/kconfig/confdata.c
--- a/scripts/kconfig/confdata.c~kconfig-fix-warnings-in-fgets-fwrite-usage
+++ a/scripts/kconfig/confdata.c
@@ -412,7 +412,7 @@ static void conf_write_string(bool heade
 	while (1) {
 		l = strcspn(str, "\"\\");
 		if (l) {
-			fwrite(str, l, 1, out);
+			xfwrite(str, l, 1, out);
 			str += l;
 		}
 		if (!*str)
diff -puN scripts/kconfig/expr.c~kconfig-fix-warnings-in-fgets-fwrite-usage scripts/kconfig/expr.c
--- a/scripts/kconfig/expr.c~kconfig-fix-warnings-in-fgets-fwrite-usage
+++ a/scripts/kconfig/expr.c
@@ -1087,7 +1087,7 @@ void expr_print(struct expr *e, void (*f
 
 static void expr_print_file_helper(void *data, struct symbol *sym, const char *str)
 {
-	fwrite(str, strlen(str), 1, data);
+	xfwrite(str, strlen(str), 1, data);
 }
 
 void expr_fprint(struct expr *e, FILE *out)
diff -puN scripts/kconfig/lkc.h~kconfig-fix-warnings-in-fgets-fwrite-usage scripts/kconfig/lkc.h
--- a/scripts/kconfig/lkc.h~kconfig-fix-warnings-in-fgets-fwrite-usage
+++ a/scripts/kconfig/lkc.h
@@ -169,6 +169,30 @@ static inline bool sym_has_value(struct 
 	return sym->flags & SYMBOL_DEF_USER ? true : false;
 }
 
+#define internal_error(fmt, args...) \
+do { \
+	fprintf(stderr, "%s:%s:%i: %s: " fmt "\n", __FILE__, \
+		__func__, __LINE__, _("internal error"), ## args); \
+	exit(1); \
+} while (0)
+
+#define xfwrite(ptr, size, nmemb, stream) \
+({ \
+	size_t _nmemb = (nmemb); \
+	size_t ret = fwrite(ptr, size, _nmemb, stream); \
+	if (ret != _nmemb) \
+		internal_error("%s", _("fwrite() came up short")); \
+	ret; \
+})
+
+#define xfgets(s, size, stream) \
+({ \
+	char *ret = fgets(s, size, stream); \
+	if (ret == NULL) \
+		internal_error("%s", _("fgets() came up short")); \
+	ret; \
+})
+
 #ifdef __cplusplus
 }
 #endif
_

Patches currently in -mm which might be from vapier@gentoo.org are

origin.patch
linux-next.patch
kconfig-fix-warnings-in-fgets-fwrite-usage.patch

