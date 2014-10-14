From: akpm@linux-foundation.org
Subject: [merged]
 check-if-crashk_res_low-exists-when-exclude-it-from-crash-mem-ranges.patch
 removed from -mm tree
Date: Tue, 14 Oct 2014 11:21:22 -0700
Message-ID: <543d69a2.8uDX2pZTbzO8k5/m%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44407 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755447AbaJNSVV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 14:21:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bhe@redhat.com, ebiederm@xmission.com, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: check if crashk_res_low exists when exclude it from crash mem ranges
has been removed from the -mm tree.  Its filename was
     check-if-crashk_res_low-exists-when-exclude-it-from-crash-mem-ranges.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

