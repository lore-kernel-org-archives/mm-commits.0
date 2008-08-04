From: akpm@linux-foundation.org
Subject: - genksyms-parser-fix-the-__attribute__-rule.patch removed from -mm tree
Date: Mon, 04 Aug 2008 13:06:25 -0700
Message-ID: <200808042006.m74K6PMi027689@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56504 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758177AbYHDUGq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Aug 2008 16:06:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: agruen@suse.de, randy.dunlap@oracle.com, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     genksyms: parser: fix the __attribute__ rule
has been removed from the -mm tree.  Its filename was
     genksyms-parser-fix-the-__attribute__-rule.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: genksyms: parser: fix the __attribute__ rule
From: Andreas Gruenbacher <agruen@suse.de>

We are having two kinds of problems with genksyms today: fake checksum
changes without actual ABI changes, and changes which we would rather like
to ignore (such as an additional field at the end of a structure that
modules are not supposed to touch, for example).

I have thought about ways to improve genksyms and compute checksums
differently to avoid those problems, but in the end I don't see a
fundamentally better way.  So here are some genksyms patches for at least
making the checksums more easily manageable, if we cannot fully fix them.

In addition to the bugfixes (the first two patches), this allows genksyms
to track checksum changes and report why a checksum changed (third patch),
and to selectively ignore changes (fourth patch).


This patch:

Gcc __attribute__ definitions may occur repeatedly, e.g.,

	static int foo __attribute__((__used__))
		       __attribute__((aligned (16)));

The genksyms parser does not understand this, and generates a syntax error.
Fix this case.

Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/genksyms/parse.c_shipped |  144 ++++++++++++++---------------
 scripts/genksyms/parse.y         |    2 
 2 files changed, 73 insertions(+), 73 deletions(-)

diff -puN scripts/genksyms/parse.c_shipped~genksyms-parser-fix-the-__attribute__-rule scripts/genksyms/parse.c_shipped
--- a/scripts/genksyms/parse.c_shipped~genksyms-parser-fix-the-__attribute__-rule
+++ a/scripts/genksyms/parse.c_shipped
@@ -504,7 +504,7 @@ static const yytype_uint16 yyprhs[] =
      239,   242,   245,   247,   248,   250,   252,   257,   262,   265,
      269,   273,   277,   278,   280,   283,   287,   291,   292,   294,
      296,   299,   303,   306,   307,   309,   311,   315,   318,   321,
-     323,   326,   327,   329,   332,   333,   335
+     323,   326,   327,   330,   333,   334,   336
 };
 
 /* YYRHS -- A `-1'-separated list of the rules' RHS.  */
@@ -542,9 +542,9 @@ static const yytype_int8 yyrhs[] =
       -1,    -1,    89,    -1,    90,    -1,    89,    90,    -1,    64,
       91,    44,    -1,     1,    44,    -1,    -1,    92,    -1,    93,
       -1,    92,    46,    93,    -1,    76,    95,    -1,    37,    94,
-      -1,    94,    -1,    52,    34,    -1,    -1,    31,    -1,    30,
-      44,    -1,    -1,    30,    -1,    29,    47,    37,    49,    44,
-      -1
+      -1,    94,    -1,    52,    34,    -1,    -1,    95,    31,    -1,
+      30,    44,    -1,    -1,    30,    -1,    29,    47,    37,    49,
+      44,    -1
 };
 
 /* YYRLINE[YYN] -- source line where rule number YYN was defined.  */
@@ -647,7 +647,7 @@ static const yytype_uint8 yyr2[] =
        2,     2,     1,     0,     1,     1,     4,     4,     2,     3,
        3,     3,     0,     1,     2,     3,     3,     0,     1,     1,
        2,     3,     2,     0,     1,     1,     3,     2,     2,     1,
-       2,     0,     1,     2,     0,     1,     5
+       2,     0,     2,     2,     0,     1,     5
 };
 
 /* YYDEFACT[STATE-NAME] -- Default rule to reduce with in state
@@ -667,9 +667,9 @@ static const yytype_uint8 yydefact[] =
        0,    66,   125,   101,   121,    71,     0,     7,   112,   106,
       76,    77,     0,     0,     0,   121,    75,     0,   114,   115,
      119,   105,     0,   110,   124,     0,    36,     0,    73,    72,
-      61,    20,   122,   102,     0,    93,     0,    84,    87,    88,
-     118,     0,    76,     0,   120,    74,   117,    80,     0,   111,
-       0,    35,   126,     0,    21,   103,    70,    94,    56,     0,
+      61,    20,   102,     0,    93,     0,    84,    87,    88,   118,
+       0,    76,     0,   120,    74,   117,    80,     0,   111,     0,
+      35,   126,   122,     0,    21,   103,    70,    94,    56,     0,
       93,    90,    92,    69,    83,     0,    82,    81,     0,     0,
      116,   104,     0,    95,     0,    91,    98,     0,    85,    89,
       79,    78,   100,    99,     0,     0,    97,    96
@@ -680,44 +680,44 @@ static const yytype_int16 yydefgoto[] =
 {
       -1,     1,     2,     3,    35,    72,    55,    36,    64,    65,
       66,    75,    38,    39,    40,    41,    42,    67,    86,    87,
-      43,   114,    69,   105,   106,   126,   127,   128,   129,   151,
+      43,   114,    69,   105,   106,   125,   126,   127,   128,   151,
      152,    44,   144,   145,    54,    76,    77,    78,   107,   108,
-     109,   110,   123,    45,    94,    46
+     109,   110,   122,    45,    94,    46
 };
 
 /* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
    STATE-NUM.  */
