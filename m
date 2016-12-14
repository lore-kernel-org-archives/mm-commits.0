From: akpm@linux-foundation.org
Subject: [merged] shmem-fix-compilation-warnings-on-unused-functions.patch removed from -mm tree
Date: Wed, 14 Dec 2016 11:25:10 -0800
Message-ID: <58519c96.RQQX8kfYRB/ql7kC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44420 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752210AbcLNTZL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 14:25:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy.lefaure@lse.epita.fr, hughd@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: shmem: fix compilation warnings on unused functions
has been removed from the -mm tree.  Its filename was
     shmem-fix-compilation-warnings-on-unused-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jérémy Lefaure <jeremy.lefaure@lse.epita.fr>
Subject: shmem: fix compilation warnings on unused functions

Compiling shmem.c with CONFIG_SHMEM and CONFIG_TRANSAPRENT_HUGE_PAGECACHE
enabled raises warnings on two unused functions when CONFIG_TMPFS and
CONFIG_SYSFS are both disabled:

mm/shmem.c:390:20: warning: `shmem_format_huge' defined but not used
[-Wunused-function]
 static const char *shmem_format_huge(int huge)
                    ^~~~~~~~~~~~~~~~~
mm/shmem.c:373:12: warning: `shmem_parse_huge' defined but not used
[-Wunused-function]
 static int shmem_parse_huge(const char *str)
             ^~~~~~~~~~~~~~~~

A conditional compilation on tmpfs or sysfs removes the warnings.

Link: http://lkml.kernel.org/r/20161118055749.11313-1-jeremy.lefaure@lse.epita.fr
Signed-off-by: Jérémy Lefaure <jeremy.lefaure@lse.epita.fr>
Acked-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/shmem.c~shmem-fix-compilation-warnings-on-unused-functions mm/shmem.c
--- a/mm/shmem.c~shmem-fix-compilation-warnings-on-unused-functions
+++ a/mm/shmem.c
@@ -370,6 +370,7 @@ static bool shmem_confirm_swap(struct ad
 
 int shmem_huge __read_mostly;
 
+#if defined(CONFIG_SYSFS) || defined(CONFIG_TMPFS)
 static int shmem_parse_huge(const char *str)
 {
 	if (!strcmp(str, "never"))
@@ -407,6 +408,7 @@ static const char *shmem_format_huge(int
 		return "bad_val";
 	}
 }
+#endif
 
 static unsigned long shmem_unused_huge_shrink(struct shmem_sb_info *sbinfo,
 		struct shrink_control *sc, unsigned long nr_to_split)
_

Patches currently in -mm which might be from jeremy.lefaure@lse.epita.fr are


