From: akpm@linux-foundation.org
Subject: + checkpatch-allow-certain-si-units-with-three-characters.patch
 added to -mm tree
Date: Mon, 10 Nov 2014 15:23:08 -0800
Message-ID: <546148dc.zPL8nTrTlwJYSLgg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45000 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474AbaKJXXH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 10 Nov 2014 18:23:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jwerner@chromium.org, apw@canonical.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: allow certain SI units with three characters
has been added to the -mm tree.  Its filename is
     checkpatch-allow-certain-si-units-with-three-characters.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-allow-certain-si-units-with-three-characters.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-allow-certain-si-units-with-three-characters.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Julius Werner <jwerner@chromium.org>
Subject: checkpatch: allow certain SI units with three characters

Checkpatch flags CamelCase identifiers in strict mode, but it has a
feature to ignore parts with only two characters to allow for SI units
like mV or uA.  Unfortunately, not all SI units fit in two characters, and
not all are lower case followed by upper case.

This patch adds hardcoded detection for frequency and 1024-based size
units (Hz/KHz/MHz/GHz/THz and KiB/MiB/GiB/TiB), since allowing any three
character combinations might be too lenient.  The list can later be
expanded as needed.

Signed-off-by: Julius Werner <jwerner@chromium.org>
Acked-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-allow-certain-si-units-with-three-characters scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-allow-certain-si-units-with-three-characters
+++ a/scripts/checkpatch.pl
@@ -4104,7 +4104,9 @@ sub process {
 #Ignore Page<foo> variants
 			    $var !~ /^(?:Clear|Set|TestClear|TestSet|)Page[A-Z]/ &&
 #Ignore SI style variants like nS, mV and dB (ie: max_uV, regulator_min_uA_show)
-			    $var !~ /^(?:[a-z_]*?)_?[a-z][A-Z](?:_[a-z_]+)?$/) {
+			    $var !~ /^(?:[a-z_]*?)_?[a-z][A-Z](?:_[a-z_]+)?$/ &&
+#Ignore some three character SI units explicitly, like MiB and KHz
+			    $var !~ /^(?:[a-z_]*?)_?(?:[KMGT]iB|[KMGT]?Hz)(?:_[a-z_]+)?$/) {
 				while ($var =~ m{($Ident)}g) {
 					my $word = $1;
 					next if ($word !~ /[A-Z][a-z]|[a-z][A-Z]/);
_

Patches currently in -mm which might be from jwerner@chromium.org are

checkpatch-allow-certain-si-units-with-three-characters.patch

