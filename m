Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4955622172E
	for <mm-commits@vger.kernel.org>; Thu, 17 Apr 2025 23:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744932156; cv=none; b=LoNIKrL+JGflx6Xd17PDki1DUrrFlngkCrwdapPBldGoXOLtmoBcayDqr/R+ct6sN0HbaiL42d1nBzSPURgR1vtnn9tzz9hrWrLhBnK1IvAC9CMG4VtY282wRBV4iOl6UZAQufKs46Z+mbj8uObpx4O0xP3BOyJXjGrfhsziWRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744932156; c=relaxed/simple;
	bh=tiB/ADpBYja/Q+ZP6ANNh+5yKZWSho9EciujLtw+MWE=;
	h=Date:To:From:Subject:Message-Id; b=f9Fg8YejZ2AzPJsX+O9+A4OTlZFnIzCIgOFQ7J5eka7cr8hP/Csk3VmXw5CvXQXrCUlSV9HrsMGEAlhqUin6Y0NXzIhYAGZwkjB1ocg7mWc4CdlfxFxjkW4JDLzEnaM46rWOOTntLe7SXjUhYHMAI6/uzAVscH6M0QKUpSlgVdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NesLWY9E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NesLWY9E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 947C7C4CEE4;
	Thu, 17 Apr 2025 23:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744932154;
	bh=tiB/ADpBYja/Q+ZP6ANNh+5yKZWSho9EciujLtw+MWE=;
	h=Date:To:From:Subject:From;
	b=NesLWY9EIOL7+P+hRwuvAA6Cfy09KaMuqgln/L330eeWA843Luf2Wlfsrx4cPjGaH
	 wS+rS6CbfJpCsSK14gSEnyTViJnnhWMRD9dIvSMBHE8iC0KH/F3ss4nJBB5wkJzGVX
	 4jpAxpuAegqsu2V0fzx1VyL3Lrr5gSUzMVLFQfao=
Date: Thu, 17 Apr 2025 16:22:34 -0700
To: mm-commits@vger.kernel.org,zokeefe@google.com,ziy@nvidia.com,yang@os.amperecomputing.com,willy@infradead.org,will@kernel.org,wangkefeng.wang@huawei.com,vishal.moola@gmail.com,usamaarif642@gmail.com,tiwai@suse.de,thomas.hellstrom@linux.intel.com,surenb@google.com,sunnanyong@huawei.com,shuah@kernel.org,ryan.roberts@arm.com,rostedt@goodmis.org,rientjes@google.com,rdunlap@infradead.org,raquini@redhat.com,peterx@redhat.com,mhocko@suse.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,kirill.shutemov@linux.intel.com,jack@suse.cz,hannes@cmpxchg.org,dev.jain@arm.com,david@redhat.com,corbet@lwn.net,cl@gentwo.org,catalin.marinas@arm.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,anshuman.khandual@arm.com,aarcange@redhat.com,npache@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-document-mthp-defer-usage.patch added to mm-new branch
Message-Id: <20250417232234.947C7C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: document (m)THP defer usage
has been added to the -mm mm-new branch.  Its filename is
     mm-document-mthp-defer-usage.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-document-mthp-defer-usage.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Nico Pache <npache@redhat.com>
Subject: mm: document (m)THP defer usage
Date: Wed, 16 Apr 2025 18:18:44 -0600

The new defer option for (m)THPs allows for a more conservative approach
to (m)THPs.  Document its usage in the transhuge admin-guide.

Link: https://lkml.kernel.org/r/20250417001846.81480-3-npache@redhat.com
Signed-off-by: Nico Pache <npache@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christoph Lameter (Ampere) <cl@gentwo.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Kirill A. Shuemov <kirill.shutemov@linux.intel.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rafael Aquini <raquini@redhat.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Reported-by:Takashi Iwai <tiwai@suse.de>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Thomas Hellstrom <thomas.hellstrom@linux.intel.com>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <yang@os.amperecomputing.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/transhuge.rst |   31 ++++++++++++++-----
 1 file changed, 23 insertions(+), 8 deletions(-)

--- a/Documentation/admin-guide/mm/transhuge.rst~mm-document-mthp-defer-usage
+++ a/Documentation/admin-guide/mm/transhuge.rst
@@ -88,8 +88,9 @@ In certain cases when hugepages are enab
 may end up allocating more memory resources. An application may mmap a
 large region but only touch 1 byte of it, in that case a 2M page might
 be allocated instead of a 4k page for no good. This is why it's
-possible to disable hugepages system-wide and to only have them inside
-MADV_HUGEPAGE madvise regions.
+possible to disable hugepages system-wide, only have them inside
+MADV_HUGEPAGE madvise regions, or defer them away from the page fault
+handler to khugepaged.
 
 Embedded systems should enable hugepages only inside madvise regions
 to eliminate any risk of wasting any precious byte of memory and to
