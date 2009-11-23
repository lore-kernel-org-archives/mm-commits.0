From: akpm@linux-foundation.org
Subject: + kbuild-genksyms-properly-consider-export_unused_symbol_gpl.patch added to -mm tree
Date: Mon, 23 Nov 2009 14:51:14 -0800
Message-ID: <200911232251.nANMpE5s000623@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55035 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755951AbZKWWvf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Nov 2009 17:51:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: JBeulich@novell.com, anibal@debian.org, jbeulich@novell.com, mmarek@suse.cz, rostedt@goodmis.org, sam@ravnborg.org


The patch titled
     kbuild: genksyms: properly consider  EXPORT_UNUSED_SYMBOL{,_GPL}()
has been added to the -mm tree.  Its filename is
     kbuild-genksyms-properly-consider-export_unused_symbol_gpl.patch

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
Subject: kbuild: genksyms: properly consider  EXPORT_UNUSED_SYMBOL{,_GPL}()
From: "Jan Beulich" <JBeulich@novell.com>

Despite being unused these should also get a CRC calculated.

Primarily I view this as a consistency thing.  But I also think this is
one of the reasons why __crc_* need to be weak (which I think should be
avoided, and hence we should have the goal to eliminate this so that
failure to calculate a proper CRC for a symbol causes the build to fail).

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Anibal Monsalve Salazar <anibal@debian.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/genksyms/keywords.c_shipped |  191 +++++++++++++-------------
 scripts/genksyms/keywords.gperf     |    2 
 2 files changed, 99 insertions(+), 94 deletions(-)

diff -puN scripts/genksyms/keywords.c_shipped~kbuild-genksyms-properly-consider-export_unused_symbol_gpl scripts/genksyms/keywords.c_shipped
--- a/scripts/genksyms/keywords.c_shipped~kbuild-genksyms-properly-consider-export_unused_symbol_gpl
+++ a/scripts/genksyms/keywords.c_shipped
@@ -1,4 +1,4 @@
-/* ANSI-C code produced by gperf version 3.0.3 */
+/* ANSI-C code produced by gperf version 3.0.4 */
 /* Command-line: gperf -L ANSI-C -a -C -E -g -H is_reserved_hash -k '1,3,$' -N is_reserved_word -p -t scripts/genksyms/keywords.gperf  */
 
 #if !((' ' == 32) && ('!' == 33) && ('"' == 34) && ('#' == 35) \
@@ -34,7 +34,7 @@ struct resword;
 static const struct resword *is_reserved_word(register const char *str, register unsigned int len);
 #line 5 "scripts/genksyms/keywords.gperf"
 struct resword { const char *name; int token; };
-/* maximum key range = 62, duplicates = 0 */
+/* maximum key range = 64, duplicates = 0 */
 
 #ifdef __GNUC__
 __inline
