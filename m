From: akpm@linux-foundation.org
Subject: + shmem-fix-compilation-warnings-on-unused-functions.patch added
 to -mm tree
Date: Fri, 18 Nov 2016 16:06:03 -0800
Message-ID: <582f976b.Qs8JL9ag54VSemQb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44852 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752761AbcKSAGE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 18 Nov 2016 19:06:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy.lefaure@lse.epita.fr, hughd@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: shmem: fix compilation warnings on unused functions
has been added to the -mm tree.  Its filename is
     shmem-fix-compilation-warnings-on-unused-functions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/shmem-fix-compilation-warnings-on-unused-functions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/shmem-fix-compilation-warnings-on-unused-functions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-thp-propagation-of-conditional-compilation-in-khugepagedc.patch
shmem-fix-compilation-warnings-on-unused-functions.patch

