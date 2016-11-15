From: akpm@linux-foundation.org
Subject: +
 mm-thp-propagation-of-conditional-compilation-in-khugepagedc.patch added to -mm tree
Date: Mon, 14 Nov 2016 16:18:08 -0800
Message-ID: <582a5440.+D2Ga6rTJnLHezMz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60222 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755153AbcKOASJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 14 Nov 2016 19:18:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy.lefaure@lse.epita.fr, kirill.shutemov@linux.intel.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, thp: propagation of conditional compilation in khugepaged.c
has been added to the -mm tree.  Its filename is
     mm-thp-propagation-of-conditional-compilation-in-khugepagedc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-thp-propagation-of-conditional-compilation-in-khugepagedc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-propagation-of-conditional-compilation-in-khugepagedc.patch

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
Subject: mm, thp: propagation of conditional compilation in khugepaged.c

Commit b46e756f5e47 ("thp: extract khugepaged from mm/huge_memory.c")
moved code from huge_memory.c to khugepaged.c. Some of this code should
be compiled only when CONFIG_SYSFS is enabled but the condition around
this code was not moved into khugepaged.c. The result is a compilation
error when CONFIG_SYSFS is disabled:

mm/built-in.o: In function `khugepaged_defrag_store':
khugepaged.c:(.text+0x2d095): undefined reference to
`single_hugepage_flag_store'
mm/built-in.o: In function `khugepaged_defrag_show':
khugepaged.c:(.text+0x2d0ab): undefined reference to
`single_hugepage_flag_show'

This commit adds the #ifdef CONFIG_SYSFS around the code related to
sysfs.

Link: http://lkml.kernel.org/r/20161114203448.24197-1-jeremy.lefaure@lse.epita.fr
Signed-off-by: Jérémy Lefaure <jeremy.lefaure@lse.epita.fr>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/khugepaged.c~mm-thp-propagation-of-conditional-compilation-in-khugepagedc mm/khugepaged.c
--- a/mm/khugepaged.c~mm-thp-propagation-of-conditional-compilation-in-khugepagedc
+++ a/mm/khugepaged.c
@@ -103,6 +103,7 @@ static struct khugepaged_scan khugepaged
 	.mm_head = LIST_HEAD_INIT(khugepaged_scan.mm_head),
 };
 
+#ifdef CONFIG_SYSFS
 static ssize_t scan_sleep_millisecs_show(struct kobject *kobj,
 					 struct kobj_attribute *attr,
 					 char *buf)
@@ -295,6 +296,7 @@ struct attribute_group khugepaged_attr_g
 	.attrs = khugepaged_attr,
 	.name = "khugepaged",
 };
+#endif /* CONFIG_SYSFS */
 
 #define VM_NO_KHUGEPAGED (VM_SPECIAL | VM_HUGETLB)
 
_

Patches currently in -mm which might be from jeremy.lefaure@lse.epita.fr are

mm-thp-propagation-of-conditional-compilation-in-khugepagedc.patch

