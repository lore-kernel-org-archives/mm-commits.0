From: akpm@linux-foundation.org
Subject: [merged] scripts-headers_checkpl-correct-re-in-header-config-leak-check.patch removed from -mm tree
Date: Wed, 10 Jun 2009 10:44:12 -0700
Message-ID: <200906101744.n5AHiCwc030938@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41023 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750948AbZFJRpL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Jun 2009 13:45:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@crashcourse.ca, dwmw2@infradead.org, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     scripts/headers_check.pl: correct RE in header CONFIG leak check
has been removed from the -mm tree.  Its filename was
     scripts-headers_checkpl-correct-re-in-header-config-leak-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
ramdisk-remove-long-deprecated-ramdisk=-boot-time-param.patch
kernel-kfifoc-replace-conditional-test-with-is_power_of_2.patch
ntfs-use-is_power_of_2-function-for-clarity.patch

