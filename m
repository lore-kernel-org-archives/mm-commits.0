From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-net-and-drivers-net-warn-on-missing-blank-line-after-variable-declaration.patch removed from -mm tree
Date: Fri, 04 Apr 2014 12:34:24 -0700
Message-ID: <533f0940.52kgUsh5aNrWfX/w%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43379 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754306AbaDDTeZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:34:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, davem@davemloft.net, joe@perches.com

Subject: [merged] checkpatch-net-and-drivers-net-warn-on-missing-blank-line-after-variable-declaration.patch removed from -mm tree
To: joe@perches.com,davem@davemloft.net,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:34:24 -0700


The patch titled
     Subject: checkpatch: net and drivers/net: warn on missing blank line after variable declaration
has been removed from the -mm tree.  Its filename was
     checkpatch-net-and-drivers-net-warn-on-missing-blank-line-after-variable-declaration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: net and drivers/net: warn on missing blank line after variable declaration

Networking prefers this style, so warn when it's not used.

Networking uses:

void foo(int bar)
{
	int baz;

	code...
}

not

void foo(int bar)
{
	int baz;
	code...
}

There are a limited number of false positives when using
macros to declare variables like:

WARNING: networking uses a blank line after declarations
#330: FILE: net/ipv4/inet_hashtables.c:330:
+	int dif = sk->sk_bound_dev_if;
+	INET_ADDR_COOKIE(acookie, saddr, daddr)

Signed-off-by: Joe Perches <joe@perches.com>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-net-and-drivers-net-warn-on-missing-blank-line-after-variable-declaration scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-net-and-drivers-net-warn-on-missing-blank-line-after-variable-declaration
+++ a/scripts/checkpatch.pl
@@ -2257,6 +2257,21 @@ sub process {
 			     "networking block comments put the trailing */ on a separate line\n" . $herecurr);
 		}
 
+# check for missing blank lines after declarations
+		if ($realfile =~ m@^(drivers/net/|net/)@ &&
+		    $prevline =~ /^\+\s+$Declare\s+$Ident/ &&
+		    !($prevline =~ /(?:$Compare|$Assignment|$Operators)\s*$/ ||
+		      $prevline =~ /(?:\{\s*|\\)$/) &&		#extended lines
+		    $sline =~ /^\+\s+/ &&			#Not at char 1
+		    !($sline =~ /^\+\s+$Declare/ ||
+		      $sline =~ /^\+\s+$Ident\s+$Ident/ ||	#eg: typedef foo
+		      $sline =~ /^\+\s+(?:union|struct|enum|typedef)\b/ ||
+		      $sline =~ /^\+\s+(?:$|[\{\}\.\#\"\?\:\(])/ ||
+		      $sline =~ /^\+\s+\(?\s*(?:$Compare|$Assignment|$Operators)/)) {
+			WARN("SPACING",
+			     "networking uses a blank line after declarations\n" . $hereprev);
+		}
+
 # check for spaces at the beginning of a line.
 # Exceptions:
 #  1) within comments
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
ntfs-logging-clean-up.patch
mm-utilc-add-kstrimdup.patch
checkpatch-always-warn-on-missing-blank-line-after-variable-declaration-block.patch
checkpatch-reduce-false-positives-for-missing-blank-line-after-declarations-test.patch
checkpatch-reduce-false-positives-for-missing-blank-line-after-declarations-test-fix.patch
ncpfs-add-pr_fmt-and-convert-printks-to-pr_level.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix-fix.patch
ncpfs-convert-pprintk-to-ncp_vdbg.patch
ncpfs-remove-now-unused-printk-macro.patch
ncpfs-inode-fix-mismatch-printk-formats-and-arguments.patch
linux-next.patch

