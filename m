From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-warn-on-macros-with-flow-control-statements.patch removed from
 -mm tree
Date: Tue, 14 Oct 2014 11:19:47 -0700
Message-ID: <543d6943.io0TxRTbFUT5bPLJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44168 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754241AbaJNSTp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 14:19:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: warn on macros with flow control statements
has been removed from the -mm tree.  Its filename was
     checkpatch-warn-on-macros-with-flow-control-statements.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: warn on macros with flow control statements

Macros with flow control statements (goto and return) are not very nice to
read as any flow movement is unexpected.

Try to highlight them and emit a warning on their definition.

Avoid warning on macros that use argument concatenation as those macros
commonly create another function where the concatenation is used in the
function name definition like:

	#define FOO_FUNC(name, rtn_type)	\
	rtn_type func##name(arg1, ...)		\
	{					\
		rtn_type rtn;			\
		[code...]			\
		return rtn;			\
	}

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-warn-on-macros-with-flow-control-statements scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-warn-on-macros-with-flow-control-statements
+++ a/scripts/checkpatch.pl
@@ -4066,12 +4066,17 @@ sub process {
 			my $cnt = $realcnt;
 			my ($off, $dstat, $dcond, $rest);
 			my $ctx = '';
+			my $has_flow_statement = 0;
+			my $has_arg_concat = 0;
 			($dstat, $dcond, $ln, $cnt, $off) =
 				ctx_statement_block($linenr, $realcnt, 0);
 			$ctx = $dstat;
 			#print "dstat<$dstat> dcond<$dcond> cnt<$cnt> off<$off>\n";
 			#print "LINE<$lines[$ln-1]> len<" . length($lines[$ln-1]) . "\n";
 
+			$has_flow_statement = 1 if ($ctx =~ /\b(goto|return)\b/);
+			$has_arg_concat = 1 if ($ctx =~ /\#\#/);
+
 			$dstat =~ s/^.\s*\#\s*define\s+$Ident(?:\([^\)]*\))?\s*//;
 			$dstat =~ s/$;//g;
 			$dstat =~ s/\\\n.//g;
@@ -4136,6 +4141,19 @@ sub process {
 				}
 			}
 
+# check for macros with flow control, but without ## concatenation
+# ## concatenation is commonly a macro that defines a function so ignore those
+			if ($has_flow_statement && !$has_arg_concat) {
+				my $herectx = $here . "\n";
+				my $cnt = statement_rawlines($ctx);
+
+				for (my $n = 0; $n < $cnt; $n++) {
+					$herectx .= raw_line($linenr, $n) . "\n";
+				}
+				WARN("MACRO_WITH_FLOW_CONTROL",
+				     "Macros with flow control statements should be avoided\n" . "$herectx");
+			}
+
 # check for line continuations outside of #defines, preprocessor #, and asm
 
 		} else {
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
mm-utilc-add-kstrimdup.patch
linux-next.patch