@@ -99,6 +100,15 @@ Applications that gets a lot of benefit
 risk to lose memory by using hugepages, should use
 madvise(MADV_HUGEPAGE) on their critical mmapped regions.
 
+Applications that would like to benefit from THPs but would still like a
+more memory conservative approach can choose 'defer'. This avoids
+inserting THPs at the page fault handler unless they are MADV_HUGEPAGE.
+Khugepaged will then scan the mappings for potential collapses into (m)THP
+pages. Admins using this the 'defer' setting should consider
+tweaking khugepaged/max_ptes_none. The current default of 511 may
+aggressively collapse your PTEs into PMDs. Lower this value to conserve
+more memory (i.e., max_ptes_none=64).
+
 .. _thp_sysfs:
 
 sysfs
@@ -109,11 +119,14 @@ Global THP controls
 
 Transparent Hugepage Support for anonymous memory can be entirely disabled
 (mostly for debugging purposes) or only enabled inside MADV_HUGEPAGE
-regions (to avoid the risk of consuming more memory resources) or enabled
-system wide. This can be achieved per-supported-THP-size with one of::
+regions (to avoid the risk of consuming more memory resources), deferred to
+khugepaged, or enabled system wide.
+
+This can be achieved per-supported-THP-size with one of::
 
 	echo always >/sys/kernel/mm/transparent_hugepage/hugepages-<size>kB/enabled
 	echo madvise >/sys/kernel/mm/transparent_hugepage/hugepages-<size>kB/enabled
+	echo defer >/sys/kernel/mm/transparent_hugepage/hugepages-<size>kB/enabled
 	echo never >/sys/kernel/mm/transparent_hugepage/hugepages-<size>kB/enabled
 
 where <size> is the hugepage size being addressed, the available sizes
@@ -136,6 +149,7 @@ The top-level setting (for use with "inh
 one of the following commands::
 
 	echo always >/sys/kernel/mm/transparent_hugepage/enabled
+	echo defer >/sys/kernel/mm/transparent_hugepage/enabled
 	echo madvise >/sys/kernel/mm/transparent_hugepage/enabled
 	echo never >/sys/kernel/mm/transparent_hugepage/enabled
 
@@ -282,7 +296,8 @@ of small pages into one large page::
 A higher value leads to use additional memory for programs.
 A lower value leads to gain less thp performance. Value of
 max_ptes_none can waste cpu time very little, you can
-ignore it.
+ignore it. Consider lowering this value when using
+``transparent_hugepage=defer``
 
 ``max_ptes_swap`` specifies how many pages can be brought in from
 swap when collapsing a group of pages into a transparent huge page::
@@ -307,14 +322,14 @@ Boot parameters
 
 You can change the sysfs boot time default for the top-level "enabled"
 control by passing the parameter ``transparent_hugepage=always`` or
-``transparent_hugepage=madvise`` or ``transparent_hugepage=never`` to the
-kernel command line.
+``transparent_hugepage=madvise`` or ``transparent_hugepage=defer`` or
+``transparent_hugepage=never`` to the kernel command line.
 
 Alternatively, each supported anonymous THP size can be controlled by
 passing ``thp_anon=<size>[KMG],<size>[KMG]:<state>;<size>[KMG]-<size>[KMG]:<state>``,
 where ``<size>`` is the THP size (must be a power of 2 of PAGE_SIZE and
 supported anonymous THP)  and ``<state>`` is one of ``always``, ``madvise``,
-``never`` or ``inherit``.
+``defer``, ``never`` or ``inherit``.
 
 For example, the following will set 16K, 32K, 64K THP to ``always``,
 set 128K, 512K to ``inherit``, set 256K to ``madvise`` and 1M, 2M
_

Patches currently in -mm which might be from npache@redhat.com are

introduce-khugepaged_collapse_single_pmd-to-unify-khugepaged-and-madvise_collapse.patch
khugepaged-rename-hpage_collapse_-to-khugepaged_.patch
khugepaged-generalize-hugepage_vma_revalidate-for-mthp-support.patch
khugepaged-generalize-__collapse_huge_page_-for-mthp-support.patch
khugepaged-introduce-khugepaged_scan_bitmap-for-mthp-support.patch
khugepaged-add-mthp-support.patch
khugepaged-skip-collapsing-mthp-to-smaller-orders.patch
khugepaged-avoid-unnecessary-mthp-collapse-attempts.patch
khugepaged-improve-tracepoints-for-mthp-orders.patch
khugepaged-add-per-order-mthp-khugepaged-stats.patch
documentation-mm-update-the-admin-guide-for-mthp-collapse.patch
mm-defer-thp-insertion-to-khugepaged.patch
mm-document-mthp-defer-usage.patch
khugepaged-add-defer-option-to-mthp-options.patch
selftests-mm-add-defer-to-thp-setting-parser.patch

