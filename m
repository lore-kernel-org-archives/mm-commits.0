From: akpm@linux-foundation.org
Subject: + ata-fix-sparse-warning-in-libatah.patch added to -mm tree
Date: Fri, 15 Feb 2008 13:57:19 -0800
Message-ID: <200802152157.m1FLvJcl025943@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36204 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755338AbYBOV5X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 16:57:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com


The patch titled
     ata: fix sparse warning in libata.h
has been added to the -mm tree.  Its filename is
     ata-fix-sparse-warning-in-libatah.patch

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
Subject: ata: fix sparse warning in libata.h
From: Harvey Harrison <harvey.harrison@gmail.com>

Avoids lots of these, also is more readable.
include/linux/libata.h:1210:13: warning: potentially expensive pointer subtraction

Change the subtraction to addition on the other side of the comparison.

Thanks to Christer Weinigel for the suggestion.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/libata.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/libata.h~ata-fix-sparse-warning-in-libatah include/linux/libata.h
--- a/include/linux/libata.h~ata-fix-sparse-warning-in-libatah
+++ a/include/linux/libata.h
@@ -1207,7 +1207,7 @@ static inline struct ata_link *ata_port_
 		return ap->pmp_link;
 	}
 
-	if (++link - ap->pmp_link < ap->nr_pmp_links)
+	if (++link < ap->nr_pmp_links + ap->pmp_link)
 		return link;
 	return NULL;
 }
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
dlm-match-signedness-between-dlm_config_info-and-cluster_set.patch
ata-fix-sparse-warning-in-libatah.patch
ubi-fix-sparse-errors-in-ubih.patch
x86-remove-pt_regs-arg-from-smp_thermal_interrupt.patch
remove-sparse-warning-for-mmzoneh.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
adfs-work-around-bogus-sparse-warning.patch
debugfs-fix-sparse-warnings.patch
coda-add-static-to-functions-in-dirc.patch
befs-fix-sparse-warning-in-linuxvfsc.patch
ncpfs-add-prototypes-to-ncp_fsh.patch
ncpfs-fix-sparse-warnings-in-ioctlc.patch
ncpfs-fix-sparse-warning-in-ncpsign_kernelc.patch
jbd-sparse-warnings-in-revokec-journalc.patch
jbd2-sparse-warnings-in-revokec-journalc.patch
