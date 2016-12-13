From: akpm@linux-foundation.org
Subject: [patch 085/123] mm: make transparent hugepage size public
Date: Mon, 12 Dec 2016 16:44:50 -0800
Message-ID: <584f4482.PHsakx32gsTQjJct%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41658 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932380AbcLMAow (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2016 19:44:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, hughd@google.com, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, dan.j.williams@intel.com, dave.hansen@intel.com, gthelen@google.com, jack@suse.cz, kirill.shutemov@linux.intel.com, mhocko@suse.com, rientjes@google.com, vbabka@suse.cz

From: Hugh Dickins <hughd@google.com>
Subject: mm: make transparent hugepage size public

Test programs want to know the size of a transparent hugepage.  While it
is commonly the same as the size of a hugetlbfs page (shown as
Hugepagesize in /proc/meminfo), that is not always so: powerpc implements
transparent hugepages in a different way from hugetlbfs pages, so it's
coincidence when their sizes are the same; and x86 and others can support
more than one hugetlbfs page size.

Add /sys/kernel/mm/transparent_hugepage/hpage_pmd_size to show the THP
size in bytes - it's the same for Anonymous and Shmem hugepages.  Call it
hpage_pmd_size (after HPAGE_PMD_SIZE) rather than hpage_size, in case some
transparent support for pud and pgd pages is added later.

Link: http://lkml.kernel.org/r/alpine.LSU.2.11.1612052200290.13021@eggly.anvils
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Greg Thelen <gthelen@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/transhuge.txt |    5 +++++
 mm/huge_memory.c               |   10 ++++++++++
 2 files changed, 15 insertions(+)

diff -puN Documentation/vm/transhuge.txt~mm-make-transparent-hugepage-size-public Documentation/vm/transhuge.txt
--- a/Documentation/vm/transhuge.txt~mm-make-transparent-hugepage-size-public
+++ a/Documentation/vm/transhuge.txt
@@ -136,6 +136,11 @@ or enable it back by writing 1:
 echo 0 >/sys/kernel/mm/transparent_hugepage/use_zero_page
 echo 1 >/sys/kernel/mm/transparent_hugepage/use_zero_page
 
+Some userspace (such as a test program, or an optimized memory allocation
+library) may want to know the size (in bytes) of a transparent hugepage:
+
+cat /sys/kernel/mm/transparent_hugepage/hpage_pmd_size
+
 khugepaged will be automatically started when
 transparent_hugepage/enabled is set to "always" or "madvise, and it'll
 be automatically shutdown if it's set to "never".
diff -puN mm/huge_memory.c~mm-make-transparent-hugepage-size-public mm/huge_memory.c
--- a/mm/huge_memory.c~mm-make-transparent-hugepage-size-public
+++ a/mm/huge_memory.c
@@ -285,6 +285,15 @@ static ssize_t use_zero_page_store(struc
 }
 static struct kobj_attribute use_zero_page_attr =
 	__ATTR(use_zero_page, 0644, use_zero_page_show, use_zero_page_store);
+
+static ssize_t hpage_pmd_size_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	return sprintf(buf, "%lu\n", HPAGE_PMD_SIZE);
+}
+static struct kobj_attribute hpage_pmd_size_attr =
+	__ATTR_RO(hpage_pmd_size);
+
 #ifdef CONFIG_DEBUG_VM
 static ssize_t debug_cow_show(struct kobject *kobj,
 				struct kobj_attribute *attr, char *buf)
@@ -307,6 +316,7 @@ static struct attribute *hugepage_attr[]
 	&enabled_attr.attr,
 	&defrag_attr.attr,
 	&use_zero_page_attr.attr,
+	&hpage_pmd_size_attr.attr,
 #if defined(CONFIG_SHMEM) && defined(CONFIG_TRANSPARENT_HUGE_PAGECACHE)
 	&shmem_enabled_attr.attr,
 #endif
_
