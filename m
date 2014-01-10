From: akpm@linux-foundation.org
Subject: + checkpatch-add-dt-compatible-string-documentation-checks.patch
 added to -mm tree
Date: Fri, 10 Jan 2014 15:05:49 -0800
Message-ID: <52d07ccd./fiuAdOBlUutqqjC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33451 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642AbaAJXFu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 10 Jan 2014 18:05:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com, grant.likely@linaro.org, apw@canonical.com, robh@kernel.org

Subject: + checkpatch-add-dt-compatible-string-documentation-checks.patch added to -mm tree
To: robh@kernel.org,apw@canonical.com,grant.likely@linaro.org,joe@perches.com
From: akpm@linux-foundation.org
Date: Fri, 10 Jan 2014 15:05:49 -0800


The patch titled
     Subject: checkpatch: add DT compatible string documentation checks
has been added to the -mm tree.  Its filename is
     checkpatch-add-dt-compatible-string-documentation-checks.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-add-dt-compatible-string-documentation-checks.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-add-dt-compatible-string-documentation-checks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rob Herring <robh@kernel.org>
Subject: checkpatch: add DT compatible string documentation checks

This adds a simple check that any compatible strings in DeviceTree dts
files are present in Documentation/devicetree/bindings.  Vendor prefixes
are also checked for existing in vendor-prefixes.txt These should be
temporary checks until we have more sophisticated binding schema checking.

Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Joe Perches <joe@perches.com>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-add-dt-compatible-string-documentation-checks scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-dt-compatible-string-documentation-checks
+++ a/scripts/checkpatch.pl
@@ -2040,6 +2040,33 @@ sub process {
 			     "Use of $flag is deprecated, please use \`$replacement->{$flag} instead.\n" . $herecurr) if ($replacement->{$flag});
 		}
 
+# check for DT compatible documentation
+		if (defined $root && $realfile =~ /\.dts/ &&
+		    $rawline =~ /^\+\s*compatible\s*=/) {
+			my @compats = $rawline =~ /\"([a-zA-Z0-9\-\,\.\+_]+)\"/g;
+
+			foreach my $compat (@compats) {
+				my $compat2 = $compat;
+				my $dt_path =  $root . "/Documentation/devicetree/bindings/";
+				$compat2 =~ s/\,[a-z]*\-/\,<\.\*>\-/;
+				`grep -Erq "$compat|$compat2" $dt_path`;
+				if ( $? >> 8 ) {
+					WARN("UNDOCUMENTED_DT_STRING",
+					     "DT compatible string \"$compat\" appears un-documented -- check $dt_path\n" . $herecurr);
+				}
+
+				my $vendor = $compat;
+				my $vendor_path = $dt_path . "vendor-prefixes.txt";
+				next if (! -f $vendor_path);
+				$vendor =~ s/^([a-zA-Z0-9]+)\,.*/$1/;
+				`grep -Eq "$vendor" $vendor_path`;
+				if ( $? >> 8 ) {
+					WARN("UNDOCUMENTED_DT_STRING",
+					     "DT compatible string vendor \"$vendor\" appears un-documented -- check $vendor_path\n" . $herecurr);
+				}
+			}
+		}
+
 # check we are in a valid source file if not then ignore this hunk
 		next if ($realfile !~ /\.(h|c|s|S|pl|sh)$/);
 
_

Patches currently in -mm which might be from robh@kernel.org are

checkpatch-add-dt-compatible-string-documentation-checks.patch

