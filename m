From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-warn-when-casting-constants-to-c90-int-or-longer-types.patch
 removed from -mm tree
Date: Thu, 21 Jan 2016 14:59:14 -0800
Message-ID: <56a162c2.n+zfYyD8TYTsgxxI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33867 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084AbcAUW7P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jan 2016 17:59:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: warn when casting constants to c90 int or longer types
has been removed from the -mm tree.  Its filename was
     checkpatch-warn-when-casting-constants-to-c90-int-or-longer-types.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: warn when casting constants to c90 int or longer types

Linus Torvalds wrote:

> I can't but help to react that this:
>  #define IOMMU_ERROR_CODE       (~(unsigned long) 0)
> Not that this *matters*, but it's a bit odd to have to cast constants
> to perfectly regular C types.

So add a test that looks for constants that are cast to
standard C90 int or longer types and suggest using C90
"6.4.4.1 Integer constants" integer-suffixes instead.

Miscellanea:

o Add a --fix option too

Signed-off-by: Joe Perches <joe@perches.com>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   42 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-warn-when-casting-constants-to-c90-int-or-longer-types scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-warn-when-casting-constants-to-c90-int-or-longer-types
+++ a/scripts/checkpatch.pl
@@ -433,6 +433,28 @@ our @typeList = (
 	qr{${Ident}_handler_fn},
 	@typeListMisordered,
 );
+
+our $C90_int_types = qr{(?x:
+	long\s+long\s+int\s+(?:un)?signed|
+	long\s+long\s+(?:un)?signed\s+int|
+	long\s+long\s+(?:un)?signed|
+	(?:(?:un)?signed\s+)?long\s+long\s+int|
+	(?:(?:un)?signed\s+)?long\s+long|
+	int\s+long\s+long\s+(?:un)?signed|
+	int\s+(?:(?:un)?signed\s+)?long\s+long|
+
+	long\s+int\s+(?:un)?signed|
+	long\s+(?:un)?signed\s+int|
+	long\s+(?:un)?signed|
+	(?:(?:un)?signed\s+)?long\s+int|
+	(?:(?:un)?signed\s+)?long|
+	int\s+long\s+(?:un)?signed|
+	int\s+(?:(?:un)?signed\s+)?long|
+
+	int\s+(?:un)?signed|
+	(?:(?:un)?signed\s+)?int
+)};
+
 our @typeListFile = ();
 our @typeListWithAttr = (
 	@typeList,
@@ -5272,6 +5294,26 @@ sub process {
 			}
 		}
 
+# check for cast of C90 native int or longer types constants
+		if ($line =~ /(\(\s*$C90_int_types\s*\)\s*)($Constant)\b/) {
+			my $cast = $1;
+			my $const = $2;
+			if (WARN("TYPECAST_INT_CONSTANT",
+				 "Unnecessary typecast of c90 int constant\n" . $herecurr) &&
+			    $fix) {
+				my $suffix = "";
+				my $newconst = $const;
+				$newconst =~ s/${Int_type}$//;
+				$suffix .= 'U' if ($cast =~ /\bunsigned\b/);
+				if ($cast =~ /\blong\s+long\b/) {
+					$suffix .= 'LL';
+				} elsif ($cast =~ /\blong\b/) {
+					$suffix .= 'L';
+				}
+				$fixed[$fixlinenr] =~ s/\Q$cast\E$const\b/$newconst$suffix/;
+			}
+		}
+
 # check for sizeof(&)
 		if ($line =~ /\bsizeof\s*\(\s*\&/) {
 			WARN("SIZEOF_ADDRESS",
_

Patches currently in -mm which might be from joe@perches.com are