-#define YYPACT_NINF -135
+#define YYPACT_NINF -134
 static const yytype_int16 yypact[] =
 {
-    -135,    11,  -135,   312,  -135,  -135,    24,  -135,  -135,  -135,
-    -135,  -135,   -23,  -135,    -2,  -135,  -135,  -135,  -135,  -135,
-    -135,  -135,  -135,  -135,   -17,  -135,   -11,  -135,  -135,  -135,
-      -3,    16,    26,  -135,  -135,  -135,  -135,    34,   482,  -135,
-    -135,  -135,  -135,  -135,  -135,  -135,  -135,  -135,  -135,  -135,
-      -8,  -135,    22,    97,  -135,   482,    22,  -135,   482,    56,
-    -135,  -135,    12,    10,    50,    49,  -135,    34,   -13,    15,
-    -135,  -135,   482,  -135,    47,   -25,    51,   145,  -135,  -135,
-      34,  -135,   356,    52,    71,    77,  -135,    10,  -135,  -135,
-      34,  -135,  -135,  -135,    68,  -135,   193,  -135,  -135,  -135,
-      48,  -135,     6,    93,    37,    68,    18,    85,    84,  -135,
-    -135,  -135,    87,  -135,   102,    86,  -135,    89,  -135,  -135,
-    -135,  -135,  -135,    90,    88,   401,    94,   100,   101,  -135,
-    -135,    99,  -135,   108,  -135,  -135,  -135,  -135,   230,  -135,
-     -25,  -135,  -135,   105,  -135,  -135,  -135,  -135,  -135,     9,
-      42,  -135,    28,  -135,  -135,   445,  -135,  -135,   119,   125,
-    -135,  -135,   126,  -135,   128,  -135,  -135,   267,  -135,  -135,
-    -135,  -135,  -135,  -135,   129,   130,  -135,  -135
+    -134,    16,  -134,   312,  -134,  -134,    20,  -134,  -134,  -134,
+    -134,  -134,   -18,  -134,    -3,  -134,  -134,  -134,  -134,  -134,
+    -134,  -134,  -134,  -134,   -26,  -134,   -25,  -134,  -134,  -134,
+      -7,     5,    27,  -134,  -134,  -134,  -134,    46,   482,  -134,
+    -134,  -134,  -134,  -134,  -134,  -134,  -134,  -134,  -134,  -134,
+      -8,  -134,    30,    97,  -134,   482,    30,  -134,   482,     7,
+    -134,  -134,    12,    10,    42,    55,  -134,    46,   -15,    15,
+    -134,  -134,   482,  -134,    25,    26,    47,   145,  -134,  -134,
+      46,  -134,   356,    39,    71,    77,  -134,    10,  -134,  -134,
+      46,  -134,  -134,  -134,  -134,  -134,   193,  -134,  -134,  -134,
+      75,  -134,     6,    95,    43,  -134,    28,    86,    85,  -134,
+    -134,  -134,    88,  -134,   103,    87,  -134,    91,  -134,  -134,
+    -134,  -134,   -23,    90,   401,    94,   101,   102,  -134,  -134,
+      98,  -134,   108,  -134,  -134,   109,  -134,   230,  -134,    26,
+    -134,  -134,  -134,   134,  -134,  -134,  -134,  -134,  -134,     9,
+      48,  -134,    35,  -134,  -134,   445,  -134,  -134,   125,   126,
+    -134,  -134,   128,  -134,   129,  -134,  -134,   267,  -134,  -134,
+    -134,  -134,  -134,  -134,   130,   131,  -134,  -134
 };
 
 /* YYPGOTO[NTERM-NUM].  */
 static const yytype_int16 yypgoto[] =
 {
-    -135,  -135,   179,  -135,  -135,  -135,  -135,   -47,  -135,  -135,
-      91,     0,   -58,   -37,  -135,  -135,  -135,   -73,  -135,  -135,
-     -48,   -32,  -135,   -38,  -135,  -134,  -135,  -135,    29,   -63,
-    -135,  -135,  -135,  -135,   -20,  -135,  -135,   106,  -135,  -135,
-      45,    95,    82,  -135,  -135,  -135
+    -134,  -134,   180,  -134,  -134,  -134,  -134,   -33,  -134,  -134,
+      93,     0,   -58,   -37,  -134,  -134,  -134,   -73,  -134,  -134,
+     -54,   -32,  -134,   -81,  -134,  -133,  -134,  -134,    29,   -50,
+    -134,  -134,  -134,  -134,   -20,  -134,  -134,   110,  -134,  -134,
+      49,    96,    80,  -134,  -134,  -134
 };
 
 /* YYTABLE[YYPACT[STATE-NUM]].  What to do in state STATE-NUM.  If
@@ -727,26 +727,26 @@ static const yytype_int16 yypgoto[] =
 #define YYTABLE_NINF -109
 static const yytype_int16 yytable[] =
 {
-      82,    70,   104,    37,   159,    68,    57,   131,    79,    49,
-     162,     4,   100,    84,    50,    88,   101,    92,    10,    93,
-      52,    51,   102,    63,    71,    97,    56,   103,    20,   104,
-      85,   104,    73,   175,    53,    91,    81,    29,   125,   120,
-      53,    33,   -93,   132,    58,    70,   147,   101,    95,    61,
-     163,   137,   150,   102,    63,    80,   149,    63,   -93,    62,
-      63,   166,    96,    59,   133,   138,   135,   104,    47,    48,
-      60,    61,    80,    53,   132,   167,   150,   150,   101,   147,
-     125,    62,    63,   163,   102,    63,   164,   165,    70,   149,
-      63,    98,    99,    83,    89,    90,   111,   125,    74,   122,
-     103,   117,     7,     8,     9,    10,    11,    12,    13,   125,
+      82,    70,   104,    37,   159,    68,    57,   130,   142,    88,
+     162,    52,    56,    84,    49,    92,     4,    93,    10,    50,
+      51,   132,    79,   134,    71,    53,    53,   143,    20,   104,
+      85,   104,    73,   120,   175,    91,    81,    29,   124,    97,
+      58,    33,   -93,   131,    83,    70,   147,   101,    95,    61,
+     163,   150,    59,   102,    63,    80,   149,    63,   -93,    62,
+      63,   136,    96,   100,    47,    48,   104,   101,   166,    98,
+      99,    60,    80,   102,    63,   137,   150,   150,   103,   124,
+     131,    53,   167,    61,   101,   147,    89,    70,   117,   163,
+     102,    63,   111,    62,    63,   149,    63,   124,    74,   164,
+     165,    90,     7,     8,     9,    10,    11,    12,    13,   124,
       15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
-     118,    26,    27,    28,    29,    30,   119,   134,    33,   139,
-     140,    98,    92,   142,   -22,   141,   154,   146,    34,   161,
-     143,   -22,  -107,   153,   -22,   -22,   112,   155,   156,   -22,
+     118,    26,    27,    28,    29,    30,   119,   103,    33,   133,
+     138,   139,    98,    92,   -22,   141,   140,   154,    34,   146,
+     142,   -22,  -107,   153,   -22,   -22,   112,   156,   155,   -22,
        7,     8,     9,    10,    11,    12,    13,   157,    15,    16,
-      17,    18,    19,    20,    21,    22,    23,    24,   170,    26,
-      27,    28,    29,    30,   171,   172,    33,   173,   176,   177,
-       5,   121,   -22,   113,   169,   160,    34,   136,     0,   -22,
-    -108,     0,   -22,   -22,   124,   130,     0,   -22,     7,     8,
+      17,    18,    19,    20,    21,    22,    23,    24,   161,    26,
+      27,    28,    29,    30,   170,   171,    33,   172,   173,   176,
+     177,     5,   -22,   121,   169,   135,    34,   113,   160,   -22,
+    -108,     0,   -22,   -22,   123,     0,   129,   -22,     7,     8,
        9,    10,    11,    12,    13,     0,    15,    16,    17,    18,
       19,    20,    21,    22,    23,    24,     0,    26,    27,    28,
       29,    30,     0,     0,    33,     0,     0,     0,     0,   -86,
@@ -784,26 +784,26 @@ static const yytype_int16 yytable[] =
 
 static const yytype_int16 yycheck[] =
 {
-      58,    38,    75,     3,   138,    37,    26,     1,    55,    32,
-       1,     0,    37,     1,    37,    63,    41,    30,     8,    32,
-      37,    23,    47,    48,    32,    72,    37,    52,    18,   102,
-      62,   104,    52,   167,    51,    67,    56,    27,    96,    87,
-      51,    31,    33,    37,    47,    82,    37,    41,    33,    37,
-      41,    33,   125,    47,    48,    55,    47,    48,    49,    47,
-      48,    33,    47,    47,   102,    47,   104,   140,    44,    45,
-      44,    37,    72,    51,    37,    47,   149,   150,    41,    37,
-     138,    47,    48,    41,    47,    48,   149,   150,   125,    47,
-      48,    44,    45,    37,    44,    46,    45,   155,     1,    31,
-      52,    49,     5,     6,     7,     8,     9,    10,    11,   167,
+      58,    38,    75,     3,   137,    37,    26,     1,    31,    63,
+       1,    37,    37,     1,    32,    30,     0,    32,     8,    37,
+      23,   102,    55,   104,    32,    51,    51,    50,    18,   102,
+      62,   104,    52,    87,   167,    67,    56,    27,    96,    72,
+      47,    31,    33,    37,    37,    82,    37,    41,    33,    37,
+      41,   124,    47,    47,    48,    55,    47,    48,    49,    47,
+      48,    33,    47,    37,    44,    45,   139,    41,    33,    44,
+      45,    44,    72,    47,    48,    47,   149,   150,    52,   137,
+      37,    51,    47,    37,    41,    37,    44,   124,    49,    41,
+      47,    48,    45,    47,    48,    47,    48,   155,     1,   149,
+     150,    46,     5,     6,     7,     8,     9,    10,    11,   167,
       13,    14,    15,    16,    17,    18,    19,    20,    21,    22,
-      49,    24,    25,    26,    27,    28,    49,    34,    31,    44,
-      46,    44,    30,    44,    37,    49,    36,    49,    41,    34,
-      50,    44,    45,    49,    47,    48,     1,    46,    49,    52,
+      49,    24,    25,    26,    27,    28,    49,    52,    31,    34,
+      44,    46,    44,    30,    37,    44,    49,    36,    41,    49,
+      31,    44,    45,    49,    47,    48,     1,    49,    46,    52,
        5,     6,     7,     8,     9,    10,    11,    49,    13,    14,
-      15,    16,    17,    18,    19,    20,    21,    22,    49,    24,
+      15,    16,    17,    18,    19,    20,    21,    22,    34,    24,
       25,    26,    27,    28,    49,    49,    31,    49,    49,    49,
-       1,    90,    37,    77,   155,   140,    41,   105,    -1,    44,
-      45,    -1,    47,    48,     1,   100,    -1,    52,     5,     6,
+      49,     1,    37,    90,   155,   105,    41,    77,   139,    44,
+      45,    -1,    47,    48,     1,    -1,   100,    52,     5,     6,
        7,     8,     9,    10,    11,    -1,    13,    14,    15,    16,
       17,    18,    19,    20,    21,    22,    -1,    24,    25,    26,
       27,    28,    -1,    -1,    31,    -1,    -1,    -1,    -1,    36,
@@ -855,9 +855,9 @@ static const yytype_uint8 yystos[] =
       46,    74,    30,    32,    97,    33,    47,    60,    44,    45,
       37,    41,    47,    52,    70,    76,    77,    91,    92,    93,
       94,    45,     1,    90,    74,    48,    49,    49,    49,    49,
-      73,    63,    31,    95,     1,    65,    78,    79,    80,    81,
-      94,     1,    37,    76,    34,    76,    95,    33,    47,    44,
-      46,    49,    44,    50,    85,    86,    49,    37,    41,    47,
+      73,    63,    95,     1,    65,    78,    79,    80,    81,    94,
+       1,    37,    76,    34,    76,    95,    33,    47,    44,    46,
+      49,    44,    31,    50,    85,    86,    49,    37,    41,    47,
       70,    82,    83,    49,    36,    46,    49,    49,     1,    78,
       93,    34,     1,    41,    82,    82,    33,    47,    36,    81,
       49,    49,    49,    49,     1,    78,    49,    49
diff -puN scripts/genksyms/parse.y~genksyms-parser-fix-the-__attribute__-rule scripts/genksyms/parse.y
--- a/scripts/genksyms/parse.y~genksyms-parser-fix-the-__attribute__-rule
+++ a/scripts/genksyms/parse.y
@@ -446,7 +446,7 @@ member_bitfield_declarator:
 
 attribute_opt:
 	/* empty */					{ $$ = NULL; }
-	| ATTRIBUTE_PHRASE
+	| attribute_opt ATTRIBUTE_PHRASE
 	;
 
 asm_definition:
_

Patches currently in -mm which might be from agruen@suse.de are

origin.patch
genksyms-track-symbol-checksum-changes.patch
genksyms-allow-to-ignore-symbol-checksum-changes.patch
git-unionfs.patch