@@ -48,39 +48,39 @@ is_reserved_hash (register const char *s
 {
   static const unsigned char asso_values[] =
     {
-      65, 65, 65, 65, 65, 65, 65, 65, 65, 65,
-      65, 65, 65, 65, 65, 65, 65, 65, 65, 65,
-      65, 65, 65, 65, 65, 65, 65, 65, 65, 65,
-      65, 65, 65, 65, 65, 65, 65, 65, 65, 65,
-      65, 65, 65, 65, 65, 65, 65, 65, 65, 65,
-      65, 65, 65, 65, 65, 65, 65, 65, 65, 65,
-      65, 65, 65, 65, 65, 65, 65, 65, 65,  5,
-      65, 65, 65, 65, 65, 65, 35, 65, 65, 65,
-       0, 65, 65, 65, 65, 65, 65, 65, 65, 65,
-      65, 65, 65, 65, 65,  0, 65,  0, 65,  5,
-      20, 15, 10, 30, 65, 15, 65, 65, 20,  0,
-      10, 35, 20, 65, 10,  5,  0, 10,  5, 65,
-      65, 65, 65, 65, 65, 65, 65, 65, 65, 65,
-      65, 65, 65, 65, 65, 65, 65, 65, 65, 65,
-      65, 65, 65, 65, 65, 65, 65, 65, 65, 65,
-      65, 65, 65, 65, 65, 65, 65, 65, 65, 65,
-      65, 65, 65, 65, 65, 65, 65, 65, 65, 65,
-      65, 65, 65, 65, 65, 65, 65, 65, 65, 65,
-      65, 65, 65, 65, 65, 65, 65, 65, 65, 65,
-      65, 65, 65, 65, 65, 65, 65, 65, 65, 65,
-      65, 65, 65, 65, 65, 65, 65, 65, 65, 65,
-      65, 65, 65, 65, 65, 65, 65, 65, 65, 65,
-      65, 65, 65, 65, 65, 65, 65, 65, 65, 65,
-      65, 65, 65, 65, 65, 65, 65, 65, 65, 65,
-      65, 65, 65, 65, 65, 65, 65, 65, 65, 65,
-      65, 65, 65, 65, 65, 65
+      67, 67, 67, 67, 67, 67, 67, 67, 67, 67,
+      67, 67, 67, 67, 67, 67, 67, 67, 67, 67,
+      67, 67, 67, 67, 67, 67, 67, 67, 67, 67,
+      67, 67, 67, 67, 67, 67, 67, 67, 67, 67,
+      67, 67, 67, 67, 67, 67, 67, 67, 67, 67,
+      67, 67, 67, 67, 67, 67, 67, 67, 67, 67,
+      67, 67, 67, 67, 67, 67, 67, 67, 67,  0,
+      67, 67, 67, 67, 67, 67, 15, 67, 67, 67,
+       0, 67, 67, 67, 67, 67, 67, 67, 67, 67,
+      67, 67, 67, 67, 67,  0, 67,  0, 67,  5,
+      25, 20, 15, 30, 67, 15, 67, 67, 10,  0,
+      10, 40, 20, 67, 10,  5,  0, 10, 15, 67,
+      67, 67, 67, 67, 67, 67, 67, 67, 67, 67,
+      67, 67, 67, 67, 67, 67, 67, 67, 67, 67,
+      67, 67, 67, 67, 67, 67, 67, 67, 67, 67,
+      67, 67, 67, 67, 67, 67, 67, 67, 67, 67,
+      67, 67, 67, 67, 67, 67, 67, 67, 67, 67,
+      67, 67, 67, 67, 67, 67, 67, 67, 67, 67,
+      67, 67, 67, 67, 67, 67, 67, 67, 67, 67,
+      67, 67, 67, 67, 67, 67, 67, 67, 67, 67,
+      67, 67, 67, 67, 67, 67, 67, 67, 67, 67,
+      67, 67, 67, 67, 67, 67, 67, 67, 67, 67,
+      67, 67, 67, 67, 67, 67, 67, 67, 67, 67,
+      67, 67, 67, 67, 67, 67, 67, 67, 67, 67,
+      67, 67, 67, 67, 67, 67, 67, 67, 67, 67,
+      67, 67, 67, 67, 67, 67
     };
   return len + asso_values[(unsigned char)str[2]] + asso_values[(unsigned char)str[0]] + asso_values[(unsigned char)str[len - 1]];
 }
 
 #ifdef __GNUC__
 __inline
-#ifdef __GNUC_STDC_INLINE__
+#if defined __GNUC_STDC_INLINE__ || defined __GNUC_GNU_INLINE__
 __attribute__ ((__gnu_inline__))
 #endif
 #endif
@@ -89,116 +89,119 @@ is_reserved_word (register const char *s
 {
   enum
     {
-      TOTAL_KEYWORDS = 43,
+      TOTAL_KEYWORDS = 45,
       MIN_WORD_LENGTH = 3,
       MAX_WORD_LENGTH = 24,
       MIN_HASH_VALUE = 3,
-      MAX_HASH_VALUE = 64
+      MAX_HASH_VALUE = 66
     };
 
   static const struct resword wordlist[] =
     {
       {""}, {""}, {""},
-#line 28 "scripts/genksyms/keywords.gperf"
+#line 30 "scripts/genksyms/keywords.gperf"
       {"asm", ASM_KEYW},
       {""},
-#line 10 "scripts/genksyms/keywords.gperf"
+#line 12 "scripts/genksyms/keywords.gperf"
       {"__asm", ASM_KEYW},
       {""},
-#line 11 "scripts/genksyms/keywords.gperf"
+#line 13 "scripts/genksyms/keywords.gperf"
       {"__asm__", ASM_KEYW},
       {""}, {""},
-#line 54 "scripts/genksyms/keywords.gperf"
+#line 56 "scripts/genksyms/keywords.gperf"
       {"__typeof__", TYPEOF_KEYW},
       {""},
-#line 14 "scripts/genksyms/keywords.gperf"
+#line 16 "scripts/genksyms/keywords.gperf"
       {"__const", CONST_KEYW},
-#line 13 "scripts/genksyms/keywords.gperf"
-      {"__attribute__", ATTRIBUTE_KEYW},
 #line 15 "scripts/genksyms/keywords.gperf"
+      {"__attribute__", ATTRIBUTE_KEYW},
+#line 17 "scripts/genksyms/keywords.gperf"
       {"__const__", CONST_KEYW},
-#line 20 "scripts/genksyms/keywords.gperf"
+#line 22 "scripts/genksyms/keywords.gperf"
       {"__signed__", SIGNED_KEYW},
-#line 46 "scripts/genksyms/keywords.gperf"
+#line 48 "scripts/genksyms/keywords.gperf"
       {"static", STATIC_KEYW},
-#line 22 "scripts/genksyms/keywords.gperf"
-      {"__volatile__", VOLATILE_KEYW},
-#line 41 "scripts/genksyms/keywords.gperf"
+      {""},
+#line 43 "scripts/genksyms/keywords.gperf"
       {"int", INT_KEYW},
-#line 34 "scripts/genksyms/keywords.gperf"
+#line 36 "scripts/genksyms/keywords.gperf"
       {"char", CHAR_KEYW},
-#line 35 "scripts/genksyms/keywords.gperf"
+#line 37 "scripts/genksyms/keywords.gperf"
       {"const", CONST_KEYW},
-#line 47 "scripts/genksyms/keywords.gperf"
+#line 49 "scripts/genksyms/keywords.gperf"
       {"struct", STRUCT_KEYW},
-#line 26 "scripts/genksyms/keywords.gperf"
+#line 28 "scripts/genksyms/keywords.gperf"
       {"__restrict__", RESTRICT_KEYW},
-#line 27 "scripts/genksyms/keywords.gperf"
+#line 29 "scripts/genksyms/keywords.gperf"
       {"restrict", RESTRICT_KEYW},
-#line 25 "scripts/genksyms/keywords.gperf"
-      {"_restrict", RESTRICT_KEYW},
-#line 18 "scripts/genksyms/keywords.gperf"
+#line 9 "scripts/genksyms/keywords.gperf"
+      {"EXPORT_SYMBOL_GPL_FUTURE", EXPORT_SYMBOL_KEYW},
+#line 20 "scripts/genksyms/keywords.gperf"
       {"__inline__", INLINE_KEYW},
-#line 12 "scripts/genksyms/keywords.gperf"
-      {"__attribute", ATTRIBUTE_KEYW},
       {""},
-#line 16 "scripts/genksyms/keywords.gperf"
+#line 24 "scripts/genksyms/keywords.gperf"
+      {"__volatile__", VOLATILE_KEYW},
+#line 7 "scripts/genksyms/keywords.gperf"
+      {"EXPORT_SYMBOL", EXPORT_SYMBOL_KEYW},
+#line 27 "scripts/genksyms/keywords.gperf"
+      {"_restrict", RESTRICT_KEYW},
+      {""},
+#line 14 "scripts/genksyms/keywords.gperf"
+      {"__attribute", ATTRIBUTE_KEYW},
+#line 8 "scripts/genksyms/keywords.gperf"
+      {"EXPORT_SYMBOL_GPL", EXPORT_SYMBOL_KEYW},
+#line 18 "scripts/genksyms/keywords.gperf"
       {"__extension__", EXTENSION_KEYW},
-#line 37 "scripts/genksyms/keywords.gperf"
+#line 39 "scripts/genksyms/keywords.gperf"
       {"enum", ENUM_KEYW},
-#line 21 "scripts/genksyms/keywords.gperf"
-      {"__volatile", VOLATILE_KEYW},
-#line 38 "scripts/genksyms/keywords.gperf"
+#line 10 "scripts/genksyms/keywords.gperf"
+      {"EXPORT_UNUSED_SYMBOL", EXPORT_SYMBOL_KEYW},
+#line 40 "scripts/genksyms/keywords.gperf"
       {"extern", EXTERN_KEYW},
       {""},
-#line 19 "scripts/genksyms/keywords.gperf"
+#line 21 "scripts/genksyms/keywords.gperf"
       {"__signed", SIGNED_KEYW},
-#line 9 "scripts/genksyms/keywords.gperf"
-      {"EXPORT_SYMBOL_GPL_FUTURE", EXPORT_SYMBOL_KEYW},
-      {""},
-#line 53 "scripts/genksyms/keywords.gperf"
+#line 11 "scripts/genksyms/keywords.gperf"
+      {"EXPORT_UNUSED_SYMBOL_GPL", EXPORT_SYMBOL_KEYW},
+#line 51 "scripts/genksyms/keywords.gperf"
+      {"union", UNION_KEYW},
+#line 55 "scripts/genksyms/keywords.gperf"
       {"typeof", TYPEOF_KEYW},
-#line 48 "scripts/genksyms/keywords.gperf"
+#line 50 "scripts/genksyms/keywords.gperf"
       {"typedef", TYPEDEF_KEYW},
-#line 17 "scripts/genksyms/keywords.gperf"
+#line 19 "scripts/genksyms/keywords.gperf"
       {"__inline", INLINE_KEYW},
-#line 33 "scripts/genksyms/keywords.gperf"
+#line 35 "scripts/genksyms/keywords.gperf"
       {"auto", AUTO_KEYW},
-#line 49 "scripts/genksyms/keywords.gperf"
-      {"union", UNION_KEYW},
-      {""}, {""},
-#line 50 "scripts/genksyms/keywords.gperf"
-      {"unsigned", UNSIGNED_KEYW},
-#line 51 "scripts/genksyms/keywords.gperf"
-      {"void", VOID_KEYW},
-#line 44 "scripts/genksyms/keywords.gperf"
-      {"short", SHORT_KEYW},
+#line 23 "scripts/genksyms/keywords.gperf"
+      {"__volatile", VOLATILE_KEYW},
       {""}, {""},
 #line 52 "scripts/genksyms/keywords.gperf"
-      {"volatile", VOLATILE_KEYW},
-      {""},
-#line 39 "scripts/genksyms/keywords.gperf"
-      {"float", FLOAT_KEYW},
-#line 36 "scripts/genksyms/keywords.gperf"
-      {"double", DOUBLE_KEYW},
+      {"unsigned", UNSIGNED_KEYW},
       {""},
-#line 7 "scripts/genksyms/keywords.gperf"
-      {"EXPORT_SYMBOL", EXPORT_SYMBOL_KEYW},
-      {""}, {""},
-#line 40 "scripts/genksyms/keywords.gperf"
+#line 46 "scripts/genksyms/keywords.gperf"
+      {"short", SHORT_KEYW},
+#line 42 "scripts/genksyms/keywords.gperf"
       {"inline", INLINE_KEYW},
-#line 8 "scripts/genksyms/keywords.gperf"
-      {"EXPORT_SYMBOL_GPL", EXPORT_SYMBOL_KEYW},
-#line 43 "scripts/genksyms/keywords.gperf"
-      {"register", REGISTER_KEYW},
       {""},
-#line 24 "scripts/genksyms/keywords.gperf"
+#line 54 "scripts/genksyms/keywords.gperf"
+      {"volatile", VOLATILE_KEYW},
+#line 44 "scripts/genksyms/keywords.gperf"
+      {"long", LONG_KEYW},
+#line 26 "scripts/genksyms/keywords.gperf"
       {"_Bool", BOOL_KEYW},
-#line 45 "scripts/genksyms/keywords.gperf"
-      {"signed", SIGNED_KEYW},
       {""}, {""},
-#line 42 "scripts/genksyms/keywords.gperf"
-      {"long", LONG_KEYW}
+#line 45 "scripts/genksyms/keywords.gperf"
+      {"register", REGISTER_KEYW},
+#line 53 "scripts/genksyms/keywords.gperf"
+      {"void", VOID_KEYW},
+#line 41 "scripts/genksyms/keywords.gperf"
+      {"float", FLOAT_KEYW},
+#line 38 "scripts/genksyms/keywords.gperf"
+      {"double", DOUBLE_KEYW},
+      {""}, {""}, {""}, {""},
+#line 47 "scripts/genksyms/keywords.gperf"
+      {"signed", SIGNED_KEYW}
     };
 
   if (len <= MAX_WORD_LENGTH && len >= MIN_WORD_LENGTH)
diff -puN scripts/genksyms/keywords.gperf~kbuild-genksyms-properly-consider-export_unused_symbol_gpl scripts/genksyms/keywords.gperf
--- a/scripts/genksyms/keywords.gperf~kbuild-genksyms-properly-consider-export_unused_symbol_gpl
+++ a/scripts/genksyms/keywords.gperf
@@ -7,6 +7,8 @@ struct resword { const char *name; int t
 EXPORT_SYMBOL, EXPORT_SYMBOL_KEYW
 EXPORT_SYMBOL_GPL, EXPORT_SYMBOL_KEYW
 EXPORT_SYMBOL_GPL_FUTURE, EXPORT_SYMBOL_KEYW
+EXPORT_UNUSED_SYMBOL, EXPORT_SYMBOL_KEYW
+EXPORT_UNUSED_SYMBOL_GPL, EXPORT_SYMBOL_KEYW
 __asm, ASM_KEYW
 __asm__, ASM_KEYW
 __attribute, ATTRIBUTE_KEYW
_

Patches currently in -mm which might be from JBeulich@novell.com are

linux-next.patch
drm-make-sure-page-protections-are-updated-after-changing-vm_flags.patch
kbuild-generate-modulesbuiltin.patch
kbuild-rebuild-fix-for-makefilemodbuiltin.patch
kbuild-generate-modulesbuiltin-fix-2.patch
kbuild-genksyms-properly-consider-export_unused_symbol_gpl.patch
fix-section-mismatch-in-early-ehci-dbgp.patch
vmalloc-adjust-gfp-mask-passed-on-nested-vmalloc-invocation.patch
mm-bootmemc-properly-__init-annotate-helper-functions.patch
dma-mapping-fix-off-by-one-error-in-dma_capable.patch

