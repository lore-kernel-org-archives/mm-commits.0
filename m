From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-allow-certain-si-units-with-three-characters.patch removed from
 -mm tree
Date: Thu, 11 Dec 2014 11:05:37 -0800
Message-ID: <5489eb01.ZXvvLK3a84mVqB7O%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45688 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757031AbaLKTFi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 14:05:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jwerner@chromium.org, apw@canonical.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: allow certain SI units with three characters
has been removed from the -mm tree.  Its filename was
     checkpatch-allow-certain-si-units-with-three-characters.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

