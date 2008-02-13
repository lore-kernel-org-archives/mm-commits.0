From: akpm@linux-foundation.org
Subject: + timeconstpl-correct-reversal-of-usec_to_hz-and-hz_to_usec.patch added to -mm tree
Date: Wed, 13 Feb 2008 01:04:03 -0800
Message-ID: <200802130905.m1D95PIc017603@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55891 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932347AbYBMJGj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Feb 2008 04:06:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hpa@zytor.com, crmafra@ift.unesp.br


The patch titled
     timeconst.pl: correct reversal of USEC_TO_HZ and HZ_TO_USEC
has been added to the -mm tree.  Its filename is
     timeconstpl-correct-reversal-of-usec_to_hz-and-hz_to_usec.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: timeconst.pl: correct reversal of USEC_TO_HZ and HZ_TO_USEC
From: "H. Peter Anvin" <hpa@zytor.com>

The USEC_TO_HZ and HZ_TO_USEC constant sets were mislabelled, with
seriously incorrect results.  This among other things manifested itself as
cpufreq not working when a tickless kernel was configured.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Tested-by: Carlos R. Mafra <crmafra@ift.unesp.br>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/timeconst.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/timeconst.pl~timeconstpl-correct-reversal-of-usec_to_hz-and-hz_to_usec kernel/timeconst.pl
--- a/kernel/timeconst.pl~timeconstpl-correct-reversal-of-usec_to_hz-and-hz_to_usec
+++ a/kernel/timeconst.pl
@@ -339,7 +339,7 @@ sub output($@)
 	print "\n";
 
 	foreach $pfx ('HZ_TO_MSEC','MSEC_TO_HZ',
-		      'USEC_TO_HZ','HZ_TO_USEC') {
+		      'HZ_TO_USEC','USEC_TO_HZ') {
 		foreach $bit (32, 64) {
 			foreach $suf ('MUL', 'ADJ', 'SHR') {
 				printf "#define %-23s %s\n",
_

Patches currently in -mm which might be from hpa@zytor.com are

origin.patch
elf-loader-crash-while-zero-filling-bss.patch
timeconstpl-correct-reversal-of-usec_to_hz-and-hz_to_usec.patch
git-kvm.patch
git-x86.patch
x86_64-set-cfg_size-for-amd-family-10h-in-case-mmconfig-is-used.patch
x86-configurable-dmi-scanning-code.patch
