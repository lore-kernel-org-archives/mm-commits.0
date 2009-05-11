From: akpm@linux-foundation.org
Subject: + scripts-headers_checkpl-correct-re-in-header-config-leak-check.patch added to -mm tree
Date: Mon, 11 May 2009 14:41:21 -0700
Message-ID: <200905112141.n4BLfMUL011029@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53390 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756460AbZEKVnq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 May 2009 17:43:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@crashcourse.ca, dwmw2@infradead.org, sam@ravnborg.org


The patch titled
     scripts/headers_check.pl: correct RE in header CONFIG leak check
has been added to the -mm tree.  Its filename is
     scripts-headers_checkpl-correct-re-in-header-config-leak-check.patch

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
Subject: scripts/headers_check.pl: correct RE in header CONFIG leak check
From: "Robert P. J. Day" <rpjday@crashcourse.ca>

Correct the regular expression in scripts/headers_check.pl to include '_'
as a valid character in the class; otherwise, the check will report a
"leaked" symbol of CONFIG_A_B_C as merely CONFIG_A.

This patch will make no difference whatsoever in the current kernel tree
as the call to the perl routine that does that check is currently
commented out:

                &check_include();
                &check_asm_types();
                &check_sizetypes();
                &check_prototypes();
                # Dropped for now. Too much noise &check_config();

However, I noticed that problem when I was building the yum downloadable
kernel source rpm for fedora 11 (beta), which *does* run that check, and
that's where the problem became obvious.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/headers_check.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/headers_check.pl~scripts-headers_checkpl-correct-re-in-header-config-leak-check scripts/headers_check.pl
--- a/scripts/headers_check.pl~scripts-headers_checkpl-correct-re-in-header-config-leak-check
+++ a/scripts/headers_check.pl
@@ -70,7 +70,7 @@ sub check_prototypes
 
 sub check_config
 {
-	if ($line =~ m/[^a-zA-Z0-9_]+CONFIG_([a-zA-Z0-9]+)[^a-zA-Z0-9]/) {
+	if ($line =~ m/[^a-zA-Z0-9_]+CONFIG_([a-zA-Z0-9_]+)[^a-zA-Z0-9_]/) {
 		printf STDERR "$filename:$lineno: leaks CONFIG_$1 to userspace where it is not valid\n";
 	}
 }
_

Patches currently in -mm which might be from rpjday@crashcourse.ca are

linux-next.patch
drm-simplify-kcalloc-call-to-kzalloc.patch
scripts-headers_checkpl-correct-re-in-header-config-leak-check.patch
kvm-expand-on-help-info-to-specify-kvm-intel-and-amd-module-names.patch
ramdisk-remove-long-deprecated-ramdisk=-boot-time-param.patch
kernel-kfifoc-replace-conditional-test-with-is_power_of_2.patch
ntfs-use-is_power_of_2-function-for-clarity.patch

