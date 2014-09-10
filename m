From: akpm@linux-foundation.org
Subject: +
 check-if-crashk_res_low-exists-when-exclude-it-from-crash-mem-ranges.patch
 added to -mm tree
Date: Wed, 10 Sep 2014 12:22:19 -0700
Message-ID: <5410a4eb.SUOUWBXlf3UYAa90%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57419 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030AbaIJTWU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Sep 2014 15:22:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bhe@redhat.com, ebiederm@xmission.com, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: check if crashk_res_low exists when exclude it from crash mem ranges
has been added to the -mm tree.  Its filename is
     check-if-crashk_res_low-exists-when-exclude-it-from-crash-mem-ranges.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/check-if-crashk_res_low-exists-when-exclude-it-from-crash-mem-ranges.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/check-if-crashk_res_low-exists-when-exclude-it-from-crash-mem-ranges.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: kexec: check if crashk_res_low exists when exclude it from crash mem ranges

Add a check if crashk_res_low exists just like GART region does.  If
crashk_res_low doesn't exist, calling exclude_mem_range is unnecessary.

Meanwhile, since crashk_res_low has been initialized at definition, it's
safe just use "if (crashk_low_res.end)" to check if it's exist.  And this
can make it consistent with other places of check.

Signed-off-by: Baoquan He <bhe@redhat.com>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/crash.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN arch/x86/kernel/crash.c~check-if-crashk_res_low-exists-when-exclude-it-from-crash-mem-ranges arch/x86/kernel/crash.c
--- a/arch/x86/kernel/crash.c~check-if-crashk_res_low-exists-when-exclude-it-from-crash-mem-ranges
+++ a/arch/x86/kernel/crash.c
@@ -237,7 +237,7 @@ static void fill_up_crash_elf_data(struc
 	ced->max_nr_ranges++;
 
 	/* If crashk_low_res is not 0, another range split possible */
-	if (crashk_low_res.end != 0)
+	if (crashk_low_res.end)
 		ced->max_nr_ranges++;
 }
 
@@ -335,9 +335,11 @@ static int elf_header_exclude_ranges(str
 	if (ret)
 		return ret;
 
-	ret = exclude_mem_range(cmem, crashk_low_res.start, crashk_low_res.end);
-	if (ret)
-		return ret;
+	if (crashk_low_res.end) {
+		ret = exclude_mem_range(cmem, crashk_low_res.start, crashk_low_res.end);
+		if (ret)
+			return ret;
+	}
 
 	/* Exclude GART region */
 	if (ced->gart_end) {
_

Patches currently in -mm which might be from bhe@redhat.com are

not-adding-modules-range-to-kcore-if-its-equal-to-vmcore-range.patch
not-adding-modules-range-to-kcore-if-its-equal-to-vmcore-range-checkpatch-fixes.patch
try-to-use-automatic-variable-in-kexec-purgatory-makefile.patch
take-the-segment-adding-out-of-locate_mem_hole-functions.patch
check-if-crashk_res_low-exists-when-exclude-it-from-crash-mem-ranges.patch
kexec-remove-the-unused-function-parameter.patch

