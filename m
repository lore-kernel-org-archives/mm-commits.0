From: akpm@linux-foundation.org
Subject: + tags-fix-config-symbols-generation.patch added to -mm tree
Date: Fri, 30 Jan 2009 12:22:25 -0800
Message-ID: <200901302022.n0UKMPtN014715@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53249 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754069AbZA3UWc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Jan 2009 15:22:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, sam@ravnborg.org


The patch titled
     tags: fix config symbols generation
has been added to the -mm tree.  Its filename is
     tags-fix-config-symbols-generation.patch

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
Subject: tags: fix config symbols generation
From: Alexey Dobriyan <adobriyan@gmail.com>

commit 4f628248a578585472e19e4cba2c604643af8c6c aka "kbuild: reintroduce
ALLSOURCE_ARCHS support for tags/cscope" breaks tags generation for
Kconfig symbols.

Steps to reproduce:

	make tags
	vi -t PROC_FS

It should jump to 'config PROC_FS' line.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/tags.sh |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN scripts/tags.sh~tags-fix-config-symbols-generation scripts/tags.sh
--- a/scripts/tags.sh~tags-fix-config-symbols-generation
+++ a/scripts/tags.sh
@@ -76,7 +76,10 @@ all_sources()
 
 all_kconfigs()
 {
-	find_sources $ALLSOURCE_ARCHS 'Kconfig*'
+	for arch in $ALLSOURCE_ARCHS; do
+		find_sources $arch 'Kconfig*'
+	done
+	find_other_sources 'Kconfig*'
 }
 
 all_defconfigs()
_

Patches currently in -mm which might be from adobriyan@gmail.com are

seq_file-move-traverse-so-it-can-be-used-from-seq_read.patch
seq_file-properly-cope-with-pread.patch
linux-next.patch
eeepc-should-depend-on-input.patch
tags-fix-config-symbols-generation.patch
sm501-fix-section-mismatches.patch
mpt-remove-unused-struct-mpt_proc_entry_t.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-export-statistics-for-softirq-to-proc-fix.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch

