From: akpm@linux-foundation.org
Subject: + scripts-get_maintainerpl-add-pattern-depth.patch added to -mm tree
Date: Thu, 13 Aug 2009 14:49:10 -0700
Message-ID: <200908132149.n7DLnAxt012831@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58004 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752716AbZHMV7r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Aug 2009 17:59:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, davem@davemloft.net, horms@verge.net.au, ja@ssi.bg, kaber@trash.net, torvalds@linux-foundation.org, wensong@linux-vs.org


The patch titled
     scripts/get_maintainer.pl: add --pattern-depth
has been added to the -mm tree.  Its filename is
     scripts-get_maintainerpl-add-pattern-depth.patch

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
Subject: scripts/get_maintainer.pl: add --pattern-depth
From: Joe Perches <joe@perches.com>

--pattern-depth is used to control how many levels of directory traversal
should be performed to find maintainers.  default is 0 (all directory levels).

For instance:

MAINTAINERS currently has multiple M: and F: entries that match
net/netfilter/ipvs/ip_vs_app.c

IPVS
M:	Wensong Zhang <wensong@linux-vs.org>
M:	Simon Horman <horms@verge.net.au>
M:	Julian Anastasov <ja@ssi.bg>
[...]
F:	net/netfilter/ipvs/

NETFILTER/IPTABLES/IPCHAINS
[...]
M:	Patrick McHardy <kaber@trash.net>
[...]
F:	net/netfilter/

NETWORKING [GENERAL]
M:	"David S. Miller" <davem@davemloft.net>
[...]
F:	net/

THE REST
M:	Linus Torvalds <torvalds@linux-foundation.org>
[...]
F:	*/

Using this command will return all of those maintainers:
(except Linus unless --git-chief-maintainers is specified)

$ ./scripts/get_maintainer.pl --nogit -nol \
	-f net/netfilter/ipvs/ip_vs_app.c
Julian Anastasov <ja@ssi.bg>
Simon Horman <horms@verge.net.au>
Wensong Zhang <wensong@linux-vs.org>
Patrick McHardy <kaber@trash.net>
David S. Miller <davem@davemloft.net>

Adding --pattern-depth=1 will match at the deepest level
$ ./scripts/get_maintainer.pl --nogit -nol --pattern-depth=1 \
	-f net/netfilter/ipvs/ip_vs_app.c
Julian Anastasov <ja@ssi.bg>
Simon Horman <horms@verge.net.au>
Wensong Zhang <wensong@linux-vs.org>

Adding --pattern-depth=2 will match at the deepest level and 1 higher
$ ./scripts/get_maintainer.pl --nogit -nol --pattern-depth=2 \
	-f net/netfilter/ipvs/ip_vs_app.c
Julian Anastasov <ja@ssi.bg>
Simon Horman <horms@verge.net.au>
Wensong Zhang <wensong@linux-vs.org>
Patrick McHardy <kaber@trash.net>

and so on.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |   21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff -puN scripts/get_maintainer.pl~scripts-get_maintainerpl-add-pattern-depth scripts/get_maintainer.pl
--- a/scripts/get_maintainer.pl~scripts-get_maintainerpl-add-pattern-depth
+++ a/scripts/get_maintainer.pl
@@ -13,7 +13,7 @@
 use strict;
 
 my $P = $0;
-my $V = '0.18beta2';
+my $V = '0.19';
 
 use Getopt::Long qw(:config no_auto_abbrev);
 
@@ -37,6 +37,7 @@ my $web = 0;
 my $subsystem = 0;
 my $status = 0;
 my $from_filename = 0;
+my $pattern_depth = 0;
 my $version = 0;
 my $help = 0;
 
@@ -80,6 +81,7 @@ if (!GetOptions(
 		'status!' => \$status,
 		'scm!' => \$scm,
 		'web!' => \$web,
+		'pattern-depth=i' => \$pattern_depth,
 		'f|file' => \$from_filename,
 		'v|version' => \$version,
 		'h|help' => \$help,
@@ -226,9 +228,13 @@ foreach my $file (@files) {
 		my $value = $2;
 		if ($type eq 'F') {
 		    if (file_match_pattern($file, $value)) {
-			my $pattern_depth = ($value =~ tr@/@@);
-			$pattern_depth++ if (!(substr($value,-1,1) eq "/"));
-			$hash{$tvi} = $pattern_depth;
+			my $value_pd = ($value =~ tr@/@@);
+			my $file_pd = ($file  =~ tr@/@@);
+			$value_pd++ if (substr($value,-1,1) ne "/");
+			if ($pattern_depth == 0 ||
+			    (($file_pd - $value_pd) < $pattern_depth)) {
+			    $hash{$tvi} = $value_pd;
+			}
 		    }
 		}
 	    }
@@ -345,13 +351,14 @@ Output type options:
   --separator [, ] => separator for multiple entries on 1 line
   --multiline => print 1 entry per line
 
-Default options:
-  [--email --git --m --n --l --multiline]
-
 Other options:
+  --pattern-depth => Number of pattern directory traversals (default: 0 (all))
   --version => show version
   --help => show this help information
 
+Default options:
+  [--email --git --m --n --l --multiline --pattern-depth=0]
+
 Notes:
   Using "-f directory" may give unexpected results:
       Used with "--git", git signators for _all_ files in and below
_

Patches currently in -mm which might be from joe@perches.com are

maintainers-osd-library-and-filesystem-pattern-fix.patch
linux-next.patch
maintainers-add-ipvs-include-files.patch
scripts-get_maintainerpl-add-git-blame.patch
scripts-get_maintainerpl-add-sections-in-pattern-match-depth-order.patch
scripts-get_maintainerpl-add-pattern-depth.patch
scripts-get_maintainerpl-better-email-routines-use-perl-not-shell-where-possible.patch
scripts-get_maintainerpl-add-mailmap-use-shell-and-email-cleanups.patch
scripts-get_maintainerpl-using-separator-implies-nomultiline.patch
scripts-get_maintainerpl-add-remove-duplicates.patch
mmc-msm_sdccc-driver-for-htc-dream.patch
msm_sdccc-convert-printkkern_level-to-pr_level.patch
msm_sdccc-stylistic-cleaning.patch
msm_sdccc-move-overly-indented-code-to-separate-function.patch
maintainers-add-matt-mackall-and-herbert-xu-to-hardware-random-number-generator.patch

